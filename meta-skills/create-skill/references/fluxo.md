# Fluxo (máquina de estados)

Fonte única de fases, estados, transições e gates da criação de skills. A skill executa o que está aqui. Para mudar o processo (incluir, remover ou reordenar estados, trocar um gate), edite este arquivo; o `SKILL.md` só resume.

## Gates

| Palavra | Significado |
|---|---|
| AVANÇAR | Sai da Fase 1 (Refinamento) para a Fase 2 (Confirmação e criação) |
| APROVADO | Libera a escrita dos arquivos da skill |

Só a palavra exata muda o estado. Qualquer outra mensagem (pergunta, comentário, ajuste) é respondida sem mudar de estado e lembra o gate pendente. Pedido para pular fase: diga a fase atual em uma frase e continue dela.

Guardas (valem sempre, nenhum gate as desliga): nada é escrito antes do APROVADO; skill existente nunca é sobrescrita; dado faltante nunca é deduzido.

## Formato de resposta
- Toda resposta começa com `Fase X/2 - Nome`.
- Toda resposta termina com `Feito:`, `Pendente:` e `Próximo passo:`.
- A primeira resposta de cada fase termina, depois do Próximo passo, com `Ajuda: diga "ajuda" para ver como funciona esta fase.` Pedido de ajuda ("ajuda", "como usar", "exemplo") devolve a seção de Ajuda da fase atual. Ajuda só mostra: não muda de fase, não grava nada, e o exemplo, rotulado `EXEMPLO (fictício)`, nunca entra na skill.
- Tom de desenvolvedor sênior, texto puro, sem emoji.

## Estado
Não há arquivo de estado. O estado é o da última resposta: o cabeçalho `Fase X/2` e o gate pendente. Conversa sem cabeçalho anterior é o início. O contador `tentativas` é mantido na conversa.

## Estados

| Estado | Fase | Nome da fase | Ação do estado (gera o evento) |
|---|---|---|---|
| REFINAMENTO | 1 | Refinamento | Perguntar só os inputs que faltam; triar (teste da distância, skill ou rule); observar a fonte; declarar o plano |
| CONFIRMACAO | 2 | Confirmação e criação | Checar existência; mostrar o plano e os arquivos a criar (só leitura) e esperar APROVADO |
| CRIACAO | 2 | Confirmação e criação | Escrever a skill e os `references/`; verificar pelo Checklist e pelo Harness |
| BLOQUEADO | fase em que parou | Bloqueado | Relatar o motivo e o que o usuário pode fazer |
| CONCLUIDO | 2 | Concluído | Apresentar o relatório |

## Transições

| # | De | Evento | Para | Condição | Ação ao disparar | Gate |
|---|---|---|---|---|---|---|
| T1 | (início) | pedido de criar skill | REFINAMENTO | | | auto |
| T2 | REFINAMENTO | inputs completos e plano declarado | CONFIRMACAO | | | usuário:AVANÇAR |
| T3 | REFINAMENTO | reprovada no teste da distância, ou é rule | BLOQUEADO | | | auto |
| T4 | REFINAMENTO | contexto compactado e skill nascida de correção | BLOQUEADO | | | auto |
| T5 | CONFIRMACAO | skill de mesmo nome já existe | BLOQUEADO | | | auto |
| T6 | CONFIRMACAO | usuário pede ajuste | REFINAMENTO | | | auto |
| T7 | CONFIRMACAO | plano mostrado | CRIACAO | | | usuário:APROVADO |
| T8 | CRIACAO | harness passa | CONCLUIDO | | apresenta o relatório | auto |
| T9 | CRIACAO | harness falha por conteúdo | CRIACAO | `tentativas < 3` | corrige o arquivo gerado; soma 1 em `tentativas` | auto |
| T10 | CRIACAO | harness falha por conteúdo | BLOQUEADO | `tentativas = 3` | | auto |
| T11 | CRIACAO | falha de ferramenta persiste após uma nova tentativa | BLOQUEADO | | relata "Harness incompleto" | auto |

## Como usar esta tabela
1. Execute a ação do estado atual e determine o evento.
2. Ache a transição que casa com `De`, `Evento` e `Condição`.
3. Mostre o resultado do estado. Gate `usuário`: pare e peça a palavra exata. Gate `auto`: siga.
4. Ao disparar, execute a ação da transição e entre no estado `Para`.
5. Estado ou transição inexistente nesta tabela: pare e pergunte.

## Ajuda

### Geral (como usar)
- Fluxo: Refinamento (Fase 1) e Confirmação e criação (Fase 2).
- Gates: AVANÇAR (vai para a confirmação) e APROVADO (libera a escrita).
- Peça "ajuda" em qualquer fase. Para ajustar o plano, diga o que mudar; um ajuste pedido na Fase 2 volta à Fase 1.
- A skill não deduz nada: faltou dado, ela pergunta.

### Fase 1 - Refinamento
Campos com `*` são obrigatórios.

EXEMPLO (fictício):

| Campo | Exemplo |
|---|---|
| Nome e diretório* | `create-widget`, em `skills/` |
| Tipo* | gerador |
| Objetivo e gatilho* | Gera um widget a partir de uma descrição; dispara com "crie um widget"; não dispara para widgets de terceiros |
| Inputs da skill* | nome do widget (texto) e diretório de destino (caminho) |
| Saída esperada* | `{Dir}/{Name}Widget.cs` |
| Fonte do conteúdo* | convenções do projeto ou um arquivo de referência |
| Comandos de verificação* | `dotnet build` e `dotnet format --verify-no-changes`, ou "nenhum" com o motivo |

### Fase 2 - Confirmação e criação
- O plano mostrado é exatamente o que será criado. Responda APROVADO para escrever; peça ajuste para voltar ao refinamento.
- Skill de mesmo nome já existente bloqueia: esta skill não altera skill existente.
