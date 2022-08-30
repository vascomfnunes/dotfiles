# Vasco Nunes's dotfiles

## Neovim

This Neovim configuration requires Neovim 0.7.2 and has the following
dependencies:

### Nonicons

Nonicons are a set of SVG icons representing several languages, inspired by
Octicons. The ttf font should be installed to correctly display the icons. You
can find the font file
[here](https://github.com/yamatsum/nonicons/blob/master/dist/nonicons.ttf).

Also, if using Kitty the following line should be added to its configuration
file (e.g. `~/.config/kitty/kitty.cfg`):

```bash
symbol_map U+f101-U+f208 nonicons

```

### Rg

Rg is required for Telescope to perform string grep operations. On macOS it
can be installed as so:

```bash
brew install rg
```

### Live server

To have markdown files HTML preview, live-server should be installed:

```bash
npm install -g live-server
```
