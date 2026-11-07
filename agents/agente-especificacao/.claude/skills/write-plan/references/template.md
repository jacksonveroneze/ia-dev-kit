# Template canônico: plano

Molde do rascunho. Em conflito com os Exemplos, o Template vence. Placeholders recebem o conteúdo real; nunca copie literalmente.

```
# Plano: {título da story}
Card: {link} | Repositório: {org/repo} | Base: {branch}
Status: rascunho

## Abordagem
{3 a 6 linhas: como a spec será atendida, apoiada no padrão existente}

## Decisões técnicas
| ID | Decisão | Motivo | Alternativa descartada | Origem |
|---|---|---|---|---|
| DT-01 | {decisão} | {motivo} | {alternativa} | {RF ou CA} |

## Componentes e arquivos
| Componente | Camada | Ação | Caminho | Origem |
|---|---|---|---|---|
| {nome} | {camada} | criar ou alterar | {caminho} | {RF ou CA} |

## Contrato
- Entrada: {campos, tipos, validações}
- Saída: {campos}
- Erros: {código estável} -> {tipo e situação}

## Persistência e integrações
{o que é lido ou escrito, e onde; ou nenhuma}

## Testes
| Critério | Teste | Nível | Caminho do teste |
|---|---|---|---|
| CA-01 | {nome do teste} | unidade ou integração | {caminho} |

## Comandos
- Build: {comando}
- Teste: {comando}
- Lint: {comando}
- Format: {comando | não se aplica}

## Rollout e rollback
- Entrada: {como entra em produção}
- Reversão: {como reverter sem novo deploy, se possível}

## Referência de implementação
- {arquivo:linha} - {o que segue}

## Riscos
- {risco} -> {mitigação}

## Pendências
- a definir: {pergunta} (afeta {DT, componente ou teste})
- (proposto, confirmar): {sugestão}
- Volta à spec: {ponto que exigiria mudar requisito}
```
