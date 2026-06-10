---
disable-model-invocation: true
name: framework-nocode-startup
description: "Guia founders nao-tecnicos do zero ao MVP funcional via Vibe Coding. Framework NoCode StartUp AI em 2 fases e 7 etapas: Visao, Mercado, Processos, Arquitetura, Dados, Criacao, Lancamento. Gera Documento Padrao progressivo com saidas deterministicas e criterios de saida por etapa."
version: "1.0"
user-invokable: true
risk: safe
source: community
date_added: "2026-06-05"
---

# Framework NoCode StartUp AI — Vibe Coding Edition

> Framework completo do zero ao MVP funcional, adaptado do NoCode StartUp AI (Matheus Castelo/Neto Camarano) para founders não-técnicos que usam Vibe Coding.

Nenhuma linha de código é escrita sem antes responder: **qual problema estamos resolvendo, para quem, e como sabemos que funcionou?**

---

## 🎯 When to Use

| Ativar Quando... | Não Ativar Quando... |
|-----------------|---------------------|
| Founder não-técnico quer validar ideia com MVP | Projeto já tem codebase estabelecida |
| Precisa de processo estruturado do zero ao deploy | Só precisa de um componente ou feature específica |
| Quer documentar decisões estratégicas progressivamente | Já tem Documento Padrão preenchido |
| Vai usar Vibe Coding (Claude Code, Cursor, Copilot) | Precisa de código altamente regulado (saúde, aviação) |
| MVP cabe em 4-8 sprints (semanas) | Projeto enterprise com múltiplos times |
| Founder quer autonomia sem depender de CTO técnico | Founder não quer seguir processo estruturado |

---

## 📋 Overview — 2 Fases · 7 Etapas

```
┌──────────────────────────────────────────────────────────┐
│            FRAMEWORK NOCODE STARTUP AI                    │
│                                                          │
│  FASE 1 — PLANEJAMENTO (etapas 1-5)                     │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐     │
│  │ 1.   │→│ 2.   │→│ 3.   │→│ 4.   │→│ 5.   │     │
│  │Visão │ │Merc. │ │Proc. │ │Arq.  │ │Dados │     │
│  └──┬───┘ └──┬───┘ └──┬───┘ └──┬───┘ └──┬───┘     │
│     └────────┴────────┴────────┴────────┘          │
│                    ↓                                │
│  FASE 2 — EXECUÇÃO (etapas 6-7)                    │
│  ┌──────────┐         ┌──────────┐                  │
│  │ 6. Criação│───────→│ 7.       │                  │
│  │ Interativa│         │ Lançamento│                  │
│  │ (MVP)    │         │ + PDCA   │                  │
│  └──────────┘         └──────────┘                  │
│                                                          │
│  ═══════════════════════════════════════════════         │
│  Documento Padrão gerado progressivamente                │
│  Cada etapa produz UMA seção do documento                │
│  Cada etapa tem EXIT CRITERIA antes de avançar          │
└──────────────────────────────────────────────────────────┘
```

---

## ⚙️ Como Usar Esta Skill

A skill orquestra a criação progressiva de um **Documento Padrão** — um arquivo `.md` que cresce a cada etapa. O arquivo gerado é restartável: qualquer etapa pode ser retomada individualmente.

**Fluxo por etapa:**

```
1. AGENTE lê a etapa → apresenta perguntas ao founder
2. FOUNDER responde → AGENTE atualiza o Documento Padrão
3. AGENTE valida exit criteria → se OK, avança
4. AGENTE registra decisão no Decision Log
```

**Arquivos gerados:**

| Arquivo | Conteúdo | Criado em |
|---------|----------|-----------|
| `docs/documento-padrao.md` | Canvas vivo do projeto | Etapa 1, expandido a cada etapa |
| `docs/decision-log.md` | Registro de decisões | Etapa 1, expandido a cada etapa |
| `docs/checklist-seguranca.md` | Checklist pré-deploy | Etapa 6 |
| `docs/prd.md` | Product Reference Document | Etapa 6 |

---

## FASE 1 — PLANEJAMENTO (Estratégia)

> Antes de qualquer código: problema validado, mercado entendido, processo mapeado, arquitetura decidida, dados modelados.

---

### Etapa 1 — Visão Estratégica

**Input:** Ideia inicial do founder (pode ser vaga, frase única).

**Processo:**

