local M = {}
local cmd = vim.cmd

local function install()
  local packer_exists = pcall(cmd, [[packadd packer.nvim]])

  if not packer_exists then
    if vim.fn.input("Download Packer? (y for yes)") ~= "y" then
      return
    end
    local directory = string.format('%s/site/pack/packer/opt/', vim.fn.stdpath('data'))
    vim.fn.mkdir(directory, 'p')
    local out = vim.fn.system(string.format('git clone %s %s', 'https://github.com/wbthomason/packer.nvim',
                                            directory .. '/packer.nvim'))
    print(out)
    print("Downloading packer.nvim...")

    return
  end
end

local function load()
  return require('packer').startup(function()
    use {'wbthomason/packer.nvim', opt = true}
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/completion-nvim'
    use 'kyazdani42/nvim-web-devicons'
    use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}}
    use {
      'nvim-telescope/telescope-fzy-native.nvim',
      opt = true,
      requires = {
        {'nvim-telescope/telescope.nvim'}
      }
    }
    use 'tjdevries/express_line.nvim'
    use {'RishabhRD/nvim-cheat.sh', requires = {'RishabhRD/popfix'}, opt = true, cmd = 'Cheat'}
    use 'junegunn/vim-peekaboo'
    use {
      'dhruvasagar/vim-table-mode',
      ft = {'txt', 'markdown'}
    } -- table alignment
    use {
      'kyazdani42/nvim-tree.lua',
      opt = true,
      requires = {
        {'kyazdani42/nvim-web-devicons', opt = true}
      },
    }
    use {
      'voldikss/vim-floaterm',
      config = function()
        vim.g.floaterm_keymap_toggle = '<c-t>'
      end
    }
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {
      'SirVer/ultisnips',
      config = function()
        vim.g.UltiSnipsExpandTrigger = '<c-s>'
      end
    }
    use 'honza/vim-snippets'
    use 'justinmk/vim-gtfo'
    use 'DataWraith/auto_mkdir'
    use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}
    use {
      'iamcco/markdown-preview.nvim',
      run = 'cd app && yarn install',
      config = function()
        vim.g.vim_markdown_preview_github = 1
        vim.g.vim_markdown_preview_toggle = 1
        vim.g.vim_markdown_preview_browser = 'Google Chrome'
        vim.g.vim_markdown_preview_temp_file = 1
      end
    }
    use 'cohama/lexima.vim'
    use 'rhysd/committia.vim'
    use {
      'editorconfig/editorconfig-vim',
      config = function()
        vim.g.EditorConfig_exclude_patterns = {'fugitive://.*', 'scp://.*'}
      end
    }
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use 'easymotion/vim-easymotion'
    use 'AndrewRadev/splitjoin.vim'
    use 'romainl/vim-cool'
    use 'tpope/vim-fugitive'
    use {'tpope/vim-rails', opt = true, ft = 'ruby'}
    use 'tpope/vim-surround'
    use 'tpope/vim-commentary'
    use {'tpope/vim-ragtag', opt = true, ft = 'eruby'}
    use {'vim-test/vim-test', opt = true, cmd = {'TestFile', 'TestSuite', 'TestNearest'}}
    use {'vimwiki/vimwiki',
      config = function()
          local wikis = {
            {path = '~/vimwiki_work_md/', syntax = 'markdown', ext = '.md'},
            {path = '~/vimwiki_personal_md/', syntax = 'markdown', ext = '.md'}
          }
          vim.g.vimwiki_list = wikis
          vim.g.vimwiki_ext2syntax = {md = 'markdown', markdown = 'markdown'}
          vim.g.vimwiki_global_ext = 0
          vim.g.vimwiki_listsyms = '✗○◐●✓'
          vim.g.vimwiki_folding = 'expr'
      end
    }
    use {
      'mattn/emmet-vim',
      cmd = 'EmmetInstall',
      config = function()
        vim.g.user_emmet_leader_key = '<C-e>'
        vim.g.user_emmet_install_global = 0
      end
    }
    use {
      'sunaku/vim-dasht',
      opt = true,
      cmd = 'Dasht',
      config = function()
        vim.g.dasht_results_window = 'vnew'
        vim.g.dasht_filetypes_docsets = {}
        vim.g.dasht_filetype_docsets['html'] = {
          'CSS',
          'Javascript',
          'Bootstrap_4',
          'Emmet',
          'Font_Awesome',
          'HTML',
          'JavaScript',
          'MomentJS',
          'jQuery'
        }
        vim.g.dasht_filetype_docsets['eruby'] = {
          'CSS',
          'Javascript',
          'Bootstrap_4',
          'Emmet',
          'Font_Awesome',
          'HTML',
          'JavaScript',
          'MomentJS',
          'jQuery',
          'Ruby_2',
          'Ruby_on_Rails_6'
        }
        vim.g.dasht_filetype_docsets['vim'] = {'Vim'}
        vim.g.dasht_filetype_docsets['css'] = {'CSS'}
        vim.g.dasht_filetype_docsets['scss'] = {'CSS', 'Sass'}
        vim.g.dasht_filetype_docsets['javascript'] = {
          'JavasScript',
          'Mocha',
          'MomentJS',
          'jQuery',
          'jQuery_Mobile',
          'jQuery_UI'
        }
        vim.g.dasht_filetype_docsets['ruby'] = {'Ruby_2', 'Ruby_onRails_6', 'Ruby_Installed_Gems'}
        vim.g.dasht_filetype_docsets['markdown'] = {'Markdown'}
        vim.g.dasht_filetype_docsets['docker'] = {'Docker', 'Man_Pages'}
        vim.g.dasht_filetype_docsets['bash'] = {'Bash'}
      end
    }
    use {
      'alexbel/vim-rubygems',
      opt = true,
      requires = {'mattn/webapi-vim'},
      cmd = {'RubygemsGemInfo', 'RubygemsAppendVersion'}
    }
    use {'AndrewRadev/tagalong.vim', opt = true, ft = {'html', 'eruby'}}
    use 'mzlogin/vim-markdown-toc'
    use {
      'kkoomen/vim-doge',
      run = function()
        vim.cmd [[call doge#install()]]
      end,
      config = function()
        vim.g.doge_enable_mappings = 0
      end
    }
    use {
      'christoomey/vim-tmux-navigator',
      config = function()
        vim.g.tmux_navigator_no_mappings = 1
      end
    }
    use {
      'RyanMillerC/better-vim-tmux-resizer',
      config = function()
        vim.g.tmux_resizer_no_mappings = 1
      end
    }
    use 'tmux-plugins/vim-tmux-focus-events'
    use 'norcalli/nvim-colorizer.lua'
    use 'vascomfnunes/vimbox'
  end)
end

function M.init()
  install()
  load()
end

return M
