# Relatório (formato)

Apresentado ao concluir ou ao parar. Uma tabela, só o que foi feito, uma linha por item.

| Item | Resultado |
|---|---|
| Endpoint | `{ApiProjectDir}/Endpoints/{AggregateFolder}/v1/{Operation}Endpoint.cs` e, no paginado, os modelos REST em `Models/` |
| Acréscimos | linha na cadeia do `RouteMappings`, chamada no `Program.cs` e constante `RouteNames` (só o que faltava) |
| Compartilhados criados | `ResultTranslator` e `RouteMappings`, só se não existiam; ou "nenhum" |
| Testes | arquivos criados e cenários cobertos, ou "projeto de testes ausente: não criado" |
| Avisos | "registro de DI (use cases, `IValidator<>`, `IMapper`, `IRegister`) não foi feito: sem ele o endpoint falha em runtime" |
| Harness | `dotnet build`, `dotnet format`, testes e a busca por termos proibidos passaram, ou o motivo ("Harness parcial" sem projeto de testes; "Harness incompleto" em falha de ambiente) |

Ao parar, troque a tabela por uma linha: o que faltou e onde era esperado (input ausente ou inválido, use
case, helper da Api ou pedido sem padrão, ou arquivo já existente). Nada foi escrito.
