---
name: create-endpoint
description: 'Cria o endpoint HTTP (Minimal API, camada Api) de um use case de leitura já existente, GetById ou GetPaged. Use sempre que o usuário pedir um endpoint, rota, GET, API ou expor um use case por HTTP (ex. GET /accounts/{id}, listar accounts), mesmo sem usar o termo. Não use para criar o use case nem para endpoints de escrita (POST/PUT/PATCH/DELETE).'
---

# Criar Endpoint de Leitura (.NET / Minimal API)

Gera o endpoint HTTP de um use case de leitura conforme a `dotnet-conventions.md` da raiz do
projeto. Esta skill é a fábrica; as rules são o contrato — cite o CONV pelo ID sempre que
justificar uma decisão. Aqui ficam as regras **comuns**; o que é específico de cada endpoint está
nos arquivos de padrão.

Em conflito entre o template de um arquivo de padrão e os exemplos dele, o template vence — os exemplos
são reforço didático, não a fonte primária.

## O que gera
`{Operation}` é o nome de um use case **já existente** na Application (`GetAccountById`,
`GetAccountsPaged`). Cada `{X}ProjectDir` é a pasta do `.csproj` daquele projeto.

- Endpoint: `{ApiProjectDir}/Endpoints/{AggregateFolder}/v1/{Operation}Endpoint.cs` (uma classe por endpoint), namespace `{ApiRootNamespace}.Endpoints.{AggregateFolder}.v1`.
- Só no paginado, em `{ApiProjectDir}/Endpoints/{AggregateFolder}/v1/Models/`, namespace `{ApiRootNamespace}.Endpoints.{AggregateFolder}.v1.Models`: `{Operation}RestRequest.cs`, `{Operation}RestResponse.cs` e `{Operation}RestMapper.cs`.
- Acréscimos em arquivos existentes: uma linha na cadeia do `RouteMappings` da feature; `app.Add{AggregateFolder}Endpoints();` no `Program.cs`, se ainda não estiver; e, no GetById, a constante `RouteNames.{Operation}`, se faltar (ver `references/prerequisites.md` e o arquivo do padrão).
- Testes, **só se o projeto de testes da Api já existir**: `{ApiTestsProjectDir}/Endpoints/{AggregateFolder}/v1/{Operation}EndpointTests.cs` (+ `Models/{Operation}RestMapperTests.cs` no paginado), namespace `{ApiTestsRootNamespace}.Endpoints.{AggregateFolder}.v1`, com os cenários do arquivo do padrão.
- Compartilhados, **só se não existirem**: `ResultTranslator` e `RouteMappings` (`references/prerequisites.md`).

Nada além disso: sem use case, sem helper da Api ausente, sem registro de DI, sem projeto de
testes. Se algum desses faltar como pré-requisito, esta skill para (ver Pré-condições) em vez de
criá-lo. Nunca sobrescreva arquivo existente.

## Escopo (quando usar / NÃO usar)
- **Usar:** expor por HTTP um use case de **leitura** que já existe na Application.
- **NÃO usar:** criar o use case. Endpoint de escrita (POST/PUT/PATCH/DELETE).

## Contrato

