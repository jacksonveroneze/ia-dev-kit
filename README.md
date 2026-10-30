# ia-skills

Coleção de skills e agentes de IA (Claude Code, Codex, Copilot) para acelerar o ciclo de desenvolvimento de times .NET: do refinamento de histórias no Trello à abertura do PR, passando pela geração de código padronizado em Clean Architecture.

Cada skill segue a mesma anatomia: `SKILL.md` (quando usar, entradas, passos) e `references/` (exemplos, template, relatório e convenções). Toda skill valida os entradas antes de agir, só escreve após aprovação do usuário e termina com um relatório do que fez.

## Estrutura

| Pasta | Conteúdo |
|---|---|
| [`skills/net/`](skills/net) | Skills para .NET/C# com Clean Architecture |
| [`skills/meta-skills/`](skills/meta-skills) | Skills para criar, auditar e manter outras skills |
| [`agents/agente-refinamento/`](agents/agente-refinamento) | Agente de refinamento Scrum |
| [`agents/agente-desenvolvimento/`](agents/agente-desenvolvimento) | Agente que implementa stories e abre o PR |

## Skills .NET

Em [`skills/net/`](skills/net). As convenções comuns ficam em [`rules/dotnet-conventions.md`](skills/net/rules/dotnet-conventions.md) e são vinculadas a cada skill por `link-rules.sh`.

| Skill | O que faz |
|---|---|
| [`create-entity`](skills/net/create-entity) | Cria o esqueleto de uma entidade / aggregate root na camada Domain (ex. Account, Order). |
| [`create-value-object`](skills/net/create-value-object) | Cria value objects sem identidade, com validação (ex. Money, Cpf, Email). |
| [`create-efcore-repository`](skills/net/create-efcore-repository) | Cria a porta na Application e a implementação na Infrastructure com EF Core (`IEfCoreRepository`). |
| [`create-external-repository`](skills/net/create-external-repository) | Cria interface e implementação de repositório sem EF Core, delegando a cliente HTTP, API ou cache, com erro e log descritos. |
| [`create-refit-interface`](skills/net/create-refit-interface) | Cria a interface Refit para APIs externas e os records dos contratos de retorno. |
| [`create-read-use-case`](skills/net/create-read-use-case) | Cria casos de uso de leitura na Application: `GetById` e `GetPaged`. |
| [`create-mapper`](skills/net/create-mapper) | Cria o mapeamento explícito entidade para Response com Mapster (`IRegister`). |
| [`create-endpoint`](skills/net/create-endpoint) | Cria o endpoint Minimal API (camada Api) de um use case de leitura existente. |
| [`standardize-solution`](skills/net/standardize-solution) | Padroniza uma solution existente: `Directory.Build.props`, `.csproj`, Dockerfile, `.editorconfig`, `.dockerignore`, sem mudar versões. |
| [`migrate-to-dotnet10`](skills/net/migrate-to-dotnet10) | Migra uma solution de .NET 8 para .NET 10: TargetFramework, LangVersion, `global.json`, imagens Docker e pacotes. |

## Meta-skills

Em [`skills/meta-skills/`](skills/meta-skills). Material comum (anatomia, régua, comportamento e modelo de relatório) em [`_shared/`](skills/meta-skills/_shared).

| Skill | O que faz |
|---|---|
| [`create-skill`](skills/meta-skills/create-skill) | Cria uma nova skill na anatomia padrão, em duas fases (refinamento e criação), só escrevendo após o APROVADO. |
| [`audit-skill`](skills/meta-skills/audit-skill) | Audita uma skill quanto à anatomia e às boas práticas, e opcionalmente a executa N vezes para medir variação. Não altera a skill. |
| [`standardize-skill`](skills/meta-skills/standardize-skill) | Corrige uma skill existente para a anatomia e a régua do projeto, sem mudar seu comportamento. |
| [`explain-skill`](skills/meta-skills/explain-skill) | Explica o que uma skill faz e não faz e gera um exemplo fictício. Somente leitura. |
| [`create-rule`](skills/meta-skills/create-rule) | Cria e otimiza as rules invariantes (entradas CONV) do catálogo `dotnet-conventions`. |

