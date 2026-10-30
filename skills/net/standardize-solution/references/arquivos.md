# Arquivos (regras por arquivo)

Regras por arquivo (Levantar e Executar). O conteúdo dos arquivos novos vem de `assets/`. Compartilhado
pelas fases do Fluxo do `SKILL.md`. Em conflito com os Exemplos, esta seção vence.

## Solution (`.sln`/`.slnx`)
- **Local:** `{Solution}`, onde já está. O arquivo nunca é movido.
- **Levantar:** leia o arquivo da solution e liste as entradas de arquivo (em `.sln`, as linhas dentro de `ProjectSection(SolutionItems)`; em `.slnx`, os `<File Path="...">`) cujo caminho, resolvido a partir de `{SolutionDir}`, é o de um arquivo que a regra de movimentação vai mover. Leia também as solutions descartadas: referência delas a arquivo que será movido entra como alerta.
- **Executar (depois das movimentações):** troque o caminho de cada entrada levantada pelo caminho novo, relativo a `{SolutionDir}` (o próprio nome do arquivo). Em `.sln`, os dois lados de `caminho = caminho`. Preserve o separador, a codificação, o BOM e o fim de linha do arquivo; não reordene, não acrescente nem remova entrada. Entrada que passaria a duplicar outra já existente: pare e relate.
- **Não faz:** não acrescenta à solution os arquivos criados por esta skill, nem os que já estavam em `{SolutionDir}`.

## `Directory.Build.props`
- **Local:** `{SolutionDir}/Directory.Build.props`. Existe em outro diretório (subdiretório de `{SolutionDir}` ou ancestral até `{RepoRoot}`): pare e relate; não crie duplicata nem mova.
- **Levantar:** se existir, leia as quatro propriedades gerenciadas (`Nullable`, `ImplicitUsings`, `PublishAot`, `SatelliteResourceLanguages`). Calcule os valores com a tabela abaixo.
- **Ausente:** copie `assets/Directory.Build.props` e ajuste `Nullable` e `ImplicitUsings` para os valores calculados. O arquivo não traz `TargetFramework` nem `LangVersion`.
- **Existente:** não sobrescreva. Ajuste só as quatro propriedades gerenciadas para os valores do asset (acrescente as ausentes) e preserve todo o resto, inclusive `TargetFramework`, `LangVersion`, `NoWarn` e `NoError`. Relate o que mudou.
- **Valor efetivo de `Nullable` e `ImplicitUsings`.** É o que o MSBuild avalia para o projeto (`dotnet msbuild {csproj} -getProperty:Nullable,ImplicitUsings`), o que já inclui o valor herdado do `Directory.Build.props` existente; resultado vazio conta como `disable`. Em `ImplicitUsings`, `true` e `false` valem como `enable` e `disable`. Valor que não seja `enable` nem `disable`, ou diretiva condicional: pare e relate.

| Situação nos projetos | Valor no `Directory.Build.props` | No `.csproj` |
|---|---|---|
| Todos com valor efetivo `disable` | `disable` | remover a diretiva, se houver |
| Todos com valor efetivo `enable` | `enable` | remover a diretiva, se houver |
| Misto | `enable` | projeto de valor efetivo `enable`: remover a diretiva, se houver; projeto de valor efetivo `disable`: manter ou acrescentar `disable` explícito |

