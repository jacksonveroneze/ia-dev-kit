# Exemplos (certo e errado)

Exemplos de apoio do `SKILL.md`. Em conflito com o Template canônico (`template.md`), o Template vence.

Nos exemplos, `{RootNamespace}` também é placeholder. Os `using` aparecem como se **não**
houvesse global using da lib.

Errado — Sem contexto — record público, `double`, `throw`, erro inline:
```csharp
public record Money(double Amount, string Currency)               // posicional, ctor público
{
    public static Money Create(double amount, string currency)
    {
        if (amount < 0)                                            // invariante não pedida
            throw new ArgumentException("negative");               // exceção p/ regra; sem chaves
        return new Money(amount, currency);                        // sem validar currency
    }
}
```

Certo — Flagship — `Email` (regex com timeout e guard de tamanho, PII mascarada, normalização após validar):
```csharp
using System.Text.RegularExpressions;
using JacksonVeroneze.NET.Result;

namespace {RootNamespace}.ValueObjects;

public sealed partial record Email
{
    private const int MaxLength = 254;

    private static readonly Error Required =
        Error.Create("Email.Required", 
            "Email is required.");

    private static readonly Error TooLong =
        Error.Create("Email.TooLong", 
            "Email must have at most 254 characters.");

    private static readonly Error InvalidFormat =
        Error.Create("Email.InvalidFormat", 
            "Email format is invalid.");

    public string Value { get; }

    private Email(string value)
    {
        Value = value;
    }

    public static Result<Email> Create(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return Result<Email>.FromInvalid(Required);
        }

        if (value.Length > MaxLength)
        {
            return Result<Email>.FromInvalid(TooLong);
        }

        if (!EmailRegex().IsMatch(value))
        {
            return Result<Email>.FromInvalid(InvalidFormat);
        }

        return Result<Email>.WithSuccess(
            new Email(value.ToLowerInvariant()));
    }

    public override string ToString()
    {
        int atIndex = Value.IndexOf('@');

        return $"{Value[0]}***{Value[atIndex..]}";
    }

    [GeneratedRegex(
        @"\A[A-Za-z0-9._%+-]{1,64}@"
        + @"(?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.){1,8}[A-Za-z]{2,63}\z",
        RegexOptions.CultureInvariant,
        matchTimeoutMilliseconds: 100)]
    private static partial Regex EmailRegex();
}
```

Certo — Segundo caso — `Money` (dois campos, negativo permitido, validação sem regex):
```csharp
using JacksonVeroneze.NET.Result;

namespace {RootNamespace}.ValueObjects;

public sealed record Money
{
    private const int CurrencyLength = 3;

    private static readonly Error InvalidCurrency =
        Error.Create("Money.InvalidCurrency", 
            "Currency must have exactly 3 letters.");

    public decimal Amount { get; }

    public string Currency { get; }

    private Money(decimal amount, string currency)
    {
        Amount = amount;
        Currency = currency;
    }

    public static Result<Money> Create(decimal amount, string currency)
    {
        if (string.IsNullOrEmpty(currency)
            || currency.Length != CurrencyLength
            || !currency.All(char.IsAsciiLetter))
        {
            return Result<Money>.FromInvalid(InvalidCurrency);
        }

        return Result<Money>.WithSuccess(
            new Money(amount, currency.ToUpperInvariant()));
    }
}
```

Diferença entre os exemplos certos e o errado:
- `sealed record` com ctor privado: construção só via `Create` (CONV-025/064).
- `decimal` para dinheiro (CONV-059), e nenhuma invariante que não foi pedida: `Amount` aceita negativo.
- Cada invariante é um `private static readonly Error` com `Code` `{Name}.{Reason}`, criado uma vez e referenciado no `FromInvalid` (CONV-021/085).
- Regex só quando necessário, com timeout, guard de tamanho e âncoras `\A`/`\z` (CONV-086).
- PII mascarada no `ToString` (CONV-054). Normalização só depois de validar.

## Pedido incompleto
"Crie um value object `Cpf`." Faltam os campos (`Fields`) e as invariantes.

Certo — a skill não escreve nada e lista só isso.
Errado — supor `string Value` e inventar o algoritmo de dígitos verificadores, que ninguém pediu.
