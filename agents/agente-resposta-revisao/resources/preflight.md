# Preflight

Executado no estado PREFLIGHT, antes do primeiro gate de passagem, para a execução nunca começar com pendência. Tudo é leitura, exceto a linha de base (P12), que roda os comandos de verificação. Item sem evidência conta como falha. Qualquer falha: evento `alguma verificação falhou` e BLOQUEADO, listando o que corrigir.

## Verificações

| # | Verificação | Como (evidência) | Falha quando |
|---|---|---|---|
| P1 | Repositório local é o do PR | `git remote get-url origin` | difere do repositório da URL do PR |
| P2 | PR existe e está aberto | `gh pr view <n> --json state,isDraft,headRefName,baseRefName,headRefOid,mergeable` | estado diferente de `OPEN`; PR de repositório que não é o local |
| P3 | PR é do usuário | `gh api user --jq .login` comparado a `gh pr view <n> --json author` | autor diferente do usuário autenticado |
| P4 | Branch atual é a do PR | `git branch --show-current` | difere de `headRefName` |
| P5 | Branch protegida fora do jogo | nome de `headRefName` e da branch atual | é `main` ou `develop` |
| P6 | Árvore limpa | `git status --porcelain` | há saída |
| P7 | Local igual ao PR | `git fetch origin <headRefName>`; comparar `git rev-parse HEAD` com `headRefOid` | HEAD atrás, à frente ou divergente do PR |
| P8 | Base não atrasada | `git fetch origin <base>`; `git rev-list --count HEAD..origin/<base>` | contagem maior que zero, ou `mergeable` igual a `CONFLICTING` |
| P9 | Sem trabalho em andamento | `estado.json` ausente ou do mesmo PR | outro PR em andamento |
| P10 | Acesso ao GitHub com escrita | `gh auth status`; `gh repo view <repo> --json viewerPermission` | sem login ou permissão menor que WRITE |
| P11 | Spec, plano e comandos de verificação | procurar `specs/*/spec.md`, `plan.md` e `tasks.md` citados na descrição ou nos arquivos do PR; ler os comandos de build, teste, lint e format do `plan.md`, senão do `CLAUDE.md` ou `AGENTS.md` do repositório | sem nenhum conjunto de comandos. Modo rígido: pergunta ao usuário e usa a resposta. Modo automático: falha. Spec ausente não falha: registra "sem spec" |
| P12 | Linha de base verde | rodar os comandos de P11 na árvore limpa, um por vez | algum falha, ou a árvore fica suja depois |
| P13 | `estado.json` e `rascunho/` fora do versionamento | `git check-ignore estado.json rascunho/` | algum não está no `.gitignore` |

P1 a P11 e P13 são somente leitura e são a exceção listada à regra de comandos (CONV-013). Nenhuma delas altera arquivo ou branch.

## Relatório (formato fixo)
```
Preflight: ok | falhou
| # | Verificação | Estado | Evidência |
|---|---|---|---|
| P1 | Repositório local é o do PR | ok ou falhou | <saída resumida> |
Spec e plano: <caminhos | sem spec>
Comandos de verificação: <build, teste, lint, format e a origem de cada um>
Pendências: <nenhuma | lista do que corrigir>
```

## Regras
- Falha na base (P12) não é culpa dos comentários: pare antes de qualquer código.
- Não corrija nada por conta própria: nem `git pull`, nem `git rebase`, nem `git merge`, nem trocar de branch. Informe o que o usuário deve fazer. Motivo: reescrever a branch do PR exige force-push, que é proibido (CONV-008).
- Base atrasada (P8): o usuário atualiza a branch por conta própria (por exemplo, merge da base) e volta a pedir.
- Para incluir uma verificação, acrescente a linha aqui; o orquestrador a executa sem mudança no `AGENTS.md`.
