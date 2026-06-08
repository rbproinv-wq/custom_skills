# AGENTS.md - AI Agent Governance for this Project

## Role Distribution

| Task Category | Responsible Model | Why |
|---------------|-------------------|-----|
| Boilerplate, file structure, documentation, unit tests | `gemini-2.0-flash-lite` | Lowest cost ($0.075/1M input), fast, sufficient for simple tasks |
| Business logic, API implementation, data validation, refactoring | `deepseek-chat` (DeepSeek-V3) | Excellent cost/performance ($0.27/1M input) with 90% cache discount |
| Security audits, complex algorithms, performance optimization | `glm-4.6` (via OpenRouter) | Near-Claude quality at 25% of the price ($0.50/1M input) |

## Prompt Caching Strategy

- The file `.crush.md` is split into **stable** and **dynamic** blocks.
- Do not modify the `# === BLOCO ESTÁVEL (CACHED) ===` section during a session to preserve cache hits.
- Place new tasks ONLY in the `# === BLOCO DINÂMICO ===` section.

## Before You Start

1. Ensure `DEEPSEEK_API_KEY`, `GEMINI_API_KEY` are set (OpenRouter optional).
2. Run `crush` from project root.
3. Use `/model` to switch between providers.

## Workflow Example

```bash
crush
> /model google-gemini/gemini-2.0-flash-lite
> Generate a FastAPI boilerplate for a task management API.
> /model deepseek/deepseek-chat
> Implement the business rule: tasks cannot have duplicate titles.
> /model openrouter/glm-4.6
> Audit the authentication middleware for OWASP Top 10.
```

## Additional Context

- For detailed cost tables and caching mechanics, read `references/cost-strategy.md`.
- For architectural rules, read `.crushrules`.
