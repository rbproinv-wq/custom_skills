# Checklist de Segurança Pré-Deploy

> Projeto: [Nome]
> Data: [YYYY-MM-DD]
> Responsável: [Nome]

## Instruções
Cada item DEVE ser verificado antes de qualquer deploy em produção.
Itens não aprovados BLOQUEIAM o deploy.

---

### 🔐 1. Variáveis de Ambiente
- [ ] Todas as chaves de API estão em `.env.local` ou secrets do provedor
- [ ] Nenhum token/secret hardcoded no código fonte
- [ ] `.env.example` commitado (sem valores reais)

### 🔐 2. Escopos de API
- [ ] Permissões de API são mínimas (princípio do menor privilégio)
- [ ] Tokens de serviço têm escopo limitado por recurso
- [ ] Chaves de API de terceiros têm restrição de origem/IP

### 🔐 3. Rate Limiting
- [ ] Endpoints públicos têm limite de requisições
- [ ] Endpoints de autenticação têm proteção contra brute force
- [ ] Webhooks têm verificação de assinatura

### 🔐 4. Logs Seguros
- [ ] Logs não contêm PII (nome, email, telefone, CPF)
- [ ] Logs não contêm tokens, senhas ou headers de autenticação
- [ ] Logs não contêm conteúdo de mensagens privadas

### 🔐 5. Segurança do Prompt do Agente
- [ ] Instruções do agente não vazam contexto do sistema
- [ ] Agente não executa comandos não-solicitados pelo usuário
- [ ] Input do usuário é sanitizado antes de ir para o prompt do LLM

### 🔐 6. Headers HTTP
- [ ] CORS configurado (origens específicas, não `*`)
- [ ] Content-Security-Policy ativo
- [ ] HSTS habilitado
- [ ] X-Content-Type-Options: nosniff

### 🔐 7. Validação de Input
- [ ] Todo input de usuário validado (tipo, tamanho, formato)
- [ ] SQL injection prevenido (ORM parametrizado ou queries escape)
- [ ] XSS prevenido (output sanitizado)

### 🔐 8. Row Level Security (Supabase)
- [ ] RLS ativado em todas as tabelas
- [ ] Policies testadas: usuário anônimo vs. autenticado
- [ ] Policies de SELECT restritas ao próprio usuário

### 🔐 9. Dependências
- [ ] Nenhuma dependência com CVE conhecido (rodar `npm audit`)
- [ ] Dependências de desenvolvimento separadas das de produção

### 🔐 10. Rollback
- [ ] Git tag criada para versão atual
- [ ] Deploy anterior ainda disponível
- [ ] Script de rollback testado

### 🔐 11. LGPD (Lei Geral de Proteção de Dados)
- [ ] Usuário fornece consentimento explícito antes de qualquer coleta de dados
- [ ] Política de privacidade publicada e acessível (explica quais dados coletados, finalidade, armazenamento)
- [ ] Funcionalidade de exclusão de dados implementada (usuário pode apagar seus dados)

### 🔐 12. Teste de Alucinação do Agente
- [ ] Agente testado com 10+ entradas inesperadas/ambíguas para verificar se inventa respostas
- [ ] Quando não sabe a resposta, agente admite ("não sei") em vez de inventar
- [ ] Fontes/contexto fornecidas ao agente são verificáveis — ele não cria dados falsos

### 🔐 13. Teste de Tom e Resiliência
- [ ] Agente mantém tom profissional e respeitoso mesmo quando usuário é rude ou insistente
- [ ] Agente não pode ser "convencido" a ignorar suas regras de segurança (prompt injection testado)
- [ ] Em caso de tentativa de abuso, agente redireciona educadamente ou encerra a conversa

### 🔐 14. Fallback Offline (Indisponibilidade do LLM)
- [ ] Se API do LLM cair, agente exibe mensagem clara para o usuário ("serviço temporariamente indisponível")
- [ ] Fluxo de fallback encaminha para atendimento humano (email, WhatsApp, formulário de contato)
- [ ] Sistema não quebra totalmente — funcionalidades não-LLM continuam operando

---

## Resultado Final

- [ ] ✅ **APROVADO** — Todos os itens verificados, deploy liberado
- [ ] ❌ **BLOQUEADO** — Itens pendentes (listar abaixo):

### Itens Pendentes
1. [ ] Item pendente...

### Observações
[espaço para notas]
