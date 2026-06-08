# RubyOs Learning Types Reference

## Overview

RubyOs supports 6 types of learnings, each designed for specific knowledge capture scenarios.

## Learning Types

### 1. ADR (Architecture Decision Record)

**Use for**: Documenting architectural decisions and their rationale.

**Example**:
```bash
rubyos learn \
  --topic "Use PostgreSQL over MongoDB for user data" \
  --content "Chose PostgreSQL for ACID compliance, complex queries, and mature ecosystem. MongoDB rejected due to lack of transactions and schema flexibility not needed for this use case." \
  --type adr \
  --project my-app \
  --tags "database,architecture,postgresql"
```

**When to use**:
- Choosing between technologies
- Designing system architecture
- Making trade-off decisions
- Documenting technical standards

### 2. Bug Solution

**Use for**: Recording solutions to bugs and errors encountered.

**Example**:
```bash
rubyos learn \
  --topic "Fix PostgreSQL connection timeout" \
  --content "Increased pool_size from 5 to 20 and added PgBouncer for connection pooling. Root cause: too many short-lived connections exhausting the pool." \
  --type bug_solution \
  --project my-app \
  --tags "postgres,performance,connection-pooling"
```

**When to use**:
- Debugging complex issues
- Finding workarounds
- Resolving environment problems
- Fixing integration bugs

### 3. Architecture Decision

**Use for**: Documenting design decisions and system architecture.

**Example**:
```bash
rubyos learn \
  --topic "Microservices vs Monolith for payment system" \
  --content "Chose microservices for payment system to isolate failure domains and enable independent scaling. Monolith rejected due to coupling risks with financial transactions." \
  --type architecture_decision \
  --project my-app \
  --tags "architecture,microservices,payments"
```

**When to use**:
- Designing system structure
- Planning service boundaries
- Defining API contracts
- Setting up infrastructure

### 4. Tech Discovery

**Use for**: Recording new technical discoveries and capabilities.

**Example**:
```bash
rubyos learn \
  --topic "Redis Streams for real-time events" \
  --content "Discovered Redis Streams can replace Kafka for small-scale event streaming. Lower operational overhead, simpler setup, sufficient for <10K events/sec." \
  --type tech_discovery \
  --project my-app \
  --tags "redis,events,streaming"
```

**When to use**:
- Finding new tools or libraries
- Learning framework features
- Discovering optimization techniques
- Understanding system capabilities

### 5. Lesson Learned

**Use for**: General lessons from development experience.

**Example**:
```bash
rubyos learn \
  --topic "Always validate inputs at API boundary" \
  --content "Spent 3 hours debugging SQL injection because input validation was only at database layer. Always validate and sanitize at the API boundary first." \
  --type lesson_learned \
  --project my-app \
  --tags "security,validation,best-practices"
```

**When to use**:
- After making mistakes
- Discovering best practices
- Learning from code reviews
- Understanding team patterns

### 6. Task Summary

**Use for**: Summarizing completed tasks and their outcomes.

**Example**:
```bash
rubyos learn \
  --topic "Implemented user authentication flow" \
  --content "Completed JWT-based auth with refresh tokens. Features: login, logout, token refresh, password reset. Tests: 95% coverage. Performance: <50ms response time." \
  --type task_summary \
  --project my-app \
  --tags "auth,jwt,api"
```

**When to use**:
- Completing features
- Finishing bug fixes
- Releasing updates
- Documenting progress

## Best Practices

### Content Guidelines

1. **Be specific**: Include exact commands, configurations, or code snippets
2. **Include context**: Explain why, not just what
3. **Add outcomes**: What was the result?
4. **Tag appropriately**: Use consistent tags for easy retrieval

### Tag Conventions

- Use lowercase: `postgres`, not `PostgreSQL`
- Use hyphens: `connection-pooling`, not `connection_pooling`
- Be descriptive: `jwt-auth`, not `auth`
- Include technology: `redis-cache`, not just `cache`

### Topic Guidelines

- Start with action verb: "Implement...", "Fix...", "Discover..."
- Be concise: Under 10 words
- Include key technology: "Redis caching layer", not "Caching"

## Querying Learnings

### By Type

```bash
# Get all bug solutions
rubyos query_knowledge --type bug_solution

# Get all ADRs
rubyos query_knowledge --type adr
```

### By Project

```bash
# Get learnings for specific project
rubyos query_knowledge --project my-app
```

### By Tags

```bash
# Get learnings with specific tags
rubyos query_knowledge --tags "postgres,performance"
```

### Semantic Search

```bash
# Natural language query
rubyos query_knowledge "how to handle JWT refresh tokens"

# With threshold
rubyos query_knowledge "database optimization" --threshold 0.8
```
