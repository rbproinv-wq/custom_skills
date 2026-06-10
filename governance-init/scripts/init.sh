#!/bin/bash
# init.sh — Project initialization with wizard, detect, and type flags
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# === Detect script location ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ASSETS_TEMPLATES="$SKILL_ROOT/assets/templates"
ASSETS_PROMPTS="$SKILL_ROOT/assets/prompts"

# === Defaults ===
PROJECT_TYPE=""
DRY_RUN=false

# === Help ===
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --wizard            Interactive setup (asks 7 questions)"
  echo "  --detect            Auto-detect project type from existing files"
  echo "  --type <name>       Explicit template: generic, python-fastapi, typescript-next"
  echo "  --dry-run           Show what would be created without writing"
  echo "  --help              Show this message"
  echo ""
  echo "No flags = generic scaffold (current behavior)"
  exit 0
}

# === Parse arguments ===
while [[ $# -gt 0 ]]; do
  case "$1" in
    --wizard) MODE="wizard"; shift ;;
    --detect) MODE="detect"; shift ;;
    --type) MODE="type"; PROJECT_TYPE="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    --help|-h) usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done

# === Wizard mode ===
if [[ "$MODE" == "wizard" ]]; then
  echo -e "${BLUE}🚀 Crush Governance Init — Wizard${NC}"
  echo ""
  echo -e "Responda 7 perguntas para configurar seu projeto:"
  echo ""

  echo "1/7 — Project type?"
  select pt in "API" "Fullstack" "Library" "CLI" "Mobile"; do
    [[ -n "$pt" ]] && break || echo "Invalid. Choose 1-5."
  done

  echo ""
  echo "2/7 — Language?"
  select lang in "Python" "TypeScript" "Go" "Rust" "Other"; do
    [[ -n "$lang" ]] && break || echo "Invalid. Choose 1-5."
  done

  echo ""
  echo "3/7 — Framework?"
  if [[ "$lang" == "Python" ]]; then
    select fw in "FastAPI" "Django" "Flask" "None"; do
      [[ -n "$fw" ]] && break || echo "Invalid."
    done
  elif [[ "$lang" == "TypeScript" ]]; then
    select fw in "Next.js" "Express" "React+Vite" "None"; do
      [[ -n "$fw" ]] && break || echo "Invalid."
    done
  else
    fw="None"
    echo "  → None (generic)"
  fi

  echo ""
  echo "4/7 — Database?"
  select db in "PostgreSQL" "SQLite" "MongoDB" "None"; do
    [[ -n "$db" ]] && break || echo "Invalid."
  done

  echo ""
  echo "5/7 — API keys setup?"
  select keys in "DeepSeek" "Gemini" "OpenRouter" "Skip"; do
    [[ -n "$keys" ]] && break || echo "Invalid."
  done

  echo ""
  echo "6/7 — LLM Router?"
  select router in "Local proxy" "None"; do
    [[ -n "$router" ]] && break || echo "Invalid."
  done

  echo ""
  echo "7/7 — Devcontainer?"
  select devc in "Yes" "No"; do
    [[ -n "$devc" ]] && break || echo "Invalid."
  done

  # Determine template
  if [[ "$lang" == "Python" && "$fw" == "FastAPI" ]]; then
    PROJECT_TYPE="python-fastapi"
  elif [[ "$lang" == "TypeScript" && "$fw" == "Next.js" ]]; then
    PROJECT_TYPE="typescript-next"
  else
    PROJECT_TYPE="generic"
  fi

  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}Type:${NC} $pt / $lang / $fw"
  echo -e "${GREEN}Template:${NC} $PROJECT_TYPE"
  echo -e "${GREEN}DB:${NC} $db | Keys: $keys | Router: $router | Devcontainer: $devc"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -n "Confirm? [Y/n]: "
  read confirm
  [[ "$confirm" == "n" || "$confirm" == "N" ]] && echo "Cancelled." && exit 0
fi

