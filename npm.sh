#!/usr/bin/env bash

# add default global packages to nvm so they'll automatically be installed when
# new versions of node are installed
cp -f npm-default-packages $NVM_DIR/default-packages

# install default packages globally
grep -Ev '^(#|$)' npm-default-packages | xargs npm install -g --quiet
