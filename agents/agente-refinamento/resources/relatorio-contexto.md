# Relatório de contexto (Fase 2, só a pedido)

Formato fixo do relatório que o orquestrador monta na Fase 2, quando o usuário pede para consultar o GitHub, a partir do que a skill `read-github` devolveu. Serve só para o usuário decidir; a fonte (`arquivo:linha`) fica aqui e não vai para as stories. Seção sem conteúdo recebe `Nenhum`.

## Como consolidar
- **Regra atual** vem só do que o código faz, com `arquivo:linha` (CONV-011).
- **Riscos** vêm do que o código faz e de divergências com o pedido.
- **Sugestões de evolução** nascem de um achado com fonte, nunca de suposição, e ficam separadas da regra atual (CONV-013). Nascem como `pendente`; só o usuário muda o status.
- **Lacunas** reúnem o que falhou, veio vazio ou tem amostra pequena. Nunca se preenche (CONV-014).
- Dado pessoal, segredo e log bruto não entram (CONV-012).

## Formato

```
Contexto: <API> | Fonte: GitHub | Pergunta: <1 frase>

## Regra atual
| Regra | Fonte |
|---|---|
| <regra em 1 frase> | `caminho/arquivo:linha` |

## Riscos
- <risco> (fonte)

## Sugestões de evolução
| N | Sugestão | Motivo (fonte) | Status |
|---|---|---|---|
| 1 | <mudança> | <achado com fonte> | pendente |

## Lacunas
- <o que não foi encontrado ou falhou>
```

Sem consulta pedida pelo usuário, não há relatório.

## Exemplo

Correto: toda linha com fonte, sugestão separada e pendente.
Errado: sugestão dentro da tabela de regra atual; regra sem `arquivo:linha`; regra preenchida "pelo que costuma ser" quando o GitHub falhou (o correto é `Nenhum` e uma linha em Lacunas).
