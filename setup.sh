#!/bin/bash

LOG="${HOME}/Library/Logs/dotfiles.log"

_process() {
  echo "$(date) PROCESSING:  $@" >> $LOG
  printf "$(tput setaf 6) %s...$(tput sgr0)\n" "$@"
}

_success() {
  local message=$1
  printf "%s✓ Success:%s\n" "$(tput setaf 2)" "$(tput sgr0) $message"
}

link_configs() {
  _process "-> Linking dotfiles"
}

_process "-> Building Macbook ... This may take a bit"
