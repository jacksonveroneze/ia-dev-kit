# Relatório (formato)

Dois relatórios, ambos em tabelas, texto puro, sem emoji: o **relatório da proposta**, apresentado na Fase 1 antes de qualquer gravação, e o **relatório final**, apresentado ao concluir ou ao parar.

## Relatório da proposta (antes do APROVADO)

| # | Item | Arquivo | Antes | Depois | Tipo |
|---|---|---|---|---|---|
| A1 | M-03 | `SKILL.md` | `## O que entrega` | `## O que gera` | aplicar |

Tipo: `aplicar` (será gravado se aprovado), `propor` (julgamento fora do escopo, com o texto sugerido) ou `pendência` (falta conteúdo de origem; o autor deve fornecer).

Termine com: quantidade de itens por tipo e a frase "Responda `APROVADO` para aplicar os itens do tipo aplicar, `APROVADO exceto <ids>` para excluir linhas, ou diga o que ajustar." Não grave nada enquanto não houver resposta.

## Relatório final

| Item | Resultado |
|---|---|
| Skill | `{caminho}` e escopo `{mecanico|completo}` |
| Aplicadas | itens da régua corrigidos (ex. M-03, M-04, M-06) |
| Excluídas | itens que o usuário excluiu na aprovação, ou "nenhum" |
| Arquivos | criados, movidos ou alterados, com o número de linhas do `SKILL.md` antes e depois |
| Propostas | itens de julgamento não aplicados, com o texto sugerido |
| Pendências | o que faltou de conteúdo de origem e quem deve fornecer |
| Harness | comandos dos itens M e resultado, ou "Harness incompleto" e o motivo |

## Ao parar
Troque as tabelas por uma linha: o que faltou (input ausente ou inválido, alterações pendentes no diretório, divergência de nome, arquivos de `_shared` ausentes, falha do Harness) e onde era esperado. Nada foi gravado, ou, se a parada foi na aplicação, o que já foi gravado.
