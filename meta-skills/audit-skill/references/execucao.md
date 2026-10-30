# Auditoria de execução (modo completo)

Mede o comportamento da skill alvo, não só o texto. Rode depois das checagens da régua.

Princípio: o prompt do teste não dita o que a skill deve decidir (caminho, nome do tipo, namespace,
códigos de erro, tipo de retorno). Se ditasse, o teste mediria obediência ao prompt, não a skill.

## Regras do executor (injetadas literalmente em toda execução)

```
Use a skill {skill}. {tarefa}

Regras:
- Invoque a skill pelo mecanismo de skills do agente, como faria normalmente. Não leia o
  arquivo da skill com leitura de arquivo, cat ou similar.
- Não pergunte nada. Se faltar informação que a skill não resolve sozinha, pare e relate o
  que era esperado e onde.
- Não crie nem altere nada fora do escopo da skill.
- Antes de escrever, declare o que a skill manda resolver (ex. nome, caminho, namespace,
  se o artefato já existe).

Ao final, informe: valores resolvidos, arquivos criados ou reaproveitados, o resultado do
harness da skill e cada decisão tomada sem respaldo explícito na skill.
```

Adapte só o trecho "declare" ao que a skill alvo resolve. Nunca acrescente dica de como resolver.

## Como a skill alvo é invocada
- O executor invoca a skill pelo mecanismo de skills, como numa sessão real. Isso testa também se a `description` dispara a skill e se o conteúdo carregado basta.
- O avaliador nunca cola o conteúdo da skill alvo no prompt nem indica o caminho do arquivo.
- Skill ausente da lista do executor ou chamada falha: a auditoria para e relata (não instalada, nome errado ou sem permissão). Sem fallback de ler o arquivo, que mascararia o problema de descoberta.

## Fluxo
1. **Extrair o contrato** da skill alvo: rules, inputs, o que ela resolve sozinha, checklist, harness, anti-patterns e **lacunas** (decisões plausíveis que o texto não fixa).
2. **Montar os critérios** em quatro grupos, cada item `determinístico` ou `julgamento`: Fluxo (invocou pelo mecanismo, declarou antes de escrever, checou duplicidade, não perguntou), Estrutura (arquivo, caminho, namespace, modificadores, proibições), Comportamento (o que o artefato faz conforme o contrato) e Harness. Critério que o contrato não sustenta vira "fora do contrato" e é lacuna da skill, não falha do modelo.
3. **Preparar o estado** antes de cada execução. Prefira isolamento por worktree; sem ele, restaure o estado limpo entre execuções.
4. **Executar N vezes**, cada uma em contexto limpo. O executor não recebe critérios nem este arquivo. Em sequência se compartilharem pastas; em paralelo só com worktrees isoladas. Sem subagente, execute inline e registre o viés.
5. **Coletar evidências:** transcript final; chamadas de ferramenta (a skill foi invocada pelo mecanismo e o arquivo dela não foi lido); `git status --porcelain` e diff; comandos de verificação **rodados pelo avaliador**.
6. **Checagens determinísticas** por comando; **de julgamento** pelo transcript, com o trecho citado.
7. **Classificar** cada falha conforme `veredito.md`; na execução, também: erro do modelo (a instrução era clara e foi ignorada).
8. **Comparar as N execuções:** decisão que varia entre execuções é decisão solta na skill, mesmo que todas passem.

## Cenários de borda (bateria completa, quando pedido)
- Artefato já existe: esperado parar e relatar, sem sobrescrever.
- Input incompleto: esperado parar e listar o que faltou e onde, sem perguntar e sem inventar.
- Pedido fora do escopo: esperado recusar e relatar que está fora do escopo, sem indicar outra skill.

## Arquivo de caso (opcional)
`tests/{skill}/case-NN.md` com tarefa, estado inicial, critérios e, opcionalmente, testes de contrato a
copiar **após** a execução. Sem arquivo de caso, use os critérios derivados e sugira salvá-los como `case-01.md`.

## Veredito da execução
Conforme `veredito.md` (seção "Veredito da execução").
