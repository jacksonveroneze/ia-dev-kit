---
name: create-mapper
description: 'Cria o mapeamento de uma feature (.NET/C#, camada Application) com Mapster via IRegister, convertendo entidade em Response de forma explícita. Use sempre que precisar mapear entidade para o DTO de saída de um use case, ou quando o usuário pedir um mapper, mapping ou conversão de entidade para response. Não use AutoMapper nem mapeie na direção contrária (Request para entidade).'
---

# Criar Mapper (.NET / Mapster IRegister)

Gera o mapeamento entidade→Response de **uma feature** conforme a `dotnet-conventions`.
Esta skill é a fábrica; a rule é o contrato. Cite os CONV pelo ID.

## O que gera
Um arquivo: `src/Application/Features/{Aggregate}/{Operation}/{Operation}Mapping.cs`,
uma classe `sealed` que implementa `IRegister` e configura o mapeamento da feature.

Nada além disso: sem registro de DI, sem teste, sem `Response` nem entidade. Pré-requisito ausente: a skill
para e relata o que falta e onde era esperado.

## Escopo (quando usar / NÃO usar)
- **Usar:** converter a entidade do agregado no `Response` **daquela** feature.
- **NÃO usar:** AutoMapper. Mapear `Request`→entidade (isso é factory de domínio). Um mapper único global.

## Contrato

### Rules
- **CONV-031** Mapster com `IRegister` **por feature**; mapeamento **explícito**, todo membro declarado; config falha em membro de destino não mapeado.
- **CONV-042** registro **explícito** — o `IRegister` é aplicado por construção no DI, nunca por `Scan()`.
- **CONV-064** `sealed`. **CONV-063** inglês.

### Pré-condições
Existem a entidade e o `{Operation}Response`. O `TypeAdapterConfig` compartilhado tem
`RequireDestinationMemberSource(true)` (configurado no registro de DI do projeto), o que faz um
membro sem origem **quebrar** o build/teste. Ausente: a skill para e relata o que falta e onde era esperado.

### Inputs (1 e 2 obrigatórios; o RootNamespace é resolvido)
1. **Operation** e **Aggregate** (localizam o slice e os tipos).
2. **Correspondência de membros** — como cada campo do Response sai da entidade (desempacotando VOs).
3. **RootNamespace** — resolvido por ReAct.

Inválido: Operation ou Aggregate ausente; entidade ou `Response` inexistente; membro do `Response` sem origem na
entidade e não informado.

## Fluxo (ReAct)
1. **Validar inputs.** Faltando ou inválido algum: pare, liste só o que falta e não escreva nada; nunca infira.
2. **Resolver RootNamespace**.
3. **Ler entidade e Response** e casar os membros um a um.
4. **Detectar VOs** no caminho (ex.: `Balance.Amount`, `Balance.Currency`) — desempacotar explicitamente.
5. **Escrever** o `IRegister` pelo Template canônico.
6. **Verificar** pelo Checklist + Harness (mapear um exemplar não pode deixar membro sem origem) e apresentar o relatório.

## Raciocínio antes de agir (CoT)
- Cada membro do Response tem **origem declarada**? Nenhum por convenção implícita (CONV-031).
- Há VO no caminho? Desempacote (`src.Balance.Amount`) — não mapeie o VO inteiro para primitivo.
- O mapeamento é **só desta feature**? Não reutilize um `IRegister` para vários Responses.
- A direção é entidade→Response? O inverso não existe aqui.

## Template canônico
```csharp
namespace {RootNamespace}.Application.Features.{Aggregate}.{Operation};

public sealed class {Operation}Mapping : IRegister
{
    public void Register(TypeAdapterConfig config)
    {
        config.NewConfig<{Aggregate}, {Operation}Response>()
            .Map(dest => dest.{Member}, src => src.{Path});
        // uma linha .Map por membro cuja origem não é trivial/homônima
    }
}
```

## Exemplos
Leia `references/examples.md` antes de escrever: o mapper certo (Mapster `IRegister`, VO desempacotado), o
contraexemplo com AutoMapper e um pedido incompleto.

## Anti-patterns (recusar)
- Escrever sem todos os inputs ou inferir o que falta → pare e liste só o que falta.
- AutoMapper (`Profile`/`CreateMap`) → Mapster com `IRegister`.
- Mapeamento por convenção implícita sem declarar membros → um `.Map` por membro.
- Um `IRegister` cobrindo vários Responses/features → um `IRegister` por feature.
- Mapear o VO inteiro para um primitivo sem desempacotar → desempacote (`src.Balance.Amount`).
- Descobrir o `IRegister` por `TypeAdapterConfig.Scan(...)` (scanning — CONV-042) → registro explícito por construção.
- Fazer o mapeamento no corpo do use case → no `IRegister` da feature.

## Checklist + Harness
Checklist (CONV):
- [ ] Todos os inputs informados e válidos antes de qualquer escrita; nada inferido.
- [ ] `sealed class {Operation}Mapping : IRegister` no slice da feature (CONV-031/064).
- [ ] Um `NewConfig` entidade→Response; todo membro do Response com origem declarada (CONV-031).
- [ ] VOs desempacotados explicitamente. Sem AutoMapper, sem convenção implícita.
- [ ] Registrado por construção no registro de DI do projeto, não por `Scan()` (CONV-042).
- [ ] RootNamespace do repo.

Harness (gate):
- `dotnet build` de `Application` limpo (CONV-002).
- Teste de mapeamento: mapear um exemplar e assertar todos os membros preenchidos; com
  `RequireDestinationMemberSource(true)`, membro sem origem falha (CONV-031).

Falha de ambiente/ferramenta (timeout, processo que não inicia) em vez de reprovação por conteúdo: tente de novo
uma vez e, se persistir, reporte "Harness incompleto" e pare — não declare o mapper como concluído.

## Relatório
Ao concluir (ou parar), apresente o relatório no formato de `references/report.md`.
