#!/bin/bash
# link-rules.sh — gerencia net/<skill>/references/dotnet-conventions.md
#
# Uso:
#   ./link-rules.sh            cria o link em toda skill de net/ (padrão)
#   ./link-rules.sh <qualquer> remove os links criados (qualquer parâmetro ativa a remoção,
#                              ex.: ./link-rules.sh --remove)
#
# Só remove symlinks; arquivo real em references/ nunca é apagado.
# Apaga references/ apenas se ficar vazia.
# Link rastreado pelo git (versionado) nunca é removido: seria um arquivo deletado no repositório.
# Fora de um repositório git, remove todos os links, como antes.

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ $# -eq 0 ]; then
  [ -f rules/dotnet-conventions.md ] || { echo "erro: rules/dotnet-conventions.md não encontrado"; exit 1; }
fi

kept=0
removed=0

for skill in */; do
  skill="${skill%/}"
  [ -f "$skill/SKILL.md" ] || continue
  link="$skill/references/dotnet-conventions.md"

  if [ $# -eq 0 ]; then
    mkdir -p "$skill/references"
    ln -sfn ../../rules/dotnet-conventions.md "$link"
    echo "  + $skill: link criado"
  else
    if [ -L "$link" ]; then
      if git ls-files --error-unmatch -- "$link" >/dev/null 2>&1; then
        kept=$((kept+1))
        echo "  = $skill: link versionado no git; mantido"
        continue
      fi
      rm "$link"
      rmdir "$skill/references" 2>/dev/null || true
      removed=$((removed+1))
      echo "  - $skill: link removido"
    fi
  fi
done

if [ $# -ne 0 ]; then
  echo "  $removed link(s) removido(s); $kept mantido(s) por serem versionados no git"
fi