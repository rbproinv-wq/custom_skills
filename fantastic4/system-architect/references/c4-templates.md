# Templates para Diagramas C4 (Mermaid)

Use estes templates durante a etapa **2. Define C4 Model (3 Levels)** da Skill 3. Eles fornecem estrutura de diagramas Mermaid validáveis e exemplos adaptáveis.

---

## Nível 1 – Diagrama de Contexto

Mostra o sistema como uma caixa preta, seus atores (personas) e sistemas externos.

```mermaid
graph TD
    Paciente["Paciente\n(Usuário final)"]
    Admin["Administrador\n(Gestor)"]
    
    Sistema["Seu Sistema\n(Sistema de Agendamento)"]
    
    WhatsApp["WhatsApp API\n(Meta)"]
    LLM["LLM API\n(OpenAI/Claude)"]
    Email["Serviço de Email\n(SendGrid/Resend)"]
    
    Paciente -->|Envia mensagens| Sistema
    Admin -->|Acessa dashboard| Sistema
    Sistema -->|Envia/recebe| WhatsApp
    Sistema -->|Chama LLM| LLM
    Sistema -->|Envia notificações| Email
```

**Instruções para preencher:**
- Substitua os nomes dos atores pelas personas reais do PRD.
- Liste todos os sistemas externos obrigatórios (APIs, bancos externos, serviços de terceiros).
- As setas devem descrever a direção e o propósito (ex: "Envia mensagens", "Consulta agenda").

---

## Nível 2 – Diagrama de Contêineres

Mostra os principais contêineres (aplicações, bancos, caches) e como se comunicam.

```mermaid
graph TD
    subgraph "Cliente"
        WhatsApp["WhatsApp\n(Cliente)"]
        Browser["Navegador\n(React/Next.js)"]
    end
    
    subgraph "Sistema"
        Webhook["Webhook Receiver\n(FastAPI)"]
        API["API Pública\n(FastAPI)"]
        Worker["Background Worker\n(Celery/RQ)"]
        Redis["Redis\n(Cache/Idempotência)"]
        DB["PostgreSQL\n(Banco Relacional)"]
    end
    
    subgraph "Externo"
        LLM["LLM API\n(OpenAI)"]
        Meta["Meta Cloud API"]
    end
    
    WhatsApp -->|Webhook HTTP POST| Webhook
    Browser -->|REST API| API
    Webhook -->|Valida idempotência| Redis
    Webhook -->|Enfileira tarefa| Worker
    Worker -->|Consulta LLM| LLM
    Worker -->|Envia mensagem via API| Meta
    API -->|CRUD| DB
    Webhook -.->|Log| DB
```

**Instruções:**
- Use `subgraph` para agrupar atores, sistema e externos.
- Inclua contêineres obrigatórios: webhook receiver (se houver entrada externa), API, worker assíncrono, cache (Redis), banco de dados.
- Mostre dependências de dados (ex: worker → Redis para lock/distributed queue).

---

## Nível 3 – Diagrama de Componentes (para o Contêiner mais crítico)

Exemplo: Componentes internos do **Webhook Receiver**.

```mermaid
graph TD
    Ingresso["POST /webhook/whatsapp"]
    
    subgraph "Webhook Receiver Container (FastAPI)"
        Router["Router\n(Valida assinatura)"]
        Idempotency["Idempotency Middleware\n(Redis lookup)"]
        Guardrail["Input Guardrail\n(Sanitização semântica)"]
        Handler["Business Handler\n(Processa mensagem)"]
        Repository["Repository\n(DB/Cache)"]
        Queue["Queue Producer\n(Enfileira tarefa)"]
    end
    
    Ingresso --> Router
    Router --> Idempotency
    Idempotency -->|"Novo request"| Guardrail
    Idempotency -->|"Já processado"| ReturnCached["Retorna 200 (cached)"]
    Guardrail -->|Válido| Handler
    Guardrail -->|Rejeitado| Return400["Retorna 400 (invalido)"]
    Handler --> Repository
    Handler --> Queue
    Queue --> Worker["Worker\n(processamento async)"]
```

**Instruções:**
- Escolha o contêiner mais complexo (geralmente o que recebe dados externos).
- Descreva o fluxo: validação → idempotência → sanitização → lógica → persistência → fila.
- Inclua caminhos alternativos (cache hit, erro de validação).

---

## Diagrama Entidade-Relacionamento (DER) para modelagem de dados

```mermaid
erDiagram
    PACIENTE {
        uuid id PK
        string nome
        string telefone
        string email
        timestamp created_at
    }
    
    CONSULTA {
        uuid id PK
        uuid paciente_id FK
        datetime data_hora
        string status
        string especialidade
        timestamp created_at
    }
    
    MENSAGEM_WHATSAPP {
        uuid id PK
        string message_id
        string payload_hash
        string status
        timestamp received_at
    }
    
    IDEMPOTENCIA {
        string key PK
        string response_hash
        timestamp expires_at
    }
    
    PACIENTE ||--o{ CONSULTA : "tem"
    MENSAGEM_WHATSAPP ||--|| IDEMPOTENCIA : "opcional"
```

**Instruções:**
- Use sintaxe `erDiagram` do Mermaid.
- Defina PK (chave primária), FK (chave estrangeira).
- Mostre relacionamentos: `||--o{` (um para muitos), `||--||` (um para um), `}o--o{` (muitos para muitos).
- Inclua tabelas para idempotência e logs, se aplicável.

---

## Validação de sintaxe Mermaid

Antes de incluir no documento final, verifique:
- [ ] Nenhum caractere especial não escapado (ex: `:` dentro de texto substitua por `:` literal ou use `#lt;`).
- [ ] Labels com espaços devem estar entre aspas duplas.
- [ ] Setas com texto: `-->|texto|` ou `-- texto -->`.
- [ ] Subgraphs bem fechados com `end`.

> Estes templates são **referências**. A skill deve adaptar nomes, contêineres e componentes de acordo com o PRD e Dossiê.