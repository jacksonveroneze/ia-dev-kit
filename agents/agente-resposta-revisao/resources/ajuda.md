# Ajuda

Fonte da CONV-011. Mostre só a seção pedida (a da etapa atual; "como usar" mostra a Geral). Todo exemplo é fictício.

## Geral (como usar)
- Fluxo: Leitura e preflight, Triagem, Correção, Revisão do diff, Commit e resposta, Concluído.
- Você informa só o PR (URL ou `org/repo#número`). O PR deve ser seu, estar aberto e a pasta atual deve estar na branch dele.
- O agente lê os comentários, recomenda CONCORDAR, CONTESTAR ou PERGUNTAR em cada um e você decide. Só os comentários concordados viram código.
- No modo rígido, cada etapa termina parada até você responder o gate. Gates: AVANÇAR, APROVAR TRIAGEM (libera a correção), APROVAR CORREÇÕES (libera os commits), AJUSTAR (pede mudança no diff), AUTORIZAR PUSH (libera o push normal), APROVAR RESPOSTAS (libera publicar as respostas).
- O agente nunca resolve thread, nunca faz merge e nunca faz force-push. Isso é seu e do revisor.
- O processo está em `resources/fluxo.md`; o critério de concordar ou contestar está em `resources/criterio-resposta.md`.
- O progresso fica em `estado.json`; se a sessão cair, o agente retoma de onde parou.

## Etapa 1 - Leitura e preflight
- Informe o PR. O agente lê os comentários e confere o ambiente: repositório e branch certos, PR seu e aberto, árvore limpa, branch igual ao PR, base não atrasada, acesso ao GitHub, comandos de verificação e linha de base verde.
- Falhou algo: o agente lista o que corrigir e para. Ele não atualiza a branch por conta própria.
- Tudo certo: mostra o relatório e espera AVANÇAR.

EXEMPLO (fictício): "Responde as revisões do PR acme/pagamentos#42"

## Etapa 2 - Triagem
- O agente agrupa os comentários e mostra, para cada um: o que pede, se parece correto à luz do código, da spec e do plano, e uma recomendação.
- Para mudar uma decisão, diga, por exemplo, "o 3 vira CONTESTAR". A tabela é reapresentada.
- Nada é alterado até você responder APROVAR TRIAGEM. Sem nenhum CONCORDAR, o agente vai direto às respostas.

## Etapa 3 - Correção
- Só os comentários concordados são corrigidos, só nos arquivos deles (mais os que você autorizou na triagem).
- Build, teste, lint e format rodam até 3 tentativas; depois disso o agente para e resume, com a saída como evidência.
- Comandos passando: o agente mostra o resultado e espera AVANÇAR.

## Etapa 4 - Revisão do diff
- Você vê o diff organizado por comentário aceito.
- APROVAR CORREÇÕES libera os commits. AJUSTAR, com o que mudar, volta à correção (até 2 ciclos).

## Etapa 5 - Commit e resposta
- Os commits entram na branch do PR. O agente mostra o `git log` e o comando de push e espera AUTORIZAR PUSH. O push é normal, nunca force, nunca em `main` ou `develop`.
- Depois, mostra o texto da resposta de cada thread (preview). Nada é publicado até você responder APROVAR RESPOSTAS.
- As threads ficam abertas: quem resolve é o revisor ou você.

## Etapa 6 - Concluído
- Resumo: commits, respostas publicadas, decisões de CONTESTAR e PERGUNTAR que dependem de retorno do revisor, e o que ficou pendente. O merge é seu.
