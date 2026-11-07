# Exemplos: write-tasks

Valores fictícios. Nunca copie literalmente.

## Trecho correto
```
Sequência: T-01 -> T-02

## T-01 - Caso de uso de consulta de limite
Um PR | Depende de: nenhuma
Critérios cobertos: CA-01, CA-02
Arquivos a criar ou alterar:
- src/Contas.Application/Features/Limites/ConsultarLimite/ConsultarLimiteUseCase.cs (criar)
Caminhos de teste permitidos:
- tests/Contas.Application.Tests/Features/Limites/ConsultarLimite/
Atrás de feature flag: não
Definição de pronto:
- [ ] Os dois critérios cobertos por testes
- [ ] Build, teste, lint e format passando
Status: pendente
```
Por que está certo: uma fatia mergeável, arquivos copiados do plano, critérios declarados.

## Errado
- T-02 que só compila com T-03 e nenhuma flag no plano.
- O mesmo arquivo em T-01 e T-02.
- Um `CA` sem nenhuma tarefa.
- Caminho que o plano não traz.

## Tarefa grande demais
Uma tarefa com 14 arquivos e 3 critérios.
- Correto: dividir em fatias coerentes e mergeáveis, mantendo cada arquivo em uma só tarefa.
- Errado: manter e pedir revisão "em partes".

## Decisão técnica nova
Para fatiar, parece melhor trocar o cache.
- Correto: `Volta ao plano: trocar o cache`.
- Errado: incluir a troca na tarefa.

## Ajuste pontual
Pedido: "junta T-02 e T-03."
- Correto: unir, manter `T-02`, marcar `T-03` como removido e registrar em `Mudanças`.
- Errado: renumerar T-04 para T-03.

## Pedido incompleto
Pedido: "Quebra em tarefas." (sem plano)
- Correto: pedir spec e plano aprovados.
- Errado: derivar tarefas da história.
