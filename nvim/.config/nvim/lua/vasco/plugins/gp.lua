local config = require 'vasco.config'

return {
  'robitx/gp.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>ac',
      '<cmd>GpChatNew popup<cr>',
      desc = 'New chat',
      mode = { 'n' },
    },
    {
      '<leader>aa',
      '<cmd>GpChatToggle<cr>',
      desc = 'Toggle AI popup',
      mode = { 'n' },
    },
    {
      '<leader>aF',
      '<cmd>GpChatFinder<cr>',
      desc = 'Find chats',
      mode = { 'n' },
    },
    {
      '<leader>ap',
      ":'<,'>GpChatPaste<cr>",
      desc = 'Paste selection in latest chat',
      mode = { 'v' },
    },
    {
      '<leader>aw',
      ":'<,'>GpRewrite<cr>",
      desc = 'Rewrite code with instructions',
      mode = { 'v' },
    },
    {
      '<leader>ai',
      ":'<,'>GpImplement<cr>",
      desc = 'Implement based on code comments',
      mode = { 'v' },
    },
    {
      '<leader>ae',
      ":'<,'>GpExplain<cr>",
      desc = 'Explain code',
      mode = { 'v' },
    },
    {
      '<leader>at',
      ":'<,'>GpUnitTests<cr>",
      desc = 'Write unit tests',
      mode = { 'v' },
    },
    {
      '<leader>ar',
      ":'<,'>GpCodeReview<cr>",
      desc = 'Review the selected code',
      mode = { 'v' },
    },
    {
      '<leader>af',
      ":'<,'>GpFindProblems<cr>",
      desc = 'Fix the selected code',
      mode = { 'v' },
    },
  },
  config = function()
    require('gp').setup {
      chat_user_prefix = '🗨 Vasco:',
      chat_assistant_prefix = { '🤖:', '[{{agent}}]' },
      chat_shortcut_respond = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-g><C-g>' },
      chat_shortcut_delete = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-g>d' },
      chat_shortcut_stop = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-g>s' },
      chat_shortcut_new = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-g>c' },
      toggle_target = 'popup',
      style_chat_finder_border = config.border_style,
      style_popup_border = config.border_style,
      hooks = {
        Explain = function(gp, params)
          local template = 'I have the following code from {{filename}}:\n\n'
            .. '```{{filetype}}\n{{selection}}\n```\n\n'
            .. 'Please respond by explaining the code above.'
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.vnew, nil, agent.model, template, agent.system_prompt)
        end,
        UnitTests = function(gp, params)
          local template = 'I have the following code from {{filename}}:\n\n'
            .. '```{{filetype}}\n{{selection}}\n```\n\n'
            .. 'Please respond by writing table driven unit tests for the code above.'
          local agent = gp.get_command_agent()
          gp.Prompt(params, gp.Target.vnew, nil, agent.model, template, agent.system_prompt)
        end,
        CodeReview = function(gp, params)
          local template = 'I have the following code from {{filename}}:\n\n'
            .. '```{{filetype}}\n{{selection}}\n```\n\n'
            .. 'Please analyze for code smells and suggest improvements.'
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.vnew 'markdown', nil, agent.model, template, agent.system_prompt)
        end,
        FindProblems = function(gp, params)
          local template = 'I have the following code from {{filename}}:\n\n'
            .. '```{{filetype}}\n{{selection}}\n```\n\n'
            .. 'Please analyze for code smells and potential issues or bugs and rewrite the code. Do not write or explain anything outside code blocks but use brief code comments to explain your changes.'
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.vnew, nil, agent.model, template, agent.system_prompt)
        end,
      },
    }
  end,
}
