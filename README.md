# ia-skills

Coleção de skills e agentes de IA (Claude Code, Codex, Copilot) para acelerar o ciclo de desenvolvimento de times .NET: do refinamento de histórias no Trello à abertura do PR, passando pela geração de código padronizado em Clean Architecture.

Cada skill segue a mesma anatomia: `SKILL.md` (quando usar, entradas, passos) e `references/` (exemplos, template, relatório e convenções). Toda skill valida os entradas antes de agir, só escreve após aprovação do usuário e termina com um relatório do que fez.

## Estrutura

| Pasta | Conteúdo |
|---|---|
| [`skills/net/`](skills/net) | Skills para .NET/C# com Clean Architecture |
| [`skills/git/`](skills/git) | Skills de GitHub: ler repositório, abrir PR, padronizar repositório |
| [`skills/trello/`](skills/trello) | Skills de Trello: ler, criar, atualizar e comentar cards |
| [`skills/meta-skills/`](skills/meta-skills) | Skills para criar, auditar e manter outras skills |
| [`agents/agente-refinamento/`](agents/agente-refinamento) | Agente de refinamento Scrum |
| [`agents/agente-especificacao/`](agents/agente-especificacao) | Agente de especificação técnica (SDD): spec, plano e tarefas por PR |
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

Os agentes rodam no Claude Code a partir da própria pasta. Cada um tem `README.md`, `AGENTS.md`, `docs/fluxo.svg` e `evals/casos.md`. O refinamento gera cards em linguagem de negócio, sem detalhe técnico de código; a especificação técnica e a label `agent-ready` que o agente de desenvolvimento exige são feitas em outro passo. Todo avanço passa por um gate de aprovação humana, e a revisão e o merge do PR continuam manuais.

### [agente-refinamento](agents/agente-refinamento)

Conduz o refinamento de histórias em 4 fases (entrada, refinamento, revisão e publicação), com consulta opcional ao GitHub a pedido do usuário, e cria os cards no Trello. Roda no Claude Code e no GitHub Copilot.

| Componente | Função |
|---|---|
| Skill [`refine-stories`](agents/agente-refinamento/.claude/skills/refine-stories) | Gera epic, stories, critérios de aceite, subtasks, ordem e dependências, em linguagem de negócio. |
| Skill [`estimate-stories`](agents/agente-refinamento/.claude/skills/estimate-stories) | Estima pontos e horas, sugere o dev e sinaliza carga versus capacidade. |
| Skill [`read-github`](skills/git/read-github) | Lê um repositório e explica a regra atual com arquivo e linha, riscos e lacunas. |
| Skill [`create-trello-card`](skills/trello/create-trello-card) | Cria um card por story e verifica o resultado, após confirmação. |
| Subagent [`github-researcher`](agents/agente-refinamento/.claude/agents/github-researcher.md) | Pesquisa em GitHub (somente leitura) na fase de contexto. |

### [agente-especificacao](agents/agente-especificacao)

Recebe o link de um card do Trello, valida o ambiente, lê o código e conduz, em 6 etapas com gate manual, a spec, o plano e as tarefas (SDD). Com APROVAR ARTEFATOS, grava `specs/<card-id>-<slug>/`, abre o PR e aplica a label `agent-ready`. Não escreve código.

| Componente | Função |
|---|---|
| Skill [`read-story-card`](skills/trello/read-story-card) | Lê o card de negócio e verifica a completude. |
| Skill [`write-spec`](agents/agente-especificacao/.claude/skills/write-spec) | Gera e refina a spec funcional (o quê e por quê). |
| Skill [`write-plan`](agents/agente-especificacao/.claude/skills/write-plan) | Gera e refina o plano técnico. |
| Skill [`write-tasks`](agents/agente-especificacao/.claude/skills/write-tasks) | Quebra o plano em tarefas do tamanho de um PR. |
| Skill [`generate-spec-artifacts`](agents/agente-especificacao/.claude/skills/generate-spec-artifacts) | Confere a consistência e grava `spec.md`, `plan.md` e `tasks.md`. |
| Skill [`update-trello-card`](skills/trello/update-trello-card) | Aplica a label no card, com preview e autorização. |
| Skills [`comment-trello-card`](skills/trello/comment-trello-card) e [`open-pull-request`](skills/git/open-pull-request) | Compartilhadas com o agente de desenvolvimento. |
| Subagent [`context-explorer`](agents/agente-especificacao/.claude/agents/context-explorer.md) | Lê o código e resume padrões e convenções (somente leitura). |

### [agente-desenvolvimento](agents/agente-desenvolvimento)

Recebe o link de um card do Trello e implementa a story: valida o ambiente, lê a spec, planeja, escreve testes e código, revisa o diff e abre o PR. Só aceita cards elegíveis (`agent-ready`, `Tipo: código`, prontidão `pronta`, sem itens a definir).

| Componente | Função |
|---|---|
| Skill [`read-trello-card`](skills/trello/read-trello-card) | Lê o card e verifica a completude da especificação. |
| Skill [`open-pull-request`](skills/git/open-pull-request) | Cria a branch, faz o commit e abre o PR em padrão fixo, após autorização. |
| Skill [`comment-trello-card`](skills/trello/comment-trello-card) | Comenta no card, com preview e autorização. |
| Subagent [`code-explorer`](agents/agente-desenvolvimento/.claude/agents/code-explorer.md) | Lê o código de referência e resume padrões e convenções (somente leitura). |
| Subagent [`test-writer`](agents/agente-desenvolvimento/.claude/agents/test-writer.md) | Escreve os testes a partir dos critérios de aceite, antes do código. |
| Subagent [`dotnet-implementer`](agents/agente-desenvolvimento/.claude/agents/dotnet-implementer.md) | Implementa a story em C#/.NET nos arquivos autorizados. |
| Subagent [`reviewer`](agents/agente-desenvolvimento/.claude/agents/reviewer.md) | Revisa o diff contra a spec e devolve APROVADO ou REPROVADO. |

## Instalação

```bash
./install.sh     # cria links das skills de skills/git, meta-skills, net e trello em ~/.codex, ~/.copilot e ~/.claude
./uninstall.sh   # remove os links
```

Só os diretórios que já existem em `$HOME` são usados. Destinos existentes que não sejam links simbólicos são ignorados.
