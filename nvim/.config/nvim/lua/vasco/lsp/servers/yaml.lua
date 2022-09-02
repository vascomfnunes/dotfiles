local M = {}

M.settings = {
  yamls = {
    schemaStore = {
      enable = true,
      url = 'https://www.schemastore.org/api/json/catalog.json',
    },
    schemas = {
      kubernetes = '*.yaml',
      ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
      ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
      ['http://json.schemastore.org/prettierrc'] = '.prettierrc.{yml,yaml}',
      ['https://json.schemastore.org/dependabot-v2'] = '.github/dependabot.{yml,yaml}',
      ['https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json'] = '*api*.{yml,yaml}',
    },
  },
}

return M
