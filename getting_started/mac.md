# Getting Started

## with a new Mac
- BREW: install home-brew from: https://brew.sh/
- XCODE: `$ xcode-select --install`

- WARP: `brew install --cask warp`

- OTHERS:

- GIT SETTINGS:
  - Set the global settings like this; (personal folders can have their own settings)
    ```
    $ git config --global user.name "Your Real Name"
    $ git config --global user.email me@example.com
    ```
    ```
    core.editor=code --wait
    core.excludesfile=/Users/john.coote/.gitignore_global
    user.name=John Coote
    user.email=john.coot@email.com
    init.defaultbranch=main
    pull.rebase=false
    ```

- GITHUB: login to https://github.com/johnofsydney
  - Make a personal folder
  - Will need to authenticate keys for new machine: https://github.com/settings/keys
  - Clone settings: https://github.com/johnofsydney/settings
  - Clone notes: https://github.com/johnofsydney/notes
  - https://docs.github.com/en/authentication/connecting-to-github-with-ssh

- SHELL
  - Maybe oh-my-zsh is NOT required?
    - If no, then look for PS1 settings here: `bash_prompt.bash`
  - The following shell files should be loaded
    ```
    source ~/Projects/John/settings/my_extensions.bash> scan on
    source ~/Projects/John/settings/work_aliases.bash
    source ~/Projects/John/settings/work_functions.bash
    ```
  - rbenv requires to be the last thing in .zshrc;
    ```
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    ```



Use Homebrew to install;
```
$ brew install rbenv ruby-build postgres redis cask

# and maybe these
$ brew install rbenv-gemset postgis shared-mime-info graphviz imagemagick
$ brew install fig
$ fig

# and then pin;
brew pin postgresql
# run brew list --pinned to show pinned packages


```


- CAT/BAT: `brew install bat`

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

### If rails won't restart
https://stackoverflow.com/questions/24627701/a-server-is-already-running-check-tmp-pids-server-pid-exiting-rails
Restarting rails server when crashed and still running;
`$ rm /your_project_path/tmp/pids/server.pid`
`$ bundle exec rails server`

### If postgres won't restart
https://stackoverflow.com/questions/36436120/fatal-error-lock-file-postmaster-pid-already-exists
1. Delete the postmaster.pid file:
  `$rm /opt/homebrew/var/postgresql/postmaster.pid` # M1 Mac
  `$rm /usr/local/var/postgres/postmaster.pid` # for older Mac
2. Restart your postgres:
  `$ brew services restart postgresql`