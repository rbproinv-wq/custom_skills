#!/bin/bash
# validate-spec.sh - Verifica se a especificação arquitetural gerada pela Skill 3 contém todas as seções e elementos obrigatórios
# Uso: ./validate-spec.sh <arquivo-especificacao.md>

set -e

SPEC_FILE="$1"

if [ -z "$SPEC_FILE" ]; then
    echo "❌ Uso: $0 <arquivo-especificacao.md>"
    exit 1
fi

if [ ! -f "$SPEC_FILE" ]; then
    echo "❌ Arquivo não encontrado: $SPEC_FILE"
    exit 1
fi

echo "🔍 Validando Especificação Arquitetural: $SPEC_FILE"
echo "======================================"

MISSING_REQUIREMENTS=0
WARNINGS=0

# Seções obrigatórias (títulos nível 3 com numeração 5.X conforme Output Format)
SECTIONS=(
    "### 5.1. Header"
    "### 5.2. Architecture Overview"
    "### 5.3. C4 Model"
    "### 5.4. Data Modeling"
    "### 5.5. API Contracts"
    "### 5.6. Architecture Decision Records"
    "### 5.7. Security & Resilience"
    "### 5.9. Technology Stack"
    "### 5.10. Observability"
    "### 5.11. Next Steps"
)

for section in "${SECTIONS[@]}"; do
    if grep -q "^$section" "$SPEC_FILE"; then
        echo "✅ $section"
    else
        echo "❌ Seção ausente: $section"
        MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
    fi
done

# Seção opcional (condicional, não falha se ausente)
if grep -q "^### 5\\.8\\. Optional Modules" "$SPEC_FILE"; then
    echo "✅ ### 5.8. Optional Modules (presente)"
else
    echo "⚠️  ### 5.8. Optional Modules (não gerada — opcional, ignorando)"
    WARNINGS=$((WARNINGS + 1))
fi

# Verifica C4 com 3 níveis (procura por diagramas Mermaid)
C4_CONTENT=$(grep -c "\`\`\`mermaid" "$SPEC_FILE" || true)
if [ "$C4_CONTENT" -ge 3 ]; then
    echo "✅ C4 model: pelo menos 3 diagramas Mermaid (níveis 1,2,3)"
else
    echo "❌ C4 model: menos de 3 diagramas Mermaid encontrados ($C4_CONTENT)"
    MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
fi

# Verifica se há DER (diagrama entidade-relacionamento Mermaid)
if grep -q "erDiagram" "$SPEC_FILE"; then
    echo "✅ DER (Entity-Relationship diagram) presente"
else
    echo "❌ DER ausente ou não identificado (espera-se bloco mermaid com erDiagram)"
    MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
fi

# Verifica SQL DDL (CREATE TABLE)
if grep -qi "create table" "$SPEC_FILE"; then
    echo "✅ SQL DDL presente (CREATE TABLE)"
else
    echo "⚠️  SQL DDL não encontrado (recomendado para modelo relacional)"
    WARNINGS=$((WARNINGS + 1))
fi

# Verifica contratos de API (tabela ou OpenAPI)
if grep -q "|" "$SPEC_FILE" && grep -q "Endpoint" "$SPEC_FILE"; then
    echo "✅ API contracts (tabela markdown) presente"
elif grep -q "openapi:" "$SPEC_FILE"; then
    echo "✅ API contracts (OpenAPI YAML) presente"
else
    echo "❌ API contracts ausentes (nenhuma tabela ou bloco OpenAPI encontrado)"
    MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
fi

# Verifica pelo menos 3 ADRs
ADR_COUNT=$(grep -c "^### ADR [0-9]\+:" "$SPEC_FILE" || true)
if [ "$ADR_COUNT" -ge 3 ]; then
    echo "✅ ADRs: $ADR_COUNT encontrados (mínimo 3)"
else
    echo "❌ ADRs: apenas $ADR_COUNT encontrados (mínimo 3)"
    MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
fi

# Verifica mecanismo de idempotência (palavras-chave)
if grep -qi "idempot" "$SPEC_FILE"; then
    echo "✅ Idempotência mencionada"
    # Verifica se há menção a Redis ou cache
    if grep -qi "redis\|cache" "$SPEC_FILE"; then
        echo "✅  - Com mecanismo de armazenamento (Redis/cache)"
    else
        echo "⚠️  - Idempotência mencionada, mas sem especificar armazenamento (Redis, cache, etc.)"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "❌ Idempotência NÃO encontrada (obrigatória)"
    MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
fi

# Verifica guardrails de entrada
if grep -qi "guardrail\|sanitiza" "$SPEC_FILE"; then
    echo "✅ Guardrails de entrada mencionados"
    # Verifica se há padrões de bloqueio (regex ou lista)
    if grep -qi "pattern\|bloquear\|regex\|reject" "$SPEC_FILE"; then
        echo "✅  - Com padrões de bloqueio/regex"
    else
        echo "⚠️  - Guardrails mencionados, mas sem padrões concretos de bloqueio"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "❌ Guardrails de entrada NÃO encontrados (obrigatórios)"
    MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
fi

# Verifica se módulo conversacional foi ativado condicionalmente (se houver menção a agente/chat)
if grep -qi "conversational agent\|agente conversacional\|chat.*agent" "$SPEC_FILE"; then
    # Verifica se tem os subitens: persona, tools, memória, RAG
    if grep -qi "persona\|tools\|mem.*ria\|rag" "$SPEC_FILE"; then
        echo "✅ Módulo Conversacional ativado com subcomponentes"
    else
        echo "⚠️  Módulo Conversacional ativado, mas pode estar faltando detalhes (persona, tools, memória, RAG)"
        WARNINGS=$((WARNINGS + 1))
    fi
fi

# Verifica observabilidade (logs, métricas, health check)
if grep -qi "log\|métrica\|prometheus\|health" "$SPEC_FILE"; then
    echo "✅ Observabilidade configurada"
else
    echo "⚠️  Observabilidade pode estar incompleta (logs, métricas ou health check não identificados)"
    WARNINGS=$((WARNINGS + 1))
fi

echo "======================================"

if [ $MISSING_REQUIREMENTS -eq 0 ]; then
    echo "✅ Especificação válida! Todos os requisitos obrigatórios estão presentes."
    if [ $WARNINGS -gt 0 ]; then
        echo "⚠️  Porém, há $WARNINGS advertências não-críticas. Revise se necessário."
    fi
    exit 0
else
    echo "❌ Especificação inválida. Faltam $MISSING_REQUIREMENTS requisito(s) obrigatório(s)."
    exit 1
fi