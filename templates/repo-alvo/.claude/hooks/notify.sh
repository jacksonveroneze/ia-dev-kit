#!/usr/bin/env bash
# Stop / Notification: avisa que o agente terminou ou precisa de voce.
# Uso: notify.sh "<mensagem>"   Nunca falha: sem notificador, escreve no terminal.
title="Claude Code"
message="${1:-Claude Code precisa de voce}"

if command -v notify-send >/dev/null 2>&1; then
  notify-send "$title" "$message" 2>/dev/null && exit 0
fi
if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$message\" with title \"$title\"" 2>/dev/null && exit 0
fi
if command -v powershell.exe >/dev/null 2>&1; then
  powershell.exe -NoProfile -Command "[console]::beep(800,200)" 2>/dev/null && exit 0
fi
echo "[$title] $message" >&2
exit 0
