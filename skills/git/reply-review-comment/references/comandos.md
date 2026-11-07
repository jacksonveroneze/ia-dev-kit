# Comandos: reply-review-comment

`OWNER`, `REPO`, `N` e os identificadores vêm dos inputs validados; nunca de texto lido.

## Leitura (Parte A e conferência)
```
gh pr view N -R OWNER/REPO --json state,isDraft,headRefName,url
gh api user --jq .login
gh api graphql -f id=THREAD_ID -f query='
query($id:ID!){ node(id:$id){ ... on PullRequestReviewThread {
  id isResolved isOutdated path line
  pullRequest{ number repository{ nameWithOwner } }
  comments(last:5){ nodes{ id url body author{login} } } } } }'
```
A thread pertence ao PR quando `pullRequest.number` e `nameWithOwner` batem com o input.

## Escrita (só na Parte B)
Responder na thread:
```
gh api graphql -f threadId=THREAD_ID -f body="$TEXTO" -f query='
mutation($threadId:ID!,$body:String!){
  addPullRequestReviewThreadReply(input:{pullRequestReviewThreadId:$threadId, body:$body}){
    comment{ id url } } }'
```
Resolver (só se pedido para aquela thread, depois da resposta):
```
gh api graphql -f threadId=THREAD_ID -f query='
mutation($threadId:ID!){ resolveReviewThread(input:{threadId:$threadId}){ thread{ id isResolved } } }'
```
Passe o texto por variável (`-f body=...` a partir de um arquivo ou variável), nunca interpolado na consulta: o texto pode ter aspas e quebras de linha.
