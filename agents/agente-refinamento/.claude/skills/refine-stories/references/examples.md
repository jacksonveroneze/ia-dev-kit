# Exemplos: refine-stories

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

## Especificação técnica
Informado: repositório `acme/pagamentos` (fonte: usuário); referência `src/Pix/CriarCobranca.cs:12-60` (fonte: leitura do repositório); comando de teste `dotnet test`.
- Correto: `Referência de implementação: src/Pix/CriarCobranca.cs:12-60 (leitura do repositório)`; `Arquivos a criar ou alterar: src/Pix/ConsultarCobranca.cs - nova consulta (proposto, confirmar; referência: CriarCobranca.cs)`; `Contrato: a definir` (ninguém informou); `Comandos: dotnet test`.
- Errado: escrever o contrato de entrada e saída de cabeça; preencher `Comandos: dotnet build && dotnet test --no-restore` quando só `dotnet test` foi informado.

## Spec autocontida
Story 2 depende da Story 1, que cria o tipo `CardSummaryOutput` em `src/Api/Models/CardSummaryOutput.cs` com `total`, `currency` e `groups`.
- Correto: `Contrato: saída CardSummaryOutput (criado pela Story 1 em src/Api/Models/CardSummaryOutput.cs): total (decimal), currency (string), groups (lista de grupo e total)`.
- Correto (campos ainda não conhecidos): `saída: a definir (tipo criado pela Story 1; campos não informados)`.
- Errado: `saída: a mesma da Story 1`; `regra: sugestão 2 aceita`; `teste: conforme decidido na conversa`.

## Critério concreto
- Correto: `Dado um agrupamento fora da lista permitida, quando a tool for chamada, então devolve erro de validação com a mensagem "groupBy inválido" e não executa o caso de uso.`
- Errado: `Dado um agrupamento inválido, quando chamar, então devolve erro.`; `então devolve o sumário.`

## Testes e comandos
- Correto: `Testes: validação de período (ordem e limite de 1 ano), agrupamento inválido e policy ausente | Comandos: build dotnet build; teste dotnet test`.
- Correto (decisão do usuário): `Testes: sem testes por decisão do usuário (risco: critérios sem verificação automática) | Comandos: build dotnet build`.
- Errado: `Testes:` vazio; sem comando de build; `a definir` marcado como `pronta`.

## Convenção do repositório
Informado: o repositório tem a skill `new-mcp-tool` (`.claude/skills/new-mcp-tool/SKILL.md:45-61`).
- Correto: `Restrições: tool fina; Siga: skill new-mcp-tool do repositório (.claude/skills/new-mcp-tool/SKILL.md:45-61)`.
- Errado: citar a skill apenas como fonte, sem mandar segui-la.

## Prontidão para codificar
- Correto: contrato `a definir` e um arquivo `(proposto, confirmar)` -> `precisa de humano: contrato de entrada e saída; confirmar arquivo ConsultarCobranca.cs`.
- Correto: todos os itens com fonte e nenhum pendente -> `pronta`.
- Correto: story de documentação -> `Tipo: sem código`, sem especificação técnica, `não se aplica`.
- Errado: `pronta` com item `a definir`; incluir especificação técnica em story sem código.

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
