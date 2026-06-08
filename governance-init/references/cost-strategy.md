# Cost Strategy & Prompt Caching Guide (June 2026)

## Official Model Pricing (per 1M tokens)

| Model                  | Input ($) | Output ($) | Cache Hit ($) | Context Window |
|------------------------|-----------|------------|---------------|----------------|
| Gemini 2.0 Flash-Lite  | 0.075     | 0.30       | ~0.01*        | 1M             |
| DeepSeek-V3            | 0.27      | 1.10       | 0.07 (90% off) | 64K (128K API) |
| GLM-4.6 (via OpenRouter) | 0.50   | 2.00       | ~0.05*        | 128K           |

*Estimated – actual cache discounts may vary by provider.

## How Prompt Caching Works

- Providers store the **prefix** of your prompt (the first N tokens).
- If the same prefix appears in a future request, those tokens are **cached** and billed at a lower rate (up to 90% discount).
- The cache persists for several minutes to hours (depending on provider) after the last use.

## To Maximize Cache Savings (Structured Prompt Template)

Place **ALL stable content** at the **very beginning** of your prompt. Example:

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
4. For DeepSeek-V3, explicit cache hits are applied automatically – no extra config needed.

## Routing Guidelines (Cost Optimization)

| Task Complexity | Recommended Model              | Approx Cost (per 10K tokens) |
|----------------|--------------------------------|-------------------------------|
| Boilerplate, docs, tests | Gemini 2.0 Flash-Lite | $0.00075                      |
| Business logic, CRUD      | DeepSeek-V3                  | $0.0027                       |
| Security audit, complex algorithm | GLM-4.6 (OpenRouter) | $0.005                        |

## References

- DeepSeek Cache Documentation: https://api-docs.deepseek.com/cache
- Anthropic Prompt Caching: https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching
- arXiv paper "Don't Break the Cache" (2601.05871)
