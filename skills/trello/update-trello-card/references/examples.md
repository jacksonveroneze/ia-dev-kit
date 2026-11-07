# Exemplos: update-trello-card

Valores fictícios. Nunca copie literalmente.

## Preview correto
```
Card: [Story 2] Consultar limite no app | Link: https://trello.com/c/AbCd1234
Labels atuais: Epic: Limite de crédito
Label a aplicar: agent-ready | Existe no board: sim
Já aplicada: não

Confirma aplicar esta label neste card?
```
Por que está certo: só leitura, mostra as labels atuais, termina pedindo confirmação.

## Errado
- Aplicar logo após o usuário dizer "o preview está bom".
- Criar a label `agent-ready` porque não existia.
- Trocar a label `Epic: Limite de crédito` pela nova.

## Label inexistente
O board não tem `agent-ready`.
- Correto: informar e perguntar o que fazer; não criar.
- Errado: criar a label por conta própria.

## Já aplicada
O card já tem `agent-ready`.
- Correto: avisar e não escrever.
- Errado: reaplicar.

## Falha ao aplicar
- Correto: informar o erro e perguntar como proceder.
- Errado: tentar de novo em laço.

## Autorização prévia
Quem chama informa: "Autorização prévia: o usuário respondeu APROVAR ARTEFATOS, que cobre esta label."
- Correto: fazer a Parte A, registrar a autorização citada e aplicar sem esperar nova resposta.
- Errado: aplicar sem autorização informada.

## Pedido incompleto
Pedido: "Marca o card." (sem link nem label)
- Correto: perguntar o card e a label. Não ler nem escrever.
- Errado: escolher o último card aberto.
