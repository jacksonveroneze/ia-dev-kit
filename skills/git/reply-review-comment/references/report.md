# Relatório: reply-review-comment

Formato fixo, por parte.

## Parte A - Preview
```
PR: <org/repo>#<n> | Estado: <aberto> | Autenticado como: <login>

| # | Thread | Local | Comentário original (trecho) | Resposta a publicar | Ação |
|---|---|---|---|---|---|
| 1 | <id> | <arquivo:linha> | <primeiros 120 caracteres> | <texto literal> | <responder | responder e resolver> |

Verificações: <texto sem segredo nem dado pessoal | thread X: motivo>
Já publicadas: <nenhuma | threads>
Autorização esperada: <resposta do usuário | autorização prévia citada por quem chama>

Confirma a publicação destas <n> respostas neste PR? <Resolver: nenhuma thread | threads listadas>
```

## Parte B - Relatório final
```
| # | Thread | Resultado | Link |
|---|---|---|---|
| 1 | <id> | <publicada | publicada e resolvida | já publicada> | <url do comentário> |
Conferência: <última resposta de cada thread igual ao texto enviado | divergência: ...>
Autorização: <frase do usuário | autorização prévia citada>
```

## Em caso de falha
```
Publicado: <lista de threads>
Não publicado: <lista de threads>
Erro: <mensagem>
Como proceder? (não repito o que já existe)
```

## Ao parar
Input ausente ou sem autorização: uma linha com o que faltou e onde era esperado (PR, thread, texto ou autorização); nada foi escrito.
