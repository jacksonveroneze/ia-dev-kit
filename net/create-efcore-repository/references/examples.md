# Exemplos (certo e errado)

Exemplos de apoio do `SKILL.md`. Em conflito com o Template canônico (`template.md`), o Template vence;
os exemplos são reforço didático, não a fonte primária.

Pedido: "repositório do agregado Account." (`Aggregate=Account`, `AggregateFolder=Accounts`,
`IdType=Guid`.)

Errado — sem contexto: generic repository, síncrono, vaza `IQueryable`, porta junto da
implementação e fora da Application, injeta `DbContext` direto:
```csharp
namespace Bank.Infrastructure;                        // porta junto da impl, fora da Application
public interface IRepository<T>                       // generic repository (CONV-081)
{
    IQueryable<T> Query();                            // vaza IQueryable (CONV-034)
    T GetById(int id);                                // síncrono, sem CancellationToken (CONV-044)
}

public class AccountRepository(AppDbContext db)       // injeta DbContext direto, nome presumido
{
}
```

Certo — com contexto. Porta em
`{ApplicationProjectDir}/Abstractions/Repositories/Accounts/IAccountRepository.cs`:
```csharp
using {EntityNamespace};
using JacksonVeroneze.NET.Pagination.Offset;

namespace {ApplicationRootNamespace}.Abstractions.Repositories.Accounts;

public interface IAccountRepository
{
    Task<Account?> GetByIdAsync(
        Guid id,
        CancellationToken cancellationToken);

    Task<Page<Account>> GetPagedAsync(
        int page,
        int pageSize,
        CancellationToken cancellationToken);

    Task CreateAsync(
        Account account,
        CancellationToken cancellationToken);

    Task UpdateAsync(
        Account account,
        CancellationToken cancellationToken);

    Task DeleteAsync(
        Account account,
        CancellationToken cancellationToken);
}
```

Implementação em `{InfrastructureProjectDir}/Repositories/Accounts/AccountRepository.cs`:
```csharp
using {EntityNamespace};
using JacksonVeroneze.NET.EntityFramework.Interfaces;
using JacksonVeroneze.NET.Pagination.Offset;

namespace {InfrastructureRootNamespace}.Repositories.Accounts;

public sealed class AccountRepository(
    IEfCoreRepository<Account, {DbContextType}> efRepository) : IAccountRepository
{
    public Task<Account?> GetByIdAsync(
        Guid id,
        CancellationToken cancellationToken)
    {
        return efRepository.GetByIdAsync(
            filter => filter.Id == id, cancellationToken);
    }

    public Task<Page<Account>> GetPagedAsync(
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

    public async Task CreateAsync(
        Account account,
        CancellationToken cancellationToken)
    {
        await efRepository.CreateAsync(
            account, cancellationToken);

        await efRepository.DbContext
            .SaveChangesAsync(cancellationToken);
    }

    public Task UpdateAsync(
        Account account,
        CancellationToken cancellationToken)
    {
        efRepository.Update(account);

        return efRepository.DbContext
            .SaveChangesAsync(cancellationToken);
    }

    public Task DeleteAsync(
        Account account,
        CancellationToken cancellationToken)
    {
        efRepository.Delete(account);

        return efRepository.DbContext
            .SaveChangesAsync(cancellationToken);
    }
}
```

Diferença: porta específica do agregado na Application e implementação na Infrastructure, cada
uma com o `RootNamespace` do **seu** projeto (CONV-010/030/013); retorna `Account?`/`Page<Account>`,
não `IQueryable` nem `Result` (CONV-034); construtor primário injeta
`IEfCoreRepository<Account, {DbContextType}>`, nunca o `DbContext` direto, e `{DbContextType}` é o
nome real da classe no repo; async com `cancellationToken` sem default, um parâmetro por linha
(CONV-044/074); `GetByIdAsync`, `GetPagedAsync`, `UpdateAsync` e `DeleteAsync` repassam uma única
chamada async cada, sem `async`/`await` e com corpo em bloco (CONV-088/089); `CreateAsync` encadeia
duas chamadas, por isso mantém `async`/`await`; lambda com nome descritivo (`filter`, `entity`),
nunca `x` (CONV-090); `SaveChanges` sempre via `efRepository.DbContext`, dentro do método de
mutação, que é o limite transacional; implementação `sealed` (CONV-064).
