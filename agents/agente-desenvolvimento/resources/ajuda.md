# Ajuda

Fonte da CONV-011. Mostre só a seção pedida (a da etapa atual; "como usar" mostra a Geral). Todo exemplo é fictício.

## Geral (como usar)
- Fluxo: Leitura e validação, Testes, Código, Revisão, Entrega.
- Este agente só codifica. Ele parte de uma spec já aprovada e mergeada em `specs/<card-id>-<slug>/` (`spec.md`, `plan.md`, `tasks.md`) e implementa UMA tarefa (`T-nn`) por execução e por PR.
- Você informa o link do card (que precisa ter a label `agent-ready` e estar em Especificado) e, se quiser, a tarefa. Sem a tarefa, o agente propõe a próxima cuja dependência já foi concluída.
- O agente não deduz nada e não faz plano: o plano vem do `plan.md`. Cada etapa termina parada até você responder o gate. Gates: AVANÇAR, APROVAR PR (libera push, PR, comentário e mover o card para Em review), COMENTAR (libera comentário de bloqueio).
- O card vai para Em andamento quando você der AVANÇAR no fim da Etapa 1 e para Em review quando o PR for aberto. O agente nunca move o card para Done.
- O processo está em `resources/fluxo.md`: estados, transições e gates. Para tirar uma aprovação manual, troque o gate da transição por `auto`.
- O progresso fica em `estado.json`; se a sessão cair, o agente retoma de onde parou.
- Próxima tarefa do mesmo card (T-02 depois de T-01 concluída): espere o merge se ela depende da T-01; volte para a branch base e atualize-a (manual, o agente não faz); responda DESCARTAR quando o agente perguntar pelo `estado.json` da T-01 (ou apague o arquivo); rode de novo com `tarefa T-02`.
- Card movido para Done antes de todas as tarefas serem integradas bloqueia no preflight (P11). O remédio é seu: mover o card de volta; o agente não faz isso.

## Etapa 1 - Leitura e validação
- Informe o link do card e, opcionalmente, a tarefa. A pasta atual deve ser o repositório da spec, na branch base.
- O agente confere a label `agent-ready` e depois o ambiente: repositório e branch certos, árvore limpa, base atualizada, ferramentas, acesso ao GitHub, os três arquivos da spec na base com `Status: aprovada`, card em Especificado, tarefa livre (sem PR aberto e não concluída), PR da spec não aberto, dependências, comandos do plano definidos, arquivos da tarefa e build, teste, lint e format passando antes de qualquer mudança.
- Qualquer falha: o agente lista o que corrigir e oferece comentar no card. Tudo certo: mostra o relatório, a tarefa escolhida e o preview de mover o card para Em andamento, e espera AVANÇAR.

EXEMPLO (fictício): "Implementa este card: https://trello.com/c/AbCd1234, tarefa T-02"

## Etapa 2 - Testes
- O agente lê o código de referência citado no plano e escreve os testes a partir dos critérios de aceite da tarefa, antes do código.
- Ele roda os testes e mostra que estão vermelhos pelo motivo certo. Se passarem antes do código, ou falharem por outro motivo, o agente para.
- Tarefa sem testes (por exemplo, só documentação): o agente avisa e pula. Mostra os testes e espera AVANÇAR.

## Etapa 3 - Código
- O agente implementa só os arquivos listados na tarefa, até os testes ficarem verdes. Precisa de outro arquivo: ele para e pergunta.
- Roda build, teste, lint e format do plano, nunca outro comando, até 3 tentativas. Depois disso o agente para e resume.
- Feature flag e rollout seguem o plano; o agente não decide isso. Depois de verde, atualiza só a documentação que a tarefa lista.
- Comandos passando: mostra a saída de cada um e espera AVANÇAR.

## Etapa 4 - Revisão
- Um revisor confere o diff com a spec, o plano e a tarefa: requisitos e critérios cobertos, nenhum arquivo fora da lista, restrições e segurança.
- Reprovado: o agente corrige e revisa de novo, até 2 ciclos.
- Aprovado: o agente mostra o parecer e espera AVANÇAR.

## Etapa 5 - Entrega
- O agente mostra o preview do PR, do comentário no card e do movimento para Em review.
- Nada é enviado até você responder APROVAR PR. O PR vai para a branch base; a revisão e o merge são seus.
- Marcar a tarefa como concluída em `tasks.md` não é feito pelo agente: fica registrado no PR e no relatório para o time.
