# Relatório (formato)

Apresentado ao concluir ou ao parar. Uma tabela, só o que foi feito, uma linha por item.

| Item | Resultado |
|---|---|
| Slice | `{ApplicationProjectDir}/Features/{AggregateFolder}/{Operation}/` com os arquivos criados (Request, Response, interface, UseCase, Mapper e, no paginado, Validator) |
| Compartilhados criados | tipos base, response, mapper do agregado, filtro ou `NotFound`, só os que faltavam; ou "nenhum" |
| Testes | arquivos de teste criados e os cenários cobertos |
| Avisos | "registro de DI (`IMapper`, `IRegister`, Validator) não foi feito" |
| Harness | `dotnet build`, `dotnet format`, testes e a busca por infra/transporte passaram, ou o motivo ("Harness incompleto" em falha de ambiente) |

Ao parar, troque a tabela por uma linha: o que faltou e onde era esperado (input ausente ou inválido,
porta, entidade, `DomainErrors` ou projeto de testes ausente, pedido sem padrão ou arquivo já existente). Nada foi escrito.
