# Tarefas

Fonte única do que a skill faz em cada repositório. As tarefas rodam na ordem numérica. Cada tarefa tem
"Levantar" (somente leitura, na Fase 0) e "Executar" (escrita, na Fase 1, após a aprovação). Para incluir
uma tarefa, acrescente uma seção ao final com o próximo número, o asset que ela usa (se houver),
"Levantar", "Executar" e "Verificar", e liste-a na tabela abaixo.

| # | Tarefa | Asset | Destino em `{Repo}` |
|---|---|---|---|
| 1 | CODEOWNERS | `assets/CODEOWNERS` | `.github/CODEOWNERS` |

`{Repo}` é o diretório do repositório informado pelo usuário.

## 1. CODEOWNERS

Define os responsáveis pelo código no GitHub. O arquivo do repositório passa a ser exatamente o do asset.

**Pré-condição da tarefa.** `assets/CODEOWNERS` existe e tem conteúdo (`test -s`). Vazio ou ausente: pare antes de qualquer escrita e relate; o conteúdo é definido pelo mantenedor da skill, nunca por você.

**Levantar** (somente leitura)
1. Procure `CODEOWNERS` por nome apenas em três locais de `{Repo}`: `.github/CODEOWNERS`, `CODEOWNERS` (raiz) e `docs/CODEOWNERS`. Não faça busca recursiva.
2. Classifique o destino `.github/CODEOWNERS`:
   - **Ausente:** ação "criar" (e criar `.github/` se faltar).
   - **Presente e idêntico ao asset (`cmp`):** ação "nada a fazer".
   - **Presente e diferente:** ação "substituir".
3. Registre `CODEOWNERS` encontrado na raiz ou em `docs/` como pendência: não é movido nem removido. Motivo: o GitHub dá precedência ao de `.github/`, mas remover o outro excede o ajuste e o usuário decide.

**Executar** (após a aprovação)
1. Crie `{Repo}/.github/` se não existir.
2. Copie `assets/CODEOWNERS` para `{Repo}/.github/CODEOWNERS`, sobrescrevendo o existente. Cópia literal: não edite, não mescle, não troque finais de linha.
3. Não faça `git add` nem commit.

**Verificar**
- `cmp {Repo}/.github/CODEOWNERS assets/CODEOWNERS` sem diferença.

**Não faz:** mesclar regras, validar owners ou sintaxe junto ao GitHub, mover ou remover `CODEOWNERS` da raiz ou de `docs/`.
