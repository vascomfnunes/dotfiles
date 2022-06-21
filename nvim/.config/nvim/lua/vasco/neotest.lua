require('neotest').setup {
  adapters = {
    require 'neotest-jest' {
      jestCommand = 'yarn test --',
    },
    require 'neotest-rspec',
  },
}
