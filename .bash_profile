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

# Load the shell dotfiles every shell needs:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{env,path,exports,extra,ai}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

ulimit -Sn 4096;

# Go
export GOPATH=/usr/local/opt/go;
export PATH=$PATH:$GOPATH/bin;

# https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# https://scipy.github.io/devdocs/building/index.html#system-level-dependencies
export PKG_CONFIG_PATH="/opt/homebrew/opt/openblas/lib/pkgconfig"

# Added by Windsurf
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# bun end

# Everything below is for human terminals only. Agent tools (Claude Code, Codex)
# and scripts run commands without a terminal, so they keep stock `cd`, `ls`,
# `grep`, `diff` and globbing, plus a fast, quiet startup.
if [[ $- == *i* && -t 0 && -t 1 && -z ${CLAUDECODE-} && -z ${CODEX_THREAD_ID-} ]]; then
	for file in ~/.{aliases,functions}; do
		[ -r "$file" ] && [ -f "$file" ] && source "$file";
	done;
	unset file;

	# Case-insensitive globbing, appended history, and `cd` typo correction
	shopt -s nocaseglob histappend cdspell;

	# Add tab completion for `defaults read|write NSGlobalDomain`
	complete -W "NSGlobalDomain" defaults;
	[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash;
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

	# https://github.com/ajeetdsouza/zoxide
	# Silence the doctor warning, which non-interactive shells print on every `cd`
	export _ZO_DOCTOR=0
	eval "$(zoxide init bash)"

	# https://github.com/junegunn/fzf
	eval "$(fzf --bash)"

	source ~/.bash_prompt
fi
