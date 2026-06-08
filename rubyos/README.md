# RubyOs Skill for Crush

This skill provides access to the RubyOs AI-assisted development operating system.

## What is RubyOs?

RubyOs is a knowledge management and continuous learning system that helps AI agents:
- Track session activities and decisions
- Capture learnings for future reference
- Perform post-mortem analysis on errors
- Query existing knowledge before starting tasks
- Generate dashboards of accumulated knowledge

## Installation

RubyOs is already installed at `~/.RubyOs/`. This skill provides the interface to use it from Crush.

## Usage

### Via Crush Skills

The skill is automatically available in Crush. When you need to:
- Create a learning: `rubyos learn --topic "..." --content "..." --type "..." --project "..."`
- Check project status: `rubyos status`
- Analyze session errors: `rubyos post-mortem`
- Query knowledge: `rubyos query_knowledge "..."`

### Via Bash Tool

All RubyOs commands work directly in Crush's bash tool:

```bash
rubyos status
rubyos learn --topic "Implemented caching" --content "Added Redis caching layer" --type tech_discovery --project my-app
rubyos post-mortem
```

## Configuration

### Supabase (Optional)

For semantic search and cloud sync:

```bash
echo "your-supabase-service-key" > ~/.rub-os/supabase-key.txt
```

### MCP Server (Advanced)

For full MCP integration, add to Crush config:

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

**Note**: The MCP server is primarily designed for OpenCode/Claude Code. For Crush, CLI commands are recommended.

## Key Features

1. **Learning Management**: Create, query, and manage knowledge entries
2. **Post-Mortem Analysis**: Automatically analyze session errors and generate prevention rules
3. **Activity Logging**: Track all actions for audit trails
4. **Session Persistence**: Save and restore session context across conversations
5. **Knowledge Dashboard**: Generate HTML visualizations of accumulated knowledge

## Differences from Crush Built-in Skills

| Feature | RubyOs | Crush Built-in |
|---------|--------|----------------|
| Learning storage | Local JSON + Supabase | N/A |
| Post-mortem | Automatic error analysis | N/A |
| Session tracking | Activity logs | Context window |
| Knowledge query | Semantic search | Skill search |
| Dashboard | HTML generation | N/A |

## Support

- GitHub: https://github.com/rbproinv-wq/rubyos-core
- Installation: `~/.RubyOs/REPLICATE.md`
- Documentation: `~/.RubyOs/README.md`
