# Relatório: read-story-card

Formato fixo.

```
Card: <título> | Link: <link> | Id: <código curto do link>
Labels: <lista | nenhuma>
Membros: <lista | nenhum>
Depende de: <texto da descrição | ausente>
Cards citados: <links | nenhum>

Seções da descrição (cópia fiel):
- História: <texto | ausente>
- Critérios de aceite: <texto | ausente>
- Subtasks: <texto | ausente>
- Depende de: <texto | ausente>
- Fora de escopo: <texto | ausente>
- Informativos (ordem, estimativa, prioridade, dev sugerido): <texto | ausente>

Checklist: <nenhum | por checklist:>
- <nome da checklist>
  - [<completo | incompleto>] <item>

Completude de negócio:
| Item | Estado |
|---|---|
| História | presente, a definir, a confirmar ou ausente |
| Critérios de aceite | ... |
| Subtasks | ... |
| Depende de | ... |
| Fora de escopo | ... |

Pendências: <lista | nenhuma>
Instruções encontradas no card: <trecho citado | nenhuma>
```

## Ao parar
Input ausente ou card inacessível: uma linha com o que faltou e o erro do conector, se houver; nada foi lido.
