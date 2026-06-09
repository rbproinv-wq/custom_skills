# Template para Definição de Tarefas (Backlog Atômico)

Use este template ao gerar cada tarefa na seção **5.3. Lista de tarefas** da Skill 4. Ele garante consistência e completude.

---

## Estrutura da tarefa

```markdown
#### Tarefa [TIPO-NNN] – [Título curto]

- **Tipo:** (DB | BACK | FRONT | AGENT | TEST | INFRA)
- **Descrição:** (2-3 frases do que deve ser implementado, sem ambiguidade)
- **Arquivos esperados:**
  - `caminho/para/arquivo1.ext`
  - `caminho/para/arquivo2.ext`
- **Assinatura/Contrato:**
  - Para BACK: `def nome_funcao(param: Tipo) -> TipoRetorno`
  - Para API: `POST /endpoint` + schema
  - Para DB: `CREATE TABLE nome (...)`
- **Dependências:** (lista de IDs de tarefas, ou "Nenhuma")
- **Testes BDD (Gherkin):**
  ```gherkin
  Cenário: Nome do cenário 1 (happy path)
    Dado que <pré-condição>
    Quando <ação>
    Então <resultado esperado>
    E <outro resultado>

  Cenário: Nome do cenário 2 (erro)
    Dado que <pré-condição inválida>
    Quando <ação>
    Então <código de erro ou exceção>

  Cenário: Nome do cenário 3 (edge case)
    Dado que <condição de borda>
    Quando <ação>
    Então <comportamento esperado>
  ```
- **Checklist de conclusão:**
  - [ ] Código implementado conforme assinatura/contrato
  - [ ] Testes BDD implementados e passam
  - [ ] Tratamento de erros implementado (entradas inválidas, exceções)
  - [ ] Logs estruturados adicionados (info, erro, warning)
  - [ ] Idempotência verificada (se aplicável – consultar Skill 3)
  - [ ] Nenhum segredo hardcoded
  - [ ] Documentação (docstring/comentários) adicionada
  - [ ] Assinatura da IA programadora registrada
- **Contexto adicional:** (referências a seções da Skill 3, ADRs, diagramas)
```

---

## Exemplo preenchido (para sistema de agendamento)

```markdown
#### Tarefa BACK-002 – Implementar endpoint POST /agendar

- **Tipo:** BACK
- **Descrição:** Criar rota FastAPI que recebe JSON com dados de agendamento, chama a função `agendar_consulta` (da tarefa BACK-001) e retorna o ID da consulta criada. Deve validar o payload com Pydantic.
- **Arquivos esperados:**
  - `src/api/routes/agendamento.py`
  - `src/api/schemas/agendamento.py`
- **Assinatura/Contrato:**
  - `POST /agendar`
  - Request: `{ "paciente_id": "uuid", "data_hora": "iso8601", "especialidade": "string" }`
  - Response (201): `{ "consulta_id": "uuid", "status": "agendado" }`
  - Response (400): `{ "error": "validation_error", "details": [...] }`
- **Dependências:** BACK-001 (função `agendar_consulta`), DB-001 (tabela `consultas`)
- **Testes BDD (Gherkin):**
  ```gherkin
  Cenário: Agendamento válido
    Dado que a tabela consultas está vazia
    E o paciente com ID "123e4567-e89b-12d3-a456-426614174000" existe
    Quando envio uma requisição POST para /agendar com dados válidos
    Então o status code é 201
    E o corpo JSON contém "consulta_id" e status "agendado"

  Cenário: Dados inválidos (data passada)
    Dado que a data enviada é "2020-01-01T10:00:00Z"
    Quando envio a requisição
    Então o status code é 400
    E o erro contém "data inválida"

  Cenário: Horário já ocupado (conflito)
    Dado que já existe uma consulta para o mesmo paciente no mesmo horário
    Quando envio a requisição com mesmo horário
    Então o status code é 409
    E a mensagem indica "conflito de horário"
  ```
- **Checklist de conclusão:**
  - [ ] Código implementado conforme assinatura/contrato
  - [ ] Testes BDD implementados e passam
  - [ ] Tratamento de erros implementado (validação Pydantic, conflito, exceções)
  - [ ] Logs estruturados adicionados (info quando sucesso, warning quando conflito)
  - [ ] Idempotência verificada (se webhook, mas este endpoint não requer; adicionar se houver Idempotency-Key)
  - [ ] Nenhum segredo hardcoded
  - [ ] Documentação (docstring da rota) adicionada
  - [ ] Assinatura da IA programadora registrada
- **Contexto adicional:** Ver OpenAPI definido na Skill 3, seção 5.5. Endpoint deve retornar 201 e não 200.
```

---

## Regras de preenchimento

| Campo | Regra |
|-------|-------|
| **ID** | Deve seguir padrão `TIPO-NNN`, onde TIPO é uma das siglas (DB, BACK, FRONT, AGENT, TEST, INFRA) e NNN é numeração sequencial global ou por tipo. |
| **Descrição** | Máximo 500 caracteres. Usar linguagem imperativa ("Criar", "Implementar", "Adicionar"). |
| **Arquivos esperados** | Incluir caminhos completos a partir da raiz do projeto (ex: `src/domain/...`). Se a tarefa não criar arquivo (ex: alterar configuração), escrever "N/A". |
| **Assinatura** | Para funções, usar type hints (Python) ou pseudo-código. Para endpoints, especificar método, caminho e schemas. Para SQL, fornecer o comando principal. |
| **Dependências** | Listar apenas IDs de tarefas. Para dependências externas (ex: API do WhatsApp), escrever "Nenhuma (mas requer credenciais da API X)". |
| **Testes BDD** | No mínimo 3 cenários. Usar `Dado que` / `Quando` / `Então` / `E`. Evitar jargão de implementação (ex: "mock the database"). |
| **Checklist** | Itens obrigatórios devem ser mantidos. Itens adicionais podem ser acrescentados após os obrigatórios. |
| **Contexto** | Referenciar seções do documento da Skill 3 (ex: "ver DER item X", "ADR 002", "diagrama C4 nível 3"). |

> Este template é um guia. A Skill 4 deve adaptar os exemplos ao projeto específico, mas manter a estrutura para que outras LLMs possam parsear facilmente.