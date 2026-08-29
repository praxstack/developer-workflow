#!/usr/bin/env bash
set -euo pipefail

install_pack() {
  npx skills@latest add "$1" --skill "${2:-*}" -g -a cursor -a codex -a claude-code -y
}

# ── Core 10 ──────────────────────────────────────────────────────────
install_pack vercel-labs/skills find-skills
install_pack shadcn/improve improve
install_pack mattpocock/skills '*'
install_pack obra/superpowers '*'
install_pack vercel-labs/agent-skills '*'
install_pack vercel-labs/agent-browser agent-browser
install_pack trailofbits/skills '*'
install_pack github/awesome-copilot '*'
install_pack anthropics/skills '*'

# ── 2026 additions ───────────────────────────────────────────────────
install_pack mvanhorn/last30days-skill
install_pack 24601/agent-deep-research
install_pack nutlope/hallmark
install_pack nvidia/skills
install_pack remotion-dev/skills

# ── CLIs ─────────────────────────────────────────────────────────────
command -v agent-browser >/dev/null || npm install -g agent-browser
agent-browser install 2>/dev/null || true

command -v openspec >/dev/null || npm install -g @fission-ai/openspec@latest

command -v graphify >/dev/null || uv tool install graphifyy 2>/dev/null || pip install graphifyy

# ── Praxstack skills-and-personas ─────────────────────────────────────
PRAXSTACK_REPO="${PRAXSTACK_REPO:-/tmp/skills-and-personas}"
if [[ -d "${PRAXSTACK_REPO}/new-skills" ]]; then
  echo "Installing praxstack portfolio (gap-fill to agents/codex)..."
  bash "${PRAXSTACK_REPO}/.agent/operator-prompt-library/scripts/install_fleet_gaps.sh" || true

  echo "Installing praxstack portfolio to Claude Code (~/.claude/skills)..."
  SRC="${PRAXSTACK_REPO}/new-skills"
  DEST="${HOME}/.claude/skills"
  TS=$(date +%Y%m%d-%H%M%S)
  BACKUP="${HOME}/.claude/skills/_backup-praxstack-${TS}"
  mkdir -p "${DEST}"
  for src_dir in "${SRC}"/*/; do
    name=$(basename "${src_dir}")
    [[ "${name}" == _audit ]] && continue
    dst="${DEST}/${name}"
    if [[ -d "${dst}" ]]; then
      mkdir -p "${BACKUP}"
      mv "${dst}" "${BACKUP}/${name}"
    fi
    cp -R "${src_dir}" "${dst}"
  done

  for skill in teach-pro-max superimprove coding-agent-leadership-principles cross-agent-handoff; do
    if [[ ! -d "${HOME}/.agents/skills/${skill}" ]]; then
      npx skills@latest add praxstack/skills-and-personas --skill "${skill}" -g -a cursor -a codex -a claude-code -y || true
    fi
  done
else
  echo "Clone praxstack/skills-and-personas to ${PRAXSTACK_REPO} first (or set PRAXSTACK_REPO)."
  echo "  gh repo clone praxstack/skills-and-personas ${PRAXSTACK_REPO}"
fi

# ── gstack (native plugin) ───────────────────────────────────────────
if [[ -x "${HOME}/.agents/plugins/gstack/setup" ]]; then
  (cd "${HOME}/.agents/plugins/gstack" && ./setup --host cursor && ./setup --host codex)
else
  echo "gstack not found at ~/.agents/plugins/gstack — clone from https://github.com/garrytan/gstack"
fi

# ── Context7 MCP (merge into ~/.cursor/mcp.json) ─────────────────────
MCP_JSON="${HOME}/.cursor/mcp.json"
if [[ -f "${MCP_JSON}" ]] && ! grep -q '"context7"' "${MCP_JSON}"; then
  echo "Add context7 to ${MCP_JSON}:"
  echo '  "context7": {"command": "npx", "args": ["-y", "@upstash/context7-mcp"]}'
fi

echo "Done. Install native plugins manually: pstack, superpowers, compound-engineering."
echo "See STACK-2026.md for layer architecture and PRAXSTACK-SKILLS.md for persona catalog."
echo "See STACK-2026.md for conflict warnings."
echo "Do NOT install wshobson/agents 94-plugin pack globally."
