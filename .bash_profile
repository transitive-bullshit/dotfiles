export PATH="/usr/local/sbin:$PATH";
export PATH="/opt/homebrew/bin:$PATH";
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="$HOME/dev/bin:$HOME/bin:$PATH";
export PATH="$PATH:$HOME/.cargo/bin";
export PATH="$PATH:$HOME/.local/bin";
export PATH="$PATH:/usr/local/opt/llvm/bin";
export PATH="$PATH:/Applications/MacVim.app/Contents/bin";
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin";
export PATH="$PATH:/Applications/Ghostty.app/Contents/MacOS";
export PATH="/usr/local/opt/python/libexec/bin:$PATH";

export BASH_SILENCE_DEPRECATION_WARNING=1
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
eval $(locale)

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{env,path,bash_prompt,exports,aliases,functions,extra,ai}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

#export PATH="$PATH:`python -m site --user-base`/bin";
#export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin/psql";

# Enable tab completion for `g` by marking it as an alias for `git`
#if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
#	complete -o default -o nospace -F _git g;
#fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
#[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Go
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
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#nvm use default

# TODO: this shouldn't be necessary
#export NODE_PATH=$NODE_PATH:`npm root -g`;

[ -s ~/.fig/exports/env.sh ] && source ~/.fig/exports/env.sh 

# Rust
#. "$HOME/.cargo/env"

# https://github.com/junegunn/fzf
eval "$(fzf --bash)"

# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init bash)"

source ~/.bash_prompt

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tfischer/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/tfischer/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tfischer/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/tfischer/Downloads/google-cloud-sdk/completion.bash.inc'; fi

# https://scipy.github.io/devdocs/building/index.html#system-level-dependencies
export PKG_CONFIG_PATH="/opt/homebrew/opt/openblas/lib/pkgconfig"

# Added by Windsurf
export PATH="/Users/tfischer/.codeium/windsurf/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/tfischer/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# bun end

# agentic
#export AGENTIC_API_BASE_URL="http://localhost:3001"
#alias a='AGENTIC_API_BASE_URL="http://localhost:3001" tsx /Users/tfischer/dev/modules/agentic/packages/cli/src/cli.ts'

# openclaw
eval "$(openclaw completion --shell bash)"
