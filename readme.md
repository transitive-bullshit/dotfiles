# transitive-bullshit dotfiles

## Installation

### Using Git and the bootstrap script

You can clone the repo wherever you want.

```bash
git clone https://github.com/transitive-bullshit/dotfiles.git
cd dotfiles
git submodule update --init --recursive
source bootstrap.sh
```

To update, `cd` into your local `dotfiles` repo and then:

```bash
./bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
set -- -f; ./bootstrap.sh
```

### Git submodules

Submodules are pinned snapshots of upstream repositories. A detached `HEAD` inside
a submodule is expected; local branches or changes are not. Make changes in the
upstream repository, then update the pinned commit here.

After cloning or pulling the parent repository, restore every submodule to the
exact commit recorded by the parent:

```bash
git submodule sync --recursive
git submodule update --init --recursive
git status
git submodule status --recursive
```

To intentionally update one snapshot, fetch its upstream repository, select an
upstream commit, and commit the changed submodule pointer in this repository.
For example, replace the path and branch below as needed:

```bash
git -C .vim/bundle/nerdtree fetch origin
git -C .vim/bundle/nerdtree switch --detach origin/master
git diff --submodule=log
git add .vim/bundle/nerdtree
git commit -m "Update nerdtree submodule"
git push --recurse-submodules=check origin master
```

If a submodule is reported as modified, inspect it before doing anything else:

```bash
git -C .vim/bundle/nerdtree status
```

When there are definitely no local changes to preserve, rebuild incomplete or
damaged submodule worktrees from the pinned commits with:

```bash
git submodule update --init --recursive --force
```

Do not use `git p` for routine synchronization. It pulls `origin/master` inside
every submodule, bypassing the pinned snapshots recorded by the parent repository.

### Sensible macOS defaults

When setting up a new Mac, you may want to set some sensible defaults:

```bash
./macos.sh
```

### Install Homebrew formulae

Using [Homebrew](http://brew.sh/):

```bash
./brew.sh
```

### Install Global NPM packages

Using `nvm`:

```bash
./npm.sh
```

### Environment variables

```bash
cp -f ~/.env.example ~/.env
```

These env variables will be sourced by the shell initialization script, but the values aren't committed to git, so you'll need to fill in any relevant values manually.

## License

MIT © [Travis Fischer](https://x.com/transitive_bs)
