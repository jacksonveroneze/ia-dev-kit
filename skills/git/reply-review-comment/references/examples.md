# Exemplos: reply-review-comment

Valores fictícios. Nunca copie literalmente.

## Preview correto
Pedido: PR `acme/pagamentos#42`; thread `PRRT_kwDOA1` com o texto "Corrigido no commit 7be41d0: a data final agora é validada contra a inicial."; sem resolver.
```
PR: acme/pagamentos#42 | Estado: aberto | Autenticado como: dev-a

| # | Thread | Local | Comentário original (trecho) | Resposta a publicar | Ação |
| 1 | PRRT_kwDOA1 | src/Tools/SummarizeCardTransactionsTool.cs:41 | Esse período aceita data final anterior à inicial... | Corrigido no commit 7be41d0: a data final agora é validada contra a inicial. | responder |

Verificações: texto sem segredo nem dado pessoal
Já publicadas: nenhuma
Confirma a publicação destas 1 respostas neste PR? Resolver: nenhuma thread
```
Por que está certo: só leitura, texto literal, ação explícita, termina pedindo autorização.

## Errado
- Publicar na Parte A "para testar".
- Publicar logo após "o preview está bom".
- Trocar "Corrigido no commit 7be41d0" por uma versão "mais educada" sem pedir.
- Resolver a thread porque a resposta diz que foi corrigido.

## Resolver pedido
Quem chama pede "responder e resolver" na thread 2 e "só responder" na thread 1, e o usuário autoriza.
- Correto: resolver só a thread 2, depois de publicada a resposta; conferir `isResolved` nela e mantê-lo falso na 1.
- Errado: resolver as duas.

## Autorização prévia
Quem chama informa: "Autorização prévia: automação configurada, permite responder (sem resolver) às threads listadas."
- Correto: fazer a Parte A, registrar a autorização citada e executar a Parte B.
- Errado: publicar sem que ninguém tenha declarado a autorização.

## Segredo no texto
A resposta contém `Authorization: Bearer eyJ...`.
- Correto: parar, informar a thread e pedir o texto sem o segredo.
- Errado: mascarar por conta própria e publicar.

## Thread de outro PR
O identificador pertence a `acme/pagamentos#40`.
- Correto: não publicar naquela, informar e seguir com as demais após a autorização.
- Errado: publicar mesmo assim.

## Resposta já publicada
O último comentário da thread é do autenticado e igual ao texto.
- Correto: registrar "já publicada" e não repetir.
- Errado: postar duplicado.

## Falha no meio
A primeira resposta foi publicada; a segunda deu erro de rede.
- Correto: parar, informar `Publicado: thread 1`, `Não publicado: thread 2`, o erro e perguntar como proceder.
- Errado: repostar a primeira.

## Pedido incompleto
Pedido: "Responde lá que está corrigido."
- Correto: perguntar o PR, a thread e o texto exato.
- Errado: escolher a thread mais recente e escrever o texto.
