# Ajuda

Fonte da CONV-011. Mostre só a seção pedida (a da etapa atual; "como usar" mostra a Geral). Todo exemplo é fictício.

## Geral (como usar)
- Fluxo: Leitura, Plano, Testes e código, Revisão, Entrega.
- Você informa só o link do card. A spec do card manda; o agente não deduz nada.
- Gates: APROVAR PLANO (libera código), APROVAR PR (libera push, PR e comentário), COMENTAR (libera comentário de bloqueio).
- Peça "ajuda" em qualquer etapa.

## Etapa 1 - Leitura
- Informe o link do card. A pasta atual deve ser o repositório do card, limpo e na branch base.
- A story precisa ter a label `agent-ready` e a especificação completa. Se faltar algo, o agente lista e oferece comentar no card.

EXEMPLO (fictício): "Implementa este card: https://trello.com/c/AbCd1234"

## Etapa 2 - Plano
- O agente lê a referência do card e propõe o plano: arquivos, testes, comandos e riscos.
- Nada é escrito até você responder APROVAR PLANO. Para mudar o plano, diga o que ajustar.

## Etapa 3 - Testes e código
- Testes saem dos critérios de aceite, antes do código. O código só toca os arquivos do card.
- Build, teste e lint rodam até 3 tentativas. Depois disso o agente para e resume.

## Etapa 4 - Revisão
- Um revisor confere o diff com a spec (critérios, restrições, fora de escopo, segurança).
- Reprovado: o agente corrige e revisa de novo, até 2 ciclos.

## Etapa 5 - Entrega
- O agente mostra o preview do PR (branch, commit, título, descrição) e do comentário no card.
- Nada é enviado até você responder APROVAR PR. O PR vai para a branch base do card; o merge é seu.
