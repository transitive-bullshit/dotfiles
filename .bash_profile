export PATH="/usr/local/sbin:$PATH";
export PATH="/opt/homebrew/bin:$PATH";
export PATH="$HOME/dev/bin:$HOME/bin:$PATH";
export PATH="$PATH:$HOME/.cargo/bin";
export PATH="$PATH:$HOME/.local/bin";
export PATH="$PATH:/usr/local/opt/llvm/bin";
export PATH="$PATH:/Applications/MacVim.app/Contents/bin";

#export PATH="/usr/local/opt/python/libexec/bin:$PATH";
#export PATH="$PATH:`python -m site --user-base`/bin";
#export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin/psql";

export BASH_SILENCE_DEPRECATION_WARNING=1

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra,ai}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
#for option in autocd globstar; do
#	shopt -s "$option" 2> /dev/null;
#done;

# Add tab completion for many Bash commands
#if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
#	source "$(brew --prefix)/share/bash-completion/bash_completion";
#elif [ -f /etc/bash_completion ]; then
#	source /etc/bash_completion;
#fi;

# Enable tab completion for `g` by marking it as an alias for `git`
#if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
#	complete -o default -o nospace -F _git g;
#fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
#[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
#complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# GO
#export PATH="$PATH:/usr/local/opt/go/libexec/bin";
export GOPATH=/usr/local/opt/go;
export PATH=$PATH:$GOPATH/bin;

git config --global user.name "Travis Fischer";
git config --global user.email fisch0920@gmail.com;

if [ -f `brew --prefix`/etc/bash_completion ]; then
    source `brew --prefix`/etc/bash_completion
fi

if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash;
fi

# https://github.com/nvm-sh/nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
#nvm use default

# TODO: this shouldn't be necessary
#export NODE_PATH=$NODE_PATH:`npm root -g`;

# Automagical
#export GCLOUD_PROJECT='boosty-170514';
#export GOOGLE_APPLICATION_CREDENTIALS="$HOME/dev/keys/master.json";
# custom-built ffmpeg for ffmpeg-gl-transition (deprecated)
#export FFMPEG_PATH="/Users/tfischer/dev/temp/ffmpeg/ffmpeg";

# Saasify
#export GCLOUD_PROJECT='saasify';
#export GOOGLE_APPLICATION_CREDENTIALS="$HOME/dev/keys/saasify-2.json";


[ -s ~/.fig/exports/env.sh ] && source ~/.fig/exports/env.sh 

# Wasmer
#export WASMER_DIR="/Users/tfischer/.wasmer"
#[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# Rust
#. "$HOME/.cargo/env"

source ~/.bash_prompt

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tfischer/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/tfischer/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tfischer/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/tfischer/Downloads/google-cloud-sdk/completion.bash.inc'; fi

#export PATH="/Users/tfischer/Library/Application Support/edgedb/bin:$PATH"

# https://scipy.github.io/devdocs/building/index.html#system-level-dependencies
export PKG_CONFIG_PATH="/opt/homebrew/opt/openblas/lib/pkgconfig"

export PATH="/opt/homebrew/sbin:$PATH"

# Added by Windsurf
export PATH="/Users/tfischer/.codeium/windsurf/bin:$PATH"
