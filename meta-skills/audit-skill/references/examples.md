# Exemplos (certo e errado)

Exemplos de apoio do `SKILL.md`. Em conflito com o Template canônico, o Template vence.

## Evidência de item mecânico

Certo:
```
M-04  FALHOU  wc -l create-entity/SKILL.md -> 187 (limite 150). Ajuste: mover Exemplos para references/.
```

Errado:
```
M-04  FALHOU  A skill parece longa.
```

Diferença: sem comando e saída, o item não é verificável nem reproduzível.

## Evidência de item de julgamento

Certo:
```
J-02  FALHOU  Fluxo, passo 1: "reúna as informações e assuma valores razoáveis".
              Permite inferir input faltante. Ajuste: parar e listar só o que falta.
```

Errado:
```
J-02  FALHOU  O gate de inputs é fraco.
```

Diferença: sem o trecho citado e o ajuste, o autor da skill não sabe o que mudar.

## Desvio versus observação

Certo: skill usa `resources/` no lugar de `references/` e tem "Rules desta skill". Classificação:
desvio mecânico (M-05), com ajuste proposto, porque a anatomia padroniza `references/`.

Certo: skill de stack Java cita comandos Maven no Harness. Classificação: observação, pois a
anatomia é agnóstica de stack e exige apenas um gate executável (J-12).

Errado: reprovar a skill Java por não usar `dotnet build`.

## Não corrigir durante a auditoria

Certo: "M-03 FALHOU: seção Relatório ausente. Ajuste proposto: acrescentar `## Relatório` apontando para
`references/report.md`." A auditoria termina no relatório; a aplicação do ajuste é fora do escopo.

Errado: abrir o `SKILL.md` alvo e inserir a seção durante a auditoria.

## Pedido incompleto

Pedido: "Audite a skill de repositório."

Certo: parar e listar o que falta. A skill alvo é ambígua (quais skills de repositório existem?) e o modo
não foi informado se o usuário quer também a execução. Nada é auditado.

Errado: escolher uma skill, assumir o modo `completo` e rodar três execuções.

## Variação entre execuções (modo completo)

Certo: em 3 execuções, uma aplicou `Trim` no valor e duas não. Todas passaram nos critérios. Veredito:
aprovada com ressalvas, porque a decisão é solta na skill. Ajuste proposto: fixar no texto se há `Trim`.

Errado: declarar aprovada porque todas passaram, ignorando a variação.
