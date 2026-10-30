---
name: create-entity
description: 'Cria o esqueleto de uma entidade / aggregate root de domínio (.NET/C#, camada Domain, com identidade) — ex. Account, Order, Customer, Transaction, Invoice. Use sempre que o usuário pedir para criar uma entity, entidade, aggregate, aggregate root ou modelo de domínio com identidade, mesmo sem usar o termo. Não use para value objects sem identidade, nem para DTOs/records de request/response.'
---

# Criar Entity / Aggregate Root (.NET / Clean Architecture)

Gera uma entidade de domínio conforme a `dotnet-conventions.md` (`references/dotnet-conventions.md`).
Esta skill é a fábrica; as rules são o contrato — cite o CONV pelo ID sempre que justificar uma decisão.

Em conflito entre o Template canônico e os Exemplos, o Template vence — os exemplos são
reforço didático, não a fonte primária.

## O que gera
Um único arquivo: `{DomainProjectDir}/{Aggregate}/{Name}.cs` — a classe da entidade, com
construtor privado e factory estática. Nada além disso: sem value object, sem método de
comportamento, sem teste, sem registro de DI. Se algum desses faltar como pré-requisito, esta
skill para (ver Pré-condições) em vez de criá-lo.

## Escopo (quando usar / NÃO usar)
- **Usar:** o conceito tem identidade e ciclo de vida — dois exemplares com o mesmo estado ainda são distintos.
- **NÃO usar:** é um valor sem identidade (é value object, não entidade). É um contrato de borda (é `Request`/`Response`, não entidade).

Esta skill gera só o esqueleto de construção: `sealed class` com identidade, construtor privado
e factory estática (`Create`/`Open`) que valida invariantes de nascimento e retorna
`Result<{Name}>`. Ela não gera métodos de comportamento/mutação (ex.: `Withdraw`, `Cancel`,
`Approve`). Se o pedido incluir comportamento, gere só a construção e avise, ao final, que
comportamento ficou fora do escopo.

## Contrato

### Rules
**Desta skill (entidade / Domain)**
- **CONV-023** Entidade: setter privado, mutação só por método; construção via factory estática `Result<T>` validando invariantes. Sem ctor público sem parâmetros. *Nesta skill:* como nenhum método de mutação é gerado, `get`-only é o padrão; setter privado só onde a propriedade for descrita como mutável ao longo da vida da entidade (ver CoT).
- **CONV-024** Domain NÃO DEVE referenciar EF/ORM nem atributo de persistência (`[Key]`, `[Table]`, `[Column]`). Mapeamento vive na Infrastructure.
- **CONV-025** Value object: imutável, igualdade por valor (`record`/`IEquatable<T>`), auto-validado via factory. *Aqui:* todo valor da entidade é um VO (ex.: `Money`, `AccountNumber`); a entidade só consome, não define VO.
- **CONV-026** Domain guarda só regra de negócio — sem orquestração, I/O ou DTO.
- **CONV-085** Factory (`Create`/`Open` de VO ou entidade) retorna `Result<T>`: invariante violada é `FromInvalid(erro)`; sucesso é `WithSuccess(valor)`.
- **CONV-021** Cada erro é `Error.Create("{Name}.{Reason}", ...)` declarado uma vez, com `Code` estável `{Tipo}.{Motivo}`; sem `Result.Fail("string")` solto, sem hierarquia de `Error`. Erro só do tipo que o declara: campo `private static readonly Error` na própria entidade. Erro compartilhado entre tipos (ex.: not-found) não nasce na entidade: fica em `Domain/Common/DomainErrors.cs`, classe estática por agregado (`{Aggregate}Error`).
- **CONV-059** Dinheiro é `decimal`, nunca `float`/`double`; na entidade é encapsulado no VO `Money` (amount + currency), nunca `decimal` cru.
- **CONV-060** Proibidos `DateTime.Now`, `DateTime.UtcNow`, `DateTimeOffset.Now` e `DateTimeOffset.UtcNow`; tempo sempre UTC (`DateTimeOffset`). O instante entra como **parâmetro** da factory; `TimeProvider` nunca é injetado na entidade.
- **Local desta skill (fora do CONV-063):** termo brasileiro sem tradução (`Cpf`, `Cnpj`, `Cep`) pode ficar no original.

**Gerais (dotnet-conventions.md)**
- **CONV-020** falha esperada é `Result`; sem `throw` para invariante de nascimento. **CONV-069** sem `null` para erro de negócio.
- **CONV-063** identificadores em inglês. **CONV-064** `sealed`. **CONV-068** `class` para tipo com identidade — nunca `record`.
- **CONV-065** acesso mais restritivo. **CONV-015** `private static readonly Error` em PascalCase.
- **CONV-067** guard clause no início da factory. **CONV-096** preferir imutabilidade (`get`-only).
- **CONV-089** corpo em bloco em todo método; nenhum `=>` (expression-bodied), nem no `Create`.
- **CONV-003** sem `!` (null-forgiving). **CONV-087** nenhum pacote novo sem confirmação.
- **CONV-011/012/013** file-scoped namespace, um tipo por arquivo, namespace espelha o caminho da pasta.

