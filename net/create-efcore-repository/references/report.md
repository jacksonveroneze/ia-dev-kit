# Relatório (formato)

Apresentado ao concluir ou ao parar. Uma tabela, só o que foi feito, uma linha por item.

| Item | Resultado |
|---|---|
| Porta | `{ApplicationProjectDir}/Abstractions/Repositories/{AggregateFolder}/I{Aggregate}Repository.cs`, com o `RootNamespace` da Application |
| Implementação | `{InfrastructureProjectDir}/Repositories/{AggregateFolder}/{Aggregate}Repository.cs`, com o `RootNamespace` da Infrastructure |
| Valores resolvidos | `IdType`, `EntityNamespace` e `DbContextType` (nome real da classe) |
| Operações | `GetByIdAsync`, `GetPagedAsync`, `CreateAsync`, `UpdateAsync` e `DeleteAsync` (hard delete) |
| Harness | `dotnet build`, `dotnet format` e a revisão da porta passaram, ou o motivo ("Harness incompleto" em falha de ambiente) |

Ao parar, troque a tabela por uma linha: o que faltou e onde era esperado (agregado, entidade, referência
de pacote ou `DbContext` não encontrado ou ambíguo, ou arquivo já existente). Nada foi escrito.
