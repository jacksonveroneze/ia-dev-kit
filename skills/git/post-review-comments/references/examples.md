# Exemplos: post-review-comments

Valores fictícios. Nunca copie literalmente.

## Preview correto
```
PR: acme/pedidos-api#42 | Link: https://github.com/acme/pedidos-api/pull/42 | Estado: aberto
SHA do head: e4f5a6b | SHA atual: e4f5a6b | igual
Evento da review: COMMENT
Duplicados: nenhum
Dados protegidos: nenhum encontrado

Comentários (2):
| C1 | src/Pedidos/Sumario.cs:18 | IMPORTANTE | válido | [IMPORTANTE] A consulta carrega os itens dentro do laço (N+1). Considere Include ou projeção. |
| C2 | geral | SUGESTAO | válido | [SUGESTAO] Falta o teste do período vazio. |

Confirma a publicação desta review neste PR?
```
Por que está certo: só leitura, evento COMMENT, texto exato, termina pedindo autorização.

## Errado
- Publicar logo após o usuário dizer "ficou bom". Elogio não é autorização.
- Enviar `APPROVE` porque os achados são só sugestões.
- Publicar texto diferente do mostrado.

## Linha fora do diff
O comentário aponta `Repositorio.cs:300`, linha que não está em nenhum trecho alterado.
- Correto: marcar "linha fora do diff" no preview e pedir a correção ou a conversão em comentário geral.
- Errado: publicar e deixar a API recusar, ou mover a linha por conta própria.

## Head mudou
O SHA informado é `e4f5a6b` e o PR agora está em `9c8d7e6`.
- Correto: parar e informar. As linhas podem ter mudado.
- Errado: publicar no SHA novo com as linhas antigas.

## Segredo no texto
Um comentário cita um valor de `password=` copiado do código.
- Correto: mascarar com `***` no preview, bloquear e pedir o texto corrigido.
- Errado: publicar o valor.

## Falha ao publicar
A API responde 422.
- Correto: informar o erro, dizer que nada foi publicado e perguntar como proceder.
- Errado: tentar de novo em laço, ou remover comentários por conta própria.

## Autorização prévia
Quem chama informa: "Autorização prévia: automação configurada, permite publicar esta review neste PR."
- Correto: fazer a Parte A, registrar a autorização citada e publicar sem esperar resposta.
- Errado: publicar sem autorização informada, ou assumir "autorizado por padrão".

## Pedido incompleto
Pedido: "Posta os comentários no PR."
- Correto: perguntar o PR, o SHA do head revisado e a lista de comentários. Nenhuma consulta nem escrita.
- Errado: usar o último PR e comentários inventados.
