# Relatório: write-dotnet-tests

Formato fixo, por parte.

## Parte A - Preview
```
Classe alvo: <caminho> | Projeto de testes: <caminho>
Arquivo de teste: <caminho> | Já existe: <sim | não>

| Critério | Teste | Mocks | Asserção |
|---|---|---|---|
| <Dado/Quando/Então resumido> | <Method_Scenario_ExpectedResult> | <fronteiras | nenhum> | <o que valida> |
Sem teste: <critério e porquê | nenhum>

Confirma escrever este arquivo?
```

## Parte B - Relatório final
| Item | Resultado |
|---|---|
| Arquivo | caminho do teste escrito |
| Cobertura | critérios com teste, quantidade de testes e critérios sem teste (com o motivo) |
| Compilação | comando informado e resultado, ou "compilação não verificada" |
| Harness | resultado, ou "Harness incompleto" e o motivo |

## Ao parar
Input ausente, arquivo de destino já existente, critério ambíguo ou sem autorização: uma linha com o que faltou e onde era esperado. Nada foi escrito.
