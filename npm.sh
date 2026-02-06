#!/usr/bin/env bash

cp -f npm-default-packages $NVM_DIR/default-packages

# install default packages
grep -Ev '^(#|$)' npm-default-packages | xargs npm install -g --quiet
