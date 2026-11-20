#!/bin/bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGETS=(.codex .copilot .claude)
AGENT_MARKER="<!-- gerado por ia-dev-kit/install.sh: nao edite; rode ./install.sh de novo -->"
installed=()
agents_installed=()

install_dir() {
  local src="$1" d name t dest

  for t in "${TARGETS[@]}"; do
    [ -d "$HOME/$t" ] || continue
    [ -d "$HOME/$t/skills" ] || mkdir -p "$HOME/$t/skills"

    for d in "$src"/*/; do
      d="${d%/}"
      name="$(basename "$d")"
      [ -f "$d/SKILL.md" ] || continue

      dest="$HOME/$t/skills/$name"
      [ -L "$dest" ] && rm "$dest"
      if [ -e "$dest" ]; then
        echo "  ! $name ($t): já existe e não é link; ignorado"
        continue
      fi
      ln -sfn "$d" "$dest"

      echo "  - $name ($(basename "$src")) -> $t"
      installed+=("$name")
    done
  done
}

# Link de um subagent (arquivo .md) em ~/.claude/agents. $2 é a origem, só para a mensagem.
link_subagent() {
  local f="$1" origem="$2" base dest
  base="$(basename "$f")"
  dest="$HOME/.claude/agents/$base"
  [ -L "$dest" ] && rm "$dest"
  if [ -e "$dest" ]; then
    echo "  ! ${base%.md} (subagent): já existe e não é link; ignorado"
    return 0
  fi
  ln -sfn "$f" "$dest"
  echo "  - ${base%.md} ($origem) -> .claude"
  agents_installed+=("${base%.md}")
}

# Subagents agnósticos, em agents/subagents/<tema>/<nome>.md: rodam sem nenhum orquestrador.
# Só no Claude Code.
install_subagents() {
  local f

  [ -d "$HOME/.claude" ] || return 0
  [ -d "$HOME/.claude/agents" ] || mkdir -p "$HOME/.claude/agents"

  for f in "$ROOT"/agents/subagents/*/*.md; do
    [ -f "$f" ] || continue
    link_subagent "$f" "subagent $(basename "$(dirname "$f")")"
  done
}

# Subagents do agente (links) e o próprio agente (arquivo gerado), só no Claude Code.
# O arquivo gerado aponta, por caminho absoluto, para o AGENTS.md e os resources/ do kit,
# então o agente roda na raiz de qualquer repositório: claude --agent <nome>.
install_agent_files() {
  local a="$1" name f dest
  name="$(basename "$a")"

  [ -d "$HOME/.claude" ] || return 0
  [ -d "$HOME/.claude/agents" ] || mkdir -p "$HOME/.claude/agents"

  for f in "$a"/.claude/agents/*.md; do
    [ -f "$f" ] || continue
    link_subagent "$f" "subagent de $name"
  done

  dest="$HOME/.claude/agents/$name.md"
  if [ -e "$dest" ] && ! grep -qF "$AGENT_MARKER" "$dest"; then
    echo "  ! $name: já existe e não foi gerado por este kit; ignorado"
    return 0
  fi

  cat > "$dest" <<AGENT
---
name: $name
description: "Sessão do $name do ia-dev-kit. Uso manual: claude --agent $name na raiz do repositório-alvo. Não delegue a este agente."
---
$AGENT_MARKER

Você é o $name, do ia-dev-kit. Seu manual completo está em $a/AGENTS.md.

Antes de responder qualquer coisa:
1. Leia esse AGENTS.md por inteiro e siga-o à risca: papel, fases ou etapas, gates e proibições.
2. Todo caminho relativo citado nele (resources/, dados/, evals/, docs/) fica em $a/, e não no diretório atual.
3. Os arquivos de trabalho do fluxo (estado.json, rascunho/) e o código-alvo ficam no diretório atual, que deve ser a raiz do repositório-alvo.
AGENT
  echo "  - $name (agente) -> .claude"
  agents_installed+=("$name")
}

install_agents() {
  local a
  for a in "$ROOT"/agents/*/; do
    a="${a%/}"
    [ -f "$a/AGENTS.md" ] || continue
    if [ -d "$a/.claude/skills" ]; then
      install_dir "$a/.claude/skills"
    fi
    install_agent_files "$a"
  done
}

echo "==> Criando links das convenções"
"$ROOT/skills/net/link-rules.sh"

echo "==> Instalando skills"

install_dir "$ROOT/skills/engineering"
install_dir "$ROOT/skills/git"
install_dir "$ROOT/skills/meta-skills"
install_dir "$ROOT/skills/net"
install_dir "$ROOT/skills/trello"

echo "==> Instalando subagents"

install_subagents

echo "==> Instalando agentes"

install_agents

echo "==> Concluído: ${#installed[@]} link(s) de skill e ${#agents_installed[@]} item(ns) de agente"
