# Ajuda

Fonte da CONV-011. Mostre só a seção pedida (a da etapa atual; "como usar" mostra a Geral). Todo exemplo é fictício.

## Geral (como usar)
- Fluxo: Leitura e preflight, Contexto, Revisão automática, Consolidação e revisão humana, Publicação, Concluído.
- Você informa a URL do Pull Request (ou `org/repo#número`), com a pasta atual no checkout do PR. Quatro revisores analisam o PR em paralelo: qualidade, desempenho, testes e segurança.
- **A revisão do PR continua sendo sua.** O agente apoia: aponta achados e lista os cenários de teste que você deve conferir. Ele não aprova, não pede mudanças e não faz merge.
- Cada etapa termina parada até você responder o gate. Gates: AVANÇAR, APROVAR COMENTÁRIOS (aprova a lista final), PUBLICAR (publica a review), VOLTAR.
- O processo está em `resources/fluxo.md`. Para tirar uma aprovação manual, edite esse arquivo.
- O progresso fica em `estado.json` e os rascunhos em `rascunho/`; se a sessão cair, o agente retoma de onde parou.

## Etapa 1 - Leitura e preflight
- Informe o PR. O agente lê metadados, arquivos, diff, CI e comentários existentes e confere o ambiente: PR aberto, checkout no head do PR, árvore limpa, CI visível e a spec do card em `specs/`.
- Falhou algo: o agente lista o que corrigir (por exemplo, `gh pr checkout`). Ele não corrige sozinho. Tudo certo: mostra o relatório e espera AVANÇAR.

EXEMPLO (fictício): "Revisa este PR: https://github.com/acme/pedidos-api/pull/42"

## Etapa 2 - Contexto
- O agente junta o diff, o CI, os comentários já feitos e a spec, o plano e as tarefas do card. Sem spec, ele avisa e revisa só por convenção.
- Mostra o que reuniu e as lacunas. Responda AVANÇAR para iniciar os revisores.

## Etapa 3 - Revisão automática
- Os quatro revisores rodam em paralelo, só lendo o código do seu checkout. Saída fora do formato é descartada e o revisor roda de novo (até 2 vezes).
- Responda AVANÇAR para consolidar.

## Etapa 4 - Consolidação e revisão humana
- O agente junta os achados, remove duplicados e descarta o que não tem arquivo, linha e evidência.
- Você recebe o aviso de que a revisão é sua, os cenários de teste a conferir e a lista de comentários propostos (C1, C2, ...).
- Aceite, edite ou descarte por número. Exemplos: "descarta C3", "edita C2: texto novo". Quando a lista estiver como você quer, responda APROVAR COMENTÁRIOS.

## Etapa 5 - Publicação
- O agente mostra o preview da review: evento `COMMENT`, texto geral e cada comentário com arquivo, linha e severidade. Nada é enviado até você responder PUBLICAR.
- O PR mudou desde a leitura, ou há segredo no texto: o agente para e diz o que fazer. VOLTAR retorna à consolidação.

## Etapa 6 - Concluído
- O agente confere no GitHub que os comentários foram publicados e resume. Aprovar e fazer merge continua sendo com você.
