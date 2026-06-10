#!/bin/bash
# validate.sh — Post-init artifact validation
set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PASS=0
FAIL=0
TOTAL=0

check_file() {
  local path="$1"
  local desc="$2"
  TOTAL=$((TOTAL + 1))
  if [[ -f "$path" ]]; then
    local size
    size=$(wc -c < "$path" 2>/dev/null || echo "0")
    if [[ "$size" -gt 0 ]]; then
      echo -e "${GREEN}✅ ${desc} (${size} bytes)${NC}"
      PASS=$((PASS + 1))
    else
      echo -e "${RED}❌ ${desc} — file is empty${NC}"
      FAIL=$((FAIL + 1))
    fi
  else
    echo -e "${RED}❌ ${desc} — not found${NC}"
    FAIL=$((FAIL + 1))
  fi
}

check_dir() {
  local path="$1"
  local desc="$2"
  TOTAL=$((TOTAL + 1))
  if [[ -d "$path" ]]; then
    echo -e "${GREEN}✅ ${desc} (directory)${NC}"
    PASS=$((PASS + 1))
  else
    echo -e "${RED}❌ ${desc} — not found${NC}"
    FAIL=$((FAIL + 1))
  fi
}

check_json() {
  local path="$1"
  local desc="$2"
  TOTAL=$((TOTAL + 1))
  if [[ -f "$path" ]]; then
    if jq '.' "$path" &>/dev/null; then
      local model_count
      model_count=$(jq '.providers | map(.models | length) | add' "$path" 2>/dev/null || echo "?")
      echo -e "${GREEN}✅ ${desc} (valid JSON, ${model_count} models)${NC}"
      PASS=$((PASS + 1))
    else
      echo -e "${RED}❌ ${desc} — invalid JSON${NC}"
      FAIL=$((FAIL + 1))
    fi
  else
    echo -e "${RED}❌ ${desc} — not found${NC}"
    FAIL=$((FAIL + 1))
  fi
}

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}📋 Post-Init Validation${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

check_file ".crush.md" ".crush.md"
check_json "crush.json" "crush.json"
check_dir ".spec" ".spec/"
check_dir ".spec/modules" ".spec/modules/"
check_dir ".spec/tasks" ".spec/tasks/"
check_dir ".crush" ".crush/"
check_dir ".crush/prompts" ".crush/prompts/"
check_file ".crush/prompts/review.md" ".crush/prompts/review.md"
check_file ".crush/prompts/refactor.md" ".crush/prompts/refactor.md"
check_file ".crush/prompts/test.md" ".crush/prompts/test.md"
check_file ".gitignore" ".gitignore"
check_dir ".git" "Git repository"

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [[ $FAIL -eq 0 ]]; then
  echo -e "${GREEN}✅ ${PASS}/${TOTAL} checks passed${NC}"
  exit 0
else
  echo -e "${RED}❌ ${FAIL} checks failed (${PASS}/${TOTAL})${NC}"
  exit 1
fi
