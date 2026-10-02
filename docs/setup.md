# Machine setup

Clone this repo and [skills](https://github.com/transitive-bullshit/skills) beside each other. Requires Git and Python 3.11+; install Python with Homebrew if missing. Use `--skills-repo` when the checkouts are elsewhere.

`agents/skills-revision` records the skills commit tested by CI. For a reproducible baseline, check out that revision; for everyday editing, use your normal skills branch and the compatible installer. When publishing coordinated changes, push that skills commit before dotfiles.

1. Inspect existing checkouts and installed configuration. Preserve local work on every machine; compare it before adopting the Git versions.
2. Restore Vim's pinned submodules with `git submodule update --init --recursive`. Review `./bootstrap.sh --dry-run`, then run it to link shell/editor files. For conflicts, `--adopt` makes a private backup; it never deletes the original. Open a new shell afterward.
3. Use `./brew.sh` and `./npm.sh` only when those machine-wide package changes are wanted. `npm.sh` requires `NVM_DIR`. Birdclaw and xurl are optional Homebrew flags; archive data, authentication, and jobs are provisioned separately.
4. Run `scripts/agent-env apply --profile mac --dry-run`, then apply. For the existing full MacBook selection, use `--profile current --adopt`. `--adopt` archives conflicting files and the old skills.sh lock. Finish with `scripts/agent-env doctor`.

`agents/profiles.json` selects the agent clients, required commands, and a named skill profile. To add optional groups, define a skill profile extending `mac` plus the desired groups in the skills repo, then reference it here. `agents/integrations.json` lists capabilities requiring separate authentication or runtime provisioning. Install desired marketplace plugins through their hosts; their caches are not portable config.

The installer links `agent-env` into `~/.local/bin`; the shell setup adds that directory to PATH.

## Everyday use

Edit linked skills/instructions or `agents/preferences.json`, then commit and push normally. On another machine, run `scripts/agent-env pull`; it preflights both repos, fast-forwards clean branches, restores pinned submodules, applies the installed profile, and checks it. Dirty/diverged checkouts require normal Git resolution first. It never commits, stashes, resets, or pushes.

Changes made through an app's settings UI can be reviewed with `scripts/agent-env export-config` and captured with `--write`. Only allowlisted portable fields are exported. `apply` preserves unrelated config and refuses to silently overwrite app-setting changes since its last receipt.

Installations are recorded under `~/.local/state/agent-env`. To undo an apply, use `scripts/agent-env restore --backup <id>`; later changes block restoration. Use `--target-home <temporary-directory> --skip-tools` for isolated file-layout checks.

Shell installation uses only `dotfiles.json`; new repository files do not become home-directory links automatically. `macos.sh` remains an optional, separately reviewed machine-wide customization.
