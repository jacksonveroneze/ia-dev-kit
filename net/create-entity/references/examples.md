# Exemplos (certo e errado)

Exemplos de apoio do `SKILL.md`. Em conflito com o Template canônico (`template.md`), o Template vence;
os exemplos são reforço didático, não a fonte primária.

## Pedido
"Account com AccountNumber, Balance (Money) e OpenedAt. Abre com depósito inicial não negativo."
(Sem comportamento pedido: só construção.)

Errado — sem contexto: setter e ctor públicos, atributo de EF, `decimal` cru, exceção, API
inexistente:
```csharp
public class Account                                   // não-sealed, aberto a herança
{
    [Key] public Guid Id { get; set; }                 // atributo de EF no domínio
    public decimal Balance { get; set; }                // primitivo, mutável de fora

    public static Account Create(decimal balance)
    {
        if (balance < 0) throw new ArgumentException(); // exceção p/ regra; sem chaves
        return new Account { Id = Guid.NewGuid(), Balance = balance };
    }
}
```

Certo — com contexto (`{DomainProjectDir}/Accounts/Account.cs`):
```csharp
using JacksonVeroneze.NET.Result;

namespace {RootNamespace}.Accounts;

public sealed class Account
{
    private static readonly Error InitialDepositNegative =
        Error.Create("Account.InitialDepositNegative",
            "Initial deposit cannot be negative.");

    public Guid Id { get; }

    public AccountNumber Number { get; }

    public Money Balance { get; }

    public DateTimeOffset OpenedAt { get; }

    private Account(Guid id, AccountNumber number,
        Money balance, DateTimeOffset openedAt)
    {
        Id = id;
        Number = number;
        Balance = balance;
        OpenedAt = openedAt;
    }

    public static Result<Account> Open(
        AccountNumber number, Money initialDeposit,
        DateTimeOffset openedAt)
    {
        if (initialDeposit.Amount < 0)
        {
            return Result<Account>
                .FromInvalid(InitialDepositNegative);
        }

        return Result<Account>.WithSuccess(
            new Account(Guid.NewGuid(),
                number, initialDeposit, openedAt));
    }
}
```

Diferença: `sealed class` com ctor privado (CONV-023/064); `Open` valida e retorna
`Result<Account>` via `FromInvalid`/`WithSuccess` (CONV-085); usa VOs `Money`/`AccountNumber`
(CONV-025/059); `openedAt` entra como parâmetro, zero `DateTime.Now` (CONV-060); sem atributo de
EF (CONV-024); todas as propriedades `get`-only — nada muda depois do nascimento, porque nenhum
comportamento foi pedido nem gerado; `Error` único, `Code` estável (CONV-021).

## Pedido incompleto
"Crie a entidade Account." Faltam o agregado, o estado (propriedades e tipos, com cada uma fixa ou
mutável) e as invariantes de criação.

Certo — a skill não escreve nada e lista só isso.
Errado — supor `Id`, `Name` e `Balance`, ou inventar uma invariante que ninguém pediu.
