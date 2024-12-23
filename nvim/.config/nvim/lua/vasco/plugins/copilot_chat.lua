local CHAT_WINDOW_WIDTH = 0.4
local DEFAULT_MODEL = 'claude-3.5-sonnet'

local function capitalize_first_letter(str)
  return str:sub(1, 1):upper() .. str:sub(2)
end

local prompts = {
  Explain = {
    prompt = '> /COPILOT_EXPLAIN\n\nWrite an explanation for the selected code as paragraphs of text.',
  },
  Review = {
    prompt = '> /COPILOT_REVIEW\n\nPlease review the following code and provide suggestions for improvement.',
  },
  Fix = {
    prompt = '> /COPILOT_GENERATE\n\nThere is a problem in this code. Rewrite the code to show it with the bug fixed.',
  },
  Optimize = {
    prompt = '> /COPILOT_GENERATE\n\nOptimize the selected code to improve performance and readability.',
  },
  Documentation = {
    prompt = '> /COPILOT_GENERATE\n\nPlease add documentation comments to the selected code.',
  },
  Refactor = {
    prompt = '> /COPILOT_GENERATE\n\nPlease refactor the following code to improve its clarity and readability.',
  },
  Tests = {
    prompt = '> /COPILOT_GENERATE\n\nPlease generate tests for my code. If using Ruby write the tests with minitest. If using JavaScript write the tests with Jest.',
  },
  Commit = {
    prompt = '> #git:staged\n\nWrite a git commit message with these requirements:\n- 50 char max title with Jira ticket (if in branch name) using format "AB-1234 Title"\n- Use imperative mode\n- Body wrapped at 72 chars\n- Start with concise summary\n- List and explain changes, implementation, and rationale\n- Include context and technical details\n- Add relevant links if applicable\n- Use `backticks` for code terms',
  },
  BetterNamings = {
    prompt = '> /COPILOT_GENERATE\n\nPlease suggest better names for the selected code.',
  },
  Summarize = {
    prompt = '> /COPILOT_GENERATE\n\nPlease summarize in a few sentences.',
  },
  Spelling = {
    prompt = '> /COPILOT_GENERATE\n\nCorrect the spelling.',
  },
  Wording = {
    prompt = '> /COPILOT_GENERATE\n\nImprove the grammar and wording.',
  },
  Concise = {
    prompt = '> /COPILOT_GENERATE\n\nRewrite the text to make it more concise.',
  },
}

local chat_config = {
  model = DEFAULT_MODEL,
  agent = 'copilot',
  context = 'buffer',
  auto_insert_mode = false,
  window = {
    width = CHAT_WINDOW_WIDTH,
  },
}

local function setup_buffer_settings()
  vim.opt_local.relativenumber = false
  vim.opt_local.number = false
end

local mappings = {
  -- { '<leader>ac', '<cmd>CopilotChat<cr>', desc = 'Open chat' },
  -- Code operations
  { '<leader>ae', '<cmd>CopilotChatExplain<cr>', desc = 'Explain code' },
  { '<leader>at', '<cmd>CopilotChatTests<cr>', desc = 'Generate tests' },
  { '<leader>ar', '<cmd>CopilotChatReview<cr>', desc = 'Review code' },
  { '<leader>aR', '<cmd>CopilotChatRefactor<cr>', desc = 'Refactor code' },
  { '<leader>af', '<cmd>CopilotChatFix<cr>', desc = 'Fix code' },
  { '<leader>ab', '<cmd>CopilotChatBetterNamings<cr>', desc = 'Better Names' },
  { '<leader>ad', '<cmd>CopilotChatDocumentation<cr>', desc = 'Add documentation for code' },

  -- Text operations
  { '<leader>aS', '<cmd>CopilotChatSummarize<cr>', desc = 'Summarize text' },
  { '<leader>as', '<cmd>CopilotChatSpelling<cr>', desc = 'Correct spelling' },
  { '<leader>aw', '<cmd>CopilotChatWording<cr>', desc = 'Improve wording' },
  { '<leader>aC', '<cmd>CopilotChatConcise<cr>', desc = 'Make text concise' },

  -- Git operations
  { '<leader>am', '<cmd>CopilotChatCommit<cr>', desc = 'Generate commit message for all changes' },
  { '<leader>aM', '<cmd>CopilotChatCommitStaged<cr>', desc = 'Generate commit message for staged changes' },

  -- { '<leader>al', '<cmd>CopilotChatReset<cr>', desc = 'Clear buffer and chat history' },
  { '<leader>aV', '<cmd>CopilotChatToggle<cr>', desc = 'Toggle' },

  -- Chat management
  {
    '<leader>ap',
    function()
      local input = vim.fn.input 'Ask Copilot: '
      if input ~= '' then
        vim.cmd('CopilotChat ' .. input)
      end
    end,
    desc = 'Prompt Copilot with custom input',
  },
  -- {
  --   '<leader>ax',
  --   function()
  --     require('CopilotChat').reset()
  --   end,
  --   desc = 'Clear',
  --   mode = { 'n', 'v' },
  -- },
  {
    '<leader>aa',
    function()
      local actions = require 'CopilotChat.actions'
      require('CopilotChat.integrations.fzflua').pick(actions.prompt_actions())
    end,
    desc = 'Prompt actions',
  },
}

return {
  -- {
    -- 'CopilotC-Nvim/CopilotChat.nvim',
    -- branch = 'main',
    -- build = 'make tiktoken',
    -- cmd = 'CopilotChat',
    -- dependencies = {
    --   { 'github/copilot.vim' },
    --   { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    -- },
    -- opts = function()
    --   local user = vim.env.USER or 'User'
    --   chat_config.question_header = '  ' .. capitalize_first_letter(user) .. ' '
    --   chat_config.answer_header = '  Copilot '
    --   chat_config.prompts = prompts
    --   return chat_config
    -- end,
    -- config = function(_, opts)
    --   local chat = require 'CopilotChat'
    --   vim.g.copilot_no_tab_map = true
    --   vim.api.nvim_set_keymap('i', '<C-h>', 'copilot#Accept("<CR>")', { silent = true, expr = true })
    --
    --   vim.api.nvim_create_autocmd('BufEnter', {
    --     pattern = 'copilot-chat',
    --     callback = setup_buffer_settings,
    --   })
    --
    --   chat.setup(opts)
    -- end,
    -- keys = mappings,
  -- },
}
