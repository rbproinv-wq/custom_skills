# Architecture Constraints

## Technology Stack
- **Backend**: [e.g., Python 3.12+ / FastAPI / SQLAlchemy]
- **Frontend**: [e.g., React 18 / TypeScript / Tailwind]
- **Database**: [e.g., PostgreSQL 15, Redis]
- **Testing**: [e.g., pytest, Jest]
- **Linting/Formatting**: [e.g., black, isort, ESLint, Prettier]
- **CI/CD**: [e.g., GitHub Actions]

## Architectural Patterns
- [ ] Clean Architecture (entities, use cases, interfaces, infrastructure)
- [ ] Hexagonal Architecture (ports & adapters)
- [ ] Event-Driven (message bus, domain events)
- [ ] CQRS (Command Query Responsibility Segregation)
- [ ] Other: ___________

## Source Code Structure
```
src/
├── domain/           # Entities, value objects, domain services
├── application/      # Use cases, DTOs, interfaces
├── infrastructure/   # Repositories, external APIs, DB adapters
└── interfaces/       # REST, CLI, messaging
tests/
├── unit/
├── integration/
└── e2e/
```

## Error Handling Policy
- Domain errors throw typed exceptions (e.g., `DomainError`)
- Never expose internal stack traces to clients
- Use structured logging (JSON) for all errors
- Retry policy for transient faults: [e.g., 3 retries with exponential backoff]

## Static Analysis & Linting
- **Python**: mypy --strict, pylint, bandit
- **TypeScript**: ESLint with security plugin, ts-strict
- **Pre-commit hooks**: enabled
- **Cyclomatic complexity limit**: 7
- **Function length limit**: 30 lines

## Dependency Injection
- Use explicit injection (constructor injection). No global `get_instance()` or `service_locator`.
- All external dependencies (DB, HTTP clients, file system) must be injectable for testing.
