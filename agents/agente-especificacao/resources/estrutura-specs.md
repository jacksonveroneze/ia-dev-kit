# Estrutura dos artefatos (SDD)

Fonte única do formato e da localização dos artefatos. Os modelos de cada arquivo ficam em `references/template.md` da skill que o gera.

## Localização

```
specs/
  <card-id>-<slug>/
    spec.md      o quê e por quê (negócio e critérios)
    plan.md      como (abordagem, arquivos, contrato, testes, comandos, rollout)
    tasks.md     tarefas do tamanho de um PR, com os arquivos de cada uma
```

- `<card-id>`: código curto do card no link do Trello (a parte depois de `/c/`).
- `<slug>`: título do card em minúsculas, hífens, até 5 palavras.
- Os três arquivos nascem juntos, no mesmo PR, e só depois de `APROVAR ARTEFATOS`.

## Rascunhos e estado (arquivos de trabalho)

`estado.json` e `rascunho/` ficam na raiz do repositório, fora do versionamento (`.gitignore`). `rascunho/` guarda `spec.md`, `plan.md` e `tasks.md` em refinamento, para a sessão poder ser retomada. Nunca entram em commit nem em PR.

## Cabeçalho comum

Os três arquivos começam com:

```
Card: <link> | Repositório: <org/repo> | Base: <branch>
Status: rascunho | aprovada
```

`Status: aprovada` só é gravado na Parte B de `generate-spec-artifacts`. A spec só vale para codificar depois que o PR dos artefatos é mergeado na branch base; o agente de desenvolvimento confere isso no preflight dele.

## Identificadores e rastreabilidade

| Prefixo | Onde nasce | Significa |
|---|---|---|
| `RF-nn` | spec.md | requisito funcional |
| `CA-nn` | spec.md | critério de aceite (Dado, Quando, Então) |
| `DT-nn` | plan.md | decisão técnica |
| `T-nn` | tasks.md | tarefa (um PR) |

Os identificadores são estáveis: nunca reaproveite nem renumere um `RF`, `CA`, `DT` ou `T` já aprovado. Cadeia obrigatória: todo `RF` tem ao menos um `CA`; todo `CA` tem ao menos um teste no plano e ao menos uma tarefa; todo arquivo do plano aparece em exatamente uma tarefa.

## Item pendente

Dado que o card, o código ou o usuário não trouxeram é escrito como `a definir`, com a pergunta que o resolve. `(proposto, confirmar)` marca uma sugestão ainda não aceita pelo usuário. Os dois bloqueiam a aprovação do arquivo.

## Separação de papéis

- `spec.md` não cita tecnologia, classe, arquivo nem endpoint.
- `plan.md` não cria nem muda requisito: se precisar, volta para a spec (VOLTAR).
- `tasks.md` não decide arquitetura: só fatia o que o plano definiu.

## Constitution

`specs/constitution.md` do repositório-alvo (modelo em `templates/repo-alvo/specs/constitution.md`) traz as regras fixas `CONST-nnn`. É opcional para o agente iniciar, mas obrigatório como guia quando existe (CONV-020).

| Situação | Comportamento |
|---|---|
| Ausente | Aviso no preflight (P12), sem bloquear. O orquestrador informa `constitution: ausente` ao `context-explorer`, que registra em `Lacunas`. |
| Existente | O `context-explorer` recebe o caminho como guia do repositório e devolve as regras relevantes. O orquestrador repassa as `CONST-nnn` aplicáveis às skills de rascunho. |

Onde citar (pelo identificador, nunca copiando o texto da regra):

| Arquivo | Onde |
|---|---|
| `spec.md` | seção Restrições, só regra de negócio ou de produto, sem tecnologia |
| `plan.md` | `Base: CONST-nnn` em cada DT que decorre de uma regra |
| `tasks.md` | observação da tarefa que aplica a regra |

Conflito entre o card e uma regra: item `a definir` com a pergunta (CONV-004); a regra vale até o humano decidir e o rascunho não é aprovado enquanto o item existir. Regra marcada `(aposentada)` não é citada. Se o arquivo tiver valor `a definir`, o agente o repassa como pendência, nunca o preenche.
