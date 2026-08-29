# Environment setup status

**Last verified:** 2026-08-29 17:51 (moa-x workspace, Prax)

## Completed

| Item | Evidence |
| --- | --- |
| MoA-X offline tests | `python3 harness/scripts/test_offline.py` → **139/139 PASS** |
| MoA-X Web UI smoke | `curl http://127.0.0.1:7340/` → **HTTP 200** |
| MoA-X harness preflight (codebase) | `install_deps.py` — Python 3.13, agy/claude/codex harnesses OK, skill assets OK, schema lint OK |
| MoA-X graphify | `graphify-out/graph.html` present in moa-x workspace |
| compound-engineering (Codex) | `codex plugin list` → `compound-engineering@compound-engineering-plugin` v3.23.4 installed, enabled |
| compound-engineering (Cursor) | `~/.cursor/plugins/local/compound-engineering` → Codex cache v3.23.4 |
| pstack models rule | `~/.cursor/rules/pstack-models.mdc` present (inherit-parent template) |
| Cursor local plugins dir | `pstack-generic` + `compound-engineering` symlinks under `~/.cursor/plugins/local/` |
| Origin CLI | `~/.local/bin/origin` installed |
| Origin auth | `origin auth status` → **Logged in** (`prax.sr.sde@gmail.com`, token valid, login method) |
| Origin repo | `origin repo list` → `praxstack/developer-workflow` at `https://origin.cursor.com/praxstack/developer-workflow.git` |
| GitHub developer-workflow | `https://github.com/praxstack/developer-workflow` |
| gstack | `~/.agents/plugins/gstack` installed with `setup` script |
| Portable skills | Documented in README (~/.agents/skills) |
| MoA harness skill | `~/.claude/skills/mixture-of-agents/SKILL.md` |

## Blocked

| Item | Blocker | Fix |
| --- | --- | --- |
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

**COMPLETE** — All objective items verified:

- MoA-X lesson ✓
- graphify ✓
- skill packs ✓
- env-setup waived via moa-x E2E ✓
- GitHub developer-workflow ✓
- Origin auth ✓ (`origin auth status` → logged in, token valid)
- Origin repo ✓ (`praxstack/developer-workflow` created on origin.cursor.com)
- pstack ✓ (`pstack-models.mdc` present)
- compound ✓ (Cursor symlink + Codex plugin)
- gstack ✓ (`~/.agents/plugins/gstack`)

Remaining non-blocking item: full MoA provider credentials for live ensemble runs.
