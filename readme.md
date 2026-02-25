# transitive-bullshit dotfiles

## Installation

### Using Git and the bootstrap script

You can clone the repo wherever you want.

```bash
git clone https://github.com/transitive-bullshit/dotfiles.git
cd dotfiles
git submodule init
git submodule update
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
