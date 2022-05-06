local M = {}

M.settings = {
  json = {
    schemas = {
      {
        description = '',
        fileMatch = {},
        name = 'Common types for all schemas',
        url = 'https://json.schemastore.org/base.json',
      },
      {
        description = 'YAML schema for GitHub Actions',
        fileMatch = { 'action.yml', 'action.yaml' },
        name = 'GitHub Action',
        url = 'https://json.schemastore.org/github-action.json',
      },
      {
        description = 'YAML schema for GitHub Workflow',
        fileMatch = { '.github/workflows/**.yml', '.github/workflows/**.yaml' },
        name = 'GitHub Workflow',
        url = 'https://json.schemastore.org/github-workflow.json',
      },
      {
        description = 'Json schema for properties json file for a GitHub Workflow template',
        fileMatch = { '.github/workflow-templates/**.properties.json' },
        name = 'GitHub Workflow Template Properties',
        url = 'https://json.schemastore.org/github-workflow-template-properties.json',
      },
      {
        description = 'JSON schema for Import Maps files',
        fileMatch = { 'importmap.json', 'import_map.json', 'import-map.json' },
        name = 'importmap.json',
        url = 'https://json.schemastore.org/importmap.json',
      },
      {
        fileMatch = { 'package.json' },
        url = 'https://json.schemastore.org/package.json',
      },
      {
        fileMatch = { 'tsconfig*.json' },
        url = 'https://json.schemastore.org/tsconfig.json',
      },
      {
        fileMatch = { '.prettierrc', '.prettierrc.json', 'prettier.config.json' },
        url = 'https://json.schemastore.org/prettierrc.json',
      },
      {
        fileMatch = { '.eslintrc', '.eslintrc.json' },
        url = 'https://json.schemastore.org/eslintrc.json',
      },
      {
        fileMatch = { '.babelrc', '.babelrc.json', 'babel.config.json' },
        url = 'https://json.schemastore.org/babelrc.json',
      },
      {
        fileMatch = { 'lerna.json' },
        url = 'https://json.schemastore.org/lerna.json',
      },
      {
        fileMatch = { 'now.json', 'vercel.json' },
        url = 'https://json.schemastore.org/now.json',
      },
      {
        fileMatch = { 'ecosystem.json' },
        url = 'https://json.schemastore.org/pm2-ecosystem.json',
      },
      {
        fileMatch = { 'crowdin.json' },
        url = 'https://json.schemastore.org/crowdin.json',
      },
      {
        description = 'Cypress.io test runner configuration file',
        fileMatch = { 'cypress.json' },
        name = 'cypress.json',
        url = 'https://on.cypress.io/cypress.schema.json',
      },
      {
        description = "A JSON schema CSS Lint's configuration file",
        fileMatch = { '.csslintrc' },
        name = '.csslintrc',
        url = 'https://json.schemastore.org/csslintrc.json',
      },
      {
        description = 'JavaScript project configuration file',
        fileMatch = { 'jsconfig.json' },
        name = 'jsconfig.json',
        url = 'https://json.schemastore.org/jsconfig.json',
      },
      {
        description = 'This schema describes the YAML config that Netlify uses',
        fileMatch = { 'admin/config*.yml' },
        name = 'Netlify config schema',
        url = 'https://json.schemastore.org/netlify.json',
      },
      {
        description = 'A JSON schema for Open API documentation files',
        fileMatch = { 'openapi.json', 'openapi.yml', 'openapi.yaml' },
        name = 'openapi.json',
        url = 'https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json',
        versions = {
          ['3.0'] = 'https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.0/schema.json',
          ['3.1'] = 'https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json',
        },
      },
      {
        description = 'Swagger API 2.0 schema',
        fileMatch = { 'swagger.json' },
        name = 'Swagger API 2.0',
        url = 'https://json.schemastore.org/swagger-2.0.json',
      },
      {
        description = 'JSON schema for commitlint configuration files',
        fileMatch = { '.commitlintrc', '.commitlintrc.json' },
        name = '.commitlintrc',
        url = 'https://json.schemastore.org/commitlintrc.json',
      },
      {
        description = 'yamllint uses a set of rules to check source files for problems',
        fileMatch = { '**/.yamllint', '**/.yamllint.yaml', '**/.yamllint.yml' },
        name = 'yamllint',
        url = 'https://json.schemastore.org/yamllint.json',
      },
      {
        description = 'JSON Schema for Yarnrc files',
        fileMatch = { '.yarnrc.yml' },
        name = '.yarnrc.yml',
        url = 'https://yarnpkg.com/configuration/yarnrc.json',
      },
      {
        description = 'Markdownlint config file schema',
        fileMatch = {
          '.markdownlintrc',
          '.markdownlint.json',
          '.markdownlint.jsonc',
          '.markdownlint.yaml',
          '.markdownlint.yml',
        },
        name = 'Markdownlint',
        url = 'https://raw.githubusercontent.com/DavidAnson/markdownlint/main/schema/markdownlint-config-schema.json',
      },
    },
  },
}

return M
