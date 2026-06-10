#!/bin/bash
set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

SPEC_DIR=".spec"
ERRORS=0

echo -e "${YELLOW}🔍 Verifying specification integrity...${NC}"

# Check required root spec files
for required in architecture.md domain_rules.md; do
    if [ ! -f "$SPEC_DIR/$required" ]; then
        echo -e "${RED}❌ Missing $SPEC_DIR/$required${NC}"
        ERRORS=$((ERRORS+1))
    fi
done

# Check that every task references an existing module
if [ -d "$SPEC_DIR/tasks" ]; then
    for task_file in "$SPEC_DIR"/tasks/*.md; do
        [ -f "$task_file" ] || continue
        module=$(grep -E '^Module:' "$task_file" | head -1 | sed 's/Module:[[:space:]]*//')
        if [ -z "$module" ]; then
            echo -e "${RED}❌ Task $(basename "$task_file") has no 'Module:' field${NC}"
            ERRORS=$((ERRORS+1))
        elif [ ! -f "$SPEC_DIR/modules/$module.md" ]; then
            echo -e "${RED}❌ Task $(basename "$task_file") references module '$module' but $SPEC_DIR/modules/$module.md does not exist${NC}"
            ERRORS=$((ERRORS+1))
        fi
    done
else
    echo -e "${YELLOW}⚠️ No tasks directory found. No tasks to verify.${NC}"
fi

# Check that every task has acceptance criteria
if [ -d "$SPEC_DIR/tasks" ]; then
    for task_file in "$SPEC_DIR"/tasks/*.md; do
        [ -f "$task_file" ] || continue
        if ! grep -q "Acceptance Criteria" "$task_file"; then
            echo -e "${RED}❌ Task $(basename "$task_file") missing 'Acceptance Criteria' section${NC}"
            ERRORS=$((ERRORS+1))
        fi
        if ! grep -q "Inputs:" "$task_file" || ! grep -q "Outputs:" "$task_file"; then
            echo -e "${RED}❌ Task $(basename "$task_file") missing 'Inputs' or 'Outputs' section${NC}"
            ERRORS=$((ERRORS+1))
        fi
    done
fi

# Check that modules exist and have bounded context
if [ -d "$SPEC_DIR/modules" ]; then
    for module_file in "$SPEC_DIR"/modules/*.md; do
        [ -f "$module_file" ] || continue
        if ! grep -q "Bounded Context" "$module_file"; then
            echo -e "${RED}❌ Module $(basename "$module_file") missing 'Bounded Context' definition${NC}"
            ERRORS=$((ERRORS+1))
        fi
    done
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All specifications are valid. Ready to start development.${NC}"
    exit 0
else
    echo -e "${RED}❌ Found $ERRORS issue(s). Please fix before running Crush tasks.${NC}"
    exit 1
fi
