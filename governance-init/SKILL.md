---
name: governance-init
version: "1.1.0"
description: Initializes a new project with cost-aware multi-provider configuration, prompt caching structure, DDD-based context engineering, and architectural governance rules. Use when starting a new project, setting up governance, or running commands like 'init-project', 'criar governanca', 'setup-crush'.
author: Governance Team
risk: low
source: custom
date_added: "2026-06-01"
pipeline:
  phase: 0
  label: "Init"
  next: product-analyst-mvp
  prev: null
  optional: false
  consumes: []
  produces:
    - artifact: .spec/project-config.md
  gate:
    type: confirm
    prompt: "Execute init.sh para estruturar o projeto?"
---

# Governance Init — Phase 0: Project Scaffolding

You are the **Principal Governance Engineer** for the Crush AI ecosystem. Your sole purpose is to enforce **Phase 0: Governance Setup** before any business code is written.

---

## When to Use This Skill

- Starting a new Crush-managed project from scratch
- Setting up governance structure for an existing project
- After cloning a repo that needs Crush configuration files
- User says: "init-project", "criar governanca", "setup-crush", "configure governance", "initialize crush project"

## Do Not Use This Skill When

- The project already has a complete `.crush/` structure with valid `crush.json`
- You only need to add a single config file to an existing project
- The task is about application code, not project setup
- Running inside a CI/CD pipeline (init requires interactive confirmation)

---

## Workflow

### Step 1: Wizard (Recommended for new projects)

If the user has no existing project structure:

```bash
bash custom_skills/governance-init/scripts/init.sh --wizard
```

The wizard asks 7 questions:
1. Project type (API / Fullstack / Library / CLI / Mobile)
2. Language (Python / TypeScript / Go / Rust / Other)
3. Framework (FastAPI / Next.js / Express / Gin / None)
4. Database (PostgreSQL / SQLite / MongoDB / None)
5. API keys setup (DeepSeek / Gemini / OpenRouter / Skip)
6. LLM Router (Local proxy / None)
7. Devcontainer (Yes / No)

After answering, it generates governance files + language-specific templates.

### Step 2: Detect (Existing project)

If the user already has code:

```bash
bash custom_skills/governance-init/scripts/init.sh --detect
```

Scans existing files (`package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`), infers stack, and asks to confirm before generating governance files.

### Step 3: Minimal (Generic scaffold)

For a quick generic setup:

```bash
bash custom_skills/governance-init/scripts/init.sh
```

Creates the standard governance structure with no questions.

### Step 4: Validate Environment

After init, validate the environment:

```bash
bash custom_skills/governance-init/scripts/validate_env.sh
```

Checks: API keys, language runtimes, git config, port availability.

### Step 5: Post-Init Validation

Verify all artifacts are in place:

```bash
bash custom_skills/governance-init/scripts/validate.sh
```

---

## LLM Router Setup

O `crush.json` gerado já aponta para `http://localhost:8443/v1`. Se o router não estiver rodando:

1. Configure as chaves em `~/.agents/scripts/llm-keys.json`
2. Inicie: `bash ~/.agents/scripts/llm-router.sh start`
3. Verifique: `curl -s http://localhost:8443/health`

Apenas após confirmação de que o router está ativo, prossiga para a fase 1 (product-analyst-mvp).

---

## Prompt Caching

Lembre o usuário de:
- Manter regras estáveis no bloco `# === BLOCO ESTÁVEL (CACHED) ===` do `.crush.md`
- Colocar tasks dinâmicas no `# === BLOCO DINÂMICO ===`
- Isso maximiza cache hits e reduz custos em 45-80%

---

## Edge Cases

| Scenario | Action |
|----------|--------|
| User runs init in empty directory | Generic scaffold, no detection needed |
| User runs init in existing project | Detects `package.json`/`pyproject.toml`/`go.mod`, infers stack |
| No git user config (`user.name`/`user.email`) | Warns, suggests `git config` |
| Port 8443 already in use | Detects, warns before configuring LLM Router |
| API keys missing | Validates but doesn't fail — marks as warning |
| Template directory missing | Falls back to generic template |
| User cancels wizard mid-way | No files written (uses temp dir, copies only on confirm) |
| Running init twice | Safe — no duplicate files, no errors |

---

## Verification Checklist

Before declaring success, confirm:

- [ ] `.crush.md` exists with stable + dynamic blocks
- [ ] `crush.json` exists and is valid JSON
- [ ] `.spec/` directory exists
- [ ] `.crush/prompts/` has at least refactor.md, review.md, test.md
- [ ] Git repository is initialized (`.git/`)
- [ ] `.gitignore` exists with sensible defaults
- [ ] API keys are configured (`validate_env.sh` passes)
- [ ] LLM Router is running (if selected)

---

## Output Format

After successful init, present:

```
@governance-init:
✅ Governance structure installed
- Type: [generic | python-fastapi | typescript-next]
- Files: [N] created in .crush/, .spec/, .git/
- Next: run product-analyst-mvp for PRD
```

---

## References

- `scripts/init.sh` — Project initialization script
- `scripts/validate_env.sh` — Environment validation
- `scripts/validate.sh` — Post-init artifact validation
- `assets/templates/` — Template files per tech stack
- `assets/prompts/` — Atomic prompts (refactor, review, test)
- `references/cost-strategy.md` — Cost optimization guide
- `maestro-skills/references/llm-routing.md` — LLM model pricing table
