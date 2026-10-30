---
name: standardize-solution
description: 'Padroniza uma solution .NET existente sem mudar versão de framework nem pacotes. Cria ou ajusta o Directory.Build.props, limpa os .csproj (propriedades gerenciadas, AssemblyName, RootNamespace), ajusta o InternalsVisibleTo e o entrypoint.sh que citam um AssemblyName removido, move Dockerfile, .dockerignore, nuget.config e .editorconfig para a pasta da solution (atualizando o caminho no arquivo da solution) e cria .editorconfig e .dockerignore quando ausentes. Use sempre que o usuário pedir para padronizar, organizar ou uniformizar os arquivos e projetos de uma solution .NET, mesmo sem citar os arquivos. Não use para migrar a versão do .NET nem para atualizar pacotes.'
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash(git rev-parse *)
  - Bash(dotnet sln * list)
  - Bash(dotnet msbuild * -getProperty:*)
---

# Padronizar solution .NET

Uniformiza os arquivos de raiz e de projeto da solution sem mudar o comportamento dos projetos: o
valor efetivo de `Nullable` e de `ImplicitUsings` de cada projeto continua o mesmo depois da
skill. Não altera versão de framework, `LangVersion` nem pacotes. As regras de cada arquivo estão
na seção dele, em `references/arquivos.md`; o Fluxo só dá a ordem.

Em conflito entre o conteúdo de uma seção e os Exemplos, a seção vence — os exemplos são reforço
didático, não a fonte primária. O conteúdo de arquivo novo vem de `assets/`.

## O que gera
Antes de qualquer alteração, produz o relatório de plano e espera a aprovação do usuário. Depois,
em `{SolutionDir}` (diretório do arquivo `.sln`/`.slnx`, esperado em `app/src`):
- **Cria, se ausente, copiando de `assets/`:** `Directory.Build.props`, `.editorconfig`, `.dockerignore`.
- **Move para `{SolutionDir}`, se estiver em outro diretório:** `Dockerfile`, `.dockerignore`, `nuget.config`, `.editorconfig`.
- **Edita:** o `Directory.Build.props` existente, cada `.csproj` (inclusive o `InternalsVisibleTo`), cada `entrypoint.sh` que cita um `AssemblyName` removido e o arquivo da solution (só o caminho de arquivo movido).

Nada além disso: não cria `Dockerfile` nem `nuget.config`, não altera `.cs`, `TargetFramework`,
`LangVersion`, `global.json`, pacotes, o conteúdo de arquivo existente (exceto o dos itens
acima), pipeline de CI, `appsettings` nem `launchSettings`. Se um pré-requisito faltar, esta
skill para (ver Pré-condições) em vez de criá-lo.

## Escopo (quando usar / NÃO usar)
- **Usar:** solution com projetos SDK-style, em qualquer versão de framework, cujos arquivos e propriedades precisam seguir o padrão.
- **NÃO usar:** projeto que não é SDK-style. Solution sem arquivo `.sln`/`.slnx`; solution de teste ponta a ponta (`E2E`). Mudança de versão do .NET ou de pacote.

## Contrato

