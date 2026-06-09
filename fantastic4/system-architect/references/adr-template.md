# Template para Architecture Decision Records (ADRs)

Use este template durante a etapa **5. Architecture Decision Records (ADRs)** da Skill 3. Cada ADR deve documentar uma decisão arquitetural importante, incluindo contexto, decisão e consequências.

---

## Formato padrão do ADR

```markdown
### ADR [NÚMERO]: [Título breve da decisão]

**Data:** [AAAA-MM-DD]  
**Status:** Proposto | Aceito | Deprecado | Substituído  

**Contexto (o problema que motivou a decisão):**
Descreva a situação, as forças em jogo (trade-offs, restrições, incertezas). 
Inclua referências a requisitos do PRD ou restrições do Dossiê.

**Decisão (o que foi escolhido):**
Declare a decisão de forma clara e inequívoca. Mencione tecnologias, padrões, 
ou práticas específicas.

**Consequências (positivas e negativas):**
- **Positivas:** O que melhora (manutenibilidade, performance, custo, segurança).
- **Negativas:** O que piora ou é comprometido (complexidade adicional, custo operacional, curva de aprendizado).

**Alternativas consideradas (opcional, mas recomendado):**
Liste outras opções e explique por que foram rejeitadas.
```

---

## Exemplo 1: Idempotência com Redis

```markdown
### ADR 001: Implementar idempotência via Redis para webhooks

**Data:** 2026-06-09  
**Status:** Aceito  

**Contexto:**  
O sistema recebe webhooks do WhatsApp API. O Meta pode reenviar o mesmo webhook 
em caso de timeout ou falha de rede, causando processamento duplicado (ex: duplicar 
consulta, enviar lembretes múltiplos). O PRD exige consistência de agendamentos.

**Decisão:**  
Usar Redis como armazenamento de chave/valor para rastrear IDs de mensagens 
(`message_id`). O middleware de idempotência verifica a chave antes de processar. 
Se existir, retorna a resposta anterior (cacheada). Chave expira em 5 minutos (TTL).

**Consequências:**  
- **Positivas:** Baixa latência (sub-milissegundo), fácil escalabilidade, sem 
  impacto no banco principal.  
- **Negativas:** Introduz dependência externa (Redis); memória adicional necessária.  
- **Alternativas consideradas:**  
  - *Banco de dados com chave única*: mais lento e aumenta carga no PostgreSQL.  
  - *Idempotência via tabela de logs*: funcional, mas pior performance.  
  - *Ignorar duplicatas*: risco de estado inconsistente (rejeitado).
```

---

## Exemplo 2: Escolha de Stack (FastAPI vs. n8n)

```markdown
### ADR 002: Utilizar FastAPI + PostgreSQL + Redis como stack principal

**Data:** 2026-06-09  
**Status:** Aceito  

**Contexto:**  
O sistema precisa processar webhooks de alta taxa (potencial 100 mensagens/segundo), 
chamar LLM com latência variável, e fornecer endpoints de consulta. O Dossiê de 
Restrições aponta necessidade de rastreabilidade e idempotência. O orçamento inicial 
é baixo, portanto economia de recursos é relevante.

**Decisão:**  
FastAPI (Python assíncrono) para APIs e webhooks, PostgreSQL para dados relacionais, 
Redis para cache e idempotência. A fila de tarefas será implementada com `background_tasks` 
do FastAPI + Redis (RLib) para simplicidade no MVP, evoluindo para Celery se necessário.

**Consequências:**  
- **Positivas:** Menor consumo de CPU/memória que soluções baseadas em Java/.NET; 
  desenvolvimento rápido; ótima compatibilidade com LLM APIs (HTTP assíncrono).  
- **Negativas:** Python tem GIL, mas o MVP não exige paralelismo intenso; a manutenção 
  de workers assíncronos pode ser mais manual que n8n.  
- **Alternativas consideradas:**  
  - *n8n (low-code)*: mais rápido para prototipagem, mas menos flexível para lógica 
    personalizada (idempotência, guardrails) e custo de infra maior.  
  - *Node.js + Express*: boa performance, mas o time tem mais experiência em Python.  
  - *Go*: excelente performance, mas curva de aprendizado e menos bibliotecas para 
    integração com LLM.
```

---

## Exemplo 3: Fila Assíncrona para Chamadas LLM

```markdown
### ADR 003: Processar chamadas LLM de forma assíncrona com fila

**Data:** 2026-06-09  
**Status:** Aceito  

**Contexto:**  
A API do WhatsApp exige resposta dentro de 15 segundos para webhooks (timeout). 
A chamada ao LLM pode levar 2–5 segundos, mas picos de tráfego podem causar 
timeout e perda de mensagens.

**Decisão:**  
Receber o webhook, validar idempotência, publicar uma tarefa em fila (Redis + RQ), 
e responder `202 Accepted` imediatamente. Um worker separado consome a fila, chama 
o LLM e envia a resposta via WhatsApp API (ou salva no banco).

**Consequências:**  
- **Positivas:** Respeita o timeout do webhook; melhor resiliência (tarefas podem 
  ser reprocessadas); desacopla recepção de processamento.  
- **Negativas:** Maior complexidade (worker separado); o usuário não recebe resposta 
  instantânea (mas WhatsApp aceita resposta assíncrona).  
- **Alternativas consideradas:**  
  - *Processamento síncrono*: arriscado timeout e perda de mensagens.  
  - *Webhook com retry manual*: não resolve o problema de latência.
```

---

## Lista de ADRs obrigatórios mínimos (Skill 3)

Para a especificação ser completa, inclua **pelo menos** estes três ADRs:

1. **Idempotência** (como e por quê)
2. **Stack tecnológica** (justificando a escolha)
3. **Comunicação assíncrona / fila** (se houver chamadas externas lentas, como LLM)

Outros ADRs podem ser adicionados conforme necessidade: banco de dados específico, estratégia de cache, particionamento de dados, padrão de autenticação, etc.

> Este template é um guia para a skill gerar ADRs consistentes. Cada ADR deve ser escrito em linguagem clara e direta, sem jargões desnecessários, mas com rigor técnico.