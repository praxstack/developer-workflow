# Praxstack skills and personas

Source repo: [praxstack/skills-and-personas](https://github.com/praxstack/skills-and-personas)

This document records what was integrated from that repo into the developer agent stack (Cursor, Codex, Claude Code) and how to replay the install.

## What came from skills-and-personas

| Layer | Contents | Host paths |
| --- | --- | --- |
| **Canonical portfolio** | 41 production skills in `new-skills/` (linter + smoke-test gated) | `~/.agents/skills/`, `~/.codex/skills/`, `~/.claude/skills/` |
| **Public portable skills** | `teach-pro-max`, `superimprove`, `coding-agent-leadership-principles`, `cross-agent-handoff` | Same three host dirs (already present before this integration) |
| **Legacy / reference skills** | `skills/` tree (superseded by `new-skills/` for most roles) | Gap-filled into `~/.agents/skills` and `~/.codex/skills` only when missing |
| **Personas** | `md-personas/`, `personas/`, `team-personas/` — source material; distilled into skills above | Not copied globally; invoke via installed skills or paste prompts from repo |
| **Operator workflows** | `prompts/high-end-operator/` (spec → plan → build → review → ship), `prompts/project-alignment/` (align, install packs, QA-only) | Paste prompts; no global install |
| **Mental health** | `mental-health-screening-companion` skill + [SAFETY.md](https://github.com/praxstack/skills-and-personas/blob/main/SAFETY.md) | Skill only |

## Install commands (replay)

### 1. Clone

```bash
gh repo clone praxstack/skills-and-personas /tmp/skills-and-personas
```

### 2. Canonical portfolio — all hosts

**Claude Code** (collision-safe backup of same-named skills):

```bash
SRC="/tmp/skills-and-personas/new-skills"
DEST="$HOME/.claude/skills"
TS=$(date +%Y%m%d-%H%M%S)
BACKUP="$HOME/.claude/skills/_backup-praxstack-$TS"
mkdir -p "$DEST"
for src_dir in "$SRC"/*/; do
  name=$(basename "$src_dir")
  [[ "$name" == _audit ]] && continue
  dst="$DEST/$name"
  if [[ -d "$dst" ]]; then mkdir -p "$BACKUP"; mv "$dst" "$BACKUP/$name"; fi
  cp -R "$src_dir" "$dst"
done
```

Or use the repo script after fixing `SRC` inside it to point at your clone (upstream hardcodes a local path).

**Codex + `~/.agents/skills`** (gap-fill only — does not overwrite existing):

```bash
bash /tmp/skills-and-personas/.agent/operator-prompt-library/scripts/install_fleet_gaps.sh
```

### 3. Public skills (individual)

```bash
npx skills@latest add praxstack/skills-and-personas --skill teach-pro-max -g -a cursor -a codex -a claude-code -y
npx skills@latest add praxstack/skills-and-personas --skill superimprove -g -a cursor -a codex -a claude-code -y
npx skills@latest add praxstack/skills-and-personas --skill coding-agent-leadership-principles -g -a cursor -a codex -a claude-code -y
npx skills@latest add praxstack/skills-and-personas --skill cross-agent-handoff -g -a cursor -a codex -a claude-code -y
```

### 4. Legacy multi-target installer (optional)

```bash
python3 /tmp/skills-and-personas/skills/install_skills.py --all --targets claude,codex --mode copy
```

### 5. Smoke test (after Claude install)

```bash
cd /tmp/skills-and-personas/new-skills && python3 _audit/smoke_test.py
```

## Canonical skill catalog (41)

| Skill | Purpose |
| --- | --- |
| `apex-autonomous-mode` | Principal-engineer autonomous execution (`/apex`, `/autonomous`, APEX-ON token) |
| `autonomous-orchestrion` | Host-neutral autonomous work protocol for non-trivial tasks |
| `backend-architecture-standards` | Backend/API/data/distributed-systems standards |
| `backend-pe` | Backend PE orchestrator (routes to language variants) |
| `backend-pe-cpp` | C++ backend PE |
| `backend-pe-java` | Java backend PE |
| `backend-pe-javascript` | JavaScript backend PE |
| `backend-pe-nodejs` | Node.js runtime PE |
| `backend-pe-python` | Python backend PE |
| `backend-pe-python-ml` | Python ML backend PE |
| `backend-pe-typescript` | TypeScript backend PE |
| `backend-system-design-expert` | API contracts, DB architecture, microservices |
| `baron-von-markup` | Markdown architect for notes/transcripts/code output |
| `blueprint-creator` | Exhaustive BLUEPRINT.md from SPEC.md |
| `chronicle` | Personal journal intelligence |
| `concept-cartographer` | Concept maps, flowcharts, architecture diagrams |
| `constellation-team` | Cross-functional star-team workflow coordinator |
| `devops-sre-engineer` | IaC, CI/CD, K8s, observability, SRE |
| `frontend-design-excellence` | Distinctive production UI (anti-generic-AI aesthetics) |
| `frontend-excellence-standards` | Frontend/a11y/performance standards reference |
| `frontend-pe` | Principal frontend engineer workflow |
| `frontend-uiux-designer` | Frontend + UI/UX design |
| `gabriel-petersson-topdown-mentor` | Top-down, problem-first technical mentor |
| `idea-capturer` | Capture and develop fleeting ideas |
| `kingmode` | Principal-engineer routing (Default / ULTRATHINK / KINGMODE) |
| `lecture-alchemist` | Lecture transcripts → study notes |
| `mental-health-screening-companion` | Screening + journaling (not therapy); see SAFETY.md |
| `obsidian-cli` | Obsidian CLI v2 terminal control |
| `orchestrion-universal-agent-router` | Host-neutral orchestration; discovers skills per task |
| `principal-engineer` | Architecture governance and design review |
| `product-manager` | PRDs, roadmap, prioritization |
| `professor-alex-interview` | FAANG/HFT interview mentor |
| `qa-security-engineer` | Test strategy + security engineering |
| `security-compliance-standards` | Security, privacy, compliance standards |
| `spec-creator` | Production-grade SPEC.md contracts |
| `super-mode-core` | Domain standards loader (backend/frontend/security) |
| `svg-logo-designer` | Hand-crafted SVG logos and brand marks |
| `techtutor` | Intuition-first technical mentor (6-layer framework) |
| `transcribe-refiner` | Clean auto-generated captions |
| `transcript-pipeline` | Zoom captions → tutorial workflow |
| `ultrathink-frontend` | Two-mode frontend architecture (Default / ULTRATHINK) |

## Persona catalog

Personas are **invoked through skills** or **paste prompts** from the repo — not installed as separate global config unless you copy bundles manually.

### Distilled into skills (preferred)

| Persona / role | Skill slug |
| --- | --- |
| Kingmode / ultrathink | `kingmode`, `super-mode-core`, `ultrathink-frontend` |
| Constellation team (PM, Principal, Backend, Frontend, QA, DevOps) | `constellation-team` + role skills below |
| Principal Engineer | `principal-engineer` |
| Product Manager | `product-manager` |
| Backend system design | `backend-system-design-expert` |
| Frontend UI/UX | `frontend-uiux-designer`, `frontend-pe` |
| QA / Security | `qa-security-engineer` |
| DevOps / SRE | `devops-sre-engineer` |
| Teach Pro Max identity | `teach-pro-max` skill + `personas/teach-pro-max-agent-persona/` bundle |
| Gabriel Petersson mentor | `gabriel-petersson-topdown-mentor` |
| Professor Alex (interviews) | `professor-alex-interview` |
| Lecture Alchemist | `lecture-alchemist` |
| Baron von Markup | `baron-von-markup` |
| Chronicle (journal) | `chronicle` |

### Portable markdown personas (`md-personas/`)

| File | Use when |
| --- | --- |
| `KINGMODE.md` | Architecture, security, deep reasoning |
| `SUPER-MODE.md` | Extended principal-engineer mode |
| `ULTRATHINK-FRONTEND.md` | Exhaustive frontend architecture |
| `CONSTELLATION-TEAM.md` | Multi-role product delivery workflow |
| `FRONTEND-DESIGN.md` / `FRONTEND-PE.md` | UI/UX and frontend PE |
| `BACKEND-PE.md` | Backend PE (pre-skill era) |
| `GEMINI-KING-MODE.md` | Gemini-specific kingmode adapter |

### Multi-file persona packs (`personas/`)

| Directory | Purpose |
| --- | --- |
| `teach-pro-max-agent-persona/` | SOUL, IDENTITY, USER, AGENTS, TOOLS, HEARTBEAT, BOOTSTRAP for cross-harness teaching |
| `Professor Alex`, `Gabriel Petersson — Top-Down Learning Mentor`, etc. | Full persona bundles with platform configs |
| `ren-nakamura-all-agents-persona` | Cross-agent mentor persona |
| `prax-lannister` | Operator persona |

## Goal and workflow patterns

There is **no standalone `/goal` skill** in this repo. Goal-style autonomous execution appears in:

| Pattern | Where | How to invoke |
| --- | --- | --- |
| **APEX autonomous mode** | `apex-autonomous-mode` skill | `/apex`, `/autonomous`, `<<APEX-ON>>` token, or "apply APEX" |
| **Autonomous orchestrion** | `autonomous-orchestrion` skill | Non-trivial tasks expecting end-to-end agent work |
| **High-end operator loop** | `prompts/high-end-operator/` | Paste prompts: `/spec` → plan → `/build` → `/review` → `/ship` |
| **Project alignment** | `prompts/project-alignment/` | `ALIGN-ONLY.md`, `INSTALL-SKILLS.md`, `ALIGN-INSTALL-QA.md` |
| **Teach Pro Max `/goal` (research)** | `docs/teach-pro-max/research/10-zero-api-autonomous-goal.md` | Research artifact only — not a shipped slash command |

Steady operator loop (from high-end-operator README):

```
/spec → /plan (or writing-plans) → /build (one failing test) → /review → /ship
```

## Conflicts with existing installs

| Situation | Resolution used |
| --- | --- |
| `~/.agents/skills` already had 39/41 portfolio skills | `install_fleet_gaps.sh` — gap-fill only; installed 1 new copy, skipped 257 existing |
| `~/.claude/skills` had older copies of same names | Backed up to `~/.claude/skills/_backup-praxstack-<timestamp>/`, then installed fresh from `new-skills/` |
| Public skills (`teach-pro-max`, etc.) | Already present on all hosts — not reinstalled |
| gstack / Superpowers / Matt Pocock | Separate packs in `INSTALL.sh`; not part of skills-and-personas |

## Host-specific notes

| Host | Skill root | Cursor discovery |
| --- | --- | --- |
| Cursor | `~/.agents/skills/` (canonical via skills-sync / npx `-a cursor`) | Skills in agent context automatically |
| Codex | `~/.codex/skills/` | CLI session |
| Claude Code | `~/.claude/skills/` | `/skill-name` or description triggers |

`orchestrion-universal-agent-router` documents `./setup --host cursor|codex|claude-code` from the **skills-sync** toolchain (not a script in this repo). Use `npx skills@latest add` or the install commands above.

## Quality gates (optional verification)

```bash
cd /tmp/skills-and-personas/new-skills
python3 _audit/lint.py
pytest _audit/tests/ -v
python3 _audit/smoke_test.py
```

## Links

- [skills.sh portfolio](https://skills.sh/praxstack/skills-and-personas)
- [SAFETY.md](https://github.com/praxstack/skills-and-personas/blob/main/SAFETY.md) (mental-health scope)
- [STACK-2026.md](STACK-2026.md) (full developer stack layers)
