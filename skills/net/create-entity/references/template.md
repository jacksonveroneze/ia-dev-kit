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

    private {Name}({IdParam}/* ... */)
    {
        {IdAssign}// atribuições
    }

    public static Result<{Name}> Create(/* VOs + dados + instante quando aplicável */)
    {
        if (/* invariante de nascimento violada */)
        {
            return Result<{Name}>.FromInvalid({Reason});
        }

        return Result<{Name}>.WithSuccess(
            new {Name}({IdValue}/* ... */));
    }
}
```

Os placeholders de identidade dependem de `Identity`:

| `Identity` | `{IdType}` | `{IdParam}` | `{IdAssign}` | `{IdValue}` |
|---|---|---|---|---|
| `Guid` (padrão) | `Guid` | `Guid id, ` | `Id = id;` + quebra de linha | `Guid.NewGuid(), ` |
| `int` (gerado pelo banco) | `int` | vazio | vazio | vazio |
| VO de id forte | o VO | `{IdType} id, ` | `Id = id;` + quebra de linha | o id que chega ao `Create`, já validado (`Result<T>` resolvido antes da entidade), seguido de `, ` |

Com `int`, a entidade não inicializa o `Id`: sem parâmetro de id no construtor nem no `Create`, sem
`Id = ...` (nem `Id = 0`) e sem argumento no `new`. A propriedade segue o mesmo padrão `public {IdType} Id { get; }`
e mantém o valor padrão do tipo até o banco atribuir. Sem configuração de EF na entidade (CONV-024); se o
construtor ficar sem parâmetros de estado, ele continua `private`.
