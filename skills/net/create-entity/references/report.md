# Relatório (formato)

Apresentado ao concluir ou ao parar. Uma tabela, só o que foi feito, uma linha por item.

| Item | Resultado |
|---|---|
| Arquivo | `{DomainProjectDir}/{Aggregate}/{Name}.cs`, com o `RootNamespace` resolvido |
| Entidade | tipo do `Id`, propriedades (`get`-only ou `private set`) e a factory (`Create` ou `Open`) |
| Invariantes | cada `Error` criado (`{Name}.{Reason}`) ou "nenhuma" |
| Value objects | os VOs usados, todos já existentes em `Domain/ValueObjects/` |
| Avisos | "comportamento fora do escopo", se o pedido incluía, ou "nenhum" |
| Harness | `dotnet build` e `dotnet format` passaram, ou o motivo ("Harness incompleto" em falha de ambiente) |

Ao parar, troque a tabela por uma linha: o que faltou e onde era esperado (input ausente ou inválido,
value object ausente, pacote `Result` não referenciado ou arquivo já existente). Nada foi escrito.