### Rules
**Desta skill**
- **Local — qual solution.** Procura-se em `app/src`. Solution cujo nome de arquivo, ou de qualquer pasta do caminho, contém `E2E` (sem diferenciar maiúscula) é ignorada, junto com a pasta dela.
- **Local — aprovação.** A skill só escreve, cria ou move depois de o usuário aprovar o relatório de plano (Gate de aprovação).
- **Local — assets.** `assets/` guarda o conteúdo de todo arquivo que a skill cria. O arquivo novo é cópia literal do asset; os únicos ajustes permitidos são os que a seção do arquivo descreve. Asset ilegível ou ausente: pare e relate.
- **Local — regra de movimentação** (vale para `Dockerfile`, `.dockerignore`, `nuget.config`, `.editorconfig`). Procure o arquivo por **nome**, na árvore de `{SolutionDir}` e nos diretórios ancestrais até `{RepoRoot}` (ignorando `bin`, `obj`, `.git`, `node_modules` e as pastas das solutions descartadas). Só em `{SolutionDir}`: nada a fazer. Em exatamente um outro diretório: mova para `{SolutionDir}` (`git mv` se estiver sob git, senão `mv`) e atualize o caminho na solution (seção "Solution"). Em `{SolutionDir}` e também em outro lugar, ou em mais de um outro diretório: pare e relate. Em nenhum lugar: vale o "Ausente" da seção do arquivo.
- **Local — nome do assembly.** Todo `AssemblyName` removido vira uma entrada do mapa `{Old}` para `{New}`: `{Old}` é o valor que estava no `.csproj` e `{New}` é o nome do arquivo `.csproj` sem extensão; projeto com `{Old}` igual a `{New}` não entra no mapa. O mapa é aplicado em uma única passada (o resultado de uma troca não é trocado de novo). Dois projetos com o mesmo `{Old}`, ou um `{New}` que seja `{Old}` de outro projeto: pare e relate. Onde o nome é ajustado e onde só é relatado:

  | Local | Tratamento |
  |---|---|
  | `.csproj` — `AssemblyName` | removido (seção `.csproj`) |
  | `.csproj` de qualquer projeto da solution — `InternalsVisibleTo` (item `<InternalsVisibleTo Include="..."/>` ou `<AssemblyAttribute>` com `_Parameter1`) | **ajustado**: a parte do nome (antes da primeira vírgula), igual a um `{Old}` do mapa sem diferenciar maiúscula, passa a `{New}`; o resto do valor (`, PublicKey=...`) e os metadados (`Key`) ficam como estão |
  | `entrypoint.sh` | **ajustado**: `{Old}.dll` passa a `{New}.dll` (seção `entrypoint.sh`) |
  | `Dockerfile` (`ENTRYPOINT`, `CMD`), `[assembly: InternalsVisibleTo]` em `.cs`, `InternalsVisibleTo` em `.props`/`.targets`, outros scripts, `docker-compose` | só relatado, não alterado |

**Gerais (dotnet-conventions.md)**
- **CONV-001** o `.csproj` não repete as propriedades do `Directory.Build.props`. *Local desta skill:* o arquivo fica em `{SolutionDir}`, a lista de propriedades é a da seção `Directory.Build.props`, e `TargetFramework` e `LangVersion` não são tocados.

### Pré-condições
- `app/src` existe e, descartadas as solutions `E2E`, contém exatamente um arquivo `.sln`/`.slnx` (ou o caminho foi informado).
- Todo `.csproj` da solution é SDK-style e o MSBuild o avalia sem erro.
- Os três arquivos de `assets/` existem.

Se alguma falhar, esta skill para e relata o que falta e onde era esperado — sem apontar como resolver.

### Inputs
1. **Solution** (opcional) — caminho do `.sln`/`.slnx`. Omitido: procurar em `app/src` (Fluxo, passo 1).

Não há outro input. Valores de Nullable, ImplicitUsings e RootNamespace são calculados.

## Fluxo (ReAct)

**Fase 0 — Identificação e plano (somente leitura)**
1. **Localizar a solution.** Sem caminho informado, procure `.sln`/`.slnx` recursivamente em `{RepoRoot}/app/src` (`{RepoRoot}` é a raiz do repositório git; sem git, o diretório atual). Descarte as solutions `E2E`. Restando exatamente uma, ela é `{Solution}` e o diretório dela é `{SolutionDir}`; zero ou mais de uma: pare e pergunte. As descartadas, e a pasta de cada uma, ficam fora de todas as buscas e entram no relatório. Liste os projetos com `dotnet sln {Solution} list`.
2. **Checar as Pré-condições.** Falhou alguma: pare e relate.
3. **Levantar.** Execute o "Levantar" de cada seção de `references/arquivos.md`, na mesma ordem do passo 6 (a seção Solution é a última porque depende de quais arquivos serão movidos).
4. **Calcular o plano.** Aplique no papel o "Executar" de cada seção.
5. **Apresentar o relatório de plano** no formato de `references/report.md` (seção "Relatório de plano") e parar. A visão geral vem primeiro: arquivos a criar, arquivos a mover, entradas da solution a atualizar, `AssemblyName` a remover, referências ao nome do assembly a ajustar.

