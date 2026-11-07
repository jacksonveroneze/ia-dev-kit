# Relatório: root-cause-debugging

Formato fixo.

```
Sintoma: <esperado | observado | quando>
Reprodução: <por leitura | comando informado e autorizado: saída resumida> | Reproduzido: <sim | não | parcial>

Hipóteses:
| # | Hipótese | Resultado | Evidência |
|---|---|---|---|
| 1 | <texto> | <confirmada | descartada | não confirmada> | <arquivo:linha ou trecho de log> |

Causa raiz: <texto | causa não encontrada - o que falta>
Evidência: <arquivo:linha, ...>
Correção sugerida (não aplicada): <descrição da mudança e onde>
Teste que protegeria: <cenário, entrada e resultado esperado; falha hoje e passa com a correção>
Riscos da correção: <lista | nenhum identificado>
Pendências: <lista | nenhuma>
```

## Ao parar
Sintoma ou repositório ausente ou inválido: uma linha com o que faltou e onde era esperado. Nada foi lido nem escrito.
