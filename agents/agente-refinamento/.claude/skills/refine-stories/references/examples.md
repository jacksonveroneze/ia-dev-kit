# Exemplos: refine-stories

Valores fictícios. Nunca copie literalmente.

## Critério de aceite
- Correto: `Dado um usuário sem saldo, quando tentar pagar, então o sistema exibe "Saldo insuficiente" e não gera cobrança.`
- Errado: `O pagamento deve ser rápido e funcionar bem.`

## Story
- Correto: `Como cliente, quero pagar com Pix, para concluir a compra sem digitar dados de cartão.`
- Errado: `Implementar Pix.`

## Dependência
- Correto: `Story 3 - Página de listagem | Ordem: 3º | Depende de: Story 2 (consulta de produtos disponível)`
- Errado: stories soltas, sem ordem e sem dependências.

## Fora de escopo
Informado no escopo: "fora de escopo: relatório em Excel". A Story 1 gera o PDF; a Story 2 envia o PDF por e-mail e nada foi dito sobre ela.
- Correto: Story 1 `Fora de escopo: relatório em Excel.`; Story 2 `Fora de escopo: a definir` (o orquestrador pergunta ao usuário antes de publicar).
- Errado: omitir o campo; inventar `Fora de escopo: envio por WhatsApp`; escrever "nada fora de escopo".

## Estimativa e dev
- Correto (nada informado): `Estimativa: a definir | Dev sugerido: a definir`.
- Correto (informado `3 pontos, Ana - backend`): `Estimativa: 3 pontos | Dev sugerido: Ana - backend`.
- Errado: escrever `Estimativa: 3 pontos` sem que ninguém tenha informado.

## Uso de achados decididos
Informado: evolução decidida "tornar o limite mínimo configurável"; evolução recusada "trocar o cálculo por score"; risco "consulta de limite leva 840 ms no p95 (fonte: indicadores do serviço)".
- Correto: uma story para a evolução decidida; uma subtask "reduzir o tempo da consulta de limite" (risco); critério `Dado carga normal, quando o cliente consultar o limite, então a resposta chega em menos de 300 ms no p95`. Nada sobre a evolução recusada.
- Errado: story para a evolução recusada; meta de tempo sem origem informada.

## Sem detalhe técnico
Informado pelo usuário: "o cálculo está em `src/Limite/Calculadora.cs:61` e o endpoint é `GET /limites/{id}`".
- Correto: `Critério: Dado um cliente com renda comprovada, quando consultar o limite, então vê o valor mínimo configurado pela empresa.` O caminho e o endpoint ficam de fora; se forem essenciais, avise o usuário que pertencem ao passo técnico.
- Errado: `Subtask: alterar Calculadora.cs:61`; `Critério: GET /limites/{id} devolve 200`.

## Story autocontida
Story 2 depende da Story 1, que entrega o resumo de gastos por categoria.
- Correto: `Depende de: Story 1 (resumo de gastos por categoria disponível)`; critério `Dado o resumo por categoria, quando o cliente escolher o mês, então vê o total e o valor de cada categoria.`
- Errado: `saída: a mesma da Story 1`; `regra: sugestão 2 aceita`; `conforme decidido na conversa`.

## Critério concreto
- Correto: `Dado um agrupamento fora da lista permitida, quando o cliente pedir o resumo, então vê a mensagem "Agrupamento inválido" e nenhum resumo é gerado.`
- Errado: `Dado um agrupamento inválido, quando pedir, então dá erro.`; `então mostra o resumo.`

## Ajuste
Pedido: "Troca a ordem da Story 3 com a Story 2."
- Correto: `Mudou: Story 3 passou a 2º e Story 2 a 3º. Story 3 agora depende de Story 1. Stories agora: 4. Sequência atualizada: Story 1 -> Story 3 -> Story 2 -> Story 4.`
- Errado: repetir a proposta inteira, ou trocar a ordem sem rever a dependência (a Story 3 ainda dependia da Story 2).

## Uso avulso, fora de qualquer fluxo
Pedido: "Quebra em stories: permitir exportar relatório em PDF. Persona: gerente. Problema: hoje copia dados à mão. Fora de escopo: relatório em Excel."
- Correto: declarar os 3 tópicos, gerar as stories com `a definir` em estimativa e dev, terminar com a sequência.
- Errado: pedir um resumo de fase ou um arquivo antes de começar; estimar pontos por conta própria.

## Pedido incompleto
Pedido: "Quebra isso em stories." (sem objetivo, persona ou escopo)
- Correto: perguntar só o que falta, nessa ordem: objetivo e problema, depois persona e escopo.
- Errado: supor persona e escopo e gerar.
