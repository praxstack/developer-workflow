# developer-workflow

Personal agent engineering stack for Cursor, Codex, and Claude Code.

## Core methodology (pick one per task)

| Layer | Tool | Install |
| --- | --- | --- |
| Discovery | find-skills | `npx skills@latest add vercel-labs/skills --skill find-skills -g -a cursor -a codex -a claude-code -y` |
| Spec / product | gstack, Spec Kit, or Compound Engineering | See links below |
| Interrogation | Matt Pocock + shadcn/improve | Portable skills via `npx skills add` |
| Implementation | pstack + Superpowers | Cursor `/add-plugin pstack`; Superpowers plugin or portable skills |
| Review / security | Superpowers, Matt Pocock, Trail of Bits | Portable skills |
| Browser QA | agent-browser | `npm i -g agent-browser && agent-browser install` |
| Ship | gstack / CI | gstack `./setup` |
| Compound learning | Compound Engineering | `/add-plugin compound-engineering` in Cursor |

## Installed portable skills (~/.agents/skills)

Installed 2026-08-29 for `cursor`, `codex`, `claude-code`:

- `find-skills` (vercel-labs/skills)
- `improve` (shadcn/improve)
- `mattpocock/skills` (full pack)
- `obra/superpowers` (full pack)
- `vercel-labs/agent-skills` (React/Next/web-design)
- `vercel-labs/agent-browser`
- `trailofbits/skills` (security)
- `github/awesome-copilot` (toolbox)
- `anthropics/skills` (reference subset)

CLI: `agent-browser` v0.35.1, `specify-cli` v1.0.1 (`uv tool install specify-cli`).

## Native plugins (manual)

These require host UI — not fully CLI-automatable:

- **pstack**: Cursor → `/add-plugin pstack` → `/setup-pstack`
- **Superpowers**: Cursor → `/add-plugin superpowers` (or use portable skills, not both on Claude)
- **Compound Engineering**: Cursor marketplace or Codex plugin flow
- **gstack**: `git clone https://github.com/garrytan/gstack.git && ./setup --host cursor` (verify Cursor host support on your version)

## Stack-specific cartridges (install per project)

```bash
npx skills@latest add supabase/agent-skills --skill '*' -g -a cursor -a codex -a claude-code -y
npx skills@latest add cloudflare/skills --skill '*' -g -a cursor -a codex -a claude-code -y
npx skills@latest add aws/agent-toolkit-for-aws/skills --skill '*' -g -a cursor -a codex -a claude-code -y
```

## MoA-X reference project

- Repo: https://github.com/drivelineresearch/moa-x
- Preflight: `python3 harness/scripts/install_deps.py`
- Offline tests: `python3 harness/scripts/test_offline.py` (139 tests)
- Web UI: `MOA_WEBUI_GITHUB_OWNER=<user> python3 -m harness.webui` → http://127.0.0.1:7340
- Graph map: run `/graphify` → `graphify-out/graph.html`

## Manual gaps

1. CLI credentials for full MoA runs (Qwen, OpenCode, AGY)
2. Mem0 MCP auth (`MEM0_API_KEY`)
3. Matt Pocock: pick Claude plugin **or** portable skills, not both
4. Microsoft skills: install selectively (context rot if loading all 175)

## Links

- [Trail of Bits skills](https://github.com/trailofbits/skills)
- [Vercel agent-browser](https://github.com/vercel-labs/agent-browser)
- [Spec Kit](https://github.com/github/spec-kit)
- [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)
- [pstack](https://github.com/cursor/plugins/tree/main/pstack)
- [gstack](https://github.com/garrytan/gstack)
