# Fluxo (máquina de estados)

Fonte única de estados, transições e gates. O orquestrador executa o que está aqui. Para mudar o processo (incluir, remover ou reordenar estados, trocar um gate), edite este arquivo; o `AGENTS.md` não muda.

## Modo

modo: rígido

Valores: `rígido` ou `automático`. A coluna de gate usada é a do modo. O modo é gravado em `estado.json` no início da execução e não muda no meio dela. O modo `automático` só deve ser ligado depois de rodar `evals/casos.md`. Mesmo no automático, a decisão por comentário (CONCORDAR, CONTESTAR, PERGUNTAR) é do usuário: o gate da triagem permanece de usuário nos dois modos (CONV-004).

## Gates

| Valor | Significado |
|---|---|
| `usuário:<PALAVRA>` | Para e espera a palavra exata. Palavras: AVANÇAR, APROVAR TRIAGEM, APROVAR CORREÇÕES, AJUSTAR, AUTORIZAR PUSH, APROVAR RESPOSTAS |
| `auto` | Segue sem esperar, mostra o resultado do estado e grava a transição |

Guardas (coluna Condição) não são gates: valem em todos os modos e não se desligam por este arquivo. São os limites de tentativa, o escopo de escrita, o preflight, as regras de git e o merge e a resolução das threads, que são humanos.

## Estados

| Estado | Etapa | Nome da etapa | Ação do estado (gera o evento) |
|---|---|---|---|
| LEITURA | 1 | Leitura e preflight | `read-review-comments`; conferir se há o que tratar |
| PREFLIGHT | 1 | Leitura e preflight | verificações de `resources/preflight.md` |
| TRIAGEM | 2 | Triagem | `comment-triager`; tabela com recomendação por comentário |
| CORRECAO | 3 | Correção | `fix-implementer` (e `test-writer` se pedido); build, teste, lint e format |
| REVISAO_DIFF | 4 | Revisão do diff | mostrar o diff por comentário aceito |
| COMMIT | 5 | Commit e resposta | commits na branch do PR; preview do push |
| RESPOSTA | 5 | Commit e resposta | Parte A de `reply-review-comment` |
| BLOQUEADO | etapa em que parou | Bloqueado | resumir o motivo e o que o usuário pode fazer |
| CONCLUIDO | 6 | Concluído | encerrar |

## Transições

| # | De | Evento | Para | Condição | Ação ao disparar | Gate rígido | Gate automático |
|---|---|---|---|---|---|---|---|
| T1 | (início) | PR informado | LEITURA | | | auto | auto |
| T2 | LEITURA | há comentário a tratar | PREFLIGHT | PR aberto e ao menos uma thread não resolvida | | auto | auto |
| T3 | LEITURA | nada a tratar | BLOQUEADO | PR fechado, ou nenhuma thread não resolvida | | auto | auto |
| T4 | PREFLIGHT | todas as verificações ok | TRIAGEM | nenhuma pendência | | usuário:AVANÇAR | auto |
| T5 | PREFLIGHT | alguma verificação falhou | BLOQUEADO | | | auto | auto |
| T6 | TRIAGEM | triagem pronta | CORRECAO | decisões do usuário com ao menos um CONCORDAR | grava as decisões em `rascunho/triagem.md` | usuário:APROVAR TRIAGEM | usuário:APROVAR TRIAGEM |
| T7 | TRIAGEM | triagem pronta | RESPOSTA | decisões do usuário sem nenhum CONCORDAR | grava as decisões em `rascunho/triagem.md` | usuário:APROVAR TRIAGEM | usuário:APROVAR TRIAGEM |
| T8 | CORRECAO | comandos passam | REVISAO_DIFF | | | usuário:AVANÇAR | auto |
| T9 | CORRECAO | comandos falham | CORRECAO | `tentativas < 2` | soma 1 em `tentativas` | auto | auto |
| T10 | CORRECAO | comandos falham | BLOQUEADO | `tentativas = 2` | | auto | auto |
| T11 | REVISAO_DIFF | diff pronto | COMMIT | | | usuário:APROVAR CORREÇÕES | usuário:APROVAR CORREÇÕES |
| T12 | REVISAO_DIFF | ajuste pedido | CORRECAO | `ciclos < 2` | soma 1 em `ciclos`; zera `tentativas` | usuário:AJUSTAR | usuário:AJUSTAR |
| T13 | REVISAO_DIFF | ajuste pedido | BLOQUEADO | `ciclos = 2` | | auto | auto |
| T14 | COMMIT | commits criados | RESPOSTA | branch do PR, nunca `main` nem `develop` | `git push` normal (sem force) da branch do PR; conferir que o PR recebeu os commits | usuário:AUTORIZAR PUSH | usuário:AUTORIZAR PUSH |
| T15 | COMMIT | push rejeitado | BLOQUEADO | | | auto | auto |
| T16 | RESPOSTA | previews prontos | CONCLUIDO | | Parte B de `reply-review-comment` (sem resolver thread) | usuário:APROVAR RESPOSTAS | usuário:APROVAR RESPOSTAS |
| T17 | BLOQUEADO | bloqueio resumido | CONCLUIDO | | | auto | auto |

As transições T6, T7, T11, T12, T14 e T16 mantêm gate de usuário também no modo automático: decisão por comentário, diff, push e publicação de respostas não são delegados às cegas.

## Como o orquestrador usa esta tabela
1. Execute a ação do estado atual e determine o evento.
2. Ache a transição com `De`, `Evento` e `Condição` que casam.
3. Mostre o resultado do estado. Gate `usuário`: grave `aguardando` em `estado.json` e pare. Gate `auto`: siga.
4. Ao disparar, execute a ação da transição, atualize `estado.json` e entre no estado `Para`.
5. Estado ou transição inexistente neste arquivo: pare e pergunte.

## Observações
- **Decisões na triagem:** no estado TRIAGEM o usuário ajusta as decisões por comentário em mensagens livres (por exemplo, "o 3 vira CONTESTAR"). Essas mensagens não mudam o estado: o orquestrador reapresenta a tabela. A palavra APROVAR TRIAGEM confirma a tabela como está.
- **Sem correção:** se todas as decisões são CONTESTAR ou PERGUNTAR (T7), não há código, commit nem push; vai direto às respostas.
- **Resolução das threads:** nenhuma transição resolve thread. O revisor ou o autor resolvem, depois de ver a resposta ou o commit. O merge é humano.
- **Autorização das skills de escrita:** `reply-review-comment` recebe a frase do usuário que satisfez APROVAR RESPOSTAS. Nenhuma transição usa autorização prévia para publicar respostas.

## Como alterar
- **Remover uma aprovação manual:** troque o gate da linha por `auto` na coluna do modo desejado (exceto as transições listadas acima, que a convenção protege).
- **Ligar a automação:** troque `modo: rígido` por `modo: automático` e ajuste a coluna automática.
- **Incluir um estado:** adicione a linha em Estados e as transições de entrada e saída.
