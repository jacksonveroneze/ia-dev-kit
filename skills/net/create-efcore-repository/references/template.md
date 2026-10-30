# Template canônico

Molde dos dois arquivos gerados. Em conflito com os Exemplos, o Template vence. Os placeholders
recebem os valores resolvidos no passo 2 do Fluxo; nunca copie literalmente.

```csharp
// {ApplicationProjectDir}/Abstractions/Repositories/{AggregateFolder}/I{Aggregate}Repository.cs
// using {EntityNamespace};                        // só se não houver global using (passo 5)
// using JacksonVeroneze.NET.Pagination.Offset;    // só se não houver global using (passo 5)

namespace {ApplicationRootNamespace}.Abstractions.Repositories.{AggregateFolder};

public interface I{Aggregate}Repository
{
    Task<{Aggregate}?> GetByIdAsync(
        {IdType} id,
        CancellationToken cancellationToken);

    // GetPagedAsync<TKey> da lib exige filtro e ordenação; a porta fica simples (sem filtro real)
    Task<Page<{Aggregate}>> GetPagedAsync(
        int page,
        int pageSize,
        CancellationToken cancellationToken);

    Task CreateAsync(
        {Aggregate} {aggregate},
        CancellationToken cancellationToken);

    Task UpdateAsync(
        {Aggregate} {aggregate},
        CancellationToken cancellationToken);

    Task DeleteAsync(
        {Aggregate} {aggregate},
        CancellationToken cancellationToken);
}
```
```csharp
// {InfrastructureProjectDir}/Repositories/{AggregateFolder}/{Aggregate}Repository.cs
// using {EntityNamespace};                                    // só se não houver global using (passo 5)
// using JacksonVeroneze.NET.EntityFramework.Interfaces;       // só se não houver global using (passo 5)
// using JacksonVeroneze.NET.Pagination.Offset;                // só se não houver global using (passo 5)

namespace {InfrastructureRootNamespace}.Repositories.{AggregateFolder};

public sealed class {Aggregate}Repository(
    IEfCoreRepository<{Aggregate}, {DbContextType}> efRepository) : I{Aggregate}Repository
{
    // uma única chamada async, nada depois dela: sem async/await (CONV-088); sempre chaves (CONV-089)
    public Task<{Aggregate}?> GetByIdAsync(
        {IdType} id,
        CancellationToken cancellationToken)
    {
        return efRepository.GetByIdAsync(
            filter => filter.Id == id, cancellationToken);
    }

    // expression e orderExpression são obrigatórios na lib; sem filtro real pedido, predicado sempre-verdadeiro
    public Task<Page<{Aggregate}>> GetPagedAsync(
        int page,
        int pageSize,
        CancellationToken cancellationToken)
    {
        PaginationParameters pagination = new(page, pageSize);

        return efRepository.GetPagedAsync(
            pagination,
            entity => true,
            entity => entity.Id,
            cancellationToken);
    }

    // duas chamadas async em sequência: precisa de async/await
    public async Task CreateAsync(
        {Aggregate} {aggregate},
        CancellationToken cancellationToken)
    {
        await efRepository.CreateAsync(
            {aggregate}, cancellationToken);

        await efRepository.DbContext
            .SaveChangesAsync(cancellationToken);   // limite transacional
    }

    // Update() é síncrono; só a Task do SaveChangesAsync é repassada: sem async/await (CONV-088)
    public Task UpdateAsync(
        {Aggregate} {aggregate},
        CancellationToken cancellationToken)
    {
        efRepository.Update({aggregate});

        return efRepository.DbContext
            .SaveChangesAsync(cancellationToken);   // limite transacional
    }

    // Delete() é síncrono; hard delete (ver CoT para exclusão lógica)
    public Task DeleteAsync(
        {Aggregate} {aggregate},
        CancellationToken cancellationToken)
    {
        efRepository.Delete({aggregate});

        return efRepository.DbContext
            .SaveChangesAsync(cancellationToken);   // limite transacional
    }
}
```
