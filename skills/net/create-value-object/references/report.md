# Relatório (formato)

Apresentado ao concluir ou ao parar. Uma tabela, só o que foi feito, uma linha por item.

| Item | Resultado |
|---|---|
| Arquivo | `{DomainProjectDir}/ValueObjects/{Name}.cs`, com o `RootNamespace` resolvido |
| Value object | campos, a factory `Create` e o tipo do retorno (`Result<{Name}>`) |
| Invariantes | cada `Error` criado (`{Name}.{Reason}`), ou "nenhuma" |
| Regex e PII | `[GeneratedRegex]` com timeout e guard de tamanho, `ToString` mascarado; ou "não se aplica" |
| Harness | `dotnet build`, `dotnet format` e `dotnet test` passaram, ou o motivo ("Harness incompleto" em falha de ambiente) |

Ao parar, troque a tabela por uma linha: o que faltou e onde era esperado (input ausente ou inválido,
pacote `Result` não referenciado ou arquivo já existente). Nada foi escrito.
