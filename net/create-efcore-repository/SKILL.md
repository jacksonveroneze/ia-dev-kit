---
name: create-efcore-repository
description: 'Cria o repositório de persistência com EF Core de um agregado (.NET/C#, Clean Architecture) — a porta na camada Application e a implementação na Infrastructure via JacksonVeroneze.NET.EntityFramework (IEfCoreRepository). Use sempre que o usuário pedir um repository, repositório, porta de persistência ou acesso a dados de um agregado (ex. AccountRepository, OrderRepository), mesmo sem usar o termo. Não use para repositório que delega a API, cliente HTTP ou cache, nem para regra de negócio (Domain) ou orquestração de caso de uso.'
---

# Criar Repository EF Core (.NET / Clean Architecture)

Gera o par **porta + implementação** de um agregado conforme a `dotnet-conventions.md` da raiz do
projeto. Esta skill é a fábrica; as rules são o contrato — cite o CONV pelo ID sempre que
justificar uma decisão.

Em conflito entre o Template canônico e os Exemplos abaixo, o Template vence — os exemplos são
reforço didático, não a fonte primária.

## O que gera
Dois arquivos, em dois projetos diferentes. `{X}ProjectDir` é a pasta do `.csproj` daquele
projeto, e **cada projeto tem `RootNamespace` próprio**.

- Porta: `{ApplicationProjectDir}/Abstractions/Repositories/{AggregateFolder}/I{Aggregate}Repository.cs`, namespace `{ApplicationRootNamespace}.Abstractions.Repositories.{AggregateFolder}`.
- Implementação: `{InfrastructureProjectDir}/Repositories/{AggregateFolder}/{Aggregate}Repository.cs`, namespace `{InfrastructureRootNamespace}.Repositories.{AggregateFolder}`.

A porta e a implementação expõem sempre o catálogo completo: `GetByIdAsync`, `GetPagedAsync`,
`CreateAsync`, `UpdateAsync` e `DeleteAsync`. Nada além disso: sem entidade, sem mapeamento de
persistência, sem registro de DI, sem teste. Se algum desses faltar como pré-requisito, esta skill
para (ver Pré-condições) em vez de criá-lo.

## Escopo (quando usar / NÃO usar)
- **Usar:** dar acesso de persistência a **um agregado** — uma porta por agregado, com o catálogo completo.
- **NÃO usar:** regra de negócio (é do Domain). Orquestração (é do use case). Mapeamento de tabela. Registro de DI.

## Contrato

### Rules
**Desta skill (repositório / Infrastructure)**
- **CONV-010** Porta de repositório vive na Application, escopo **por agregado** (`IAccountRepository`), compartilhada pelos slices daquele agregado — nunca uma porta por use case.
- **CONV-030** Porta de repositório vive em `Application/Abstractions/Repositories/{AggregateFolder}/`. Application NÃO DEVE referenciar tipo concreto de infra (`DbContext`, provider). *Aqui:* `Page<{Aggregate}>` na assinatura é aceitável — é um DTO de paginação (`JacksonVeroneze.NET.Pagination`), não um tipo de infra.
- **CONV-032** Infrastructure contém só: repositório, configuração de persistência, integração externa. Zero regra de negócio.
- **CONV-034** Repositório implementa a porta; async + `CancellationToken`; retorna entidade, `Page<T>` ou `null`. NÃO DEVE vazar tipo de query do store (`IQueryable`). *Aqui:* `null` significa ausência, não erro de negócio (ver Nota).
- **CONV-007/008 (trecho de dependência)** `Infrastructure` referencia `Application` (+ `Domain`). Camada de baixo NÃO DEVE referenciar camada de cima: a porta não conhece a implementação e a Application não referencia a Infrastructure.
- **CONV-082** A porta de repositório é exceção explícita ao veto de "abstração de implementação única" do CONV-081, justificada por DIP + seam de teste.
- **Local desta skill (catálogo completo):** a porta e a implementação sempre trazem as cinco operações do catálogo, mesmo que nenhum use case as use ainda. É decisão de projeto declarada aqui, não especulação.
- **Local desta skill (`IEfCoreRepository`):** a implementação injeta `IEfCoreRepository<{Aggregate}, {DbContextType}>`, nunca o `DbContext` direto. O `DbContext` só é acessado por `efRepository.DbContext`.
- **Local desta skill (limite transacional):** o método de mutação faz o `SaveChangesAsync` dentro dele mesmo, via `efRepository.DbContext.SaveChangesAsync(cancellationToken)`. Um agregado por transação, sem unit of work.
- **Local desta skill (formatação):** cada parâmetro de método, da interface, da implementação e do construtor primário (mesmo com um só parâmetro), fica em sua própria linha, indentado.

