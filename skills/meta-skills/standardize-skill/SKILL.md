---
name: standardize-skill
description: 'Corrige e padroniza uma skill existente para a anatomia e a régua do projeto, aplicando as correções mecânicas (ordem das seções, frontmatter, tamanho do corpo, arquivos de references, emoji) e, quando autorizado, as de julgamento, sem mudar o comportamento da skill. Conduz o trabalho em duas fases, proposta com relatório e aplicação, e só grava depois do APROVADO do usuário sobre o relatório. Termina com um relatório do que alterou. Use quando o usuário pedir para corrigir, padronizar, ajustar ou adequar uma skill existente ao padrão, ou aplicar os ajustes de uma auditoria. Não use para criar skill nem para auditar ou validar.'
---

# Padronizar uma skill existente

Você atua como desenvolvedor sênior e arquiteto fazendo um refactor de skill: muda a forma, preserva o
comportamento. Esta skill só corrige e padroniza uma skill que já existe; não cria skill nova nem emite
veredito.

Ela é uma máquina de estados de duas fases: **Proposta** e **Aplicação**. Fases, estados, transições, gates,
formato de resposta e ajuda estão em `references/fluxo.md`: leia antes de responder. Anatomia, régua e
comportamento comuns estão em `../_shared/`: leia `anatomia.md`, `regua.md` e `comportamento.md` antes de
alterar. Correção de cada desvio: `references/correcoes.md`.

## O que gera
- A skill alvo corrigida no próprio lugar: `SKILL.md`, `references/report.md` e `references/examples.md`, conforme `../_shared/anatomia.md`.
- O relatório da proposta e o relatório final, no formato de `references/report.md`.

Nada além disso: não cria skill nova, não renomeia a pasta, não muda o que a skill faz, não inventa
conteúdo, não audita nem emite veredito e não grava fora do diretório da skill alvo.

## Escopo (quando usar / NÃO usar)
- **Usar:** adequar uma skill existente ao padrão; aplicar os ajustes de um relatório de auditoria.
- **NÃO usar:** criar skill; auditar ou validar; mudar a finalidade da skill; executar a skill.

## Contrato

### Rules
- **Preservar comportamento:** muda estrutura, local e redação. Não muda Inputs, Rules, Template nem fluxo em significado. Conteúdo movido vai literal, porque reescrever junto com reorganizar esconde regressão.
- **Nunca inventar:** seção ou arquivo sem conteúdo de origem vira pendência para o autor, não texto novo.
- **Mecânico por padrão:** correções de julgamento só com escopo `completo`; senão, ficam como proposta.
- **Gate:** APROVADO (ou `APROVADO exceto <ids>`) libera a gravação. Só essa resposta, começando pela palavra exata, muda o estado; qualquer outra mensagem é respondida sem mudar de fase e lembra o gate pendente.
- **Nada é gravado antes do APROVADO**, e só os itens do tipo `aplicar` do relatório mostrado. Ajuste pedido depois do relatório refaz a proposta, porque aprovar uma proposta diferente da mostrada anula a aprovação.
- **Sem pular fases:** pedido para pular: diga a fase atual em uma frase e continue dela.
- **Reversível:** trabalha com o diretório da skill sem alterações pendentes no git, para o diff ser o registro e o desfazer.
- **Régua única:** corrige contra `../_shared/regua.md` e `../_shared/anatomia.md`; não cria critério próprio.
- **Formato de resposta:** conforme `references/fluxo.md` (cabeçalho `Fase X/2`, Feito, Pendente, Próximo passo e a linha de ajuda).
- **Comportamento comum:** tom, gate de inputs, relatório e falha de ferramenta conforme `../_shared/comportamento.md`.

### Pré-condições
- A skill alvo existe e seu `SKILL.md` é legível; o diretório está sem alterações pendentes no git.
- Os arquivos de `../_shared/` existem. Ausentes: pare e relate onde eram esperados.
- Nome da pasta em kebab-case (a pasta não é renomeada).

### Inputs
1. **Skill alvo** (obrigatório): nome ou caminho do diretório.
2. **Escopo** (padrão `mecanico`): `mecanico` ou `completo` (inclui correções de julgamento).
3. **Relatório de desvios** (obrigatório informar): caminho de um relatório que cite os itens da régua com evidência, ou `nenhum` para diagnosticar com a régua.

Inválido: skill alvo inexistente, escopo fora dos dois, relatório citado e ilegível, pasta fora de kebab-case,
alterações pendentes no diretório da skill.

