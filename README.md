# ia-dev-kit

Coleção de skills e agentes de IA (Claude Code, Codex, Copilot) para acelerar o ciclo de desenvolvimento de times .NET: do refinamento de histórias no Trello à abertura do PR, passando pela geração de código padronizado em Clean Architecture.

Cada skill segue a mesma anatomia: `SKILL.md` (quando usar, entradas, passos) e `references/` (exemplos, template, relatório e convenções). Toda skill valida as entradas antes de agir, só escreve após aprovação do usuário e termina com um relatório do que fez.

## Estrutura

| Pasta | Conteúdo |
|---|---|
| [`skills/net/`](skills/net) | Skills para .NET/C# com Clean Architecture |
| [`skills/git/`](skills/git) | Skills de GitHub: repositório, PR, review e worktrees |
| [`skills/trello/`](skills/trello) | Skills de Trello: ler, criar, atualizar, mover e comentar cards |
| [`skills/engineering/`](skills/engineering) | Skills de engenharia: rollout seguro e causa raiz |
| [`skills/meta-skills/`](skills/meta-skills) | Skills para criar, auditar e manter outras skills |
| [`agents/agente-refinamento/`](agents/agente-refinamento) | Agente de refinamento Scrum |
| [`agents/agente-especificacao/`](agents/agente-especificacao) | Agente de especificação técnica (SDD): spec, plano e tarefas por PR |
| [`agents/agente-desenvolvimento/`](agents/agente-desenvolvimento) | Agente que implementa uma tarefa da spec e abre o PR |
| [`agents/agente-revisao/`](agents/agente-revisao) | Agente que revisa um PR com 4 revisores em paralelo |
| [`agents/agente-resposta-revisao/`](agents/agente-resposta-revisao) | Agente que ajuda o autor a responder às revisões do PR |
| [`templates/`](templates) | Modelos para o repositório-alvo: CLAUDE.md, constitution, hooks, CI |
| [`docs/board-trello.md`](docs/board-trello.md) | Guia do board do Trello: listas, labels e quem move o quê |

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
| [`write-dotnet-tests`](skills/net/write-dotnet-tests) | Gera testes xUnit, Moq e Shouldly a partir dos critérios de aceite, com preview e autorização. |
| [`create-mapper`](skills/net/create-mapper) | Cria o mapeamento explícito entidade para Response com Mapster (`IRegister`). |
| [`create-endpoint`](skills/net/create-endpoint) | Cria o endpoint Minimal API (camada Api) de um use case de leitura existente. |
| [`standardize-solution`](skills/net/standardize-solution) | Padroniza uma solution existente: `Directory.Build.props`, `.csproj`, Dockerfile, `.editorconfig`, `.dockerignore`, sem mudar versões. |
| [`migrate-to-dotnet10`](skills/net/migrate-to-dotnet10) | Migra uma solution de .NET 8 para .NET 10: TargetFramework, LangVersion, `global.json`, imagens Docker e pacotes. |

## Skills de Git

Em [`skills/git/`](skills/git). Skills de escrita têm preview em somente leitura e só escrevem após autorização explícita.

| Skill | O que faz |
|---|---|
| [`read-github`](skills/git/read-github) | Lê um repositório e explica a regra atual com arquivo e linha, riscos e lacunas. |
| [`open-pull-request`](skills/git/open-pull-request) | Cria a branch, faz o commit e abre o PR em padrão fixo. |
| [`read-pull-request`](skills/git/read-pull-request) | Lê um PR (metadados, diff, checks, comentários), somente leitura. |
| [`post-review-comments`](skills/git/post-review-comments) | Publica uma review com comentários em linha, com preview e autorização. |
| [`read-review-comments`](skills/git/read-review-comments) | Lê as threads de review de um PR, somente leitura. |
| [`reply-review-comment`](skills/git/reply-review-comment) | Responde a threads de review, com preview e autorização. |
| [`git-worktrees`](skills/git/git-worktrees) | Cria, lista e remove worktrees para trabalho em paralelo. |
| [`standardize-repository`](skills/git/standardize-repository) | Padroniza a configuração de um repositório. |

