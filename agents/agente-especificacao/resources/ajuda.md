# Ajuda

Fonte da CONV-011. Mostre só a seção pedida (a da etapa atual; "como usar" mostra a Geral). Todo exemplo é fictício.

## Geral (como usar)
- Fluxo: Leitura e validação, Contexto, Spec, Plano, Tarefas, Entrega.
- Você informa o link do card, o repositório (org/repo) e a branch base. O agente não deduz nada: dado que falta vira pergunta e rascunho com pendência não é aprovado.
- Cada etapa termina parada até você responder o gate. Gates: AVANÇAR, APROVAR SPEC, APROVAR PLANO, APROVAR TAREFAS, APROVAR ARTEFATOS, VOLTAR (volta uma etapa e invalida as aprovações seguintes), COMENTAR.
- Nas etapas 3 a 5 você refina em conversa: diga o que ajustar e o agente refaz o rascunho, mostrando o que mudou.
- Nada é gravado em `specs/`, nem PR, comentário, label ou movimento do card, até APROVAR ARTEFATOS.
- O processo está em `resources/fluxo.md`. Para fundir aprovações, troque o gate da transição por `auto`.
- O progresso fica em `estado.json` e os rascunhos em `rascunho/`; se a sessão cair, o agente retoma de onde parou. Os dois devem estar no `.gitignore`.

## Etapa 1 - Leitura e validação
- Informe o link do card, o repositório e a branch base. A pasta atual deve ser o repositório.
- O agente confere se o card de negócio está completo (história, critérios de aceite, subtasks, dependência e fora de escopo) e depois o ambiente: repositório e branch certos, árvore limpa, base atualizada, acesso de escrita ao GitHub, destino livre, cards de dependência (lidos pelo link; dependência só com título vira pendência para você) e lista `Specified` no board. Também avisa, sem bloquear, se `specs/constitution.md` não existir e se o card não estiver na lista `Refined`.
- Qualquer falha: o agente lista o que corrigir e oferece comentar no card. Tudo certo: mostra o relatório e espera AVANÇAR. Card fora de `Refined`: o agente avisa e pede que você confirme, em frase própria, que quer seguir assim; só depois o AVANÇAR vale.

EXEMPLO (fictício): "Especifica este card: https://trello.com/c/AbCd1234, repositório acme/contas, base develop"

## Etapa 2 - Contexto
- O agente lê o código e os guias do repositório (incluindo `specs/constitution.md`, se existir; ausente, só um aviso) e resume como a regra funciona hoje, onde a mudança se encaixa e quais convenções seguir.
- As regras `CONST-nnn` aplicáveis passam a ser citadas na spec, no plano e nas tarefas. Se o card conflitar com uma regra, vira pergunta para você decidir.
- Lacuna que impeça a spec: o agente lista e para. Contexto reunido: espera AVANÇAR.

## Etapa 3 - Spec
- O agente propõe o quê e o porquê: requisitos, critérios de aceite, regras, erros, restrições e perguntas em aberto. Sem tecnologia.
- Responda as perguntas ou peça ajustes. Só com zero item `a definir` o APROVAR SPEC é aceito.

## Etapa 4 - Plano
- O agente propõe o como: decisões, componentes e caminhos, contrato, testes por critério, comandos, rollout e rollback.
- O plano não cria requisito. Se for preciso mudar a spec, diga VOLTAR. Só com zero item `a definir` o APROVAR PLANO é aceito.

## Etapa 5 - Tarefas
- O agente fatia o plano em tarefas do tamanho de um PR, com os arquivos, testes e comandos de cada uma.
- Todo critério de aceite deve estar coberto e todo arquivo do plano em uma só tarefa. Só então o APROVAR TAREFAS é aceito.

## Etapa 6 - Entrega
- O agente confere a consistência e mostra o preview dos três arquivos, do PR, do comentário, da label `agent-ready` e do movimento do card para a lista `Specified` (lista atual e destino).
- Nada é gravado até você responder APROVAR ARTEFATOS. O PR vai para a branch base, em uma branch `spec/<slug>`; o agente confere o nome da branch no preview junto do título e da descrição e para se divergir, porque o desenvolvimento acha a spec por esse nome. O movimento do card é o último passo, depois da label. Card já em `Specified`: o agente avisa e não move. Lista `Specified` inexistente: o agente para e pergunta, sem criar. A revisão e o merge são seus. A spec só vale para codificar depois do merge.
