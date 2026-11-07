# Template canônico

Molde de cada story e do epic. Em conflito com os Exemplos, o Template vence.

```
EPIC: <nome> - <objetivo em 1 frase>

### Story 1 - <título>
**História:** Como <persona>, quero <ação>, para <benefício>.
**Ordem de execução:** 1º | **Depende de:** nenhuma
**Estimativa:** <pontos | a definir> | **Prioridade:** Alta/Média/Baixa
**Dev sugerido:** <nome - skill que justifica | a definir>
**Critérios de aceite:**
- Critério 1: Dado <contexto>, quando <ação>, então <resultado verificável do ponto de vista de quem usa>.
- Critério 2: ...
**Subtasks:**
- [ ] <ação de alto nível, sem detalhe técnico>
**Fora de escopo:** <lista | a definir>
```
`Fora de escopo` aparece em toda story: use o fora de escopo informado que se aplica a ela; se nada foi informado para a story, `a definir` (nunca invente nem escreva "nada fora de escopo" por dedução). `Depende de` cita a story pelo número e diz em palavras o que ela entrega.
Placeholders recebem o conteúdo real; nunca copie literalmente. Termine a proposta com a sequência em uma linha: `Story 1 -> Story 2 -> (Story 3 e Story 4 em paralelo)`.
