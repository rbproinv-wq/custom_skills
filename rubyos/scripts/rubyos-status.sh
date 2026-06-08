#!/bin/bash
# RubyOs Status Check Script
# Quick status check for RubyOs installation and project state

set -e

RUBYOS_HOME="${RUBYOS_HOME:-$HOME/.RubyOs}"
PROJECT_DIR="${1:-.}"
RUB_OS_DIR="$PROJECT_DIR/.rub-os"

echo "=== RubyOs Status ==="
echo ""

# Check installation
echo "1. Installation Check:"
if [ -f "$RUBYOS_HOME/rubyos-mcp-server.py" ]; then
    echo "   ✅ RubyOs installed at $RUBYOS_HOME"
else
    echo "   ❌ RubyOs not found at $RUBYOS_HOME"
    exit 1
fi

# Check Python version
echo ""
echo "2. Python Version:"
python3 --version

# Check project initialization
echo ""
echo "3. Project State:"
if [ -f "$RUB_OS_DIR/state.json" ]; then
    STATUS=$(python3 -c "import json; print(json.load(open('$RUB_OS_DIR/state.json')).get('status', 'unknown'))")
    echo "   ✅ Project initialized"
    echo "   Status: $STATUS"
else
    echo "   ⚠️  Project not initialized"
    echo "   Run: rubyos init"
fi

# Check activity log
echo ""
echo "4. Activity Log:"
if [ -f "$RUB_OS_DIR/activity-log.md" ]; then
    LINES=$(wc -l < "$RUB_OS_DIR/activity-log.md")
    echo "   ✅ Activity log exists ($LINES lines)"
else
    echo "   ⚠️  No activity log"
fi

# Check pending learnings
echo ""
echo "5. Pending Learnings:"
if [ -f "$RUB_OS_DIR/pending-learnings.json" ]; then
    COUNT=$(python3 -c "import json; print(len(json.load(open('$RUB_OS_DIR/pending-learnings.json'))))")
    echo "   📚 $COUNT learning(s) pending sync"
else
    echo "   ℹ️  No pending learnings"
fi

# Check Supabase configuration
echo ""
echo "6. Supabase Configuration:"
if [ -f "$HOME/.rub-os/supabase-key.txt" ]; then
    echo "   ✅ Supabase key configured"
elif [ -n "$SUPABASE_SERVICE_KEY" ]; then
    echo "   ✅ Supabase key in environment"
else
    echo "   ⚠️  Supabase not configured (optional)"
fi

echo ""
echo "=== Quick Commands ==="
echo "  rubyos status              # Show this status"
echo "  rubyos init                # Initialize project"
echo "  rubyos learn --help        # Create a learning"
echo "  rubyos post-mortem         # Analyze session"
echo "  rubyos learnings-dashboard # Generate dashboard"
