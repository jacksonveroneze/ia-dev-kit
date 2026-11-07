# Template canônico: tarefas

Molde do rascunho. Em conflito com os Exemplos, o Template vence. Placeholders recebem o conteúdo real; nunca copie literalmente.

```
# Tarefas: {título da story}
Card: {link} | Repositório: {org/repo} | Base: {branch}
Status: rascunho

Sequência: T-01 -> T-02 -> (T-03 e T-04 em paralelo)

## T-01 - {título}
Um PR | Depende de: nenhuma
Critérios cobertos: {CA-01, CA-02}
Arquivos a criar ou alterar:
- {caminho} (criar ou alterar)
Caminhos de teste permitidos:
- {caminho}
Testes: {CA -> nome do teste}
Comandos: build {comando}; teste {comando}; lint {comando}
Atrás de feature flag: {nome | não}
Definição de pronto:
- [ ] {critério verificável da tarefa}
- [ ] Build, teste e lint passando
Status: pendente

## T-02 - {título}
...

## Pendências
- a definir: {pergunta} (afeta {T})
- Volta ao plano ou à spec: {ponto}
```
