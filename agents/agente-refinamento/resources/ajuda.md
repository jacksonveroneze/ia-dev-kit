# Ajuda

Fonte da CONV-016. Mostre só a seção pedida (a da fase atual; "como usar" mostra a Geral). Todo exemplo é fictício: nunca entra no refinamento.

## Geral (como usar)
- Fluxo: Entrada, Contexto, Refinamento, Revisão, Publicação.
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
| Contexto técnico | API `api-extrato`, GitHub e Datadog, pergunta: "como o período é validado hoje?" |
| Board* | Time Exemplo |
| Lista de destino* | Backlog |

## Fase 2 - Contexto
- Opcional. Sem contexto, o agente registra `Contexto: não solicitado`.
- Para pedir: API (cadastrada em `dados/fontes.md`), fontes (GitHub, Datadog) e a pergunta sobre a regra.
- Você recebe regra atual, produção, riscos, sugestões e lacunas, tudo com fonte.
- Marque cada sugestão como aceita ou recusada. Só as aceitas viram story.

EXEMPLO (fictício): "Contexto da `api-extrato`, GitHub e Datadog. Como o período máximo é validado hoje?"

## Fase 3 - Refinamento
- O agente gera epic, stories, critérios de aceite, subtasks, ordem, dependências, estimativa e dev sugerido.
- Nada é publicado. Você revisa na fase seguinte.
- Story acima de 8 pontos é dividida. Dev com 2 ou mais stories gera alerta de carga.

## Fase 4 - Revisão
Ajuste em linguagem natural.

EXEMPLOS (fictícios):
- "Troca o dev da Story 2 para o Mario."
- "Divide a Story 3 em duas."
- "Move a Story 4 para antes da Story 2."
- "Aumenta a Story 1 para 5 pontos."

O agente mostra só o que mudou e confere a Definition of Ready. Alerta de carga: responda CIENTE por dev sinalizado. Tudo certo: AVANÇAR.

## Fase 5 - Publicação
- O agente mostra o preview (título, dev, pontos, subtasks, dependência) e checa cards duplicados.
- Nada é criado até você responder APROVADO.
- Card duplicado: escolha pular, atualizar ou criar mesmo assim.
- Falha no meio: o agente para e não recria o que já existe.
