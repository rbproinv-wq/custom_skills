# Checklist de Conformidade Legal

Use este checklist durante a etapa **2.2 Legal & Compliance Constraints** da Skill 2 (Domain Researcher). Ele ajuda a identificar as principais obrigações legais aplicáveis a projetos de software, priorizando as leis de proteção de dados e normas setoriais.

---

## Como usar

1. Identifique o **setor/domínio** do projeto (saúde, finanças, educação, varejo, etc.).
2. Identifique as **jurisdições** dos usuários (Brasil, Europa, EUA, etc.) – se não informado, assuma Brasil.
3. Para cada lei relevante, verifique se as exigências se aplicam ao escopo do MVP.
4. Registre a(s) fonte(s) oficial(is) e a(s) exigência(s) concreta(s).
5. Classifique o impacto: **bloqueador** (impede MVP sem mudança significativa), **mitigável** (exige ajuste de design), ou **baixo** (apenas documentação).

---

## Camada 1 – Proteção de Dados (geral)

### LGPD (Lei Geral de Proteção de Dados – Brasil, Lei 13.709/2018)

| Exigência | Descrição | Impacto típico | Verificado? |
|-----------|-----------|----------------|--------------|
| Base legal para tratamento | Todo dado pessoal deve ter uma base legal (consentimento, legítimo interesse, execução de contrato etc.) | Consentimento explícito para dados sensíveis (saúde, biometria) | [ ] |
| Direito do titular | Acesso, correção, eliminação, portabilidade, informação | Implementar canais para atender pedidos (ex: e-mail, formulário) | [ ] |
| Relatório de impacto | Obrigatório para dados sensíveis em larga escala | Pode ser exigido; recomendar consultoria | [ ] |
| Notificação de violação | Comunicar ANPD e titulares em até 48h em caso de vazamento | Exige logging, detecção e resposta rápida | [ ] |
| Política de privacidade | Documento claro sobre coleta, uso, compartilhamento | Deve estar acessível antes da coleta | [ ] |

### GDPR (General Data Protection Regulation – Europa)

*Semelhante à LGPD, com diferenças:*
- Direito à portabilidade mais forte.
- Data Protection Officer (DPO) obrigatório em certos casos.
- Fronteiras: transferência internacional exige cláusulas padrão.

### CCPA (California Consumer Privacy Act – EUA)

*Foco em opt-out de venda de dados, direito a saber e deletar.*

---

## Camada 2 – Setores regulados

### Saúde (clínicas, hospitais, planos de saúde)

| Norma | Exigência | Impacto |
|-------|-----------|---------|
| **HIPAA** (EUA – se aplicável) | Proteção de informações médicas (PHI); segurança técnica, física, administrativa | Requer criptografia, trilha de auditoria, controles de acesso rigorosos |
| **ANVISA** (Brasil – registro de software para diagnóstico) | Se o software for classificado como dispositivo médico (ex: auxiliar em diagnóstico) | Registro pode levar meses; consultar especialista |
| **CFM Resolução** (Conselho Federal de Medicina) | Regras para telemedicina e prontuário eletrônico | Armazenamento mínimo de 20 anos, interoperabilidade |

### Finanças (pagamentos, investimentos, crédito)

| Norma | Exigência | Impacto |
|-------|-----------|---------|
| **PCI-DSS** (processamento de cartões) | Armazenamento seguro de dados de cartão; não armazenar CVV; criptografia | Se o sistema manipular cartão diretamente, exigências rigorosas |
| **BACEN / Banco Central** | Dependendo da atividade (ex: instituição de pagamento) | Autorização prévia, capital mínimo, compliance |
| **Lei Geral do Cadastro Positivo** | Compartilhamento de histórico de crédito | Consentimento específico, regras de acesso |

### Educação (cursos, gestão escolar)

| Norma | Exigência | Impacto |
|-------|-----------|---------|
| **FERPA** (EUA) | Privacidade de registros educacionais | Consentimento para compartilhamento |
| **LDB (Brasil)** | Registro de frequência, notas, diplomas | Integridade e retenção de dados por longo prazo |

### Comércio eletrônico / varejo

| Norma | Exigência | Impacto |
|-------|-----------|---------|
| **CDC (Código de Defesa do Consumidor)** | Direito de arrependimento (7 dias), informação clara | Fluxos de cancelamento e reembolso |
| **Lei do Marco Civil da Internet** | Logs de acesso por 6 meses, neutralidade | Armazenar logs de forma segura |

---

## Camada 3 – Obrigações específicas de plataformas (ex: WhatsApp, Google)

| Plataforma | Exigência legal/política | Impacto |
|------------|--------------------------|---------|
| **Meta (WhatsApp API)** | Proibido enviar mensagens não solicitadas em massa; templates de notificação exigem aprovação | MVP pode precisar de aprovação prévia |
| **Google Calendar API** | Conformidade com política de uso: não armazenar credenciais em texto, renovar tokens | Requer OAuth seguro |
| **OpenAI API** | Política de uso proíbe gerar conteúdo ilegal, assédio; retenção de dados por 30 dias | Logging limitado, evitar dados sensíveis em prompts |

---

## Como registrar no dossiê (seção 5.3)

Para cada exigência identificada, registre no formato:

> **Norma:** [Nome da lei/norma]  
> **Exigência concreta:** [o que a lei especificamente requer]  
> **Impacto no projeto:** [bloqueador / mitigável / baixo] – [descrição breve]  
> **Referência:** [URL ou documento]  

**Exemplo (LGPD para dados de saúde):**
> **Norma:** LGPD, Art. 11 – Tratamento de dados sensíveis  
> **Exigência concreta:** Consentimento explícito e destacado do titular para coleta e uso de dados sobre saúde.  
> **Impacto:** Mitigável – Incluir mensagem de consentimento no primeiro contato do WhatsApp.  
> **Referência:** https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709.htm

---

## Nota final

Este checklist **não substitui parecer jurídico**. Para projetos com alto risco regulatório (saúde, finanças, dados de crianças), recomenda-se consultoria especializada. A skill deve sinalizar isso nos riscos identificados.