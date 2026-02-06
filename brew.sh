#!/usr/bin/env bash

# Install command-line tools using Homebrew

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated)
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`
brew install coreutils

# Install some other useful utilities like `sponge`
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed
# Install Bash 4
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

# Install more recent versions of some macOS tools
brew install vim
brew install grep
brew install openssh
brew install screen
brew install wget
brew install gnupg
brew install imagemagick

# Install other useful binaries
brew install git
brew install git-lfs
brew install lua
brew install tree
brew install httpie
brew install jq
brew install gh
brew install ripgrep
brew install llm
brew install rust
brew install fzf
brew install yt-dlp
brew install zoxide

# JS/TS
brew install nvm
brew install bun

# Python
brew install poetry
brew install scipy

# https://github.com/jordanbaird/Ice
brew install jordanbaird-ice

# Third-party SDKs
brew install google-cloud-sdk
brew install stripe/stripe-cli/stripe

# AI-oriented cli tools
brew install steipete/tap/bird
brew install steipete/tap/gifgrep
brew install steipete/tap/gogcli
brew install steipete/tap/goplaces
brew install steipete/tap/summarize

# Larger tools
brew install tw93/tap/mole
brew install ffmpeg

# Remove outdated versions from the cellar
brew cleanup
