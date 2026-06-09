# Roteiro de Pesquisa para Políticas de API

Use este roteiro durante a etapa **2.3 API & Platform Policies** da Skill 2 (Domain Researcher). Ele organiza as perguntas essenciais que a skill deve responder para cada API ou plataforma externa mencionada no PRD.

---

## Para cada API, responda as perguntas abaixo

### Informações básicas
1. **Nome oficial da API** (ex: WhatsApp Cloud API, OpenAI Chat Completions API, Google Calendar API v3)
2. **Documentação oficial (URL)** – localizar a página de referência principal
3. **Provedor/empresa** (Meta, OpenAI, Google, Stripe, etc.)

### Restrições de uso
4. **Rate limits** – por segundo / minuto / dia? Por IP, por token, por número de telefone?  
   *Exemplo: WhatsApp: 80 mensagens/segundo por número de telefone*
5. **Limites de quota** – mensagens/dia, requisições/mês, tokens/mês?  
   *Exemplo: OpenAI: 10.000 tokens/minuto para tier 1*
6. **Concorrência / assíncrono** – permite chamadas concorrentes? Há filas?

### Custos
7. **Modelo de preços** – grátis, freemium, pago por uso, assinatura?  
8. **Preço unitário** – por requisição, por mensagem, por token, por usuário ativo?  
   *Exemplo: WhatsApp: custo por conversa (sessão de 24h) a partir de US$ 0,005*
9. **Tiers gratuitos** – existe quota gratuita? (ex: OpenAI US$ 5 de crédito inicial)
10. **Custos extras** – armazenamento, transferência de dados, webhooks?

### Autenticação e segurança
11. **Método de autenticação** – API key, OAuth2, JWT, mTLS?
12. **Requisitos de segurança** – HTTPS obrigatório? Webhooks exigem verificação de assinatura?
13. **Armazenamento de credenciais** – política sobre onde e como armazenar chaves?

### Automação e comportamento permitido
14. **Mensagens proativas** – O serviço permite envio de mensagens sem interação do usuário?  
    *Exemplo WhatsApp: permitido apenas com template aprovado e dentro de 24h?*
15. **Limitações de conteúdo** – O que é proibido? (ex: marketing não solicitado, dados de saúde em prompts da OpenAI)
16. **Cadência / spam** – Há limites para evitar spam? (ex: não enviar mais de X mensagens para o mesmo usuário por dia)
17. **Webhooks** – Permite callbacks? Há retry policy? Timeout?

### Privacidade e conformidade
18. **Retenção de dados** – Quanto tempo a API guarda logs/requisições?  
    *Exemplo OpenAI: 30 dias para análise de abuso*
19. **Exclusão de dados** – É possível solicitar exclusão de dados enviados para a API?
20. **Localização de dados** – Os dados são processados em que regiões? (ex: OpenAI só EUA)

### Disponibilidade e suporte
21. **SLA / disponibilidade** – Existe garantia de uptime? (ex: 99,9%)
22. **Suporte a incidentes** – O provedor oferece status page? Canal de comunicação?
23. **Versões e deprecação** – Ciclo de vida: com que frequência a API muda? Aviso prévio de descontinuação?

### Aprovação / onboarding
24. **Processo de ativação** – Imediato? Requer verificação de negócio? (ex: WhatsApp exige Business Verification)
25. **Templates / pré-aprovação** – A API exige aprovação humana para certos tipos de mensagem?  
    *Exemplo WhatsApp: templates de notificação precisam ser aprovados (1–48h)*

---

## O que fazer se a informação não for encontrada

| Situação | Ação |
|----------|------|
| Documentação oficial não tem rate limit explícito | Procurar em blogs técnicos, fóruns (Stack Overflow), ou repositórios de clientes da API. Se ainda assim não encontrar, marcar como **"lacuna"** e perguntar ao usuário. |
| Preços não são públicos | Registrar "não público" e sugerir contato comercial. |
| Política de automação ambígua | Citar a ambiguidade e marcar como risco. |
| API obsoleta (última atualização >2 anos) | Alertar que a informação pode estar desatualizada e sugerir verificação pelo usuário. |

---

## Exemplo preenchido – WhatsApp Cloud API

| Pergunta | Resposta | Fonte |
|----------|----------|-------|
| Nome oficial | WhatsApp Cloud API | developers.facebook.com |
| Rate limits | 80 mensagens/segundo por número de telefone | Meta docs |
| Preços | US$ 0,005 por conversa (24h) | Meta pricing |
| Autenticação | Token de acesso permanente via Facebook App | docs |
| Mensagens proativas | Permitido apenas templates aprovados, dentro de 24h do último contato | WhatsApp Business Policy |
| Retenção de dados | Logs de mensagens retidos por 30 dias | Privacy policy |
| Onboarding | Requer conta verificada no Business Manager (pode levar dias) | Help center |

> Este roteiro é um **guia de coleta** para uso interno da skill. Os dados consolidados devem ser reportados na seção **5.4 API & Platform Restrictions** do dossiê final, em formato de lista ou tabela.