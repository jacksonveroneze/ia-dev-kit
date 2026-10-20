# Relatório de contexto (Fase 2)

Formato fixo do relatório que o orquestrador monta na Fase 2, a partir do que as skills de leitura devolveram. Seção sem conteúdo recebe `Nenhum`.

## Como consolidar
- **Regra atual** vem só do que o código faz, com `arquivo:linha` (CONV-011).
- **Produção** vem só dos indicadores, com valor, janela e link (CONV-011).
- **Riscos** juntam os riscos de cada fonte. Divergência entre código e produção também é risco.
- **Sugestões de evolução** nascem de um achado com fonte, nunca de suposição, e ficam separadas da regra atual (CONV-013). Nascem como `pendente`; só o usuário muda o status.
- **Lacunas** reúnem o que falhou, veio vazio ou tem amostra pequena. Nunca se preenche (CONV-014).
- Dado pessoal, segredo e log bruto não entram (CONV-012).

## Formato

```
Contexto: <API> | Fontes: <GitHub, Datadog> | Pergunta: <1 frase>

## Regra atual
| Regra | Fonte |
|---|---|
| <regra em 1 frase> | `caminho/arquivo:linha` |

## Produção
| Indicador | Valor | Janela | Link |
|---|---|---|---|
| <indicador> | <valor> | <janela> | <link> |

## Riscos
- <risco> (fonte)

## Sugestões de evolução
| N | Sugestão | Motivo (fonte) | Status |
|---|---|---|---|
| 1 | <mudança> | <achado com fonte> | pendente |

## Lacunas
- <o que não foi encontrado ou falhou>
```

Sem contexto solicitado, o relatório inteiro é: `Contexto: não solicitado`.

## Exemplo

Correto: toda linha com fonte, janela nos indicadores, sugestão separada e pendente.
Errado: sugestão dentro da tabela de regra atual; indicador sem janela; Produção preenchida "pelo que costuma ser" quando o Datadog falhou (o correto é `Nenhum` e uma linha em Lacunas).
