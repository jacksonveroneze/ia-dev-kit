# Ajuda

Fonte da CONV-016. Mostre só a seção pedida (a da fase atual; "como usar" mostra a Geral). Todo exemplo é fictício: nunca entra no refinamento.

## Geral (como usar)
- Fluxo: Entrada, Refinamento, Revisão, Publicação.
- Gates: AVANÇAR (próxima fase), CIENTE (aceitar alerta de carga), APROVADO (liberar escrita no Trello).
- Peça "ajuda" em qualquer fase. Para ajustar algo, diga o que mudar.
- O agente não deduz nada: faltou dado, ele pergunta.

## Fase 1 - Entrada
Campos com `*` são obrigatórios.

EXEMPLO (fictício):

| Campo | Exemplo |
|---|---|
| Objetivo* | Permitir que o cliente consulte o extrato por período |
| Problema* | Hoje o extrato mostra só 30 dias e o cliente abre chamado |
| Persona* | Cliente pessoa física do app |
| Escopo* | Filtro por período, listagem paginada |
| Fora de escopo* | Extrato de cartão, exportação em CSV |
| Restrições | Prazo de 2 sprints |
| Board* | Time Exemplo |
| Lista de destino* | Backlog |

## Fase 2 - Refinamento
- Opcional, só a pedido: para o agente consultar o GitHub, informe a API (cadastrada em `dados/fontes.md`) e a pergunta sobre a regra atual. Sem pedido, ele não consulta.
- Com a consulta, você recebe regra atual, riscos, sugestões e lacunas, tudo com fonte. Serve para você decidir; a fonte não vai para as stories. Marque cada sugestão como aceita ou recusada; só as aceitas viram story.

EXEMPLO (fictício): "Consulta a `api-extrato` no GitHub. Como o período máximo é validado hoje?"

- O agente gera epic, stories, critérios de aceite, subtasks, ordem, dependências, estimativa e dev sugerido, em linguagem de negócio.
- Detalhe técnico de código (arquivos, contratos, comandos) não entra: é feito em outro passo.
- Nada é publicado. Você revisa na fase seguinte.
- Story acima de 8 pontos é dividida. Dev com 2 ou mais stories gera alerta de carga.

## Fase 3 - Revisão
Ajuste em linguagem natural.

EXEMPLOS (fictícios):
- "Troca o dev da Story 2 para o Mario."
- "Divide a Story 3 em duas."
- "Move a Story 4 para antes da Story 2."
- "Aumenta a Story 1 para 5 pontos."

O agente mostra só o que mudou. Alerta de carga: responda CIENTE por dev sinalizado. Tudo certo: AVANÇAR.

## Fase 4 - Publicação
- O agente mostra o preview (título, dev, pontos, subtasks, dependência, fora de escopo) e checa cards duplicados.
- A descrição do card leva história, critérios de aceite, dependência (com o link do card da story anterior), fora de escopo, estimativa e prioridade. A label é a do epic.
- Story com Fora de escopo `a definir` não é publicada: o agente pergunta antes.
- Nada é criado até você responder APROVADO.
- Card duplicado: escolha pular, atualizar ou criar mesmo assim.
- Falha no meio: o agente para e não recria o que já existe.
