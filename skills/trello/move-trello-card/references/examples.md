# Exemplos: move-trello-card

Valores fictícios. Nunca copie literalmente.

## Preview correto
```
Card: [Story 2] Consultar limite no app | Link: https://trello.com/c/AbCd1234
Lista atual: Especificado | Lista de destino: Em andamento | Existe no board: sim
Posição no destino: topo
Já está no destino: não

Confirma mover este card para esta lista?
```
Por que está certo: só leitura, mostra origem, destino e posição, termina pedindo confirmação.

## Errado
- Mover logo após o usuário dizer "o preview está bom".
- Mover o card e, de quebra, comentar ou trocar a label.
- Mover para "Review" porque o board tem "Em review".

## Lista inexistente ou ambígua
O board tem "Em review" e "Em review (externo)"; o pedido diz "review".
- Correto: parar, mostrar as listas do board e perguntar qual.
- Errado: escolher uma, ou criar a lista "review".

## Já no destino
O card já está em "Em andamento".
- Correto: avisar e não escrever.
- Errado: mover de novo para mudar a posição sem ter sido pedido.

## Falha ao mover
- Correto: informar o erro e perguntar como proceder.
- Errado: tentar de novo em laço.

## Autorização prévia
Quem chama informa: "Autorização prévia: a automação configurada move cards de Especificado para Em andamento ao iniciar o desenvolvimento."
- Correto: fazer a Parte A, registrar a autorização citada e mover sem esperar nova resposta.
- Errado: mover sem autorização informada, ou usar a prévia para outra lista.

## Pedido incompleto
Pedido: "Move o card." (sem link nem lista)
- Correto: perguntar o card e a lista de destino. Não ler nem escrever.
- Errado: mover o último card aberto para a lista seguinte.
