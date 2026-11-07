# Relatório: create-trello-card

Formato fixo, por parte.

## Parte A - Preview
```
Board: <board> | Lista de destino: <lista>
Duplicados: <nenhum | card X: pular, atualizar ou criar>

| Ordem | Título do card | Dev | Pontos | Subtasks | Depende de | Fora de escopo |
|---|---|---|---|---|---|---|
| 1 | [Story 1] <título> | <dev> | <pontos> | <N> | <nenhuma, Story X ou link do card externo> | preenchido |

Confirma a criação destes cards na lista <lista>?
```

## Parte B - Relatório final
```
Cards criados: <N de M>

| Ordem | Card | Link | Depende de (link gravado) |
|---|---|---|---|
| 1 | [Story 1] <título> | <link> | <nenhuma ou link> |

Divergências da verificação: <nenhuma | lista>
Pendências: <nenhuma | por exemplo, dev sem responsável>
```

## Em caso de falha
```
Criados: <lista com link>
Não criados: <lista>
Erro: <mensagem do conector>
Como proceder? (não recrio o que já existe)
```

## Ao parar (input ausente ou sem confirmação)
Uma linha: o que faltou e onde era esperado (stories, Fora de escopo, link de dependência fora da lista, ordem de dependência, board, lista ou confirmação). Nada foi lido nem escrito.
