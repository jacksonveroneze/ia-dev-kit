# Critério de resposta aos comentários de review

Orientação prática para recomendar CONCORDAR, CONTESTAR ou PERGUNTAR. A recomendação é do agente; a decisão é do usuário (CONV-004). O `comment-triager` lê este arquivo; o orquestrador usa o mesmo critério ao redigir as respostas.

## Princípio
Avalie pelo impacto e pela spec, não pelo tom nem por quem comentou. Um comentário é bom quando aponta algo verificável: o código faz outra coisa que a spec pede, falha em um caso, quebra uma convenção do repositório ou deixa um risco. Um comentário insistente, mas sem evidência, continua sem evidência (CONV-020).

## Antes de recomendar
1. Leia o código no ponto citado (`arquivo:linha`) na versão atual da branch. O comentário pode ter ficado desatualizado (`desatualizada`): confira se o problema ainda existe.
2. Procure a regra na spec (`spec.md`), no plano (`plan.md`) e na tarefa (`tasks.md`), quando houver, e nas convenções do repositório.
3. Procure o que o comentário não viu: um teste que cobre, outra camada que valida, uma decisão já registrada no plano.
4. Só então classifique.

## Tipo do comentário

| Tipo | O que é | Como tratar |
|---|---|---|
| Correção | bug, caso não coberto, violação da spec, segurança, dado protegido, regressão | pesa mais; confirme com evidência; tende a CONCORDAR se confirmado |
| Convenção | quebra de regra escrita do repositório (nome, camada, padrão da referência) | CONCORDAR se a regra existe por escrito; cite a regra |
| Estilo | preferência de formatação, nome, ordem, sem regra escrita | ver "Estilo versus correção" |
| Teste | pede teste ou cobertura | CONCORDAR se o critério de aceite não tem teste; senão aponte o teste existente |
| Pergunta | quer entender uma decisão | responder; vira PERGUNTAR só se a resposta depende de decisão do usuário |
| Fora de escopo | pede algo além do que a spec e a tarefa cobrem | CONTESTAR com cordialidade, sugerindo item separado; nunca ampliar o PR sem decisão do usuário |
| Ruído | elogio, "ok", "+1", discussão sem pedido | sem ação; resposta opcional |

## Estilo versus correção
- Correção muda comportamento ou risco. Estilo não muda o que o código faz.
- Se o `format` ou o `lint` do repositório já exige, não é preferência: é correção de convenção e fica barata (CONCORDAR).
- Estilo sem regra escrita e que custa pouco: CONCORDAR é razoável, para poupar atrito. Estilo sem regra escrita que custa refatoração grande ou foge do escopo da tarefa: CONTESTAR com cordialidade ou PERGUNTAR ao usuário. Diga que é preferência e registre.
- Estilo contra o padrão da referência (`Siga:`) do plano: CONTESTAR citando a referência.

## CONCORDAR
Recomende quando o comentário está correto à luz do código e da spec, a correção cabe nos arquivos do comentário e não contradiz a spec. Diga no motivo qual evidência confirmou e qual mudança resolve. Se a correção exige tocar arquivo que o comentário não citou, liste o arquivo e deixe o usuário autorizar na triagem.

## CONTESTAR
Recomende quando a evidência mostra que o comentário não se aplica: a spec pede o contrário, o caso já é tratado em outra camada, o teste existente cobre, ou o pedido amplia o escopo. Regras para a resposta:
- Abra reconhecendo o ponto ("Entendi a preocupação com X").
- Dê a evidência: `arquivo:linha`, trecho da spec ou do plano, teste existente. Sem evidência não há contestação: vira PERGUNTAR.
- Diga o que o código faz hoje e por quê, em uma ou duas frases. Sem ironia, sem "como já disse".
- Ofereça saída quando couber: item separado, ajuste de spec, discussão com o autor da spec.
- Deixe a porta aberta: se o revisor tiver um caso concreto que a evidência não cobre, reavalie.

## PERGUNTAR
Recomende quando não dá para decidir com o que existe:
- o comentário é ambíguo (não dá para saber o que pede);
- spec e comentário divergem e só o dono da spec resolve;
- duas leituras razoáveis levam a mudanças diferentes;
- falta o dado (comando, requisito, caso de uso) e deduzir seria inventar.
Duas formas: pergunta ao usuário na triagem (o que o agente precisa saber) e pergunta ao revisor na thread (o que o agente quer esclarecer). Diga qual das duas.

## Quando não concordar
- Pelo número de pessoas que pediram, pela hierarquia de quem pediu ou pelo tom firme.
- Para encerrar a discussão mais rápido, se a mudança piora o código ou contradiz a spec.
- Quando a correção sugerida resolve o sintoma e esconde a causa: contraponha com a causa, com evidência.
- Quando dois comentários pedem coisas incompatíveis: não aceite os dois; apresente o conflito ao usuário (PERGUNTAR).

## Quando concordar sem atrito
- Erro objetivo confirmado (o revisor tem razão e o código falha no caso descrito).
- Regra escrita do repositório violada.
- Falta de teste para um critério de aceite.
- Segurança ou dado protegido.

## Como o agente apresenta
Por comentário: o que pede, onde (`arquivo:linha`), a avaliação com evidência, a recomendação com o motivo e, para CONCORDAR, a mudança e os arquivos. Se o usuário decide diferente da recomendação, registre a decisão dele e siga; o agente não insiste.
