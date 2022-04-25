# Passwords for external APIs

There are a number of ways to specify a password, each represented by a separate setting. Newsboat looks for settings in certain order, and uses the first one that it finds. The exact order is described below.

Settings are prefixed by API names; e.g. newsblur-password, feedhq-passwordeval. All APIs support all the settings, so examples below use REMOTEAPI for prefix. Replace it with the name of the remote API you use.

The first setting Newsboat checks is `REMOTEAPI-password`. It should contain the password in plain text.

The second setting Newsboat checks is `REMOTEAPI-passwordfile`. It should contain a path to a file; the first line of that file should contain the password in plain text. If the file doesn’t exit, is unreadable, or its first line is empty, Newsboat will exit with an error.

The third setting Newsboat checks is `REMOTEAPI-passwordeval`. It should contain a command that, when executed, will print out the password to stdout. stderr will be passed through to the terminal.

If the first line of command’s output is empty, or the command fails to execute, Newsboat will exit with an error. This is the most versatile of all the options, because it lets you emulate every other and more; let’s look at it in more detail.

For example, a user might want to store their password in a file encrypted by GPG. They create the file like that:

```bash
gpg --encrypt --default-recipient-self --output ~/.newsboat/password.gpg
```

They enter their password, press Enter, and finish the command by pressing `^D` (Control and d simultaneously). Then, they specify in their Newsboat config:

```
REMOTEAPI-passwordeval "gpg --decrypt ~/.newsboat/password.gpg"
```

Now every time they start Newsboat, GPG will be ran. It’ll probably ask for keyring password, then decrypt the file, and pass its contents to Newsboat, which will use it to authenticate with the remote API.
