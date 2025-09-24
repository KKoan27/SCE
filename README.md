# Sistema de Cadastro de Estabelecimentos (SCE)

Este é um sistema de linha de comando (CLI) para gerenciar o cadastro de estabelecimentos, permitindo ao usuário pesquisar, adicionar, editar e remover registros de um banco de dados MongoDB.

## Funcionalidades

* **Pesquisar:** Busque por todos os estabelecimentos ou filtre por um nome específico.
* **Adicionar:** Insira novos estabelecimentos no banco de dados.
* **Editar:** Modifique as informações de um estabelecimento existente.
* **Remover:** Apague o registro de um estabelecimento.

## Pré-requisitos

Antes de começar, garanta que você tenha os seguintes softwares instalados em sua máquina:

1.  **[SDK do Dart](https://dart.dev/get-dart):** Necessário para executar o projeto.
2.  **[MongoDB Community Server](https://www.mongodb.com/try/download/community):** O banco de dados onde as informações serão armazenadas. Certifique-se de que o serviço do MongoDB esteja em execução.

## Configuração

* **Banco de Dados:** Este projeto tentará se conectar a uma instância do MongoDB rodando localmente no endereço padrão (`mongodb://localhost:27017/`). Certifique-se de que seu servidor MongoDB esteja acessível neste endereço.
* **Dependências:** O projeto utiliza o pacote `mongo_dart`. A instalação das dependências será feita no próximo passo.

## Instalação

Siga os passos abaixo para preparar o ambiente:

1.  **Clone ou baixe o repositório:**
    ```bash
    # Se estiver usando Git
    git clone <url-do-seu-repositorio>
    cd <nome-do-repositorio>

    # Ou simplesmente baixe e extraia os arquivos do projeto em uma pasta.
    ```
2.  **Instale as dependências do projeto:**
    Abra o terminal na pasta raiz do projeto e execute o comando:
    ```bash
    dart pub get
    ```

## Como Usar

Para iniciar o programa, navegue até a pasta do projeto pelo terminal e execute o seguinte comando:

```bash
dart run bin/main.dart

