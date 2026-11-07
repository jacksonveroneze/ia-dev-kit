# Exemplos: generate-spec-artifacts

Valores fictícios. Nunca copie literalmente.

## Preview correto
```
Destino: specs/AbCd1234-consultar-limite-app/ | Existe: não
Consistência: aprovada
| Verificação | Estado |
|---|---|
| Pendências abertas | nenhuma |
| RF com CA | 2 de 2 |
| CA com teste no plano | 3 de 3 |
| CA com tarefa | 3 de 3 |
| Arquivos do plano em uma só tarefa | sim |
| Cabeçalhos iguais | sim |
| Dados protegidos | nenhum encontrado |
Achados: nenhum

Arquivos a gravar:
- specs/AbCd1234-consultar-limite-app/spec.md
- specs/AbCd1234-consultar-limite-app/plan.md
- specs/AbCd1234-consultar-limite-app/tasks.md

(conteúdo dos três arquivos)

Confirma a gravação destes arquivos neste destino?
```
Por que está certo: só leitura, cadeia conferida, termina pedindo confirmação.

## Errado
- Gravar logo após o usuário dizer "ficou bom". Comentário não é autorização.
- Gravar com um `a definir` aberto no plano.
- "Melhorar" uma frase do plano ao gravar.
- Sobrescrever a pasta que já existe.

## Inconsistência
O `CA-03` não tem tarefa.
- Correto: consistência reprovada, achado `CA-03 sem tarefa`, sem pedir confirmação.
- Errado: gravar e deixar para depois.

## Destino existente
A pasta já existe.
- Correto: parar e perguntar.
- Errado: sobrescrever ou criar `-2`.

## Falha no meio
Gravou `spec.md`; `plan.md` falhou.
- Correto: informar gravados e não gravados e perguntar como proceder.
- Errado: apagar e refazer tudo.

## Autorização prévia
Quem chama informa: "Autorização prévia: o usuário respondeu APROVAR ARTEFATOS, que cobre estes arquivos."
- Correto: fazer a Parte A, registrar a autorização citada e gravar.
- Errado: gravar sem autorização informada.

## Pedido incompleto
Pedido: "Gera os artefatos." (sem os rascunhos)
- Correto: pedir os três rascunhos, o código do card, o título e a raiz de specs.
- Errado: gerar arquivos vazios.
