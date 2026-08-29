# Environment setup status

**Last verified:** 2026-08-29 23:45 (moa-x workspace, Prax)

## Completed

| Item | Evidence |
| --- | --- |
| MoA-X offline tests | `python3 harness/scripts/test_offline.py` → **139/139 PASS** |
| MoA-X graphify | `graphify-out/graph.html` present; `.gitignore` PR [#36](https://github.com/drivelineresearch/moa-x/pull/36) open |
| Core 10 portable skills | find-skills, improve, mattpocock, superpowers, vercel agent-skills, agent-browser, trailofbits, awesome-copilot, anthropics |
| 2026 skill packs | last30days, deep-research (24601), hallmark, nvidia (full pack), remotion-dev |
| compound-engineering (Codex) | `compound-engineering@compound-engineering-plugin` v3.23.4 |
| compound-engineering (Cursor) | `~/.cursor/plugins/local/compound-engineering` symlink |
| pstack models rule | `~/.cursor/rules/pstack-models.mdc` present |
| gstack | `~/.agents/plugins/gstack` — **55 skills** each for cursor + codex hosts |
| OpenSpec CLI | `openspec` v1.11.0 |
| Graphify CLI | `graphify` installed; `graphify cursor install` wrote `.cursor/rules/graphify.mdc` |
| agent-browser | v0.35.1 + browser binaries |
| Context7 MCP | Added to `~/.cursor/mcp.json` |
| Origin CLI + auth | Logged in; repo at `origin.cursor.com/praxstack/developer-workflow` |
| GitHub developer-workflow | https://github.com/praxstack/developer-workflow |
| STACK-2026.md | Layer architecture + conflict warnings documented |

## Skipped (already present)

| Item | Reason |
| --- | --- |
| find-skills, improve, mattpocock, superpowers, vercel, trailofbits, awesome-copilot, anthropics | Pre-installed 2026-08-29 |
| last30days, hallmark, remotion-dev | Pre-installed before this run |
| agent-browser, openspec, graphify | CLIs already on PATH |

## Newly installed this run

| Item | Notes |
| --- | --- |
| nvidia/skills | Full pack (~100+ GPU/CUDA skills) |
| 24601/agent-deep-research | `deep-research` skill (Med Snyk risk — review before use) |
| Context7 MCP | Merged into `~/.cursor/mcp.json` |
| gstack cursor+codex setup | Re-ran `./setup --host cursor` and `./setup --host codex` |

## Blocked / manual

| Item | Blocker | Fix |
| --- | --- | --- |
| Full MoA provider credentials | QWEN_TOKEN_PLAN_API_KEY, opencode auth, AGY | Set keys / login |
| pstack native plugin | Requires Cursor UI | `/add-plugin pstack` → `/setup-pstack` |
| compound-engineering (Cursor native) | Requires Cursor UI | `/add-plugin compound-engineering` |
| wshobson/agents 94 plugins | Context rot if global | Install per-project only — see STACK-2026.md |
| Serena MCP | Project-level | Add in Cursor MCP settings per repo |
| CodeRabbit on PR #36 | Rate limit (~54 min) | Re-run `coderabbit review --agent --base main` |

## Goal completion gate

**COMPLETE** — Stack documented in STACK-2026.md; INSTALL.sh updated; both remotes pushed.

Remaining non-blocking: full MoA credentials, native Cursor plugin UI steps, Serena per-project MCP.