### Rules
**Desta skill (endpoint / transporte HTTP)**
- **CONV-035** Endpoint é Minimal API (`MapGet` sobre um `RouteGroupBuilder`); sem controller MVC.
- **CONV-037** O contrato de borda (`Request`/`Response` da Application) é reaproveitado sempre que o protocolo conseguir vincular o tipo direto. NÃO DEVE criar contrato de transporte paralelo por hábito — só quando o protocolo não conseguir vincular (motivo registrado aqui). *Aqui:* o GetById devolve o response da Application; o GetPaged usa `RestRequest`/`RestResponse` + Mapster, porque o `[AsParameters]` não vincula o `PagedRequest` (construtor protegido, `init` com lógica).
- **CONV-040** Adaptador fino: parse do input, chama o use case, traduz o `Result`. Sem regra de negócio, sem repositório. *Aqui:* sem `DbContext` e sem `try/catch`.
- **CONV-073** Versionamento de contrato explícito onde o protocolo suportar; schema/documentação exposta quando aplicável. *Aqui:* um grupo por feature criado por `RouteGroupBuilderFactory.Factory(app, Resource, Version)`, com `Version` explícita e namespace `v1`; respostas documentadas com `.Produces<T>()` e `.AddDefaultResponseEndpoints()`.
- **CONV-031 (trecho de mapeamento)** Mapeamento via Mapster com `IRegister` explícito; todo membro declarado — a config DEVE falhar em membro de destino não mapeado. *Aqui:* o `{Operation}RestMapper` tem um `.Map` por membro, sem convenção implícita, e nunca se mapeia à mão no endpoint.
- **CONV-036 (trecho de HTTP)** O único tradutor de `Result` para HTTP é `ResultTranslator.ToIResult()`; o status nasce do `ResultType` (`Invalid` 400, `NotFound` 404, `Conflict` 409, `RuleViolation` 422, demais 500; sucesso sem valor 204). NÃO DEVE montar `Results.NotFound()`/`Results.BadRequest()` à mão para falha de use case.
- **CONV-061 (trecho de HTTP)** Exceção não tratada é do `IExceptionHandler` global; o endpoint não tem `try/catch`.
- **CONV-079 (trecho de HTTP)** Toda rota com `.RequireAuthorization(AuthorizationPolicies.{AggregateFolder}Read)`; a policy é constante, nunca string literal. Posse do recurso é do use case (CONV-056).
- **Local desta skill (retorno):** o handler devolve `IResult` via `ToIResult()`, não typed results. O modelo de falha é o `ResultType` da lib, sem taxonomia própria.
- **Local desta skill (estrutura):** um endpoint é uma classe `{Operation}Endpoint` com um método `Add{GetById|GetPaged}`, declarado em bloco `extension(RouteGroupBuilder builder)` (CONV-098).
- **Local desta skill (validação do paginado):** inline, com `IValidator<{Operation}Request>` sobre o Request já mapeado, antes do use case (CONV-029/038). Um filtro de endpoint validaria o `RestRequest`, tipo que o Validator não conhece.
- **Local desta skill (formatação):** o `CancellationToken cancellationToken` é o último parâmetro do handler; `using` explícitos para os namespaces de `RouteNames`, `AuthorizationPolicies`, `AddDefaultResponseEndpoints` e do use case.

**Gerais (dotnet-conventions.md)**
- Valem sem repetir o texto: CONV-022/057/070 (nunca serializar `Result`/`Error`, erro sem detalhe interno, nunca expor entidade), 044/074 (`cancellationToken`), 098 (método de extensão em bloco `extension`), 003, 063, 064, 089/090, 042, 087 e 011/012/013 (com o `RootNamespace` do `.csproj` de cada projeto). Estilo e formatação, o build e o `dotnet format` barram (CONV-002).
- *Acréscimo (CONV-048/049/050/051/052/053):* testes xUnit + Moq + Shouldly, `Method_Scenario_ExpectedResult`, AAA, mock só do use case, asserção sobre status e corpo.

### Pré-condições
Existem, antes de começar:
- na Application, em `Features/{AggregateFolder}/{Operation}/`: `I{Operation}UseCase`, `{Operation}Request` e `{Operation}Response` (e, no paginado, `{Operation}Validator`);
- na Api, os helpers listados no Bloco A.2 de `references/prerequisites.md`;
- no GetById, `Id` do `{Operation}Request` do tipo `Guid` (a rota usa `{id:guid}`).

Esta skill não cria use case, helper, registro de DI, nem projeto de testes: se um pré-requisito
estiver ausente, ela para e relata o que falta e onde era esperado — sem apontar como resolver. Ela
também não registra DI: ao terminar, avise que o registro dos use cases, do `IValidator<>`, do
`IMapper` e dos `IRegister` da Api (explícito, sem scanning) não foi feito, e que **sem ele o
endpoint falha em runtime**.

### Inputs (todos obrigatórios)
1. **Use case alvo** — `{Operation}`, deduzido do pedido; confirme que existe na Application.
2. **Aggregate** — entidade, PascalCase, singular (`Account`). **AggregateFolder** — pasta plural (`Accounts`).
3. **Paginado:** filtros e campos ordenáveis vêm do `Request` da Application; não reinvente.

`{resource}` é o segmento de rota: `{AggregateFolder}` em kebab-case minúsculo (`accounts`,
`bank-accounts`). `RootNamespace` dos projetos e os namespaces dos helpers são resolvidos pelo
Fluxo, não perguntados. São placeholders: nunca copie o valor de um exemplo.

