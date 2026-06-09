# Template para Checklist de Conclusão de Tarefas

Use este template para gerar a seção **Checklist de conclusão** de cada tarefa no backlog. Ele padroniza os itens obrigatórios e permite adicionar verificações específicas por tipo de tarefa.

---

## Estrutura base (obrigatória para todas as tarefas)

```markdown
- [ ] Código implementado conforme assinatura/contrato especificado
- [ ] Testes BDD implementados (conforme cenários Gherkin) e passam
- [ ] Tratamento de erros implementado (entradas inválidas, exceções, timeouts)
- [ ] Logs estruturados adicionados nos pontos principais (info, erro, warning)
- [ ] Idempotência verificada (se aplicável – webhooks ou endpoints state-changing)
- [ ] Nenhum segredo hardcoded (chaves API, senhas, tokens, certificados)
- [ ] Documentação adicionada (docstring, comentários, ou README relevante)
- [ ] Assinatura da IA programadora (ou hash do contexto) registrada no arquivo .signature
```

---

## Itens adicionais por tipo de tarefa

### Tarefas de Banco de Dados (DB)

Acrescentar após os itens obrigatórios:

```markdown
- [ ] Script SQL é idempotente (IF NOT EXISTS, OR REPLACE, ou controle de versão de migração)
- [ ] Índices criados para colunas de busca frequente
- [ ] Row Level Security (RLS) configurada (se aplicável, conforme Skill 3)
- [ ] Migração testada em ambiente vazio e com dados existentes (rollback funcional, se especificado)
- [ ] Comentários adicionados nas tabelas/colunas (ex: `COMMENT ON COLUMN ...`)
```

### Tarefas de Backend – Função Pura (BACK)

```markdown
- [ ] Type hints (ou equivalente em linguagem) para todos os parâmetros e retorno
- [ ] Testes unitários cobrem todos os cenários BDD (mínimo 3)
- [ ] Função não causa efeitos colaterais (não escreve em disco, não chama rede) – ou documenta dependências
- [ ] Validação de entradas com mensagens de erro claras
- [ ] Comportamento determinístico (dada mesma entrada, mesma saída)
```

### Tarefas de Backend – API Endpoint (BACK)

```markdown
- [ ] OpenAPI/Swagger atualizado com o novo endpoint (se houver doc automática)
- [ ] Validação de payload com schema (Pydantic, Marshmallow, etc.)
- [ ] Códigos de status HTTP apropriados (201 para criação, 200 para sucesso, 4xx para erro cliente)
- [ ] Cabeçalhos de segurança (CORS, Content-Type, etc.) configurados
- [ ] Rate limiting (se aplicável) implementado conforme restrições da Skill 2
- [ ] Teste de integração (chamada HTTP real) passa
```

### Tarefas de Backend – Worker / Fila (BACK)

```markdown
- [ ] Worker reconecta automaticamente ao broker (Redis/RabbitMQ) em caso de queda
- [ ] Tarefa é idempotente (mesmo se processada múltiplas vezes, sem efeito colateral duplicado)
- [ ] Timeout configurado para tarefas lentas (evita worker travado)
- [ ] Retry com backoff exponencial para tarefas falhas
- [ ] Logs incluem `task_id` e `attempt` para rastreamento
- [ ] Dead letter queue configurada (ou equivalente para falhas irremediáveis)
```

### Tarefas de Agente Conversacional (AGENT)

```markdown
- [ ] Prompt do sistema (persona) definido em arquivo de configuração ou constante
- [ ] Ferramentas (tools) têm descrição clara e schema JSON (se for function calling)
- [ ] Memória de curto prazo (histórico da conversa) mantém últimos N turnos (N definido)
- [ ] Guardrails de entrada aplicados antes de enviar prompt ao LLM
- [ ] Temperatura e outros parâmetros de geração definidos e justificados
- [ ] RAG (se aplicável): índice da base de conhecimento testado com consultas exemplo
```

### Tarefas de Frontend (FRONT)

```markdown
- [ ] Componente renderiza sem erros no navegador
- [ ] Estados de loading e erro tratados e exibidos
- [ ] Acessibilidade básica (labels, aria, navegação por teclado)
- [ ] Responsividade testada em pelo menos 2 tamanhos de tela
- [ ] Integração com API funciona (mock ou real) e trata erros de rede
- [ ] Testes unitários (Jest/Vitest) para lógica principal
```

### Tarefas de Infraestrutura (INFRA)

```markdown
- [ ] Dockerfile (ou equivalente) produz imagem com tamanho otimizado (multistage, se aplicável)
- [ ] Instruções de execução documentadas (docker-compose ou comando)
- [ ] Healthcheck implementado e configurado
- [ ] Variáveis de ambiente sensíveis não estão hardcoded no Dockerfile
- [ ] Container roda com usuário não-root (menos privilégios)
- [ ] Teste de subida local (docker run) passa sem erros
```

### Tarefas de Testes (TEST)

```markdown
- [ ] Suite de testes cobre todos os cenários BDD listados para as tarefas relacionadas
- [ ] Testes são independentes (não compartilham estado mutável)
- [ ] Fixtures de banco de dados ou mocks isolados
- [ ] Testes rodam em CI (ou pelo menos localmente) em menos de 30 segundos
- [ ] Relatório de cobertura gerado (se aplicável) com mínima de 80% para as funções testadas
```

---

## Exemplo de checklist completo (tarefa BACK – endpoint)

```markdown
- [ ] Código implementado conforme assinatura/contrato especificado
- [ ] Testes BDD implementados (conforme cenários Gherkin) e passam
- [ ] Tratamento de erros implementado (entradas inválidas, exceções, timeouts)
- [ ] Logs estruturados adicionados nos pontos principais (info, erro, warning)
- [ ] Idempotência verificada (se aplicável – webhooks ou endpoints state-changing)
- [ ] Nenhum segredo hardcoded (chaves API, senhas, tokens, certificados)
- [ ] Documentação adicionada (docstring, comentários, ou README relevante)
- [ ] Assinatura da IA programadora (ou hash do contexto) registrada no arquivo .signature
- [ ] OpenAPI/Swagger atualizado com o novo endpoint
- [ ] Validação de payload com schema (Pydantic)
- [ ] Códigos de status HTTP apropriados (201, 400, 409, etc.)
- [ ] Cabeçalhos de segurança configurados
- [ ] Teste de integração (chamada HTTP real) passa
```

---

## Instruções para a Skill 4

1. **Sempre inclua os 8 itens obrigatórios** (primeiro bloco) para qualquer tarefa.
2. **Adicione os itens específicos** baseado no tipo da tarefa (DB, BACK, AGENT, FRONT, INFRA, TEST).
3. Se uma tarefa for mista (ex: endpoint que também configura um worker?), **quebre em duas tarefas** em vez de criar checklist híbrido.
4. Para tarefas simples (ex: função de validação sem I/O), os itens específicos podem ser omitidos, mas os obrigatórios permanecem.
5. Ao final do checklist, opcionalmente adicione um campo para **observações do implementador** (ex: "necessário configurar variável X no ambiente de produção").

> Este template é uma referência. A Skill 4 deve adaptar os itens específicos conforme a stack (ex: para Node.js, mencionar `Joi` em vez de `Pydantic`). O princípio é sempre garantir rastreabilidade, qualidade e segurança.