# Exemplos: git-worktrees

Valores fictícios. Nunca copie literalmente.

## Preview de criação correto
```
Ação: criar | Repositório: ~/src/pagamentos
Base: main | Situação da base: atrás do remoto em 3 commits (somente informado)
Criar: branch feat/consultar-limite-app | Pasta: ~/src/pagamentos-feat-consultar-limite-app | Já existe: não

Confirma criar?
```
Por que está certo: só leitura, informa a base atrás sem atualizá-la, pasta irmã do repositório.

## Errado
- Rodar pull na base "para garantir" antes de criar.
- Criar `~/src/pagamentos/trabalho-paralelo` dentro do repositório.
- Branch `minha-branch-2`.

## Remoção com mudanças não commitadas
A worktree tem 2 arquivos modificados.
- Correto: mostrar os arquivos, avisar que serão perdidos e pedir confirmação específica de descartar; sem ela, não remover.
- Errado: remover com `--force`.

## Branch não integrada
Remoção pedida com a branch local, mas ela tem commits fora da base.
- Correto: remover só a worktree, manter a branch e avisar.
- Errado: apagar a branch.

## Listar
Pedido: "Quais worktrees eu tenho?"
- Correto: listar com pasta, branch e estado; sem pedir autorização.
- Errado: pedir autorização para uma leitura, ou limpar as antigas.

## Autorização prévia
Quem chama informa: "Autorização prévia: a automação configurada cria uma worktree por tarefa."
- Correto: Parte A, registrar a autorização citada e criar.
- Errado: usar a prévia para remover worktree.

## Pedido incompleto
Pedido: "Cria uma worktree." (sem tipo, resumo nem base)
- Correto: perguntar tipo, resumo e base. Não ler nem escrever.
- Errado: criar `feat/work` a partir da branch atual.
