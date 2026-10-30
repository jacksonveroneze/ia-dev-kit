# Anatomia da skill (fonte única)

Compartilhado pelas meta-skills (cada uma aplica a parte que lhe cabe). Texto puro.
Mudou a anatomia: mude só aqui.

## Arquivos de toda skill
- `SKILL.md`: corpo com até 150 linhas.
- `references/report.md`: formato do relatório da skill (obrigatório; modelo em `modelo-report.md`).
- `references/examples.md`: exemplos certo e errado da skill (obrigatório).
- Opcionais: `references/template.md` (ver abaixo), `references/stack-{nome}.md` (convenções de uma stack), `scripts/`, `assets/`.

`references/template.md`: o Template canônico com mais de uns 25 linhas vai para este arquivo. A seção
`## Template canônico` fica no corpo com o ponteiro, a instrução de ler antes de escrever e a regra de
precedência sobre os Exemplos; o Fluxo cita o arquivo no passo de escrever.

## Pastas (só estas três)
- `references/`: documentação que o agente **lê** sob demanda e carrega no contexto (exemplos, relatório, convenções). O corpo diz quando ler cada arquivo.
- `assets/`: arquivos usados **na saída**, copiados ou preenchidos sem virar instrução (templates, `.editorconfig`, imagens).
- `scripts/`: código que o agente **executa**.
- `resources/` e outros nomes não são usados. Critério: lido pelo agente é `references/`; copiado para a saída é `assets/`; executado é `scripts/`.

## Estrutura do `SKILL.md` (ordem fixa, sem reordenar)
Seção que não se aplica fica no lugar com `N/A - motivo`.

```
---
name: {kebab-case, igual à pasta, até 64 caracteres}
description: '{o quê e quando, sem o como; até 1024 caracteres; sem dois-pontos e sem sinais de maior ou menor}'
---
# {Título}                          (propósito e distância que cobre)
## O que gera
## Escopo (quando usar / NÃO usar)
## Contrato
### Rules                           (locais da skill; depois as gerais do projeto)
### Pré-condições
### Inputs                          (todos obrigatórios; o que é inválido)
## Fluxo (ReAct)                    (passo 1: validar inputs, parar e listar o que falta)
## Raciocínio antes de agir (CoT)   (2 a 4 perguntas verificáveis)
## Template canônico                (saída com {Placeholders})
## Exemplos                         (aponta para references/examples.md)
## Anti-patterns (recusar)
## Checklist + Harness
## Relatório                        (aponta para references/report.md)
```

## Técnica de cada seção

| Seção | Técnica | Conteúdo |
|---|---|---|
| Frontmatter | Gatilho | `name` e `description`, sem o como |
| Título e propósito | Contexto mínimo | A distância que a skill cobre |
| O que gera | Saída explícita | Arquivos, caminhos e nomes |
| Escopo | Restrição negativa | Quando usar e quando NÃO usar, sem nomear outras skills |
| Contrato: Rules | Grounding | Locais da skill, depois as gerais do projeto |
| Contrato: Pré-condições | Fail-fast | O que precisa existir antes |
| Contrato: Inputs | Fail-fast | Todos obrigatórios; o que é inválido |
| Fluxo (ReAct) | Fases | Passo 1 valida inputs; depois declarar, agir, verificar |
| Raciocínio (CoT) | CoT guiado | De 2 a 4 perguntas verificáveis |
| Template canônico | Saída estruturada | Saída com `{Placeholders}`, nunca copiada literalmente |
| Exemplos | Few-shot | Aponta para `references/examples.md` |
| Anti-patterns | Restrição negativa | Cada item com a alternativa |
| Checklist + Harness | Autoverificação | Checklist manual e gate executável |
| Relatório | Saída estruturada | Aponta para `references/report.md` |

Por que esta ordem: contrato antes de exemplo; certo antes de errado; gate e relatório por último
(recência); ReAct no fluxo externo, CoT dentro do passo de agir; referência pesada em `references/`.

## Teste da distância
O agente teria produzido isso sem a skill? Se sim, a skill não deve existir: ocupa contexto sem cobrir
distância nenhuma. Skill de boas práticas genéricas reprova no teste.

## Frontmatter
- `name`: kebab-case, igual ao nome da pasta, até 64 caracteres.
- `description`: é o gatilho, não documentação. Diga o quê e quando; mantenha os traços que discriminam
  o disparo, os sinônimos do artefato e o "quando NÃO usar" (o que fica de fora, sem nomear outra skill). Corte detalhe de
  implementação. Até 1024 caracteres, sem dois-pontos e sem sinais de maior ou menor.

## Tipos de skill
Os headings não mudam; muda o conteúdo.
- Gerador: o Template canônico é o artefato produzido.
- Transformador: o Template vira o mapa de alterações (arquivo, antes e depois); vale gate de confirmação.
- Auditor: o Template vira o formato da saída; o Checklist vira a régua.
- Com fases (máquina de estados): estados, transições e gates em `references/fluxo.md`; o Fluxo no corpo resume as fases e nenhum gate de escrita é dispensado; as demais seções não mudam.

## Tamanho e divulgação progressiva
Corpo com até 150 linhas. Exemplos, relatório e convenções de stack ficam em `references/`; arquivos de
saída em `assets/`; código em `scripts/`. Todos citados no corpo com a instrução de quando usar.

## Adaptadores de stack
Convenções específicas de uma stack (catálogo de regras, comandos de build, régua de verificação) ficam
em `references/stack-{nome}.md`. O núcleo da skill permanece agnóstico.
