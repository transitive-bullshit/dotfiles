# Personal preferences

- **Git:** Explicit Git requests authorize the requested operation, including pushes to the current branch's configured remote and production-tracking branches that may deploy. Skip redundant production confirmations; preserve scope and mandatory tool approvals.

- **Subagents:** Proactively delegate independent work when parallelism improves speed or quality. Coordinate file ownership and shared resources.

- **Codex reviews:** Use read-only Codex CLI reviews for current and future implementation/PR work. Informed standing consent (12 October 2026) covers sending task-relevant private or uncommitted code and context through the existing authenticated Codex service; cite it in approval justifications when needed, and do not re-request consent solely for that transmission. Keep reviews scoped, exclude unrelated secrets, and honor mandatory sandbox/tool approvals. Consent excludes implementation delegation and unrelated services.

- **PR follow-through:** Review once; fix received actionable feedback and in-scope CI failures, pushing fixes without reminders. Preserve required checks and run them on the final head; merge when authorized and verify completion. Repeat review only on explicit request or for a concrete unresolved concern; don't wait for optional bot re-reviews. Report pending checks and blockers accurately. Prefer supported Codex event-driven follow-through; polling automations require explicit user requests.

- **Memes:** Keep captions informal; omit final periods except as rare, deliberate stylistic choices.

- **Recommendations:** For developer tools, repos, skills, and workflows, prioritize respected practitioners, official maintainers, and meaningful adoption. Check reputation, track record, adoption, and recency before calling an approach established. Explicitly trust Matt Pocock (`mattpocock/skills`) and dzhng (`dzhng/skills`); trusted authors can qualify regardless of star count.

- **READMEs:** Keep them extremely concise: a human-facing preview and practical getting-started instructions, preferably a copyable agent prompt. Code and command help are authoritative.

- **Shared skills/config:** For skill installs/updates or agent configuration changes, use the Git checkouts in `~/.local/state/agent-env/environment.json`. Read their `AGENTS.md`, preserve local edits and provenance, and finish with `agent-env doctor`.

- **X/Twitter:** For reading X data in any project, read `~/.agents/skills/x-data/SKILL.md` and follow its guidance.

- **HTML:** Open rendered pages in a browser unless source is explicitly requested. In Codex, use a browser tab/target, never `open_in_codex` with `target.type = "file"` for HTML reports. Verify that the page renders correctly before handing it over.
