# Exemplo de Instruções de Orquestração para o Backlog Atômico

Este documento fornece um modelo prático para a seção **5.4. Orchestration Instructions** da Skill 4. Inclui scripts de exemplo e fluxo de validação.

---

## 1. Coleta de Checklists de Conclusão

Cada IA programadora, ao finalizar uma tarefa, deve criar um arquivo de assinatura no formato:

```
TASK-<ID>.completed.json
```

Exemplo de conteúdo `TASK-BACK-002.completed.json`:

```json
{
  "task_id": "BACK-002",
  "completed_at": "2026-06-09T14:30:00Z",
  "signature": "ia-programadora-12345",
  "checklist_items": {
    "code_implemented": true,
    "bdd_tests_pass": true,
    "error_handling": true,
    "logs_added": true,
    "idempotency_verified": true,
    "no_secrets": true,
    "documentation_added": true,
    "signature_recorded": true
  },
  "notes": "Endpoint testado localmente com dados mock"
}
```

### Script de coleta (Python)

```python
#!/usr/bin/env python3
# collect_checklists.py - Varre diretório e valida tarefas concluídas

import os
import json
from pathlib import Path

COMPLETION_DIR = Path(".")  # diretório raiz do projeto
REQUIRED_KEYS = {"task_id", "signature", "checklist_items"}

def load_completed_tasks():
    tasks = {}
    for json_file in COMPLETION_DIR.glob("TASK-*.completed.json"):
        with open(json_file) as f:
            data = json.load(f)
            missing = REQUIRED_KEYS - set(data.keys())
            if missing:
                print(f"⚠️ {json_file.name} faltando chaves: {missing}")
                continue
            tasks[data["task_id"]] = data
    return tasks

def validate_dependencies(tasks, backlog_tasks):
    missing = []
    for task in backlog_tasks:
        task_id = task["id"]
        if task_id not in tasks:
            missing.append(task_id)
    return missing

if __name__ == "__main__":
    completed = load_completed_tasks()
    print(f"Encontradas {len(completed)} tarefas concluídas.")
    # Exemplo: validar contra um backlog carregado de um JSON central
```

---

## 2. Execução de Testes de Integração

### Estrutura recomendada de testes

```
tests/
  integration/
    test_agendamento_flow.py
    test_whatsapp_webhook.py
    test_agent_tools.py
```

### Script de execução (bash)

```bash
#!/bin/bash
# run_integration_tests.sh

set -e

echo "🚀 Rodando testes de integração..."

# Configurar ambiente de teste
export ENVIRONMENT=test
export DATABASE_URL=postgresql://test:test@localhost:5432/testdb

# Subir dependências (docker-compose de teste)
docker-compose -f docker-compose.test.yml up -d

# Aguardar banco ficar pronto
sleep 3

# Executar pytest com marcador 'integration'
pytest tests/integration/ -v --tb=short

# Coletar código de saída
EXIT_CODE=$?

# Derrubar containers
docker-compose -f docker-compose.test.yml down

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Todos os testes de integração passaram."
else
    echo "❌ Alguns testes falharam."
    exit $EXIT_CODE
fi
```

---

## 3. Geração de Relatório de Conclusão

### Script que gera um relatório markdown

```bash
#!/bin/bash
# generate_report.sh

REPORT_FILE="completion_report.md"

echo "# Relatório de Conclusão do Backlog" > $REPORT_FILE
echo "" >> $REPORT_FILE
echo "**Data:** $(date '+%Y-%m-%d %H:%M:%S')" >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Listar tarefas concluídas
echo "## Tarefas Concluídas" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "| Tarefa | Concluída em | Assinatura |" >> $REPORT_FILE
echo "|--------|--------------|------------|" >> $REPORT_FILE

for f in TASK-*.completed.json; do
    if [ -f "$f" ]; then
        TASK_ID=$(jq -r '.task_id' "$f")
        DATE=$(jq -r '.completed_at' "$f")
        SIG=$(jq -r '.signature' "$f")
        echo "| $TASK_ID | $DATE | $SIG |" >> $REPORT_FILE
    fi
done

# Verificar tarefas pendentes (comparar com lista mestra)
echo "" >> $REPORT_FILE
echo "## Tarefas Pendentes" >> $REPORT_FILE
echo "" >> $REPORT_FILE

# (Assumindo que existe um arquivo backlog_tasks.txt com todos os IDs)
if [ -f "backlog_tasks.txt" ]; then
    while read task_id; do
        if [ ! -f "TASK-${task_id}.completed.json" ]; then
            echo "- $task_id" >> $REPORT_FILE
        fi
    done < backlog_tasks.txt
fi

echo "" >> $REPORT_FILE
echo "## Resumo" >> $REPORT_FILE
TOTAL=$(grep -c "^| TASK-" <<< "$(cat $REPORT_FILE)" || true)
echo "- Total de tarefas concluídas: $TOTAL" >> $REPORT_FILE

cat $REPORT_FILE
```

---

## 4. Fluxo de Orquestração Passo a Passo (para a equipe)

Para que o backlog seja executado por IAs programadoras, recomenda-se o seguinte fluxo:

1. **Preparação do ambiente**:
   ```bash
   git clone <repo>
   cd <repo>
   python -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   docker-compose up -d
   ```

2. **Execução das tarefas na ordem recomendada** (ex: DB-001 → BACK-001 → BACK-002 → ...).

3. **Para cada tarefa**, o programador:
   - Lê a seção da tarefa no backlog.
   - Implementa código e testes.
   - Marca o checklist (pode ser em papel digital, mas prefere-se o JSON assinado).
   - Cria o arquivo `TASK-<ID>.completed.json`.

4. **Após concluir um módulo** (ex: todas as tarefas de "Agendamento"), roda os testes de integração do módulo:
   ```bash
   pytest tests/integration/test_agendamento_flow.py
   ```

5. **Ao final de tudo**, executa o script de relatório e validação final:
   ```bash
   python collect_checklists.py
   bash generate_report.sh
   ```

6. **O relatório gerado** é enviado para o ciclo PDCA ou para o próximo estágio (deploy).

---

## 5. Exemplo de Comando Agregador (Makefile)

Para simplificar a orquestração, pode-se oferecer um `Makefile`:

```makefile
.PHONY: setup test-integration report clean

setup:
	pip install -r requirements.txt
	docker-compose up -d

test-integration:
	pytest tests/integration/ -v

report:
	bash generate_report.sh

clean:
	docker-compose down
	rm -f TASK-*.completed.json
	rm -f completion_report.md

all: setup test-integration report
```

Uso: `make all`

---

## 6. Integração com CI (GitHub Actions)

Exemplo de workflow (`.github/workflows/validate.yml`):

```yaml
name: Validate Backlog Completion

on:
  push:
    branches: [ main ]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - name: Install dependencies
        run: pip install -r requirements.txt
      - name: Run integration tests
        run: pytest tests/integration/ -v
      - name: Check all tasks completed
        run: |
          python collect_checklists.py
          if [ $? -ne 0 ]; then exit 1; fi
```

> Este exemplo é uma referência. A Skill 4 deve adaptar os scripts e instruções conforme a stack (Python, Node.js, etc.) e as ferramentas de orquestração escolhidas (Makefile, Just, Taskfile, etc.). O princípio é fornecer um caminho claro e automatizável para validar a conclusão do backlog.