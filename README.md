# Configuração da API Gateway v2 com Terraform

Este repositório contém a configuração do Terraform para criar e gerenciar uma API Gateway v2 na AWS, que integra diversas funções Lambda para operações de veículos e clientes, com autenticação JWT via Amazon Cognito.

## Estrutura do Projeto

- `provider.tf`: Define o provedor AWS e a região.
- `main.tf`: Configura o API Gateway, integrações com funções Lambda, e define rotas e autorizações.
- `outputs.tf`: (Opcional) Define as saídas do Terraform para uso posterior.

## Recursos Criados

### API Gateway v2

A API Gateway é definida com o protocolo HTTP e expõe várias rotas para interagir com as funções Lambda:

- **Nome da API**: `gtw-mducati`

### Funções Lambda Integradas

As seguintes funções Lambda estão integradas à API Gateway:

- **Cadastrar Cliente**: `lambda-compradores-CadastrarClienteFunction`
- **Criar Veículo**: `CriarVeiculoFunction`
- **Editar Veículo**: `EditarVeiculoFunction`
- **Listar Veículos Disponíveis**: `ListarVeiculosDisponiveisFunction`
- **Listar Veículos Vendidos**: `ListarVeiculosVendidosFunction`
- **Reservar Veículo**: `ReservarVeiculoFunction`
- **Processar Pagamento**: `ProcessarPagamentoFunction`

### Permissões

As permissões necessárias para que o API Gateway possa invocar as funções Lambda são configuradas.

### Integrações

Cada rota é associada a uma integração com uma função Lambda específica usando o tipo de integração `AWS_PROXY`.

### Autorização

O acesso às seguintes rotas é protegido por um authorizer JWT utilizando Amazon Cognito:

- **Cadastrar Cliente**: `POST /clientes`
- **Criar Veículo**: `POST /veiculos`
- **Editar Veículo**: `PUT /veiculos/{id}`
- **Reservar Veículo**: `POST /veiculos/{id}/reservar`
- **Processar Pagamento**: `POST /pagamentos`

Rota sem autenticação:

- **Listar Veículos Disponíveis**: `GET /veiculos/disponiveis`
- **Listar Veículos Vendidos**: `GET /veiculos/vendidos`

### Deployment

O estágio de desenvolvimento (`dev`) é configurado para auto-deploy, garantindo que as alterações na configuração sejam automaticamente aplicadas.

## Requisitos

- Terraform 1.3 ou superior
- AWS CLI configurado com credenciais apropriadas

## Instruções de Uso

1. **Clone o repositório**:
    ```sh
    git clone <URL do repositório>
    cd <nome do diretório>
    ```

2. **Inicialize o Terraform**:
    ```sh
    terraform init
    ```

3. **Revise o plano de execução**:
    ```sh
    terraform plan
    ```

4. **Aplique a configuração**:
    ```sh
    terraform apply
    ```

5. **Destrua a infraestrutura (se necessário)**:
    ```sh
    terraform destroy
    ```

## Observações

- Certifique-se de que as funções Lambda referenciadas estejam criadas e disponíveis na AWS.
- Ajuste as configurações de `audience` e `issuer` no authorizer JWT conforme necessário para seu ambiente Cognito.

## Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE).

