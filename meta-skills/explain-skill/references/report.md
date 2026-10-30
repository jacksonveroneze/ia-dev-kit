# Relatório (formato)

Apresentado ao concluir ou ao parar. Curto: uma tabela e um exemplo mínimo. Texto puro, sem emoji.

```
# Explicação: {skill}
Tipo: {gerador|transformador|auditor}   Fontes: SKILL.md e {arquivos de references lidos}

| Campo | Conteúdo | Fonte |
|---|---|---|
| Faz | {até 3 itens, uma frase cada} | {seção} |
| Não faz | {até 3 itens} | {seção} |
| Entradas | {o que a skill exige do usuário} | {seção} |
| Saída | {arquivos ou artefato produzido} | {seção} |
| Para quando | {pré-condição ou input ausente} | {seção} |
| Verifica com | {comandos do Harness ou "nada definido"} | {seção} |

## Exemplo (fictício)
Cenário: {pedido fictício em uma frase}

{bloco de código com o caso mínimo, derivado do Template e dos Exemplos}

| Trecho | Vem de |
|---|---|
| {linha ou construção relevante} | {regra ou seção da skill} |

Nota: EXEMPLO (fictício). Ilustra a construção; não foi compilado nem executado.
```

Sem Template nem Exemplo de origem, troque o bloco "Exemplo" por uma linha: "exemplo não gerado: sem
Template ou Exemplo de origem". Campo que a skill não define: "não definido na skill".

Ao parar, troque tudo por uma linha: o que faltou (skill alvo ausente ou ilegível, cenário fora do escopo da
skill, caminho de saída dentro da skill alvo) e onde era esperado. Nada foi escrito.
