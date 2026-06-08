# RubyOs Post-Mortem Workflow

## Overview

The post-mortem command analyzes session errors and generates prevention rules. It's one of RubyOs' most powerful features for continuous improvement.

## When to Use

- End of a development session
- After encountering multiple errors
- When debugging complex issues
- Before starting a new task (to learn from past mistakes)

## How It Works

### 1. Activity Log Analysis

The post-mortem reads `.rub-os/activity-log.md` to understand what happened during the session:

```
| 2026-06-06T10:30:00Z | rubyos | skill: jwt-auth | Implemented JWT middleware |
| 2026-06-06T10:45:00Z | rubyos | skill: jwt-auth | ERROR: Token validation failed |
| 2026-06-06T11:00:00Z | rubyos | skill: jwt-auth | Fixed: Added clock skew tolerance |
```

### 2. Error Pattern Detection

The system identifies:
- **Repeated errors**: Same error occurring multiple times
- **Error cascades**: One error leading to another
- **Time patterns**: Errors clustered in specific time periods
- **Tool patterns**: Errors related to specific tools or commands

### 3. Rule Generation

For each error pattern, the system generates:

```markdown
## Rule: Always handle clock skew in JWT validation

**Trigger**: JWT token validation fails with "token not yet valid" or "token expired"
**Prevention**: Add 30-second clock skew tolerance to JWT validation
**Example**:
```python
# Bad
if token.exp < time.time():
    raise InvalidTokenError()

# Good
if token.exp < time.time() - 30:  # 30 second tolerance
    raise InvalidTokenError()
```
```

### 4. Learning Creation

The post-mortem creates `lesson_learned` learnings for significant errors:

```bash
rubyos learn \
  --topic "Handle clock skew in JWT validation" \
  --content "Always add 30-second tolerance to JWT expiration checks. Clock skew between servers causes intermittent validation failures." \
  --type lesson_learned \
  --project my-app \
  --tags "jwt,authentication,clock-skew"
```

### 5. MEMORY.md Update

The session summary is added to `MEMORY.md`:

```markdown
## Session: 2026-06-06

### Errors Encountered
- JWT validation failed due to clock skew (fixed)

### Lessons Learned
- Always add clock skew tolerance to JWT validation

### Next Steps
- Implement token refresh mechanism
- Add rate limiting to auth endpoints
```

## Running Post-Mortem

### Basic Usage

```bash
rubyos post-mortem
```

### With Options

```bash
# Verbose output
rubyos post-mortem --verbose

# Dry run (don't create learnings)
rubyos post-mortem --dry-run

# Specific time range
rubyos post-mortem --since "2026-06-06"
```

### Via MCP (if configured)

```bash
# Using MCP tool
rubyos run_post_mortem
```

## Output Files

### activity-log.md

Chronological log of all actions:

```markdown
| Timestamp | Agent | Skill | Action |
|-----------|-------|-------|--------|
| 2026-06-06T10:30:00Z | rubyos | jwt-auth | Implemented JWT middleware |
| 2026-06-06T10:45:00Z | rubyos | jwt-auth | ERROR: Token validation failed |
```

### pending-learnings.json

Learnings awaiting sync to Supabase:

```json
[
  {
    "topic": "Handle clock skew in JWT validation",
    "content": "Always add 30-second tolerance...",
    "type": "lesson_learned",
    "project": "my-app",
    "tags": ["jwt", "authentication"],
    "created_at": "2026-06-06T11:00:00Z"
  }
]
```

### MEMORY.md

Session memory for continuity:

```markdown
## Last Session: 2026-06-06

### State
- Project: my-app
- Status: Active
- Errors: 1 (resolved)

### Lessons
- JWT validation needs clock skew tolerance

### Pending
- 1 learning awaiting sync
```

## Best Practices

### Before Session

1. Check `rubyos status` for project state
2. Review recent learnings: `rubyos query_knowledge --project my-app --limit 5`
3. Load relevant context: `rubyos load-context`

