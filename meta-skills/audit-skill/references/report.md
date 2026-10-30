# Relatório (formato)

Apresentado ao concluir ou ao parar. Texto puro, sem emoji. Use PASSOU, FALHOU, FORA DO CONTRATO e NAO VERIFICADO.

```
# Auditoria: {skill} - {data}
Modo: {estatico|completo}   Padrão: {caminho de _shared}   Executor: {subagente|inline|n/a}

## Veredito
{APROVADA | APROVADA COM RESSALVAS | REPROVADA} - {uma frase}

## Régua mecânica
| ID | Critério | Resultado | Comando e saída |
|---|---|---|---|

## Régua de julgamento
| ID | Critério | Resultado | Trecho citado |
|---|---|---|---|

## Falhas
| # | Item | Origem | Severidade | Evidência | Ajuste proposto |
|---|---|---|---|---|---|

## Observações
- {variação legítima ou item fora do contrato}

## Execução (somente modo completo)
Tarefa: {tarefa}   Estado inicial: {estado}   N: {N}

| Critério | Grupo | Tipo | Exec 1 | Exec 2 | Exec 3 |
|---|---|---|---|---|---|

Decisões sem respaldo na skill e lacunas (decisões que variaram):
- {decisão}: {como variou} -> {texto sugerido para a skill}

Harness rodado pelo avaliador:
| Execução | Comando | Resultado |
|---|---|---|

## Ajustes recomendados
1. {arquivo}: {mudança} (origem: desvio mecânico | desvio de julgamento | lacuna)
```

Ao parar, troque o relatório por uma linha: o que faltou (input ausente ou inválido, skill alvo
inexistente, arquivos de _shared não encontrados, harness incompleto) e onde era esperado. Nada foi auditado.
