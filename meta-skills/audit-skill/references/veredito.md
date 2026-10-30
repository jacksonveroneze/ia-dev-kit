# Veredito, severidade e classificação de falhas

Específico da auditoria. A régua (itens M e J) está em `../../_shared/regua.md`.

## Severidade
- **Alta:** qualquer item M; J-02; J-03; J-14. Reprova.
- **Média:** J-01, J-04, J-08, J-09, J-11, J-12. Ressalva; reprova se recorrente.
- **Baixa:** J-05, J-06, J-07, J-10, J-13. Ressalva.

## Veredito
- **APROVADA:** todos os itens M e J passam, sem lacuna.
- **APROVADA COM RESSALVAS:** itens M passam, mas há falha J de severidade baixa ou média, ou observação relevante.
- **REPROVADA:** qualquer falha de severidade alta, ou falha média recorrente.

## Classificação de falhas (uma origem por falha)
- **Desvio mecânico:** M falhou. Pede ajuste de arquivo.
- **Desvio de julgamento:** J falhou. Pede ajuste de texto; cite o trecho.
- **Lacuna da skill:** o texto permite mais de uma leitura ou não cobre o caso.
- **Observação:** variação legítima de stack ou item fora do contrato; não conta como falha.
- **Ambiente:** falha alheia à skill (ferramenta, build quebrado).

## Veredito da execução (modo completo)
- Passam todos os critérios em todas as execuções e nenhuma lacuna varia: sem ressalva.
- Critérios passam mas há decisão solta ou item fora do contrato: ressalva.
- Falha de origem skill ou convenções, ou falha de Estrutura ou Harness em uma execução: reprova.
