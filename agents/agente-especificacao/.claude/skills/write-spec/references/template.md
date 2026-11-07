# Template canônico: spec

Molde do rascunho. Em conflito com os Exemplos, o Template vence. Placeholders recebem o conteúdo real; nunca copie literalmente. Seção sem conteúdo fica com `nenhum` ou com `a definir` e a pergunta.

```
# Spec: {título da story}
Card: {link} | Repositório: {org/repo} | Base: {branch}
Status: rascunho

## Contexto e problema
{por que a mudança existe, em 2 a 4 frases, com origem na story ou no contexto}

## Objetivo
{resultado esperado em 1 frase}

## Escopo
- Dentro: {lista}
- Fora de escopo: {lista}

## Requisitos funcionais
- RF-01: {o sistema deve ...}
- RF-02: ...

## Critérios de aceite
- CA-01 (RF-01): Dado {contexto}, quando {ação}, então {resultado observável}.
- CA-02 (RF-02): ...

## Regras de negócio e validações
- {regra, com valor ou limite concreto quando existir}

## Erros esperados
- {situação} -> {resultado para quem usa}

## Restrições e segurança
- {dados pessoais, autorização, desempenho, prazos, termos técnicos impostos}

## Dependências
- {story ou sistema; ou nenhuma}

## Perguntas em aberto
- a definir: {pergunta} (afeta {RF ou CA})
- (proposto, confirmar): {sugestão} (afeta {RF ou CA})
```

O relatório acompanha o rascunho (ver `report.md`).