### During Session

1. Log activities: `rubyos learn --topic "..." --content "..." --type "..." --project "..."`
2. Note errors immediately in activity log
3. Query knowledge before solving problems: `rubyos query_knowledge "error message"`

### After Session

1. Run post-mortem: `rubyos post-mortem`
2. Review generated rules
3. Save context: `rubyos save-context`
4. Sync learnings: `rubyos sync`

## Integration with Development Workflow

### Git Integration

```bash
# After fixing a bug
rubyos learn \
  --topic "Fix race condition in user creation" \
  --content "Added database lock with SELECT FOR UPDATE to prevent duplicate user creation" \
  --type bug_solution \
  --project my-app \
  --tags "database,race-condition,locking"

# Commit with reference
git commit -m "fix: prevent duplicate user creation

Added database lock with SELECT FOR UPDATE to prevent race condition.

RubyOs learning: bug_solution/race-condition-locking"
```

### Code Review Integration

```bash
# After code review feedback
rubyos learn \
  --topic "Always validate inputs at API boundary" \
  --content "Code review found SQL injection vulnerability. Input validation was only at database layer. Always validate at API boundary first." \
  --type lesson_learned \
  --project my-app \
  --tags "security,validation,code-review"
```

### Testing Integration

```bash
# After finding edge case
rubyos learn \
  --topic "Test timezone handling in date comparisons" \
  --content "Found bug where date comparisons failed across timezones. Always use UTC for storage and comparison." \
  --type bug_solution \
  --project my-app \
  --tags "testing,timezone,dates"
```

## Troubleshooting

### Post-Mortem Not Finding Errors

```bash
# Check activity log exists
ls -la .rub-os/activity-log.md

# Check log has content
wc -l .rub-os/activity-log.md

# Run with verbose output
rubyos post-mortem --verbose
```

### Learnings Not Being Created

```bash
# Check pending learnings
cat .rub-os/pending-learnings.json

# Check Supabase connection (if configured)
rubyos sync --verbose

# Manually create learning
rubyos learn --topic "..." --content "..." --type lesson_learned --project "..."
```

### MEMORY.md Not Updating

```bash
# Check MEMORY.md permissions
ls -la MEMORY.md

# Manually save context
rubyos save-context --verbose

# Check session state
cat .rub-os/session-state.json
```

## Advanced Usage

### Custom Post-Mortem Scripts

```python
#!/usr/bin/env python3
"""Custom post-mortem analysis."""

import json
from pathlib import Path

# Load activity log
log_path = Path(".rub-os/activity-log.md")
if log_path.exists():
    with open(log_path) as f:
        lines = f.readlines()
    
    # Find errors
    errors = [l for l in lines if "ERROR" in l]
    print(f"Found {len(errors)} errors in session")
    
    # Analyze patterns
    error_types = {}
    for error in errors:
        # Extract error type
        parts = error.split("|")
        if len(parts) >= 4:
            action = parts[3].strip()
            error_type = action.split(":")[0] if ":" in action else "unknown"
            error_types[error_type] = error_types.get(error_type, 0) + 1
    
    print("Error patterns:")
    for etype, count in error_types.items():
        print(f"  {etype}: {count}")
```

### Automated Post-Mortem Hook

```bash
# Add to .git/hooks/post-commit
#!/bin/bash
# Run post-mortem after each commit

if command -v rubyos &> /dev/null; then
    rubyos post-mortem --dry-run
fi
```

### Integration with CI/CD

```yaml
# .github/workflows/post-mortem.yml
name: Post-Mortem Analysis

on:
  push:
    branches: [main]

jobs:
  post-mortem:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Post-Mortem
        run: |
          rubyos post-mortem --dry-run --output report.json
      - name: Upload Report
        uses: actions/upload-artifact@v3
        with:
          name: post-mortem-report
          path: report.json
```
