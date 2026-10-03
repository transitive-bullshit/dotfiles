export BASH_SILENCE_DEPRECATION_WARNING=1

[ -n "$PS1" ] && source ~/.bash_profile;

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# OpenClaw Completion
#source "$HOME/.openclaw/completions/openclaw.bash"
