#!/bin/sh

set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
test_tmp=$(mktemp -d)
trap 'rm -rf "$test_tmp"' EXIT HUP INT TERM
mkdir -p "$test_tmp/bin" "$test_tmp/home/.agents/skills/caveman"
printf 'keep\n' > "$test_tmp/home/.agents/skills/caveman/SKILL.md"
cat > "$test_tmp/bin/curl" <<'EOF'
#!/bin/sh
# curl -fsSL URL -o FILE
case "$2" in
  https://api.skills-hub.ai/api/v1/skills/refactor)
    cat > "$4" <<'JSON'
{"name":"refactor","description":"Test refactor skill.","category":{"slug":"review"}}
JSON
    ;;
  https://api.skills-hub.ai/api/v1/skills/refactor/versions/1.0.0)
    cat > "$4" <<'JSON'
{"version":"1.0.0","instructions":"Test refactor instructions."}
JSON
    ;;
esac
exit 0
EOF
cat > "$test_tmp/bin/tar" <<'EOF'
#!/bin/sh
dest=$4
case "$dest" in
  */caveman)
    for name in caveman caveman-compress caveman-help caveman-review caveman-stats cavecrew; do
      mkdir -p "$dest/skills/$name"
      printf 'test\n' > "$dest/skills/$name/SKILL.md"
    done
    ;;
  */vercel)
    mkdir -p "$dest/skills/web-design-guidelines"
    printf 'test\n' > "$dest/skills/web-design-guidelines/SKILL.md"
    ;;
  */find-skills) paths='skills/find-skills' ;;
  */apple-design)
    paths='.'
    mkdir -p "$dest/references"
    printf 'reference\n' > "$dest/references/example.md"
    ;;
  */superpowers) paths='skills/systematic-debugging skills/writing-plans skills/executing-plans skills/requesting-code-review skills/receiving-code-review' ;;
  */issue) paths='dist/codex/plugins/use-git/skills/create-issue' ;;
  */rea) paths='.agents/skills/reverse-engineer-anything' ;;
  */agent-scripts) paths='skills/project-structure skills/instruments-profiling skills/swiftui-performance-audit' ;;
  */swiftui) paths='swiftui-pro' ;;
  */swift-concurrency) paths='swift-concurrency-pro' ;;
  */swift-testing) paths='swift-testing-pro' ;;
esac
for path in ${paths:-}; do
  mkdir -p "$dest/$path"
  printf 'test\n' > "$dest/$path/SKILL.md"
done
EOF
chmod +x "$test_tmp/bin/curl" "$test_tmp/bin/tar"
# Rewrite the pinned hash so the stub payload verifies like the real one.
hub_hash=$(printf '%s' 'Test refactor instructions.' | shasum -a 256 | awk '{print $1}')
sed "s/^refactor_hash=.*/refactor_hash=$hub_hash/" "$root/agents/install-skills.sh" > "$test_tmp/install-skills.sh"
sed 's/^refactor_hash=.*/refactor_hash=0000000000000000000000000000000000000000000000000000000000000000/' \
  "$root/agents/install-skills.sh" > "$test_tmp/install-skills-bad.sh"
HOME="$test_tmp/home" PATH="$test_tmp/bin:$PATH" sh "$test_tmp/install-skills.sh"
HOME="$test_tmp/home" PATH="$test_tmp/bin:$PATH" sh "$test_tmp/install-skills.sh"
mkdir -p "$test_tmp/bad"
if HOME="$test_tmp/bad" PATH="$test_tmp/bin:$PATH" sh "$test_tmp/install-skills-bad.sh" 2>/dev/null; then
  echo "Checksum mismatch was not rejected." >&2
  exit 1
fi
test ! -e "$test_tmp/bad/.agents/skills/refactor/SKILL.md"
test "$(cat "$test_tmp/home/.agents/skills/caveman/SKILL.md")" = keep
test -f "$test_tmp/home/.agents/skills/caveman-review/SKILL.md"
test ! -e "$test_tmp/home/.agents/skills/caveman-commit"
test -f "$test_tmp/home/.agents/skills/web-design-guidelines/SKILL.md"
test -f "$test_tmp/home/.agents/skills/apple-design/references/example.md"
test -f "$test_tmp/home/.agents/skills/refactor/SKILL.md"
grep -F 'name: "refactor"' "$test_tmp/home/.agents/skills/refactor/SKILL.md" >/dev/null
grep -F 'description: "Test refactor skill."' "$test_tmp/home/.agents/skills/refactor/SKILL.md" >/dev/null
grep -F 'Test refactor instructions.' "$test_tmp/home/.agents/skills/refactor/SKILL.md" >/dev/null
for name in find-skills apple-design refactor systematic-debugging writing-plans executing-plans requesting-code-review receiving-code-review \
  create-issue reverse-engineer-anything project-structure instruments-profiling swiftui-performance-audit \
  swiftui-pro swift-concurrency-pro swift-testing-pro; do
  test -f "$test_tmp/home/.agents/skills/$name/SKILL.md"
done
