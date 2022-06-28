#!/bin/bash

LOG="${HOME}/Library/Logs/dotfiles.log"

_process() {
  echo "$(date) PROCESSING: -> $@" >> $LOG
  printf "$(tput setaf 6) %s...$(tput sgr0)\n" "$@"
}

_success() {
  local message=$1
  printf "%s✓ Success:%s\n" "$(tput setaf 2)" "$(tput sgr0) $message"
}

set_default_shell() {
  _process "Setting default shell to zsh"
  if [ $SHELL != "/bin/zsh" ]; then
    chsh -s /bin/zsh
    zsh
  else
    _process "Shell already set to zsh"
  fi
}

gen_ssh_key() {
  local sshidpath=~/.ssh/id_rsa
  _process "Generating SSH key at $sshidpath"

  if [ ! -f $sshidpath ]; then
    # Generate an SSH key. Send 'n' to prompt if asked to overwrite current file if it already exists
    #  <<< n >/dev/null 2>&1 - add to end of next line if not running in conditional. This will
    # ensure the generated key does not overwrite the existing key
    ssh-keygen -t rsa -b 4096 -N '' -f $sshidpath
  else
    _process "id_rsa file already exists"
  fi
}

install_xcode_tools() {
  _process "Installing xcodey things"
  xcode-select --install
}

install_homebrew() {
    _process "Installing homebrew"
  if test ! $(which brew); then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    _process "Homebrew already exists"
  fi
}

update_homebrew() {
  _process "Updaing homebrew"
  brew update
}

install_git() {
  brew install git

  _process "Installing git utilities"
  brew install git-extras

  _process "Setting default git configuration"
  git config --global user.name "Ryan Back"
  git config --global user.email ryanpback@gmail.com
  git config --global pull.ff true
  git config --global pull.rebase true
  git config --global core.editor "code --wait"
  # I don't think I need this, but it was in my original global git config 🤷‍♂️
  # git config --global filter.lfs.clean "git-lfs clean -- %f"
  # git config --global filter.lfs.smudge "git-lfs smudge -- %f"
  # git config --global filter.lfs.process "git-lfs filter-process"
  # git config --global filter.lfs.required true
}

brew_installs() {
  _process "Installing brew packages"

  brew install \
    ack \
    bat \
    certbot \
    fzf \
    gawk \
    git-secret \
    gnu-sed \
    gnupg \
    gnutls \
    htop \
    jo \
    jq \
    kind \
    kubectx \
    kubernetes-cli \
    mysql \
    openssl@1.1 \
    postgresql \
    protobuf \
    rbenv \
    ruby-build \
    stern \
    tldr \
    trash \
    tree \
    wget \
    zsh-autosuggestions \
    zsh-syntax-highlighting

  TODO: Set postgres user and db
}

cleanup_brew() {
  _process "Cleaning up brew"
  brew cleanup
}

install_fonts() {
  _process "Installing fonts"
  brew install --cask font-fira-code
}

install_and_link_dotfiles() {
  _process "Installing dotfiles repo"
  local dotfiles_dir=$HOME/.dotfiles

  (
    if [ -d "$dotfiles_dir" ]; then
      _process "Dotfiles repo already exists locally. Pulling latest changes"
      cd $dotfiles_dir && git pull origin master
    else
      git clone git@github-personal:ryanpback/dotfiles.git $dotfiles_dir
    fi

    _process "Symlinking dotfiles"
    cd $dotfiles_dir
    ./link-dotfiles.sh
  )
}

install_zsh_plugins() {
  _process "Installing Powerlevel10k"
  local zshdownloadpath=~/.zsh
  local powerlevel10kpath=$zshdownloadpath/powerlevel10k
  local zshzpath=$zshdownloadpath/zsh-z

  if [ ! -d $powerlevel10kpath ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $zshdownloadpath
  else
    _process "Powerlevel10k already exists"
    (
      cd $powerlevel10kpath && git pull
    )
  fi

  _process "Installing zsh-z"
  if [ ! -d $zshzpath ]; then
    git clone https://github.com/agkozak/zsh-z.git $zshdownloadpath
  else
    _process "zsh-z already exists"
    (
      cd $zshzpath && git pull
    )
  fi
}

install_vim_plugins() {
  _proceess "Installing Vim Plugin Manager (Vundle)..."
  local bundledownloadpath=~/.vim/bundle
  local vundlepath=$bundledownloadpath/Vundle.vim

  if [ ! -d $vundlepath ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git $vundlepath
  else
    _process "Vundle already exists"
    (
      cd $vundlepath && git pull
    )
  fi

  _process "Installing plugins from .vimrc"
  vim -c 'PluginInstall' -c 'qa!' <<< "\n" >/dev/null 2>&1
}

set_macos_defaults() {
  _process "Installing default preferences"
  source ~/.dotfiles/config/.macos
}

_process "Building Macbook. This may take a bit"
# set_default_shell
# gen_ssh_key
# install_xcode_tools
# install_homebrew
# update_homebrew
# install_git
# brew_installs
# cleanup_brew
# install_fonts
# install_and_link_dotfiles
# install_zsh_plugins
# install_vim_plugins
# Dont forget to install mindnode
# set_macos_defaults # this should be last. It requires a reboot
