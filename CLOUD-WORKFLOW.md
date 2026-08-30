# Cloud-first workflow

Run agent work on Cursor Cloud VMs instead of a local Mac. This doc covers
**developer-workflow** (stack/bootstrap) and **moa-x** (reference harness), with
dual remotes on GitHub and Cursor Origin.

## Why cloud-first

| Local Mac | Cloud VM |
| --- | --- |
| Paths like `/Users/prax/Developer/...` | Ephemeral Linux home (`/home/ubuntu/...` or similar) |
| Your Chrome session, keychain, MCP OAuth | Fresh VM per run; secrets via env / one-time login |
| Long jobs tie up laptop | Fire-and-forget; PRs opened from the VM |

**Rule:** Never hardcode Mac paths in prompts, skills, or scripts. Clone on the
VM, work on branches there, push to fork + open PRs from there.

## Repos and remotes

| Repo | GitHub | Cursor Origin |
| --- | --- | --- |
| developer-workflow | `praxstack/developer-workflow` | `origin.cursor.com/praxstack/developer-workflow` |
| moa-x (fork) | `praxstack/moa-x` | *(optional — use GitHub fork as primary)* |
| moa-x (upstream) | `drivelineresearch/moa-x` | — |

### Clone on a cloud VM

**developer-workflow** (preferred Origin path):

```bash
# Install origin CLI (once per VM)
curl -fsSL https://downloads.cursor.com/origin/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
origin auth login   # browser or printed URL in headless SSH

origin repo clone praxstack/developer-workflow
cd developer-workflow
git remote add github git@github.com:praxstack/developer-workflow.git 2>/dev/null || true
```

**moa-x** (fork → upstream):

```bash
gh repo clone praxstack/moa-x
cd moa-x
git remote add upstream https://github.com/drivelineresearch/moa-x.git
git fetch upstream
```

Do **not** assume `/Users/prax/Developer/moa-x` exists on the VM.

## One-time VM bootstrap

Run after first clone on a fresh cloud agent or VM:

```bash
cd developer-workflow
./INSTALL.sh --cloud
```

`--cloud` installs portable skills, CLIs (agent-browser, openspec, graphify),
and optional praxstack portfolio when `PRAXSTACK_REPO` is set. See
[INSTALL.sh](INSTALL.sh) for details.

### Auth you must do once per VM (or per credential rotation)

