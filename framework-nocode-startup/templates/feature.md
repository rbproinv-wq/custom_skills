# Template de Feature — `feature.md` (Arquivo Único)

```
features/<feature-slug>/
└── feature.md              ← ÚNICO arquivo: tudo que a LLM precisa
```

> **Regra de ouro**: Uma LLM nova, em uma sessão nova, deve conseguir executar esta feature COMPLETAMENTE usando apenas este arquivo. Se precisar de informação de fora, copie o trecho relevante aqui dentro.

---

## feature.md

```markdown
# Feature: <nome>

## 📋 Objetivo
<!-- Por que essa feature existe? Qual problema resolve? -->

## ✅ Critérios de Aceitação
<!-- Lista verificável. Quando tudo estiver verde, a feature está pronta. -->
- [ ] ...
- [ ] ...
- [ ] ...

## 🧩 Contexto Relevante (copiado do Documento Padrão)

### Stack usada nesta feature
<!-- Extraído da Etapa 4 — apenas o que esta feature usa -->
- Framework:
- Banco:
- API/Integrações:
- Modelo LLM:

### Schema (tabelas e campos que esta feature mexe)
<!-- Extraído da Etapa 5 — apenas tabelas/colunas relevantes -->

```sql
-- CREATE TABLE ...
```

### Regras de Negócio
<!-- Extraído da Etapa 3 — regras que afetam esta feature -->
- ...

## 📝 Plano de Execução
<!-- Tarefas de 2-5 min, com paths exatos e comandos de verificação -->

### 1. <tarefa>
- **Arquivos**: `src/app/...`
- **Fazer**: ...
- **Verificar**: `npm run test -- ...`

### 2. <tarefa>
- **Arquivos**: `src/app/...`
- **Fazer**: ...
- **Verificar**: ...

## 🔗 Dependências
<!-- Features que precisam estar prontas antes de começar esta -->
- Nenhuma / `features/<outra-feature>/feature.md`

## 📊 Estimativa de Contexto (preenchido pelo AGENTE)

| Heurística | Valor | Status |
|------------|-------|--------|
| Arquivos/telas envolvidos | <número> | ✅ ≤ 3 / ⚠️ 4-7 / 🚫 > 7 |
| Passos no fluxo do usuário | <número> | ✅ ≤ 15 / 🚫 > 15 |
| Complexidade estimada | <pequena/média/grande> | — |
| **Decisão** | | **✅ Direto / 🔪 Decompor** |

## 💡 Notas para a LLM
<!-- Dicas, armadilhas, decisões anteriores relevantes -->
-
```
