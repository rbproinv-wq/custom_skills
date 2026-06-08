# RubyOs Knowledge System

## Overview

The RubyOs knowledge system provides semantic search, learning management, and cross-project knowledge sharing. It stores learnings locally in JSON and optionally syncs to Supabase for cloud storage and advanced search.

## Architecture

### Local Storage

```
.rub-os/
├── pending-learnings.json    # Learnings awaiting sync
├── session-state.json        # Current session state
└── activity-log.md           # Chronological action log
```

### Cloud Storage (Optional)

- **Supabase**: PostgreSQL + pgvector for semantic search
- **Embeddings**: Generated via Edge Function using `gte-small` model (384 dimensions)
- **FTS Fallback**: Full-text search when embeddings unavailable

## Learning Structure

```json
{
  "id": 1,
  "topic": "Handle clock skew in JWT validation",
  "content": "Always add 30-second tolerance to JWT expiration checks...",
  "type": "lesson_learned",
  "project": "my-app",
  "tags": ["jwt", "authentication", "clock-skew"],
  "code_snippet": "if token.exp < time.time() - 30: ...",
  "agent": "rubyos",
  "created_at": "2026-06-06T11:00:00Z",
  "updated_at": "2026-06-06T11:00:00Z"
}
```

## Creating Learnings

### Via CLI

```bash
rubyos learn \
  --topic "Solution for PostgreSQL timeout" \
  --content "Increased pool_size to 20 and added PgBouncer" \
  --type bug_solution \
  --project my-app \
  --tags "postgres,performance" \
  --code-snippet "pool_size = 20"
```

### Via MCP (if configured)

```bash
rubyos create_learning \
  --topic "Solution for PostgreSQL timeout" \
  --content "Increased pool_size to 20 and added PgBouncer" \
  --type bug_solution \
  --project my-app \
  --tags "postgres,performance"
```

### Learning Types

| Type | Description | Use Case |
|------|-------------|----------|
| `adr` | Architecture Decision Record | Technology choices |
| `bug_solution` | Bug fix documentation | Error resolution |
| `architecture_decision` | Design decisions | System design |
| `tech_discovery` | Technical discoveries | New tools/features |
| `lesson_learned` | General lessons | Best practices |
| `task_summary` | Task completion summary | Feature documentation |

## Querying Knowledge

### Semantic Search

```bash
# Natural language query
rubyos query_knowledge "how to handle JWT refresh tokens"

# With filters
rubyos query_knowledge "database optimization" \
  --project my-app \
  --type bug_solution \
  --limit 10 \
  --threshold 0.7
```

### Recent Learnings

```bash
# Get recent learnings for a project
rubyos recent_learnings --project my-app --limit 5

# Get all recent learnings
rubyos recent_learnings --limit 10
```

### Hybrid Search

```bash
# Combine semantic and keyword search
rubyos hybrid_search "postgres connection timeout"
```

## Affinity Boosting

RubyOs boosts relevance for learnings from:

1. **Same Project**: +20% relevance boost
2. **Similar Tags**: +10% relevance boost
3. **Recent Activity**: Higher ranking for recent learnings

### Example

Query: "database performance"
- Learning from same project about PostgreSQL: 0.85 * 1.2 = 1.02
- Learning from different project about MySQL: 0.75
- Learning with matching tags: 0.80 * 1.1 = 0.88

## Cross-Project Knowledge

Learnings are shared across all projects by default. This enables:

1. **Knowledge reuse**: Solutions from one project help others
2. **Pattern detection**: Common issues across projects
3. **Best practices**: Shared learnings improve all projects

### Filtering by Project

```bash
# Get learnings for specific project
rubyos query_knowledge "authentication" --project my-app

# Get all learnings (cross-project)
rubyos query_knowledge "authentication"
```

## Quality Gates

RubyOs validates learnings before creation:

### Minimum Requirements

1. **Topic**: At least 10 characters
2. **Content**: At least 50 characters
3. **Type**: Must be valid learning type
4. **Project**: Required for all learnings

### Duplicate Detection

```bash
# Check for similar learnings
rubyos learn --topic "..." --content "..." --dry-run

# Output:
# ⚠️ Duplicação detectada: 'Similar learning title' (similaridade: 87.1%)
```

### Force Creation

```bash
# Skip quality gates (not recommended)
rubyos learn --topic "..." --content "..." --force
```

## Syncing to Supabase

### Manual Sync

```bash
# Sync all pending learnings
rubyos sync

# Sync with verbose output
rubyos sync --verbose

# Check sync status
cat .rub-os/pending-learnings.json | jq '. | length'
```

### Automatic Sync

Learnings are automatically queued for sync when created. The sync happens:

1. When `rubyos sync` is run
2. At end of session (if configured)
3. Periodically (if background sync enabled)

### Sync Status

```bash
# Check pending learnings
rubyos status

# Output:
# Learnings pending sync: 4
# Execute `rubyos sync` to synchronize
```

## Dashboard

Generate HTML dashboard of all learnings:

