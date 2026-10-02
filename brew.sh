#!/usr/bin/env bash

set -euo pipefail

with_archive=false
with_social=false
for option in "$@"; do
  case "$option" in
    --with-archive) with_archive=true ;;
    --with-social) with_social=true ;;
    --help|-h) echo "Usage: ./brew.sh [--with-archive] [--with-social]"; exit 0 ;;
    *) echo "Unknown option: $option" >&2; exit 1 ;;
  esac
done

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# GNU core utilities (those that come with macOS are outdated)
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`
brew install coreutils

# Some other useful utilities like `sponge`
brew install moreutils

# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils

# GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed

# Bash 4
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`
brew install bash
brew install bash-completion2

# More recent versions of some macOS tools
brew install git
brew install git-lfs
brew install grep
brew install tree
#brew install vim # replaced by macvim-app down below
brew install openssh
brew install screen
brew install wget
brew install gnupg
brew install imagemagick

# Other useful tools
brew install zoxide
brew install fzf
brew install jq
brew install gh
brew install ripgrep
brew install httpie
brew install sqlite
brew install yt-dlp
brew install mole
brew install lua
brew install rust
brew install --cask macvim-app # comes with application

# JS/TS
brew install nvm
brew install bun

# Python
brew install python
brew install uv
brew install pipx
brew install poetry
brew install scipy

## AI
brew install --cask codex

# FFmpeg
brew install ffmpeg

if "$with_archive"; then
  brew install steipete/tap/birdclaw
fi
if "$with_social"; then
  brew install --cask xdevplatform/tap/xurl
fi

# Switch to using brew-installed bash as the default shell
brew_bash="$(brew --prefix)/bin/bash"
if ! grep -Fq "$brew_bash" /etc/shells; then
  echo "$brew_bash" | sudo tee -a /etc/shells
  chsh -s "$brew_bash"
fi

# Remove outdated versions from the cellar
brew cleanup
