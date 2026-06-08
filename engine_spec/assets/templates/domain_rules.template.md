# Domain Rules & Ubiquitous Language

## Ubiquitous Language (Glossary)
| Term | Definition | Synonyms (avoid) |
|------|------------|------------------|
| [Term1] | [Exact meaning in this domain] | [Prohibited terms] |
| [Term2] | [Exact meaning] | ... |

## Invariant Business Rules
These rules must always hold, regardless of implementation details.

1. **[Rule Name]**: [Description]. Example: `Total price cannot be negative.`
2. **[Rule Name]**: [Description]. Example: `User must have a unique email across the system.`
3. **[Rule Name]**: [Description].

## Global User Flows (End-to-End)
- **Flow A**: [Actor] → [Trigger] → [Steps] → [Outcome]
- **Flow B**: ...

## Domain Events (if applicable)
| Event | Trigger | Payload |
|-------|---------|---------|
| `UserRegistered` | After user creation | `{ user_id, email, timestamp }` |

## External Integrations & Contracts
- **Service X**: [Input format, output format, error codes]
- **Service Y**: ...

## Validation & Constraint Rules
- **Data validation**: [e.g., email regex, phone number format]
- **Business time constraints**: [e.g., discount only valid between 8am-6pm]
- **Legal/compliance rules**: [e.g., GDPR data retention period 30 days]