**Gate de aprovação**
- Nada é criado, movido ou editado antes da aprovação explícita do usuário ("aprovo", "pode executar"). Pergunta, ajuste ou comentário não é aprovação: responda e reapresente o relatório.
- Aprovação parcial (o usuário exclui linhas): execute só o aprovado. Linha de movimentação excluída também exclui a atualização da solution correspondente; linha de `AssemblyName` excluída também exclui os ajustes de nome (`InternalsVisibleTo`, `entrypoint.sh`) que dependem dela.
- Divergência durante a execução em relação ao relatório aprovado (arquivo novo, valor diferente): pare e reapresente o relatório atualizado.
- Se o agente oferecer um modo de planejamento, use-o para apresentar o relatório. Ele não substitui este gate.

**Fase 1 — Padronização (após a aprovação)**
6. Execute o "Executar" de cada seção de `references/arquivos.md`, nesta ordem: `.editorconfig`, `.dockerignore`, `Dockerfile`, `nuget.config`, `Directory.Build.props`, `.csproj`, `entrypoint.sh` (depois do `.csproj`, que monta o mapa de nomes), Solution (por último, depois de todas as movimentações).

**Fase 2 — Verificação**
7. Verificar pelo Checklist + Harness. Falha causada pela padronização: pare e relate; não edite código-fonte.

## Raciocínio antes de agir (CoT)
- Qual o valor efetivo de `Nullable` e de `ImplicitUsings` em cada projeto, já contando o herdado do `Directory.Build.props` existente? Todos iguais, ou misto?
- Algum arquivo será movido? A solution o referencia? Outra solution (descartada) o referencia?
- Algum `.csproj` tem `AssemblyName` diferente do nome do arquivo? Quem cita o nome antigo: `InternalsVisibleTo` (em qualquer `.csproj`), `entrypoint.sh`, `Dockerfile`, `.cs`? Qual desses a skill ajusta e qual só relata?
- Alguma propriedade é condicional, ou tem valor fora de `enable`/`disable`? Se sim, pare.
- O prefixo de namespace calculado é o da raiz do projeto ou de uma subpasta (poucos arquivos)? Relate o valor e quantos arquivos o sustentam.

## Template canônico
Saída: o mapa de alterações é o relatório de plano de `references/report.md` (visão geral e uma tabela por arquivo
e por projeto). As regras por arquivo estão em `references/arquivos.md` e o conteúdo dos arquivos novos em `assets/`: leia antes da Fase 0.

## Exemplos
Leia `references/examples.md` antes da Fase 1: `Directory.Build.props` novo, caso misto de `Nullable`/`ImplicitUsings`,
diretiva ausente com arquivo existente, `AssemblyName` com `InternalsVisibleTo` e `entrypoint.sh`, e
atualização da solution (`.sln` e `.slnx`).

## Anti-patterns (recusar)
- Escrever, criar ou mover qualquer coisa antes da aprovação do relatório; tratar pergunta ou comentário como aprovação.
- Mover arquivo e não atualizar o caminho dele na solution; ou acrescentar à solution arquivo que ela não referenciava.
- Considerar a solution `E2E`, ou procurar arquivos dentro da pasta dela.
- Sobrescrever um `Directory.Build.props` existente; criar outro em `{SolutionDir}` quando já existe em subdiretório ou ancestral.
- Tocar em `TargetFramework`, `LangVersion`, `global.json` ou pacotes; alterar o conteúdo de arquivo de raiz existente.
- Deixar `PublishAot`, `SatelliteResourceLanguages` ou `AssemblyName` no `.csproj`; remover `AssemblyName` sem listá-lo nas tabelas de resumo.
- Remover `AssemblyName` e deixar `InternalsVisibleTo` (em qualquer `.csproj`) ou `entrypoint.sh` apontando para o nome antigo; apagar o sufixo de chave pública do `InternalsVisibleTo`; recriar o `entrypoint.sh` em vez de editá-lo (perde a permissão de execução); ajustar `Dockerfile` ou `.cs`.
- Remover `Nullable`/`ImplicitUsings` de um projeto de valor efetivo `disable` no caso misto, sem deixar `disable` explícito; tratar diretiva ausente como `disable` quando o `Directory.Build.props` existente já define a propriedade.
- Remover propriedade condicional sem parar e relatar.
- Criar `Dockerfile` ou `nuget.config` que não existiam; escrever arquivo novo que não seja cópia do asset.
- `RootNamespace` copiado dos exemplos, ou placeholder (`{RootNamespace}`, `{SolutionDir}`...) deixado literal.

