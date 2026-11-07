# Fluxo (máquina de estados)

Fonte única de estados, transições e gates. O orquestrador executa o que está aqui. Para mudar o processo (incluir, remover ou reordenar estados, trocar um gate), edite este arquivo; o `AGENTS.md` não muda.

## Gates

Este agente tem uma só coluna de gate e não tem modo automático: todo avanço entre etapas é manual. Para flexibilizar depois, troque o gate de uma transição por `auto`. Exemplo: para aprovar tudo de uma vez, troque o gate de T7 e T8 por `auto` e deixe T9 (APROVAR TAREFAS) como a aprovação única.

| Valor | Significado |
|---|---|
| `usuário:<PALAVRA>` | Para e espera a palavra exata. Palavras: AVANÇAR, APROVAR SPEC, APROVAR PLANO, APROVAR TAREFAS, APROVAR ARTEFATOS, VOLTAR, COMENTAR |
| `auto` | Segue sem esperar, mostra o resultado do estado e grava a transição |

Guardas (coluna Condição) não são gates: valem sempre e não se desligam por este arquivo. São o preflight, o escopo de escrita, a regra de não deduzir e as regras de git das convenções.

Com `auto` em T7, T8 ou T9, a Condição continua valendo: rascunho com item `a definir` nunca avança.

## Estados

| Estado | Etapa | Nome da etapa | Ação do estado (gera o evento) |
|---|---|---|---|
| LEITURA | 1 | Leitura e validação | `read-story-card`; conferir se o card de negócio está completo |
| PREFLIGHT | 1 | Leitura e validação | verificações de `resources/preflight.md` |
| CONTEXTO | 2 | Contexto | `context-explorer`; reunir o estado atual do código |
| SPEC | 3 | Spec | `write-spec`; refazer o rascunho a cada ajuste |
| PLANO | 4 | Plano | `write-plan`; refazer o rascunho a cada ajuste |
| TAREFAS | 5 | Tarefas | `write-tasks`; refazer o rascunho a cada ajuste |
| ENTREGA | 6 | Entrega | Parte A de `generate-spec-artifacts`; montar o preview da entrega (PR, comentário e label) |
| BLOQUEADO | etapa em que parou | Bloqueado | resumir o motivo e oferecer comentário no card |
| CONCLUIDO | 6 | Concluído | encerrar |

## Transições

| # | De | Evento | Para | Condição | Ação ao disparar | Gate |
|---|---|---|---|---|---|---|
| T1 | (início) | link do card, repositório e branch base informados | LEITURA | | | auto |
| T2 | LEITURA | card completo | PREFLIGHT | completo | | auto |
| T3 | LEITURA | card incompleto | BLOQUEADO | | | auto |
| T4 | PREFLIGHT | todas as verificações ok | CONTEXTO | nenhuma pendência | | usuário:AVANÇAR |
| T5 | PREFLIGHT | alguma verificação falhou | BLOQUEADO | | | auto |
| T6 | CONTEXTO | contexto reunido | SPEC | sem lacuna que impeça a spec | | usuário:AVANÇAR |
| T7 | SPEC | rascunho pronto | PLANO | zero item `a definir` | marca spec aprovada em `estado.json` | usuário:APROVAR SPEC |
| T8 | PLANO | rascunho pronto | TAREFAS | zero item `a definir` | marca plano aprovado | usuário:APROVAR PLANO |
| T9 | TAREFAS | rascunho pronto | ENTREGA | zero item `a definir` | marca tarefas aprovadas | usuário:APROVAR TAREFAS |
| T10 | ENTREGA | previews prontos | CONCLUIDO | consistência ok | Parte B de `generate-spec-artifacts`; depois `open-pull-request`; depois `comment-trello-card`; por fim `update-trello-card` | usuário:APROVAR ARTEFATOS |
| T11 | BLOQUEADO | comentário sobre o bloqueio | CONCLUIDO | | `comment-trello-card` | usuário:COMENTAR |
| T12 | PLANO | pedido de voltar | SPEC | | desmarca spec, plano e tarefas aprovados | usuário:VOLTAR |
| T13 | TAREFAS | pedido de voltar | PLANO | | desmarca plano e tarefas aprovados | usuário:VOLTAR |
| T14 | ENTREGA | pedido de voltar | TAREFAS | | desmarca tarefas aprovadas | usuário:VOLTAR |
| T15 | ENTREGA | consistência falhou | BLOQUEADO | | | auto |

## Como o orquestrador usa esta tabela
1. Execute a ação do estado atual e determine o evento.
2. Ache a transição com `De`, `Evento` e `Condição` que casam. Nenhuma casa (por exemplo, rascunho com item `a definir`): fique no estado, liste o que falta e pare.
3. Mostre o resultado do estado. Gate `usuário`: grave `aguardando` em `estado.json` e pare. Gate `auto`: siga.
4. Ao disparar, execute a ação da transição, atualize `estado.json` e entre no estado `Para`.
5. Estado ou transição inexistente neste arquivo: pare e pergunte.

## Como alterar
- **Remover uma aprovação manual:** troque o gate da linha por `auto`.
- **Incluir um estado:** adicione a linha em Estados e as transições de entrada e saída.
- **Autorização das skills de escrita:** com gate `auto`, o orquestrador informa às skills de escrita a autorização prévia (a transição, citada) no lugar da resposta do usuário.