# === Detect mode ===
if [[ "$MODE" == "detect" ]]; then
  echo -e "${BLUE}🔍 Detecting project type from existing files...${NC}"

  if [[ -f "package.json" ]]; then
    PROJECT_TYPE="typescript-next"
    echo -e "${GREEN}→ Detected: package.json (TypeScript project)${NC}"
  elif [[ -f "pyproject.toml" ]]; then
    PROJECT_TYPE="python-fastapi"
    echo -e "${GREEN}→ Detected: pyproject.toml (Python project)${NC}"
  elif [[ -f "go.mod" ]]; then
    PROJECT_TYPE="generic"
    echo -e "${GREEN}→ Detected: go.mod (Go project — using generic template)${NC}"
  elif [[ -f "Cargo.toml" ]]; then
    PROJECT_TYPE="generic"
    echo -e "${GREEN}→ Detected: Cargo.toml (Rust project — using generic template)${NC}"
  else
    PROJECT_TYPE="generic"
    echo -e "${YELLOW}→ No known project files found; using generic template${NC}"
  fi

  echo ""
  echo -n "Use template '$PROJECT_TYPE'? [Y/n]: "
  read confirm
  [[ "$confirm" == "n" || "$confirm" == "N" ]] && echo "Cancelled." && exit 0
fi

# === Type mode (explicit) ===
if [[ "$MODE" == "type" ]]; then
  if [[ "$PROJECT_TYPE" != "generic" && "$PROJECT_TYPE" != "python-fastapi" && "$PROJECT_TYPE" != "typescript-next" ]]; then
    echo -e "${RED}Invalid type: $PROJECT_TYPE. Valid: generic, python-fastapi, typescript-next${NC}"
    exit 1
  fi
fi

# === Default mode ===
if [[ -z "$MODE" ]]; then
  PROJECT_TYPE="generic"
  echo -e "${BLUE}🚀 Crush Governance Init — Generic Scaffold${NC}"
fi

# === Dry-run ===
if $DRY_RUN; then
  echo -e "${YELLOW}Dry-run mode — no files will be written${NC}"
  echo ""
  echo -e "${BLUE}Would create:${NC}"
  echo "  .crush/prompts/"
  echo "  .crush/sessions/"
  echo "  .spec/modules/"
  echo "  .spec/tasks/"
  echo "  crush.json"
  echo "  .crush.md (template: $PROJECT_TYPE)"
  echo "  .crushrules"
  echo "  AGENTS.md"
  echo "  .gitignore"
  if [[ -d "$ASSETS_TEMPLATES/$PROJECT_TYPE" ]]; then
    echo "  Language-specific template: $PROJECT_TYPE/"
  fi
  echo ""
  echo -e "${GREEN}Dry-run complete. Use without --dry-run to apply.${NC}"
  exit 0
fi

# === Verify assets exist ===
if [[ ! -d "$ASSETS_TEMPLATES" ]]; then
  echo -e "${RED}❌ Cannot find assets/templates at $ASSETS_TEMPLATES${NC}"
  echo -e "${YELLOW}Expected script at: $SCRIPT_DIR${NC}"
  echo -e "${YELLOW}Resolved SKILL_ROOT: $SKILL_ROOT${NC}"
  exit 1
fi

# === Check prerequisites ===
GIT_NAME=$(git config user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config user.email 2>/dev/null || echo "")
if [[ -z "$GIT_NAME" || -z "$GIT_EMAIL" ]]; then
  echo -e "${YELLOW}⚠️  Git user.name or user.email not configured.${NC}"
  echo -e "${YELLOW}   Set them: git config --global user.name 'Your Name'${NC}"
  echo -e "${YELLOW}   And: git config --global user.email 'you@example.com'${NC}"
  echo ""
  echo -n "Continue anyway? [Y/n]: "
  read confirm
  [[ "$confirm" == "n" || "$confirm" == "N" ]] && exit 0
fi

