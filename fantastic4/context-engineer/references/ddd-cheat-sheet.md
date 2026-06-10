# DDD Tactical Patterns Cheat Sheet

## Entities
- Have a unique identity (ID) that remains constant even if attributes change.
- Implement equality based on ID, not all fields.
- Example:
  ```python
  class User:
      def __init__(self, user_id: UserId, email: str):
          self.id = user_id
          self.email = email
      def __eq__(self, other):
          return isinstance(other, User) and self.id == other.id
  ```

## Value Objects
- Immutable; no identity; defined by their attributes.
- Equality based on all fields.
- Example:
  ```python
  class Email:
      def __init__(self, address: str):
          self._value = self._validate(address)
      def _validate(self, addr): ...
      def __eq__(self, other):
          return isinstance(other, Email) and self._value == other._value
  ```

## Aggregates
- A cluster of entities and value objects treated as a unit.
- One root entity (Aggregate Root) controls access.
- External objects can only hold references to the Aggregate Root.
- Example: `Order` (root) contains `OrderLine` items.

## Domain Services
- Stateless operations that don't naturally fit into an entity or value object.
- Example: `TransferService` moving money between two accounts.

## Repositories
- Provide collection-like interface to retrieve and persist aggregates.
- Hides storage details; returns fully constructed aggregates.
- Example: `UserRepository.find_by_email(email)`

## Domain Events
- Record something significant that happened in the domain.
- Past tense naming: `UserRegistered`, `PaymentProcessed`.
- Handled asynchronously (event bus) to decouple contexts.

## Factories
- Encapsulate complex creation logic of aggregates or value objects.
- Example: `UserFactory.create_verified_user(email, name)`

## Anti-Corruption Layer (ACL)
- Translates between two bounded contexts (e.g., legacy system and new domain).
- Prevents foreign concepts from leaking into the core domain.

## Layering (Clean/Hexagonal)
- **Domain Layer**: Entities, value objects, domain services, events – NO infrastructure imports.
- **Application Layer**: Use cases, orchestrators – depends on domain interfaces.
- **Infrastructure Layer**: Repositories, external APIs, DB mappers – implements domain interfaces.
- **Interface Layer**: REST, CLI, GUI – uses application services.

## Concrete Example: User Registration
```
[Interface Layer] POST /register
       ↓
[Application] RegisterUserUseCase
       ↓ checks
[Domain] User entity, Email value object, UserRegistered event
       ↓
[Infrastructure] UserRepository (saves to DB), EventPublisher
```

## Always Ask
- Does this behavior belong to an entity, a value object, or a domain service?
- Is this business rule invariant across all implementations?
- Are infrastructure concerns (logging, DB, HTTP) injected, not hardcoded?