**Gerais (dotnet-conventions.md)**
- Valem sem repetir o texto: CONV-011/012/013 (namespace e arquivo), 044/074 (`cancellationToken`), 063 (inglês), 064 (`sealed`), 066 (primary constructor), 069 (ver Nota), 081, 087, 088 (`await` só quando usa o resultado), 089 (corpo em bloco) e 090 (lambda descritivo). Estilo e formatação, o build e o `dotnet format` barram (CONV-002).
- *Acréscimo a CONV-011/012/013:* o namespace usa o `RootNamespace` do `.csproj` de **cada** projeto, sem presumir que os dois são iguais.
- *Acréscimo a CONV-087:* `JacksonVeroneze.NET.EntityFramework` (Infrastructure) e `JacksonVeroneze.NET.Pagination` (Application, porque `Page<T>` aparece na porta) já estão confirmados; não pergunte de novo para esses dois.

**Nota — por que não usa `Result`:** repositório não representa falha de negócio (CONV-034); ele
devolve a entidade, `Page<T>` ou `null`. "Não encontrado" como falha de negócio é modelado no use
case (`Result<T>.FromNotFound`), não aqui. Não envolva o retorno da porta em `Result`.

Referência da API do pacote `JacksonVeroneze.NET.EntityFramework`: leia `references/stack-entityframework.md` antes de escrever.

### Pré-condições
A entidade do agregado existe em `{DomainProjectDir}/{AggregateFolder}/{Aggregate}.cs`. A Application
referencia o Domain e o pacote `JacksonVeroneze.NET.Pagination`. A Infrastructure referencia a
Application e o pacote `JacksonVeroneze.NET.EntityFramework`. Existe no repo uma classe `DbContext`
real — **não presuma o nome `AppDbContext`**; ele só é usado como argumento genérico, nunca
injetado sozinho. Esta skill não cria entidade, `DbContext`, mapeamento de persistência, registro
de DI, nem qualquer outro artefato fora dos dois arquivos descritos em "O que gera": se um
pré-requisito estiver ausente, ela para e relata o que falta e onde era esperado — sem apontar como
resolver.

### Inputs
1. **Aggregate** — nome da entidade, PascalCase, singular (`Account`, `Order`). `{aggregate}` é o mesmo nome em camelCase.
2. **AggregateFolder** — pasta do agregado, normalmente plural (`Accounts`); é a pasta onde a entidade já está no Domain.
3. **IdType** — tipo do `Id`, lido da entidade (`Guid` por padrão).

`RootNamespace` dos dois projetos, `EntityNamespace` e `DbContextType` são resolvidos pelo Fluxo,
não perguntados. Faltando o agregado e sem inferência segura, pergunte antes de gerar.

## Fluxo (ReAct)
1. **Localizar os `.csproj`** de Domain, Application e Infrastructure.
2. **Resolver identificação.** Nunca use o namespace dos exemplos desta skill, e nunca presuma que os projetos compartilham o mesmo `RootNamespace`.
   - `ApplicationRootNamespace` e `InfrastructureRootNamespace`, cada um do seu `.csproj`. Preferencial: `dotnet msbuild <csproj> -getProperty:RootNamespace`. Fallback: `<RootNamespace>` do `.csproj`, senão `<AssemblyName>`, senão o nome do arquivo `.csproj` sem extensão.
   - `EntityNamespace` e `IdType`: leia o arquivo da entidade em `{DomainProjectDir}/{AggregateFolder}/{Aggregate}.cs`; o namespace é o da linha `namespace` do arquivo, o tipo é o da propriedade `Id`. Entidade ausente: pare e relate.
   - `DbContextType`: encontre a classe real (ex.: `find . -name "*DbContext.cs"`) e use o nome exato dela. Nenhuma ou mais de uma: pare e pergunte.
   - Declare, num bloco só, antes de escrever qualquer coisa: `Aggregate=`, `AggregateFolder=`, `IdType=`, `EntityNamespace=`, `ApplicationRootNamespace=`, `InfrastructureRootNamespace=`, `DbContextType=`, e o path final dos dois arquivos.
