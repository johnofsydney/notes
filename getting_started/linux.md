# Getting Started

## with a new Raspberry Pi 400

## The Basics

We have Debian based environment. Let's get up to date and have something to write with;

```sh
$ sudo apt update
$ sudo apt install code
```
Can you do everything with keyboad, and not with mouse? maybe but it's not what god intended when WIMP was invented. so to connect an apple wireless mouse

```sh
# turn off the mouse
$ bluetoothctl

[bluetooth]  scan on
# turn on the mouse

# hopefully you will see something like
[NEW] Device 30:D9:XX:XX:E7:27 Johns Own Mouse

and then then you can 
[bluetoothctl] connect 30:D9:XX:XX:E7:27
```

Next, connect to github.
Pop aloong to github.com and sign in.

```sh
# Create a new SSH key pair;
$ ssh-keygen -t ed25519 -C "your@email.com" # the email for your github account

# add this new key to your keychain
$ eval "$(ssh-agent -s)"
$ ssh-add ~/.ssh/id_ed25519
```

Then open up the github page
https://github.com/settings/keys
- click **New SSH Key**
- copy the text from `~/.ssh/id_ed25519.pub` and paste that in as the *Key*
- Use a *Title* that identifies the computer you're using


Clone some good repos
```sh
$ git clone git@github.com:johnofsydney/notes.git
$ git clone git@github.com:johnofsydney/settings.git
```
https://www.rosehosting.com/blog/how-to-install-ruby-on-rails-on-debian-11/
Add the following lines to `~/.bashrc`
```sh
source ~/Projects/John/settings/my_extensions.bash
source ~/Projects/John/settings/bash_prompt.bash
```

More git settings
```
$ git config --global user.name "Your Real Name"
$ git config --global user.email me@example.com
$ core.editor code --wait
```

## Install Ruby on Rails
https://www.rosehosting.com/blog/how-to-install-ruby-on-rails-on-debian-11/


Terminal needs to run as a login
`$ bash -l`
`$ rvm use 3.0.0`

To install Postgresql
`$ sudo apt install libpq-dev`

more pg stuff:
https://linuxhint.com/start-postgresql-linux/

`$ raspi-gpio get` to show GPIO information

[john@raspberrypi] ~/Projects/John/notes [master] 19:03:28
$ raspi-gpio set 23 op pn dh

[john@raspberrypi] ~/Projects/John/notes [master] 19:03:33
$ raspi-gpio set 23 op pn dl
