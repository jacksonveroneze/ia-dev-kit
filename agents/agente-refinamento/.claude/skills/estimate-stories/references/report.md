# Relatório: estimate-stories

Formato fixo. Seção sem conteúdo recebe `Nenhum`.

```
## Estimativa
| Story | Pontos | Dev sugerido | Skill que justifica | Horas | Obs |
|---|---|---|---|---|---|
| Story 1 | <pontos> | <dev> | <skill> | <horas ou (suposição)> | <risco que subiu a faixa, se houver> |

## Carga por dev
| Dev | Stories | Pontos | Capacidade |
|---|---|---|---|
| <dev> | <N> | <pontos> | <capacidade ou não informada> |

ALERTA DE CARGA: <dev> com N stories          (um por dev com 2 ou mais stories)
ALERTA DE CAPACIDADE: <dev> com X pontos, capacidade Y
DIVIDIR: Story N passa de 8 pontos (<motivo>)

## Suposições
- <célula vazia de horas usada>
```

## Ao parar
Input ausente ou inválido (sem stories, sem critério de aceite, tabela sem nenhum dev): uma linha com o que faltou e onde era esperado; nada foi estimado.
