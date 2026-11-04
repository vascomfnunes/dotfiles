import { spawnSync } from "node:child_process"

// Publish OpenCode session activity to the tmux window marker.

const AGENT = "opencode"

const STARTED = "session.execution.started"
const COMPLETED = new Set([
  "session.execution.succeeded",
  "session.execution.failed",
  "session.execution.interrupted",
])

// Older servers expose session.status/session.idle; current servers emit
// session.execution.* events. Handle both so the plugin survives either shape.
const STATUS_EVENTS = new Set(["session.status", "session.idle"])
const HANDLED = new Set([STARTED, ...COMPLETED, ...STATUS_EVENTS])

function runHelper(args) {
  const script =
    process.env.AGENT_STATUS_BIN || `${process.env.HOME}/.local/bin/agent-status`

  try {
    // Run synchronously so begin/done callbacks land in event order. Each
    // helper invocation is short (a few tmux option updates).
    spawnSync(script, args, {
      stdio: "ignore",
      env: process.env,
      timeout: 5000,
    })
  } catch {
    // Status reporting is best-effort and must never break a session.
  }
}

export default {
  id: "agent-status",
  setup(ctx) {
    const controller = new AbortController()
    const busy = new Set()
    const roots = new Map()

    // Child sessions finish constantly inside a single turn. Only the root
    // session should drive the window marker.
    function isRoot(sessionID) {
      let cached = roots.get(sessionID)
      if (!cached) {
        cached = Promise.resolve()
          .then(() => ctx.session.get({ sessionID }))
          .then((session) => !session?.parentID)
          .catch(() => true)
        roots.set(sessionID, cached)
      }
      return cached
    }

    function mark(state, directory) {
      runHelper([state, "--agent", AGENT, "--path", directory])
    }

    function finish(sessionID, directory) {
      busy.delete(sessionID)
      roots.delete(sessionID)
      mark("done", directory)
    }

    async function handle(event) {
      if (!HANDLED.has(event.type)) {
        return
      }

      const sessionID = event.data?.sessionID
      if (!sessionID || !(await isRoot(sessionID))) {
        return
      }

      const directory = event.location?.directory ?? ctx.location.directory

      if (event.type === STARTED) {
        if (!busy.has(sessionID)) {
          busy.add(sessionID)
          mark("begin", directory)
        }
        return
      }

      if (COMPLETED.has(event.type)) {
        if (busy.has(sessionID)) {
          finish(sessionID, directory)
        }
        return
      }

      // Legacy session.status/session.idle events.
      if (event.type === "session.status") {
        const status = event.data.status?.type
        if (status === "busy" || status === "retry") {
          if (!busy.has(sessionID)) {
            busy.add(sessionID)
            mark("begin", directory)
          }
        } else if (status === "idle" && busy.has(sessionID)) {
          finish(sessionID, directory)
        }
        return
      }

      if (event.type === "session.idle" && busy.has(sessionID)) {
        finish(sessionID, directory)
      }
    }

    void (async () => {
      try {
        for await (const event of ctx.event.subscribe({
          types: [...HANDLED],
          signal: controller.signal,
        })) {
          await handle(event)
        }
      } catch (error) {
        if (!controller.signal.aborted) {
          console.error("agent-status plugin:", error)
        }
      }
    })()

    return () => controller.abort()
  },
}
