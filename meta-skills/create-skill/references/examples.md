# Exemplos (certo e errado)

Exemplos de apoio do `SKILL.md`. Em conflito com o Template canônico, o Template vence.

## Gate de inputs no passo 1 do Fluxo da skill gerada

Certo:
```
1. Validar inputs. Falta algum: pare, liste só o que falta e onde era esperado, e não escreva nada.
   Nunca infira diretório, tipo ou dependência; nunca use valor de exemplo.
```

Errado:
```
1. Reúna as informações e, se necessário, assuma valores razoáveis.
```

Diferença: assumir valores faz o agente criar o artefato no lugar errado e parecer que deu certo.

## Pedido incompleto

Pedido: "Crie uma skill para gerar controllers."

Certo: a meta-skill para e lista o que falta, sem escrever nada:
- diretório de destino e nome da skill;
- tipo (gerador, transformador ou auditor);
- gatilho, com o "NÃO usar" (o que fica de fora);
- inputs que a skill exigirá do usuário;
- saída esperada (artefatos e caminhos);
- fonte do conteúdo (convenções ou código de referência);
- comandos de verificação.

Errado: escolher a pasta, supor o framework e escrever uma skill genérica.

## Negativa com e sem alternativa

Certo:
```
Não deduza o tipo de retorno a partir da dependência. Use o Retorno informado pelo usuário, porque o
tipo mapeado é decisão de contrato, não detalhe de implementação.
```

Errado:
```
Não deduza o tipo de retorno.
```

Diferença: sem a alternativa, o modelo escolhe a segunda opção mais provável, em geral tão ruim quanto a primeira.

## Description como gatilho

Certo: "Cria o repositório externo (.NET) a partir de métodos descritos que delegam a uma dependência.
Use quando o usuário pedir um repositório sem EF Core. Não use para registro de DI."

Errado: "Gera interface e classe sealed com primary constructor, try/catch com filtro when e log via
ILogger, mapeando com Mapster." (descreve o como interno e não diz quando disparar).

## Seção que não se aplica

Certo:
```
## Raciocínio antes de agir (CoT)
N/A - skill de repasse puro, sem decisão a tomar antes de escrever.
```

Errado: omitir a seção, o que quebra a ordem padronizada e impede a comparação entre skills.