1. Perguntar e documentar:
   - **Problema**: Qual dor específica? Para quem? Em que contexto?
   - **Objetivo**: O que o MVP precisa provar? (hipótese única)
   - **Métricas de sucesso**: Adoção (usuários/semana), tempo de resposta, conversão (%), horas economizadas
   - **Escopo inicial**: O que entra no MVP vs. V2 vs. nunca
   - **Estimativa de custos**: ORÇAMENTO ZERO se possível (free tiers: Supabase, Vercel, GitHub)

2. Validar com perguntas de Sócrates:
   - "Se isso existisse amanhã, o que mudaria no seu dia?"
   - "Quem mais sente essa dor?"
   - "O que você usa hoje para resolver?"

**Output:** Seção `## 1. Estratégia: [objetivo]` no Documento Padrão.

**Exit Criteria:**
- [ ] Problema descrito em 1 frase clara
- [ ] Público-alvo identificado (não "todo mundo")
- [ ] 1 métrica de sucesso definida com valor alvo
- [ ] Escopo MVP vs. V2 separado
- [ ] Orçamento estimado (ideal: $0/mês em free tiers)

---

### Etapa 2 — Market Insights

**Input:** Seção 1 do Documento Padrão.

**Processo:**

1. Pesquisar e documentar:
   - **Concorrentes diretos e indiretos**: O que eles fazem? Onde falham?
   - **UX Patterns do segmento**: Paleta, tipografia, componentes comuns, padrões de navegação
   - **Análise SWOT**: Forças, Fraquezas, Oportunidades, Ameaças
   - **Diferenciais defensáveis**: O que é difícil de copiar? (dados proprietários, network effect, workflow embeddado)

2. Perguntas-guias:
   - "Por que os usuários dos concorrentes migrariam para o seu?"
   - "O que você faz de 10x melhor?"
   - "Qual barreira de entrada você tem?"

3. **Validação com Usuários (obrigatório antes da Etapa 3)**:
   - Realizar **5 entrevistas semiestruturadas** com potenciais usuários
   - **Onde encontrar**: LinkedIn, grupos de WhatsApp/Telegram do segmento, Google Forms compartilhado em redes sociais, contatos pessoais, associações de classe, Google Meets/Zoom para entrevistas ao vivo
   - **Script de entrevista** (15 min):
     1. "Qual sua maior dificuldade com [problema] hoje?"
     2. "Como você resolve isso atualmente?"
     3. "O que você já tentou e não funcionou?"
     4. "Se existisse uma solução que fizesse X, você usaria?"
     5. "Quanto você pagaria por mês por isso?"
     6. "Indicações: quem mais você conhece que tem esse problema?"
   - **Sintetizar**: Agrupar respostas por tema, identificar padrões, documentar citações literais
   - **Fallback** (quando entrevistas reais não são possíveis): O AGENTE DEVE pesquisar dados públicos de mercado sobre o segmento (IBGE, pesquisas setoriais, artigos, relatórios) e criar **personas detalhadas** com dores, comportamentos e objecções realistas. As personas e simulações DEVEM ser documentadas no Documento Padrão.

**Output:** Seção `## 2. Mercado: [insights]` no Documento Padrão (incluindo resultados da validação).

**Exit Criteria:**
- [ ] Mínimo 3 concorrentes mapeados com falhas identificadas
- [ ] 1 diferencial defensável documentado
- [ ] SWOT completo (4 quadrantes)
- [ ] Inspiração visual/UX selecionada
- [ ] Mínimo 5 potenciais usuários entrevistados OU personas validadas com dados de mercado
- [ ] Padrões de resposta documentados (o que mais dói, o que mais valorizam)

---

### Etapa 3 — Mapeamento de Processos

**Input:** Seções 1-2 do Documento Padrão.

**Processo:**

1. Mapear o fluxo completo:
   - **Jornada do usuário**: Descoberta → Primeiro uso → Valor → Retenção → Indicação
   - **Árvore de decisão do sistema**: Se X → Y, senão → Z
   - **Triggers**: O que inicia cada fluxo? (email, webhook, agendamento, ação do usuário)
   - **Estados do CRM/board**: Ex: New Lead → In Service → Awaiting → Completed → Archived

2. Formato: Diagrama textual (Mermaid ou lista hierárquica)

**Output:** Seção `## 3. Fluxo: [diagrama]` no Documento Padrão.

**Exit Criteria:**
- [ ] Fluxo principal mapeado (início ao fim)
- [ ] Pelo menos 1 branch/ramificação identificada
- [ ] Triggers documentados para cada passo
- [ ] Estados do board definidos

