# Cost Strategy & Prompt Caching Guide

> ⚠️ **Prices change frequently — verify at provider docs before relying.**

Consulte `maestro-skills/references/llm-routing.md` para a tabela mais atualizada de
modelos, preços e roteamento. Este documento cobre conceitos gerais de cache.

---

## How Prompt Caching Works

- Providers store the **prefix** of your prompt (the first N tokens).
- If the same prefix appears in a future request, those tokens are **cached** and billed at a lower rate (up to 90% discount).
- The cache persists for several minutes to hours (depending on provider) after the last use.

## To Maximize Cache Savings (Structured Prompt Template)

Place **ALL stable content** at the **very beginning** of your prompt:

```markdown
# === BLOCO ESTÁVEL (CACHED) ===
## ROLE
You are a senior engineer.

## RULES
- Always use type hints.
- Maximum 30 lines per function.

# === BLOCO DINÂMICO ===
## TASK
Implement a login endpoint.
```

## Expected Savings

- For loops of 5+ similar requests: **45–80% cost reduction** (arXiv:2601.05871).
- Cache hit reduces first-token latency by **13–31%**.

## Recommended Workflow

1. Keep `.crush.md` stable block identical across sessions.
2. Use the same Crush session for related tasks.
3. Avoid changing the system prompt mid-session unless necessary.
4. For DeepSeek-V3, explicit cache hits are applied automatically — no extra config needed.

## BFRI Scoring (Optional Governance Metric)

O **Backend Feasibility & Risk Index** (BFRI) avalia o projeto em 5 dimensões:

| Dimension | Scale | What It Measures |
|-----------|-------|-----------------|
| Architectural Fit | 1-5 | How well the stack matches requirements |
| Business Logic Complexity | 1-5 | How complex the core domain logic is |
| Data Risk | 1-5 | Sensitivity and volume of data |
| Operational Risk | 1-5 | Deployment, monitoring, compliance burden |
| Testability | 1-5 | How easy to test critically |

Use BFRI como gate pós-init para avaliar se o projeto está maduro para começar.

## References

- DeepSeek Cache: https://api-docs.deepseek.com/cache
- Anthropic Prompt Caching: https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching
- arXiv "Don't Break the Cache" (2601.05871)
