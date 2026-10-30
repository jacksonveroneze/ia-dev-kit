# Exemplos (certo e errado)

Exemplos de apoio do `SKILL.md`. Em conflito com o Template canônico, o Template vence.

Errado — Sem contexto — AutoMapper com mapeamento por convenção implícita:
```csharp
public class AccountProfile : Profile                     // AutoMapper (CONV-031 exige Mapster)
{
    public AccountProfile()
        => CreateMap<Account, GetAccountByIdResponse>();   // convenção implícita, VO não tratado
}
```
Certo — Com contexto — Mapster `IRegister`, membros explícitos, VO desempacotado:
```csharp
namespace Bank.Application.Features.Accounts.GetAccountById;

public sealed class GetAccountByIdMapping : IRegister
{
    public void Register(TypeAdapterConfig config)
    {
        config.NewConfig<Account, GetAccountByIdResponse>()
            .Map(dest => dest.AccountId, src => src.Id)
            .Map(dest => dest.Balance,   src => src.Balance.Amount)
            .Map(dest => dest.Currency,  src => src.Balance.Currency);
    }
}
```
Diferença: Mapster em vez de AutoMapper (CONV-031); cada membro do Response declarado, incluindo
o desempacote do VO `Money` (`Balance.Amount`/`Balance.Currency`); com
`RequireDestinationMemberSource` ligado, um membro novo sem `.Map` quebra o build.

## Pedido incompleto
"Crie o mapper do Account." Faltam a operação (`Operation`) e o `Response` que recebe o mapeamento.

Certo — a skill não escreve nada e lista só isso.
Errado — supor a operação ou inventar os membros do `Response`.