---

### Etapa 4 — Arquitetura Técnica

**Input:** Seções 1-3 do Documento Padrão.

**Processo:**

1. Definir a stack técnica (adaptável ao projeto, recomendar por padrão):
   - **Interface**: Web (Next.js), Mobile (Expo), Chat (Telegram/WhatsApp), CLI
   - **Agente AI**: modelo LLM — ver passo 2 abaixo antes de decidir
   - **Memória**: PostgreSQL (Supabase/Neon) para histórico, Redis (Upstash) para cache/sessão
   - **RAG (fontes de conhecimento)**: Documentos, FAQs, base de conhecimento vetorial (pgvector)
   - **Tools/MCP**: Integrações GET (consulta) e POST (ação) — ex: consultar API pública, enviar email, criar ticket
   - **Funcionalidades**: Lista de capacidades do MVP
   - **Anotações de Prompt**: Regras de comportamento do agente (tom, limites, formato de resposta)

2. **Pesquisa de Custo-Benefício de LLMs (obrigatório)**:
   O AGENTE DEVE pesquisar na internet os preços atuais dos principais provedores de LLM para escolher o modelo com melhor relação custo-benefício para cada tarefa do sistema. Esta pesquisa DEVE ser refeita a cada nova aplicação do framework, pois preços e modelos mudam semanalmente.

   **Metodologia:**
   a) **Classificar as tarefas do sistema por tipo**:
      - **Classificação/extração** (ex: identificar intenção do usuário) → modelo pequeno e rápido
      - **Conversação/geração** (ex: responder paciente) → modelo grande e caprichado
      - **RAG/embedding** (ex: buscar FAQ) → modelo de embedding dedicado
   b) **Para cada tipo, pesquisar**:
      - Preço por 1M tokens de entrada (input)
      - Preço por 1M tokens de saída (output)
      - Context window (quantos tokens cabem)
      - Performance em benchmarks relevantes (MMLU, HumanEval, etc.)
   c) **Fontes de consulta recomendadas** (sempre buscar as URLs atuais):
      - https://openai.com/pricing
      - https://anthropic.com/pricing
      - https://ai.google.dev/pricing
      - https://groq.com/pricing (inferência rápida e barata)
      - Pesquisa: "best cheap LLM 2026" ou "modelos LLM melhor custo-benefício 2026"
   d) **Estratégia de otimização de custos**:
      - **Modelo especialista por tarefa**: usar modelo barato para classificação, modelo caro só para conversação
      - **Fallback automático**: se modelo caro exceder orçamento do mês, cair para modelo barato
      - **Cache de respostas frequentes**: FAQ respondido uma vez, cacheado para não pagar de novo
      - **Limite de gastos**: configurar hard cap mensal ($) na conta do provedor
      - **Exemplo prático** (projeto clínica): Gemini 2.0 Flash para classificar intenção ($0.10/1M input), Claude 3.5 Haiku para conversação ($0.80/1M input) — economia de ~70% vs. usar Claude Opus para tudo

3. Documentar decisões com justificativa ("por que X ao invés de Y")

**Output:** Seção `## 4. Stack: [decisões]` no Documento Padrão (incluindo tabela de modelos pesquisados com preços).

**Exit Criteria:**
- [ ] Interface escolhida e justificada
- [ ] Modelo LLM + provider definidos (com pesquisa de preços atualizada)
- [ ] Estratégia de memória definida (curto + longo prazo)
- [ ] Fontes RAG identificadas
- [ ] Mínimo 2 tools/integrações mapeadas
- [ ] Anotações de prompt rascunhadas
- [ ] Tabela de custo estimado por tarefa documentada (tipo de tarefa, modelo, $/1M tokens, custo mensal estimado)
- [ ] Estratégia de fallback definida (o que acontece se LLM ficar indisponível ou orçamento estourar)

---

### Etapa 5 — Modelagem de Dados

**Input:** Seções 1-4 do Documento Padrão.

**Processo:**

1. Projetar o schema de dados:
   - **Tabelas/coleções**: O que precisa ser armazenado?
   - **Colunas/campos**: Nome, tipo, constraints
   - **Relações**: 1:1, 1:N, N:N
   - **Índices**: O que será buscado com frequência?
   - **Políticas de segurança (RLS)**: Quem pode ler/escrever o quê? (se Supabase)

2. Formato: SQL DDL ou Tabela Markdown (para founders não-técnicos)

**Output:** Seção `## 5. Schema: [modelagem]` no Documento Padrão.

