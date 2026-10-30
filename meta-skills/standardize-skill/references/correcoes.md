# Correção de cada desvio

Régua em `../../_shared/regua.md`; anatomia em `../../_shared/anatomia.md`. Aplique na ordem abaixo:
a estrutura depende do frontmatter, e a extração depende da estrutura.

## Ordem de aplicação
1. Frontmatter (M-01, M-02, M-08)
2. Estrutura e ordem das seções (M-03)
3. Pastas e extração para `references/` (M-09, M-04, M-05)
4. Texto (M-06, M-07 e, com escopo `completo`, itens J)

## Itens mecânicos (aplicados no escopo `mecanico`)

| ID | Correção | Se faltar conteúdo de origem |
|---|---|---|
| M-01 | Ajustar `name` para o nome da pasta | Pasta fora de kebab-case: parar e relatar; não renomear |
| M-02 | Reduzir a `description` ao quê e quando; remover dois-pontos e sinais de maior ou menor; manter os traços que discriminam o disparo e o "NÃO usar" | Sem "NÃO usar" na original: pendência |
| M-03 | Renomear e reordenar os headings para a ordem de `anatomia.md`; mover os blocos literalmente | Seção ausente sem conteúdo de origem: `N/A - motivo` só se o motivo é evidente; senão, pendência |
| M-04 | Mover o excesso (exemplos, tabelas longas, detalhes de stack) para `references/`, citando cada arquivo no corpo com a instrução de quando ler. Template canônico com mais de uns 25 linhas vai para `references/template.md`, mantendo a seção no corpo com o ponteiro | Corpo continua acima do limite: pendência |
| M-05 | Criar `references/examples.md` com os exemplos que já existem no corpo; criar `references/report.md` pelo modelo `modelo-report.md` | Sem exemplos de origem: pendência; não inventar |
| M-09 | Para cada arquivo de pasta fora do padrão (ex. `resources/`): lido pelo agente vai para `references/`; copiado ou preenchido na saída vai para `assets/`; executável vai para `scripts/`. Mover com `git mv` e atualizar as citações no corpo | Função do arquivo ambígua: pendência; não mover |
| M-06 | Trocar emoji e símbolos por texto ("Certo", "Errado", "Passou", "Falhou") | - |
| M-07 | Trocar nome de ferramenta de agente por verbo neutro ("pergunte ao usuário", "execute o comando") | - |
| M-08 | Corrigir frontmatter: abrir e fechar com `---`, manter só campos válidos | - |

## Itens de julgamento (escopo `completo`; senão, proposta)

| ID | Correção | Limite |
|---|---|---|
| J-02 | Passo 1 do Fluxo passa a validar inputs, parar e listar o que falta | Não criar input que a skill não declara: pendência |
| J-03 | Acrescentar a seção Relatório apontando para `references/report.md` e a regra de parada | Conteúdo do relatório sem origem: pendência |
| J-04 | Acrescentar a alternativa ao lado de cada negativa | Alternativa não derivável do texto: pendência |
| J-05, J-06 | Acrescentar a ausência e o porquê somente se o texto da skill já os sustenta | Senão, pendência |
| J-07 | Reduzir o CoT a 2 a 4 perguntas verificáveis, sem acrescentar regra nova | - |
| J-08 | Reorganizar exemplos em certo e errado | Falta pedido incompleto: pendência |
| J-09 | Reescrever a `description` como gatilho | Mudar o gatilho muda o disparo: confirmar |
| J-01, J-11 | Não corrigir: a skill pode não dever existir ou ser rule; relatar para o autor | Sempre fora do escopo |
| J-10, J-12, J-13 | Ajustar tom, harness e coerência só quando a correção é de redação | Se muda o significado: proposta |

## Limites
- Muda forma, local e redação; nunca finalidade, inputs, rules, template ou fluxo em significado.
- Conteúdo movido vai literal. Reescrita é um passo separado, listado no mapa e confirmado.
- Divergência de `name` e pasta, ou pasta fora de kebab-case: relate e pare; não renomeie.
