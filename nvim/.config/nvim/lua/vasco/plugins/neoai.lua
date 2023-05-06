return {
  'Bryley/neoai.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  cmd = {
    'NeoAI',
    'NeoAIOpen',
    'NeoAIClose',
    'NeoAIToggle',
    'NeoAIContext',
    'NeoAIContextOpen',
    'NeoAIContextClose',
    'NeoAIInject',
    'NeoAIInjectCode',
    'NeoAIInjectContext',
    'NeoAIInjectContextCode',
  },
  keys = {
    { '<leader>og', desc = 'Generate git message' },
  },
  config = function()
    require('neoai').setup {
      ui = {
        output_popup_text = 'NeoAI',
        input_popup_text = 'Prompt',
        width = 30, -- As percentage eg. 30%
        output_popup_height = 80, -- As percentage eg. 80%
        submit = '<Enter>', -- Key binding to submit the prompt
      },
      models = {
        {
          name = 'openai',
          model = 'gpt-3.5-turbo',
          params = nil,
        },
      },
      register_output = {
        ['g'] = function(output)
          return output
        end,
        ['c'] = require('neoai.utils').extract_code_snippets,
      },
      inject = {
        cutoff_width = 75,
      },
      prompts = {
        context_prompt = function(context)
          return "Hey, I'd like to provide some context for future "
            .. 'messages. Here is the code/text that I want to refer '
            .. 'to in our upcoming conversations:\n\n'
            .. context
        end,
      },
      mappings = {
        ['select_up'] = '<C-k>',
        ['select_down'] = '<C-j>',
      },
      shortcuts = {
        {
          name = 'gitcommit',
          key = '<leader>og',
          desc = 'generate git commit message',
          use_context = false,
          prompt = function()
            return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    using conventional commits messages:
                ]] .. vim.fn.system 'git diff --cached'
          end,
          modes = { 'n' },
          strip_function = nil,
        },
      },
    }
  end,
}
