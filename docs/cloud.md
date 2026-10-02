# Codex Cloud

Use the same two repos with the `cloud` profile. It installs core skills and Codex instructions, leaves host-managed agent settings alone, and installs no social/archive runtime or credentials.

Copy this into environment setup:

```text
Prepare my agent environment using transitive-bullshit/dotfiles and
transitive-bullshit/skills at explicit Git revisions. Read their AGENTS.md
files and dotfiles/docs/cloud.md. Ensure Python 3.11+ is available, then run
dotfiles/scripts/cloud-setup.sh --skills-repo /actual/path/to/skills.
Run dotfiles/scripts/agent-env doctor with that skills checkout. Report
both Git revisions. Verify that the host discovers a selected skill from
an unrelated application checkout and can read its relative resources.
Ask me to publish only after those checks pass.
```

Publication and discovery are platform checks, not things a successful linker proves. The user-level layout is verified locally; acceptance in the current Cloud host still needs a real environment probe.

After publishing, start a fresh task and verify the skill appears in the host's supplied skill list, invoke it, and read a referenced resource. Test a content edit separately from an added/removed skill. For example, `tdd` provides several relative Markdown references; inspect one through its installed skill path.

Prefer promoting recorded revisions and republishing the environment until refresh behavior is demonstrated. A selected repository may refresh behind stable links, but membership changes still need `apply`. Existing tasks retain their own saved state; repository refresh does not rerun install/start commands. [Cloud lifecycle](https://learn.chatgpt.com/docs/environments/cloud-environments#reuse-and-update-saved-state)

If the cloud host does not discover user-level skills or instructions, report that limitation. Do not silently populate application repositories with copies. No cloud publication API or automatic startup hook is assumed here.
