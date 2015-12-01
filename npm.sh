#!/usr/bin/env bash

# Install global command-line tools using npm.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

npm update

# install useful command-line tools
npm install -g gulp
npm install -g bower
npm install -g standard
npm install -g less
npm install -g tape
npm install -g castnow
npm install -g spoof
npm install -g jshint
npm install -g node-inspector
npm install -g typescript

# install some of the most common node dependencies globally just in case i'm 
# on a remote island without internet getting attacked by zombies with lasers 
# and need to hack some codez to save the dayz
npm install -g cordova ionic
npm install -g request
npm install -g async
npm install -g cheerio
npm install -g express
npm install -g browserify
npm install -g underscore
npm install -g mongodb
npm install -g mongoose
npm install -g redis
npm install -g chalk
npm install -g colors
npm install -g q
npm install -g bcrypt
npm install -g glob
npm install -g http-server
npm install -g phantomjs
npm install -g rimraf
npm install -g inherits
npm install -g extends
npm install -g moment
npm install -g debug
npm install -g once
npm install -g dotenv
