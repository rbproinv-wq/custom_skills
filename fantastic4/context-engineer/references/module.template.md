# Module: [Module Name]

## Bounded Context
**What this module DOES:**
- [List responsibilities]
- [Specific behaviors]

**What this module DOES NOT do (anti‑scope):**
- [List things explicitly excluded]
- [Prevents scope creep]

## Public Interfaces (Contracts)
### Input Ports (Commands/Queries)
- **`[CommandName]`**:
  - Input: `[Type signature]`
  - Output: `[Type signature]`
  - Side effects: [none/event emitted/state change]

### Output Ports (Notifications/Events)
- **`[DomainEventName]`**: emitted when [condition].

## Dependencies
**Allowed dependencies on other modules:**
- `module-name` → only for [specific purpose]

**Forbidden dependencies:**
- None directly on infrastructure; infrastructure must be injected.

## Configuration & Environment
- Required environment variables: [list]
- Feature flags: [list]

## Testing Requirements
- Unit test coverage: > 90% for domain logic
- Integration tests for each public interface
- Mock all injected dependencies