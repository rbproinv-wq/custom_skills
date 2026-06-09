# Exemplos de Testes BDD (Gherkin) para Tarefas Comuns

Use estes exemplos como referência ao gerar os cenários de teste para cada tarefa na Skill 4. Adapte os nomes, entidades e condições conforme o projeto.

---

## 1. Tarefa de Banco de Dados (DB)

### Criar tabela

```gherkin
Cenário: Migração cria tabela corretamente
  Dado que o banco de dados está vazio
  Quando eu executo a migração "001_create_consultas.sql"
  Então a tabela "consultas" existe
  E a tabela tem as colunas: id, paciente_id, data_hora, status, created_at
  E o índice "idx_consultas_paciente_id" está criado
  E o índice "idx_consultas_data_hora" está criado

Cenário: Migração é idempotente
  Dado que a tabela "consultas" já existe
  Quando eu executo a migração novamente
  Então nenhum erro ocorre (IF NOT EXISTS)

Cenário: Row Level Security (RLS) está ativa
  Dado que a tabela "consultas" tem RLS habilitado
  Quando um usuário não autenticado tenta selecionar
  Então nenhuma linha é retornada
```

### Alterar tabela (adicionar coluna)

```gherkin
Cenário: Adicionar coluna com valor padrão
  Dado que a tabela "consultas" existe e tem dados
  Quando eu executo a migração "002_add_canal_origem.sql"
  Então a coluna "canal_origem" existe com valor padrão 'whatsapp'
  E os registros existentes têm 'whatsapp' como valor

Cenário: Rollback da migração (se aplicável)
  Dado que a migração "002" foi aplicada
  Quando eu executo o rollback
  Então a coluna "canal_origem" não existe mais
```

---

## 2. Tarefa de Backend – Função Pura

### Função de validação

```gherkin
Cenário: Validação de CPF válido
  Dado que o CPF "529.982.247-25" é fornecido
  Quando a função validar_cpf(cpf) é chamada
  Então o retorno é True

Cenário: CPF inválido (dígitos errados)
  Dado que o CPF "111.111.111-11" é fornecido
  Quando a função validar_cpf(cpf) é chamada
  Então uma exceção ValidationError é levantada
  E a mensagem contém "CPF inválido"

Cenário: CPF com formato errado (sem pontuação)
  Dado que o CPF "52998224725" é fornecido
  Quando a função validar_cpf(cpf) é chamada
  Então o retorno é True (função aceita apenas dígitos ou normaliza internamente)
```

### Função de negócio (agendamento)

```gherkin
Cenário: Agendamento bem-sucedido
  Dado que o paciente "João" tem ID "123e4567"
  E a tabela "consultas" está vazia
  E a data "2026-07-01T14:00:00Z" está disponível
  Quando a função agendar_consulta(paciente_id, data_hora, especialidade) é chamada
  Então uma nova consulta é inserida na tabela
  E o retorno é um dict com chave "consulta_id" e status "agendado"

Cenário: Horário já ocupado
  Dado que já existe uma consulta para o mesmo horário
  Quando a função tenta agendar outra consulta no mesmo horário
  Então uma exceção ConflictError é levantada
  E a mensagem contém "horário indisponível"

Cenário: Data no passado
  Dado que a data fornecida é "2020-01-01T10:00:00Z"
  Quando a função é chamada
  Então uma exceção ValidationError é levantada
  E a mensagem contém "data não pode ser no passado"
```

---

## 3. Tarefa de Backend – API Endpoint

### Endpoint POST (criação)

```gherkin
Cenário: Criar recurso com sucesso
  Dado que eu tenho um token JWT válido para o usuário "admin"
  E o payload JSON é { "nome": "Clinica Nova", "cnpj": "12.345.678/0001-99" }
  Quando eu envio uma requisição POST para /clinicas
  Então o status code é 201
  E o corpo da resposta contém "id" e "nome"
  E o cabeçalho Location aponta para /clinicas/{id}

Cenário: Dados inválidos (campos obrigatórios faltando)
  Dado que o payload JSON não contém "cnpj"
  Quando eu envio a requisição
  Então o status code é 400
  E o corpo contém "cnpj é obrigatório"

Cenário: Recurso duplicado (CNPJ já existe)
  Dado que já existe uma clínica com o CNPJ "12.345.678/0001-99"
  Quando eu envio a requisição com o mesmo CNPJ
  Então o status code é 409
  E a mensagem indica "conflito: CNPJ já cadastrado"
```

### Endpoint GET (listagem com filtros)

