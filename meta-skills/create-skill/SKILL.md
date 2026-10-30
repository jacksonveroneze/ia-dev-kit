---
name: create-skill
description: 'Cria uma nova skill para agentes de código (Claude, Devin e afins), em qualquer stack, seguindo a anatomia padronizada e a mesma ordem de seções em todas. Cada skill criada valida os inputs antes de agir, para e lista o que falta, e termina com um relatório do que executou. Use sempre que o usuário pedir para criar uma skill, documentar um procedimento reutilizável para o agente, ou transformar uma correção recorrente em skill; e em dúvida entre skill e rule. Não use para auditar ou editar skill existente (audit-skill audita), nem para executar uma skill, nem para escrever regras invariantes permanentes.'
---

# Meta-skill: criação de skills

Você atua como desenvolvedor sênior e arquiteto de software que escreve procedimentos para outros
agentes executarem. Uma skill captura a distância entre o que um agente produz por padrão e o que este
projeto exige. Esta skill só cria; não audita nem edita.

Anatomia, régua e comportamento comuns estão em `../_shared/`: leia `anatomia.md`, `comportamento.md` e
`regua.md` antes de escrever. Eles são a fonte única e valem para toda skill criada.

## O que gera
- `{skills-dir}/{name}/SKILL.md`, `references/report.md` e `references/examples.md`, conforme `../_shared/anatomia.md`.
- Opcionais: `references/stack-{nome}.md`, `scripts/`.

Nada além disso: não executa a skill criada, não a registra em ferramenta, não instala dependências, não
audita (a auditoria é da `audit-skill`) e não altera skill existente.

## Escopo (quando usar / NÃO usar)
- **Usar:** criar uma skill nova; decidir entre skill e rule antes de escrever.
- **NÃO usar:** auditar ou revisar skill existente (use `audit-skill`); corrigir ou padronizar skill existente (use `standardize-skill`); executar uma skill (use a própria skill); escrever invariante permanente ("nunca X", "toda classe Y deve Z"), que é rule e vai para o arquivo de instruções permanentes do projeto (`AGENTS.md`, `CLAUDE.md` ou equivalente).

## Contrato

### Rules
- **Teste da distância:** aplique o de `../_shared/anatomia.md`. Reprovando, não crie.
- **Skill ou rule:** procedimento ("para montar Y") é skill e custa contexto só quando dispara. Invariante ("nunca X") é rule, fica sempre em contexto e por isso é curta e negativa. Invariante escrita como skill nunca carrega quando importa.
- **Conformidade:** a skill criada cumpre `../_shared/regua.md` (itens M e J) e `../_shared/comportamento.md`.
- **Gate de inputs:** conforme `../_shared/comportamento.md`; sem todos os inputs, não escreve nada.
- **Conteúdo do projeto:** vem do código, das correções e das convenções (ver Fonte da verdade em `comportamento.md`).

### Pré-condições
- Tipo definido (gerador, transformador ou auditor; ver `anatomia.md`).
- Diretório de destino conhecido e gravável, e skill de mesmo nome inexistente.
- Skill nascida de correção em sessão exige contexto íntegro. Com sessão compactada, não crie agora e registre como pendente; se a tarefa não coube num contexto, quebre a tarefa antes.

### Inputs (todos obrigatórios)
1. Nome (kebab-case) e diretório de destino.
2. Tipo: gerador, transformador ou auditor.
3. Objetivo em uma frase e gatilho (quando dispara, quando não dispara, skill irmã que assume o resto).
4. Inputs que a skill criada exigirá do usuário, com o formato de cada um.
5. Saída esperada: artefatos, caminhos e convenções de nome.
6. Fonte do conteúdo: convenções, código de referência ou a correção da sessão.
7. Comandos de verificação (build, teste, lint) ou "nenhum", com o motivo.

Inválido: nome fora de kebab-case, tipo fora dos três, gatilho sem "NÃO usar", fonte inexistente, skill sem
inputs definidos, ou pedido que o teste da distância reprova.

## Fluxo (ReAct)
1. **Validar inputs.** Faltando ou inválido algum: pare e liste só o que falta, antes de qualquer outro passo.
2. **Triar.** Aplique o teste da distância e a decisão skill ou rule. Sendo rule, pare e relate com a justificativa.
3. **Observar.** Leia a fonte. Se vem de correção: o que o agente fez, o que o projeto exigia e por quê. O erro típico é excesso, o agente anexa responsabilidades que a arquitetura já absorve noutro lugar. Nomeie as anexações.
4. **Declarar**, num bloco só, antes de escrever: nome, caminho, tipo, gatilho, inputs da skill, seções `N/A`, comandos de verificação. Em skill transformadora ou destrutiva, peça confirmação do bloco.
5. **Checar existência.** Skill já existente: pare e relate; esta skill não altera skill existente.
6. **Escrever** pela estrutura de `../_shared/anatomia.md`, com `references/examples.md` e `references/report.md`.
7. **Verificar** pelo Checklist e pelo Harness; só então relate.

## Raciocínio antes de agir (CoT)
- Todos os inputs vieram do usuário, sem eu preencher nada por conveniência?
- O agente produziria isso sozinho? Se sim, o que a skill acrescenta?
- É procedimento (skill) ou invariante (rule)?
- A skill que vou escrever para e lista o que falta quando falta input?

## Template canônico
Saída: a skill na estrutura e na ordem de seções de `../_shared/anatomia.md` (bloco "Estrutura do
`SKILL.md`"), com `{Placeholders}` resolvidos pelos inputs. O `references/report.md` da skill segue o modelo
de `../_shared/modelo-report.md`.

## Exemplos
Leia `references/examples.md` antes de escrever: gate de inputs bem e mal escrito, pedido incompleto,
negativa com e sem alternativa, `description` como gatilho e seção `N/A`.

## Anti-patterns (recusar)
- Escrever sem todos os inputs ou preencher o que falta por conta própria: pare e liste o que falta.
- Auditar, corrigir ou editar skill existente: indique `audit-skill` (auditar) ou `standardize-skill` (corrigir); não altere.
- Skill sem `references/report.md` ou `references/examples.md`: crie os dois.
- Skill de boas práticas genéricas: reprovada no teste da distância, não crie.
- Invariante escrita como skill: mova para o arquivo de regras permanentes do projeto.
- Seções fora de ordem, renomeadas ou omitidas sem `N/A - motivo`: siga `../_shared/anatomia.md`.
- Criar a skill a partir de contexto compactado: registre como pendente.
- Violar qualquer item de `../_shared/regua.md` (emoji, corpo acima de 150 linhas, negativa sem alternativa, tom informal): corrija antes de relatar.

## Checklist + Harness

Checklist:
- [ ] Todos os inputs informados e válidos antes de qualquer escrita; nada inferido.
- [ ] Passou no teste da distância e é skill, não rule.
- [ ] Skill nova: o diretório de destino não continha skill de mesmo nome.
- [ ] Skill gerada cumpre os itens J de `../_shared/regua.md`.
- [ ] Nada fora do escopo foi criado ou alterado.

Harness (gate):
1. Rodar os comandos dos itens M de `../_shared/regua.md` na skill criada; todos devem passar.
2. Conferir que `references/report.md` e `references/examples.md` existem e estão citados.

Falha de ferramenta: conforme `../_shared/comportamento.md` ("Harness incompleto"). Para validar a skill
de forma independente, indique a `audit-skill`; esta skill não se autoaudita.

## Relatório
Ao concluir ou parar, apresente o relatório no formato de `references/report.md`.
