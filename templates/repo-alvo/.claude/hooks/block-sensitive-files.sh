#!/usr/bin/env bash
# PreToolUse (Read|Edit|Write|MultiEdit|NotebookEdit): bloqueia arquivos sensiveis.
# Saida: codigo 0 = liberado; codigo 2 = bloqueado, com o motivo em stderr.
set -u
source "$(dirname "$0")/_lib.sh"

hook_read_input
file_path="$(hook_field '.tool_input.file_path')" || exit 0
[ -z "$file_path" ] && file_path="$(hook_field '.tool_input.notebook_path')"
[ -z "$file_path" ] && exit 0

name="$(basename "$file_path")"
lower="$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]')"

case "$lower" in
  .env|.env.*)
    case "$lower" in
      .env.example|.env.sample|.env.template) exit 0 ;;
    esac
    hook_block "arquivo de ambiente ($name). Use variavel de ambiente ou user-secrets; peca ao humano o que precisar." ;;
  *.pfx|*.p12|*.pem|*.key|*.snk)
    hook_block "certificado ou chave ($name). Nunca leia nem edite." ;;
  appsettings.production.json|appsettings.prod.json)
    hook_block "appsettings de producao ($name). Mude por pipeline ou pelo humano." ;;
  secrets.json|id_rsa|id_ed25519|credentials|credentials.json)
    hook_block "arquivo de segredo ($name)." ;;
esac

case "$file_path" in
  */.aws/*|*/.ssh/*|*/.gnupg/*|*/UserSecrets/*|*/.microsoft/usersecrets/*)
    hook_block "diretorio de credenciais ($file_path)." ;;
esac

exit 0
