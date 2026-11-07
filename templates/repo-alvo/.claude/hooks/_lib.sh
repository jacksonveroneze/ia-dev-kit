#!/usr/bin/env bash
# Funcoes comuns dos hooks. Uso: source "$(dirname "$0")/_lib.sh"
# Le o JSON do hook na entrada padrao e expoe campos via jq ou, na falta, python3.

hook_read_input() {
  HOOK_INPUT="$(cat || true)"
  export HOOK_INPUT
}

# hook_field <caminho.jq>  ex.: hook_field '.tool_input.file_path'
hook_field() {
  local path="$1"
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$HOOK_INPUT" | jq -r "$path // empty" 2>/dev/null
  elif command -v python3 >/dev/null 2>&1; then
    printf '%s' "$HOOK_INPUT" | python3 -c '
import json, sys
path = sys.argv[1].lstrip(".").split(".")
try:
    value = json.load(sys.stdin)
    for key in path:
        value = value.get(key) if isinstance(value, dict) else None
    print("" if value is None else value)
except Exception:
    print("")
' "$path"
  else
    echo "hook: instale jq ou python3 para os hooks funcionarem" >&2
    return 1
  fi
}

# hook_block <mensagem>  bloqueia a acao (codigo 2: a mensagem volta para o agente)
hook_block() {
  echo "BLOQUEADO pelo hook $(basename "$0"): $1" >&2
  exit 2
}
