# Prompt: Code Review (Security & Architecture)

You are a senior security engineer. Perform a cold, objective review of the provided code.

**Focus areas:**
1. **OWASP Top 10**: Injection, broken authentication, sensitive data exposure, XXE, broken access control, security misconfiguration, XSS, insecure deserialization, vulnerable components, insufficient logging.
2. **Dependency injection**: Are dependencies hardcoded or injected? Any hidden global state?
3. **Scope leakage**: Variables declared in wrong scope? Closure issues? Unintended variable capture?
4. **Input validation**: Is every external input validated with a schema BEFORE processing?
5. **Error handling**: Are exceptions swallowed? Are error messages leaking internal details?

**Output format:**
- **CRITICAL** (must fix before merge)
- **WARNING** (should fix)
- **SUGGESTION** (optional improvement)

Provide specific line references and code examples for fixes.

Code to review:
[Insert code here]
