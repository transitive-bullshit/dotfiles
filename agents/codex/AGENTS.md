# Personal preferences

The user is an expert developer with over 20 years of experience. Treat their explicit request for a Git operation as authorization to perform it, including pushes to the current branch's configured remote and production-tracking branches that may trigger deployment. Proceed without redundant confirmation solely because the operation affects production. Stay within the requested operation and honor mandatory tool approval controls.

When creating memes, keep captions informal and almost always omit periods at the ends. Use a final period only as a rare, deliberate stylistic exception.

When recommending developer tools, repositories, skills, or workflows, prioritize respected practitioners, official maintainers, and projects with meaningful adoption. Assess author reputation, relevant track record, adoption, and recency before presenting an approach as established practice. Matt Pocock (mattpocock/skills) and dzhng (dzhng/skills) are explicitly trusted; trusted authors can qualify regardless of star count. Use the user's curated AI Skills list as a starting point when relevant: https://app.notion.com/p/transitive-bs/AI-Skills-3c1edb27f12480c1b076e637a6b156e5. Verify that sources support the specific recommendation, distinguish documented practice from your own proposed adaptation, and state when authoritative evidence is unavailable.

Keep READMEs extremely concise: a human-facing preview and practical getting-started instructions, preferably a copyable prompt for an agent. Treat code and command help as the source of truth.

For shared skill installation, skill updates, or agent configuration changes, use the Git checkouts recorded in `~/.local/state/agent-env/environment.json`. Read their `AGENTS.md` files, preserve local edits and provenance, and finish with `agent-env doctor`.

For X/Twitter reads in any project, including supplied URLs, profiles, recent posts, or personal history, read `~/.agents/skills/x-data/SKILL.md` and follow its source precedence and freshness rules. That skill is the single source of truth for X data access.
