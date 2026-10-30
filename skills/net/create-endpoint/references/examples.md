# Exemplos (certo e errado)

Exemplos de apoio do `SKILL.md` e dos arquivos de padrão. Em conflito com o Template canônico do padrão, o
Template vence; os exemplos são reforço didático, não a fonte primária.

## Padrão GetById
Errado — sem contexto: lógica e acesso a dados no endpoint, status à mão, sem autorização, nome copiado:
```csharp
app.MapGet("/api/accounts/{id}", async (Guid id, AppDbContext db) =>              // DbContext no endpoint (CONV-040)
{
    try                                                                           // try/catch (CONV-061)
    {
        var account = await db.Accounts.FindAsync(id);                            // sem use case, sem CancellationToken (CONV-044)
        if (account is null) return Results.NotFound();                           // status à mão, deveria ser ToIResult()
        return Results.Ok(account);                                               // expõe entidade (CONV-070)
    }
    catch (Exception ex) { return Results.Problem(ex.ToString()); }              // vaza detalhe interno (CONV-057)
})
.WithName("GetShortUrlById");                                                     // nome copiado; sem RequireAuthorization (CONV-079)
```

Certo — com contexto: `Account`:
```csharp
using Microsoft.AspNetCore.Mvc;
using {ApiRootNamespace}.Endpoints.Extensions;
using {ApplicationRootNamespace}.Features.Accounts.GetAccountById;
using {AuthorizationPoliciesNamespace};
using {DefaultResponsesNamespace};
using {RouteNamesNamespace};

namespace {ApiRootNamespace}.Endpoints.Accounts.v1;

internal static class GetAccountByIdEndpoint
{
    extension(RouteGroupBuilder builder)
    {
        public RouteGroupBuilder AddGetById()
        {
            builder.MapGet("{id:guid}", async (
                    [FromServices] IGetAccountByIdUseCase useCase,
                    Guid id,
                    CancellationToken cancellationToken) =>
                {
                    GetAccountByIdRequest input = new(id);

                    var output = await useCase.ExecuteAsync(
                        input, cancellationToken);

                    return output.ToIResult();
                })
                .WithName(RouteNames.GetAccountById)
                .Produces<GetAccountByIdResponse>()
                .AddDefaultResponseEndpoints()
                .RequireAuthorization(AuthorizationPolicies.AccountsRead);

            return builder;
        }
    }
}
```

Diferença: só adapta protocolo — monta o `Request`, chama o use case, devolve `ToIResult()` (CONV-040/036);
nenhum `DbContext`, `try/catch` ou status manual; devolve o response da Application, não a entidade
(CONV-037/070); nome de rota igual à operação; policy por constante (CONV-079); `CancellationToken`
último e repassado (CONV-044/074); método de extensão em bloco `extension` (CONV-098).

## Padrão GetPaged
Errado — sem contexto: liga o `PagedRequest` direto no `[AsParameters]`, não valida, ignora falha, `!` sem guard, sem autorização:
```csharp
app.MapGet("/api/accounts", async (
    [AsParameters] GetAccountsPagedRequest request,                              // PagedRequest não é vinculável; sem RestRequest
    IGetAccountsPagedUseCase useCase) =>                                         // sem CancellationToken (CONV-044)
{
    var output = await useCase.ExecuteAsync(request, default);                   // `default` no token; sem validação: pageSize=999999 chega ao repositório
    return Results.Ok(output.Value!);                                            // `!` sem checar falha (CONV-003); expõe o response da Application
});                                                                              // sem RequireAuthorization (CONV-079)
```

Certo — com contexto: `Account`, filtro por `Currency`:
```csharp
// GetAccountsPagedRestRequest.cs
public sealed record GetAccountsPagedRestRequest(
    int? Page = null,
    int? PageSize = null,
    string? OrderBy = null,
    SortDirection? Order = null,
    string? Currency = null);
```
```csharp
// GetAccountsPagedRestMapper.cs — dentro de Register
config.NewConfig<GetAccountsPagedRestRequest, GetAccountsPagedRequest>()
    .IgnoreNullValues(true)
    .Map(dest => dest.Page, src => src.Page)
    .Map(dest => dest.PageSize, src => src.PageSize)
    .Map(dest => dest.OrderBy, src => src.OrderBy)
    .Map(dest => dest.Order, src => src.Order)
    .Map(dest => dest.Currency, src => src.Currency);

config.NewConfig<GetAccountsPagedResponse, GetAccountsPagedRestResponse>()
    .Map(dest => dest.Data, src => src.Data)
    .Map(dest => dest.Pagination, src => src.Pagination);
```
O endpoint segue o template com `GetAccountsPaged`, `AuthorizationPolicies.AccountsRead` e `Currency` como filtro.

Diferença: `RestRequest` vinculável por construtor e mapeado com `IgnoreNullValues` (defaults preservados,
CONV-037); validação do Request **antes** do use case, 400 sem chamá-lo (CONV-029/038); falha do use
case por `ToIResult()` (CONV-036); valor não nulo garantido por `ThrowIfNull`, sem `!` (CONV-003);
mapeamento explícito nos dois sentidos (CONV-031); policy por constante, `CancellationToken` último e
repassado (CONV-079/044/074); método de extensão em bloco `extension` (CONV-098).

## Pedido incompleto ou fora de padrão
"Crie o endpoint para criar uma conta (`POST /accounts`)." Não há padrão para escrita (só `GetById` e `GetPaged`).

Certo — a skill não escreve nada e relata que não há padrão para esse pedido.
Errado — improvisar um endpoint de escrita ou adaptar o `GetById`.

"Crie o endpoint do GetAccountById." Sem `IGetAccountByIdUseCase` na Application.

Certo — a skill para e relata o que falta e onde era esperado; não cria o use case.
Errado — criar o use case junto com o endpoint.
