# Arquivos e locais da versão

Regras por arquivo (Levantar e Executar) e a tabela "Onde a versão sobe". Compartilhado pelas fases do
Fluxo do `SKILL.md`. Em conflito com os Exemplos, esta seção vence.

## Onde a versão sobe
| Local | O que sobe | De | Para |
|---|---|---|---|
| `Directory.Build.props` | `TargetFramework` | qualquer valor | `net10.0` |
| `Directory.Build.props` | `LangVersion` | qualquer valor, ou ausente | `14` |
| `.csproj` | `TargetFramework` e `LangVersion` | declarados no projeto | removidos (o `Directory.Build.props` define) |
| `global.json` | `sdk.version` | `8.0.x` (ou ausente o arquivo) | versão estável do SDK 10 instalado |
| `Dockerfile` | tag das imagens `mcr.microsoft.com/dotnet/{sdk,aspnet,runtime,runtime-deps}` e `ARG` de versão que alimenta o `FROM` | `8.0...` | `10.0...` (tabela da seção `Dockerfile`) |
| Pacotes da família Microsoft | `PackageReference`/`PackageVersion` | `8.x` | maior estável da major 10 |
| Pacotes de terceiros | `PackageReference`/`PackageVersion` | versão atual | maior estável da major atual (regra da seção Pacotes) |

### Arquivos

## `Directory.Build.props`
- **Local:** `{SolutionDir}/Directory.Build.props`. Existe em outro diretório além de `{SolutionDir}` (subdiretório ou ancestral até `{RepoRoot}`): pare e relate.
- **Levantar:** leia `TargetFramework` e `LangVersion` do arquivo (declarados ou não, com ou sem `Condition`).
- **Executar:** ajuste `TargetFramework` para `net10.0` e `LangVersion` para `14` (acrescente os ausentes no primeiro `PropertyGroup` sem `Condition`), preserve todo o resto e relate o que mudou. Propriedade condicional no arquivo: pare e relate.

## `.csproj` (cada projeto da solution)
- **Local:** onde já está.
- **Levantar:** leia `TargetFramework` e `LangVersion` (declarados ou não, com ou sem `Condition`).
- **Executar:** remova `TargetFramework` e `LangVersion`, qualquer que seja o valor. `TargetFramework` com valor diferente de `net8.0` (ex.: `netstandard2.0`) é alerta em linha própria, que o usuário pode excluir. Propriedade com `Condition` (própria ou do `PropertyGroup`): não remova; relate. `PropertyGroup` que ficar vazio é removido. Preserve indentação e o restante do arquivo.

## `global.json`
- **Local:** `{SolutionDir}/global.json`. Existe só em outro diretório: pare e relate.
- **Levantar:** se existir, leia `sdk.version`, `sdk.rollForward` e `sdk.allowPrerelease`. Leia a versão estável mais alta do SDK 10 em `dotnet --list-sdks`: é o `{Sdk10}`.
- **Ausente:** execute `dotnet new globaljson` dentro de `{SolutionDir}` e confira que o `sdk.version` gerado é `{Sdk10}`, sem sufixo de prerelease.
- **Existente:** altere só `sdk.version` para `{Sdk10}`; preserve `rollForward`, `allowPrerelease` e o restante. `sdk.version` já na major 10 estável: nada a fazer. `allowPrerelease` `true`: não altere e relate.
- **Alerta:** o SDK fixado é o instalado nesta máquina; quem tiver SDK mais antigo na mesma major terá erro de resolução, a menos que o `rollForward` permita.

## `Dockerfile`
- **Local:** todo arquivo chamado `Dockerfile`, `Dockerfile.*` ou `*.Dockerfile` na árvore de `{SolutionDir}` e nos diretórios ancestrais até `{RepoRoot}` (ignorando `bin`, `obj`, `.git`, `node_modules` e as pastas das solutions descartadas). Nenhum encontrado: relate, não crie.
- **Levantar:** leia cada `FROM` (inclusive com `--platform` e `AS`) cuja imagem seja `mcr.microsoft.com/dotnet/sdk`, `aspnet`, `runtime` ou `runtime-deps`, e cada `ARG` cujo valor padrão alimente esse `FROM` (`FROM ...:${ARG}`).
- **Executar:** troque só a parte da versão da tag, conforme a tabela. O resto do arquivo não é tocado.

| Tag atual | Tag nova |
|---|---|
| `8.0`, `8.0.<patch>` | `10.0` |
| `8.0-alpine` | `10.0-alpine` |
| `8.0-noble`, `8.0-noble-chiseled` | `10.0-noble`, `10.0-noble-chiseled` |
| `ARG` com valor `8.0...` que alimenta o `FROM` | mesmo mapeamento acima, no valor do `ARG` |
| qualquer outra: sufixo `-slim`, `-bookworm*`, `-bullseye*`, `-jammy*`, `-alpine<versão>`, `-azurelinux*`, digest `@sha256`, imagem `nightly` | não altere a linha; relate como alerta |

- **Alertas fixos:** (a) as imagens .NET 10 não são mais Debian; a tag sem variante (`10.0`) passa a ser Ubuntu 24.04, então o sistema operacional base muda em relação ao `8.0`; (b) `COPY` com caminho relativo, `ENTRYPOINT` e `USER` não são avaliados; (c) a existência da tag nova só é confirmada no Harness.

## Pacotes (`PackageReference`, `PackageVersion`)
- **Local:** cada `.csproj` e, se existir, `Directory.Packages.props` (CONV-058).
- **Levantar:** `dotnet list {Solution} package --outdated` (sem `--include-prerelease`). Para a família Microsoft, liste as versões com `dotnet package search {id} --exact-match --format json` e escolha a maior estável de major 10.
- **Regras:** só pacote direto. Família Microsoft atrelada ao runtime (`Microsoft.AspNetCore.*`, `Microsoft.Extensions.*`, `Microsoft.EntityFrameworkCore.*` e `System.*` publicado com a versão do runtime): maior versão estável da major 10, nunca major 11. Os demais pacotes da Microsoft e os de terceiros: maior versão estável dentro da major atual; a major só sobe quando a versão atual não restaura nem compila em `net10.0`, e cada subida é relatada. Versão prerelease (qualquer sufixo) nunca é instalada. Pacote novo nunca é adicionado (CONV-087).
- **Executar:** com `Directory.Packages.props`, altere só o `PackageVersion`; sem ele, use `dotnet add {csproj} package {id} --version {versao}`. Um pacote por vez, anotando versão anterior e nova. Sem versão estável compatível: mantenha a atual e relate (id, versão, motivo).

| Pacote | Versão alvo |
|---|---|
| Família Microsoft atrelada ao runtime | maior versão estável de major 10 |
| Terceiro, ou outro pacote da Microsoft | maior versão estável dentro da major atual |
| Terceiro que não restaura nem compila em `net10.0` | menor major estável que compila; subida relatada |
| Sem versão estável compatível | manter a atual e relatar |

## Outros locais que citam a versão (somente relato)
- **Local:** `.github/workflows/*`, `azure-pipelines*.yml`, `.gitlab-ci.yml`, `Jenkinsfile`, `docker-compose*`, `.devcontainer/*`, e qualquer `.csproj`/`.props`/`.targets` com condição em `$(TargetFramework)`. Fora das pastas das solutions descartadas.
- **Levantar:** procure por `net8.0`, `8.0.x`, `dotnet-version`, `dotnet/sdk:8`, `dotnet/aspnet:8`, `dotnet/runtime:8`.
- **Executar:** nada. Cada ocorrência entra no relatório como alerta (arquivo, linha, trecho). Não se altera.
