# Relatório: safe-rollout

Formato fixo. Apresentado ao concluir; uma linha por campo.

```
## Rollout e rollback
Mudança: <resumo em 1 linha> | Afeta: <quem e o quê>
Evidência lida: <arquivo:linha, ...>

Decisão de flag: <sim | não> - <porquê em 1 frase>
Nome da flag: <nome | não se aplica | a definir>
Mecanismo: <o que o projeto já usa, com arquivo:linha | a definir>

Estados:
| Estado | Comportamento | Quando |
|---|---|---|
| Desligada | código antigo | <padrão inicial> |
| Parcial | <critério de quem recebe o novo> | <a definir | dado informado> |
| Ligada | código novo para todos | <condição> |

Depreciação do código antigo: <o que marcar, onde (arquivo:linha) e aviso a consumidores | a definir>
Critério de rollback: <sinal observável e limite | a definir> | Como reverter: <ação> | Perde dado ou contrato: <não | sim - compatibilidade>
Passos de remoção:
1. <passo, com condição de saída>
Riscos: <lista | nenhum identificado>
A definir: <lista do que faltou e quem informa | nenhum>
```

## Ao parar
Descrição da mudança ou repositório ausente ou inválido: uma linha com o que faltou e onde era esperado. Nada foi lido nem escrito.
