## Contexto
<!-- Por que esta mudança existe. Card, spec e tarefa de origem. -->

## O que muda
<!-- Lista curta, uma linha por mudança. -->
-

## Como testar
<!-- Comandos executados e resultado real. Não afirme o que não rodou; escreva "não informados". -->
```
dotnet build   # a definir
dotnet test    # a definir
dotnet format --verify-no-changes   # a definir
```

## Link de origem
<!-- Link do card do Trello e, se houver, specs/<card-id>-<slug>/ e a tarefa T-nn. -->

## Checklist
- [ ] Título no padrão Conventional Commits: `<tipo>(<escopo>): <descrição no imperativo>`, até 72 caracteres
- [ ] Critérios de aceite (CA-nn) atendidos, cada um com teste passando
- [ ] Build, testes e `dotnet format --verify-no-changes` verdes
- [ ] Sem segredo, token ou dado pessoal no diff nem nos logs
- [ ] Mudança de comportamento protegida por feature flag (CONST-006), ou justificativa registrada
- [ ] Apenas os arquivos previstos na tarefa; PR dentro do limite de tamanho (CONST-007)
- [ ] Revisão humana solicitada; merge feito por humano
