# Exemplos: estimate-stories

Valores fictícios. Nunca copie literalmente.

## Correto
3 stories; time informado: Ana (backend e banco), Beto (frontend); horas preenchidas só para Ana.

```
## Estimativa
| Story | Pontos | Dev sugerido | Skill que justifica | Horas | Obs |
|---|---|---|---|---|---|
| Story 1 | 3 | Ana | backend | 12 | |
| Story 2 | 5 | Ana | banco de dados | 20 | subiu de 3 para 5: risco de consulta lenta informado |
| Story 3 | 2 | Beto | frontend | (suposição) | horas do Beto não informadas |

## Carga por dev
| Dev | Stories | Pontos | Capacidade |
|---|---|---|---|
| Ana | 2 | 8 | 13 |
| Beto | 1 | 2 | 13 |

ALERTA DE CARGA: Ana com 2 stories

## Suposições
- Horas da Story 3 sem valor na tabela do time.
```
Por que está certo: horas vêm da tabela, célula vazia virou suposição, carga contada por dev, o risco justificou a faixa.

## Errado
- `Story 4 | 13 pontos`. Fora das faixas; deveria ser `DIVIDIR: Story 4 passa de 8 pontos`.
- `Story 3 | Carlos`. Dev que não está na tabela informada.
- `Story 3 | 2 pontos | 6 horas` com a tabela sem horas. Hora inventada, sem `(suposição)`.
- Ana com 2 stories e nenhum alerta.

## Troca de dev
Pedido: "Passa a Story 2 para o Beto."
- Correto: refazer horas com a coluna do Beto, recontar a carga de Ana e Beto, atualizar a skill que justifica (e avisar se não cobre o trabalho).
- Errado: trocar o nome e manter as horas e a carga antigas.

## Uso avulso, fora de qualquer fluxo
Pedido: "Estima estas 2 stories. Time: Ana (backend), Beto (frontend)." (sem capacidade nem horas)
- Correto: estimar pontos e dev; horas `(suposição)`; carga contada; capacidade registrada como não informada.
- Errado: pedir um arquivo de time, ou preencher horas "típicas".

## Tabela do time ausente
Pedido: "Estima estas stories." (sem informar o time)
- Correto: pedir a tabela do time. Não estimar.
- Errado: usar nomes de devs de outra conversa.
