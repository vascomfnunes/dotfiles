local prompts = {
  -- Code related prompts
  Explain = 'Please explain how the following code works.',
  Review = 'Please review the following code and provide suggestions for improvement.',
  Tests = 'Please explain how the selected code works, then generate unit tests for it. If this is a Ruby file write the tests using minitest. If is a JavaScript file, use Jest.',
  Refactor = 'Please refactor the following code to improve its clarity and readability.',
  FixCode = 'Please fix the following code to make it work as intended.',
  FixError = 'Please explain the error in the following text and provide a solution.',
  Documentation = 'Please provide documentation for the following code.',
  Commit = 'Write a git commit message for the changes. The title should have 50 characters or less and start with a Jira ticket reference, but only if present in the branch name, in the format "AB-1234 Commit title here" (replace the ticket example with the correct ticet reference from the branch name and use imperative mode. The body should provide a meaningful commit message, which should be wrapped at 72 characters. Start with a concise paragraph explaining what is included in the commit. Then make sure to list what has changed or added and explaining how those changes were implemented and why. At the end, include any relevant links to tickets, documentation or online resources if that makes sense. If you include any file name or command, please wrap them in backticks. Use markdown when possible.',
  -- Text related prompts
  Summarize = 'Please summarize the following text.',
  Spelling = 'Please correct any grammar and spelling errors in the following text.',
  Wording = 'Please improve the grammar and wording of the following text.',
  Concise = 'Please rewrite the following text to make it more concise.',
}

return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    cmd = 'CopilotChat',
    dependencies = {
      { 'github/copilot.vim' },
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    opts = function()
      local user = vim.env.USER or 'User'
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
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
      -- Show help actions with telescope
      {
        '<leader>ah',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.telescope').pick(actions.help_actions())
        end,
        desc = 'Help actions',
      },
      -- Show prompts actions with telescope
      {
        '<leader>ap',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
        end,
        desc = 'Prompt actions',
      },
      {
        '<leader>ap',
        ":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
        mode = 'x',
        desc = 'Prompt actions',
      },
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
          return require('CopilotChat').toggle()
        end,
        desc = 'Toggle',
        mode = { 'n', 'v' },
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
