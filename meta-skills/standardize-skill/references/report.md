# Relatório (formato)

Apresentado ao concluir ou ao parar. Texto puro, sem emoji. O mapa de alterações é mostrado antes de
gravar (para confirmação) e o relatório final é apresentado depois.

## Mapa de alterações (antes de gravar)

| # | Item | Arquivo | Antes | Depois | Tipo |
|---|---|---|---|---|---|

Tipo: aplicar, propor ou pendência. Ao final do mapa: "Confirma a aplicação dos itens do tipo aplicar?"

## Relatório final

| Item | Resultado |
|---|---|
| Skill | `{caminho}` e escopo `{mecanico|completo}` |
| Aplicadas | itens da régua corrigidos (ex. M-03, M-04, M-06) |
| Arquivos | criados, movidos ou alterados, com o número de linhas do `SKILL.md` antes e depois |
| Propostas | itens de julgamento não aplicados, com o texto sugerido |
| Pendências | o que faltou de conteúdo de origem e quem deve fornecer |
| Harness | comandos dos itens M e resultado, ou "Harness incompleto" e o motivo |

Próximo passo: validar com a `audit-skill`, em contexto limpo.

Ao parar, troque as tabelas por uma linha: o que faltou (input ausente ou inválido, alterações
pendentes no diretório, divergência de nome, arquivos de `_shared` ausentes, mapa sem confirmação) e
onde era esperado. Nada foi alterado.