| Tool | Command | Notes |
| --- | --- | --- |
| **Origin** | `origin auth login` | Configures git credential helper for `origin.cursor.com`. Headless: CLI prints a URL — complete in browser. |
| **GitHub** | `gh auth login` | Needed for `gh pr create`, fork PRs, issue comments. Prefer SSH or token via env in CI. |
| **Cursor API** (SDK/automation) | `export CURSOR_API_KEY=cursor_...` | [Dashboard → Integrations](https://cursor.com/dashboard/integrations) |

Origin skill is **disabled in cloud** environments in Cursor's bundled skill
pack — agents on cloud VMs should follow this doc instead of the local Origin
skill install path.

## Push to both remotes

After commits on `main` (or a feature branch):

```bash
# developer-workflow
git push origin main          # if origin = GitHub
git push cursor-origin main   # Origin remote (add once below)

# One-time Origin remote
git remote add cursor-origin https://origin.cursor.com/praxstack/developer-workflow.git
```

Recommended remote names for developer-workflow:

```bash
git remote rename origin github    # optional clarity
git remote add cursor-origin https://origin.cursor.com/praxstack/developer-workflow.git
```

## PR workflow from cloud

Standard fork flow — entirely on the VM:

```bash
cd moa-x   # or developer-workflow for doc-only changes
git checkout -b feature/my-change
# ... edit, test ...
python3 harness/scripts/test_offline.py   # moa-x: 139 offline tests, no network

git add -A && git commit -m "Describe why, not just what."
git push -u fork feature/my-change   # moa-x: remote `fork` → praxstack/moa-x
# developer-workflow: git push github feature/my-change

gh pr create \
  --repo drivelineresearch/moa-x \
  --head praxstack:feature/my-change \
  --base main \
  --title "Short title" \
  --body "$(cat <<'EOF'
## Summary
- ...

## Test plan
- [ ] python3 harness/scripts/test_offline.py
EOF
)"
```

For **developer-workflow** (no upstream fork): push branch to GitHub and Origin,
open PR on GitHub if needed.

## moa-x cloud agent checklist

When spawning work on **moa-x** from a cloud agent:

1. **Clone** `gh repo clone praxstack/moa-x` (not local Mac paths).
2. **Preflight** `python3 harness/scripts/install_deps.py` (config-aware toolchain).
3. **Test** `python3 harness/scripts/test_offline.py` before push.
4. **Branch** off `main`; sync with upstream when needed:
   `git fetch upstream && git merge upstream/main`.
5. **Push** to `praxstack/moa-x` fork; open PR against `drivelineresearch/moa-x`.
6. **Graph** after code edits: `graphify update .` (keeps `graphify-out/` current).
7. **Do not** commit `.moa/` session artifacts.

Current example: PR [#36](https://github.com/drivelineresearch/moa-x/pull/36)
(graphify gitignore) — continue from cloud the same way.

## Launching cloud agents

### Cursor UI

1. Open the repo in Cursor (GitHub or Origin clone).
2. Start an agent with **Cloud** enabled ([Cloud Agents dashboard](https://cursor.com/dashboard?tab=cloud-agents)).
3. Cloud agents run on a Cursor-hosted VM with a **fresh clone** of the repo —
   ideal for long jobs and opening real PRs.

### Cursor SDK (TypeScript / Python)

Always set `cloud` explicitly (omitting it silently runs local):

```typescript
import { Agent, AgentOptions } from "@cursor/sdk";

const agent = await Agent.create({
  apiKey: process.env.CURSOR_API_KEY!,
  cloud: {
    repos: [{ url: "https://github.com/praxstack/moa-x.git" }],
    autoCreatePR: true,
  },
});
```

Cloud agent IDs start with `bc-`. See [Cloud Agents REST API](https://cursor.com/docs/cloud-agent/api/endpoints).

### cursor-app-control (Agents Window)

These MCP tools move the **current** agent's workspace root (local or cloud
session with MCP available):

| Tool | Use when |
| --- | --- |
| `create_project` | Bootstrap a new directory + git repo, then `move_agent_to_root`. |
| `move_agent_to_root` | Switch agent to an existing path; runs `git fetch origin <branch>` on destination. |
| `move_agent_to_cloned_root` | Target is a **sibling clone** (e.g. `cursorfs-clone` under `~/.cursor/cursorfs-clone/`) on the same branch — skips fetch/merge. |

**Typical cloud pattern:** clone repo on VM → `move_agent_to_root` with that
path → implement → push. For `cursorfs-clone` outputs, use
`move_agent_to_cloned_root` to avoid "Remote branch not found on origin" on
local-only branches.

`create_project` alone does not start a cloud VM — pair it with Cloud agent
mode in the UI or SDK `cloud: { repos: [...] }`.

### Automations

Scheduled / trigger-based cloud work: [Automate skill](~/.cursor/skills-cursor/automate/SKILL.md)
→ Cloud compute in [dashboard](https://cursor.com/dashboard?tab=cloud-agents).
Recurring timers on cloud agents use subscription MCP, not local `sleep`.

## What stays local vs cloud

| Stays local (Mac) | Moves to cloud VM |
| --- | --- |
| Cursor desktop UI, browser for Origin one-click login (first time) | All git write operations (commit, push, PR) |
| Optional: personal Chrome for `browser-use` on logged-in sites | `INSTALL.sh --cloud` skill stack |
| Some MCP OAuth flows (Slack, Gmail) unless re-authed on VM | moa-x harness runs, offline tests, graphify |
| `~/.agents/skills` on Mac (reference only) | Fresh `~/.agents/skills` after `--cloud` install |

## Honest limits

**Cannot fully move to cloud (today):**

- **Origin `auth login` browser step** — headless VMs get a URL; you complete
  login once per VM (or use credential helper persistence if the VM is reused).
- **Local Chrome / browser-use** — cloud has no access to your Mac Chrome
  profile; use cloud browser MCP or `agent-browser` on the VM.
- **MCP servers requiring desktop OAuth** — Gmail, Slack, some team MCPs need
  auth in that environment; HTTP MCP with API keys work better on cloud.
- **Cursor native plugins** — `/add-plugin pstack`, compound-engineering: UI
  steps on desktop; portable skills via `INSTALL.sh` work on cloud.
- **MoA full multi-lab runs** — need provider API keys / CLI auth on the VM
  (Qwen, OpenCode, AGY, Codex, Claude); offline tests do not.
- **Local-only paths in rules** — e.g. old prompts citing
  `/Users/prax/Developer/moa-x`; update to repo-relative instructions.

**You must do once on each cloud VM:**

1. `origin auth login` (if pushing to Origin)
2. `gh auth login` (if using `gh pr create`)
3. `./INSTALL.sh --cloud` (or full `INSTALL.sh` for parity with Mac)
4. Provider env vars for live MoA runs (optional for doc/test-only work)

## Quick switch checklist for Prax

1. Stop relying on Mac paths in agent prompts.
2. Open [Cloud Agents dashboard](https://cursor.com/dashboard?tab=cloud-agents) and confirm compute is enabled.
3. On next cloud session:
   ```bash
   origin repo clone praxstack/developer-workflow
   cd developer-workflow && ./INSTALL.sh --cloud
   gh repo clone praxstack/moa-x && cd moa-x
   python3 harness/scripts/test_offline.py
   ```
4. Do `origin auth login` and `gh auth login` when prompted.
5. Work on branches, push to fork + Origin, `gh pr create` from the VM.
6. Use Cloud agent mode (UI or SDK `cloud: { repos }`) for long-running tasks.

## Related docs

- [README.md](README.md) — stack overview
- [INSTALL.sh](INSTALL.sh) — bootstrap (`--cloud` flag)
- [STACK-2026.md](STACK-2026.md) — layer architecture
- moa-x [CLAUDE.md](https://github.com/drivelineresearch/moa-x/blob/main/CLAUDE.md) — harness rules
- Cursor [Cloud Agent docs](https://cursor.com/docs/cloud-agent/api/endpoints)
