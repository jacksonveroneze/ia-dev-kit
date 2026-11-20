# Subagents agnósticos

Subagents que rodam sem nenhum agente orquestrador: não leem estado, não esperam gate e não dependem de arquivo de um agente. Quem chama (você, outra sessão ou um orquestrador) passa a entrada no pedido e recebe o relatório em formato fixo. O `./install.sh` linka cada um em `~/.claude/agents`.

Subagents que dependem do fluxo de um agente (spec, plano, tarefas, triagem) ficam em `agents/<agente>/.claude/agents/`.

| Subagent | Pasta | O que faz | Entrada mínima |
|---|---|---|---|
| [`reviewer-quality`](review/reviewer-quality.md) | `review/` | Clean Architecture, DDD, legibilidade e convenções do repositório | diff e lista de arquivos alterados |
| [`reviewer-performance`](review/reviewer-performance.md) | `review/` | EF Core e N+1, async/await, alocações e IO | diff e lista de arquivos alterados |
| [`reviewer-tests`](review/reviewer-tests.md) | `review/` | Cobertura, cenários, fragilidade, xUnit, Moq e Shouldly | diff e lista de arquivos alterados |
| [`reviewer-security`](review/reviewer-security.md) | `review/` | Segredos, dados pessoais, validação, autorização, injeção e dependências | diff e lista de arquivos alterados |
| [`github-researcher`](research/github-researcher.md) | `research/` | Explica como uma regra funciona hoje em um repositório, com `arquivo:linha` (usa a skill `read-github`) | `org/repo` e a pergunta |

## Como chamar sozinho

```
Use o reviewer-security neste diff: <diff ou caminho> (arquivos: ...). Spec: specs/123-x/spec.md (opcional).
Use o github-researcher em acme/pagamentos: onde se valida o limite de transferência?
```

Spec, plano, tarefas, guias do repositório e resultado do CI são opcionais nos revisores; sem spec, os achados saem sem referência a `RF`/`CA`.

## Requisitos e limites
- Os revisores só têm `Read`, `Grep` e `Glob`: não obtêm o diff sozinhos. Quem chama o fornece e o checkout local deve estar no head do PR.
- Os revisores assumem a stack do kit (.NET, EF Core, xUnit, Moq, Shouldly, Clean Architecture).
- O `github-researcher` também tem só `Read`, `Grep` e `Glob`. Para ler um repositório remoto, acrescente em `tools` as ferramentas do seu conector de GitHub ou o `Bash` para `gh`; a skill `read-github` precisa estar instalada.

## Incluir um subagent
Crie `<tema>/<nome>.md` seguindo o molde de [`skills/meta-skills/_shared/subagent.md`](../../skills/meta-skills/_shared/subagent.md) (entrada, permissões, saída em formato fixo, o que não faz e checklist), confira a forma e rode `./install.sh`:

```bash
skills/meta-skills/_shared/check-subagents.sh [arquivo.md ...]   # sem argumento, confere todos os subagents do kit
```

Só entra aqui o que roda sem agente: se precisa de arquivo ou estado de um fluxo, fica no agente dele. O script confere a forma (itens S-01 a S-12); os itens de julgamento (J-01 a J-07) são conferidos por quem cria ou revisa.
