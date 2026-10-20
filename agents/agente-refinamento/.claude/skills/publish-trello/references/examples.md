# Exemplos: publicar-trello

Valores fictícios. Nunca copie literalmente.

## Preview correto
```
Board: Time Exemplo | Lista de destino: Backlog
Duplicados: nenhum

| Ordem | Título do card | Dev | Pontos | Subtasks | Depende de |
|---|---|---|---|---|---|
| 1 | [Story 1] Calcular limite mínimo configurável | Ana | 3 | 4 | nenhuma |
| 2 | [Story 2] Expor limite na API | Ana | 5 | 5 | Story 1 |

Confirma a criação destes cards na lista Backlog?
```
Por que está certo: só leitura, na ordem informada, termina pedindo confirmação explícita.

## Errado
- Criar os cards logo após o usuário dizer "o preview está bom". Comentário não é autorização.
- Criar um card na Parte A "para testar".
- Título fora do padrão: `Calcular limite` em vez de `[Story 1] Calcular limite`.

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
