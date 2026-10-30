# Exemplos (certo e errado)

Exemplos de apoio do `SKILL.md` e dos arquivos de padrão. Em conflito com o Template canônico do padrão, o
Template vence; os exemplos são reforço didático, não a fonte primária.

## Padrão GetById
Errado — sem contexto: MediatR, `DbContext` na Application, exceção para not-found, erro e log no
use case:
```csharp
public class GetAccountByIdHandler(AppDbContext db, ILogger<GetAccountByIdHandler> logger)   // infra na Application (CONV-030/072); logger
    : IRequestHandler<GetAccountByIdQuery, GetAccountByIdResponse>                            // MediatR, não IUseCase
{
    private static readonly Error NotFound = Error.Create("x", "y");                          // erro local; deveria ser DomainErrors

    public async Task<GetAccountByIdResponse> Handle(                                          // deveria ser ExecuteAsync
        GetAccountByIdQuery q, CancellationToken ct)
    {
        var a = await db.Accounts.FindAsync(q.Id)
            ?? throw new NotFoundException();                                                  // exceção p/ fluxo (CONV-020)
        logger.LogInformation("found {Balance}", a.Balance);                                   // log + dado sensível (CONV-054)
        return new GetAccountByIdResponse(a.Id, a.Balance.Amount, a.Balance.Currency);         // campos duplicados no response
    }
}
```

Certo — com contexto: `Account` (demais arquivos: o template com `GetAccountById`/`AccountResponse`):
```csharp
using MapsterMapper;
using {ApplicationRootNamespace}.Abstractions.Repositories.Accounts;
using {DomainErrorsNamespace};
using {EntityNamespace};

namespace {ApplicationRootNamespace}.Features.Accounts.GetAccountById;

public sealed class GetAccountByIdUseCase(
    IMapper mapper,
    IAccountRepository repository) : IGetAccountByIdUseCase
{
    public async Task<Result.Result<GetAccountByIdResponse>> ExecuteAsync(
        GetAccountByIdRequest request,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(request);

        var entity = await repository
            .GetByIdAsync(request.Id, cancellationToken);

        if (entity is null)
        {
            return Result.Result<GetAccountByIdResponse>
                .FromNotFound(DomainErrors.AccountError.NotFound);
        }

        var response = mapper
            .Map<Account, GetAccountByIdResponse>(entity);

        return Result.Result<GetAccountByIdResponse>
            .WithSuccess(response);
    }
}
```
```csharp
// GetAccountByIdMapper.cs — dentro de Register
config.NewConfig<Account, GetAccountByIdResponse>()
    .Map(dest => dest.Data, src => src);
```

Diferença: depende da porta e de `IUseCase<,>`, não do `DbContext`/MediatR (CONV-027/030/072); o erro
vem de `DomainErrors`, sem logger (CONV-021/027); `FromNotFound` em vez de exceção (CONV-020);
`Response` é só envelope e o dado é do `Common`; operação nomeada `GetAccountById`, verbo + agregado +
qualificador (CONV-016).

## Padrão GetPaged
Errado — sem contexto: sem `IUseCase`, valida no use case, porta com `page`/`pageSize` soltos, `!`,
expõe `Page<T>`, trata lista vazia como erro:
```csharp
public class GetAccountsPagedUseCase(IAccountRepository repo, IMapper mapper)             // sem interface/IUseCase, sem sealed
{
    public async Task<Result<Page<AccountResponse>>> HandleAsync(                          // HandleAsync; Page<T> da lib vazando; Result<> solto
        GetAccountsPagedRequest request, CancellationToken ct)
    {
        if (request.Page < 1) throw new ArgumentException("invalid page");                 // validação + exceção no use case (CONV-020/029)

        var page = await repo.GetPagedAsync(request.Page!.Value, request.PageSize!.Value, ct); // `!` (CONV-003); sem filtro/ordenação

        if (page.Data.Count == 0)
            return Result.Fail<Page<AccountResponse>>(
                new NotFoundError("No accounts found."));                                  // lista vazia não é not-found

        return Result.Ok(new Page<AccountResponse>(
            mapper.Map<List<AccountResponse>>(page.Data), page.PageInfo));                 // remontando o envelope à mão
    }
}
```

Certo — com contexto: `Account`, filtro por `Currency` (demais arquivos: o template com
`GetAccountsPaged`/`AccountResponse`):
```csharp
using {ApplicationRootNamespace}.Abstractions.UseCases;
using {ApplicationRootNamespace}.Common.Models.Request;
using {ApplicationRootNamespace}.Features.Accounts.Common.Models;
using {SortDirectionNamespace};

namespace {ApplicationRootNamespace}.Features.Accounts.GetAccountsPaged;

public sealed record GetAccountsPagedRequest()
    : PagedRequest(DefaultOrderBy, DefaultOrder),
        IBaseRequest
{
    private const string DefaultOrderBy = nameof(AccountResponse.Balance);

    private const SortDirection DefaultOrder = SortDirection.Ascending;

    public string? Currency { get; init; }
}
```
```csharp
// GetAccountsPagedValidator.cs — trecho
private static readonly string[] AllowedOrderBy =
[
    nameof(AccountResponse.Balance),
    nameof(AccountResponse.Currency)
];
```
```csharp
// GetAccountsPagedMapper.cs — dentro de Register
config.NewConfig<GetAccountsPagedRequest, AccountPagedFilter>()
    .Map(dest => dest.Currency, src => src.Currency)
    .Map(dest => dest.Pagination, src => src);

config.NewConfig<GetAccountsPagedRequest, PaginationParameters>()
    .ConstructUsing(src =>
        new PaginationParameters(
            src.Page.GetValueOrDefault(),
            src.PageSize.GetValueOrDefault(),
            src.OrderBy,
            src.Order));

config.NewConfig<Page<Account>, GetAccountsPagedResponse>()
    .Map(dest => dest.Data, src => src.Data)
    .Map(dest => dest.Pagination, src => src.PageInfo);
```

Diferença: `Request : PagedRequest, IBaseRequest` (CONV-028); envelope `PagedResponse` em vez do `Page<T>` da
lib, com item e mapper do `Common`; a validação é do Validator, que restringe `OrderBy` (CONV-029/038);
página vazia é `WithSuccess`; filtro montado por Mapster e entregue à porta (CONV-031); sem `!`
(CONV-003); operação nomeada `GetAccountsPaged`, verbo + agregado + qualificador (CONV-016).

## Pedido incompleto ou fora de padrão
"Crie o use case que busca o Account pelo e-mail." Não há padrão para leitura por e-mail (só `GetById` e `GetPaged`).

Certo — a skill não escreve nada e relata que não há padrão para esse pedido.
Errado — improvisar um padrão novo ou adaptar o `GetById`.

"Crie o GetAccountById." Sem a porta `IAccountRepository` na Application.

Certo — a skill para e relata o que falta e onde era esperado; não cria a porta.
Errado — criar a porta junto com o use case.
