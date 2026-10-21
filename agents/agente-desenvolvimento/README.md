# Agente de Desenvolvimento (v1)

Recebe o link de um card do Trello e implementa a story: lê a spec, planeja, escreve testes e código, revisa o diff e abre o PR. Roda no Claude Code. Complementa o agente de refinamento, que gera cards com a label `agent-ready`.

## Fluxo

| Etapa | O que acontece | Usa | Gate |
|---|---|---|---|
| 1 Leitura | Lê o card e confere se a story está elegível | `read-trello-card` | nenhum |
| 2 Plano | Lê a referência e propõe o plano | `code-explorer` | APROVAR PLANO |
| 3 Testes e código | Testes pelos critérios, depois código; roda build, teste e lint (3 tentativas) | `test-writer`, `dotnet-implementer` | nenhum |
| 4 Revisão | Confere o diff com a spec (2 ciclos) | `reviewer` | nenhum |
| 5 Entrega | Preview do PR e do comentário no card | `open-pull-request`, `comment-trello-card` | APROVAR PR |

Story elegível: label `agent-ready`, `Tipo: código`, prontidão `pronta` e nenhum item `a definir` ou `(proposto, confirmar)`. O agente nunca deduz o que o card não traz: para e oferece comentar no card (COMENTAR).

## Como usar

1. Abra o Claude Code na **raiz do repositório do card**, limpo e na branch base do card.
2. Disponibilize este agente nesse repositório: copie (ou aponte por link simbólico) `.claude/agents/` e `.claude/skills/`, e importe `AGENTS.md` no `CLAUDE.md` do repositório (`@caminho/AGENTS.md`). Mantenha `resources/` ao lado do `AGENTS.md`.
3. Conecte por MCP o Trello e deixe a CLI `gh` autenticada.
4. Diga: `Implementa este card: <link>`.
5. Responda os gates: APROVAR PLANO, depois APROVAR PR.

## Estrutura

```
AGENTS.md          orquestrador: etapas, gates, ligação entre subagents e skills
CLAUDE.md          aponta para AGENTS.md
resources/         convencoes.md, ajuda.md
evals/casos.md     casos de teste
.claude/agents/    code-explorer, test-writer, dotnet-implementer, reviewer
.claude/skills/    read-trello-card, open-pull-request, comment-trello-card
                   (cada uma: SKILL.md e references/examples.md, references/report.md)
```

Skill é capacidade e funciona sozinha; o processo mora só no `AGENTS.md`. Novas stacks entram como outro implementer (por exemplo `frontend-implementer`), sem mudar o resto.

## Antes de usar em produção

- Restrinja `tools` dos agents às ferramentas de leitura e escrita necessárias; o `reviewer` e o `code-explorer` são somente leitura.
- Proteja `main` e `develop` no GitHub (branch protection): o agente não faz merge, mas a regra no servidor é a garantia.
- Rode `evals/casos.md`, em especial os casos 3, 5, 7, 17 e 18.
- Comece por uma story pequena e acompanhe os gates.
