#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🔐 Validating API Environment Variables...${NC}"

MISSING=0

# Check DeepSeek
if [ -z "$DEEPSEEK_API_KEY" ]; then
    echo -e "${RED}❌ DEEPSEEK_API_KEY is not set${NC}"
    echo -e "${YELLOW}   → Add to ~/.bashrc or ~/.zshrc: export DEEPSEEK_API_KEY='sk-...'${NC}"
    MISSING=1
else
    echo -e "${GREEN}✅ DEEPSEEK_API_KEY is set${NC}"
fi

# Check Gemini
if [ -z "$GEMINI_API_KEY" ]; then
    echo -e "${RED}❌ GEMINI_API_KEY is not set${NC}"
    echo -e "${YELLOW}   → Add to ~/.bashrc or ~/.zshrc: export GEMINI_API_KEY='AIza...'${NC}"
    MISSING=1
else
    echo -e "${GREEN}✅ GEMINI_API_KEY is set${NC}"
fi

# Check OpenRouter (optional but recommended)
if [ -z "$OPENROUTER_API_KEY" ]; then
    echo -e "${YELLOW}⚠️ OPENROUTER_API_KEY is not set (optional, but recommended for GLM-4.6 access)${NC}"
else
    echo -e "${GREEN}✅ OPENROUTER_API_KEY is set${NC}"
fi

echo ""
if [ $MISSING -eq 1 ]; then
    echo -e "${RED}❌ One or more required API keys are missing. Please set them before using Crush.${NC}"
    exit 1
else
    echo -e "${GREEN}✅ All required API keys are present. Environment is ready.${NC}"
    exit 0
fi