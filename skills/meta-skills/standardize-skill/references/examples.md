# Exemplos (certo e errado)

Exemplos de apoio do `SKILL.md`. Em conflito com o Template canônico, o Template vence.

## Mover versus reescrever

Certo: o `SKILL.md` tem 187 linhas e traz três exemplos no corpo. Mover os exemplos, literalmente, para
`references/examples.md`, deixar no corpo "Leia `references/examples.md` antes de escrever" e registrar no
relatório da proposta: "M-04: 187 para 124 linhas; conteúdo movido sem alteração".

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

Certo: o mesmo caso com escopo `completo`: entra no relatório da proposta, é aprovado e é aplicado.

Errado: trocar o passo 1 com escopo `mecanico` porque "claramente estava errado".

## Description

Certo: a original descreve o como interno e tem dois-pontos. A nova mantém o quê, o quando e o "NÃO usar";
o relatório da proposta mostra antes e depois e pede o APROVADO, porque a `description` decide o disparo.

Errado: cortar a `description` para caber no limite e perder o "NÃO usar".

## Name e pasta divergentes

Certo: pasta `criar-entity` e `name: create-entity`. Parar e relatar a divergência; qual dos dois vale é
decisão do autor, e renomear a pasta quebra quem referencia a skill.

Errado: renomear a pasta para casar com o `name`.

## Pedido incompleto

Pedido: "Padronize a skill de repositório."

Certo: parar e listar o que falta: qual skill (há mais de uma de repositório), o relatório de auditoria
(ou `nenhum`) e, se o usuário quer correção de julgamento, o escopo. Se houver alterações pendentes no
diretório, relatar também. Nada é alterado.

Errado: escolher uma skill, assumir o escopo `completo` e gravar sem mostrar o relatório da proposta.

## Gates e fases

Usuário na Fase 1 pede para pular: "Já aplica."
- Certo: `Fase 1/2 - Proposta`, "Ainda estamos na proposta. Para aplicar, falta o seu APROVADO sobre o relatório.", seguido de Feito, Pendente e Próximo passo.
- Errado: gravar os itens.

Comentário no gate (Fase 1, aguardando APROVADO): "A proposta parece boa."
- Certo: responder em uma frase e lembrar "Responda APROVADO para aplicar".
- Errado: tratar o comentário como APROVADO e gravar.

Aprovação parcial: "APROVADO exceto A3, A5."
- Certo: aplicar todos os itens do tipo `aplicar`, menos A3 e A5, e listar as duas linhas como excluídas no relatório final.
- Errado: aplicar A3 e A5 mesmo assim, ou ignorar a dependência (excluir a movimentação e aplicar a citação dela).

Ajuste na Fase 1: "Roda de novo com escopo completo."
- Certo: refazer o diagnóstico e a proposta com o escopo `completo` e pedir o APROVADO de novo.
- Errado: manter a proposta antiga ou gravar com o escopo novo sem mostrar o relatório.

Divergência na Fase 2: um arquivo que a proposta pretendia mover já existe no destino.
- Certo: parar, voltar à Fase 1 e reapresentar a proposta atualizada.
- Errado: sobrescrever o arquivo do destino para "terminar".
