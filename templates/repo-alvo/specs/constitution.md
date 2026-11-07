# Constitution do repositório

Regras fixas deste repositório. Toda `spec.md`, `plan.md` e `tasks.md` em `specs/` herda estas regras; nenhuma pode contrariar uma delas. Regra mudou: altere este arquivo por PR próprio, com revisão humana, antes de qualquer spec que dependa da mudança. Até lá, vale o texto atual.

Valores marcados `a definir` devem ser preenchidos pelo time antes do primeiro uso pelos agentes.

## Como citar (agente de especificação e demais agentes)

- Cite pelo identificador `CONST-nnn`; nunca copie o texto da regra.
- Na `spec.md`, cite só o que for regra de negócio ou de produto (ex.: CONST-004 dados pessoais; CONST-006 rollout), em "Restrições", sem tecnologia.
- No `plan.md`, cada decisão técnica (DT-nn) que decorre de uma regra traz "Base: CONST-nnn". Cada teste planejado por CA cita CONST-003.
- No `tasks.md`, cada tarefa que aplica uma regra cita o identificador na observação; o limite de tamanho (CONST-007) decide o fatiamento.
- Conflito entre o pedido do card e uma regra: não resolva sozinho. Registre como item `a definir` com a pergunta e pare para o humano decidir (a regra vence até a decisão).
- Identificadores são estáveis: não renumere nem reaproveite. Regra aposentada fica marcada como `(aposentada)`.

## Arquitetura

- **CONST-001** Clean Architecture: `Domain` não depende de nada; `Application` depende só de `Domain`; `Infrastructure` e a camada de entrada (API, worker) dependem de `Application`. A dependência aponta sempre para dentro.
- **CONST-002** Regra de negócio vive em `Domain`/`Application`, nunca no ponto de entrada nem só no banco. Falha esperada é `Result`, não exceção. Convenções de código: `CONV-nnn` (dotnet-conventions).

## Testes

- **CONST-003** Todo critério de aceite (CA) tem ao menos um teste automatizado que o cobre, e o teste cita o CA no nome ou em comentário. Stack xUnit, Moq e Shouldly; nomes `Method_Scenario_ExpectedResult`. Tarefa sem teste passando não está pronta.

## Segurança e dados pessoais

- **CONST-004** Dado pessoal (CPF, e-mail, telefone, endereço, dados financeiros) nunca aparece em log, mensagem de erro, comentário, fixture de teste real nem exemplo de spec. Use dado sintético. Coleta nova de dado pessoal exige base legal registrada na spec (item `a definir` até o humano confirmar). Retenção: a definir.
- **CONST-005** Segredo nunca em código nem em arquivo versionado; configuração sensível vem de variável de ambiente, user-secrets ou cofre. Toda entrada externa é validada no ponto de entrada. Todo endpoint tem controle de acesso explícito.

## Rollout

- **CONST-006** Mudança de comportamento visível a usuário ou a sistema integrado entra atrás de feature flag, desligada por padrão, com plano de ativação e de reversão no `plan.md`. Mudança puramente interna (refatoração sem efeito observável) dispensa flag, com a justificativa registrada. Biblioteca de flags: a definir.

## Tamanho de PR

- **CONST-007** Um PR por tarefa (T-nn). Limite orientador: até 400 linhas de diff, até 10 arquivos, sem misturar refatoração e mudança de comportamento. Acima disso, a tarefa é dividida no `tasks.md` antes de codificar. (valores a definir pelo time)
- **CONST-008** Merge sempre humano, após revisão humana. Nenhum agente faz merge, push em `main`/`develop` ou force-push.

## Definição de pronto

- **CONST-009** Uma tarefa está pronta somente quando: build verde; testes verdes, incluindo os dos CAs da tarefa; `dotnet format --verify-no-changes` sem diferença; nenhum aviso novo; arquivos alterados iguais aos previstos na tarefa; PR descrito com os comandos realmente executados; CI verde; revisão humana aprovada.
- **CONST-010** Uma spec está pronta somente quando: todo RF tem CA; todo CA tem teste e tarefa; nenhum item `a definir` ou `(proposto, confirmar)`; `Status: aprovada`; PR dos artefatos mergeado.
