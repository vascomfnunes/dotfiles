local prompts = {
  Explain = {
    prompt = '> /COPILOT_EXPLAIN\n\nWrite an explanation for the selected code as paragraphs of text.',
  },
  Review = {
    prompt = '> /COPILOT_REVIEW\n\nReview the selected code.',
    -- see config.lua for implementation
  },
  Fix = {
    prompt = '> /COPILOT_GENERATE\n\nThere is a problem in this code. Rewrite the code to show it with the bug fixed.',
  },
  Optimize = {
    prompt = '> /COPILOT_GENERATE\n\nOptimize the selected code to improve performance and readability.',
  },
  Docs = {
    prompt = '> /COPILOT_GENERATE\n\nPlease add documentation comments to the selected code.',
  },
  Tests = {
    prompt = '> /COPILOT_GENERATE\n\nPlease generate tests for my code. If using Ruby write the tests with minitest. If using JavaScript write the tests with Jest.',
  },
  Commit = {
    prompt = '> #git:staged\n\nWrite a git commit message for the changes. The title should have 50 characters or less and start with a Jira ticket reference, but only if present in the branch name, in the format "AB-1234 Commit title here" (replace the ticket example with the correct ticket reference from the branch name and use imperative mode. The body should provide a meaningful commit message, which should be wrapped at 72 characters. Start with a concise paragraph explaining what is included in the commit. Then make sure to list what has changed or added and explaining how those changes were implemented and why. Always clearly describe the motivation, context, or technical details behind the change if applicable. Commit messages should be **clear** , **informative** , and **professional** , aiding readability and project tracking. At the end, include any relevant links to tickets, documentation or online resources if that makes sense. Use **backticks** if referencing code or specific terms.',
  },
}

return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    build = 'make tiktoken',
    cmd = 'CopilotChat',
    dependencies = {
      { 'github/copilot.vim' },
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    opts = function()
      local user = vim.env.USER or 'User'
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        model = 'claude-3.5-sonnet',
        agent = 'copilot',
        context = 'buffer',
        auto_insert_mode = false,
        prompts = prompts,
        question_header = '  ' .. user .. ' ',
        answer_header = '  Copilot ',
        window = {
          width = 0.4,
        },
        mappings = {
          close = {
            normal = 'q',
            insert = '<C-c>',
          },
          reset = {
            normal = '<C-x>',
            insert = '<C-x>',
          },
          submit_prompt = {
            normal = '<CR>',
            insert = '<C-s>',
          },
          toggle_sticky = {
            detail = 'Makes line under cursor sticky or deletes sticky line.',
            normal = 'gr',
          },
          accept_diff = {
            normal = '<C-y>',
            insert = '<C-y>',
          },
          jump_to_diff = {
            normal = 'gj',
          },
          quickfix_diffs = {
            normal = 'gq',
          },
          yank_diff = {
            normal = 'gy',
            register = '"',
          },
          show_diff = {
            normal = 'gd',
          },
          show_info = {
            normal = 'gi',
          },
          show_context = {
            normal = 'gc',
          },
        },
      }
    end,
    config = function(_, opts)
      local chat = require 'CopilotChat'
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap('i', '<C-h>', 'copilot#Accept("<CR>")', { silent = true, expr = true })

      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-chat',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
    keys = {
      -- Code related commands
      { '<leader>pe', '<cmd>CopilotChatExplain<cr>', desc = 'Explain code' },
      { '<leader>pt', '<cmd>CopilotChatTests<cr>', desc = 'Generate tests' },
      { '<leader>pr', '<cmd>CopilotChatReview<cr>', desc = 'Review code' },
      { '<leader>pR', '<cmd>CopilotChatRefactor<cr>', desc = 'Refactor code' },
      { '<leader>pn', '<cmd>CopilotChatBetterNamings<cr>', desc = 'Better Naming' },
      -- Chat with Copilot in visual mode
      {
        '<leader>av',
        ':CopilotChatVisual',
        mode = 'x',
        desc = 'Open in vertical split',
      },
      {
        '<leader>ax',
        ':CopilotChatInline<cr>',
        mode = 'x',
        desc = 'Inline chat',
      },
      -- Custom input for CopilotChat
      {
        '<leader>ai',
        function()
          local input = vim.fn.input 'Ask Copilot: '
          if input ~= '' then
            vim.cmd('CopilotChat ' .. input)
          end
        end,
        desc = 'Ask input',
      },
      -- Generate commit message based on the git diff
      {
        '<leader>am',
        '<cmd>CopilotChatCommit<cr>',
        desc = 'Generate commit message for all changes',
      },
      {
        '<leader>aM',
        '<cmd>CopilotChatCommitStaged<cr>',
        desc = 'Generate commit message for staged changes',
      },
      {
        '<leader>ax',
        function()
          return require('CopilotChat').reset()
        end,
        desc = 'Clear',
        mode = { 'n', 'v' },
      },
      {
        '<leader>aa',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.fzflua').pick(actions.prompt_actions())
        end,
        desc = 'Prompt actions',
      },
      -- Debug
      { '<leader>ad', '<cmd>CopilotChatDebugInfo<cr>', desc = 'Debug Info' },
      -- Fix the issue with diagnostic
      { '<leader>af', '<cmd>CopilotChatFixDiagnostic<cr>', desc = 'Fix Diagnostic' },
      -- Clear buffer and chat history
      { '<leader>al', '<cmd>CopilotChatReset<cr>', desc = 'Clear buffer and chat history' },
      -- Toggle Copilot Chat Vsplit
      { '<leader>av', '<cmd>CopilotChatToggle<cr>', desc = 'Toggle' },
    },
  },
}
