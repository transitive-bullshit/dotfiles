#!/usr/bin/env bash

cp -f nvm-default-packages $NVM_DIR/default-packages

# install default packages
grep -Ev '^(#|$)' nvm-default-packages | xargs npm install -g --quiet