## Skills de Trello

Em [`skills/trello/`](skills/trello). O guia do board está em [`docs/board-trello.md`](docs/board-trello.md).

| Skill | O que faz |
|---|---|
| [`read-story-card`](skills/trello/read-story-card) | Lê um card de story e confere a completude de negócio. |
| [`read-trello-card`](skills/trello/read-trello-card) | Lê um card e confere a completude da especificação técnica. |
| [`create-trello-card`](skills/trello/create-trello-card) | Cria um card por story e verifica o resultado, após confirmação. |
| [`update-trello-card`](skills/trello/update-trello-card) | Aplica uma label existente a um card, com preview e autorização. |
| [`move-trello-card`](skills/trello/move-trello-card) | Move um card para outra lista do board, com preview e autorização. |
| [`comment-trello-card`](skills/trello/comment-trello-card) | Comenta no card, com preview e autorização. |

## Skills de engenharia

Em [`skills/engineering/`](skills/engineering).

| Skill | O que faz |
|---|---|
| [`safe-rollout`](skills/engineering/safe-rollout) | Monta o bloco de rollout e rollback (feature flag, depreciação, remoção) de uma mudança. |
| [`root-cause-debugging`](skills/engineering/root-cause-debugging) | Investiga a causa raiz de um bug com evidência e sugere correção e teste, sem aplicar. |

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

Recebe o link de um card do Trello, valida o ambiente, lê o código e conduz, em 6 etapas com gate manual, a spec, o plano e as tarefas (SDD). Com APROVAR ARTEFATOS, grava `specs/<card-id>-<slug>/`, abre o PR, aplica a label `agent-ready` e move o card para Especificado. Lê `specs/constitution.md` do repositório quando existe. Não escreve código.

| Componente | Função |
|---|---|
| Skill [`read-story-card`](skills/trello/read-story-card) | Lê o card de negócio e verifica a completude. |
| Skill [`write-spec`](agents/agente-especificacao/.claude/skills/write-spec) | Gera e refina a spec funcional (o quê e por quê). |
| Skill [`write-plan`](agents/agente-especificacao/.claude/skills/write-plan) | Gera e refina o plano técnico. |
| Skill [`write-tasks`](agents/agente-especificacao/.claude/skills/write-tasks) | Quebra o plano em tarefas do tamanho de um PR. |
| Skill [`generate-spec-artifacts`](agents/agente-especificacao/.claude/skills/generate-spec-artifacts) | Confere a consistência e grava `spec.md`, `plan.md` e `tasks.md`. |
| Skill [`update-trello-card`](skills/trello/update-trello-card) | Aplica a label no card, com preview e autorização. |
| Skill [`move-trello-card`](skills/trello/move-trello-card) | Move o card para a lista Especificado, com preview e autorização. |
| Skills [`comment-trello-card`](skills/trello/comment-trello-card) e [`open-pull-request`](skills/git/open-pull-request) | Compartilhadas com o agente de desenvolvimento. |
| Subagent [`context-explorer`](agents/agente-especificacao/.claude/agents/context-explorer.md) | Lê o código e resume padrões e convenções (somente leitura). |

### [agente-desenvolvimento](agents/agente-desenvolvimento)

Só codifica. Recebe o link de um card com a label `agent-ready`, lê `specs/<card-id>-<slug>/` já aprovada e mergeada, e implementa uma tarefa por vez com TDD: testes antes do código, loop de build, teste, lint e format, revisão do diff e PR. Move o card para Em andamento e Em review.

