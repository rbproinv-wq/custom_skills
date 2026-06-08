#!/bin/bash
set -e
clear

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 CRUSH GOVERNANCE INIT - Phase 0 Setup${NC}"
echo -e "${YELLOW}Creating project governance structure...${NC}"

# === DETECT SKILL DIRECTORY (works for global and local install) ===
# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Navigate two levels up to reach the skill root (scripts/ -> skill-root/)
SKILL_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ASSETS_TEMPLATES="$SKILL_ROOT/assets/templates"
ASSETS_PROMPTS="$SKILL_ROOT/assets/prompts"

echo -e "${BLUE}📁 Skill root detected: $SKILL_ROOT${NC}"

# Verify assets exist
if [ ! -d "$ASSETS_TEMPLATES" ]; then
    echo -e "${RED}❌ Cannot find assets/templates at $ASSETS_TEMPLATES${NC}"
    exit 1
fi

# 1. Create required directories
mkdir -p .crush/prompts
mkdir -p .crush/sessions
mkdir -p .spec/modules
mkdir -p .spec/tasks

echo -e "${GREEN}✅ Directories created: .crush/prompts, .crush/sessions, .spec, .spec/modules, .spec/tasks${NC}"

# 2. Copy template files from skill assets to project root
cp "$ASSETS_TEMPLATES/crush.json" ./crush.json
echo -e "${GREEN}✅ crush.json installed${NC}"

cp "$ASSETS_TEMPLATES/.crush.md" ./.crush.md
echo -e "${GREEN}✅ .crush.md installed${NC}"

cp "$ASSETS_TEMPLATES/.crushrules" ./.crushrules
echo -e "${GREEN}✅ .crushrules installed${NC}"

cp "$ASSETS_TEMPLATES/AGENTS.md" ./AGENTS.md
echo -e "${GREEN}✅ AGENTS.md installed${NC}"

# 3. Copy atomic prompts (if directory exists)
if [ -d "$ASSETS_PROMPTS" ]; then
    cp "$ASSETS_PROMPTS/review.md" .crush/prompts/ 2>/dev/null && echo -e "${GREEN}✅ review.md installed${NC}"
    cp "$ASSETS_PROMPTS/refactor.md" .crush/prompts/ 2>/dev/null && echo -e "${GREEN}✅ refactor.md installed${NC}"
    cp "$ASSETS_PROMPTS/test.md" .crush/prompts/ 2>/dev/null && echo -e "${GREEN}✅ test.md installed${NC}"
else
    echo -e "${YELLOW}⚠️ Prompts directory not found; skipping.${NC}"
fi

# 4. Initialize git repository if not already
if [ ! -d ".git" ]; then
    git init
    echo -e "${GREEN}✅ Git repository initialized${NC}"
else
    echo -e "${YELLOW}ℹ️ Git repository already exists${NC}"
fi

# 5. Create initial .gitignore with sensible defaults
if [ ! -f ".gitignore" ]; then
    cat << 'EOF' > .gitignore
# Crush sessions logs
.crush/sessions/
# Environment variables
.env
.env.local
# OS files
.DS_Store
Thumbs.db
# IDE
.vscode/
.idea/
EOF
    echo -e "${GREEN}✅ .gitignore created${NC}"
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🎉 Governance structure successfully installed!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Run 'bash .crush/skills/crush-governance-init/scripts/validate_env.sh' to check API keys"
echo "  2. Edit .crush.md with your project-specific stable rules"
echo "  3. Start Crush with 'crush' and begin development"
