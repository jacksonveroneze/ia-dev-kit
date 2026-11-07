# Relatório: update-trello-card

Formato fixo, por parte.

## Parte A - Preview
```
Card: <título> | Link: <link>
Labels atuais: <lista | nenhuma>
Label a aplicar: <nome> | Existe no board: <sim | não>
Já aplicada: <sim | não>

Confirma aplicar esta label neste card?
```

## Parte B - Relatório final
```
Label aplicada: <sim | não>
Card: <título> | Link: <link>
Conferência: <label presente e demais labels mantidas | divergência: ...>
```

## Em caso de falha
```
Não aplicada.
Erro: <mensagem do conector>
Como proceder? (não tento de novo sem perguntar)
```

## Ao parar
Input ausente, label inexistente ou sem autorização: uma linha com o que faltou; nada foi escrito.
