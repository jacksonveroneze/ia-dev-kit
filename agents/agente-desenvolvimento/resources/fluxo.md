# Fluxo (máquina de estados)

Fonte única de estados, transições e gates. O orquestrador executa o que está aqui. Para mudar o processo (incluir, remover ou reordenar estados, trocar um gate), edite este arquivo; o `AGENTS.md` não muda.

## Gates

Este agente tem uma só coluna de gate e não tem modo automático: todo avanço entre etapas é manual. Para flexibilizar depois, troque o gate de uma transição por `auto`. Exemplo: para ir dos testes ao código sem parar, troque o gate de T6 e T7 por `auto`. Só faça isso depois de rodar `evals/casos.md`.

| Valor | Significado |
|---|---|
| `usuário:<PALAVRA>` | Para e espera a palavra exata. Palavras: AVANÇAR, APROVAR PR, COMENTAR |
| `auto` | Segue sem esperar, mostra o resultado do estado e grava a transição |

DESCARTAR não é gate de transição: é a confirmação do motor para descartar um `estado.json` CONCLUIDO de outra tarefa e iniciar a nova execução (T1), sem sobrescrever antes dela.

Guardas (coluna Condição) não são gates: valem sempre e não se desligam por este arquivo. São o preflight, os limites de tentativa, o escopo de escrita, o vermelho antes do código, a regra de não deduzir e as regras de git das convenções.

## Estados

| Estado | Etapa | Nome da etapa | Ação do estado (gera o evento) |
|---|---|---|---|
| LEITURA | 1 | Leitura e validação | `read-trello-card` só para o link e a label; conferir `agent-ready` |
| PREFLIGHT | 1 | Leitura e validação | verificações de `resources/preflight.md`; Parte A de `move-trello-card` (In Progress) |
| TESTES | 2 | Testes | `code-explorer`; `test-writer` (pula se a tarefa não tem testes); comprovar o vermelho |
| CODIGO | 3 | Código | `dotnet-implementer`; loop de build, teste, lint e format do plano; documentação listada |
| REVISAO | 4 | Revisão | `reviewer` |
| ENTREGA | 5 | Entrega | Parte A de `open-pull-request`, `comment-trello-card` e `move-trello-card` (In Review) |
| BLOQUEADO | etapa em que parou | Bloqueado | resumir o motivo e oferecer comentário no card |
| CONCLUIDO | 5 | Concluído | encerrar |

## Transições

| # | De | Evento | Para | Condição | Ação ao disparar | Gate |
|---|---|---|---|---|---|---|
| T1 | (início) | link do card informado | LEITURA | | | auto |
| T2 | LEITURA | card elegível | PREFLIGHT | label `agent-ready` | | auto |
| T3 | LEITURA | card não elegível | BLOQUEADO | | | auto |
| T4 | PREFLIGHT | todas as verificações ok | TESTES | nenhuma pendência | grava a tarefa em `estado.json`; Parte B de `move-trello-card` (In Progress), com a frase AVANÇAR citada como autorização; card já em In Progress: não move | usuário:AVANÇAR |
| T5 | PREFLIGHT | alguma verificação falhou | BLOQUEADO | | | auto |
| T6 | TESTES | testes vermelhos | CODIGO | vermelho comprovado com evidência | | usuário:AVANÇAR |
| T7 | TESTES | tarefa sem testes | CODIGO | `tasks.md` não lista critérios nem testes para a tarefa | | usuário:AVANÇAR |
| T8 | TESTES | vermelho não comprovado | BLOQUEADO | | | auto |
| T9 | CODIGO | comandos passam | REVISAO | build, teste, lint e format (se listado) com evidência | | usuário:AVANÇAR |
| T10 | CODIGO | comandos falham | CODIGO | `tentativas < 2` | soma 1 em `tentativas` | auto |
| T11 | CODIGO | comandos falham | BLOQUEADO | `tentativas = 2` | soma 1 em `tentativas` | auto |
| T12 | REVISAO | APROVADO | ENTREGA | | | usuário:AVANÇAR |
| T13 | REVISAO | REPROVADO | CODIGO | `ciclos < 2` | soma 1 em `ciclos`; zera `tentativas` | auto |
| T14 | REVISAO | REPROVADO | BLOQUEADO | `ciclos = 2` | | auto |
| T15 | ENTREGA | previews prontos | CONCLUIDO | | Parte B de `open-pull-request`; depois Parte B de `comment-trello-card` com o link do PR; por fim Parte B de `move-trello-card` (In Review; card já em In Review: não move) | usuário:APROVAR PR |
| T16 | BLOQUEADO | comentário sobre o bloqueio | CONCLUIDO | | `comment-trello-card` | usuário:COMENTAR |

## Como o orquestrador usa esta tabela
1. Execute a ação do estado atual e determine o evento.
2. Ache a transição com `De`, `Evento` e `Condição` que casam. Nenhuma casa: fique no estado, liste o que falta e pare.
3. Mostre o resultado do estado. Gate `usuário`: grave `aguardando` em `estado.json` e pare. Gate `auto`: siga.
4. Ao disparar, execute a ação da transição, atualize `estado.json` e entre no estado `Para`.
5. Estado ou transição inexistente neste arquivo: pare e pergunte.

## Como alterar
- **Remover uma aprovação manual:** troque o gate da linha por `auto`.
- **Incluir um estado:** adicione a linha em Estados e as transições de entrada e saída.
- **Autorização das skills de escrita:** com gate `auto`, o orquestrador informa às skills `open-pull-request`, `comment-trello-card` e `move-trello-card` a autorização prévia (a transição, citada) no lugar da resposta do usuário.
- **Nunca** mover o card para Done: é do humano, depois do merge.
