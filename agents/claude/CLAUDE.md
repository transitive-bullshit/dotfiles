# Global instructions

## Browser media hygiene

- When researching YouTube or other audio/video pages, prefer WebFetch or the browser's `get_page_text` / `read_page` over leaving a media page open.
- If you do open a media page in a browser pane, pause all playback right away (e.g. run `document.querySelectorAll('video,audio').forEach(m => m.pause())`) and close the tab as soon as you're done with it. Never leave a media tab open in the background — autoplay can start unrelated audio the user can't trace back to a session.

Keep READMEs extremely concise: a human-facing preview and practical getting-started instructions, preferably a copyable prompt for an agent. Treat code and command help as the source of truth.

For shared skill installation, skill updates, or agent configuration changes, use the Git checkouts recorded in `~/.local/state/agent-env/environment.json`. Read their `AGENTS.md` files, preserve local edits and provenance, and finish with `agent-env doctor`.
