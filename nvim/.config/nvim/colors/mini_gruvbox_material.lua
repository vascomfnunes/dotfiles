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
    base02 = '#303030',
    base03 = '#5a524c',
    base04 = '#d8a657',
    base05 = '#d4be98',
    base06 = '#89b482',
    base07 = '#d4be98',
    base08 = '#7daea3',
    base09 = '#d3869b',
    base0A = '#ea6962',
    base0B = '#a9b665',
    base0C = '#a9b665',
    base0D = '#7daea3',
    base0E = '#d3869b',
    base0F = '#a9b665',
  }
end

-- Light palette is an 'inverted dark', output of 'MiniBase16.mini_palette':
-- - Background '#e2e5ca' (LCh(uv) = 90-20-90)
-- - Foreground '#002a83' (Lch(uv) = 15-60-250)
-- - Accent chroma 75
if vim.o.background == 'light' then
  palette = {
    base00 = '#e2e5ca',
    base01 = '#bcbfa4',
    base02 = '#979a7e',
    base03 = '#73765a',
    base04 = '#324490',
    base05 = '#002a83',
    base06 = '#0000e4',
    base07 = '#080500',
    base08 = '#5e2200',
    base09 = '#a86400',
    base0A = '#008818',
    base0B = '#004500',
    base0C = '#b34aad',
    base0D = '#004b76',
    base0E = '#7d0077',
    base0F = '#0086ae',
  }
end

if palette then
  require('mini.base16').setup {
    palette = palette,
    use_cterm = use_cterm,
    plugins = {
      default = false,
    },
  }
  vim.g.colors_name = 'mini_gruvbox_material'
end
