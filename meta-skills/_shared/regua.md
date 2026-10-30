# Régua de aderência (fonte única)

Critérios que uma skill deve cumprir. `create-skill` usa como checklist e harness da skill que escreve;
`audit-skill` usa como régua da skill que audita. Anatomia em `anatomia.md`; comportamento em
`comportamento.md`. Comandos rodam a partir do diretório da skill (`$S`).

## Itens mecânicos (M): verificáveis por comando

| ID | Critério | Comando de verificação |
|---|---|---|
| M-01 | `name` em kebab-case, igual à pasta, até 64 caracteres | `grep -m1 '^name:' $S/SKILL.md` e comparar com `basename $S` |
| M-02 | `description` até 1024 caracteres, sem dois-pontos e sem sinais de maior ou menor | extrair a linha e conferir tamanho e caracteres |
| M-03 | Headings `##` na ordem de `anatomia.md`; ausentes marcadas `N/A - motivo` | `grep -n '^##' $S/SKILL.md` |
| M-04 | Corpo com até 150 linhas | `wc -l $S/SKILL.md` |
| M-05 | Existem `references/report.md` e `references/examples.md` e o corpo os cita | `ls $S/references` e `grep -n 'references/' $S/SKILL.md` |
| M-06 | Sem emoji ou símbolo decorativo em nenhum arquivo da skill | `grep -rnP '[\x{2600}-\x{27BF}\x{1F300}-\x{1FAFF}]' $S` |
| M-07 | Sem nome de ferramenta de agente específico no corpo | `grep -nEi 'AskUserQuestion|Skill tool|ferramenta Skill|TodoWrite' $S/SKILL.md` |
| M-08 | Frontmatter presente e fechado, só com campos válidos | ler as primeiras linhas |

## Itens de julgamento (J): leitura do texto, com trecho citado

| ID | Critério | Falha típica |
|---|---|---|
| J-01 | Passa no teste da distância | boa prática genérica |
| J-02 | Gate de inputs: passo 1 do Fluxo valida, para e lista o que falta; nunca infere | "assuma valores razoáveis" |
| J-03 | Relatório: manda apresentar `references/report.md` ao concluir ou parar; o arquivo tem tabela e regra de parada | sem relatório ou sem regra de parada |
| J-04 | Toda negativa traz a alternativa | proibição isolada |
| J-05 | Declara a ausência: o que o artefato não faz e quem assume | escopo implícito |
| J-06 | Explica o porquê das restrições, citando a regra do projeto | "MUST" sem motivo |
| J-07 | CoT com 2 a 4 perguntas verificáveis | perguntas abertas ou ausentes |
| J-08 | Exemplos com certo e errado e um caso de pedido incompleto | só caminho feliz |
| J-09 | `description` é gatilho: o quê e quando, com "NÃO usar" e skill irmã, sem o como | descreve implementação |
| J-10 | Tom de desenvolvedor sênior (ver `comportamento.md`) | informal ou vago |
| J-11 | É procedimento (skill), não invariante permanente (rule) | "nunca X" como skill |
| J-12 | Harness executável, com regra para falha de ambiente | gate sem comando |
| J-13 | Template canônico coerente com Inputs e Exemplos | placeholder sem input |
