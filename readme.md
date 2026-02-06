# transitive-bullshit dotfiles

## NOTES

This is my customized version of *Mathias Bynens*' excellent MacOS bootstrap setup. Aside from some simple settings tweaks, it adds extensive Vim customization via Pathogen and a modified version of the [spf13](https://github.com/spf13/spf13-vim) Vim distribution. All pathogen plugins are submodules and must be initialized properly before running the `bootstrap` script.

## Installation

### Using Git and the bootstrap script

You can clone the repo wherever you want.

```bash
git clone https://github.com/fisch0920/dotfiles.git
cd dotfiles
git submodule init
git submodule update
source bootstrap.sh
```

To update, `cd` into your local `dotfiles` repo and then:

```bash
git submodule update
source bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
set -- -f; source bootstrap.sh
```

### Sensible OS X defaults

When setting up a new Mac, you may want to set some sensible OS X defaults:

```bash
./.macos
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