| Componente | Função |
|---|---|
| Skill [`read-trello-card`](skills/trello/read-trello-card) | Lê o card e verifica a completude da especificação. |
| Skill [`open-pull-request`](skills/git/open-pull-request) | Cria a branch, faz o commit e abre o PR em padrão fixo, após autorização. |
| Skill [`comment-trello-card`](skills/trello/comment-trello-card) | Comenta no card, com preview e autorização. |
| Skill [`move-trello-card`](skills/trello/move-trello-card) | Move o card entre as listas do board. |
| Subagent [`code-explorer`](agents/agente-desenvolvimento/.claude/agents/code-explorer.md) | Lê o código de referência e resume padrões e convenções (somente leitura). |
| Subagent [`test-writer`](agents/agente-desenvolvimento/.claude/agents/test-writer.md) | Escreve os testes a partir dos critérios de aceite, antes do código. |
| Subagent [`dotnet-implementer`](agents/agente-desenvolvimento/.claude/agents/dotnet-implementer.md) | Implementa a story em C#/.NET nos arquivos autorizados. |
| Subagent [`reviewer`](agents/agente-desenvolvimento/.claude/agents/reviewer.md) | Revisa o diff contra a spec e devolve APROVADO ou REPROVADO. |

### [agente-revisao](agents/agente-revisao)

Revisa um PR aberto em 6 etapas: lê o PR e a spec, dispara 4 revisores em paralelo (qualidade, performance, testes e segurança), consolida e, com a sua aprovação dos comentários, publica a review como `COMMENT`. Você revisa por conta própria, sem depender do resultado do agente. Não altera código, não aprova e não faz merge.

| Componente | Função |
|---|---|
| Skill [`read-pull-request`](skills/git/read-pull-request) | Lê o PR, somente leitura. |
| Skill [`post-review-comments`](skills/git/post-review-comments) | Publica a review, após autorização. |
| Subagents [`reviewer-quality`](agents/agente-revisao/.claude/agents/reviewer-quality.md), [`reviewer-performance`](agents/agente-revisao/.claude/agents/reviewer-performance.md), [`reviewer-tests`](agents/agente-revisao/.claude/agents/reviewer-tests.md), [`reviewer-security`](agents/agente-revisao/.claude/agents/reviewer-security.md) | Revisores somente leitura, com saída em formato fixo. |

### [agente-resposta-revisao](agents/agente-resposta-revisao)

Ajuda o autor a responder às revisões do próprio PR: triagem de cada comentário (concordar, contestar ou perguntar, quem decide é você), correção só do que foi concordado com verificação, commit, push com autorização e respostas nas threads. Não resolve threads, não faz force-push nem merge.

| Componente | Função |
|---|---|
| Skill [`read-review-comments`](skills/git/read-review-comments) | Lê as threads de review. |
| Skill [`reply-review-comment`](skills/git/reply-review-comment) | Responde nas threads, após autorização. |
| Subagent [`comment-triager`](agents/agente-resposta-revisao/.claude/agents/comment-triager.md) | Avalia cada comentário contra o código e a spec (somente leitura). |
| Subagent [`fix-implementer`](agents/agente-resposta-revisao/.claude/agents/fix-implementer.md) | Corrige só os arquivos dos comentários aceitos. |
| Subagent [`test-writer`](agents/agente-resposta-revisao/.claude/agents/test-writer.md) | Escreve testes quando a correção pedir. |

## Modelos para o repositório-alvo

Em [`templates/`](templates): `CLAUDE.md` global e de projeto, `specs/constitution.md`, `.claude/settings.json` com permissões e hooks, workflow de CI, template de PR e `.gitignore` dos agentes. Veja o [`templates/README.md`](templates/README.md).

## Instalação

```bash
./install.sh     # cria links das skills de skills/engineering, git, meta-skills, net e trello em ~/.codex, ~/.copilot e ~/.claude
./uninstall.sh   # remove os links
```

Só os diretórios que já existem em `$HOME` são usados. Destinos existentes que não sejam links simbólicos são ignorados.
