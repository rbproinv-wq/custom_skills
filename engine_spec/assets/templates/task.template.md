# Task: [Unique Identifier - short slug]

## Objective
[One sentence describing what this task accomplishes, no implementation details]

## Related Context
- **Module**: `[module name (filename without .md)]`
- **Domain Rules** (from `domain_rules.md`): [list relevant rule IDs or names]
- **Architecture Constraints** (from `architecture.md`): [list relevant sections]

## Inputs (exact)
| Name | Type | Required | Description | Validation |
|------|------|----------|-------------|------------|
| `input1` | `string` | Yes | User email | Must be valid email format |
| `input2` | `int` | No | Timeout in ms | Default 5000, min 100 |

## Outputs (exact)
| Name | Type | Description |
|------|------|-------------|
| `result` | `UserDTO` | Contains id, email, and created_at |
| `error` | `DomainError` | If validation fails, returns InvalidEmailError |

## Acceptance Criteria (Mandatory)
- [ ] AC1: Given valid inputs, function returns correct UserDTO.
- [ ] AC2: Given invalid email, function raises InvalidEmailError.
- [ ] AC3: Given missing required input, function raises MissingInputError.
- [ ] AC4: Idempotency – calling twice with same data returns same DTO (no duplicate side effects).

## Dependencies on other tasks
- This task depends on: [list task IDs or "none"]

## Suggested Test Cases (to be generated)
- Happy path: ...
- Edge: empty string, null, boundary values
- Error paths: missing field, malformed data

## Notes / Implementation Hints
- [Any non‑obvious guidance for the developer agent]