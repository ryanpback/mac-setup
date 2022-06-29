#!/bin/bash

LOG=$HOME/Library/Logs/dotfiles.log
DOTFILES_DIR=$HOME/.dotfiles
DOTFILES_CONFIG_DIR=$DOTFILES_DIR/config
ZSH_CONFIG_DIR=$HOME/.zsh
VIM_CONFIG_DIR=$HOME/.vim

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
}

cleanup_brew() {
  _process "Cleaning up brew"
  brew cleanup
}

install_fonts() {
  _process "Installing fonts"
  brew install --cask font-fira-code
}

install_dotfiles() {
  _process "Installing dotfiles repo"
  (
    if [ ! -d "$DOTFILES_DIR" ]; then
      git clone git@github-personal:ryanpback/dotfiles.git $DOTFILES_DIR
    else
      _process "Dotfiles repo already exists locally ... Pulling latest changes"
      cd $DOTFILES_DIR && git pull origin master
    fi
  )
}

link_dotfiles() {
    _process "Symlinking dotfiles"
  (
    cd $DOTFILES_DIR
    ./link-dotfiles.sh
  )
}

install_zsh_plugins() {
  _process "Installing Powerlevel10k"
  local powerlevel10kpath=$ZSH_CONFIG_DIR/powerlevel10k
  local zshzpath=$ZSH_CONFIG_DIR/zsh-z

  if [ ! -d $powerlevel10kpath ]; then
    mkdir -p $powerlevel10kpath
    (
      cd $powerlevel10kpath && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git .
    )
  else
    _process "Powerlevel10k already exists ... Pulling latest changes"
    (
      cd $powerlevel10kpath && git pull
    )
  fi

  _process "Installing zsh-z"
  if [ ! -d $zshzpath ]; then
    mkdir -p $zshzpath
    (
      cd $zshzpath && git clone https://github.com/agkozak/zsh-z.git .
    )
  else
    _process "zsh-z already exists ... Pulling latest changes"
    (
      cd $zshzpath && git pull
    )
  fi
}

install_vundle() {
  _process "Installing Vim Plugin Manager (Vundle)"
  local bundledownloadpath=$VIM_CONFIG_DIR/bundle
  local vundlepath=$bundledownloadpath/Vundle.vim

  if [ ! -d $vundlepath ]; then
    mkdir -p $vundlepath
    (
      cd $vundlepath && git clone https://github.com/VundleVim/Vundle.vim.git .
    )
  else
    _process "Vundle already exists ... Pulling latest changes"
    (
      cd $vundlepath && git pull
    )
  fi
}

install_vim_plugins() {
  _process "Installing vim plugins"
  vim -c 'PluginInstall' -c 'qa!' <<< "\n" >/dev/null 2>&1
}

set_macos_defaults() {
  _process "Installing default preferences"
  source $DOTFILES_CONFIG_DIR/.macos
}

# reboot() {
  # shutdown -r now
# }

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
# install_dotfiles
# link_dotfiles
install_zsh_plugins
install_vundle
install_vim_plugins
# Dont forget to install mindnode
# Install npm, nvm, yarn
# set_macos_defaults # this should be last. It requires a reboot
# reboot

# Apps:
# 1Password 7
# Better Snap Tool
# Charles?
# CopyClip 2
# Docker
# Git
# Github desktop
# GPG Keychain
# Grammarly
# Gsutil
# iTerm
# Itsycal
# Karabiner-elements
# Karabiner-eventViewer
# Krew
# Logitech options
# MindNode
# npm/node/nvm/yarn
# Postman
# Rbenv
# Spotify
# Stern
# Vscode
# XCode
# Zoom
