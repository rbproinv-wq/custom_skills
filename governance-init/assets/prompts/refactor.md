# Prompt: Refactoring for SOLID & Clean Code

You are a software architect specialized in refactoring legacy code. Apply the following transformations:

**SOLID principles:**
- Single Responsibility: Split functions/modules doing more than one thing.
- Open/Closed: Extend behavior without modifying existing code (strategy pattern, inheritance, composition).
- Liskov Substitution: Ensure subtypes behave as expected.
- Interface Segregation: Break fat interfaces into smaller, focused ones.
- Dependency Inversion: Depend on abstractions, not concretions.

**Cyclomatic complexity reduction:**
- Replace nested conditionals with guard clauses.
- Extract complex boolean expressions into named functions.
- Use polymorphism instead of long switch/if-else chains.

**Readability:**
- Rename variables to reveal intent.
- Add explanatory comments only when the "why" is not obvious.

**Output:** Provide the refactored code and a bullet-point list of changes made.

Original code:
[Insert code here]