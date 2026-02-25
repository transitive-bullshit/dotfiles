#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function doIt() {
	local DOTFILES_DIR
	DOTFILES_DIR="$(pwd)"

	local EXCLUDES=(
		".git"
		".gitignore"
		".env"
		".DS_Store"
		"bootstrap.sh"
		"macos.sh"
		"npm.sh"
		"brew.sh"
		"license"
		"npm-default-packages"
		"brew-default-packages"
		"CLAUDE.md"
		"AGENTS.md"
		"readme.md"
	)

	for item in "$DOTFILES_DIR"/.[^.]* "$DOTFILES_DIR"/*; do
		[ -e "$item" ] || continue

		local name
		name="$(basename "$item")"

		local skip=false
		for exclude in "${EXCLUDES[@]}"; do
			if [[ "$name" == "$exclude" ]]; then
				skip=true
				break
			fi
		done
		$skip && continue

		local target="$HOME/$name"

		if [ -L "$target" ]; then
			rm -f "$target"
		elif [ -e "$target" ]; then
			rm -rf "$target"
		fi

		ln -s "$item" "$target"
	done

	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
