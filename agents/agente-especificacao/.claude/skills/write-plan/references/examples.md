# Exemplos: write-plan

Valores fictícios. Nunca copie literalmente.

## Trecho correto
```
## Componentes e arquivos
| Componente | Camada | Ação | Caminho | Origem |
|---|---|---|---|---|
| ConsultarLimiteUseCase | Application | criar | src/Contas.Application/Features/Limites/ConsultarLimite/ConsultarLimiteUseCase.cs | RF-01 |

## Testes
| Critério | Teste | Nível | Caminho do teste |
|---|---|---|---|
| CA-01 | Execute_ClienteComLimite_RetornaValor | unidade | tests/Contas.Application.Tests/Features/Limites/ConsultarLimite/ConsultarLimiteUseCaseTests.cs |

## Comandos
- Build: dotnet build Contas.sln
- Teste: dotnet test Contas.sln
- Lint: a definir
- Format: a definir

## Rollout e rollback
- Entrada: atrás de feature flag desligada por padrão.
- Reversão: desligar a flag.
```
Por que está certo: cada linha tem origem, o caminho segue o padrão do resumo do código, os comandos vêm do repositório (o que não foi encontrado, como lint e format, fica `a definir`) e há reversão.

## Errado
- Caminho inventado que o resumo do código não confirma.
- `DT-03: Trocar o provedor de cache.` sem ligação com `RF` ou `CA`.
- Incluir "limite expirado" como novo requisito. Isso volta para a spec.
- Escrever `dotnet build` como comando sem o código ou o usuário terem confirmado.

## Divergência
A spec diz que o limite vem de outro serviço; o código o lê do banco.
- Correto: registrar em Pendências e perguntar; não escolher.
- Errado: seguir o código e ignorar a spec, ou o contrário.

## Pacote novo
Você acha útil uma biblioteca de cache que o projeto não usa.
- Correto: `(proposto, confirmar)`.
- Errado: incluir como decisão firme.

## Ajuste pontual
Pedido: "usa o repositório existente em vez de criar um novo."
- Correto: alterar o componente e os testes afetados e registrar em `Mudanças`.
- Errado: refazer o plano inteiro.

## Pedido incompleto
Pedido: "Faz o plano." (sem spec)
- Correto: pedir a spec aprovada e o resumo do código.
- Errado: planejar a partir da história.
