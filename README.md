# Vasco's dotfiles

<!-- vim-markdown-toc GitLab -->

* [Vim](#vim)
  * [Update plugins](#update-plugins)
  * [Clean plugins](#clean-plugins)
  * [LSP](#lsp)
  * [Linters and Fixers](#linters-and-fixers)
  * [Using languagetool](#using-languagetool)
* [Weechat configuration](#weechat-configuration)
  * [Secured data](#secured-data)

<!-- vim-markdown-toc -->

This repository uses Homesick to handle the dotfiles.

See more information here:
[https://github.com/vascomfnunes/homesick](https://github.com/vascomfnunes/homesick)

Install `homesick`:

```bash
gem install homesick
```

To clone the repository on a new machine:

```bash
git clone git@github.com:vascomfnunes/dotfiles.git .homesick
```

Then just link the files:

```bash
homesick link
```

## Vim

This config uses Vim 8.x.x and [Plug](https://github.com/junegunn/vim-plug) to manage all plugins.

### Update plugins

```vim
:PlugUpdate
```

### Clean plugins

```vim
:PlugClean
```

### LSP

This configuration uses [vim-lsp](https://github.com/prabirshrestha/vim-lsp) and
[vim-lsp-settings](https://github.com/mattn/vim-lsp-settings) as the Language
Server Protocol.

To install a specific server run the following command:

```vim
:LspInstallServer <server-name>
```

### Linters and Fixers

To use some of the defined key mappings with linters/fixers:

* **Markdown** - `brew install markdownlint-cli`
* **CSS/SCSS** - `npm install -g stylelint`
* **Ruby** - `gem install rubocop`
* **YAML** - `brew install yamllint`
* **Json** - `brew install jsonlint`
* **HTML** - `npm install -g html-linter`
* **JavaScript** - `brew install eslint`
* **Docker** - `brew install hadolint`
* **Eruby** - `gem install erb_lint`
* **Generic** - `brew install prettier`

All linters use the `<leader>cl` keybinding. Fixers use `<leader>cf`.

### Using languagetool

Markdown files have a keybinding (`<leader>cg`) to check grammatical issues in the text using
`languagetool`. It defaults to `en-GB`.

This requires `languagetool` to be installed:

```bash
brew install languagetool
```

## Weechat configuration

### Secured data

To secure the password for the irc servers:

```weechat
/secure passphrase <pass>
/secure set freenodepass <pass>
```
