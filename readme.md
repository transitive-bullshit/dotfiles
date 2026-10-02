# Dev Environment

My shell, editor, and AI coding setup, shared across Macs through Git. Agent skills live in [skills](https://github.com/transitive-bullshit/skills).

## Get started

Give your coding agent this prompt:

```text
Set up this machine from transitive-bullshit/dotfiles and
transitive-bullshit/skills. Clone them beside each other, read their
AGENTS.md files, and follow dotfiles/docs/setup.md. Preserve existing
files and local edits. Use the mac profile, keep social/archive tools
optional, and finish with agent-env doctor.
```

Already cloned? Requires Python 3.11+:

```sh
scripts/agent-env apply --profile mac
scripts/agent-env doctor
```

Edit the linked files, commit and push normally. On another machine:

```sh
scripts/agent-env pull
```

[Setup and migration](docs/setup.md) · [Cloud setup](docs/cloud.md) · `scripts/agent-env --help`

[MIT](license) © [Travis Fischer](https://x.com/transitive_bs)
