# Padrão: endpoint de busca por identificador único (GetById)

Use quando o use case é `Get{Aggregate}ById`. Rota `GET /{resource}/{id}` com a constraint de `{IdRouteConstraint}` (tabela abaixo); método de extensão
`AddGetById`; classe `{Operation}Endpoint`. `{Operation}` = `Get{Aggregate}ById` (ex.:
`GetAccountById`), já existente na Application. Placeholders e regras comuns: `SKILL.md`.
Arquivo (em `Endpoints/{AggregateFolder}/v1/`): `{Operation}Endpoint.cs`.

## Pré-condições específicas deste padrão
- Existem na Application `I{Operation}UseCase`, `{Operation}Request` e `{Operation}Response`. Ausentes: pare e relate o que era esperado e onde.
- `{IdType}` é o tipo da propriedade `Id` do `{Operation}Request`, lido, não presumido. Suportados: `Guid`, `int` e `string`. Outro tipo: pare e relate o que era esperado e onde.
- `AuthorizationPolicies.{AggregateFolder}Read` existe. Ausente: pare e relate.
- `RouteNames.{Operation}` existindo, use. Não existindo, acrescente-o ao `RouteNames` existente: `public const string {Operation} = "{Operation}";`. `RouteNames` inexistente: pare e relate. Esse é o único acréscimo que esta skill faz em um helper da Api.

## Raciocínio antes de escrever (CoT) — específico deste padrão
- Antes de gerar: (1) o use case, o `Request` e o `Response` existem; (2) `RouteNames.{Operation}` existe ou será acrescentado; (3) a policy existe.
- Not-found e demais falhas chegam como `Result` do use case: **sempre** `output.ToIResult()` (404 vem de `ResultType.NotFound`); nunca `Results.NotFound()` à mão (CONV-036).
- Sucesso devolve o response da Application (`DataResponse<{Aggregate}Response>`): `Produces<{Operation}Response>()`; sem DTO REST neste padrão (CONV-037).
- `WithName(...)` é obrigatório: o `Location` do endpoint de criação usa esse nome (`ToCreatedResultFromRoute`).
- Constraint de rota derivada do `{IdType}`:

  | `{IdType}` | `{IdRouteConstraint}` | Rota |
  |---|---|---|
  | `Guid` | `guid` | `{id:guid}` |
  | `int` | `int` | `{id:int}` |
  | `string` | nenhuma | `{id}` |

- O endpoint não restringe nem valida o formato do id: o valor que casa a rota segue para o use case (inclusive `Guid.Empty`, `0` ou texto qualquer); a ausência é 404 por `Result` NotFound do use case. Id que não casa a constraint: 404, a rota não casa. Sem `try/catch` (CONV-061).
- Parâmetros do handler: serviços com `[FromServices]`, depois o valor de rota, `CancellationToken` por último.
- O método `AddGetById` fica num bloco `extension(RouteGroupBuilder builder)` (CONV-098).

## Template canônico
```csharp
// Endpoints/{AggregateFolder}/v1/{Operation}Endpoint.cs
using Microsoft.AspNetCore.Mvc;                                   // só se não houver global using
using {ApiRootNamespace}.Endpoints.Extensions;
using {ApplicationRootNamespace}.Features.{AggregateFolder}.{Operation};
using {AuthorizationPoliciesNamespace};                           // namespace real de AuthorizationPolicies
using {DefaultResponsesNamespace};                                // namespace real de AddDefaultResponseEndpoints
using {RouteNamesNamespace};                                      // namespace real de RouteNames

namespace {ApiRootNamespace}.Endpoints.{AggregateFolder}.v1;

internal static class {Operation}Endpoint
{
    extension(RouteGroupBuilder builder)
    {
        public RouteGroupBuilder AddGetById()
        {
            builder.MapGet("{id:{IdRouteConstraint}}", async (   // string: "{id}", sem constraint
                    [FromServices] I{Operation}UseCase useCase,
                    {IdType} id,
                    CancellationToken cancellationToken) =>
                {
                    {Operation}Request input = new(id);

                    var output = await useCase.ExecuteAsync(
                        input, cancellationToken);

                    return output.ToIResult();
                })
                .WithName(RouteNames.{Operation})
                .Produces<{Operation}Response>()
                .AddDefaultResponseEndpoints()
                .RequireAuthorization(AuthorizationPolicies.{AggregateFolder}Read);

            return builder;
        }
    }
}
```
Cadeia em `RouteMappings` (`prerequisites.md`, Bloco B): acrescentar `.AddGetById()`.

## Exemplos
Ver `examples.md`, seção "Padrão GetById".

## Anti-patterns específicos deste padrão (além dos comuns do SKILL.md)
- `Results.NotFound()`/`Results.Ok(output.Value)` no lugar de `output.ToIResult()`.
- Sem `WithName`, ou com nome de outra feature (`GetShortUrlById`); rota sem a constraint do `{IdType}` (ou constraint em `string`); `{IdType}` presumido como `Guid` em vez de lido do `Request`.
- Response REST próprio (`RestResponse`) neste padrão; restringir ou validar o formato do id no endpoint (`Guid.TryParse`, regex, `Guid.Empty`, faixa do `int`).
- Nome do método ou da classe fora de `AddGetById` / `{Operation}Endpoint`.
- Acrescentar constante ao `RouteNames` inexistente, ou criar o `RouteNames`.

## Checklist específico deste padrão (além do comum do SKILL.md)
- [ ] `{IdType}` lido do `Request` e suportado (`Guid`, `int` ou `string`); rota pela tabela de constraints (`{id:guid}`, `{id:int}` ou `{id}`); sem validação de formato do id.
- [ ] `MapGet` com `[FromServices] I{Operation}UseCase useCase`, `{IdType} id`, `CancellationToken` por último.
- [ ] `{Operation}Request input = new(id)`; retorno `output.ToIResult()`.
- [ ] `.WithName(RouteNames.{Operation})` (constante existe), `.Produces<{Operation}Response>()`, `.AddDefaultResponseEndpoints()`, `.RequireAuthorization(...)`.
- [ ] Método `AddGetById` em bloco `extension(RouteGroupBuilder builder)` na classe `{Operation}Endpoint`, e `.AddGetById()` na cadeia do `RouteMappings`.

## Cenários mínimos de teste (Harness, passo 3 do SKILL.md)
Integração com `WebApplicationFactory`; substitua `I{Operation}UseCase` por mock (Moq) e use autenticação de teste com a policy `{AggregateFolder}Read`.
- Use case retorna sucesso: 200 e corpo com `data` mapeado.
- Use case retorna `Result` NotFound: 404 `ProblemDetails` com título "Resource Not Found".
- Sem credencial: 401; credencial sem a policy: 403; o use case não é chamado.
- `Guid` ou `int`: `id` que não casa com a constraint: 404 (rota não casa); o use case não é chamado.
- `string`: qualquer valor chega ao use case (não há cenário de rota não casada).
- O endpoint tem o nome `RouteNames.{Operation}` nos metadados (serve ao `Location` do Create).
