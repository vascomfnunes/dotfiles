local use_cterm, palette

--base00 - Default Background
--base01 - Lighter Background (Used for status bars, line number and folding marks)
--base02 - Selection Background
--base03 - Comments, Invisibles, Line Highlighting
--base04 - Dark Foreground (Used for status bars)
--base05 - Default Foreground, Caret, Delimiters, Operators
--base06 - Light Foreground (Not often used)
--base07 - Light Background (Not often used)
--base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
--base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
--base0A - Classes, Markup Bold, Search Text Background
--base0B - Strings, Inherited Class, Markup Code, Diff Inserted
--base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
--base0D - Functions, Methods, Attribute IDs, Headings
--base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
--base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>

-- Dark palette

if vim.o.background == 'dark' then
  palette = {
    base00 = '#282828',
    base01 = '#282828',
    base02 = '#504945',
    base03 = '#665c54',
    base04 = '#bdae93',
    base05 = '#ddc7a1',
    base06 = '#ebdbb2',
    base07 = '#fbf1c7',
    base08 = '#ea6962',
    base09 = '#e78a4e',
    base0A = '#d8a657',
    base0B = '#a9b665',
    base0C = '#89b482',
    base0D = '#7daea3',
    base0E = '#d3869b',
    base0F = '#bd6f3e',
  }
end

-- Light palette

if vim.o.background == 'light' then
  palette = {
    base00 = '#fbf1c7',
    base01 = '#fbf1c7',
    base02 = '#d5c4a1',
    base03 = '#bdae93',
    base04 = '#665c54',
    base05 = '#504945',
    base06 = '#3c3836',
    base07 = '#282828',
    base08 = '#9d0006',
    base09 = '#af3a03',
    base0A = '#b57614',
    base0B = '#79740e',
    base0C = '#427b58',
    base0D = '#076678',
    base0E = '#8f3f71',
    base0F = '#d65d0e',
  }
end

if palette then
  require('mini.base16').setup {
    palette = palette,
    use_cterm = use_cterm,
    plugins = {
      default = false,
      ['folke/lazy.nvim'] = true,
      ['folke/noice.nvim'] = true,
      ['folke/which-key.nvim'] = true,
      ['ggandor/leap.nvim'] = true,
      ['lewis6991/gitsigns.nvim'] = true,
      ['nvim-neo-tree/neo-tree.nvim'] = true,
      ['rcarriga/nvim-dap-ui'] = true,
      ['williamboman/mason.nvim'] = true,
    },
  }
  vim.g.colors_name = 'mini_gruvbox_material'
end
