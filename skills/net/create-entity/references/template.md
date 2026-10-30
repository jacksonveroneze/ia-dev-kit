# Template canônico

Molde do arquivo gerado pela skill. `{RootNamespace}` e os demais placeholders recebem os valores
resolvidos no passo 3 do Fluxo; nunca copie literalmente. Em conflito com os Exemplos, o Template vence.

```csharp
// using JacksonVeroneze.NET.Result;   // só se não houver global using (passo 5)

namespace {RootNamespace}.{Aggregate};

public sealed class {Name}
{
    private static readonly Error {Reason} =
        Error.Create("{Name}.{Reason}", "<mensagem clara>");

    public {IdType} Id { get; }

    // get-only quando fixa no nascimento; private set só se o usuário descreveu mudança futura
    public {PropType} {Prop} { get; }

    private {Name}({IdType} id, /* ... */)
    {
        Id = id;
        // atribuições
    }

    public static Result<{Name}> Create(/* VOs + dados + instante quando aplicável */)
    {
        if (/* invariante de nascimento violada */)
        {
            return Result<{Name}>.FromInvalid({Reason});
        }

        return Result<{Name}>.WithSuccess(
            new {Name}({IdValue}, /* ... */));
    }
}
```

`{IdValue}` é `Guid.NewGuid()` quando `Identity` é `Guid` (o padrão). Com VO de id forte, o id chega ao
`Create` já validado (`Result<T>` resolvido antes da entidade) e entra no lugar de `{IdValue}`.
