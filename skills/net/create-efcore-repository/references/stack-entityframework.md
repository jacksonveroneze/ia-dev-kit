# Referência da API (JacksonVeroneze.NET.EntityFramework)

Conhecimento do pacote usado pela implementação. Leia antes de escrever.

- A referência é o código-fonte do pacote na **tag da versão instalada**.
- `IEfCoreRepository<TEntity, TDbContext>` expõe `DbContext` e `DbSet` como propriedades (`efRepository.DbContext`, `efRepository.DbSet`) e resolve o `DbSet` a partir de `TEntity`.
- `GetPagedAsync<TKey>(pagination, expression, orderExpression, cancellationToken)`: `expression` e `orderExpression` são **obrigatórios e não anuláveis**; não existe overload sem eles.
- `Update(...)` e `Delete(...)` são síncronos. `SoftDelete(...)` só chama `Update` por baixo: não marca campo nenhum como excluído nem filtra as próximas queries.
- A interface também expõe `AnyAsync`, `CountAsync`, `GetAllAsync`, `GetSingleOrDefaultAsync` e `GetPagedCursorAsync` (cursor, não offset). Estão fora do catálogo: não gere wrapper para eles.
