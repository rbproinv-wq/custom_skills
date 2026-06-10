#!/bin/bash
# validate_env.sh — Environment validation (API keys + runtimes + git config + ports)
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

MISSING=0
FIX_MODE=false

# Parse --fix flag
for arg in "$@"; do
  [[ "$arg" == "--fix" ]] && FIX_MODE=true
done

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🔐 Environment Validation${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# === OS Detection ===
echo -e "${YELLOW}📋 System Info${NC}"
UNAME=$(uname -s)
echo -e "  OS: ${UNAME}"
if command -v lsb_release &>/dev/null; then
  echo -e "  Distro: $(lsb_release -d 2>/dev/null | cut -f2)"
fi
echo ""

# === Git config ===
echo -e "${YELLOW}📋 Git Configuration${NC}"
GIT_NAME=$(git config user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config user.email 2>/dev/null || echo "")

if [[ -n "$GIT_NAME" ]]; then
  echo -e "${GREEN}✅ git user.name: $GIT_NAME${NC}"
else
  echo -e "${RED}❌ git user.name is not set${NC}"
  MISSING=1
  if $FIX_MODE && [[ -n "${GIT_AUTHOR_NAME:-}" ]]; then
    git config --global user.name "$GIT_AUTHOR_NAME"
    echo -e "${GREEN}   → Fixed from GIT_AUTHOR_NAME${NC}"
  fi
fi

if [[ -n "$GIT_EMAIL" ]]; then
  echo -e "${GREEN}✅ git user.email: $GIT_EMAIL${NC}"
else
  echo -e "${RED}❌ git user.email is not set${NC}"
  MISSING=1
  if $FIX_MODE && [[ -n "${GIT_AUTHOR_EMAIL:-}" ]]; then
    git config --global user.email "$GIT_AUTHOR_EMAIL"
    echo -e "${GREEN}   → Fixed from GIT_AUTHOR_EMAIL${NC}"
  fi
fi
echo ""

# === Language Runtimes ===
echo -e "${YELLOW}📋 Language Runtimes${NC}"

check_runtime() {
  local name="$1"
  local cmd="$2"
  if command -v "$cmd" &>/dev/null; then
    local ver
    ver=$("$cmd" --version 2>/dev/null | head -1 || echo "unknown")
    echo -e "${GREEN}✅ ${name}: ${ver}${NC}"
  else
    echo -e "${YELLOW}⚠️  ${name} not found (optional)${NC}"
  fi
}

check_runtime "Python" "python3"
check_runtime "Node.js" "node"
check_runtime "Go" "go"
check_runtime "Rust" "rustc"
echo ""

# === API Keys ===
echo -e "${YELLOW}📋 API Keys${NC}"

check_key() {
  local name="$1"
  local var="$2"
  if [[ -z "${!var:-}" ]]; then
    echo -e "${YELLOW}⚠️  ${name} (optional: $var)${NC}"
  else
    local masked="${!var:0:6}...${!var: -4}"
    echo -e "${GREEN}✅ ${name}: $masked${NC}"
  fi
}

check_key "DeepSeek" "DEEPSEEK_API_KEY"
check_key "Gemini" "GEMINI_API_KEY"
check_key "OpenRouter" "OPENROUTER_API_KEY"
echo ""

# === Port availability ===
echo -e "${YELLOW}📋 Port Check${NC}"
if command -v ss &>/dev/null; then
  if ss -tln | grep -q ':8443 '; then
    echo -e "${YELLOW}⚠️  Port 8443 is in use (LLM Router may conflict)${NC}"
  else
    echo -e "${GREEN}✅ Port 8443 is free${NC}"
  fi
else
  echo -e "${YELLOW}⚠️  Cannot check ports (ss not available)${NC}"
fi
echo ""

# === Disk space ===
echo -e "${YELLOW}📋 Disk Space${NC}"
AVAIL_KB=$(df . 2>/dev/null | awk 'NR==2 {print $4}')
if [[ -n "$AVAIL_KB" && "$AVAIL_KB" -lt 512000 ]]; then
  echo -e "${YELLOW}⚠️  Low disk space: ${AVAIL_KB}KB available (< 500MB)${NC}"
else
  echo -e "${GREEN}✅ Sufficient disk space${NC}"
fi
echo ""

# === Result ===
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [[ $MISSING -eq 1 ]]; then
  echo -e "${RED}❌ Some checks failed. Review warnings above.${NC}"
  exit 1
else
  echo -e "${GREEN}✅ All checks passed. Environment is ready.${NC}"
  exit 0
fi
