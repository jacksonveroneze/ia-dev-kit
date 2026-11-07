# Agente de Refinamento Scrum (v5)

Conduz o refinamento de histórias em 4 fases e cria os cards no Trello. Só refina: as stories saem em linguagem de negócio, sem detalhe técnico de código (isso é feito em outro passo). Consulta ao GitHub opcional, só quando você pedir, para entender a regra atual. Roda no Claude Code e no GitHub Copilot.

## Fluxo

![Fluxo do agente](docs/fluxo.svg)

| Fase | O que acontece | Gate |
|---|---|---|
| 1 Entrada | Você informa objetivo, problema, persona, escopo, board e lista | AVANÇAR |
| 2 Refinamento | Gera stories, estima pontos e horas, sugere dev. Se você pedir, consulta o GitHub antes e você aceita ou recusa cada sugestão | AVANÇAR |
| 3 Revisão | Você ajusta stories, dev, pontos e ordem | AVANÇAR (CIENTE se houver carga) |
| 4 Publicação | Preview dos cards; só cria depois da sua aprovação | APROVADO |

O agente nunca deduz dado que você não informou. Em qualquer fase, diga **ajuda**.

## O que o card tem

História, critérios de aceite Dado/Quando/Então, subtasks de alto nível, dependência, estimativa e dev sugerido. Não leva arquivo, contrato, comando nem label de prontidão para codificar (CONV-017).

## Como usar

1. Preencha `dados/time.md` (capacidade e horas) e `dados/fontes.md` (API e repositório, só se for consultar o GitHub).
2. Conecte por MCP: Trello (obrigatório) e GitHub (opcional, só se for consultar código).
3. Abra a pasta na raiz no Claude Code e inicie a conversa.
4. Informe os campos da Fase 1 e responda cada gate (AVANÇAR, CIENTE, APROVADO).
5. Confira o resultado no board.

Entrada mínima:

```
Objetivo:
Problema:
Persona:
Escopo:
Fora de escopo:
Board:
Lista de destino:

Na Fase 2, só se quiser verificar código: API e a pergunta sobre a regra atual
```

## Estrutura

```
AGENTS.md          orquestrador: fases, gates, ligação entre skills
CLAUDE.md          aponta para AGENTS.md
resources/         convencoes.md, relatorio-contexto.md, ajuda.md
dados/             time.md, fontes.md
evals/casos.md     casos de teste
docs/fluxo.svg     diagrama do fluxo
.claude/skills/    read-github, estimate-stories, refine-stories, publish-trello (cada uma: SKILL.md e references/examples.md, references/report.md)
.claude/agents/    github-researcher
```

Skill é capacidade e funciona sozinha; o processo mora só no `AGENTS.md`.

## GitHub Copilot

- **VS Code:** lê `AGENTS.md` (habilite `chat.useAgentsMdFile`), `.claude/skills/` e `.claude/agents/`. Configure o MCP do Trello nele.
- **CLI:** copie os agents para `.github/agents/*.agent.md`. Sem a cópia, a consulta ao GitHub roda a skill na conversa.

## Testes

Rode `evals/casos.md` a cada mudança e a cada modelo. Críticos: 31 (não deduzir), 26 e 27 (confirmação antes de escrever), 36 e 37 (sem detalhe técnico).
