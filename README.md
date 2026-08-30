# developer-workflow

Personal agent engineering stack for Cursor, Codex, and Claude Code.

**→ See [STACK-2026.md](STACK-2026.md) for the full 2026 layer architecture, install commands, and conflict warnings.**

**→ See [PRAXSTACK-SKILLS.md](PRAXSTACK-SKILLS.md) for the praxstack/skills-and-personas portfolio, persona catalog, and replay install commands.**

**→ See [CLOUD-WORKFLOW.md](CLOUD-WORKFLOW.md) for cloud-first agent work (Origin + GitHub, VM bootstrap, PR flow).**

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
- **Compound Engineering**: Codex → `codex plugin add compound-engineering@compound-engineering-plugin` (done v3.23.4). Cursor → `/add-plugin compound-engineering`
- **gstack**: ✅ Installed via `~/.agents/plugins/gstack` — `./setup --host cursor` and `./setup --host codex` (55 skills each)

## Cursor Origin (hosted git)

Origin CLI installed to `~/.local/bin/origin` (2026.08.24). **Auth pending:**

```bash
~/.local/bin/origin auth login   # one-click browser sign-in
~/.local/bin/origin repo list    # verify after login
# Optional: origin repo create developer-workflow
```

GitHub copy remains at this repo; Origin is for Cursor-hosted git at `origin.cursor.com`.

## Setup status (2026-08-29 audit)

| Item | Status |
| --- | --- |
| Portable skills (~/.agents/skills) | ✅ ~1184 entries |
| gstack (cursor + codex) | ✅ |
| compound-engineering (Codex) | ✅ |
| compound-engineering (Cursor) | ⏳ `/add-plugin` |
| pstack | ⏳ `/add-plugin` + `/setup-pstack` |
| spec-kit CLI | ✅ v1.0.1 |
| MoA-X offline tests | ✅ 139/139 |
| graphify on moa-x | ✅ graphify-out/ |
| Origin CLI | ✅ installed, auth pending |
| `/env-setup` skill | ❌ not on this machine |

**Env verification stand-in** (no env-setup skill): `install_deps.py` + `test_offline.py` in moa-x.

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

1. **Origin auth**: `~/.local/bin/origin auth login`
2. **Cursor plugins**: `/add-plugin pstack` → `/setup-pstack`; `/add-plugin compound-engineering`
3. CLI credentials for full MoA runs (Qwen, OpenCode, AGY)
4. Mem0 MCP auth (`MEM0_API_KEY`)
5. Matt Pocock: pick Claude plugin **or** portable skills, not both
6. Microsoft skills: install selectively (context rot if loading all 175)
7. `/env-setup` skill: not installed locally — provide or accept moa-x preflight as substitute

## Links

- [Trail of Bits skills](https://github.com/trailofbits/skills)
- [Vercel agent-browser](https://github.com/vercel-labs/agent-browser)
- [Spec Kit](https://github.com/github/spec-kit)
- [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)
- [pstack](https://github.com/cursor/plugins/tree/main/pstack)
- [gstack](https://github.com/garrytan/gstack)
