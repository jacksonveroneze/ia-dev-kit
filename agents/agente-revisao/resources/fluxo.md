# Fluxo (máquina de estados)

Fonte única de estados, transições e gates. O orquestrador executa o que está aqui. Para mudar o processo (incluir, remover ou reordenar estados, trocar um gate), edite este arquivo; o `AGENTS.md` não muda.

## Gates

Este agente tem uma só coluna de gate e não tem modo automático: todo avanço entre etapas é manual. Para flexibilizar, troque o gate de uma transição por `auto`. Exemplo: para só aprovar a lista de comentários e a publicação, troque o gate de T4, T6 e T7 por `auto` e deixe T10 (APROVAR COMENTÁRIOS) e T12 (PUBLICAR) como as aprovações.

| Valor | Significado |
|---|---|
| `usuário:<PALAVRA>` | Para e espera a palavra exata. Palavras: AVANÇAR, APROVAR COMENTÁRIOS, PUBLICAR, VOLTAR |
| `auto` | Segue sem esperar, mostra o resultado do estado e grava a transição |

Guardas (coluna Condição) não são gates: valem sempre e não se desligam por este arquivo. São o preflight, o limite de relançamentos, o escopo de escrita, o evento `COMMENT`, o bloqueio de dado protegido e as regras de git das convenções.

Com `auto` em T10 ou T12, a Condição continua valendo, e a skill de publicação recebe a autorização prévia (a transição, citada). Nunca troque T10 e T12 por `auto` sem rodar `evals/casos.md`: a revisão humana é o objetivo do fluxo.

## Estados

| Estado | Etapa | Nome da etapa | Ação do estado (gera o evento) |
|---|---|---|---|
| LEITURA | 1 | Leitura e preflight | `read-pull-request`; gravar `rascunho/pr.md` e o SHA do head |
| PREFLIGHT | 1 | Leitura e preflight | verificações de `resources/preflight.md` |
| CONTEXTO | 2 | Contexto | reunir diff, CI, comentários existentes, spec, plano e tarefas em `rascunho/contexto.md` |
| REVISAO | 3 | Revisão automática | os quatro revisores em paralelo; validar o contrato de cada saída |
| CONSOLIDACAO | 4 | Consolidação e revisão humana | consolidar achados, cenários de teste a conferir e lista de comentários; o usuário aceita, edita ou descarta |
| PUBLICACAO | 5 | Publicação | Parte A de `post-review-comments`; mostrar o preview |
| BLOQUEADO | etapa em que parou | Bloqueado | resumir o motivo e o que o usuário pode fazer |
| CONCLUIDO | 6 | Concluído | encerrar |

## Transições

| # | De | Evento | Para | Condição | Ação ao disparar | Gate |
|---|---|---|---|---|---|---|
| T1 | (início) | URL ou `org/repo#n` do PR informado | LEITURA | | | auto |
| T2 | LEITURA | PR lido | PREFLIGHT | | | auto |
| T3 | LEITURA | PR não lido | BLOQUEADO | | | auto |
| T4 | PREFLIGHT | todas as verificações ok | CONTEXTO | nenhuma pendência | | usuário:AVANÇAR |
| T5 | PREFLIGHT | alguma verificação falhou | BLOQUEADO | | | auto |
| T6 | CONTEXTO | contexto reunido | REVISAO | | | usuário:AVANÇAR |
| T7 | REVISAO | quatro relatórios válidos | CONSOLIDACAO | | | usuário:AVANÇAR |
| T8 | REVISAO | relatório inválido | REVISAO | `tentativas` do revisor `< 2` | soma 1 em `tentativas` do revisor; relança só esse revisor | auto |
| T9 | REVISAO | relatório inválido | BLOQUEADO | `tentativas` do revisor `= 2` | | auto |
| T10 | CONSOLIDACAO | lista pronta | PUBLICACAO | ao menos 1 comentário aceito; nenhum dado protegido | grava `rascunho/comentarios.md` como lista final | usuário:APROVAR COMENTÁRIOS |
| T11 | CONSOLIDACAO | nenhum comentário | CONCLUIDO | todos descartados ou nenhum achado | | usuário:AVANÇAR |
| T12 | PUBLICACAO | preview pronto | CONCLUIDO | head igual ao SHA gravado | Parte B de `post-review-comments` | usuário:PUBLICAR |
| T13 | PUBLICACAO | PR mudou | BLOQUEADO | | | auto |
| T14 | PUBLICACAO | dado protegido | CONSOLIDACAO | | mostra onde mascarar | auto |
| T15 | PUBLICACAO | pedido de voltar | CONSOLIDACAO | | | usuário:VOLTAR |
| T16 | BLOQUEADO | bloqueio resumido | LEITURA | usuário corrigiu o problema | zera `tentativas` e `preflight` | usuário:AVANÇAR |

## Como o orquestrador usa esta tabela
1. Execute a ação do estado atual e determine o evento.
2. Ache a transição com `De`, `Evento` e `Condição` que casam. Nenhuma casa (por exemplo, lista final vazia ou com dado protegido): fique no estado, liste o que falta e pare.
3. Mostre o resultado do estado. Gate `usuário`: grave `aguardando` em `estado.json` e pare. Gate `auto`: siga.
4. Ao disparar, execute a ação da transição, atualize `estado.json` e entre no estado `Para`.
5. Estado ou transição inexistente neste arquivo: pare e pergunte.

## Como alterar
- **Remover uma aprovação manual:** troque o gate da linha por `auto`.
- **Incluir um estado:** adicione a linha em Estados e as transições de entrada e saída. Exemplo: um estado de "resposta ao autor" depois de PUBLICACAO.
- **Incluir um revisor:** crie o arquivo em `.claude/agents/` e acrescente-o na ação de REVISAO e na condição de T7.
- **Autorização da skill de escrita:** com gate `auto` em T12, o orquestrador informa a `post-review-comments` a autorização prévia (a transição, citada) no lugar da resposta do usuário.