**Exit Criteria:**
- [ ] Todas as entidades do fluxo viram tabelas
- [ ] Relações entre tabelas documentadas
- [ ] Políticas de acesso definidas (quem vê o quê)
- [ ] Schema é backward-compatible V1 (evitar breaking changes precoces)

---

## FASE 2 — EXECUÇÃO (Construção)

> Documento Padrão completo. Agora é construir, testar e lançar.

---

### Etapa 6 — Criação Interativa (MVP)

**Input:** Documento Padrão completo (seções 1-5).

**Processo:**

0. **Decomposição de Features** (executada pelo AGENTE automaticamente):
   - A partir do Documento Padrão, o AGENTE extrai a lista de features do MVP e cria:
     - `features/<feature-slug>/feature.md` — um arquivo por feature, autocontido
     - `docs/context/global/` — contexto compartilhado (stack, schema, regras)
   - **Orçamento de Contexto** (estimado pelo AGENTE por heurísticas, sem fórmula):
     - **≤ 3 arquivos/telas**: direto — sem decomposição
     - **4–7 arquivos/telas**: alerta — considerar sub-features
     - **> 7 arquivos/telas**: decomposição OBRIGATÓRIA
     - **> 15 passos no fluxo do usuário**: decomposição OBRIGATÓRIA
     - Feature descrita em mais de 1 página: considerar sub-features
     - O AGENTE considera o modelo alvo (Etapa 4): modelos gratuitos (120k–200k tokens) usam thresholds mais conservadores
   - **Regra de autocontenção**: uma LLM nova deve conseguir executar a feature apenas com o conteúdo do seu `feature.md`. Informação compartilhada (stack, schema) vai em `docs/context/global/` — cada feature referencia o path, não duplica o conteúdo
   - **Sprints**: a ordem do Documento Padrão (jornada do usuário) define a prioridade. Sem grafo de dependências explícito
   - **MVP pequeno (≤ 5 features)**: esta etapa é **OPCIONAL** — features desenvolvidas diretamente do Documento Padrão
   - **Revisão de consistência**: após desenvolver todas as features, o AGENTE executa uma verificação para garantir que decisões isoladas não criaram conflitos entre features (nomes de campos, fluxos, regras de negócio)

1. **Setup do projeto**: Scaffold da stack escolhida (Next.js + Supabase + etc.)

2. **Sprints guiados por features** — executar features do diretório `features/` na ordem definida pela jornada do usuário (Documento Padrão). Cada sprint entrega uma ou mais features completas e testadas.

3. **A cada sprint**: Testar antes de avançar (test-first mindset)

4. **Checklist de segurança obrigatório antes de qualquer deploy:**
   - [ ] Segredos e chaves de API em variáveis de ambiente (nunca hardcoded)
   - [ ] Escopos de API mínimos (princípio do menor privilégio)
   - [ ] Rate limiting em endpoints públicos
   - [ ] Logs sem dados sensíveis (PII, senhas, tokens)
   - [ ] Revisão de prompt do agente (injeção de prompt, vazamento de contexto)
   - [ ] Headers de segurança (CORS, CSP, HSTS)
   - [ ] Validação de input em todas as entradas do usuário
   - [ ] Row Level Security (RLS) ativado se Supabase

5. **PRD (Product Reference Document)**: Gerar documento que descreve o que foi construído, decisões técnicas, e guia de uso para o agente AI.

**Outputs:**
- Código do MVP funcional no diretório do projeto
- `docs/checklist-seguranca.md` — checklist assinado
- `docs/prd.md` — Product Reference Document

**Exit Criteria:**
- [ ] Checklist de segurança 100% aprovado
- [ ] Fluxo principal funciona end-to-end
- [ ] Tratamento de erros básico implementado (não quebra em input inesperado)
- [ ] PRD gerado e commitado

---

### Etapa 7 — Lançamento & PDCA

**Input:** MVP funcional + Documento Padrão + PRD.

**Processo:**

1. **Deploy**: Publicar em ambiente de produção (Vercel, Railway, Render)
2. **Hipóteses documentadas**: O que esperamos que aconteça?
3. **Métricas**: Coletar dados reais — comparar com alvos definidos na Etapa 1
4. **Feedback loop**: Entrevistar 5 primeiros usuários
5. **Ciclo PDCA (Plan-Do-Check-Act)**:
   - **Plan**: O que melhorar baseado nos dados?
   - **Do**: Implementar mudança
   - **Check**: A métrica melhorou?
   - **Act**: Decidir: pivotar, perseverar ou escalar?

