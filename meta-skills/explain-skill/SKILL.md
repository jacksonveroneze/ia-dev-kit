---
name: explain-skill
description: 'Lê uma skill existente e explica de forma compacta o que ela faz e o que não faz, em uma tabela curta, e gera um código de exemplo fictício, derivado do Template e dos Exemplos dela, para mostrar como ela constrói o resultado. Somente leitura, não executa a skill e não emite veredito. Use quando o usuário pedir para entender, explicar, resumir ou mostrar como uma skill funciona ou o que ela gera. Não use para criar, corrigir ou auditar skills, nem para executar a skill.'
---

# Explicar uma skill

Você atua como desenvolvedor sênior e arquiteto explicando uma skill a um colega: curto, factual e com a
fonte de cada afirmação. Esta skill só lê e explica; não cria, não corrige, não avalia e não executa.

Comportamento comum (tom, gate de inputs, relatório e falha de ferramenta): `../_shared/comportamento.md`.

## O que gera
- A explicação, no formato de `references/report.md`, apresentada na conversa: uma tabela curta e um exemplo de código fictício.
- Opcional, só se o usuário informar o caminho: a mesma saída salva como `.md` nesse caminho.

Nada além disso: não altera a skill alvo, não a executa, não grava no projeto, não compila o exemplo.

## Escopo (quando usar / NÃO usar)
- **Usar:** entender o que uma skill faz e não faz, e ver como ela constrói o resultado com um caso mínimo.
- **NÃO usar:** criar, corrigir ou auditar skill; executar a skill; avaliar a qualidade dela.

## Contrato

### Rules
- **Somente leitura:** a única escrita possível é a saída no caminho informado, fora do diretório da skill alvo.
- **Fonte única:** cada célula vem do `SKILL.md` ou de `references/` da skill alvo, com a seção de origem. O que o texto não define fica como "não definido na skill"; nada é inferido, porque a explicação serve para entender a skill como ela é.
- **Compacto:** até 7 linhas na tabela, uma frase por célula, no máximo 3 itens em "Faz" e em "Não faz".
- **Exemplo derivado:** vem do Template e dos Exemplos da skill, com valores fictícios, rotulado `EXEMPLO (fictício)`, no caso mínimo (um método, um campo, um arquivo). Sem Template nem Exemplo de origem, a saída diz "exemplo não gerado: sem Template ou Exemplo de origem".
- **Sem veredito:** descreve fatos; não opina sobre qualidade nem aderência.
- **Exemplo não validado:** não compila nem executa; a saída diz isso.

### Pré-condições
A skill alvo existe e seu `SKILL.md` é legível; `references/` é lido quando existir.

### Inputs (obrigatório: Skill alvo; os demais têm padrão)
1. **Skill alvo** — nome ou caminho do diretório.
2. **Cenário** — pedido fictício em uma frase para o exemplo. Padrão: o primeiro exemplo certo da própria skill.
3. **Caminho de saída** — onde salvar a saída em `.md`. Padrão: só apresentar.

Inválido: skill alvo inexistente ou sem `SKILL.md` legível; cenário que a skill não atende (relate "fora do
escopo da skill"); caminho de saída dentro do diretório da skill alvo.

## Fluxo (ReAct)
1. **Validar inputs.** Faltando ou inválido: pare, liste só o que falta e não escreva nada.
2. **Ler** o `SKILL.md` e os arquivos de `references/` da skill alvo (Template e Exemplos incluídos).
3. **Extrair** tipo, o que faz, o que não faz, entradas, saída, quando para e como verifica, cada um com a seção de origem.
4. **Declarar**, num bloco só: skill alvo, cenário e fontes lidas.
5. **Montar o exemplo:** parta do Template, resolva os placeholders com os valores fictícios do cenário ou dos Exemplos, e mapeie cada trecho relevante à regra de origem.
6. **Verificar** pelo Checklist e pelo Harness.
7. **Apresentar** a saída no formato de `references/report.md`.

## Raciocínio antes de agir (CoT)
- Cada célula da tabela tem fonte na skill, ou estou inferindo?
- O exemplo usa só o que o Template e os Exemplos da skill mostram?
- O exemplo violaria algum Anti-pattern da própria skill?
- A saída cabe em uma tela?

## Template canônico
Saída: a explicação de `references/report.md`, com as seções nesta ordem: cabeçalho, tabela (campo,
conteúdo, fonte), exemplo fictício, legenda (trecho e origem) e nota de validação.

## Exemplos
Leia `references/examples.md` antes de explicar: célula com fonte e sem fonte, exemplo derivado e inventado,
skill sem Template e pedido incompleto.

## Anti-patterns (recusar)
- Preencher a tabela com o que a skill "provavelmente faz" → cite a seção ou escreva "não definido na skill".
- Exemplo com estrutura que o Template não tem → derive do Template e dos Exemplos da skill.
- Exemplo longo ou com vários casos → caso mínimo.
- Opinar sobre qualidade ou propor melhorias → descreva fatos, sem veredito.
- Executar a skill ou gravar no projeto → só leitura; saída apenas no caminho informado.
- Placeholder literal no exemplo → resolva com valores fictícios e rotule `EXEMPLO (fictício)`.
- Indicar outra skill como alternativa → relate só o que a skill alvo diz.
- Célula longa ou mais de 7 linhas → uma frase por célula e só o essencial.
- Emoji ou símbolo decorativo → texto puro.
- Rodar sem skill alvo → pare e liste o que falta.

## Checklist + Harness

Checklist:
- [ ] Skill alvo informada e legível; nada inferido.
- [ ] Toda célula tem a seção de origem ou "não definido na skill".
- [ ] Tabela com até 7 linhas; "Faz" e "Não faz" com até 3 itens.
- [ ] Exemplo derivado do Template e dos Exemplos, rotulado fictício, caso mínimo, sem placeholder literal.
- [ ] O exemplo não viola os Anti-patterns da skill alvo.
- [ ] Skill alvo intacta; nada gravado no projeto.

Harness (gate):
1. `git status --porcelain` sem alteração no diretório da skill alvo nem no projeto (exceto o caminho de saída informado).
2. Nenhum `{Placeholder}` no exemplo gerado (ex. `grep -nE '\{[A-Za-z]+\}'` na saída, ignorando interpolação da própria linguagem).
3. Tabela com no máximo 7 linhas.

Falha de ferramenta: conforme `../_shared/comportamento.md`; reporte "Harness incompleto" e não conclua.

## Relatório
Ao concluir ou parar, apresente a saída no formato de `references/report.md`.