3. **Checar existência.** Se a porta ou a implementação já existe, pare aqui — não sobrescreva nem adicione método; relate qual arquivo já existe.
4. **Conferir referências.** A Application referencia o Domain e `JacksonVeroneze.NET.Pagination`; a Infrastructure referencia a Application e `JacksonVeroneze.NET.EntityFramework`. Faltando alguma, pare e relate o que falta e onde era esperado; não adicione a referência aqui.
5. **Checar usings globais** de cada projeto. Se `EntityNamespace`, `JacksonVeroneze.NET.Pagination.Offset` ou `JacksonVeroneze.NET.EntityFramework.Interfaces` já são `global using` no projeto do arquivo, não repita o `using` (`IDE0005` é erro).
6. **Modelar** as cinco operações (CoT abaixo).
7. **Escrever** porta e implementação pelo Template canônico (`references/template.md`).
8. **Verificar** pelo Checklist + Harness.

## Raciocínio antes de agir (CoT)
- A assinatura da porta menciona tipo de EF ou infra (`DbContext`, `DbSet`, `IQueryable`, `IEfCoreRepository`)? Está errada: a porta é agnóstica (CONV-030). `IEfCoreRepository<,>` e `{DbContextType}` só aparecem no construtor da **implementação**.
- Escrita: `CreateAsync` encadeia duas chamadas async (`efRepository.CreateAsync` e `SaveChangesAsync`), então mantém `async`/`await`. `UpdateAsync` e `DeleteAsync` chamam `Update`/`Delete` (síncronos) e retornam direto a `Task` do `SaveChangesAsync`, sem `async`/`await` (CONV-088). Sempre em corpo de bloco (CONV-089).
- Exclusão: `DeleteAsync` é **hard delete** via `efRepository.Delete(...)`. `SoftDelete` da lib só chama `Update`, então não resolve exclusão lógica. Se o pedido ou a entidade indicar exclusão lógica (ex.: campo de status ou `DeletedAt`), pare e pergunte antes de gerar `DeleteAsync`.
- Paginação: `expression` e `orderExpression` são obrigatórios. Sem filtro pedido, passe `entity => true` e ordene por `entity => entity.Id`. A porta expõe só `page` e `pageSize`; não invente parâmetros de filtro que o usuário não definiu.

## Template canônico
Leia `references/template.md` antes de escrever. Os placeholders (`{ApplicationRootNamespace}`, `{InfrastructureRootNamespace}`,
`{EntityNamespace}`, `{AggregateFolder}`, `{DbContextType}`) recebem os valores resolvidos no passo 2 do Fluxo;
nunca copie literalmente.

## Exemplos
Leia `references/examples.md` antes de escrever: repositório do agregado `Account` (certo e errado).

## Anti-patterns (recusar)
- `IRepository<T>` genérico ou unit of work (CONV-081).
- Injetar `{DbContextType}` diretamente no construtor da implementação — injete `IEfCoreRepository<{Aggregate}, {DbContextType}>`.
- Retornar `IQueryable`/`DbSet` ou expor `.Include(...)` para fora (CONV-034).
- Envolver o retorno da porta em `Result`/`Result<T>` — repositório não representa falha de negócio.
- Porta na Infrastructure, ou tipo de infra (`DbContext`, `IEfCoreRepository`) na assinatura da porta — só `Page<T>` é aceitável, por ser DTO de paginação (CONV-030).
- `SaveChangesAsync` fora do método de mutação, ou chamado num `DbContext` injetado à parte em vez de `efRepository.DbContext`.
- Omitir uma operação do catálogo, ou gerar wrapper para método da lib fora do catálogo (`AnyAsync`, `CountAsync`, `GetAllAsync`, `GetSingleOrDefaultAsync`, `GetPagedCursorAsync`).
- Qualquer regra de negócio dentro do repositório (CONV-032).
- Presumir o nome `AppDbContext` sem checar a classe real do projeto.
- Usar o mesmo `RootNamespace` para porta e implementação, copiar o namespace do exemplo, ou deixar placeholder (`{ApplicationRootNamespace}`, `{EntityNamespace}`...) literal.
- `DeleteAsync` com hard delete numa entidade que indica exclusão lógica sem confirmar com o usuário; tratar `efRepository.SoftDelete` como exclusão lógica pronta.
- `GetPagedAsync` sem `expression`/`orderExpression` (são obrigatórios; não há overload sem eles), ou com esses parâmetros nomeados diferente da interface da lib.
- Nome de pacote errado (`JacksonVeroneze.NET.EF`, `...EFCore`) — o pacote real é `JacksonVeroneze.NET.EntityFramework`.
- Sobrescrever arquivo existente, ou adicionar método a uma porta que já existe.
- Criar a entidade, o `DbContext`, o mapeamento ou qualquer outro artefato fora do escopo, em vez de parar e relatar.
- Violar uma CONV geral listada em Rules (nome, idioma, `cancellationToken`, `async`/`await`, corpo em bloco, lambda) → aplique a CONV; o build e o `dotnet format` barram as de estilo (CONV-002).