**Outputs:**
- MVP em produção (URL pública)
- Relatório pós-lançamento com métricas coletadas
- Próximos 3 passos priorizados

**Exit Criteria:**
- [ ] URL de produção pública e acessível
- [ ] Mínimo 5 usuários reais usando
- [ ] Métricas coletadas vs. alvos da Etapa 1
- [ ] Próximo ciclo PDCA planejado
- [ ] Decisão: Pivot / Persevere / Scale documentada

---

## 📦 Output Contract

| Artefato | Etapa | Formato | Restartável? |
|----------|-------|---------|:---:|
| `docs/documento-padrao.md` | 1→7 | Markdown | ✅ |
| `docs/decision-log.md` | 1→7 | Markdown | ✅ |
| Código do MVP | 6 | Projeto | ✅ |
|| `features/<feature>/feature.md` | 6 | Feature spec autocontida | ✅ |
|| `docs/context/global/` | 6 | Contexto compartilhado (stack, schema, regras) | ✅ |
| `docs/checklist-seguranca.md` | 6 | Markdown | ✅ |
| `docs/prd.md` | 6 | Markdown | ✅ |
| URL de produção | 7 | URL | ❌ |

---

## 🛡️ Safety Boundaries

1. **Código não-confiável**: Todo código gerado por IA (Vibe Coding) DEVE passar pelo checklist de segurança (Etapa 6) antes de ir para produção.
2. **Segredos**: AGENTE NUNCA deve hardcodar chaves de API, tokens ou senhas. Sempre usar variáveis de ambiente.
3. **OWASP LCNC Top 10**: Aplicar validação de input, rate limiting e RLS. Verificar injeção de prompt em agentes.
4. **Dados sensíveis**: Logs nunca devem conter PII, tokens de autenticação ou conteúdo de mensagens privadas.
5. **LGPD (Lei Geral de Proteção de Dados)**: Se o projeto atende usuários brasileiros, DEVE:
   - Coletar consentimento explícito para armazenamento de dados
   - Permitir que o usuário solicite exclusão dos seus dados ("direito ao esquecimento")
   - Não armazenar dados sensíveis (saúde, religião, política) sem base legal específica (art. 11 LGPD)
   - Ter Política de Privacidade publicada antes do lançamento
6. **Deploy**: Só liberar após checklist de segurança 100% verde (Etapa 6).
7. **Custo**: Monitorar custos de API LLM desde o início. Evitar loops infinitos em agents. Preferir free tiers. Configurar hard cap mensal de gastos.
8. **Rollback**: Antes de qualquer deploy, garantir que rollback é possível (git tag + deploy anterior funcionando).
9. **Context Budget**: Features são avaliadas por heurísticas de complexidade (número de arquivos/telas, passos de fluxo). Limites: > 7 arquivos/telas ou > 15 passos exige decomposição. Cada diretório de feature DEVE ser autocontido (único `feature.md` + contexto global em `docs/context/global/`). Projetos com ≤ 5 features podem pular esta etapa. Uma revisão de consistência pós-desenvolvimento verifica conflitos entre features.

---

## 🔐 Safety Checklist (Etapa 6 — expandido)

> O AGENTE DEVE executar este checklist antes de qualquer comando de deploy.

```
[ ] 1. Variáveis de ambiente: todas as chaves em .env.local / secrets, zero hardcode
[ ] 2. Escopos de API: permissões mínimas (ex: Stripe só cobrar, Supabase só CRUD necessário)
[ ] 3. Rate limiting: endpoints públicos têm limite (ex: 10 req/min para não-autenticados)
[ ] 4. Logs seguros: sem PII, senhas, tokens, headers de autenticação
[ ] 5. Prompt segurança: instruções do agente não vazam contexto, não executam comandos não-solicitados
[ ] 6. Headers HTTP: CORS configurado, CSP ativo, HSTS habilitado
[ ] 7. Validação de input: todo input do usuário validado (tipo, tamanho, formato)
[ ] 8. RLS/Policies: Supabase RLS ativo, policies testadas com usuario anon vs. autenticado
[ ] 9. Dependências: sem versões com CVEs conhecidos (npm audit, pip audit)
[ ] 10. Rollback: git tag criada, deploy anterior disponível
[ ] 11. LGPD: consentimento explícito implementado, política de privacidade publicada, direito de exclusão funcional
[ ] 12. Teste de alucinação: agente testado com 10 entradas inesperadas — responde adequadamente ou admite não saber?
[ ] 13. Teste de tom e resiliência: agente mantém tom profissional mesmo quando usuário é rude ou insiste no impossível?
[ ] 14. Fallback offline: se API do LLM cair, o sistema avisa o usuário em linguagem natural e encaminha para humano sem quebrar?
```

