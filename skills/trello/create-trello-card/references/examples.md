# Exemplos: create-trello-card

Valores fictícios. Nunca copie literalmente.

## Preview correto
```
Board: Time Exemplo | Lista de destino: Backlog
Duplicados: nenhum

| Ordem | Título do card | Dev | Pontos | Subtasks | Depende de | Fora de escopo |
|---|---|---|---|---|---|---|
| 1 | [Story 1] Calcular limite mínimo configurável | Ana | 3 | 4 | nenhuma | preenchido |
| 2 | [Story 2] Consultar limite no app | Ana | 5 | 5 | Story 1 (link após criar) | preenchido |

Confirma a criação destes cards na lista Backlog?
```
Por que está certo: só leitura, na ordem informada, termina pedindo confirmação explícita.

## Errado
- Criar os cards logo após o usuário dizer "o preview está bom". Comentário não é autorização.
- Criar um card na Parte A "para testar".
- Título fora do padrão: `Calcular limite` em vez de `[Story 1] Calcular limite`.

## Dependência como link
A Story 1 foi criada com o link `https://trello.com/c/AbCd1234`; a Story 2 depende dela.
- Correto: na descrição da Story 2, `Depende de: Story 1 (Calcular limite mínimo configurável) - https://trello.com/c/AbCd1234`.
- Errado: `Depende de: Story 1` sem link; buscar na lista um card "parecido" para ligar.

## Dependência fora da lista
A Story 3 depende de um card que já existia no board.
- Correto: usar o link informado nos Inputs (`Depende de: Cadastro de clientes - https://trello.com/c/ZyX98765`). Sem link informado, pedir na Parte A.
- Errado: procurar o card pelo nome e escolher um; ou gravar só o nome.

## Dependência de story posterior
A Story 2 diz depender da Story 4, que vem depois na lista.
- Correto: parar antes de criar e pedir a ordem corrigida (o link da Story 4 ainda não existe).
- Errado: criar a Story 2 com dependência sem link.

## Fora de escopo
- Correto: gravar `Fora de escopo: Alterar o limite; exportar extrato.` na descrição, copiado da story.
- Correto: story chega com `Fora de escopo: a definir`; parar na Parte A e pedir o texto.
- Errado: omitir o campo, gravar `a definir` ou escrever "nada fora de escopo" por dedução.

## Descrição do card
A story chega com história, critérios de aceite, dependência e fora de escopo.
- Correto: copiar o texto inteiro para a descrição do card, sem alterar uma palavra, e conferir na verificação que ficou idêntico.
- Errado: resumir os critérios de aceite em duas linhas ou reescrever com outras palavras.

## Label
A story chega com o epic `Limite de crédito`.
- Correto: criar a label `Epic: Limite de crédito` se não existir e aplicá-la às stories do epic.
- Errado: criar uma label que ninguém informou.

## Card duplicado
Já existe `[Story 1] Calcular limite mínimo configurável` na lista.
- Correto: avisar e perguntar: pular, atualizar ou criar mesmo assim. Esperar a resposta.
- Errado: criar outro card igual, ou editar o existente sem perguntar.

## Falha no meio da criação
Story 1 criada; a Story 2 retornou erro.
- Correto: parar, informar `Criados: Story 1 (link)`, `Não criados: Story 2, Story 3`, `Erro: <mensagem>`, e perguntar como proceder.
- Errado: recriar a Story 1 para "refazer tudo do zero".

## Uso avulso, fora de qualquer fluxo
Pedido: "Cria estas 2 stories no board Time Exemplo, lista Backlog." (com as stories completas)
- Correto: fazer a Parte A, mostrar o preview e esperar a confirmação; só então criar.
- Errado: criar direto porque o pedido já dizia "cria".

## Pedido incompleto
Pedido: "Cria as stories no Trello." (sem board nem lista)
- Correto: perguntar só o board e a lista de destino. Não ler nem escrever.
- Errado: escolher o board "mais recente".
