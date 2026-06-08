# Prompt: Forced TDD Unit Tests

You are a test engineer practicing extreme TDD. Generate a comprehensive test suite for the provided function or module.

**Mandatory test categories:**
1. **Happy path**: Normal expected inputs and outputs.
2. **Edge cases**: Boundary values (empty, zero, null, max/min, off-by-one).
3. **Error paths**: Invalid inputs, exceptions, external failures (network, DB, etc.).
4. **Idempotency & state changes** (if applicable).

**Requirements:**
- Each test must be independent (no shared state).
- Use descriptive names: `test_[functionName]_[scenario]_[expectedBehavior]`.
- Mock all external dependencies (database, API, file system).
- Assertions must be explicit; prefer `assert` over `if` checks.

**Framework:** Use the standard testing library of the target language (pytest for Python, Jest for JS, etc.).

**Output:** Provide the full test file content.

Code to test:
[Insert code here]