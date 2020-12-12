# Vasco's dotfiles

<!-- vim-markdown-toc GFM -->

* [Vim](#vim)
  * [Install new plugins](#install-new-plugins)
  * [Update all plugins](#update-all-plugins)
  * [Remove a submodule plugin](#remove-a-submodule-plugin)
  * [Extra steps](#extra-steps)
  * [Help files](#help-files)
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

To clone the repository on a new machine, including the plugin submodules:

```bash
git clone --recursive git@github.com:vascomfnunes/dotfiles.git .homesick
```

Then just link the files:

```bash
homesick link
```

## Vim

This config uses the native Vim 8.2 package management with all plugins
as Git submodules on `~/.vim/pack/plugin/start`.

### Install new plugins

Inside `~/.vim/pack/plugin/start`:

```bash
git submodule add <url>
```

### Update all plugins

```bash
git submodule update --remote --merge
```

### Remove a submodule plugin

```bash
git submodule deinit -f -- a/submodule    
rm -rf a/submodule
git rm -f a/submodule
```

After changing you should commit and push the changes to the repository.

### Extra steps

Some plugins will require to install dependencies. Further steps inside the
plugin directory:

* **markdown-preview.nvim** - `yarn`
* **vim-doge** - `yarn`

`fzf.vim` require to run the command `:call fzf#install()` inside
vim itself in order to install the latest fzf binary.

### Help files

To generate help files for the plugins use the `:helptags ALL` command.

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
* **Generic** - `brew install prettier`

All linters use the `<leader>cl` keybinding. Fixers use `<leader>cf`.

### Using languagetool

Markdown files has a keybinding (`<leader>cg`) to check grammatical issues in the text using
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
