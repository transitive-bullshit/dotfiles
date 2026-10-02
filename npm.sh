#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
: "${NVM_DIR:?Set NVM_DIR to your nvm directory before running npm.sh}"
cp "$repo_root/npm-default-packages" "$NVM_DIR/default-packages"
while IFS= read -r package; do
  [[ -z "$package" || "$package" == \#* ]] && continue
  npm install --global "$package"
done < "$repo_root/npm-default-packages"
