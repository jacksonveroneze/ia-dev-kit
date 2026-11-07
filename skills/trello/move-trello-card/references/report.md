# Relatório: move-trello-card

Formato fixo, por parte.

## Parte A - Preview
```
Card: <título> | Link: <link>
Lista atual: <nome> | Lista de destino: <nome> | Existe no board: <sim | não | ambígua>
Posição no destino: <topo | fim | informada>
Já está no destino: <sim | não>

Confirma mover este card para esta lista?
```

## Parte B - Relatório final
```
Card movido: <sim | não>
Card: <título> | Link: <link>
De: <lista> | Para: <lista> | Posição: <topo | fim>
Conferência: <lista nova e resto do card inalterado | divergência: ...>
```

## Em caso de falha
```
Não movido.
Erro: <mensagem do conector>
Como proceder? (não tento de novo sem perguntar)
```

## Ao parar
Input ausente, lista inexistente ou ambígua (com as listas do board) ou sem autorização: uma linha com o que faltou; nada foi escrito.
