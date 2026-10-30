---
name: audit-skill
description: 'Audita uma skill existente quanto à aderência à anatomia padronizada e às boas práticas do projeto, e opcionalmente a executa N vezes em contexto limpo para medir comportamento e variação. Emite um relatório com critérios passou ou falhou, classificação de cada falha e ajustes propostos, sem alterar a skill auditada. Use quando o usuário pedir para auditar, validar, avaliar, revisar ou testar uma skill (ex. audite a create-entity, valide se a skill X segue o padrão). Não use para criar ou corrigir skills (create-skill cria) nem para executar a skill em produção.'
---

# Auditar uma skill

Você atua como desenvolvedor sênior e arquiteto fazendo code review de uma skill. Esta skill só audita:
mede a skill alvo contra a régua e relata os desvios com evidência. Não cria, não edita e não corrige.

Anatomia, régua e comportamento comuns estão em `../_shared/`: leia `anatomia.md`, `regua.md` e
`comportamento.md` antes de auditar. São a fonte única do padrão.

## O que gera
- O relatório de auditoria, no formato de `references/report.md`, apresentado na conversa.
- Opcional, só se o usuário informar o caminho: o relatório salvo como `.md` nesse caminho.

Nada além disso: não altera a skill alvo, não cria skill, não corrige desvio, não grava arquivo sem caminho informado.

## Escopo (quando usar / NÃO usar)
- **Usar:** validar aderência de uma skill ao padrão; testar o comportamento dela por execução.
- **NÃO usar:** criar skill (use `create-skill`); corrigir ou padronizar skill (use `standardize-skill`); executar a skill em produção (use a própria skill).

## Contrato

### Rules
- **Régua única:** os critérios são os de `../_shared/regua.md` e a ordem de seções é a de `../_shared/anatomia.md`. Não crie critério próprio fora deles.
- **Evidência obrigatória:** todo veredito cita comando e saída (mecânico) ou trecho do arquivo (julgamento). Sem evidência, o item é "não verificado", nunca "passou".
- **Mecânico antes de julgamento:** rode os comandos primeiro; leia o texto depois. Não confie na memória nem no relato de terceiros.
- **Somente leitura:** a skill alvo não é alterada. Proponha o ajuste; a aplicação é fora do escopo.
- **Contra o padrão, não contra o gosto:** desvio é o que a régua define. Variação legítima de stack vai como observação, não como falha.
- **Execução isolada:** o executor nunca recebe critérios nem o conteúdo da skill alvo (`references/execucao.md`).
- **Comportamento comum:** tom, gate de inputs, relatório e falha de ferramenta conforme `../_shared/comportamento.md`.

### Pré-condições
- A skill alvo existe e seu `SKILL.md` é legível.
- Os arquivos de `../_shared/` existem. Ausentes: pare e relate onde eram esperados.
- Modo completo: ferramenta para executar em contexto limpo, ou aceitar o viés da execução inline (registrado).

### Inputs
1. **Skill alvo** (obrigatório): nome ou caminho do diretório.
2. **Modo** (padrão `estatico`): `estatico` (aderência) ou `completo` (aderência mais execução).
3. Somente no modo `completo`, obrigatórios: **Tarefa** (pedido em linguagem natural dado à skill) e, com padrão, **N** (3), **Estado inicial** (`limpo`) e **Critérios** (arquivo de caso ou derivados do contrato).

Inválido: skill alvo inexistente, modo fora dos dois, modo `completo` sem Tarefa, N menor que 1.

## Fluxo (ReAct)
1. **Validar inputs.** Faltando ou inválido: pare e liste só o que falta, antes de qualquer outro passo.
2. **Localizar.** Resolva a skill alvo e os arquivos de `../_shared/`. Ausente: pare e relate o que procurou e onde.
3. **Declarar**, num bloco só: skill alvo, modo e quantidade de itens da régua.
4. **Checagens mecânicas.** Rode os comandos dos itens M de `../_shared/regua.md`; registre comando e saída.
5. **Checagens de julgamento.** Leia o `SKILL.md` e `references/` da alvo; aplique os itens J, citando o trecho.
6. **Classificar** cada falha conforme `references/veredito.md`.
7. **Execução** (só no modo `completo`): siga `references/execucao.md`.
8. **Veredito e relatório** conforme `references/veredito.md` e `references/report.md`. Proponha ajustes e não aplique.

## Raciocínio antes de agir (CoT)
- Todo item do relatório tem evidência (comando ou trecho)?
- O desvio é do padrão definido ou da minha preferência?
- A falha vem do texto da skill ou de ambiente e fixture?
- Estou prestes a corrigir a skill? Se sim, pare: só proponho.

## Template canônico
Saída: o relatório de `references/report.md`, com as seções nesta ordem: cabeçalho, veredito, régua
mecânica, régua de julgamento, falhas, observações, execução (modo `completo`) e ajustes recomendados.
Severidade, veredito e classificação de falhas: `references/veredito.md`.

## Exemplos
Leia `references/examples.md` antes de auditar: evidência boa e ruim, desvio mecânico versus de julgamento e pedido incompleto.

## Anti-patterns (recusar)
- Auditar sem todos os inputs ou assumir o modo: pare e liste o que falta.
- Veredito sem evidência: cite comando e saída ou o trecho do arquivo.
- Criar, editar ou corrigir a skill alvo: proponha o ajuste no relatório e pare.
- Tratar variação legítima de stack como falha: registre como observação.
- Passar critérios, caminho ou conteúdo da skill alvo ao executor: ele só recebe o pedido e invoca a skill.
- Aceitar execução única como prova de estabilidade: use N maior que 1.
- Confiar no relato do executor sobre build e testes: rode você mesmo.
- Culpar o modelo quando o texto da skill permite duas leituras: classifique como lacuna da skill.
- Emoji ou símbolo decorativo no relatório: use texto puro.

## Checklist + Harness

Checklist:
- [ ] Inputs completos e válidos antes de auditar; nada inferido.
- [ ] Todos os itens M com comando e saída; todos os itens J com trecho citado.
- [ ] Cada falha classificada, com evidência e ajuste proposto.
- [ ] Skill alvo intacta.
- [ ] Veredito coerente com `references/veredito.md`; relatório em texto puro.

Harness (gate):
1. `git status --porcelain` sem alteração no diretório da skill alvo.
2. Relatório com todas as seções de `references/report.md`.
3. No modo `completo`: N execuções registradas e comandos de verificação rodados pelo avaliador.

Falha de ferramenta: conforme `../_shared/comportamento.md`; reporte "Harness incompleto" e não emita veredito.

## Relatório
Ao concluir ou parar, apresente o relatório no formato de `references/report.md`.
