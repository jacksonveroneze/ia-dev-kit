# Relatório: git-worktrees

Formato fixo, por parte.

## Parte A - Preview
```
Ação: <criar | listar | remover> | Repositório: <caminho>
Worktrees existentes:
| Pasta | Branch | Estado |
|---|---|---|
| <pasta> | <branch> | <limpa | mudanças não commitadas | não rastreados> |

Base: <branch> | Situação da base: <em dia | atrás do remoto em N commits | não verificável> (somente informado)
Criar: branch <tipo>/<slug> | Pasta: <caminho> | Já existe: <sim | não>
Remover: <pasta> | Será descartado: <nada | mudanças | não rastreados | commits não integrados>

Confirma <criar | remover>?
```

## Parte B - Relatório final
```
Executado: <criada | removida | nada>
Worktree: <pasta> | Branch: <branch> | Base: <branch>
Branch local apagada: <sim | não | não pedida>
Conferência: <lista relida confere | divergência: ...>
```

## Em caso de falha
```
Parcial ou não executado.
Feito: <lista> | Não feito: <lista>
Erro: <mensagem do git>
Como proceder? (não refaço sem perguntar)
```

## Ao parar
Input ausente, destino já existente, worktree suja sem confirmação específica ou sem autorização: uma linha com o que faltou; nada foi escrito.
