# Getting Started

## with a new Mac

- BREW: install home-brew from: https://brew.sh/
- XCODE: `$ xcode-select --install`

Install applications

```sh
$ brew install iterm2      # basic terminal
$ brew install --cask warp # different terminal
$ brew install git
$ brew install git-recent

# Browsers
$ brew install --cask firefox
$ brew install --cask google-chrome
$ brew install --cask brave-browser

# Editors
$ brew install --cask visual-studio-code
$ brew install --cask rubymine

# Helpful apps
$ brew install bat              # a better cat
$ brew install ag               # Silver Searcher; a faster grep
$ brew install --cask spotify
$ brew install --cask postman   # API client
$ brew install --cask paw       # different API client
$ brew install --cask rectangle # excellent window manager
$ brew install fzf              # fuzzy find, better terminal recall
$ $(brew --prefix)/opt/fzf/install

# maybes
$ brew install httpie # a better curl
$ brew install tldr   # summarise articles
$ brew install --cask clipy

```

Updates and Maintenance

```sh
$ brew update
$ brew upgrade
$ softwareupdate --install --all
$ brew cleanup
```

- OTHERS:

- GIT SETTINGS:

  - Set the global settings like this; (personal folders can have their own settings)

    ```sh
    $ git config --global user.name "Your Real Name"
    $ git config --global user.email me@example.com
    $ git config --global core.editor code --wait
    $ git config --global core.excludesfile /Users/<username>/.gitignore_global
    $ git config --global pull.rebase false
    $ git config --global color.ui true
    $ git config --global fetch.prune true
    $ git config --global init.defaultBranch main
    $ git config --global --add push.default current
    $ git config --global --add push.autoSetupRemote true
    $ git config --global --add merge.ff true
    # when possible resolve the merge as a fast-forward (only update the branch pointer to match the merged branch; do not create a merge commit)

    $ git config --list
    ```

- Get settings / dot files / notes / GITHUB:
- login to https://github.com/johnofsydney

  - Make a personal folder (eg ~/Projects/John)
  - Clone settings: https://github.com/johnofsydney/settings
  - Clone notes: https://github.com/johnofsydney/notes
    For accessing repos via SSH
  - create a public / private key pair. Paste the publie one into github
    - https://github.com/settings/keys
    - docs https://docs.github.com/en/authentication/connecting-to-github-with-ssh
      For accessing repos via HTTPS
    - create a token with appropriate permissions
      - https://github.com/settings/tokens
    - use it in place of password
    - docs: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

- SHELL

  - for warp, Oh-my-zsh is not required. look for PS1 settings here: `bash_prompt.bash`
  - get ohmyzsh
    - sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  - The following shell files should be loaded (add them to .zshrc)
    source ~/Projects/John/settings/my_extensions.bash
    source ~/Projects/John/settings/work_aliases.bash
    source ~/Projects/John/settings/work_functions.bash

    ```

    ```

  - rbenv requires to be the last thing in .zshrc;
    ```sh
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    ```

Use Homebrew to install;

```sh
$ brew install rbenv ruby-build postgres redis cask

# and maybe these
$ brew install rbenv-gemset postgis shared-mime-info graphviz imagemagick
$ brew install fig # does not work with warp
$ fig

# and then pin;
brew pin postgresql
# run brew list --pinned to show pinned packages


```

- NODE / NVM

  - Open terminal, install NVM from: https://github.com/nvm-sh/nvm#installing-and-updating
  - Install Node v15.14.0 by running nvm install 15.14.0
  - Switch to the last installed Node by running nvm use 15.14.0

- RUBY / RVM
  - rbenv install 2.7.3 (install ruby version)
  - rbenv init
  - Add this to bash profile so you can access rbenv $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  - Set default version to 2.7.3 — rbenv global 2.7.3

### Links

https://gorails.com/setup/osx/12-monterey

## with a new company

- `$ gem install bundler`
- `$ brew services start postgresql` (always start server)
- `$ brew services start redis` (always start redis server)
- `$ bundle config gems.contribsys.com <sidekiq-pro-key>`
- `$ bundle install`
- `$ bundle exec rails db:create to create a new db
- `$ psql -d <database_name> < path/dump_name.sql`
- `$ bundle exec rails db:migrate`
- `$ bundle exec rails server

## General work notes

### Loading Database Dump

Get the latest database dump and insert it into your local dev database:
`$ psql -d <database_name> < path/to/dump_name.sql`

alternative:
`$ psql -U db_user db_name < dump_name.sql`

### If rails won't restart

https://stackoverflow.com/questions/24627701/a-server-is-already-running-check-tmp-pids-server-pid-exiting-rails
Restarting rails server when crashed and still running;
`$ rm /your_project_path/tmp/pids/server.pid`
`$ bundle exec rails server`

### If postgres won't restart

https://stackoverflow.com/questions/36436120/fatal-error-lock-file-postmaster-pid-already-exists

1. Delete the postmaster.pid file:
   `$ rm /opt/homebrew/var/postgresql/postmaster.pid` # M1 Mac
   `$ rm /usr/local/var/postgres/postmaster.pid` # for older Mac
   `$ rm $(brew --prefix)/var/postgres/postmaster.pid` # for either? untested
2. Restart your postgres:
   `$ brew services restart postgresql`

### To restart redis:

`$ brew services restart redis`