## Checklist + Harness

Checklist (mapeado a CONV; as CONV gerais de Rules valem sem repetição aqui):
- [ ] Os dois arquivos nos paths e namespaces de "O que gera", cada um com o `RootNamespace` do próprio `.csproj`; entidade importada pelo `EntityNamespace` real (CONV-010/030/013).
- [ ] Construtor injeta `IEfCoreRepository<{Aggregate}, {DbContextType}>`, nunca o `DbContext` direto; nome real da classe `DbContext` confirmado no repo, nunca presumido como `AppDbContext`.
- [ ] Catálogo completo na porta e na implementação (`GetByIdAsync`, `GetPagedAsync`, `CreateAsync`, `UpdateAsync`, `DeleteAsync`); nada fora dele.
- [ ] Retorno é entidade, `Page<T>` ou `null`, nunca `Result` nem `IQueryable`; sem tipo de infra na porta, só `Page<T>` como exceção (CONV-030/034).
- [ ] Método de mutação faz `SaveChangesAsync` via `efRepository.DbContext`, dentro do próprio método; sem unit of work (CONV-081).
- [ ] `DeleteAsync` é hard delete via `efRepository.Delete`; exclusão lógica indicada na entidade foi confirmada com o usuário.
- [ ] `GetPagedAsync` passa `expression` e `orderExpression`, nunca omitidos nem `null` (padrão `entity => true` e `entity => entity.Id`).
- [ ] Usings presentes ou `global using` confirmado, sem `using` duplicado; nenhum placeholder ou namespace de exemplo copiado; cada parâmetro em sua própria linha (regra local).
- [ ] Zero regra de negócio (CONV-032); nenhum anti-pattern acima ocorre e as CONV gerais de Rules são cumpridas.
- [ ] Nenhum pré-requisito ausente foi criado por esta skill — o que faltava foi relatado, não gerado.

Harness (gate — só conclui quando todos passam):
1. `dotnet build <Application.csproj>` sem warning.
2. `dotnet build <Infrastructure.csproj>` sem warning. Com CONV-002, os dois cobrem analyzer, `.editorconfig` (`IDE*`, inclusive `IDE0011` e `IDE0005`) e `BannedSymbols.txt`.
3. `dotnet format <Application.csproj> --verify-no-changes` e o mesmo para a Infrastructure, sem diferença.
4. Revisão da porta gerada: grep por termos de infra (`DbContext`, `IQueryable`, `IEfCoreRepository`, `[Key]`, `[Table]`) — deve dar vazio. Se o repo já tiver teste de arquitetura automatizado para isso, rode-o em vez do grep.

Se algum comando falhar por erro de ambiente/ferramenta (timeout, processo que não inicia, etc.)
em vez de reprovar por conteúdo do arquivo, não trate como passo concluído: tente de novo uma
vez e, se persistir, reporte ao usuário como Harness incompleto e pare — não declare a criação do
repositório como concluída.

Se algum teste já referencia o tipo, ele também precisa estar verde.

## Relatório
Ao concluir (ou parar), apresente o relatório no formato de `references/report.md`.
