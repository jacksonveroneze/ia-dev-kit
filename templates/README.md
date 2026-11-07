# Modelos para repositórios e para a máquina do desenvolvedor

Arquivos prontos para copiar e adaptar. Tudo que está marcado `a definir` precisa ser preenchido pelo time: os agentes não inventam esses valores.

## Mapa

| Arquivo | O que é | Copiar para | Como adaptar |
|---|---|---|---|
| `global/CLAUDE.md` | Preferências pessoais: tom, segurança, código, git worktrees, revisão | `~/.claude/CLAUDE.md` | Ajuste ao seu gosto. Se já existe, mescle em vez de substituir |
| `repo-alvo/CLAUDE.md` | Contexto do projeto .NET: comandos, arquitetura, testes, specs, branches, "nunca" | `CLAUDE.md` na raiz do repositório-alvo | Preencha a tabela de comandos (solution e branch base) |
| `repo-alvo/specs/constitution.md` | Regras fixas `CONST-nnn` que spec, plano e tarefas herdam | `specs/constitution.md` do repositório-alvo | Revise cada regra; preencha os `a definir` (retenção, biblioteca de flags, limites de PR) |
| `repo-alvo/.claude/settings.json` | Permissões (allow, ask, deny) e hooks | `.claude/settings.json` do repositório-alvo | Veja "Permissões e hooks" abaixo |
| `repo-alvo/.claude/hooks/*.sh` | Scripts chamados pelo `settings.json` | `.claude/hooks/` do repositório-alvo, mantendo o modo executável | Edite os padrões de `block-risky-bash.sh` |
| `repo-alvo/.github/workflows/ci.yml` | CI: restore, build, testes com cobertura, `dotnet format --verify-no-changes` | `.github/workflows/ci.yml` | Defina `SOLUTION`; mantenha o `global.json` na raiz |
| `repo-alvo/.github/pull_request_template.md` | Descrição de PR com as 5 seções fixas | `.github/pull_request_template.md` | Troque os comandos de "Como testar" pelos reais |
| `repo-alvo/.gitignore-agentes.txt` | Linhas para o `.gitignore` | Acrescentar ao `.gitignore` do repositório-alvo | Nenhuma; confira que `estado.json` e `rascunho/` entraram |

## Como aplicar no repositório-alvo

```
cp -r templates/repo-alvo/.claude <repositório>/
cp templates/repo-alvo/CLAUDE.md <repositório>/
mkdir -p <repositório>/specs && cp templates/repo-alvo/specs/constitution.md <repositório>/specs/
mkdir -p <repositório>/.github/workflows
cp templates/repo-alvo/.github/workflows/ci.yml <repositório>/.github/workflows/
cp templates/repo-alvo/.github/pull_request_template.md <repositório>/.github/
cat templates/repo-alvo/.gitignore-agentes.txt >> <repositório>/.gitignore
chmod +x <repositório>/.claude/hooks/*.sh
```

Se o repositório já tem algum desses arquivos, mescle manualmente. Faça tudo em um PR próprio, com revisão humana. Depois do `cp -r`, confira `git ls-files --stage .claude/hooks`: o modo deve ser `100755`.

## Ordem sugerida
1. `.gitignore-agentes.txt`: os agentes exigem `estado.json` e `rascunho/` ignorados no preflight.
2. `CLAUDE.md` e `specs/constitution.md`: contexto e regras que os agentes leem.
3. `.claude/`: permissões e hooks.
4. `.github/`: CI e template de PR.

## Permissões e hooks

- `permissions.allow`: leitura, build, test, format do .NET e `gh` de leitura. `ask`: `git push`, commit, merge e `gh` que escreve. `deny` (vence `ask` e `allow`): ler ou editar `.env`, `.env.local`, `.env.production` e demais variantes com ambiente (menos `.env.example`, `.env.sample` e `.env.template`, que os hooks liberam), chaves, certificados e `appsettings.Production.json`; `gh pr merge`, `git branch -d`/`-D`, `git push --force`, push em `main`/`develop` (inclusive `HEAD:main`), `git reset --hard`. `git branch` fica no `allow` só nas formas de leitura.
- `PreToolUse` bloqueia (código de saída 2, com o motivo) leitura e edição de arquivos sensíveis e comandos Bash que casem com a lista `PATTERNS` de `block-risky-bash.sh`. Substitua os hosts `a-definir-*` pelos de produção e de APIs de terceiros reais.
- `PostToolUse` roda `dotnet format` no `.cs` editado. Nunca bloqueia; avisa em caso de falha.
- `Stop` e `Notification` chamam `notify.sh` (`notify-send` no Linux, `osascript` no macOS, `echo` como fallback).
- Os hooks usam `jq` ou, na falta, `python3`. Sem nenhum dos dois, o hook avisa e não bloqueia: instale um deles.
- Settings pessoais ficam em `.claude/settings.local.json` (ignorado pelo git).
- Os hooks são uma segunda barreira, não a primeira: o `deny` de permissões já cobre os casos principais.

## Verificação

- `python3 -m json.tool .claude/settings.json`
- `bash -n .claude/hooks/*.sh`
- Teste um bloqueio: `echo '{"tool_input":{"file_path":".env"}}' | .claude/hooks/block-sensitive-files.sh; echo $?` deve imprimir o motivo e `2`.