## Checklist + Harness

Checklist:
- [ ] Fase 0 sem nenhuma escrita; relatório de plano apresentado no formato de `references/report.md`; execução só depois da aprovação explícita.
- [ ] Solution escolhida em `app/src`, com as `E2E` descartadas e listadas no relatório.
- [ ] Todo arquivo movido está em `{SolutionDir}` e a entrada dele na solution, quando existia, aponta para o caminho novo; nenhuma outra entrada foi alterada.
- [ ] `Directory.Build.props` único, em `{SolutionDir}`, com as quatro propriedades e os valores da tabela (CONV-001).
- [ ] Nenhum `.csproj` repete as propriedades gerenciadas nem tem `AssemblyName`; cada `AssemblyName` removido está nas tabelas de resumo.
- [ ] Nenhum `InternalsVisibleTo` de `.csproj` nem `entrypoint.sh` cita um `{Old}` do mapa (salvo linha excluída pelo usuário); `entrypoint.sh` mantém a permissão de execução.
- [ ] Todo `.csproj` tem `RootNamespace` (ou o motivo de não ter está no relatório final).
- [ ] Arquivo criado é cópia do asset (com os ajustes da seção, se houver); nenhum `Dockerfile` ou `nuget.config` foi criado.
- [ ] Nenhum `.cs`, `TargetFramework`, `LangVersion`, `global.json`, pacote, conteúdo de arquivo existente, pipeline ou `appsettings` foi alterado.
- [ ] Relatório final apresentado em tabelas.

Harness (gate — só conclui quando passam):
1. Reavaliar cada projeto com `dotnet msbuild {csproj} -getProperty:...` e comparar com a linha de base: `Nullable` e `ImplicitUsings` iguais (vazio e `disable` equivalem; `true` e `enable` equivalem); `TargetFramework` e `LangVersion` idênticos; `PublishAot` e `SatelliteResourceLanguages` iguais aos do `Directory.Build.props`; `AssemblyName` igual ao nome do arquivo `.csproj`. As diferenças esperadas vão para o relatório.
2. `dotnet sln {Solution} list` sem erro, e cada caminho de entrada da solution alterada existe em disco.
3. `dotnet build {Solution}` sem erro. Warnings novos entram no relatório final; não são corrigidos aqui.
4. `dotnet test {Solution} --no-build` verde, quando a solution tem projeto de teste.
5. Buscar (Grep) cada `{Old}` do mapa nos `.csproj` (`InternalsVisibleTo`) e nos `entrypoint.sh`: nenhuma ocorrência restante, exceto de linha excluída pelo usuário (essas aparecem no relatório final como pendência).

Se algum comando falhar por erro de ambiente/ferramenta (timeout, processo que não inicia, feed
indisponível) em vez de reprovar por conteúdo, não trate como passo concluído: tente de novo uma
vez e, se persistir, reporte ao usuário como Harness incompleto e pare — não declare a padronização
como concluída.

## Relatório
Ao concluir (ou ao parar), apresente as tabelas da seção "Relatório final" de `references/report.md`: o que foi feito por linha, arquivos criados e movidos, entradas da solution
atualizadas, projetos editados (com `AssemblyName` removido), referências ao nome do assembly ajustadas, resultado do Harness e o que ficou
fora do escopo.
