#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install all default Homebrew packages
while read -r package; do
  brew install "$package"
done < <(grep -Ev '^(#|$)' brew-default-packages)

# Switch to using brew-installed bash as the default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

# Remove outdated versions from the cellar
brew cleanup