Nota sobre `ToString()`: a entidade é `class`, não `record` (CONV-068) — o `ToString()`
sintetizado do `object` imprime só o nome do tipo, sem vazar propriedade nenhuma. Diferente do
value object, aqui não é preciso sobrescrever.

### Pré-condições
O projeto Domain referencia `JacksonVeroneze.NET.Result` (`Result`, `Result<T>`, `Error`,
`ResultType`). Todo value object que a entidade usa precisa já existir em
`Domain/ValueObjects/`. Esta skill não cria value object, método de comportamento, nem qualquer
outro artefato fora do arquivo descrito em "O que gera": se um pré-requisito estiver ausente,
ela para e relata o que falta e onde era esperado — sem apontar como resolver.

### Inputs (todos obrigatórios, exceto Identity, que tem padrão)
1. **Name** — em inglês, PascalCase (`Account`, `Order`); termo brasileiro sem tradução fica no original.
2. **Aggregate** — pasta/agregado dono (normalmente plural: `Accounts`).
3. **Identity** — tipo do Id; se não informado, `Guid` (gerado com `Guid.NewGuid()` dentro do `Create`); ou VO de id forte se o projeto usar — aí o Id é `Result<T>` validado antes da entidade.
4. **Estado** — propriedades e tipos (preferir VO; dinheiro é `Money`). Para cada propriedade, diga se ela é fixa no nascimento ou muda depois (mesmo sem comportamento gerado agora).
5. **Invariantes de criação** — o que precisa valer para a entidade nascer válida (ou o usuário dizer que não há).

Inválido: Name fora de PascalCase em inglês (salvo termo brasileiro sem tradução), Aggregate ausente,
propriedade sem tipo ou sem indicação de fixa ou mutável, invariante não informada.

## Fluxo (ReAct)
1. **Validar inputs.** Faltando ou inválido algum: pare, liste só o que falta e não escreva nada; nunca infira. Não crie uma invariante que não foi pedida.
2. **Localizar o projeto Domain.** Encontre o `.csproj` do Domain.
3. **Resolver identificação.** A partir do `.csproj`, resolva `RootNamespace` (preferencial: `dotnet msbuild <Domain.csproj> -getProperty:RootNamespace`; fallback: `<RootNamespace>` do `.csproj`, senão `<AssemblyName>`, senão o nome do arquivo `.csproj` sem extensão). Declare, num bloco só, antes de escrever qualquer coisa: `Name=`, `Aggregate=`, `RootNamespace=`, e o path final `{DomainProjectDir}/{Aggregate}/{Name}.cs`.
4. **Checar existência.** Se `{Aggregate}/{Name}.cs` já existe, pare aqui — não sobrescreva, relate que o arquivo já existe.
5. **Checar usings globais.** Se o Domain já declara `global using JacksonVeroneze.NET.Result`, não repita o `using` no arquivo (`IDE0005` é erro).
6. **Conferir os value objects necessários.** Para cada valor que deveria ser VO, confirme que existe em `Domain/ValueObjects/`. Faltando algum, pare — relate qual VO falta e onde era esperado; não use primitivo cru no lugar dele e não crie o VO aqui.
7. **Modelar** identidade, estado e invariantes de nascimento (CoT abaixo).
8. **Escrever** o arquivo pelo Template canônico (`references/template.md`).
9. **Verificar** pelo Checklist + Harness e apresentar o relatório.

## Raciocínio antes de agir (CoT)
- Tem identidade e ciclo de vida? Se não, não é entidade.
- Qual o mínimo de estado? O que é VO, o que é primitivo? Cada propriedade é fixa no nascimento (`get`-only) ou o usuário disse que muda depois (`private set`, mesmo sem método gerado agora — deixa a costura pronta)?
- Quais invariantes valem no nascimento? Cada uma vira `private static readonly Error {Name}.{Reason}` + guard clause com chaves retornando `FromInvalid`. A factory precisa de um instante (ex.: `openedAt`)? Entra como parâmetro (CONV-060).
- O pedido incluiu comportamento (ex.: "Withdraw exige saldo suficiente"), I/O, orquestração ou mapeamento? Gere só a construção, não crie o método nem o que não é do Domain, e avise ao final que comportamento ficou fora do escopo.

## Template canônico
Leia `references/template.md` antes de escrever. `{RootNamespace}` e os demais placeholders recebem os
valores resolvidos no passo 3 do Fluxo; nunca copie literalmente.

## Exemplos
Leia `references/examples.md` antes de escrever: `Account` com `AccountNumber`, `Balance` e `OpenedAt`
(certo e errado) e um pedido incompleto.

