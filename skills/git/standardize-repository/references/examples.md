# Exemplos

Os caminhos e nomes abaixo são fictícios; nunca os copie para a execução real.

## 1. Arquivo novo

Entrada: `/work/repo-a` (repositório git, sem `CODEOWNERS`).

Plano: `repo-a | 1. CODEOWNERS | criar | cria .github/`.
Após aprovação: copia `assets/CODEOWNERS` para `/work/repo-a/.github/CODEOWNERS`.
Harness: `cmp` sem diferença; `git status --short` lista só `.github/`.

## 2. Arquivo existente substituído

Entrada: `/work/repo-b`, com `.github/CODEOWNERS` diferente do asset.

Certo: plano com `substituir`; após aprovação, o arquivo passa a ser cópia literal do asset, sem manter regras antigas.
Errado: mesclar as regras antigas com as do asset, ou anexar o conteúdo ao final. A regra local é substituição total.

## 3. CODEOWNERS fora de `.github/`

Entrada: `/work/repo-c`, com `CODEOWNERS` na raiz e nenhum em `.github/`.

Certo: cria `.github/CODEOWNERS` e relata o da raiz em "Pendências", sem tocar nele.
Errado: mover o da raiz para `.github/` ou apagá-lo. Isso excede o ajuste.

## 4. Diretório que não é repositório

Entrada: `/work/repo-a` e `/work/notas` (pasta sem `.git`).

Certo: `notas` aparece no plano como `descartado` (não é a raiz de um repositório git) e na tabela final como "não feito"; `repo-a` segue normalmente.
Errado: parar tudo por causa de `notas`, ou executar nele e criar `.github/` numa pasta qualquer.

## 5. Asset vazio

Situação: `assets/CODEOWNERS` com zero bytes.

Certo: a skill para no passo 1 e responde: "assets/CODEOWNERS está vazio; o conteúdo era esperado em assets/CODEOWNERS. Nada foi escrito."
Errado: gravar um arquivo vazio, o que apagaria o `CODEOWNERS` existente, ou preencher com owners inventados.

## 6. Input ausente

Pedido: "padronize meus repositórios", sem diretórios.

Certo: parar e responder: "Faltam os diretórios dos repositórios (lista de um ou mais caminhos locais)."
Errado: usar o diretório atual, ou procurar repositórios no disco por conta própria.

## 7. Aprovação parcial

Plano com `repo-a` (criar) e `repo-b` (substituir). Usuário responde: "aprovo, menos o repo-b".

Certo: executa só `repo-a`; no relatório final, `repo-b` aparece como "não feito: excluído pelo usuário".
Errado: executar `repo-b` assim mesmo, ou tratar "menos o repo-b" como dúvida e não executar nada.

## 8. Pergunta não é aprovação

Após o plano, o usuário pergunta: "o repo-b perde as regras antigas?"

Certo: responder que sim, a substituição é total e o anterior fica no histórico do git, e reapresentar o relatório pedindo aprovação.
Errado: entender a pergunta como "pode executar".
