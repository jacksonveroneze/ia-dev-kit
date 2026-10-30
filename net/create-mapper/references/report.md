# Relatório (formato)

Apresentado ao concluir ou ao parar. Uma tabela, só o que foi feito, uma linha por item.

| Item | Resultado |
|---|---|
| Arquivo | `{Operation}Mapping.cs` no slice da feature, com o `RootNamespace` resolvido |
| Membros | cada membro do `Response` com a origem declarada (`.Map`), indicando os VOs desempacotados |
| Harness | `dotnet build` e o teste de mapeamento passaram, ou o motivo ("Harness incompleto" em falha de ambiente) |

Ao parar, troque a tabela por uma linha: o que faltou e onde era esperado (input ausente ou inválido,
entidade ou `Response` inexistente, membro sem origem ou arquivo já existente). Nada foi escrito.
