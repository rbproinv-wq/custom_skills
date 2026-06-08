---
name: rubyos
description: "AI-assisted development operating system with knowledge management, session tracking, and continuous learning. Use when working on projects that use RubyOs for learning storage, post-mortem analysis, or activity logging."
risk: low
source: "https://github.com/rbproinv-wq/rubyos-core"
date_added: "2026-06-06"
user-invokable: true
argument-hint: "[command] [options]"
---

# RubyOs: AI-Assisted Development OS

RubyOs is a knowledge management and continuous learning system for AI-assisted development. It provides CLI tools for session tracking, post-mortem analysis, learning creation, and activity logging.

## Installation

RubyOs is installed at `~/.RubyOs/`. Verify installation:

```bash
ls ~/.RubyOs/rubyos-mcp-server.py
ls ~/.RubyOs/kernel/
```

## Quick Reference

| Command | Description |
|---------|-------------|
| `rubyos status` | Show project state (active/sleeping) |
| `rubyos init` | Initialize RubyOs in current directory |
| `rubyos learn --topic X --content Y --type Z --project P` | Create a learning |
| `rubyos learnings-dashboard` | Generate HTML dashboard of learnings |
| `rubyos post-mortem` | Analyze session errors and generate rules |
| `rubyos review` | Adversarial review of implementation |
| `rubyos verify-goals` | Check acceptance criteria |
| `rubyos save-context` | Save session context to MEMORY.md |
| `rubyos load-context` | Restore previous session |
| `rubyos sync` | Sync pending learnings to Supabase |
| `rubyos enrich` | Enrich pending learnings |

## When to Use

- **Start of session**: Check `rubyos status` to see project state
- **During development**: Use `rubyos learn` to capture insights
- **End of session**: Run `rubyos post-mortem` to analyze errors
- **Knowledge queries**: Search learnings before starting new tasks
- **Activity tracking**: Log important actions for audit trail

## Learning Types

| Type | Use Case |
|------|----------|
| `adr` | Architecture Decision Records |
| `bug_solution` | Solutions to bugs encountered |
| `architecture_decision` | Design decisions and rationale |
| `tech_discovery` | New technical discoveries |
| `lesson_learned` | General lessons from experience |
| `task_summary` | Summary of completed tasks |

## Workflows

### 1. Starting a Session

```bash
# Check project state
rubyos status

# If sleeping, reactivate
rubyos init
```

### 2. During Development

```bash
# Log an activity
rubyos learn --topic "Implemented JWT auth" \
             --content "Added JWT middleware with refresh token rotation" \
             --type tech_discovery \
             --project my-app \
             --tags "jwt,auth,security"

# Query existing knowledge
rubyos query_knowledge "how to handle JWT refresh tokens"
```

### 3. Ending a Session

```bash
# Analyze session for errors
rubyos post-mortem

# Save context for next session
rubyos save-context

# Sync learnings to Supabase (if configured)
rubyos sync
```

### 4. Post-Mortem Analysis

The post-mortem command:
1. Reads `activity-log.md` for the session
2. Detects error patterns
3. Generates prevention rules
4. Creates `lesson_learned` learnings
5. Updates `MEMORY.md` with session summary

## Knowledge System

### Create Learning

```bash
rubyos learn \
  --topic "Solution for PostgreSQL timeout" \
  --content "Increased pool_size to 20 and added connection pooling with PgBouncer" \
  --type bug_solution \
  --project my-app \
  --tags "postgres,performance"
```

### Query Knowledge

```bash
# Semantic search
rubyos query_knowledge "how to fix timeout in postgres"

# Recent learnings for a project
rubyos recent_learnings --project my-app
```

### Dashboard

```bash
# Generate HTML dashboard
rubyos learnings-dashboard

# Opens ~/.RubyOs/dashboard.html in browser
```

## Project Structure

When RubyOs is initialized in a project:

```
<project>/
└── .rub-os/
    ├── state.json           # Project status (active/sleeping)
    ├── activity-log.md      # Chronological action log
    ├── skill-manifest.json  # Active skills + usage history
    ├── pending-learnings.json # Learnings awaiting sync
    ├── session-state.json   # Current session state
    └── SKILL.md            # Project workflow
```

