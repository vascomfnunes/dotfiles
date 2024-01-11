return {
  'dpayne/CodeGPT.nvim',
  cmd = 'Chat',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  keys = {
    {
      '<leader>ae',
      '<cmd>Chat explain<cr>',
      desc = 'Explain code',
      mode = { 'v' },
    },
    {
      '<leader>af',
      '<cmd>Chat debug<cr>',
      desc = 'Find problems in code',
      mode = { 'v' },
    },
    {
      '<leader>ad',
      '<cmd>Chat doc<cr>',
      desc = 'Write documentation',
      mode = { 'v' },
    },
    {
      '<leader>at',
      '<cmd>Chat tests<cr>',
      desc = 'Write unit tests',
      mode = { 'v' },
    },
    {
      '<leader>ar',
      '<cmd>Chat code_edit<cr>',
      desc = 'Refactor code',
      mode = { 'v' },
    },
  },
  config = function()
    require 'codegpt.config'
    local ror_prompt = 'You are a Ruby on Rails programmer focused in writting clena, organized and DRY code.'

    vim.g['codegpt_openai_api_key'] = os.getenv 'OPENAI_API_KEY'
    vim.g['codegpt_popup_type'] = 'vertical'
    vim.g['codegpt_vertical_popup_size'] = '40%'
    vim.g['codegpt_clear_visual_selection'] = true

    vim.g['codegpt_ui_commands'] = {
      -- some default commands, you can remap the keys
      quit = 'q', -- key to quit the popup
      use_as_output = '<c-o>', -- key to use the popup content as output and replace the original lines
      use_as_input = '<c-i>', -- key to use the popup content as input for a new API request
    }

    vim.g['codegpt_commands'] = {
      ['tests'] = {
        language_instructions = {
          ruby = ror_prompt .. ' Use the minitest framework.',
        },
      },
      ['doc'] = {
        language_instructions = {
          ruby = 'Use rdoc format.',
        },

        -- Overrides the max tokens to be 1024
        max_tokens = 1024,
      },
      ['code_edit'] = {
        -- Overrides the system message template
        language_instructions = {
          ruby = ror_prompt,
        },

        -- Overrides the user message template
        user_message_template = 'I have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\nEdit the above code. {{language_instructions}}',
        callback_type = 'code_popup',
      },
    }
  end,
}
