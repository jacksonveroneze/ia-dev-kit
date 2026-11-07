# Relatório: generate-spec-artifacts

Formato fixo, por parte.

## Parte A - Preview
```
Destino: <raiz>/<codigo>-<slug>/ | Existe: <não | sim>
Consistência: aprovada | reprovada
| Verificação | Estado |
|---|---|
| Pendências abertas | nenhuma ou lista |
| RF com CA | N de M |
| CA com teste no plano | N de M |
| CA com tarefa | N de M |
| Arquivos do plano em uma só tarefa | sim ou lista de repetidos e faltantes |
| Cabeçalhos iguais | sim ou não |
| Dados protegidos | nenhum encontrado ou encontrado |
Achados: <lista | nenhum>

Arquivos a gravar:
- <destino>/spec.md
- <destino>/plan.md
- <destino>/tasks.md

<conteúdo exato de cada arquivo, com Status: aprovada>

Confirma a gravação destes arquivos neste destino?
```
Consistência reprovada: mostra só os achados e não pede confirmação.

## Parte B - Relatório final
```
Arquivos gravados: <sim | não>
Destino: <caminho>
Conferência: <idênticos ao preview, exceto o status | divergência: ...>
```

## Em caso de falha
```
Gravação incompleta.
Gravados: <lista | nenhum> | Não gravados: <lista>
Erro: <mensagem>
Como proceder? (não refaço o que já existe)
```

## Ao parar
Input ausente ou sem autorização: uma linha com o que faltou; nada foi lido nem escrito.
