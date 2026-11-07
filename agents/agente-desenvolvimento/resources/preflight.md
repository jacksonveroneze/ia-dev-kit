# Preflight

Executado no estado PREFLIGHT, antes do primeiro gate de passagem, para a execução nunca começar com pendência. Tudo é leitura, exceto a linha de base (P17), que roda os comandos do plano. Item sem evidência conta como falha. Qualquer falha: evento `alguma verificação falhou` e BLOQUEADO, listando o que corrigir.

Os artefatos são lidos pelo git na branch base (`git show HEAD:specs/<card-id>-<slug>/spec.md` e equivalentes), depois de P3 e P4 garantirem que a árvore local é a base. O `<card-id>` vem do link; o `<slug>` vem do nome da pasta `specs/<card-id>-*` encontrada em P9. O cabeçalho dos três arquivos (`Card`, `Repositório`, `Base`, `Status`) segue `agente-especificacao/resources/estrutura-specs.md`.

## Verificações

| # | Verificação | Como (evidência) | Falha quando |
|---|---|---|---|
| P1 | Repositório local é o da spec | `git remote get-url origin` | difere do `Repositório` do cabeçalho da spec |
| P2 | Branch atual é a base da spec | `git branch --show-current` | difere da `Base` do cabeçalho da spec |
| P3 | Árvore limpa | `git status --porcelain` | há saída |
| P4 | Base atualizada | `git fetch origin <base>`; comparar `git rev-parse HEAD` e `origin/<base>` | HEAD atrás ou divergente |
| P5 | Sem trabalho em andamento | `estado.json` ausente, ou do mesmo card e da mesma tarefa, ou com `estado` CONCLUIDO (de outra tarefa, do mesmo card ou não); `git branch -a` (branch de execução cujo PR já foi mergeado não conta) | `estado.json` de outro card ou de outra tarefa fora de CONCLUIDO; branch de outra execução com PR não mergeado. CONCLUIDO de outra tarefa só passa depois do DESCARTAR do usuário (ver Regras) |
| P6 | `estado.json` fora do versionamento | `git check-ignore estado.json` | não está no `.gitignore` |
| P7 | Ferramentas | `command -v git`, `command -v gh` e o executável de cada comando do plano (build, teste, lint, format) | algum ausente |
| P8 | Acesso ao GitHub com escrita | `gh auth status`; `gh repo view <repo> --json viewerPermission` | sem login ou permissão menor que WRITE |
| P9 | Artefatos existem na base | `git ls-tree -r origin/<base> --name-only -- specs/` filtrado por `<card-id>` | não há exatamente uma pasta `specs/<card-id>-<slug>/` com `spec.md`, `plan.md` e `tasks.md` |
| P10 | Spec aprovada e na base | `git show origin/<base>:specs/<card-id>-<slug>/<arquivo>` do cabeçalho dos três arquivos; `gh pr list --state all --head spec/<slug> --json number,state` | algum com `Status` diferente de `aprovada`, ou `Card` diferente do link, ou há PR da spec ABERTO (`state` OPEN) para o `<slug>` |
| P11 | Card pronto | resultado de `read-trello-card` (labels) e a lista atual do card, lida em somente leitura pelo conector do Trello | sem a label `agent-ready`; lista diferente de Especificado, exceto quando a lista é Em andamento ou Em review e existe PR de outra tarefa do mesmo card; lista Done sempre falha |
| P12 | Tarefa escolhida livre | `tasks.md`: a `T-nn` existe e está `Status: pendente`; `gh pr list --state all --search "<card-id> T-nn" --json number,state,title,headRefName`; `git branch -a` | não existe; já tem PR aberto; já tem PR mergeado (concluída); branch da tarefa já existe |
| P13 | Dependências da tarefa concluídas | cada `T` em `Depende de` da tarefa tem PR mergeado (mesma busca de P12); cada arquivo ou tipo que o plano diz vir de outra tarefa ou story existe na base | dependência sem PR mergeado, ou ausente na base |
| P14 | Comandos e rollout definidos | `plan.md`: seções Comandos e Rollout e rollback; `tasks.md`: linha `Comandos` da tarefa | build, teste ou lint ausente ou `a definir`; format listado como `a definir`; rollout com `a definir`; comandos da tarefa divergem do plano |
| P15 | Arquivos da tarefa | listar os caminhos de "Arquivos a criar ou alterar" e de "Caminhos de teste permitidos" | a alterar não existe; a criar já existe; diretório pai ausente |
| P16 | Referências existem | cada `arquivo:linha` de "Referência de implementação" do plano que a tarefa usa | arquivo ou linha inexistente (plano desatualizado) |
| P17 | Linha de base verde | rodar os comandos do plano na árvore limpa, um por vez | algum falha, ou a árvore fica suja depois |

As verificações de P1 a P16 são somente leitura e são a exceção listada à regra de comandos do plano (CONV-013). Nenhuma delas altera arquivo, branch ou card.

## Prova de que a spec foi mergeada
A prova são os três arquivos `specs/<card-id>-<slug>/{spec,plan,tasks}.md` presentes na base (P9) com `Status: aprovada` (P10). O PR da spec não é a prova: PR mergeado, fechado sem merge ou inexistente (a branch `spec/<slug>` pode ter sido apagada) não decide nada se os arquivos estão na base. O P10 só falha pelo PR quando há um PR da spec aberto para o `<slug>`, porque a spec ainda pode mudar.

## Escolha da tarefa
- Tarefa informada pelo usuário: P12 e P13 valem para ela.
- Sem tarefa informada: proponha a primeira `T-nn` de `tasks.md`, na ordem da Sequência, com `Status: pendente`, sem PR (aberto ou mergeado) e com todas as dependências concluídas. Registre no relatório a escolhida e as outras elegíveis. O AVANÇAR de T4 confirma a escolha.
- Nenhuma elegível: falha de P12, listando o que impede cada uma.

## Relatório (formato fixo)
```
Preflight: ok | falhou
Tarefa: <T-nn - título> (informada | proposta)
| # | Verificação | Estado | Evidência |
|---|---|---|---|
| P1 | Repositório local é o da spec | ok ou falhou | <saída resumida> |
Pendências: <nenhuma | lista do que corrigir>
Preview do card: <Parte A de move-trello-card: lista atual -> Em andamento>
```

## Regras
- Falha na base (P17) não é culpa da tarefa: pare antes de qualquer código.
- Não corrija nada por conta própria (nem `git pull`, nem trocar de branch, nem editar o `.gitignore`). Informe o que o usuário deve fazer.
- Spec em `rascunho`, PR de spec aberto (`spec/<slug>`) ou campo `a definir` nos artefatos: o problema é de quem especifica; não complete nem leia a spec de outra branch.
- `estado.json` com `estado` CONCLUIDO de outra tarefa (típico da segunda tarefa do mesmo card): P5 passa, mas o agente pergunta antes se pode descartá-lo e só segue com a palavra DESCARTAR; sem ela não sobrescreve nada. Quem preferir pode remover o arquivo à mão. Voltar à base e atualizá-la (P2, P4) continua sendo do usuário.
- Card em Done antes de todas as `T-nn` estarem integradas: P11 falha. O remédio é humano (mover o card de volta); o agente não move o card e não relaxa a regra.
- Para incluir uma verificação, acrescente a linha aqui; o orquestrador a executa sem mudança no `AGENTS.md`.
