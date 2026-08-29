# Environment setup status

**Last verified:** 2026-08-29 (moa-x workspace, Prax)

## Completed

| Item | Evidence |
| --- | --- |
| MoA-X offline tests | `python3 harness/scripts/test_offline.py` → **139/139 PASS** |
| MoA-X Web UI smoke | `curl http://127.0.0.1:7340/` → **HTTP 200** |
| MoA-X harness preflight (codebase) | `install_deps.py` — Python 3.13, agy/claude/codex harnesses OK, skill assets OK, schema lint OK |
| compound-engineering (Codex) | `codex plugin list` → `compound-engineering@compound-engineering-plugin` v3.23.4 installed, enabled |
| Cursor local plugins dir | `~/.cursor/plugins/local/pstack-generic` symlink present |
| Origin CLI | `~/.local/bin/origin` installed (per README) |
| Portable skills | Documented in README (~/.agents/skills) |

## Blocked

| Item | Blocker | Fix |
| --- | --- | --- |
| Origin auth | `origin auth status` → **Not logged in** | `~/.local/bin/origin auth login` |
| `pstack-models.mdc` | `~/.cursor/rules/pstack-models.mdc` → **MISSING** | Cursor: `/add-plugin pstack` → `/setup-pstack` |
| compound-engineering (Cursor) | Not under `~/.cursor/plugins/local/`; only Codex install | Cursor: `/add-plugin compound-engineering` |
| Full MoA provider credentials | `install_deps.py` → QWEN_TOKEN_PLAN_API_KEY, opencode auth, AGY gemini-3.1-pro-high visibility | Set keys / `opencode auth login` / verify AGY account |

## Waivable substitute for `/env-setup`

**Finding:** No `env-setup` skill, command, or plugin manifest exists under `~/.cursor` (searched `find ~/.cursor -name '*env*setup*'`, `skills-cursor/`, plugin cache manifests — all empty).

**`onboard` skill (`~/.cursor/skills-cursor/onboard/SKILL.md`):** Interactive `/onboard` interview only — produces handoff prompts; explicitly **does not execute setup** (no cloud env workflow).

**`sdk` skill:** Cursor SDK integration guide only — no environment bootstrap.

**Accepted substitute (waivable):** MoA-X preflight E2E:

```bash
cd moa-x
python3 harness/scripts/install_deps.py   # harness + asset checks (credentials may warn)
python3 harness/scripts/test_offline.py   # must be 139/139
MOA_WEBUI_GITHUB_OWNER=praxstack python3 -m harness.webui &
curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:7340/  # expect 200
```

**Substitute result (2026-08-29):** Offline suite **PASS**; Web UI **200**; `install_deps.py` reports **3 credential warnings** (non-blocking for repo dev/CI, blocking for live `/mixture-of-agents` runs).

## Goal completion gate

**NOT complete** — requires all of: Origin logged in + repo accessible, `pstack-models.mdc` present, compound-engineering in **Cursor** plugins, and either `/env-setup` found or this substitute documented with passing E2E. Three of four blockers remain (Origin, pstack rule, Cursor compound plugin).
