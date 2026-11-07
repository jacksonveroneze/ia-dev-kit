# Preflight

Executado no estado PREFLIGHT, antes do primeiro gate de passagem, para a revisão nunca começar com pendência. Tudo é somente leitura. Item sem evidência conta como falha. Qualquer falha: evento `alguma verificação falhou` e BLOQUEADO, listando o que corrigir.

## Verificações

| # | Verificação | Como (evidência) | Falha quando |
|---|---|---|---|
| P1 | PR acessível | `rascunho/pr.md` com número, título e SHA do head | PR inexistente ou sem acesso |
| P2 | PR aberto | estado do PR no relatório da leitura | fechado ou merged. Rascunho (draft): aviso, não falha |
| P3 | PR não parte de `main` ou `develop` | branch de origem do relatório | origem é `main` ou `develop` (PR entre branches de linha não é revisado aqui) |
| P4 | Repositório local é o do PR | `git remote get-url origin` | difere de `org/repo` do PR |
| P5 | Checkout no head do PR | `git branch --show-current`; `git rev-parse HEAD` | branch ou SHA diferente do head do PR |
| P6 | Árvore limpa | `git status --porcelain` | há saída (arquivos modificados mudariam a leitura dos revisores) |
| P7 | CI visível | checks do relatório da leitura | a consulta falhou. Sem checks configurados: registra "nenhum check", não falha. Check em falha ou pendente: aviso, não falha |
| P8 | Spec do card localizável | `card-id` extraído da descrição do PR (`/c/<id>`), do nome da branch ou do título; `ls specs/<card-id>-*/` | `card-id` encontrado e pasta ausente, ou faltando `spec.md`, `plan.md` ou `tasks.md`. Sem `card-id`: aviso, a revisão segue sem spec e o fato vai em Lacunas |
| P9 | Spec aprovada | primeiras linhas de `spec.md` (`Status:`) | `Status` diferente de `aprovada`. Só se aplica quando P8 achou a spec |
| P10 | Acesso ao GitHub | `gh auth status`; `gh repo view <repo> --json viewerPermission` | sem login ou sem permissão para ler o repositório |
| P11 | Tamanho do diff | `changedFiles` e linhas alteradas do relatório | mais de 40 arquivos ou 2000 linhas alteradas: pergunta ao usuário qual recorte revisar; o recorte vira o escopo gravado em `estado.json` |
| P12 | Arquivos de trabalho ignorados | `git check-ignore estado.json rascunho/` | algum não está no `.gitignore` |

Todas as verificações são de leitura. Nenhuma altera arquivo, branch, PR ou card.

## Relatório (formato fixo)
```
Preflight: ok | falhou
| # | Verificação | Estado | Evidência |
|---|---|---|---|
| P1 | PR acessível | ok ou falhou | <saída resumida> |
Avisos: <nenhum | lista (rascunho, CI com falha, sem spec)>
Pendências: <nenhuma | lista do que corrigir>
```

## Regras
- Não corrija nada por conta própria (nem `git pull`, nem `gh pr checkout`, nem editar `.gitignore`). Informe o que o usuário deve fazer. Motivo: o agente nunca altera a pasta nem o PR.
- Para incluir uma verificação, acrescente a linha aqui; o orquestrador a executa sem mudança no `AGENTS.md`.
- Aviso não bloqueia, mas aparece no resumo da CONSOLIDACAO.
