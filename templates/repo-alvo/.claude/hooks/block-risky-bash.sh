#!/usr/bin/env bash
# PreToolUse (Bash): bloqueia comandos que tocam producao, APIs de terceiros
# ou arquivos sensiveis. Ajuste a lista PATTERNS ao seu repositorio.
# Saida: codigo 0 = liberado; codigo 2 = bloqueado, com o motivo em stderr.
set -u
source "$(dirname "$0")/_lib.sh"

hook_read_input
command_line="$(hook_field '.tool_input.command')" || exit 0
[ -z "$command_line" ] && exit 0

# Expressoes regulares (ERE). Acrescente hosts de producao e APIs de terceiros reais.
PATTERNS=(
  '(^|[^a-z])(cat|less|more|head|tail|grep|sed|awk|cp|mv|source)[^|;&]*\.env(\.[a-z]+)?($|[^a-z])'
  '\.pfx|\.p12|appsettings\.Production\.json|appsettings\.Prod\.json'
  'ASPNETCORE_ENVIRONMENT=Production'
  '(prod|production)[-.](db|database|sql|redis|api)'
  'a-definir-host-de-producao\.example\.com'
  'a-definir-api-de-terceiro\.example\.com'
  'kubectl[^|;&]*(--context|-n|--namespace)[ =][^ ]*prod'
  'az (webapp|keyvault|sql)[^|;&]*prod'
  'dotnet ef database update[^|;&]*--connection'
  'rm -rf (/|~|\$HOME)( |$)'
)

# Modelos de ambiente sem segredo sao liberados.
command_line="$(printf '%s' "$command_line" | sed -E 's/\.env\.(example|sample|template)//g')"

for pattern in "${PATTERNS[@]}"; do
  if printf '%s' "$command_line" | grep -Eiq -- "$pattern"; then
    hook_block "comando casa com o padrao '$pattern'. Producao e APIs de terceiros so por pedido humano."
  fi
done

exit 0
