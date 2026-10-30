# Relatório (formato)

Apresentado ao concluir ou ao parar. Uma tabela, só o que foi feito, em uma linha por item.

| Item | Resultado |
|---|---|
| Contrato | `.../Abstractions/Repositories/Customers/ICustomerRepository.cs` |
| Implementação | `.../Repositories/Customers/CustomerRepository.cs` |
| Métodos | `GetByIdAsync` (mapeia para `CustomerResult?`, 404 vira `null` com log) |
| Harness | `dotnet build` e `dotnet format` passaram, ou o motivo ("Harness incompleto" em falha de ambiente) |

Ao parar, troque a tabela por uma linha: o que faltou e onde era esperado (dado não informado, tipo
não encontrado ou arquivo já existente).
