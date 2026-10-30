---
name: create-external-repository
description: 'Cria um repositório externo (.NET/C#), sem EF Core. Gera a interface (contrato) e a implementação com os métodos que o usuário descreve, cada um delegando a uma dependência informada (cliente HTTP, API, cache e afins), mapeando o resultado para o tipo de retorno informado e aplicando o tratamento de erro e o log descritos. Só segue com todos os dados informados, os diretórios, o nome do contrato, as dependências e, por método, nome, parâmetros, retorno e comportamento. Use sempre que o usuário pedir um repository, repositório ou adaptador com métodos descritos que não seja de persistência EF Core, mesmo sem usar o termo. Não use para registro de DI nem para regra de negócio.'
---

# Criar repositório externo (.NET)

Gera o contrato e a implementação de um repositório cujos métodos o usuário descreve, conforme a
`dotnet-conventions.md`. "Externo" = delega a uma dependência externa (HTTP, cache etc.); não é o
padrão `Repository<T>` nem persistência EF Core. Em conflito entre o Template canônico e os
Exemplos, o Template vence.

## O que gera
- `{InterfaceDir}/I{Name}.cs`: o contrato, com um método por item descrito.
- `{ImplementationDir}/{Name}.cs`: a implementação; o nome é o do contrato sem o `I` inicial.

O namespace de cada arquivo é o `RootNamespace` do `.csproj` mais próximo acima da pasta mais o
caminho relativo da pasta (CONV-013). Pastas ausentes são criadas. Nada além disso: sem registro de DI,
sem teste, sem pacote, sem os tipos de parâmetro, retorno ou dependência. Pré-requisito ausente: a
skill para e relata o que falta e onde era esperado.

## Escopo (quando usar / NÃO usar)
- **Usar:** repositório cujos métodos delegam a uma dependência (não EF Core), com mapeamento, tratamento de erro e log descritos.
- **NÃO usar:** persistência com EF Core; regra de negócio; contrato ou implementação que já existe (a skill não acrescenta método).

## Contrato

### Rules desta skill
- **Local (dados obrigatórios):** só começa com todos os dados do Inputs. Faltando ou inválido, pede só o que falta e não escreve nada; nunca infere nem usa valor de exemplo.
- **Local (nada além do descrito):** cada método faz só o que a descrição diz: chamada da dependência, mapeamento, tratamento de erro e log. Sem log, `try/catch` ou mapeamento não descritos.
- **Local (mapeamento):** quando descrito, mapeia o resultado da dependência para o **Retorno informado**; o tipo mapeado nunca é deduzido.
- **Local (tratamento de erro):** captura só a exceção descrita e devolve o valor descrito; qualquer outra propaga. Quando a descrição qualifica a exceção (status, código, condição), o `catch` leva filtro `when`; quando a exceção descrita é o próprio filtro, `catch (ExcecaoDescrita)` sem `when`. Ausência vira `null` apenas se o Retorno é anulável e a descrição manda; é ausência, não erro de negócio (CONV-069).
- **Local (formatação):** cada parâmetro do método e do construtor em sua própria linha; numa chamada, quebra depois do `(` e os argumentos seguem juntos.

### Rules gerais (dotnet-conventions.md)
- **CONV-014** `Async` no fim do nome. **CONV-044** `CancellationToken` em toda operação que o aceita. **CONV-074** chamado `cancellationToken`, sem default, último parâmetro.
- **CONV-064** implementação `sealed`. **CONV-066** primary constructor. **CONV-063** identificadores em inglês, exceto os informados pelo usuário.
- **CONV-083** sem engolir exceção. **CONV-062** log estruturado via `ILogger<T>` com message template. **CONV-054** sem PII, senha, token ou payload no log; só identificador.
- **CONV-088** `await` só quando o resultado é usado no método. **CONV-089** corpo em bloco, nunca `=>`.
- **CONV-011/012/013** file-scoped namespace, um tipo por arquivo, namespace espelha a pasta. **CONV-087** pacote novo só com confirmação; a skill não adiciona pacote.

### Pré-condições
Todos os dados informados e válidos. Há um `.csproj` acima de cada diretório. Os tipos citados existem
no repositório ou em pacote já referenciado. Nenhum dos dois arquivos existe.

### Inputs (todos obrigatórios)
1. **Contrato** — nome (`ICustomerRepository`, começa com `I`) e **diretório**.
2. **Implementação** — **diretório**.
3. **Dependências** — tipo e nome de cada uma (`ICustomerApi api`, `IMapper mapper`, `ILogger<CustomerRepository> logger`).
4. **Métodos** (um ou mais), cada um com:
   - **Nome** (termina em `Async`) e **Parâmetros** (tipo e nome; o `cancellationToken` é acrescentado).
   - **Retorno** — tipo final do método, informado explicitamente (o `T` de `Task<T>`; a assinatura é sempre `Task<{Return}>`, `ValueTask` está fora do escopo).
   - **Comportamento** — dependência e método chamados, se o resultado é mapeado, tratamento de erro e log, se houver.

Inválido: nome sem `I`, método sem `Async`, diretório fora de projeto, Retorno ausente, comportamento
sem a chamada da dependência ou com dependência fora da lista.

