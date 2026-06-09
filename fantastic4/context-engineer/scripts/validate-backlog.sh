#!/bin/bash
# validate-backlog.sh - Verifica se o backlog gerado pela Skill 4 está completo e bem estruturado
# Uso: ./validate-backlog.sh <arquivo-backlog.md>

set -e

BACKLOG_FILE="$1"

if [ -z "$BACKLOG_FILE" ]; then
    echo "❌ Uso: $0 <arquivo-backlog.md>"
    exit 1
fi

if [ ! -f "$BACKLOG_FILE" ]; then
    echo "❌ Arquivo não encontrado: $BACKLOG_FILE"
    exit 1
fi

echo "🔍 Validando Backlog Atômico: $BACKLOG_FILE"
echo "======================================"

MISSING_REQUIREMENTS=0
WARNINGS=0

# Seções obrigatórias (títulos de nível 2)
SECTIONS=(
    "## Module Summary"
    "## Detailed Task List"
    "## Orchestration Instructions"
    "## Recommendations for AI Programmers"
)

for section in "${SECTIONS[@]}"; do
    if grep -q "^$section" "$BACKLOG_FILE"; then
        echo "✅ $section"
    else
        echo "❌ Seção ausente: $section"
        MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
    fi
done

# Verifica cabeçalho com total de tarefas
if grep -q "Total tasks:" "$BACKLOG_FILE" || grep -q "Quantidade total de tarefas" "$BACKLOG_FILE"; then
    echo "✅ Cabeçalho com total de tarefas"
else
    echo "⚠️  Cabeçalho não contém 'Total tasks:' ou 'Quantidade total de tarefas'"
    WARNINGS=$((WARNINGS + 1))
fi

# Verifica se há pelo menos uma tarefa (padrão "#### Tarefa ")
TASK_COUNT=$(grep -c "^#### Tarefa" "$BACKLOG_FILE" || true)
if [ "$TASK_COUNT" -ge 1 ]; then
    echo "✅ Pelo menos uma tarefa encontrada ($TASK_COUNT no total)"
else
    echo "❌ Nenhuma tarefa encontrada (esperado padrão '#### Tarefa ...')"
    MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
fi

# Verifica IDs das tarefas (padrão TIPO-NNN)
INVALID_IDS=$(grep "^#### Tarefa" "$BACKLOG_FILE" | grep -vE "Tarefa (DB|BACK|FRONT|AGENT|TEST|INFRA)-[0-9]{3}" | wc -l)
if [ "$INVALID_IDS" -eq 0 ]; then
    echo "✅ Todas as tarefas têm ID válido (TIPO-NNN)"
else
    echo "❌ $INVALID_IDS tarefa(s) com ID inválido (use DB/BACK/FRONT/AGENT/TEST/INFRA-NNN)"
    MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
fi

# Verifica tipos de tarefa válidos
for task_type in DB BACK FRONT AGENT TEST INFRA; do
    COUNT=$(grep -c "\- \*\*Tipo:\*\* $task_type" "$BACKLOG_FILE" || true)
    if [ "$COUNT" -gt 0 ]; then
        echo "✅ Tipo $task_type presente ($COUNT tarefa(s))"
    fi
done

# Verifica se cada tarefa tem pelo menos 3 cenários BDD
# Procura por blocos de código Gherkin (```gherkin) e conta cenários
BDD_BLOCKS=$(grep -c "\`\`\`gherkin" "$BACKLOG_FILE" || true)
if [ "$BDD_BLOCKS" -ge "$TASK_COUNT" ]; then
    echo "✅ Blocos Gherkin encontrados para cada tarefa"
    # Conta cenários: linhas que começam com "Cenário:"
    SCENARIO_COUNT=$(grep -c "^  Cenário:" "$BACKLOG_FILE" || true)
    if [ "$SCENARIO_COUNT" -ge $((TASK_COUNT * 3)) ]; then
        echo "✅ Pelo menos 3 cenários por tarefa (total $SCENARIO_COUNT cenários)"
    else
        echo "⚠️  Esperado pelo menos $((TASK_COUNT * 3)) cenários, encontrados $SCENARIO_COUNT"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "⚠️  Blocos Gherkin insuficientes ($BDD_BLOCKS) para o número de tarefas ($TASK_COUNT)"
    WARNINGS=$((WARNINGS + 1))
fi

# Verifica checklist de conclusão (padrão "- [ ]")
CHECKLIST_ITEMS=$(grep -c "^  - \[ \]" "$BACKLOG_FILE" || true)
if [ "$CHECKLIST_ITEMS" -ge $((TASK_COUNT * 8)) ]; then
    echo "✅ Checklist de conclusão presente (mínimo 8 itens por tarefa)"
else
    echo "⚠️  Checklist com menos de 8 itens por tarefa (esperado $((TASK_COUNT * 8)), encontrado $CHECKLIST_ITEMS)"
    WARNINGS=$((WARNINGS + 1))
fi

# Verifica se há pelo menos um item de idempotência no checklist se a tarefa for webhook/endpoint state-changing
# (checagem simples: se aparece "Idempotência" no checklist)
IDEMPOTENCY_MENTION=$(grep -c "Idempotência verificada" "$BACKLOG_FILE" || true)
if [ "$IDEMPOTENCY_MENTION" -gt 0 ]; then
    echo "✅ Idempotência mencionada nos checklists"
else
    echo "⚠️  Nenhuma menção a 'Idempotência verificada' (pode ser aceitável se não houver webhooks)"
    # não conta como erro obrigatório porque pode não se aplicar
fi

# Verifica dependências: formato esperado "- **Dependências:** (lista ou 'Nenhuma')"
DEPENDENCY_LINES=$(grep -c "\- \*\*Dependências:\*\*" "$BACKLOG_FILE" || true)
if [ "$DEPENDENCY_LINES" -ge "$TASK_COUNT" ]; then
    echo "✅ Todas as tarefas têm campo de dependências"
else
    echo "❌ Algumas tarefas sem campo de dependências"
    MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
fi

# Verifica se há instruções de orquestração (pelo menos um comando ou script)
if grep -q "```bash\|```python\|```sh\|```powershell" "$BACKLOG_FILE"; then
    echo "✅ Instruções de orquestração incluem exemplos de comando/script"
else
    echo "⚠️  Instruções de orquestração sem exemplos de script (recomendado)"
    WARNINGS=$((WARNINGS + 1))
fi

echo "======================================"

if [ $MISSING_REQUIREMENTS -eq 0 ]; then
    echo "✅ Backlog válido! Todos os requisitos obrigatórios estão presentes."
    if [ $WARNINGS -gt 0 ]; then
        echo "⚠️  Porém, há $WARNINGS advertências não-críticas. Revise se necessário."
    fi
    exit 0
else
    echo "❌ Backlog inválido. Faltam $MISSING_REQUIREMENTS requisito(s) obrigatório(s)."
    exit 1
fi