```bash
# Generate dashboard
rubyos learnings-dashboard

# Opens ~/.RubyOs/dashboard.html in browser
```

### Dashboard Features

- **Learning timeline**: Visualize learning creation over time
- **Tag cloud**: See most common tags
- **Project breakdown**: Learnings per project
- **Type distribution**: Balance of learning types
- **Search**: Find specific learnings

## Configuration

### Supabase Setup

```bash
# Set service key
echo "your-service-key" > ~/.rub-os/supabase-key.txt

# Or use environment variable
export SUPABASE_SERVICE_KEY="your-service-key"
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SUPABASE_SERVICE_KEY` | Supabase service key | None |
| `RUBYOS_HOME` | RubyOs installation path | `~/.RubyOs` |
| `RUBYOS_PROJECT` | Current project name | Directory name |

### Configuration File

```json
// .rub-os/config.json
{
  "supabase": {
    "enabled": true,
    "project_ref": "your-project-ref"
  },
  "sync": {
    "auto": true,
    "interval": 300
  },
  "quality_gates": {
    "min_topic_length": 10,
    "min_content_length": 50,
    "duplicate_threshold": 0.85
  }
}
```

## Best Practices

### Creating Learnings

1. **Be specific**: Include exact commands, configurations, or code
2. **Add context**: Explain why, not just what
3. **Include outcomes**: What was the result?
4. **Tag appropriately**: Use consistent tags for easy retrieval
5. **Add code snippets**: Include relevant code examples

### Querying Knowledge

1. **Start broad**: Use general queries first
2. **Filter by project**: When working on specific project
3. **Use semantic search**: For natural language queries
4. **Check recent learnings**: For latest insights

### Managing Knowledge

1. **Review pending learnings**: Regularly sync to Supabase
2. **Update outdated learnings**: Keep knowledge current
3. **Delete duplicates**: Maintain clean knowledge base
4. **Export dashboard**: Share insights with team

## Troubleshooting

### Learnings Not Being Created

```bash
# Check quality gates
rubyos learn --topic "short" --content "content" --dry-run

# Check pending learnings
cat .rub-os/pending-learnings.json

# Force creation (bypass gates)
rubyos learn --topic "..." --content "..." --force
```

### Search Not Working

```bash
# Check Supabase connection
rubyos query_knowledge "test" --verbose

# Check if learnings exist
cat .rub-os/pending-learnings.json | jq '. | length'

# Test semantic search
rubyos query_knowledge "test" --threshold 0.5
```

### Sync Failing

```bash
# Check Supabase key
cat ~/.rub-os/supabase-key.txt

# Check network connection
rubyos sync --verbose

# Manual sync
rubyos sync --force
```

## Advanced Usage

### Custom Learning Templates

```bash
# Create learning from template
rubyos learn \
  --topic "Bug: [ERROR_TYPE]" \
  --content "
## Problem
[Description of the problem]

## Root Cause
[What caused the issue]

## Solution
[How it was fixed]

## Prevention
[How to prevent this in the future]
" \
  --type bug_solution \
  --project my-app \
  --tags "bug,template"
```

### Batch Learning Creation

```bash
# Create multiple learnings
cat learnings.txt | while read line; do
  rubyos learn --topic "$line" --content "..." --type lesson_learned --project my-app
done
```

### Knowledge Export

```bash
# Export all learnings
cat .rub-os/pending-learnings.json | jq '.' > learnings-export.json

# Export by project
cat .rub-os/pending-learnings.json | jq '[.[] | select(.project == "my-app")]' > my-app-learnings.json

# Export by type
cat .rub-os/pending-learnings.json | jq '[.[] | select(.type == "bug_solution")]' > bug-solutions.json
```

## Integration Examples

### With Git

```bash
# After fixing a bug
rubyos learn \
  --topic "Fix race condition in user creation" \
  --content "Added database lock with SELECT FOR UPDATE" \
  --type bug_solution \
  --project my-app \
  --tags "database,race-condition"

# Commit with reference
git commit -m "fix: prevent duplicate user creation

Added database lock with SELECT FOR UPDATE to prevent race condition.

RubyOs learning: bug_solution/race-condition-locking"
```

### With CI/CD

```yaml
# .github/workflows/learn.yml
name: Capture Learning

on:
  issues:
    types: [closed]

jobs:
  capture:
    if: contains(github.event.issue.labels.*.name, 'bug')
    steps:
      - uses: actions/checkout@v3
      - name: Create Learning
        run: |
          rubyos learn \
            --topic "Bug: ${{ github.event.issue.title }}" \
            --content "${{ github.event.issue.body }}" \
            --type bug_solution \
            --project my-app \
            --tags "bug,github-issue"
```

### With Code Review

```bash
# After code review feedback
rubyos learn \
  --topic "Always validate inputs at API boundary" \
  --content "Code review found SQL injection vulnerability. Input validation was only at database layer." \
  --type lesson_learned \
  --project my-app \
  --tags "security,validation,code-review"
```