## MCP Server (Optional)

RubyOs includes an MCP server with 17 tools for advanced integration. To use:

### Configure in Crush

Add to your Crush MCP configuration:

```json
{
  "mcp": {
    "rubyos": {
      "type": "local",
      "command": ["python3", "/home/rb_dev/.RubyOs/rubyos-mcp-server.py"]
    }
  }
}
```

### MCP Tools Available

| Category | Tools |
|----------|-------|
| **Skills** | `search_skills`, `load_skill`, `read_skill_asset`, `create_skill` |
| **RAG** | `query_knowledge`, `hybrid_search`, `recent_learnings` |
| **Knowledge** | `create_learning`, `update_learning`, `delete_learning` |
| **Cache** | `cached_query`, `cache_discovery` |
| **Session** | `compress_session`, `check_context_budget`, `run_kernel_script` |
| **System** | `log_activity`, `zap`, `run_post_mortem`, `gating_override` |

**Note**: The MCP server is designed for OpenCode/Claude Code. For Crush, use the CLI commands directly.

## Skills Vault

RubyOs has 1484+ skills in `~/.RubyOs/skills/`. To search:

```bash
# Search skills
rubyos search_skills --query "docker deploy"

# Load a skill
rubyos load_skill --name "docker-expert"
```

**Note**: Crush has its own 1508+ built-in skills. Use RubyOs skills only when you need specific knowledge from the RubyOs vault.

## Dependencies

- Python 3.12+
- `requests` package (`pip install requests`)
- Supabase project (optional, for RAG/search)

## Configuration

### Supabase (Optional)

For semantic search and learning sync:

```bash
# Set service key
echo "your-service-key" > ~/.rub-os/supabase-key.txt

# Or use environment variable
export SUPABASE_SERVICE_KEY="your-service-key"
```

### Environment Variables

| Variable | Description |
|----------|-------------|
| `SUPABASE_SERVICE_KEY` | Supabase service key for RAG |
| `RUBYOS_HOME` | RubyOs installation path (default: `~/.RubyOs`) |

## Gotchas

1. **`~` does NOT expand in Python subprocess** — always use absolute paths
2. **Float comparisons need `round(x, 2)`** — Python floating point precision
3. **Skills are NOT pre-loaded** — use `search_skills` or `load_skill` first
4. **Tool gating hides tools** — use `gating_override` if a tool isn't appearing
5. **Session snapshots happen automatically** every 6 tool calls (min 30s apart)

## Troubleshooting

### MCP Server Not Starting

```bash
# Check Python version
python3 --version

# Test server directly
python3 ~/.RubyOs/rubyos-mcp-server.py

# Check for errors
python3 -c "import sys; sys.path.insert(0, '/home/rb_dev/.RubyOs/kernel'); from tool_gating import get_gated_tools; print('OK')"
```

### Learnings Not Syncing

```bash
# Check pending learnings
cat .rub-os/pending-learnings.json

# Manual sync
rubyos sync

# Check Supabase connection
rubyos enrich
```

### Post-Mortem Failing

```bash
# Check activity log exists
ls -la .rub-os/activity-log.md

# Run with verbose output
python3 ~/.RubyOs/kernel/post-mortem.py --verbose
```

## Reference Files

Load on-demand as needed:

- `~/.RubyOs/kernel/tool_gating.py` — Tool visibility management
- `~/.RubyOs/kernel/context_budget.py` — Token usage monitoring
- `~/.RubyOs/kernel/session_summary.py` — Session compression
- `~/.RubyOs/kernel/semantic_cache.py` — Cached query system

## Integration with Crush

RubyOs CLI commands work directly in Crush's bash tool. The knowledge system stores learnings locally in `.rub-os/pending-learnings.json` and optionally syncs to Supabase.

For session continuity:
1. Use `rubyos save-context` at end of session
2. Use `rubyos load-context` at start of next session
3. Check `MEMORY.md` for session history

## Security Notes

- Never version `skills/custom/servidor-acesso/` (contains sensitive data)
- Never version `.cache/`, `activity-log.md`, or `state.json`
- Use `uuid` for test data to avoid collisions
- Verify external schemas before writing to Supabase