# === Create directories ===
mkdir -p .crush/prompts
mkdir -p .crush/sessions
mkdir -p .spec/modules
mkdir -p .spec/tasks

echo -e "${GREEN}✅ Directories created: .crush/prompts, .crush/sessions, .spec/${NC}"

# === Copy crush.json ===
if [[ ! -f "crush.json" ]]; then
  cp "$ASSETS_TEMPLATES/crush.json" ./crush.json
  echo -e "${GREEN}✅ crush.json installed${NC}"
else
  echo -e "${YELLOW}ℹ️  crush.json already exists, skipping${NC}"
fi

# === Copy language-specific .crush.md ===
if [[ -d "$ASSETS_TEMPLATES/$PROJECT_TYPE" ]]; then
  if [[ ! -f ".crush.md" ]]; then
    cp "$ASSETS_TEMPLATES/$PROJECT_TYPE/.crush.md" ./.crush.md
    echo -e "${GREEN}✅ .crush.md installed ($PROJECT_TYPE template)${NC}"
  else
    echo -e "${YELLOW}ℹ️  .crush.md already exists, skipping${NC}"
  fi
else
  if [[ ! -f ".crush.md" ]]; then
    cp "$ASSETS_TEMPLATES/.crush.md" ./.crush.md
    echo -e "${GREEN}✅ .crush.md installed (generic template)${NC}"
  else
    echo -e "${YELLOW}ℹ️  .crush.md already exists, skipping${NC}"
  fi
fi

# === Copy other templates ===
if [[ ! -f ".crushrules" ]]; then
  cp "$ASSETS_TEMPLATES/.crushrules" ./.crushrules 2>/dev/null && echo -e "${GREEN}✅ .crushrules installed${NC}" || true
fi
if [[ ! -f "AGENTS.md" ]]; then
  cp "$ASSETS_TEMPLATES/AGENTS.md" ./AGENTS.md 2>/dev/null && echo -e "${GREEN}✅ AGENTS.md installed${NC}" || true
fi

# === Copy atomic prompts ===
if [[ -d "$ASSETS_PROMPTS" ]]; then
  cp "$ASSETS_PROMPTS/review.md" .crush/prompts/ 2>/dev/null && echo -e "${GREEN}✅ review.md installed${NC}" || true
  cp "$ASSETS_PROMPTS/refactor.md" .crush/prompts/ 2>/dev/null && echo -e "${GREEN}✅ refactor.md installed${NC}" || true
  cp "$ASSETS_PROMPTS/test.md" .crush/prompts/ 2>/dev/null && echo -e "${GREEN}✅ test.md installed${NC}" || true
else
  echo -e "${YELLOW}⚠️  Prompts directory not found; skipping.${NC}"
fi

# === Initialize git ===
if [[ ! -d ".git" ]]; then
  git init
  echo -e "${GREEN}✅ Git repository initialized${NC}"
else
  echo -e "${YELLOW}ℹ️  Git repository already exists${NC}"
fi

# === Create .gitignore ===
if [[ ! -f ".gitignore" ]]; then
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

# === Check port 8443 ===
if command -v ss &>/dev/null; then
  if ss -tln | grep -q ':8443 '; then
    echo -e "${GREEN}✅ Port 8443 is available (LLM Router can use it)${NC}"
  fi
fi

# === Summary ===
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🎉 Governance structure successfully installed!${NC}"
echo -e "${YELLOW}Template:${NC} $PROJECT_TYPE"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Run 'bash custom_skills/governance-init/scripts/validate_env.sh' to check environment"
echo "  2. Run 'bash custom_skills/governance-init/scripts/validate.sh' to verify artifacts"
echo "  3. Edit .crush.md with your project-specific stable rules"
echo "  4. Start Crush and begin development"
echo ""
echo -e "${YELLOW}LLM Router (optional):${NC}"
echo "  bash ~/.agents/scripts/llm-router.sh start"
echo "  Configure keys in ~/.agents/scripts/llm-keys.json"
