#!/usr/bin/env bash
set -euo pipefail

CLOUD_MODE=0
for arg in "$@"; do
  case "${arg}" in
    --cloud) CLOUD_MODE=1 ;;
    -h|--help)
      cat <<'EOF'
Usage: ./INSTALL.sh [--cloud]

  --cloud   Bootstrap a Cursor Cloud VM: install origin CLI, ensure gh,
            clone praxstack/skills-and-personas when missing, print auth
            reminders. Skill/CLI install is the same as default.

See CLOUD-WORKFLOW.md for the full cloud-first workflow.
EOF
      exit 0
      ;;
  esac
done

install_pack() {
  npx skills@latest add "$1" --skill "${2:-*}" -g -a cursor -a codex -a claude-code -y
}

# ── Cloud VM bootstrap (optional) ────────────────────────────────────
if [[ "${CLOUD_MODE}" -eq 1 ]]; then
  echo "==> Cloud bootstrap (see CLOUD-WORKFLOW.md)"

  export PATH="${HOME}/.local/bin:${PATH}"

  if ! command -v origin >/dev/null 2>&1; then
    echo "Installing origin CLI..."
    curl -fsSL https://downloads.cursor.com/origin/install.sh | sh
    export PATH="${HOME}/.local/bin:${PATH}"
  fi

  if command -v origin >/dev/null 2>&1; then
    if ! origin auth status 2>/dev/null | grep -q 'Token:.*valid'; then
      echo "Origin auth required — run: origin auth login"
    else
      echo "Origin auth: OK"
    fi
  fi

  if ! command -v gh >/dev/null 2>&1; then
    echo "gh CLI not found — install from https://cli.github.com/ then: gh auth login"
  elif ! gh auth status >/dev/null 2>&1; then
    echo "GitHub auth required — run: gh auth login"
  else
    echo "GitHub auth: OK"
  fi

  # Default clone location on ephemeral VMs
  if [[ ! -d "${PRAXSTACK_REPO:-/tmp/skills-and-personas}/new-skills" ]] && command -v gh >/dev/null 2>&1; then
    PRAXSTACK_REPO="${PRAXSTACK_REPO:-${HOME}/skills-and-personas}"
    if [[ ! -d "${PRAXSTACK_REPO}/new-skills" ]]; then
      echo "Cloning praxstack/skills-and-personas to ${PRAXSTACK_REPO}..."
      gh repo clone praxstack/skills-and-personas "${PRAXSTACK_REPO}" || true
    fi
    export PRAXSTACK_REPO
  fi

  if [[ ! -x "${HOME}/.agents/plugins/gstack/setup" ]]; then
    if command -v gh >/dev/null 2>&1; then
      GSTACK_DIR="${HOME}/.agents/plugins/gstack"
      if [[ ! -x "${GSTACK_DIR}/setup" ]]; then
        echo "Cloning gstack to ${GSTACK_DIR}..."
        mkdir -p "${HOME}/.agents/plugins"
        gh repo clone garrytan/gstack "${GSTACK_DIR}" || true
      fi
    fi
  fi

  echo ""
fi

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

if [[ "${CLOUD_MODE}" -eq 1 ]]; then
  echo ""
  echo "Cloud next steps (CLOUD-WORKFLOW.md):"
  echo "  origin auth login          # if not already valid"
  echo "  gh auth login              # for PR workflow"
  echo "  gh repo clone praxstack/moa-x && cd moa-x"
  echo "  python3 harness/scripts/test_offline.py"
fi
