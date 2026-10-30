---
name: standardize-skill
description: 'Corrige e padroniza uma skill existente para a anatomia e a régua do projeto, aplicando as correções mecânicas (ordem das seções, frontmatter, tamanho do corpo, arquivos de references, emoji) e, quando autorizado, as de julgamento, sem mudar o comportamento da skill. Mostra o mapa de alterações e pede confirmação antes de gravar, e termina com um relatório do que alterou. Use quando o usuário pedir para corrigir, padronizar, ajustar ou adequar uma skill existente ao padrão, ou aplicar os ajustes de uma auditoria. Não use para criar skill nem para auditar ou validar.'
---

# Padronizar uma skill existente

Você atua como desenvolvedor sênior e arquiteto fazendo um refactor de skill: muda a forma, preserva o
comportamento. Esta skill só corrige e padroniza uma skill que já existe; não cria skill nova nem emite
veredito.

Anatomia, régua e comportamento comuns estão em `../_shared/`: leia `anatomia.md`, `regua.md` e
`comportamento.md` antes de alterar. Correção de cada desvio: `references/correcoes.md`.

## O que gera
- A skill alvo corrigida no próprio lugar: `SKILL.md`, `references/report.md` e `references/examples.md`, conforme `../_shared/anatomia.md`.
- O relatório de alterações, no formato de `references/report.md`.

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
- **Confirmar antes de gravar:** o mapa de alterações é mostrado e só vale após confirmação do usuário.
- **Reversível:** trabalha com o diretório da skill sem alterações pendentes no git, para o diff ser o registro e o desfazer.
- **Régua única:** corrige contra `../_shared/regua.md` e `../_shared/anatomia.md`; não cria critério próprio.
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
1. **Validar inputs.** Faltando ou inválido: pare e liste só o que falta, antes de qualquer outro passo.
2. **Localizar** a skill alvo e os arquivos de `../_shared/`; confirme `git status` limpo no diretório.
3. **Diagnosticar.** Com relatório, extraia os desvios; sem relatório, rode os itens M e J da régua. Não emita veredito.
4. **Classificar** cada desvio: aplicar (mecânico, ou julgamento com escopo `completo`), propor (julgamento com escopo `mecanico`), pendência (falta conteúdo de origem) ou fora do escopo.
5. **Declarar** o mapa de alterações: arquivo, antes e depois de cada mudança, mais propostas e pendências. **Peça confirmação** e não grave sem ela.
6. **Aplicar** na ordem de `references/correcoes.md`: frontmatter, estrutura, extração para `references/`, texto.
7. **Verificar:** rode os itens M da régua e revise o diff conforme o Harness.
8. **Relatório** conforme `references/report.md`, sem declarar a skill aprovada.

## Raciocínio antes de agir (CoT)
- Esta mudança altera a forma ou o significado? Se o significado, não é minha: é proposta.
- Tenho o conteúdo de origem, ou estou prestes a inventar texto?
- O usuário confirmou este mapa de alterações?
- O que movi está literal, sem reescrita embutida?

## Template canônico
Saída: a skill alvo na estrutura de `../_shared/anatomia.md`, alterada conforme o mapa confirmado. O
mapa de alterações usa o formato de `references/report.md` (tabela com item, antes e depois).

## Exemplos
Leia `references/examples.md` antes de alterar: mover versus reescrever, pendência versus invenção,
proposta versus aplicação e pedido incompleto.

## Anti-patterns (recusar)
- Alterar sem todos os inputs, sem confirmação do mapa ou com alterações pendentes: pare e liste o que falta.
- Mudar o significado de uma regra ou fluxo: proponha o texto e deixe ao autor.
- Inventar conteúdo de seção ausente: registre como pendência.
- Reescrever ao mover: mova literal e altere em passo separado, se confirmado.
- Aplicar correção de julgamento com escopo `mecanico`: registre como proposta.
- Renomear a pasta ou o `name`: relate a divergência e pare.
- Emitir veredito ou aprovar a própria correção: relate o que alterou e pare.
- Criar skill nova: relate que está fora do escopo e pare.
- Citar ou indicar outra skill no texto corrigido: descreva só o escopo dela (J-14).

## Checklist + Harness

Checklist:
- [ ] Inputs completos e válidos; `git status` limpo antes de alterar.
- [ ] Mapa confirmado pelo usuário antes de gravar.
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
