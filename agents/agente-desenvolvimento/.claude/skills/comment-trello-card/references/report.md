# Relatório: comment-trello-card

Formato fixo, por parte.

## Parte A - Preview
```
Card: <título> | Link: <link>
Duplicado: <nenhum | comentário idêntico existente>
Dados protegidos: <nenhum encontrado | encontrado: corrija o texto>

Texto do comentário:
<texto exato>

Confirma a publicação deste comentário neste card?
```

## Parte B - Relatório final
```
Comentário publicado: <sim | não>
Card: <título> | Link: <link>
Conferência: <texto idêntico ao preview | divergência: ...>
```

## Em caso de falha
```
Não publicado.
Erro: <mensagem do conector>
Como proceder? (não tento de novo sem perguntar)
```

## Ao parar
Input ausente ou sem autorização: uma linha com o que faltou e onde era esperado (card, texto ou autorização); nada foi lido nem escrito.
