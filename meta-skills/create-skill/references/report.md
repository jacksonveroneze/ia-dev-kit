# Relatório (formato)

Dois relatórios, ambos em tabelas, texto puro: o **plano da skill**, apresentado na Fase 2 antes de qualquer escrita, e o **relatório final**, apresentado ao concluir ou ao parar.

## Plano da skill (antes do APROVADO)

| Item | Valor |
|---|---|
| Skill | `{skills-dir}/{name}/` |
| Tipo | gerador, transformador ou auditor |
| Gatilho | quando dispara e quando não dispara |
| Inputs da skill | cada input com o formato |
| Saída esperada | artefatos, caminhos e convenções de nome |
| Arquivos a criar | `SKILL.md`, `references/report.md`, `references/examples.md` e os demais |
| Seções N/A | `{lista}` ou "nenhuma", com o motivo de cada |
| Decisão | skill ou rule, com a justificativa em uma frase |
| Verificação | comandos do Harness, ou "nenhum" com o motivo |

Termine com: "Responda `APROVADO` para criar a skill, ou diga o que ajustar." Não escreva nada enquanto não houver resposta.

## Relatório final

| Item | Resultado |
|---|---|
| Skill | `{skills-dir}/{name}/SKILL.md` com `{N}` linhas |
| Referências | `references/report.md`, `references/examples.md` e demais arquivos criados |
| Seções N/A | `{lista}` ou "nenhuma", com o motivo de cada |
| Decisão | skill ou rule, com a justificativa em uma frase |
| Harness | comandos executados e resultado, ou "Harness incompleto" e o motivo |

## Ao parar
Troque a tabela por uma linha: o que faltou (input ausente ou inválido, fonte inexistente, skill já existente, contexto compactado, rule no lugar de skill) e onde era esperado. Nada foi escrito.

O `references/report.md` das skills criadas segue o modelo de `../../_shared/modelo-report.md`.
