-- PROJECTIONIST
--

vim.g.projectionist_heuristics = {
  -- React
  ['src/*'] = {
    ['*.js'] = {
      alternate = {
        '{dirname}/{basename}.test.js',
        '{dirname}/__tests__/{basename}.test.js',
      },
      type = 'source',
    },
    ['*.test.js'] = {
      alternate = {
        '{dirname}/{basename}.js',
        '{dirname}/../{basename}.js',
      },
      type = 'test',
    },
  },
  -- Ruby on Rails
  ['config/routes.rb'] = {
    ['app/controllers/*_controller.rb'] = {
      alternate = 'app/models/{singular}.rb',
      type = 'controller',
    },
    ['app/helpers/*_helper.rb'] = {
      alternate = 'app/controllers/{}_controller.rb',
      type = 'helper',
    },
    ['app/models/*.rb'] = {
      alternate = 'app/controllers/{plural}_controller.rb',
      type = 'model',
    },
    ['app/views/*.html.erb'] = {
      alternate = 'app/controllers/{dirname}_controller.rb',
      type = 'view',
    },
    ['config/initializers/*.rb'] = {
      type = 'initializer',
    },
    ['app/javascript/*.js'] = {
      type = 'javascript',
    },
    ['app/javascript/stylesheets/*.scss'] = {
      type = 'stylesheets',
    },
    ['spec/*.rb'] = {
      type = 'spec',
    },
  },
}
