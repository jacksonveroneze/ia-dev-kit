# Preflight

Executado no estado PREFLIGHT, antes do primeiro gate de passagem, para a execução nunca começar com pendência. Tudo é leitura. Item sem evidência conta como falha. Qualquer falha: evento `alguma verificação falhou` e BLOQUEADO, listando o que corrigir. `aviso` (P12 e P13) não é falha: o preflight segue `ok` e o aviso aparece no relatório. P12: a ausência é repassada ao `context-explorer` para constar em `Lacunas`. P13: card fora da lista `Refinado` exige confirmação explícita do usuário no gate de AVANÇAR (T4).

Os dados de repositório e branch base vêm do usuário no início (T1), porque o card de negócio não os traz.

## Verificações

| # | Verificação | Como (evidência) | Falha quando |
|---|---|---|---|
| P1 | Repositório local é o informado | `git remote get-url origin` | difere do repositório informado |
| P2 | Branch atual é a base informada | `git branch --show-current` | difere da base |
| P3 | Árvore limpa | `git status --porcelain` | há saída |
| P4 | Base atualizada | `git fetch origin <base>`; comparar `git rev-parse HEAD` e `origin/<base>` | HEAD atrás ou divergente |
| P5 | Sem trabalho em andamento | `estado.json` ausente ou do mesmo card; `git branch -a`; `gh pr list --state open` | outro card em andamento; branch ou PR `spec/<slug>` já existe |
| P6 | Ferramentas | `command -v git` e `command -v gh` | algum ausente |
| P7 | Acesso ao GitHub com escrita | `gh auth status`; `gh repo view <repo> --json viewerPermission` | sem login ou permissão menor que WRITE |
| P8 | Arquivos de trabalho ignorados | `git check-ignore estado.json rascunho/` | algum não está no `.gitignore` |
| P9 | Destino dos artefatos livre | listar `specs/` na base | já existe `specs/<card-id>-*` |
| P10 | Cards de dependência legíveis | ler, com a skill de leitura de card, cada card citado por LINK em `Depende de` (somente leitura). Dependência sem link (só título) é pendência a resolver com o usuário; nunca se busca o card por palavra, título ou adivinhação | card inexistente ou sem acesso, ou dependência citada sem link |
| P11 | Lista `Especificado` existe no board do card | ler o board do card e listar os nomes das listas (somente leitura); citar o nome encontrado | nenhuma lista `Especificado`, ou mais de uma que case |
| P12 | `specs/constitution.md` do repositório-alvo | `ls specs/constitution.md`; existindo, `git log -1 --format=%h -- specs/constitution.md` | nunca falha: ausente vira `aviso` (não bloqueia) |
| P13 | Card está na lista `Refinado` | ler o card e a lista em que está (somente leitura); citar o nome da lista atual | nunca falha: lista diferente de `Refinado`, ou lista não determinada, vira `aviso` (não bloqueia) |

Nenhuma verificação altera arquivo, branch ou card.

## Relatório (formato fixo)
```
Preflight: ok | falhou
| # | Verificação | Estado | Evidência |
|---|---|---|---|
| P1 | Repositório local é o informado | ok ou falhou (P12 e P13: ok ou aviso) | <saída resumida> |
Pendências: <nenhuma | lista do que corrigir>
Avisos: <nenhum | constitution ausente: ... | card fora de Refinado: lista atual <nome>; requer confirmação explícita no AVANÇAR>
```

## Regras
- Não corrija nada por conta própria (nem `git pull`, nem trocar de branch, nem editar o `.gitignore`). Informe o que o usuário deve fazer.
- Aviso P13: o orquestrador mostra o aviso e, antes de aceitar AVANÇAR, pede que o usuário confirme em frase própria que quer especificar com o card fora de `Refinado` (por exemplo, "confirmo seguir com o card em Backlog"). Sem a confirmação, AVANÇAR não libera; com ela, grava em `estado.json` e o AVANÇAR vale.
- Para incluir uma verificação, acrescente a linha aqui; o orquestrador a executa sem mudança no `AGENTS.md`.
