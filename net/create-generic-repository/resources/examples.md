# Exemplos (certo/errado)

Exemplos de apoio do `SKILL.md`. Em conflito com o Template canônico, o Template vence. Namespaces e
`using` são valores resolvidos ilustrativos; use sempre os do repositório.

## Busca por ID, tratando 404
Pedido:
- Contrato: `ICustomerRepository`, em `app/src/Bank.Application/Abstractions/Repositories/Customers`
- Implementação: em `app/src/Bank.Infrastructure/Repositories/Customers`
- Dependências: `ICustomerApi api`, `IMapper mapper`, `ILogger<CustomerRepository> logger`
- Método: `GetByIdAsync`, parâmetro `int customerId`, retorno `CustomerResult?`
- Comportamento: chama `api.GetCustomerByIdAsync`, mapeia o resultado para `CustomerResult` e, em `ApiException` com 404, loga aviso e devolve `null`.

`ICustomerRepository.cs`:
```csharp
using Bank.Application.Features.Customers.Common;

namespace Bank.Application.Abstractions.Repositories.Customers;

public interface ICustomerRepository
{
    Task<CustomerResult?> GetByIdAsync(
        int customerId,
        CancellationToken cancellationToken);
}
```

`CustomerRepository.cs`:
```csharp
using System.Net;
using Bank.Application.Abstractions.Repositories.Customers;
using Bank.Application.Features.Customers.Common;
using MapsterMapper;
using Microsoft.Extensions.Logging;
using Refit;

namespace Bank.Infrastructure.Repositories.Customers;

public sealed class CustomerRepository(
    ICustomerApi api,
    IMapper mapper,
    ILogger<CustomerRepository> logger) : ICustomerRepository
{
    public async Task<CustomerResult?> GetByIdAsync(
        int customerId,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await api.GetCustomerByIdAsync(
                customerId, cancellationToken);

            var response = mapper
                .Map<CustomerResult>(result);

            return response;
        }
        catch (ApiException ex)
            when (ex.StatusCode is HttpStatusCode.NotFound)
        {
            logger.LogWarning(
                "Cliente {CustomerId} não encontrado.", customerId);

            return null;
        }
    }
}
```
Outro status propaga; só o 404 descrito é capturado, com `when`.

## Busca de coleção, com log
Pedido (mesmos diretórios e dependências, para `AccountRepository`):
- Método: `GetAccountsAsync`, parâmetros `AccountType? accountType` e `AccountStatus? status`, retorno `IReadOnlyCollection<AccountResult>`
- Comportamento: chama `api.GetAccountsAsync`, mapeia o resultado para o retorno e loga a quantidade.

Método dentro de `AccountRepository`:
```csharp
public async Task<IReadOnlyCollection<AccountResult>> GetAccountsAsync(
    AccountType? accountType,
    AccountStatus? status,
    CancellationToken cancellationToken)
{
    var result = await api.GetAccountsAsync(
        accountType, status, cancellationToken);

    var response = mapper
        .Map<IReadOnlyCollection<AccountResult>>(result);

    logger.LogInformation(
        "Contas consultadas. Quantidade: {Count}.", response.Count);

    return response;
}
```

## Pedido incompleto
"Crie o ICustomerRepository com um GetByIdAsync que busca o cliente na API." Faltam o diretório do
contrato, o da implementação, as dependências, o parâmetro e o Retorno.

Certo — a skill não escreve nada e pede só isso.
Errado — assumir a pasta, supor que o retorno é `CustomerResult` ou escolher a dependência.

## Errado
```csharp
public class CustomerRepository(ICustomerApi api)                    // sem sealed (CONV-064)
{
    public async Task<CustomerResult> GetById(int id)                // sem Async, sem cancellationToken
    {
        try { return await api.GetCustomerByIdAsync(id); }           // sem cancellationToken, sem mapeamento
        catch { return null; }                                       // catch vazio engole tudo (CONV-083)
    }
}

logger.LogInformation($"Contas: {result.Count}");                   // interpolação (CONV-062)
```
