export BASH_SILENCE_DEPRECATION_WARNING=1

[ -n "$PS1" ] && source ~/.bash_profile;

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="/Users/tfischer/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