## Fluxo (ReAct)
1. **Conferir os dados.** Faltando ou inválido algum: pare e peça só o que falta, antes de qualquer outro passo.
2. **Declarar**, num bloco só, antes de escrever: nome do contrato e da implementação, diretórios, `Namespace=` de cada arquivo (`dotnet msbuild <csproj> -getProperty:RootNamespace`; fallback `<RootNamespace>`, `<AssemblyName>`, nome do `.csproj`; nunca o dos exemplos), dependências e cada método (assinatura, chamada, mapeamento, tratamento, log).
3. **Resolver tipos.** Cada tipo citado vem da declaração no repositório (namespace dela) ou de pacote/framework conhecido. Nome ausente ou ambíguo: pare e pergunte.
4. **Checar existência** do contrato e da implementação; existindo, pare e relate qual.
5. **Checar `global using`** para não repetir `using` (`IDE0005` é erro).
6. **Escrever** pelo Template canônico e **verificar** pelo Checklist + Harness.

## Raciocínio antes de agir (CoT)
- Todos os dados vieram do usuário, inclusive o Retorno de cada método e a dependência que ele chama?
- O método repassa uma única chamada async sem nada depois? Sem `async`/`await` (CONV-088). Mapeia, trata erro ou loga depois? Com `await`.
- A descrição manda log ou captura de erro? Se não, o método não tem nenhum dos dois.

## Template canônico
Placeholders recebem os valores do passo 2; nunca copie literalmente.
```csharp
// {InterfaceDir}/I{Name}.cs
// usings dos tipos de parâmetro e de retorno (só os que não forem globais)

namespace {InterfaceNamespace};

public interface I{Name}
{
    Task<{Return}> {Method}Async(
        {ParamType} {paramName},
        CancellationToken cancellationToken);
}
```
```csharp
// {ImplementationDir}/{Name}.cs
// usings das dependências, do contrato e dos tipos usados (só os que não forem globais)

namespace {ImplementationNamespace};

public sealed class {Name}(
    {DepType} {depName},
    {DepType} {depName}) : I{Name}
{
    public async Task<{Return}> {Method}Async(
        {ParamType} {paramName},
        CancellationToken cancellationToken)
    {
        // corpo = só o que a descrição manda, nesta ordem:
        var result = await {depName}.{DepMethod}(
            {args}, cancellationToken);                 // chamada da dependência

        var response = mapper
            .Map<{Return}>(result);                      // mapeamento, se descrito

        return response;                                 // log e tratamento de erro: ver Exemplos
    }
}
```
Repasse puro — uma única chamada, sem mapeamento, log ou tratamento — não usa `async`/`await`; o
método não-`async` tem corpo só `return {depName}.{DepMethod}({args}, cancellationToken);` (CONV-088).
Um bloco por método, separados por linha em branco, na interface e na classe.

## Exemplos
Leia `references/examples.md` antes de escrever: busca por ID com tratamento de 404, busca de coleção
com log e um pedido incompleto.

## Anti-patterns (recusar)
- Começar sem todos os dados, inferir o que falta (diretório, Retorno, dependência) ou usar valor de exemplo → peça só o que falta.
- Deduzir o tipo mapeado a partir do retorno da dependência → use o Retorno informado.
- Log, `try/catch` ou mapeamento que a descrição não pediu; `catch` sem tipo nem filtro, vazio ou que engole a exceção (CONV-083) → capture só a exceção descrita (com `when` quando a descrição a qualifica) e devolva o valor descrito.
- Log com interpolação de string, `Console.WriteLine` ou dado pessoal (CONV-062/054) → message template com identificador.
- `null` por erro de negócio, ou para tipo de retorno não anulável (CONV-069).
- `CancellationToken` ausente ou com `= default`; `=>` em método; classe sem `sealed` (CONV-044/074/089/064).
- Registrar DI, criar tipo ausente, adicionar pacote, sobrescrever arquivo existente; parâmetros na mesma linha; placeholder literal.

## Checklist + Harness

Checklist:
- [ ] Todos os dados informados antes de qualquer escrita; nada inferido.
- [ ] Contrato e implementação nos diretórios e namespaces de "O que gera"; implementação `sealed`, com primary constructor, nome do contrato sem o `I` (CONV-011/012/013/064/066).
- [ ] Cada método: `Async`, `cancellationToken` por último e sem default, corpo em bloco, Retorno igual ao informado (CONV-014/044/074/089).
- [ ] Só o comportamento descrito; `catch` só da exceção descrita, com `when` quando ela é qualificada; log com template e sem PII (CONV-083/062/054).
- [ ] `await` só quando o resultado é usado (CONV-088); nenhum `using` duplicado, registro de DI, pacote ou placeholder.

Harness (gate — só conclui quando passam):
1. `dotnet build` do `.csproj` de cada diretório sem warning.
2. `dotnet format <csproj> --verify-no-changes` sem diferença.

Falha de ambiente/ferramenta (timeout, processo que não inicia) em vez de reprovação por conteúdo:
tente de novo uma vez e, se persistir, reporte "Harness incompleto" e pare — não declare a criação
como concluída.

## Relatório
Ao concluir (ou parar), apresente o relatório no formato de `references/report.md`.