Inválido: use case inexistente na Application ou sem padrão correspondente (escrita, cursor, outra leitura);
Aggregate ou AggregateFolder ausente.

## Fluxo (ReAct)
1. **Validar inputs.** Faltando ou inválido algum: pare, liste só o que falta e não escreva nada; nunca infira. Depois, localize os `.csproj` da Api e da Application, o projeto de testes da Api (se existir) e a pasta `Features/{AggregateFolder}/{Operation}/` na Application.
2. **Escolher o padrão** pela tabela do Template canônico e ler o arquivo do padrão inteiro. Nenhum padrão atende: pare e pergunte.
3. **Resolver identificação.** Nunca use o namespace dos exemplos.
   - `ApiRootNamespace` e `ApplicationRootNamespace` (e `ApiTestsRootNamespace`, se houver testes), cada um do seu `.csproj`. Preferencial: `dotnet msbuild <csproj> -getProperty:RootNamespace`. Fallback: `<RootNamespace>`; senão `<AssemblyName>`; senão o nome do `.csproj` sem extensão.
   - Namespace do use case: `{ApplicationRootNamespace}.Features.{AggregateFolder}.{Operation}` (`using` explícito).
   - Declare, num bloco só, antes de escrever qualquer coisa: `Aggregate=`, `AggregateFolder=`, `Operation=`, `resource=`, `ApiRootNamespace=`, `ApplicationRootNamespace=`, e o path final de cada arquivo.
4. **Checar existência.** Se `{Operation}Endpoint.cs` (ou, no paginado, algum arquivo de `Models/`) já existe, ou o método já está na cadeia do `RouteMappings`, pare aqui — não sobrescreva nem duplique, relate.
5. **Checar usings globais** da Api (`Microsoft.AspNetCore.Mvc`, `MapsterMapper`, `FluentValidation`, a lib `Result`): se já são `global using`, não repita o `using` (`IDE0005` é erro).
6. **Executar `references/prerequisites.md`** (verifica; cria só o que falta; para se faltar helper) e declarar os namespaces reais dos helpers.
7. **Conferir o use case** na Application (`I{Operation}UseCase`, `{Operation}Request`, `{Operation}Response`). Faltando: pare e relate.
8. **Escrever** o endpoint (+ modelos REST no paginado) pelo template; **acrescentar** `.Add{...}()` à cadeia do `RouteMappings`; garantir a chamada no `Program.cs`; escrever os testes, se o projeto de testes existir.
9. **Verificar** pelo Checklist + Harness e apresentar o relatório.

## Raciocínio antes de agir (CoT)
- O endpoint só adapta protocolo? Se apareceu regra de negócio, consulta a repositório ou `try/catch`, está no lugar errado (CONV-040).
- Todo status HTTP vem do `ResultTranslator`? Qualquer `Results.NotFound()`/`BadRequest()` manual para falha de use case está errado (CONV-036).
- O tipo do Request/Response é o do use case existente (nunca recriar contrato, CONV-037) e rota, versão, policy e nome de rota vêm de constantes existentes (`Resource`, `Version`, `AuthorizationPolicies`, `RouteNames`), nunca de string solta?
- O método de extensão está num bloco `extension`? Formato clássico com `this` está errado (CONV-098).

## Template canônico
Leia o arquivo do padrão escolhido, inteiro, antes de escrever; cada um traz o Template canônico, os anti-patterns, o checklist e os cenários de teste do padrão.
| Pedido / use case | Arquivo |
|---|---|
| Sempre, antes de qualquer padrão: `ResultTranslator`, helpers exigidos, `RouteMappings` e `Program.cs` | `references/prerequisites.md` |
| Use case `Get{Aggregate}ById` | `references/get-by-id.md` |
| Use case `Get{AggregateFolder}Paged` | `references/get-paged.md` |

Outro use case (escrita, cursor, outra leitura): **não há padrão** — pare e pergunte, não improvise.

## Exemplos
Leia `references/examples.md` antes de escrever: `GetById`, `GetPaged` e pedidos incompletos ou fora de padrão.

