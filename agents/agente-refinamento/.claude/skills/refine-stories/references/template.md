# Template canônico

Molde de cada story e do epic. Em conflito com os Exemplos, o Template vence.

```
EPIC: <nome> - <objetivo em 1 frase>

### Story 1 - <título>
**Tipo:** código | sem código
**História:** Como <persona>, quero <ação>, para <benefício>.
**Ordem de execução:** 1º | **Depende de:** nenhuma
**Estimativa:** <pontos | a definir> | **Prioridade:** Alta/Média/Baixa
**Dev sugerido:** <nome - skill que justifica | a definir>
**Critérios de aceite:**
- Critério 1: Dado <contexto>, quando <ação>, então <resultado verificável>.
- Critério 2: ...
**Subtasks:**
- [ ] <ação técnica concreta>
**Especificação técnica:** (só para código)
- Repositório e branch base: <valor (fonte) | a definir>
- Referência de implementação: <arquivo:linha (fonte) | a definir>
- Contrato: entrada <campos e tipos>; saída <campos e tipos, escritos aqui>; erros <código ou mensagem por caso>
- Regras de negócio e validações: <lista (fonte) | a definir>
- Arquivos a criar ou alterar: <caminho - motivo | (proposto, confirmar) | a definir>
- Testes: <casos a cobrir | sem testes por decisão do usuário (risco: critérios sem verificação automática)>
- Comandos: build <comando | a definir>; teste <comando | nenhum informado>; lint <comando | nenhum informado>
- Restrições: <padrões e proibições do projeto | nenhuma informada>; Siga: <guia ou skill do repositório (arquivo:linha) | nenhum informado>
- Fora de escopo desta story: <lista>
- Se faltar informação: pare e comente no card; não deduza.
**Prontidão para codificar:** pronta | precisa de humano: <o que falta> | não se aplica
```
Placeholders recebem o conteúdo real; nunca copie literalmente. Termine a proposta com a sequência em uma linha: `Story 1 -> Story 2 -> (Story 3 e Story 4 em paralelo)`.
