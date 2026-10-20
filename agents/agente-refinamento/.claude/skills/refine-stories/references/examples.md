# Exemplos: refinar-stories

Valores fictícios. Nunca copie literalmente.

## Critério de aceite
- Correto: `Dado um usuário sem saldo, quando tentar pagar, então o sistema exibe "Saldo insuficiente" e não gera cobrança.`
- Errado: `O pagamento deve ser rápido e funcionar bem.`

## Story
- Correto: `Como cliente, quero pagar com Pix, para concluir a compra sem digitar dados de cartão.`
- Errado: `Implementar Pix.`

## Dependência
- Correto: `Story 3 - Página de listagem | Ordem: 3º | Depende de: Story 2 (endpoint de produtos)`
- Errado: stories soltas, sem ordem e sem dependências.

## Estimativa e dev
- Correto (nada informado): `Estimativa: a definir | Dev sugerido: a definir`.
- Correto (informado `3 pontos, Ana - backend`): `Estimativa: 3 pontos | Dev sugerido: Ana - backend`.
- Errado: escrever `Estimativa: 3 pontos` sem que ninguém tenha informado.

## Uso de achados técnicos
Informado: evolução decidida "tornar o limite mínimo configurável"; evolução recusada "trocar o cálculo por score"; risco "endpoint de limite com p95 de 840 ms (fonte: indicadores do serviço)".
- Correto: uma story para a evolução decidida; uma subtask de otimização da consulta (risco); critério `Dado carga normal, quando consultar o limite, então o p95 fica abaixo de 300 ms (fonte do valor atual: indicadores do serviço)`. Nada sobre a evolução recusada.
- Errado: story para a evolução recusada; meta de latência sem fonte.

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
