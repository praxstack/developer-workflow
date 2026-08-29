# STACK-2026 — Agent Engineering Stack

Personal agent engineering stack for Cursor, Codex, and Claude Code (verified 2026-08-29).

## Layer architecture

Pick **one methodology per task** — do not stack conflicting layers on the same work item.

| Layer | Purpose | Primary tools |
| --- | --- | --- |
| **Discover** | Find skills, research freshness, codebase maps | find-skills, last30days, deep-research, Graphify |
| **Spec** | Product intent, plans, OpenAPI-style specs | gstack `/spec`, OpenSpec, Spec Kit |
| **Implement** | Execution with guardrails | pstack, Superpowers (pick one with pstack) |
| **Review** | Code quality, architecture | Matt Pocock, gstack `/review`, Compound Engineering |
| **Security** | Audit, SAST patterns | Trail of Bits, NVIDIA (selective) |
| **Browser** | QA, dogfooding, E2E | agent-browser, gstack browse |
| **Ship** | Land, deploy, release | gstack `/ship`, CI |
| **Learn** | Retros, compound learning | gstack `/learn`, Compound Engineering |

## Core 10 + 2026 additions

### Core 10 (baseline)

| Pack | Install |
| --- | --- |
| find-skills | `npx skills@latest add vercel-labs/skills --skill find-skills -g -a cursor -a codex -a claude-code -y` |
| improve | `npx skills@latest add shadcn/improve --skill improve -g -a cursor -a codex -a claude-code -y` |
| mattpocock | `npx skills@latest add mattpocock/skills --skill '*' -g -a cursor -a codex -a claude-code -y` |
| superpowers | `npx skills@latest add obra/superpowers --skill '*' -g -a cursor -a codex -a claude-code -y` |
| vercel agent-skills | `npx skills@latest add vercel-labs/agent-skills --skill '*' -g -a cursor -a codex -a claude-code -y` |
| agent-browser | `npx skills@latest add vercel-labs/agent-browser --skill agent-browser -g -a cursor -a codex -a claude-code -y` |
| trailofbits | `npx skills@latest add trailofbits/skills --skill '*' -g -a cursor -a codex -a claude-code -y` |
| awesome-copilot | `npx skills@latest add github/awesome-copilot --skill '*' -g -a cursor -a codex -a claude-code -y` |
| anthropics | `npx skills@latest add anthropics/skills --skill '*' -g -a cursor -a codex -a claude-code -y` |
| gstack | `git clone https://github.com/garrytan/gstack ~/.agents/plugins/gstack && cd ~/.agents/plugins/gstack && ./setup --host cursor && ./setup --host codex` |

### 2026 additions

| Tool | Role | Install |
| --- | --- | --- |
| **OpenSpec** | Spec-driven change management CLI | `npm install -g @fission-ai/openspec@latest` |
| **Graphify** | Repo knowledge graph + Cursor rule | `uv tool install graphifyy` then `graphify cursor install` |
| **Serena** | Semantic code retrieval (MCP) | Add Serena MCP in Cursor settings (project-level) |
| **Context7** | Live library docs MCP | Add to `~/.cursor/mcp.json` (see INSTALL.sh) |
| **last30days** | Research freshness / recent events | `npx skills@latest add mvanhorn/last30days-skill -g -a cursor -a codex -a claude-code -y` |
| **deep-research** | Async Gemini-grounded research | `npx skills@latest add 24601/agent-deep-research -g -a cursor -a codex -a claude-code -y` |
| **Hallmark** | UI quality / anti-slop design | `npx skills@latest add nutlope/hallmark -g -a cursor -a codex -a claude-code -y` |
| **NVIDIA skills** | CUDA, cuOpt, NeMo, VSS (selective) | `npx skills@latest add nvidia/skills -g -a cursor -a codex -a claude-code -y` |
| **Remotion** | Programmatic video | `npx skills@latest add remotion-dev/skills -g -a cursor -a codex -a claude-code -y` |

### Native plugins (manual Cursor UI)

| Plugin | Install |
| --- | --- |
| pstack | Cursor → `/add-plugin pstack` → `/setup-pstack` |
| compound-engineering | Cursor → `/add-plugin compound-engineering`; Codex → `codex plugin add compound-engineering@compound-engineering-plugin` |
| superpowers (native) | Cursor → `/add-plugin superpowers` — **or** portable skills, not both |

## Conflict warnings

**Do not run these together on the same task:**

| Conflict | Why |
| --- | --- |
| gstack + Superpowers + pstack + Compound Engineering | Four competing orchestration layers — pick one implementation driver |
| Matt Pocock plugin + Matt Pocock portable skills | Duplicate skill discovery and conflicting prompts |
| Superpowers plugin + obra/superpowers portable skills | Same skill names, doubled context |
| gstack `/spec` + OpenSpec + Spec Kit | Three spec systems — pick one per feature |
| Full NVIDIA pack + unrelated task | 100+ GPU skills pollute context — use `nvidia-skill-finder` or install selectively |
| wshobson/agents 94-plugin pack globally | Context rot — install per-project only (see note below) |

## wshobson/agents — do NOT install globally

The [wshobson/agents](https://github.com/wshobson/agents) marketplace ships **94 plugins**. Installing all globally causes severe context rot and skill-name collisions. Install individual plugins per project via Cursor `/add-plugin` when a specific capability is needed.

## MoA-X reference

- Upstream: https://github.com/drivelineresearch/moa-x
- Preflight: `python3 harness/scripts/install_deps.py`
- Offline tests: `python3 harness/scripts/test_offline.py` (139 tests)
- Graph map: `/graphify` → `graphify-out/graph.html` (gitignored)

## Links

- [gstack](https://github.com/garrytan/gstack)
- [OpenSpec](https://github.com/Fission-AI/OpenSpec)
- [Graphify](https://github.com/graphifyy/graphifyy)
- [Context7 MCP](https://github.com/upstash/context7)
- [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)
- [pstack](https://github.com/cursor/plugins/tree/main/pstack)
