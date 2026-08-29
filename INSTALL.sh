#!/usr/bin/env bash
set -euo pipefail

install_pack() {
  npx skills@latest add "$1" --skill "${2:-*}" -g -a cursor -a codex -a claude-code -y
}

install_pack vercel-labs/skills find-skills
install_pack shadcn/improve improve
install_pack mattpocock/skills '*'
install_pack obra/superpowers '*'
install_pack vercel-labs/agent-skills '*'
install_pack vercel-labs/agent-browser agent-browser
install_pack trailofbits/skills '*'
install_pack github/awesome-copilot '*'
install_pack anthropics/skills '*'

command -v agent-browser >/dev/null || npm install -g agent-browser
agent-browser install 2>/dev/null || true

echo "Done. Install native plugins manually: pstack, superpowers, compound-engineering."
