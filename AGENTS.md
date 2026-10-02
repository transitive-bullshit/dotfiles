# Working here

This repo owns shell/editor setup and portable agent settings. The sibling `skills` repo owns skill files and the shared installer. For first-machine setup or migration, read `docs/setup.md`; for Codex Cloud, read `docs/cloud.md`.

Use explicit mappings in `dotfiles.json` and profiles in `agents/profiles.json`. Preserve existing files through the installers' preflight and backup paths. Keep credentials, caches, application state, and per-project settings outside portable preferences.

Run `python3 -m unittest discover -s tests` and `scripts/agent-env check --skills-repo ../skills` after installer/config changes. Keep READMEs extremely concise: a preview, copyable agent setup prompt, and essential commands. Code and CLI help are the source of truth.
