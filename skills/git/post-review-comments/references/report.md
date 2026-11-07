# Relatório: post-review-comments

Formato fixo, por parte.

## Parte A - Preview
```
PR: <org/repo>#<n> | Link: <url> | Estado: <aberto>
SHA do head: <informado> | SHA atual: <atual> | <igual | diferente: não publicar>
Evento da review: <COMMENT | APPROVE | REQUEST_CHANGES (pedido por escrito de quem chama)>
Duplicados: <nenhum | lista>
Dados protegidos: <nenhum encontrado | encontrado em C<n>: corrija o texto>

Texto geral da review:
<texto | nenhum>

Comentários (<n>):
| # | Local | Severidade | Situação | Texto |
|---|---|---|---|---|
| C1 | <arquivo>:<linha> | <BLOQUEANTE | IMPORTANTE | SUGESTAO> | <válido | linha fora do diff | arquivo fora do PR> | <texto exato, com *** onde mascarado> |
| C2 | geral | <severidade> | válido | <texto exato> |

Confirma a publicação desta review neste PR?
```

## Parte B - Relatório final
```
Review publicada: <sim | não>
PR: <org/repo>#<n> | Review: <id> | Link: <url>
Autorização: <resposta do usuário | autorização prévia citada>
Evento: <COMMENT | ...>
Conferência:
| # | Local | Resultado |
|---|---|---|
| C1 | <arquivo>:<linha> | <publicado com texto idêntico | divergência: ...> |
```

## Em caso de falha
```
Não publicado (ou publicado em parte: lista).
Erro: <mensagem do gh>
Como proceder? (não tento de novo sem perguntar)
```

## Ao parar
Input ausente ou inválido, PR fechado, SHA diferente, dado protegido ou comentário fora do diff sem correção: uma frase com o que faltou e onde era esperado. Nada foi escrito.
