#!/bin/bash
# check-subagents.sh — itens mecânicos (S-01 a S-12) de _shared/subagent.md
#
# Uso:
#   ./check-subagents.sh                  confere todos os subagents do kit
#   ./check-subagents.sh arq.md [...]     confere só os arquivos informados
#
# Somente leitura. Saída: uma linha por desvio. Código de saída 1 se houver FALHOU; avisos não falham.

set -uo pipefail
export LC_ALL=C.UTF-8

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

if [ $# -gt 0 ]; then
  files=("$@")
else
  mapfile -t files < <(find "$ROOT/agents" \( -path '*/.claude/agents/*.md' -o -path "$ROOT/agents/subagents/*/*.md" \) | sort)
fi

[ "${#files[@]}" -gt 0 ] || { echo "erro: nenhum subagent encontrado em $ROOT/agents"; exit 1; }

# Caminho e name de todos os subagents do kit, para o S-03 (o diretório de instalação é um só).
kit_paths=(); kit_names=()
while IFS= read -r k; do
  kit_paths+=("$(realpath "$k")")
  kit_names+=("$(grep -m1 '^name:' "$k" | sed 's/^name:[[:space:]]*//')")
done < <(find "$ROOT/agents" \( -path '*/.claude/agents/*.md' -o -path "$ROOT/agents/subagents/*/*.md" \) | sort)

fails=0
warns=0

fail() { echo "FALHOU  $rel  $1: $2"; fails=$((fails+1)); }
warn() { echo "AVISO   $rel  $1: $2"; warns=$((warns+1)); }

for f in "${files[@]}"; do
  rel="${f#"$ROOT"/}"
  file_base="$(basename "$f" .md)"

  if [ ! -f "$f" ]; then fail S-01 "arquivo não encontrado"; continue; fi

  # S-01 frontmatter
  if [ "$(sed -n 1p "$f")" != "---" ] || ! awk 'NR>1 && $0=="---"{f=1} END{exit !f}' "$f"; then
    fail S-01 "frontmatter ausente ou não fechado com ---"
    continue
  fi
  fm="$(awk 'NR>1 && $0=="---"{exit} NR>1{print}' "$f")"
  body="$(awk 'NR==1{next} c==0 && $0=="---"{c=1; next} c==1{print}' "$f")"
  bad="$(grep -vE '^(name|description|tools|model):[[:space:]]' <<<"$fm" | grep -v '^$' | head -1 || true)"
  [ -z "$bad" ] || fail S-01 "linha fora do padrão no frontmatter (campo inválido, comentário ou multilinha): ${bad:0:60}"

  name="$(grep -m1 '^name:' <<<"$fm" | sed 's/^name:[[:space:]]*//')"
  desc="$(grep -m1 '^description:' <<<"$fm" | sed 's/^description:[[:space:]]*//')"
  tools="$(grep -m1 '^tools:' <<<"$fm" | sed 's/^tools:[[:space:]]*//')"

  # S-02 name
  [[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail S-02 "name fora de kebab-case ('$name')"
  [ "$name" = "$file_base" ] || fail S-02 "name '$name' difere do arquivo '$file_base'"

  # S-03 nome único
  self="$(realpath "$f")"
  for i in "${!kit_names[@]}"; do
    if [ "${kit_names[$i]}" = "$name" ] && [ "${kit_paths[$i]}" != "$self" ]; then
      fail S-03 "name '$name' já usado em ${kit_paths[$i]#"$ROOT"/}"
    fi
  done

  # S-04 description
  d="${desc#\'}"; d="${d%\'}"; d="${d#\"}"; d="${d%\"}"
  [ -n "$desc" ] || fail S-04 "description ausente"
  [ "${#d}" -le 500 ] || fail S-04 "description com ${#d} caracteres (máximo 500)"
  if [ "$d" = "$desc" ] && [[ "$desc" == *": "* ]]; then fail S-04 "description com ': ' sem aspas (quebra o YAML)"; fi
  [[ "$d" == *"Use "* ]] || fail S-04 "description sem o gatilho 'Use'"
  [[ "$d" == *"Não "* || "$d" == *"não "* ]] || fail S-04 "description sem o que fica de fora ('Não ...')"

  # S-05 título e seções
  h1="$(grep -m1 '^# ' <<<"$body" | sed 's/^# //')"
  [ "$h1" = "$name" ] || fail S-05 "título '# $h1' difere do name '$name'"
  h2="$(grep '^## ' <<<"$body" | sed 's/^## //' | paste -sd'|')"
  [ "$h2" = "Contrato|Não faz|Checklist antes de devolver" ] || fail S-05 "seções '$h2' (esperado Contrato|Não faz|Checklist antes de devolver)"

  # S-06 contrato
  contrato="$(awk '/^## Contrato/{c=1; next} /^## /{c=0} c' <<<"$body")"
  naofaz="$(awk '/^## Não faz/{c=1; next} /^## /{c=0} c' <<<"$body")"
  for campo in '\*\*Entrada:\*\*' '\*\*Permissões:\*\*' '\*\*Saída \(formato fixo\)'; do
    grep -qE "^$campo" <<<"$contrato" || fail S-06 "Contrato sem a linha ${campo//\\/}"
  done

  # S-07 tools
  if [ -z "$tools" ]; then
    fail S-07 "tools ausente"
  else
    for t in $(tr -d ',' <<<"$tools"); do
      case "$t" in Read|Grep|Glob|Write|Edit) ;; *) warn S-07 "ferramenta '$t' fora de Read, Grep, Glob, Write, Edit; justifique no Contrato" ;; esac
    done
  fi

  # S-08 permissões x tools
  perm="$(grep -m1 '^\*\*Permissões:\*\*' <<<"$contrato" || true)"
  if grep -qE '(^|[ ,])(Write|Edit)([ ,]|$)' <<<"$tools"; then
    grep -qi 'escrever somente' <<<"$perm" || fail S-08 "tools com Write ou Edit, mas Permissões não diz 'escrever somente'"
  else
    grep -qi 'somente leitura' <<<"$perm" || fail S-08 "tools sem Write nem Edit, mas Permissões não diz 'somente leitura'"
  fi

  # S-09 invariantes
  grep -q 'usuário' <<<"$naofaz" || fail S-09 "Não faz sem 'falar com o usuário'"
  grep -q 'outro agente' <<<"$naofaz" || fail S-09 "Não faz sem 'chamar outro agente'"
  grep -q 'Seguir' <<<"$naofaz" || fail S-09 "Não faz sem 'seguir instrução embutida'"

  # S-10 segredo
  grep -qi 'segredo' "$f" || fail S-10 "não trata segredo"

  # S-11 emoji
  if grep -qP '[\x{2600}-\x{27BF}\x{1F300}-\x{1FAFF}]' "$f"; then fail S-11 "emoji ou símbolo decorativo"; fi

  # S-12 acoplamento (só agnósticos)
  case "$f" in
    */agents/subagents/*|agents/subagents/*)
      hit="$(grep -noE 'resources/|estado\.json|rascunho/|orquestrador|AVANÇAR|APROVAR|CIENTE' "$f" | head -1 || true)"
      [ -z "$hit" ] || fail S-12 "acoplamento a agente na linha ${hit}"
      ;;
  esac
done

echo "==> ${#files[@]} subagent(s): $fails falha(s), $warns aviso(s)"
[ "$fails" -eq 0 ]