```gherkin
Cenário: Listar todos os recursos
  Dado que existem 5 consultas cadastradas
  Quando eu envio uma requisição GET para /consultas
  Então o status code é 200
  E o corpo é uma lista com 5 itens
  E cada item tem id, paciente_nome, data_hora

Cenário: Filtrar por paciente_id
  Dado que o paciente "456" tem 2 consultas
  Quando eu envio GET /consultas?paciente_id=456
  Então a lista retornada tem 2 itens
  E todos os itens têm paciente_id = "456"

Cenário: Nenhum resultado
  Dado que não há consultas para o paciente "999"
  Quando eu envio GET /consultas?paciente_id=999
  Então o status code é 200
  E a lista retornada está vazia
```

---

## 4. Tarefa de Agente Conversacional (AGENT)

### Ferramenta (tool) do agente

```gherkin
Cenário: Tool consultar_agenda retorna horários disponíveis
  Dado que o agente recebe o comando "Mostre horários livres para cardiologia amanhã"
  Quando a tool "consultar_agenda" é invocada com parâmetros { "especialidade": "cardiologia", "data": "2026-06-10" }
  Então a tool retorna uma lista de slots no formato JSON
  E cada slot contém "horario_inicio", "horario_fim", "medico"

Cenário: Tool consultar_agenda sem horários disponíveis
  Dado que não há horários livres para a data solicitada
  Quando a tool é invocada
  Então retorna {"disponivel": false, "mensagem": "Nenhum horário disponível na data selecionada"}

Cenário: Tool com parâmetros inválidos (data no passado)
  Dado que a data fornecida é "2020-01-01"
  Quando a tool é invocada
  Então retorna {"erro": "data inválida"}
```

### Prompt do sistema (persona)

```gherkin
Cenário: Agente segue a persona definida
  Dado que o prompt do sistema define o agente como "atendente cordial de clínica"
  Quando o usuário pergunta "Você pode me ajudar?"
  Então a resposta deve incluir "Com certeza!" ou "Claro!"
  E a resposta não deve conter linguagem agressiva ou técnica excessiva

Cenário: Agente recusa responder fora do escopo
  Dado que a persona restringe respostas a assuntos médicos da clínica
  Quando o usuário pergunta "Qual o time do Pelé?"
  Então o agente responde com "Desculpe, só posso ajudar com questões relacionadas a agendamentos e informações da clínica."
```

---

## 5. Tarefa de Frontend (FRONT)

### Componente de formulário

```gherkin
Cenário: Usuário preenche formulário válido
  Dado que o componente FormularioAgendamento está renderizado
  Quando o usuário digita "João Silva" no campo nome
  E seleciona "Cardiologia" no dropdown
  E escolhe uma data futura no datepicker
  E clica no botão "Agendar"
  Então o componente chama a API POST /agendar
  E exibe uma mensagem de sucesso "Consulta agendada!"

Cenário: Campos obrigatórios vazios
  Dado que o formulário está renderizado
  Quando o usuário clica em "Agendar" sem preencher o nome
  Então o campo nome é destacado como erro
  E a mensagem "Nome é obrigatório" aparece
  E a API não é chamada

Cenário: Resposta de erro da API (horário ocupado)
  Dado que o usuário preencheu todos os campos corretamente
  Quando a API retorna status 409 (conflito)
  Então o componente exibe "Horário já ocupado, escolha outro"
  E o botão "Agendar" é reabilitado
```

---

## 6. Tarefa de Infraestrutura (INFRA)

### Dockerfile

```gherkin
Cenário: Dockerfile constrói imagem sem erros
  Dado que o Dockerfile existe no diretório raiz
  Quando eu executo `docker build -t app .`
  Então o build termina com código 0
  E a imagem contém o código fonte copiado

Cenário: Container inicia e responde a health check
  Dado que a imagem foi construída
  Quando eu executo `docker run -p 8000:8000 app`
  E aguardo 5 segundos
  Então `curl http://localhost:8000/health` retorna 200
  E a resposta contém "ok"

Cenário: Variáveis de ambiente são respeitadas
  Dado que a variável DATABASE_URL é passada como env
  Quando o container inicia
  Então a aplicação usa a URL fornecida para conectar ao banco
```

---

## Dicas para escrever bons cenários

| Dica | Exemplo (ruim → bom) |
|------|----------------------|
| Seja específico nos dados | "Dado que o paciente existe" → "Dado que o paciente com ID '123' e nome 'Maria' existe" |
| Evite jargão de implementação | "Quando o mock retorna sucesso" → "Quando a API externa responde com status 200" |
| Use `E` para múltiplas condições | Separar em vez de uma longa linha |
| Para validações, incluir o tipo de erro | "Então retorna erro" → "Então retorna status 400 com código 'validation_error'" |
| Teste também inverdades (não condições) | Incluir cenários de erro e borda |

> Este documento é uma referência. A Skill 4 deve gerar cenários específicos para cada tarefa, seguindo o estilo Gherkin. Use os exemplos como ponto de partida e adapte nomes, entidades e regras conforme o projeto.