## Anti-patterns (recusar)
- Escrever sem todos os inputs ou inferir o que falta → pare e liste só o que falta.
- Setter público, ctor público, ou `public Account() { }` (quebra invariante) → ctor privado e factory estática `Result<{Name}>`; propriedades `get`-only.
- `class` sem `sealed`, ou `record` para tipo com identidade (CONV-064/068) → `public sealed class`.
- `throw` para invariante de nascimento (CONV-020/085) → `Result<{Name}>.FromInvalid(...)`.
- `Error` inline/repetido → `private static readonly Error` único por invariante.
- `DateTime.Now`, `DateTime.UtcNow`, `DateTimeOffset.Now`/`.UtcNow` na entidade, ou `TimeProvider` injetado (CONV-060) → instante como parâmetro da factory.
- Atributo `[Key]`/`[Table]`/`[Column]` ou referência a `DbContext`/repositório (CONV-024) → nada de persistência no Domain; o mapeamento vive na Infrastructure.
- Chamar serviço, repositório, mapper ou fazer I/O de dentro da entidade (CONV-026) → o Domain guarda só regra de negócio; remova.
- Expor coleção interna mutável (`List<T>`) → `IReadOnlyList<T>`.
- Gerar método de comportamento/mutação (`Withdraw`, `Cancel`, ...) → gere só a construção e avise que comportamento ficou fora do escopo.
- `private set` sem método que a use e sem mudança futura descrita (código morto) → `get`-only.
- Primitivo cru onde existe (ou cabe) VO, em especial `decimal`/`float`/`double` para dinheiro (CONV-059) → o VO (`Money`).
- Membro expression-bodied (`=>`) em qualquer método, mesmo o `Create` (CONV-089) → corpo em bloco.
- Lib externa sem confirmação (CONV-087) → não adicione; pare e relate.
- Namespace copiado dos exemplos ou placeholder literal (`{RootNamespace}`, `{Aggregate}`) → valores resolvidos no passo 3.
- Criar o VO que falta, ou qualquer artefato fora do escopo → pare e relate o que falta e onde era esperado.

## Checklist + Harness

Checklist (mapeado a CONV):
- [ ] Todos os inputs informados e válidos antes de qualquer escrita; nada inferido.
- [ ] Arquivo em `{DomainProjectDir}/{Aggregate}/{Name}.cs`; namespace `{RootNamespace}.{Aggregate}` com RootNamespace resolvido do `.csproj` (CONV-013).
- [ ] `sealed class`, um tipo por arquivo, file-scoped namespace (CONV-064/068/012/011).
- [ ] Construtor privado; sem ctor público sem parâmetros; construção só via factory `Result<T>` (CONV-023).
- [ ] Propriedade `get`-only por padrão; `private set` só onde o usuário descreveu mudança futura (CONV-023/096).
- [ ] Cada invariante tem `private static readonly Error` com `Code` `{Name}.{Reason}` e guard clause com chaves retornando `FromInvalid`; só as pedidas (CONV-021/085/065/067).
- [ ] `Create`/`Open` retorna `Result<{Name}>`; `WithSuccess(value)` no caminho feliz (CONV-085).
- [ ] Valor como VO; dinheiro é `Money` (CONV-025/059).
- [ ] Instante entra como parâmetro da factory; zero `DateTime.Now`/`.UtcNow`/`DateTimeOffset.Now`/`.UtcNow` e zero `TimeProvider` injetado (CONV-060).
- [ ] Zero atributo/using de EF; zero I/O, orquestração ou DTO; zero método de comportamento gerado (CONV-024/026).
- [ ] Sem `null` para erro, sem `throw` para regra, sem `!` null-forgiving (CONV-069/020/003).
- [ ] Corpo em bloco em todo método, nenhum `=>` (CONV-089); `using` da lib só se não houver global using; `static readonly` em PascalCase (CONV-015).
- [ ] Identificador em inglês, exceto termo brasileiro sem tradução (exceção local; CONV-063 não a prevê). Nenhum pacote novo (CONV-087).
- [ ] Nenhum pré-requisito ausente foi criado por esta skill — o que faltava foi relatado, não gerado.

Harness (gate — só conclui quando passam):
1. `dotnet build <Domain.csproj>` sem warning. Com CONV-002 isso cobre analyzer, `.editorconfig` (`IDE*`, inclusive `IDE0011` e `IDE0005`) e `BannedSymbols.txt`.
2. `dotnet format <Domain.csproj> --verify-no-changes` sem diferença: pega espaço em branco, espaço no fim de linha e quebra de linha.
3. `dotnet test` dos testes que já referenciam o tipo, se existirem: verdes.

Falha de ambiente/ferramenta (timeout, processo que não inicia) em vez de reprovação por conteúdo:
tente de novo uma vez e, se persistir, reporte "Harness incompleto" e pare — não declare a criação
da entidade como concluída.

## Relatório
Ao concluir (ou parar), apresente o relatório no formato de `references/report.md`.