---

## 📝 Decision Log Template

```markdown
# Decision Log — [Nome do Projeto]

## [YYYY-MM-DD] — [Decisão]
- **Contexto**: Por que precisávamos decidir?
- **Opções consideradas**: A, B, C (com prós e contras)
- **Decisão**: Escolhemos A porque...
- **Consequências**: O que esperamos que aconteça?
- **Revisado em**: [data para reavaliar]
```

O AGENTE DEVE adicionar uma entrada ao Decision Log sempre que uma decisão arquitetural ou de produto for tomada.

---

## ⚠️ Common Failure Modes

| Modo de Falha | Sintoma | Correção |
|---------------|---------|----------|
| Founder quer pular Etapa 2 | MVP sem diferencial competitivo | Voltar para Etapa 2 |
| Founder não valida com usuários | MVP que ninguém quer | Entrevistar 5 usuários antes de codificar |
| Escopo cresce (scope creep) | MVP vira monstrengo | Revisar Etapa 1, cortar para V2 |
| Checklist de segurança ignorado | Dados expostos em produção | Bloquear deploy até checklist 100% |
| LGPD ignorada | Multa, processo judicial, bloqueio da ANPD | Implementar consentimento e política de privacidade |
| Founder não documenta decisões | Perde contexto entre sprints | Usar Decision Log obrigatório |
| Código gerado por IA sem revisão | Vulnerabilidades, lógica incorreta | Aplicar checklist antes de merge |
| Métricas não definidas na Etapa 1 | "Parece que não funcionou" — sem dados | Voltar para Etapa 1, definir métrica |
| Custo de LLM não estimado | Surpresa na fatura do primeiro mês | Pesquisar preços na Etapa 4 e configurar hard cap |
| Deploy sem rollback | Se quebrar, não tem volta | git tag + testar rollback antes |
| Feature estoura contexto | LLM perde o foco, código com bugs, retrabalho | Decompor em sub-features usando heurísticas (> 7 arquivos ou > 15 passos) |

---

## ✅ Success Criteria

A skill cumpriu seu propósito quando:

1. Documento Padrão completo com 7 seções
2. Decision Log com entradas para cada etapa
3. Checklist de segurança 100% verde
4. MVP funcional em produção
5. Mínimo 5 usuários usando
6. Próximo ciclo PDCA planejado
7. Founder sabe replicar o processo sozinho

---

## 📚 References

| Recurso | Link |
|---------|------|
| NoCode StartUp AI (Matheus Castelo) | Site + Blog + YouTube |
| OWASP Low-Code/No-Code Top 10 | owasp.org |
| Google 16 Factor App | cloud.google.com |
| Thoughtworks Technology Radar 2026 | thoughtworks.com |
| OpenAI Production Best Practices | platform.openai.com |

---

## 🚫 Limitations

- **Não substitui CTO técnico**: Decisões de arquitetura complexas podem precisar de revisão de um engenheiro sênior.
- **Não gera código sozinha**: A skill orquestra o processo; o código é gerado pelo Vibe Coding (Claude Code, Cursor, etc.).
- **MVP não é produção**: O MVP gerado é funcional mas pode não atender a requisitos de escala, conformidade ou segurança enterprise.
- **Depende do founder**: O processo só funciona se o founder responder às perguntas e seguir as etapas. Pular etapas quebra o framework.
- **Orçamento zero não é sempre possível**: Algumas integrações podem exigir planos pagos.
- **Notion original não acessível**: Este framework foi reconstruído de fontes secundárias (blog, YouTube, LinkedIn). Pode haver diferenças do original.

---

## 📋 When to Use (resumo)

```
Usar quando:
- Founder não-técnico com ideia de startup
- Quer MVP funcional em 4-8 semanas
- Vai usar Vibe Coding (IA para gerar código)
- Precisa de processo estruturado e documentado
- Orçamento limitado (idealmente $0/mês)

NÃO usar quando:
- Já tem codebase estabelecida
- Precisa de código regulado (saúde, aviação, fintech)
- Founder não quer seguir processo
- Projeto enterprise multi-time
- Só precisa de ajuste/feature em projeto existente
```
