#!/bin/bash
# validate-prd.sh - Verifica se um PRD gerado pela Skill 1 contém todas as seções obrigatórias
# Uso: ./validate-prd.sh arquivo-prd.md

set -e

PRD_FILE="$1"

if [ -z "$PRD_FILE" ]; then
    echo "❌ Uso: $0 <arquivo-prd.md>"
    exit 1
fi

if [ ! -f "$PRD_FILE" ]; then
    echo "❌ Arquivo não encontrado: $PRD_FILE"
    exit 1
fi

echo "🔍 Validando PRD: $PRD_FILE"
echo "======================================"

MISSING_SECTIONS=0

# Lista de seções obrigatórias (títulos Markdown)
SECTIONS=(
    "## Problema identificado"
    "## Solução proposta"
    "## Funcionalidades principais"
    "## Personas e tipos de usuários"
    "## Escopo do MVP"
    "## Métricas de sucesso"
    "## Custo estimado"
    "## Riscos e premissas"
    "## Metodologia utilizada"
    "## Próximos passos"
)

for section in "${SECTIONS[@]}"; do
    if grep -q "^$section" "$PRD_FILE"; then
        echo "✅ $section"
    else
        echo "❌ Seção ausente: $section"
        MISSING_SECTIONS=$((MISSING_SECTIONS + 1))
    fi
done

# Verifica se existe pelo menos uma funcionalidade MVP
if grep -qi "mvp" "$PRD_FILE" | grep -qi "\[ \]" "$PRD_FILE"; then
    echo "✅ Possui funcionalidades MVP (checkboxes ou lista)"
else
    echo "⚠️  Nenhuma funcionalidade MVP explícita encontrada (use checkboxes ou 'MVP:')"
fi

# Verifica se há pelo menos 2 personas (contando nomes)
PERSONA_COUNT=$(grep -cE "(Persona|nome):" "$PRD_FILE" || true)
if [ "$PERSONA_COUNT" -ge 2 ]; then
    echo "✅ Personas identificadas (mínimo 2)"
else
    echo "❌ Personas insuficientes (mínimo 2 encontradas: $PERSONA_COUNT)"
    MISSING_SECTIONS=$((MISSING_SECTIONS + 1))
fi

# Verifica KPIs (pelo menos 3)
KPI_COUNT=$(grep -cE "(KPI|métrica|indicador)" "$PRD_FILE" || true)
if [ "$KPI_COUNT" -ge 3 ]; then
    echo "✅ KPIs ou métricas encontradas ($KPI_COUNT)"
else
    echo "❌ Menos de 3 KPIs ou métricas encontradas ($KPI_COUNT)"
    MISSING_SECTIONS=$((MISSING_SECTIONS + 1))
fi

echo "======================================"

if [ $MISSING_SECTIONS -eq 0 ]; then
    echo "✅ PRD válido! Todas as seções obrigatórias estão presentes."
    exit 0
else
    echo "❌ PRD inválido. Faltam $MISSING_SECTIONS seções obrigatórias."
    exit 1
fi