#!/bin/bash
set -e
clear

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔧 Compiling Lean Context Payload for Crush...${NC}"

PROJECT_ROOT="${PWD}"
SPEC_DIR="$PROJECT_ROOT/.spec"
OUTPUT_FILE="$PROJECT_ROOT/.crush/compiled_context.md"

if [ ! -d "$SPEC_DIR" ]; then
    echo -e "${RED}❌ .spec directory not found. Run 'crush-governance-init' first.${NC}"
    exit 1
fi

# Start with architecture and domain rules (stable part)
{
    echo "# === BLOCO ESTÁVEL (CACHED) - Compiled from .spec ==="
    echo ""
    if [ -f "$SPEC_DIR/architecture.md" ]; then
        echo "## ARCHITECTURE CONSTRAINTS"
        cat "$SPEC_DIR/architecture.md"
        echo ""
    fi
    if [ -f "$SPEC_DIR/domain_rules.md" ]; then
        echo "## DOMAIN INVARIANTS"
        cat "$SPEC_DIR/domain_rules.md"
        echo ""
    fi
} > "$OUTPUT_FILE"

# Optional: add specific module if passed as argument
if [ -n "$1" ]; then
    MODULE_FILE="$SPEC_DIR/modules/$1.md"
    if [ -f "$MODULE_FILE" ]; then
        echo "## MODULE: $1" >> "$OUTPUT_FILE"
        cat "$MODULE_FILE" >> "$OUTPUT_FILE"
        echo -e "${GREEN}✅ Module $1 appended${NC}"
    else
        echo -e "${YELLOW}⚠️ Module $1 not found. Skipping.${NC}"
    fi
fi

# Add task if passed as second argument
if [ -n "$2" ]; then
    TASK_FILE="$SPEC_DIR/tasks/$2.md"
    if [ -f "$TASK_FILE" ]; then
        echo "" >> "$OUTPUT_FILE"
        echo "## TASK: $2" >> "$OUTPUT_FILE"
        cat "$TASK_FILE" >> "$OUTPUT_FILE"
        echo -e "${GREEN}✅ Task $2 appended${NC}"
    else
        echo -e "${YELLOW}⚠️ Task $2 not found. Skipping.${NC}"
    fi
fi

echo -e "${GREEN}✅ Compiled context written to $OUTPUT_FILE${NC}"
echo -e "${YELLOW}ℹ️ You can now copy the content of this file into the stable block of .crush.md${NC}"