## Anti-patterns (recusar)
- Escrever sem todos os inputs ou inferir o que falta → pare e liste só o que falta.
- Regra de negócio, `DbContext`, repositório ou `try/catch` no endpoint; endpoint que chama outro endpoint (CONV-040/061) → o endpoint só adapta protocolo (parse, use case, `ToIResult()`); a exceção é do `IExceptionHandler` global.
- Traduzir `Result` à mão (`if (output.IsFailure) return Results.NotFound()`), serializar `Result`/`Error`, ou expor entidade (CONV-022/036/070) → `ToIResult()` e o response da Application (ou o REST response).
- Rota sem `RequireAuthorization`, policy como string literal, versão ou `Resource` hard-coded fora do `RouteMappings` → `.RequireAuthorization(AuthorizationPolicies.{AggregateFolder}Read)` e as constantes do `RouteMappings`.
- Copiar nomes de exemplo (`GetShortUrlById`, `Accounts`) ou o namespace de um exemplo, ou deixar placeholder literal → valores resolvidos no passo 3.
- Criar de novo `ResultTranslator`/`RouteMappings` que já existem, ou inventar helper ausente (`RouteGroupBuilderFactory`, `AuthorizationPolicies`, `LocationBuilder`...): pare e relate.
- Registrar o mesmo endpoint duas vezes na cadeia, ou duplicar `app.Add{AggregateFolder}Endpoints()` no `Program.cs` → confira a cadeia e o `Program.cs` antes; uma linha e uma chamada.
- `CancellationToken` com default ou não repassado; omitir os `using` explícitos (CONV-074) → último parâmetro, sem default, repassado ao use case, com `using` explícitos.
- Método de extensão no formato clássico (`this RouteGroupBuilder builder`) (CONV-098); `!` em qualquer ponto (CONV-003) → bloco `extension`; sem `!`.
- Criar o use case, o projeto de testes ou qualquer outro artefato fora do escopo, em vez de parar e relatar.

## Checklist + Harness
Checklist (comum; o arquivo do padrão acrescenta os itens do padrão):
- [ ] Todos os inputs informados e válidos antes de qualquer escrita; nada inferido.
- [ ] `references/prerequisites.md` executado e arquivo do padrão lido; nada duplicado.
- [ ] Arquivos nos paths e namespaces de "O que gera", com o `RootNamespace` da Api; um tipo por arquivo (CONV-012/013).
- [ ] Endpoint fino: monta o Request, chama o use case, devolve `ToIResult()` (CONV-040/036); sem `try/catch`.
- [ ] `RequireAuthorization(AuthorizationPolicies.{AggregateFolder}Read)` presente e a constante existe (CONV-079).
- [ ] `CancellationToken cancellationToken` último, sem default, repassado (CONV-044/074).
- [ ] Método `Add...` num bloco `extension`, na cadeia do `RouteMappings`; `Program.cs` chama `app.Add{AggregateFolder}Endpoints()` uma única vez (CONV-098).
- [ ] Sem `!` (CONV-003); nenhum helper recriado; nenhum pacote novo (CONV-087).
- [ ] Nenhum pré-requisito ausente foi criado por esta skill — o que faltava foi relatado, não gerado.
- [ ] Ao terminar, avisado que o registro de DI não foi feito.

Harness (gate — só conclui quando todos passam):
1. `dotnet build <Api.csproj>` sem warning. Com CONV-002 cobre analyzers, `.editorconfig` (`IDE*`, inclusive `IDE0005`) e `BannedSymbols.txt`.
2. `dotnet format <Api.csproj> --verify-no-changes` sem diferença.
3. Testes conforme os cenários do arquivo do padrão (integração com `WebApplicationFactory` e o use case substituído por mock; mapper REST com `Compile()`). Se o projeto de testes da Api não existe, **não o crie** (pacote novo, CONV-087): reporte Harness parcial (build + format) e pare, sem declarar o endpoint concluído.
4. Grep na Api por `DbContext`, `IRepository`, `catch (`, `Value!` e `Results.NotFound(` / `Results.BadRequest(` em endpoints — deve dar vazio.

Se algum comando falhar por erro de ambiente/ferramenta (timeout, processo que não inicia, etc.)
em vez de reprovar por conteúdo do arquivo, não trate como passo concluído: tente de novo uma
vez e, se persistir, reporte como Harness incompleto e pare — não declare o endpoint como
concluído.

## Relatório
Ao concluir (ou parar), apresente o relatório no formato de `references/report.md`.
