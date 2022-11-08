vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-tree').setup {
	disable_netrw = true,
	hijack_cursor = true,
	hijack_netrw = true,
	hijack_unnamed_buffer_when_opening = false,
	open_on_setup = false,
	filters = {
		custom = {
			'.git',
			'node_modules',
			'\\.cache',
			'__pycache__',
		},
	},
	update_cwd = true,
	update_focused_file = { enable = true, update_cwd = false, ignore_list = {} },
	actions = {
		open_file = {
			resize_window = true,
			quit_on_open = true,
			window_picker = {
				enable = true,
				chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
				exclude = {
					filetype = { 'notify', 'packer', 'qf', 'diff', 'fugitive' },
					buftype = { 'nofile', 'terminal', 'help' },
				},
			},
		},
	},
	trash = {
		require_confirm = true,
	},
	log = {
		enable = false,
		truncate = false,
		types = {
			all = false,
			config = false,
			copy_paste = false,
			diagnostics = false,
			git = false,
			profile = false,
		},
	},
	git = {
		enable = false,
		ignore = true,
	},
	filesystem_watchers = {
		enable = true,
	},
	view = {
		adaptive_size = false,
		width = math.floor(vim.fn.winwidth(0) * 0.30), -- 20% of window width
		side = 'left',
		mappings = {
			-- custom only false will merge the list with the default mappings
			-- if true, it will only use your list to set the mappings
			custom_only = false,
			-- list of mappings to set on the tree manually
			list = {
				{ key = { '<CR>', 'o', 'l' }, action = 'edit' },
				{ key = '<C-v>', action = 'vsplit' },
				{ key = '<C-s>', action = 'split' },
				{ key = '<C-t>', action = 'tabnew' },
				{ key = 'h', action = 'close_node' },
				{ key = '<Tab>', action = 'preview' },
				{ key = 'H', action = 'toggle_dotfiles' },
				{ key = 'R', action = 'refresh' },
				{ key = 'a', action = 'create' },
				{ key = 'd', action = 'remove' },
				{ key = 'r', action = 'rename' },
				{ key = 'x', action = 'cut' },
				{ key = 'y', action = 'copy' },
				{ key = 'p', action = 'paste' },
				{ key = 'Y', action = 'copy_name' },
				{ key = 'C', action = 'copy_path' },
				{ key = 'gy', action = 'copy_absolute_path' },
				{ key = '-', action = 'dir_up' },
				{ key = 'q', action = 'close' },
				{ key = 'g?', action = 'toggle_help' },
			},
		},
	},
	renderer = {
		highlight_git = false,
		highlight_opened_files = 'none',
		indent_markers = {
			enable = false,
		},
		icons = {
			show = { folder = true, file = true, folder_arrow = true, git = false },
			glyphs = {
				default = ' ',
				symlink = ' ',
				folder = {
					default = ' ',
					empty = ' ',
					empty_open = ' ',
					open = ' ',
					symlink = ' ',
					symlink_open = ' ',
					arrow_open = ' ',
					arrow_closed = ' ',
				},
			},
		},
	},
}
