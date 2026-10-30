# Template canônico

Molde do arquivo gerado pela skill. `{RootNamespace}` é placeholder: substitua pelo valor
resolvido no passo 3 do Fluxo, nunca copie literalmente. Em conflito com os Exemplos, o Template vence.

```csharp
// using System.Text.RegularExpressions;   // só quando usar [GeneratedRegex]
// using JacksonVeroneze.NET.Result;       // só se não houver global using (passo 4)

namespace {RootNamespace}.ValueObjects;

public sealed record {Name}          // 'partial' só se usar source generator (ex.: [GeneratedRegex])
{
    // um Error por invariante, Code {Name}.{Reason}
    private static readonly Error {Reason} =
        Error.Create("{Name}.{Reason}", 
            "<mensagem clara>");

    public {FieldType} {FieldName} { get; }

    private {Name}({FieldType} {fieldParam})
    {
        {FieldName} = {fieldParam};
    }

    public static Result<{Name}> Create({FieldType} {fieldParam})
    {
        if (/* invariante violada */)
        {
            return Result<{Name}>.FromInvalid({Reason});
        }

        // normalização só após validar
        return Result<{Name}>.WithSuccess(
            new {Name}(/* valores normalizados */));
    }

    // só para PII:
    // public override string ToString() => /* valor mascarado */;
}
```
