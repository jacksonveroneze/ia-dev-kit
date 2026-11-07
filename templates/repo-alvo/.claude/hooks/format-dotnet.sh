#!/usr/bin/env bash
# PostToolUse (Edit|Write|MultiEdit): roda dotnet format no arquivo .cs editado.
# Nunca bloqueia: falha de formatacao vira aviso em stderr (codigo 1, nao bloqueante).
set -u
source "$(dirname "$0")/_lib.sh"

hook_read_input
file_path="$(hook_field '.tool_input.file_path')" || exit 0
case "$file_path" in
  *.cs) ;;
  *) exit 0 ;;
esac
[ -f "$file_path" ] || exit 0

if ! command -v dotnet >/dev/null 2>&1; then
  echo "format-dotnet: dotnet nao encontrado; formatacao ignorada" >&2
  exit 1
fi

project_dir="${CLAUDE_PROJECT_DIR:-$PWD}"
dir="$(dirname "$file_path")"
target=""
# Sobe da pasta do arquivo ate a raiz do projeto procurando .csproj, depois .sln/.slnx.
search="$dir"
while [ -n "$search" ] && [ "$search" != "/" ]; do
  found="$(find "$search" -maxdepth 1 \( -name '*.csproj' -o -name '*.sln' -o -name '*.slnx' \) 2>/dev/null | head -n 1)"
  if [ -n "$found" ]; then target="$found"; break; fi
  [ "$search" = "$project_dir" ] && break
  search="$(dirname "$search")"
done

if [ -z "$target" ]; then
  echo "format-dotnet: nenhum .csproj/.sln acima de $file_path; formatacao ignorada" >&2
  exit 1
fi

if output="$(dotnet format "$target" --include "$file_path" --no-restore 2>&1)"; then
  echo "format-dotnet: $file_path formatado"
  exit 0
fi
echo "format-dotnet: falhou em $file_path (alvo $target)" >&2
printf '%s\n' "$output" | tail -n 15 >&2
exit 1