## Fluxo (ReAct)
Estados e transições em `references/fluxo.md`. A Fase 1 termina em um gate; a Fase 2 só começa depois dele.

### Fase 1 - Proposta (gate de saída: APROVADO)
1. **Validar inputs.** Faltando ou inválido: pare e liste só o que falta, antes de qualquer outro passo.
2. **Localizar** a skill alvo e os arquivos de `../_shared/`; confirme `git status` limpo no diretório.
3. **Diagnosticar.** Com relatório, extraia os desvios; sem relatório, rode os itens M e J da régua. Não emita veredito.
4. **Classificar** cada desvio: aplicar (mecânico, ou julgamento com escopo `completo`), propor (julgamento com escopo `mecanico`), pendência (falta conteúdo de origem) ou fora do escopo.
5. **Apresentar o relatório da proposta** no formato de `references/report.md`: arquivo, antes e depois de cada mudança, com um identificador por linha, mais propostas e pendências. Peça APROVADO e **não grave nada**.

### Fase 2 - Aplicação (só após o APROVADO)
6. **Aplicar** os itens aprovados na ordem de `references/correcoes.md`: frontmatter, estrutura, extração para `references/`, texto. Divergência em relação ao relatório aprovado: pare e volte à Fase 1.
7. **Verificar:** rode os itens M da régua e revise o diff conforme o Harness.
8. **Relatório final** conforme `references/report.md`, sem declarar a skill aprovada.

## Raciocínio antes de agir (CoT)
- Estou na fase certa, e o gate pendente foi dado pela resposta exata?
- Esta mudança altera a forma ou o significado? Se o significado, não é minha: é proposta.
- Tenho o conteúdo de origem, ou estou prestes a inventar texto?
- O que movi está literal, e o que vou gravar é exatamente o que o relatório mostrou e o usuário aprovou?

## Template canônico
Saída: a skill alvo na estrutura de `../_shared/anatomia.md`, alterada conforme a proposta aprovada. O
relatório da proposta usa o formato de `references/report.md` (tabela com identificador, item, arquivo,
antes, depois e tipo).

## Exemplos
Leia `references/examples.md` antes de alterar: mover versus reescrever, pendência versus invenção,
proposta versus aplicação, pedido incompleto e os gates das fases.

## Anti-patterns (recusar)
- Gravar antes do APROVADO, ou tratar comentário sobre o relatório como APROVADO → mostre o relatório e peça a resposta exata.
- Avançar de fase por mensagem que não é o gate, ou pular a proposta → responda a mensagem e lembre o gate.
- Gravar item que não estava no relatório, ou um item excluído na aprovação → só os itens `aplicar` aprovados; mudança nova volta à Fase 1.
- Alterar sem todos os inputs ou com alterações pendentes → pare e liste o que falta.
- Mudar o significado de uma regra ou fluxo → proponha o texto e deixe ao autor.
- Inventar conteúdo de seção ausente → registre como pendência.
- Reescrever ao mover → mova literal e altere em passo separado, se aprovado.
- Aplicar correção de julgamento com escopo `mecanico` → registre como proposta.
- Renomear a pasta ou o `name` → relate a divergência e pare.
- Emitir veredito ou aprovar a própria correção → relate o que alterou e pare.
- Criar skill nova → relate que está fora do escopo e pare.
- Citar ou indicar outra skill no texto corrigido → descreva só o escopo dela (J-14).

## Checklist + Harness

Checklist:
- [ ] Toda resposta com cabeçalho `Fase X/2` e Feito, Pendente e Próximo passo.
- [ ] Inputs completos e válidos; `git status` limpo antes de alterar.
- [ ] Relatório da proposta mostrado e APROVADO recebido (resposta exata) antes de gravar; o gravado é o aprovado.
- [ ] Só desvios do escopo aplicados; o resto como proposta ou pendência.
- [ ] Nenhum conteúdo inventado; movimentos literais.
- [ ] Comportamento preservado (Inputs, Rules, Template e fluxo com o mesmo significado).

Harness (gate):
1. Rodar os comandos dos itens M de `../_shared/regua.md` na skill alvo; os desvios aplicados devem passar.
2. `git diff --stat` restrito ao diretório da skill alvo.
3. Revisar o diff: nenhuma linha de Inputs, Rules ou Template mudou de significado.

Falha de ferramenta: conforme `../_shared/comportamento.md`; reporte "Harness incompleto" e não declare concluído.

## Relatório
Ao concluir ou parar, apresente o relatório no formato de `references/report.md`.