## `.csproj` (cada projeto da solution)
- **Local:** onde já está.
- **Levantar:** leia no XML `AssemblyName`, `RootNamespace`, os itens `InternalsVisibleTo` e as propriedades gerenciadas (declaradas ou não, com ou sem `Condition`). Avalie com `dotnet msbuild {csproj} -getProperty:Nullable,ImplicitUsings,PublishAot,SatelliteResourceLanguages,TargetFramework,LangVersion,AssemblyName`: é a linha de base do Harness. Monte o mapa `{Old}` para `{New}` (regra "nome do assembly") com os `AssemblyName` que serão removidos. Se o `.csproj` ou um `Dockerfile` citar pelo nome um arquivo que será movido, ou se um `Dockerfile`, um `.cs`, um `.props`/`.targets` ou outro script citar um `{Old}`, registre como alerta (não é alterado).
- **Executar:**
  - Remova `PublishAot` e `SatelliteResourceLanguages`, qualquer que seja o valor; valor diferente do global entra no relatório.
  - Remova `AssemblyName`, qualquer que seja o valor. Todo `AssemblyName` removido entra nas tabelas de resumo, com o valor anterior e o nome do assembly depois (o nome do arquivo `.csproj`); quando o valor anterior era diferente desse nome, é alerta.
  - `InternalsVisibleTo`: em todo `.csproj` da solution, troque o nome que for um `{Old}` do mapa pelo `{New}` correspondente, mesmo dentro de `ItemGroup` com `Condition` (é troca de nome, não remoção). Cada troca entra no relatório com `arquivo:linhas`, o valor anterior e o novo. Nome que não está no mapa não é tocado.
  - `Nullable` e `ImplicitUsings` seguem a tabela da seção `Directory.Build.props`.
  - Propriedade com `Condition` (própria ou do `PropertyGroup`): não remova; relate.
  - `PropertyGroup` que ficar vazio é removido. Preserve indentação e o restante do arquivo.
- **`RootNamespace`.** Para cada projeto sem `RootNamespace`, leia os `namespace` declarados nos `.cs` do projeto (ignorando `bin`/`obj` e arquivos gerados) e calcule o maior prefixo, por segmento, comum a todos eles. Acrescente `<RootNamespace>{prefixo}</RootNamespace>` no primeiro `PropertyGroup` do `.csproj` (sem nenhum, crie um). Sem `.cs` com namespace, ou sem prefixo comum: não acrescente e relate o projeto. Já existe `RootNamespace`: não altere; se divergir do calculado, relate os dois valores.

## `entrypoint.sh`
- **Local:** onde já está; o arquivo nunca é movido nem criado. Procura-se por nome, na árvore de `{SolutionDir}` e nos diretórios ancestrais até `{RepoRoot}` (ignorando `bin`, `obj`, `.git`, `node_modules` e as pastas das solutions descartadas). Todo arquivo encontrado é tratado.
- **Ausente:** nada a fazer.
- **Levantar:** com o mapa `{Old}` para `{New}` do `.csproj`, liste as linhas que citam `{Old}.dll` (a citação inteira: o nome não pode ser sufixo de outro nome, como `Meu{Old}.dll`). Registre cada uma como `arquivo:linhas`, com o trecho. Citação de `{Old}` sem `.dll` não é trocada: entra como alerta.
- **Executar:** troque `{Old}.dll` por `{New}.dll` só nas ocorrências levantadas, editando o arquivo no lugar (não recrie), para manter o fim de linha, a codificação, o BOM e a permissão de execução. Mapa vazio: não edita.
- **Não faz:** não altera outra linha, não move o arquivo e não ajusta o `Dockerfile` que o chama.

## `.editorconfig`
- **Local:** `{SolutionDir}/.editorconfig` (regra de movimentação).
- **Ausente:** copie `assets/.editorconfig`.
- **Existente:** não altere o conteúdo.

## `.dockerignore`
- **Local:** `{SolutionDir}/.dockerignore` (regra de movimentação).
- **Ausente:** copie `assets/.dockerignore`.
- **Existente:** não altere o conteúdo.

## `Dockerfile`
- **Local:** `{SolutionDir}/Dockerfile` (regra de movimentação).
- **Ausente:** relate, não crie (não há resource).
- **Existente:** não altere o conteúdo. Movido, os `COPY` com caminho relativo podem quebrar: relate como alerta, sem ajustar.

## `nuget.config`
- **Local:** `{SolutionDir}/nuget.config` (regra de movimentação).
- **Ausente:** relate, não crie (não há resource).
- **Existente:** não altere o conteúdo.
