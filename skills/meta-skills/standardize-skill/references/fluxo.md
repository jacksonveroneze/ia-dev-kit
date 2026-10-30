# Fluxo (máquina de estados)

Fonte única de fases, estados, transições e gates da padronização de skills. A skill executa o que está aqui. Para mudar o processo (incluir, remover ou reordenar estados, trocar um gate), edite este arquivo; o `SKILL.md` só resume.

## Gates

| Palavra | Significado |
|---|---|
| APROVADO | Libera a gravação dos itens do tipo `aplicar` do relatório da proposta |
| APROVADO exceto `<ids>` | Libera a gravação de todos os itens `aplicar`, menos os listados (ex.: `APROVADO exceto A3, A5`) |

Só essas respostas, começando pela palavra exata, mudam o estado. Qualquer outra mensagem (pergunta, comentário, pedido de ajuste) é respondida sem mudar de estado e lembra o gate pendente. Pedido para pular fase ("já aplica"): diga a fase atual em uma frase e continue dela.

Linhas que dependem uma da outra (mover arquivo e atualizar a citação dele) formam um único item, ou são excluídas juntas.

Guardas (valem sempre, nenhum gate as desliga): nada é gravado antes do APROVADO; só se grava no diretório da skill alvo; o significado de Inputs, Rules, Template e fluxo da skill nunca muda; conteúdo ausente nunca é inventado.

## Formato de resposta
- Toda resposta começa com `Fase X/2 - Nome`.
- Toda resposta termina com `Feito:`, `Pendente:` e `Próximo passo:`.
- A primeira resposta de cada fase termina, depois do Próximo passo, com `Ajuda: diga "ajuda" para ver como funciona esta fase.` Pedido de ajuda ("ajuda", "como usar", "exemplo") devolve a seção de Ajuda da fase atual. Ajuda só mostra: não muda de fase, não grava nada, e o exemplo, rotulado `EXEMPLO (fictício)`, nunca entra na skill alvo.
- Tom de desenvolvedor sênior, texto puro, sem emoji.

## Estado
Não há arquivo de estado. O estado é o da última resposta: o cabeçalho `Fase X/2` e o gate pendente. Conversa sem cabeçalho anterior é o início.

## Estados

| Estado | Fase | Nome da fase | Ação do estado (gera o evento) |
|---|---|---|---|
| PROPOSTA | 1 | Proposta | Validar inputs (perguntar só o que falta); localizar a skill alvo; conferir `git status`; diagnosticar; classificar cada desvio; montar e mostrar o relatório da proposta (só leitura) e esperar APROVADO |
| APLICACAO | 2 | Aplicação | Aplicar os itens aprovados na ordem de `correcoes.md`; verificar pelo Harness |
| BLOQUEADO | fase em que parou | Bloqueado | Relatar o motivo e o que o usuário pode fazer |
| CONCLUIDO | 2 | Concluído | Apresentar o relatório final |

## Transições

| # | De | Evento | Para | Condição | Ação ao disparar | Gate |
|---|---|---|---|---|---|---|
| T1 | (início) | pedido de padronizar uma skill | PROPOSTA | | | auto |
| T2 | PROPOSTA | pré-condição falhou (skill ou `_shared` ausente, diretório com alterações pendentes, pasta fora de kebab-case, nome divergente da pasta) | BLOQUEADO | | | auto |
| T3 | PROPOSTA | nenhum desvio a aplicar | CONCLUIDO | | apresenta o relatório com "nada a aplicar" | auto |
| T4 | PROPOSTA | relatório da proposta mostrado | APLICACAO | | | usuário:APROVADO |
| T5 | PROPOSTA | usuário pede ajuste (escopo, itens) | PROPOSTA | | refaz o diagnóstico e a proposta | auto |
| T6 | APLICACAO | harness passa | CONCLUIDO | | apresenta o relatório final | auto |
| T7 | APLICACAO | divergência em relação à proposta aprovada (arquivo novo, valor diferente) | PROPOSTA | | para e reapresenta a proposta atualizada | auto |
| T8 | APLICACAO | harness falha por conteúdo | BLOQUEADO | | relata os primeiros erros; não edita além da proposta | auto |
| T9 | APLICACAO | falha de ferramenta persiste após uma nova tentativa | BLOQUEADO | | relata "Harness incompleto" | auto |

## Como usar esta tabela
1. Execute a ação do estado atual e determine o evento.
2. Ache a transição que casa com `De`, `Evento` e `Condição`.
3. Mostre o resultado do estado. Gate `usuário`: pare e peça a resposta exata. Gate `auto`: siga.
4. Ao disparar, execute a ação da transição e entre no estado `Para`.
5. Estado ou transição inexistente nesta tabela: pare e pergunte.

## Ajuda

### Geral (como usar)
- Fluxo: Proposta (Fase 1) e Aplicação (Fase 2).
- A skill propõe as mudanças em um relatório, sem gravar. Você responde `APROVADO` para aplicar tudo, ou `APROVADO exceto A3, A5` para excluir linhas.
- Peça "ajuda" em qualquer fase. Para ajustar a proposta (escopo, itens), diga o que mudar: a skill refaz o relatório.
- A skill não inventa conteúdo: o que falta de origem vira pendência para o autor.

### Fase 1 - Proposta
Campos com `*` são obrigatórios.

EXEMPLO (fictício):

| Campo | Exemplo |
|---|---|
| Skill alvo* | `skills/create-widget` |
| Escopo | `mecanico` (padrão) ou `completo` |
| Relatório de desvios* | `reports/create-widget.md`, ou `nenhum` para diagnosticar com a régua |

### Fase 2 - Aplicação
- Só o que você aprovou é gravado, e só dentro do diretório da skill alvo.
- Se algo divergir da proposta durante a aplicação, a skill para e volta à Fase 1 com a proposta atualizada.
