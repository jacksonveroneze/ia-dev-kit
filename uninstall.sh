#!/bin/bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGETS=(.codex .copilot .claude)
AGENT_MARKER="<!-- gerado por ia-dev-kit/install.sh: nao edite; rode ./install.sh de novo -->"
removed=0
removed_agents=0

echo "==> Removendo skills"

for t in "${TARGETS[@]}"; do
  dir="$HOME/$t/skills"
  if [ ! -d "$dir" ]; then
    echo "  . $t: sem pasta skills; ignorado"
    continue
  fi

  for l in "$dir"/*; do
    [ -L "$l" ] || continue                                  # só links
    case "$(readlink "$l")" in "$ROOT"/*) ;; *) continue ;; esac   # só os que apontam para este repositório

    rm "$l"
    echo "  - $(basename "$l") <- $t"
    removed=$((removed+1))
  done
done

if [ "$removed" -eq 0 ]; then
  echo "  nenhuma skill deste repositório estava instalada"
fi

echo "==> Removendo agentes"

adir="$HOME/.claude/agents"
if [ -d "$adir" ]; then
  for f in "$adir"/*.md; do
    [ -e "$f" ] || [ -L "$f" ] || continue
    if [ -L "$f" ]; then
      case "$(readlink "$f")" in "$ROOT"/*) ;; *) continue ;; esac   # subagent: só link para este repositório
    else
      grep -qF "$AGENT_MARKER" "$f" || continue                       # agente: só arquivo gerado pelo install.sh
    fi
    rm "$f"
    echo "  - $(basename "$f" .md) <- .claude"
    removed_agents=$((removed_agents+1))
  done
fi

if [ "$removed_agents" -eq 0 ]; then
  echo "  nenhum agente deste repositório estava instalado"
fi

echo "==> Removendo links das convenções"
"$ROOT/skills/net/link-rules.sh" --remove

echo "==> Concluído: $removed link(s) de skill e $removed_agents item(ns) de agente removido(s)"
