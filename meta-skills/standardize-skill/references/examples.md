# Exemplos (certo e errado)

Exemplos de apoio do `SKILL.md`. Em conflito com o Template canônico, o Template vence.

## Mover versus reescrever

Certo: o `SKILL.md` tem 187 linhas e traz três exemplos no corpo. Mover os exemplos, literalmente, para
`references/examples.md`, deixar no corpo "Leia `references/examples.md` antes de escrever" e registrar no
mapa: "M-04: 187 para 124 linhas; conteúdo movido sem alteração".

Errado: mover os exemplos e, no mesmo passo, enxugá-los e trocar termos. Se o significado muda, a
regressão não aparece no diff.

## Pendência versus invenção

Certo: a skill não tem seção Exemplos nem exemplo algum. Registrar pendência: "M-05: não há exemplos de
origem; o autor deve fornecer um caso certo, um errado e um pedido incompleto". Criar `references/examples.md`
só quando houver conteúdo.

Errado: escrever exemplos plausíveis para fechar o item. Exemplo inventado ensina o agente um
comportamento que ninguém decidiu.

## Proposta versus aplicação

Certo: escopo `mecanico`, e a skill tem "assuma valores razoáveis" no passo 1. J-02 é de julgamento:
registrar como proposta, com o texto sugerido ("pare, liste só o que falta e não escreva nada") e não aplicar.

Certo: o mesmo caso com escopo `completo`: entra no mapa de alterações, é confirmado e é aplicado.

Errado: trocar o passo 1 com escopo `mecanico` porque "claramente estava errado".

## Description

Certo: a original descreve o como interno e tem dois-pontos. A nova mantém o quê, o quando e o "NÃO usar";
o mapa mostra antes e depois e pede confirmação, porque a `description` decide o disparo.

Errado: cortar a `description` para caber no limite e perder o "NÃO usar" e a skill irmã.

## Name e pasta divergentes

Certo: pasta `criar-entity` e `name: create-entity`. Parar e relatar a divergência; qual dos dois vale é
decisão do autor, e renomear a pasta quebra quem referencia a skill.

Errado: renomear a pasta para casar com o `name`.

## Pedido incompleto

Pedido: "Padronize a skill de repositório."

Certo: parar e listar o que falta: qual skill (há mais de uma de repositório), o relatório de auditoria
(ou `nenhum`) e, se o usuário quer correção de julgamento, o escopo. Se houver alterações pendentes no
diretório, relatar também. Nada é alterado.

Errado: escolher uma skill, assumir o escopo `completo` e gravar sem mostrar o mapa.
