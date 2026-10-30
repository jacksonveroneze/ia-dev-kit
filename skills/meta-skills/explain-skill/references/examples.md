# Exemplos (certo e errado)

Exemplos de apoio do `SKILL.md`. A skill `create-widget` abaixo é fictícia e existe só para ilustrar.

## Célula com fonte e sem fonte

Skill fictícia `create-widget`: gera `{Dir}/{Name}Widget.cs`, para se o arquivo já existe, não gera teste
nem registro de DI (seções "O que gera" e "Escopo").

Certo:
```
| Não faz | Teste e registro de DI | O que gera |
| Para quando | O arquivo já existe | Fluxo, passo 3 |
| Verifica com | nada definido | Checklist + Harness |
```

Errado:
```
| Não faz | Provavelmente não valida o nome | (sem fonte) |
```

Diferença: o que o texto não diz fica "não definido na skill". Dizer o que a skill "provavelmente" faz
leva o leitor a confiar num comportamento que ninguém decidiu.

## Exemplo derivado versus inventado

Template da skill fictícia: `public sealed class {Name}Widget { public string Id { get; } }`.
Exemplo dela: `Name=Order`, campo `Id`.

Certo (derivado, caso mínimo, rotulado):
```csharp
// EXEMPLO (fictício)
public sealed class OrderWidget
{
    public string Id { get; }
}
```
| Trecho | Vem de |
|---|---|
| `public sealed class` | Rules, "sealed por padrão" |
| `Id { get; }` | Template, propriedade somente leitura |

Errado:
```csharp
public class OrderWidget : IDisposable        // o Template não tem herança nem IDisposable
{
    public string Id { get; set; }            // o Template é somente leitura
    public void Render() { }                  // comportamento que a skill não gera
}
```

Diferença: o exemplo mostra como a skill constrói, então só pode conter o que o Template e os Exemplos
mostram. Acrescentar o que "faria sentido" descreve outra skill.

## Skill sem Template nem Exemplo

Skill que só emite um relatório de texto, sem Template e sem exemplo de saída.

Certo: a tabela é preenchida e a seção de exemplo vira uma linha: "exemplo não gerado: sem Template ou
Exemplo de origem".
Errado: inventar um relatório plausível para ter algo a mostrar.

## Pedido incompleto

Pedido: "Explique a skill de repositório."

Certo: parar e listar o que falta, sem ler nem escrever nada. A skill alvo é ambígua (há mais de uma com
esse tipo de nome) e o diretório não foi informado.
Errado: escolher uma skill e explicá-la.

## Cenário fora do escopo

Skill fictícia `create-widget` só gera widget de um arquivo. Cenário pedido: "widget com três classes".

Certo: relatar "fora do escopo da skill: gera um arquivo por widget" e usar o cenário padrão (o primeiro
exemplo certo da skill) para o exemplo.
Errado: montar o exemplo com três classes como se a skill suportasse isso.
