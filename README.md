# Vasco's dotfiles

<!-- vim-markdown-toc GitLab -->

* [Neovim](#neovim)
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

## Neovim

This configuration requires neovim 0.5.x nightly.

## Weechat configuration

### Secured data

To secure the password for the irc servers:

```weechat
/secure passphrase <pass>
/secure set freenodepass <pass>
```
