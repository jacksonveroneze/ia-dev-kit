# Relatório (formato)

Apresentado em dois momentos: o relatório de plano (Fase 0, antes de qualquer escrita) e o relatório final
(ao concluir). Uma tabela por momento, uma linha por repositório e por tarefa.

## Relatório de plano

Comece pela visão geral: quantos repositórios válidos, quantos descartados, quantas ações de criar,
substituir e nada a fazer. Depois a tabela.

| Repositório | Tarefa | Ação prevista | Observação |
|---|---|---|---|
| {Repo} | 1. CODEOWNERS | criar, substituir ou nada a fazer | {pendência, se houver} |
| {RepoDescartado} | todas | descartado | {motivo: não existe, não é a raiz de um repositório git, sem permissão de escrita, duplicado} |

Termine pedindo a aprovação explícita e informando que linhas podem ser excluídas.

## Relatório final

| Repositório | Tarefa | Resultado | Detalhe |
|---|---|---|---|
| {Repo} | 1. CODEOWNERS | feito, não feito ou nada a fazer | {caminho gravado, ou o motivo de não ter feito} |

Em seguida:

| Item | Resultado |
|---|---|
| Não feito | {repositórios descartados, linhas excluídas pelo usuário e falhas, cada um com o motivo} |
| Pendências | {`CODEOWNERS` encontrado na raiz ou em `docs/`, com o caminho} |
| Verificação | {comandos do Harness e resultado, ou "Harness incompleto" e o motivo} |

Ao parar (asset vazio ou ausente, lista de diretórios ausente), troque as tabelas por uma linha: o que
faltou e onde era esperado. Nada foi escrito.
