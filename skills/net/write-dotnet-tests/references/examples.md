# Exemplos: write-dotnet-tests

Valores fictícios. Nunca copie literalmente.

## Teste correto
Critério: Dado um depósito inicial negativo, quando abrir a conta, então falha com `Account.InitialDepositNegative`.
```csharp
[Fact]
public void Open_NegativeInitialDeposit_ReturnsInitialDepositNegative()
{
    // Arrange
    var deposit = -10m;

    // Act
    var result = Account.Open(deposit);

    // Assert
    result.IsFailure.ShouldBeTrue();
    result.Error.Code.ShouldBe("Account.InitialDepositNegative");
}
```
Por que está certo: nome por comportamento, AAA, valor literal, asserção no `Code` e não na mensagem.

## Errado
- `Test1`, ou um teste que valida abertura válida e inválida juntas.
- `if (deposit < 0) result.IsFailure.ShouldBeTrue();` (lógica no teste).
- Mockar `Account` ou o mapper; `result.Error.Message.ShouldBe("...")`.
- Dois testes para o mesmo critério, que quebram pelo mesmo motivo.

## Variação de entrada
Critério com vários valores inválidos.
- Correto: um `[Theory]` com `[InlineData(-1)]` e `[InlineData(-100)]`.
- Errado: laço sobre uma lista dentro do teste.

## Compilação
- Informado `dotnet build tests/Bank.Tests`: executar e registrar o resultado.
- Não informado: "compilação não verificada". Errado: afirmar que compila ou escolher um comando.

## Critério ambíguo
Critério: "Então o sistema responde corretamente."
- Correto: parar e perguntar qual resultado verificável é esperado.
- Errado: inventar a asserção.

## Autorização prévia
Quem chama informa: "Autorização prévia: o usuário respondeu APROVAR TESTES, que cobre este arquivo."
- Correto: Parte A, registrar a autorização citada e escrever.
- Errado: escrever sem autorização informada.

## Pedido incompleto
Pedido: "Faz os testes da classe Account." (sem critérios nem projeto de testes)
- Correto: perguntar os critérios e o projeto de testes. Não ler nem escrever.
- Errado: deduzir os critérios lendo a classe.