## Agentes

Os agentes rodam no Claude Code a partir da própria pasta. Cada um tem `README.md`, `AGENTS.md`, `docs/fluxo.svg` e `evals/casos.md`. Os dois se complementam: o refinamento gera cards com a label `agent-ready` que o agente de desenvolvimento consome. Todo avanço passa por um gate de aprovação humana, e a revisão e o merge do PR continuam manuais.

### [agente-refinamento](agents/agente-refinamento)

Conduz o refinamento de histórias em 5 fases (entrada, contexto, refinamento, revisão e publicação) e cria os cards no Trello. Roda no Claude Code e no GitHub Copilot.

| Componente | Função |
|---|---|
| Skill [`refine-stories`](agents/agente-refinamento/.claude/skills/refine-stories) | Gera epic, stories, critérios de aceite, subtasks, especificação técnica, ordem e dependências. |
| Skill [`estimate-stories`](agents/agente-refinamento/.claude/skills/estimate-stories) | Estima pontos e horas, sugere o dev e sinaliza carga versus capacidade. |
| Skill [`read-github`](agents/agente-refinamento/.claude/skills/read-github) | Lê um repositório e explica a regra atual com arquivo e linha, riscos e lacunas. |
| Skill [`publish-trello`](agents/agente-refinamento/.claude/skills/publish-trello) | Cria um card por story e verifica o resultado, após confirmação. |
| Subagent [`github-researcher`](agents/agente-refinamento/.claude/agents/github-researcher.md) | Pesquisa em GitHub (somente leitura) na fase de contexto. |
| Subagent [`datadog-analyst`](agents/agente-refinamento/.claude/agents/datadog-analyst.md) | Consulta métricas, traces e logs no Datadog, com dado pessoal mascarado. |

### [agente-desenvolvimento](agents/agente-desenvolvimento)

Recebe o link de um card do Trello e implementa a story: valida o ambiente, lê a spec, planeja, escreve testes e código, revisa o diff e abre o PR. Só aceita cards elegíveis (`agent-ready`, `Tipo: código`, prontidão `pronta`, sem itens a definir).

| Componente | Função |
|---|---|
| Skill [`read-trello-card`](agents/agente-desenvolvimento/.claude/skills/read-trello-card) | Lê o card e verifica a completude da especificação. |
| Skill [`open-pull-request`](agents/agente-desenvolvimento/.claude/skills/open-pull-request) | Cria a branch, faz o commit e abre o PR em padrão fixo, após autorização. |
| Skill [`comment-trello-card`](agents/agente-desenvolvimento/.claude/skills/comment-trello-card) | Comenta no card, com preview e autorização. |
| Subagent [`code-explorer`](agents/agente-desenvolvimento/.claude/agents/code-explorer.md) | Lê o código de referência e resume padrões e convenções (somente leitura). |
| Subagent [`test-writer`](agents/agente-desenvolvimento/.claude/agents/test-writer.md) | Escreve os testes a partir dos critérios de aceite, antes do código. |
| Subagent [`dotnet-implementer`](agents/agente-desenvolvimento/.claude/agents/dotnet-implementer.md) | Implementa a story em C#/.NET nos arquivos autorizados. |
| Subagent [`reviewer`](agents/agente-desenvolvimento/.claude/agents/reviewer.md) | Revisa o diff contra a spec e devolve APROVADO ou REPROVADO. |

## Instalação

```bash
./install.sh     # cria links das skills de skills/net em ~/.codex, ~/.copilot e ~/.claude
./uninstall.sh   # remove os links
```

Só os diretórios que já existem em `$HOME` são usados. Destinos existentes que não sejam links simbólicos são ignorados.
