#!/bin/bash
# validate-dossier.sh - Verifica se um dossiê gerado pela Skill 2 contém todas as seções obrigatórias
# Uso: ./validate-dossier.sh <arquivo-dossie.md>

set -e

DOSSIER_FILE="$1"

if [ -z "$DOSSIER_FILE" ]; then
    echo "❌ Uso: $0 <arquivo-dossie.md>"
    exit 1
fi

if [ ! -f "$DOSSIER_FILE" ]; then
    echo "❌ Arquivo não encontrado: $DOSSIER_FILE"
    exit 1
fi

echo "🔍 Validando Dossiê de Restrições: $DOSSIER_FILE"
echo "======================================"

MISSING_SECTIONS=0

# Lista de seções obrigatórias (títulos Markdown)
SECTIONS=(
    "## Competitor Benchmark"
    "## Legal & Compliance Constraints"
    "## API & Platform Restrictions"
    "## Channel Analysis"
    "## Design/UX Inspirations"
    "## Identified Risks & Opportunities"
    "## Unresolved Gaps"
    "## Research Methodology"
)

for section in "${SECTIONS[@]}"; do
    if grep -q "^$section" "$DOSSIER_FILE"; then
        echo "✅ $section"
    else
        echo "❌ Seção ausente: $section"
        MISSING_SECTIONS=$((MISSING_SECTIONS + 1))
    fi
done

# Verifica presença de pelo menos 3 concorrentes na tabela (linhas após cabeçalho da tabela)
# Procura por padrão de tabela markdown: | --- | --- | ... e conta linhas subsequentes com |
if grep -q "^| Concorrente" "$DOSSIER_FILE"; then
    # Conta linhas que começam com | e têm pelo menos 5 pipes (indicativo de tabela preenchida)
    COMPETITOR_ROWS=$(grep -c "^| .*| .*| .*| .*| .*| .*|$" "$DOSSIER_FILE" || true)
    # Subtrai 1 se o cabeçalho foi contado
    if [ "$COMPETITOR_ROWS" -ge 4 ]; then
        echo "✅ Tabela de concorrentes com pelo menos 3 entradas"
    else
        echo "❌ Tabela de concorrentes com menos de 3 entradas (encontradas $((COMPETITOR_ROWS - 1)))"
        MISSING_SECTIONS=$((MISSING_SECTIONS + 1))
    fi
else
    echo "❌ Tabela de concorrentes não encontrada"
    MISSING_SECTIONS=$((MISSING_SECTIONS + 1))
fi

# Verifica se há pelo menos uma restrição legal com fonte (link ou menção de "Fonte")
if grep -q "Fonte:" "$DOSSIER_FILE" || grep -q "http" "$DOSSIER_FILE"; then
    echo "✅ Restrições legais com fontes identificadas"
else
    echo "⚠️  Seção legal pode estar sem fontes (recomendado incluir referências)"
fi

# Verifica se há pelo menos uma API listada (seção com subitens ou tabela)
if grep -q "###" "$DOSSIER_FILE" | grep -q "API"; then
    echo "✅ APIs identificadas (ou seção vazia justificada)"
else
    echo "⚠️  Nenhuma API específica identificada (pode ser aceitável se nenhuma foi citada no PRD)"
fi

# Verifica se os riscos estão classificados (bloqueador/mitigável)
if grep -qi "bloqueador\|mitigável\|alto\|médio\|baixo" "$DOSSIER_FILE"; then
    echo "✅ Riscos classificados com nível ou tipo"
else
    echo "⚠️  Riscos podem não estar classificados (recomendado indicar bloqueador/mitigável)"
fi

echo "======================================"

if [ $MISSING_SECTIONS -eq 0 ]; then
    echo "✅ Dossiê válido! Todas as seções obrigatórias estão presentes."
    exit 0
else
    echo "❌ Dossiê inválido. Faltam $MISSING_SECTIONS seções obrigatórias."
    exit 1
fi