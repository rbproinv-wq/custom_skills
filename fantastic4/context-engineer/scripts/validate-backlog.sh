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

# Verifica .spec/tasks/ directory
if [ -d ".spec/tasks" ]; then
    TASK_COUNT=$(ls .spec/tasks/*.md 2>/dev/null | wc -l)
    if [ "$TASK_COUNT" -ge 1 ]; then
        echo "✅ Tasks individuais encontradas em .spec/tasks/ ($TASK_COUNT no total)"
    else
        echo "❌ .spec/tasks/ vazio ou sem arquivos .md"
        MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
    fi
else
    # Fallback: verifica padrão de tarefas no backlog.md
    TASK_COUNT=$(grep -c "^#### Task " "$BACKLOG_FILE" || true)
    if [ "$TASK_COUNT" -ge 1 ]; then
        echo "✅ Pelo menos uma tarefa encontrada no backlog ($TASK_COUNT no total)"
    else
        echo "❌ Nenhuma tarefa encontrada (esperado .spec/tasks/*.md ou '#### Task ...' no backlog)"
        MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
    fi
fi

# Verifica IDs das tarefas (padrão TIPO-NNN)
if [ -d ".spec/tasks" ]; then
    INVALID_IDS=$(ls .spec/tasks/*.md 2>/dev/null | grep -vE "(DB|BACK|FRONT|AGENT|TEST|INFRA)-[0-9]{3}" | wc -l)
else
    INVALID_IDS=$(grep "^#### Task " "$BACKLOG_FILE" | grep -vE "Task (DB|BACK|FRONT|AGENT|TEST|INFRA)-[0-9]{3}" | wc -l)
fi
if [ "$INVALID_IDS" -eq 0 ]; then
    echo "✅ Todas as tarefas têm ID válido (TIPO-NNN)"
else
    echo "❌ $INVALID_IDS tarefa(s) com ID inválido (use DB/BACK/FRONT/AGENT/TEST/INFRA-NNN)"
    MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
fi

# Verifica tipos de tarefa válidos (nos arquivos individuais ou no backlog)
if [ -d ".spec/tasks" ]; then
    for task_type in DB BACK FRONT AGENT TEST INFRA; do
        COUNT=$(ls .spec/tasks/$task_type-*.md 2>/dev/null | wc -l)
        if [ "$COUNT" -gt 0 ]; then
            echo "✅ Tipo $task_type presente ($COUNT tarefa(s))"
        fi
    done
else
    for task_type in DB BACK FRONT AGENT TEST INFRA; do
        COUNT=$(grep -c "\- \*\*Tipo:\*\* $task_type" "$BACKLOG_FILE" || true)
        if [ "$COUNT" -gt 0 ]; then
            echo "✅ Tipo $task_type presente ($COUNT tarefa(s))"
        fi
    done
fi

# Verifica BDD nos arquivos individuais de task (quando existem)
if [ -d ".spec/tasks" ]; then
    TOTAL_BDD_BLOCKS=0
    for task_file in .spec/tasks/*.md; do
        [ -f "$task_file" ] || continue
        BLOCKS=$(grep -c '```gherkin' "$task_file" || true)
        TOTAL_BDD_BLOCKS=$((TOTAL_BDD_BLOCKS + BLOCKS))
    done
    if [ "$TOTAL_BDD_BLOCKS" -ge "$TASK_COUNT" ]; then
        echo "✅ Blocos Gherkin encontrados nas tasks individuais"
    else
        echo "⚠️  Blocos Gherkin insuficientes nos arquivos de task"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    # Fallback: verifica no backlog.md
    BDD_BLOCKS=$(grep -c '```gherkin' "$BACKLOG_FILE" || true)
    if [ "$BDD_BLOCKS" -ge "$TASK_COUNT" ]; then
        echo "✅ Blocos Gherkin encontrados no backlog"
    else
        echo "⚠️  Blocos Gherkin insuficientes no backlog"
        WARNINGS=$((WARNINGS + 1))
    fi
fi

# Verifica artefatos DDD (.spec/modules/, architecture.md, domain_rules.md)
if [ -d ".spec/modules" ]; then
    MODULE_COUNT=$(ls .spec/modules/*.md 2>/dev/null | wc -l)
    if [ "$MODULE_COUNT" -ge 1 ]; then
        echo "✅ Bounded contexts em .spec/modules/ ($MODULE_COUNT módulo(s))"
    else
        echo "⚠️  .spec/modules/ vazio (pode ser aceitável em projetos pequenos)"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "⚠️  .spec/modules/ não encontrado (bounded contexts não foram gerados)"
    WARNINGS=$((WARNINGS + 1))
fi

if [ -f ".spec/architecture.md" ]; then
    echo "✅ .spec/architecture.md presente"
else
    echo "⚠️  .spec/architecture.md ausente (recomendado para prompt caching)"
    WARNINGS=$((WARNINGS + 1))
fi

if [ -f ".spec/domain_rules.md" ]; then
    echo "✅ .spec/domain_rules.md presente"
else
    echo "⚠️  .spec/domain_rules.md ausente (recomendado para prompt caching)"
    WARNINGS=$((WARNINGS + 1))
fi

# Verifica dependências (nos arquivos individuais ou no backlog)
if [ -d ".spec/tasks" ]; then
    MISSING_DEPS=0
    for task_file in .spec/tasks/*.md; do
        [ -f "$task_file" ] || continue
        if ! grep -q "Dependencies:" "$task_file"; then
            MISSING_DEPS=$((MISSING_DEPS + 1))
        fi
    done
    if [ "$MISSING_DEPS" -eq 0 ]; then
        echo "✅ Todas as tarefas têm campo de dependências"
    else
        echo "❌ $MISSING_DEPS tarefa(s) sem campo de dependências"
        MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
    fi
else
    DEPENDENCY_LINES=$(grep -c "\- \*\*Dependências:\*\*" "$BACKLOG_FILE" || true)
    if [ "$DEPENDENCY_LINES" -ge "$TASK_COUNT" ]; then
        echo "✅ Todas as tarefas têm campo de dependências"
    else
        echo "❌ Algumas tarefas sem campo de dependências"
        MISSING_REQUIREMENTS=$((MISSING_REQUIREMENTS + 1))
    fi
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