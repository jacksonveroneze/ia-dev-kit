# Padrão: busca por identificador único (GetById)

Use quando o pedido é localizar **um** registro pelo `Id` do agregado. Ausência é resultado
esperado, modelado como `NotFound` — nunca sucesso vazio nem exceção.

`{Operation}` = `Get{Aggregate}ById` (ex.: `GetAccountById`). Placeholders e regras comuns:
`SKILL.md`. Arquivos (em `Features/{AggregateFolder}/{Operation}/`): `Request`, `Response`,
`I{Operation}UseCase`, `{Operation}UseCase`, `{Operation}Mapper`.

## Pré-condições específicas deste padrão
- A porta `I{Aggregate}Repository` tem `GetByIdAsync({IdType} id, CancellationToken cancellationToken)`. Ausente ou com outra assinatura: pare e relate o que era esperado e onde.
- `Domain/Common/DomainErrors.cs` existe; resolva também `{DomainErrorsNamespace}` (o `namespace` declarado no arquivo) e declare-o junto dos demais valores. Arquivo inexistente: pare e relate.
- `DomainErrors.{Aggregate}Error.NotFound` existindo, use. Não existindo, acrescente-o seguindo o padrão dos erros vizinhos do arquivo (`Code` estável `{Aggregate}.NotFound`, CONV-021). Esse é o único arquivo fora da Application que esta skill escreve.

## Raciocínio antes de escrever (CoT) — específico deste padrão
- Antes de gerar: (1) `DomainErrors.{Aggregate}Error.NotFound` existe ou será acrescentado; (2) a porta tem `GetByIdAsync`; (3) qualifique o tipo da entidade inline só se houver ambiguidade de nome.
- Ausente é esperado: `FromNotFound(DomainErrors.{Aggregate}Error.NotFound)`, nunca exceção (CONV-020/021). O erro vive no Domain: sem `Error` local.
- `{Operation}Response` é só o envelope `DataResponse<{Aggregate}Response>`; a forma do dado e o mapper dela são do `Common` (`prerequisites.md`, Bloco B). O mapper da operação só liga `Data` à entidade; todo membro explícito (CONV-031).

## Template canônico

```csharp
// {Operation}Request.cs
using {ApplicationRootNamespace}.Abstractions.UseCases;

namespace {ApplicationRootNamespace}.Features.{AggregateFolder}.{Operation};

public sealed record {Operation}Request(
    {IdType} Id) : IBaseRequest;
```
```csharp
// {Operation}Response.cs
using {ApplicationRootNamespace}.Common.Models.Response;
using {ApplicationRootNamespace}.Features.{AggregateFolder}.Common.Models;

namespace {ApplicationRootNamespace}.Features.{AggregateFolder}.{Operation};

public sealed record {Operation}Response
    : DataResponse<{Aggregate}Response>;
```
```csharp
// I{Operation}UseCase.cs
using {ApplicationRootNamespace}.Abstractions.UseCases;

namespace {ApplicationRootNamespace}.Features.{AggregateFolder}.{Operation};

public interface I{Operation}UseCase :
    IUseCase<{Operation}Request, Result.Result<{Operation}Response>>;
```
```csharp
// {Operation}UseCase.cs
using MapsterMapper;                                          // só se não houver global using
using {ApplicationRootNamespace}.Abstractions.Repositories.{AggregateFolder};
using {DomainErrorsNamespace};                                // namespace real de DomainErrors
using {EntityNamespace};                                      // namespace real da entidade

namespace {ApplicationRootNamespace}.Features.{AggregateFolder}.{Operation};

public sealed class {Operation}UseCase(
    IMapper mapper,
    I{Aggregate}Repository repository) : I{Operation}UseCase
{
    public async Task<Result.Result<{Operation}Response>> ExecuteAsync(
        {Operation}Request request,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(request);

        var entity = await repository
            .GetByIdAsync(request.Id, cancellationToken);

        if (entity is null)
        {
            return Result.Result<{Operation}Response>
                .FromNotFound(DomainErrors.{Aggregate}Error.NotFound);
        }

        var response = mapper
            .Map<{Aggregate}, {Operation}Response>(entity);

        return Result.Result<{Operation}Response>
            .WithSuccess(response);
    }
}
```
```csharp
// {Operation}Mapper.cs — só liga Data à entidade; a forma do dado é do Common
using Mapster;
using {EntityNamespace};

namespace {ApplicationRootNamespace}.Features.{AggregateFolder}.{Operation};

public sealed class {Operation}Mapper : IRegister
{
    public void Register(TypeAdapterConfig config)
    {
        ArgumentNullException.ThrowIfNull(config);

        config.NewConfig<{Aggregate}, {Operation}Response>()
            .Map(dest => dest.Data, src => src);
    }
}
```
`{Aggregate}Response` e `{Aggregate}ResponseMapper` (Common): template em `prerequisites.md` (Bloco B).

## Exemplos
Ver `examples.md`, seção "Padrão GetById".

## Anti-patterns específicos deste padrão (além dos comuns do SKILL.md)
- Exceção ou `null` para not-found; `Error`/`NotFoundError` declarado no use case (o erro vem de `DomainErrors.{Aggregate}Error.NotFound`).
- Campos declarados em `{Operation}Response`; response ou mapper de item novo por operação; mapper da operação com `.Map` além de `Data` ligado à entidade.
- Tratar ausência como sucesso com `Data` vazio.

## Checklist específico deste padrão (além do comum do SKILL.md)
- [ ] Porta com `GetByIdAsync({IdType}, CancellationToken)` confirmada.
- [ ] Not-found: `FromNotFound(DomainErrors.{Aggregate}Error.NotFound)`; nenhum `Error` local; `{DomainErrorsNamespace}` importado.
- [ ] `Response : DataResponse<{Aggregate}Response>` sem campos; mapper da operação só com `Data` ligado à entidade; response e mapper de item do `Common` reaproveitados.
- [ ] `Request` com o `Id` tipado como `{IdType}`.

## Cenários mínimos do teste de unidade (Harness, passo 3 do SKILL.md)
`IMapper` **real** (CONV-052): `TypeAdapterConfig` com `{Operation}Mapper` e `{Aggregate}ResponseMapper` aplicados explicitamente e `Compile()`; mocke só a porta.
- Porta retorna a entidade: sucesso, `Data` com todos os campos mapeados.
- Porta retorna `null`: falha `ResultType.NotFound` com o erro de `DomainErrors.{Aggregate}Error.NotFound` (mesmo `Code`) (CONV-053).
- `request` nulo: `ArgumentNullException`.
- A configuração compila sem membro de destino não mapeado.
