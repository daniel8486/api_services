# API Services - Documentação Técnica

## Visão Geral

Este projeto é uma API backend desenvolvida em Ruby on Rails, estruturada para ser escalável, modular e de fácil manutenção, seguindo princípios de Clean Code e SRP (Single Responsibility Principle). O sistema gerencia usuários, empresas, cidades, bairros, estados e CEPs, com regras de negócio robustas e controle de acesso por perfil.

## Estrutura de Pastas

- **controllers/**: Orquestra as requisições HTTP e delega lógica para services e models.
- **models/**: Define entidades, validações, enums e associações.
- **serializers/**: Padroniza e formata as respostas JSON da API.
- **services/**: Centraliza regras de negócio, lógica complexa e integrações.
- **responses/**: Monta respostas customizadas para endpoints específicos.
- **jobs/**: Tarefas assíncronas (ex: atualização de cache).
- **validators/**: Validadores customizados para atributos específicos.
- **uploaders/**: Upload e processamento de arquivos.
- **policies/**: Autorização por recurso.

## Regras de Negócio

### Usuários

- **Papéis**: `super_root`, `super_admin`, `admin`, `user`, `client`.
- **Hierarquia**:
  - `super_root`: acesso total ao sistema, cadastrado apenas via seed.
  - `super_admin`: gerencia todas as empresas e usuários, não precisa de empresa vinculada.
  - `admin`, `user`, `client`: sempre vinculados a uma empresa.
- **Validações**:
  - CPF obrigatório, único e com formato válido.
  - Só pode haver um `admin` por empresa.
  - Não é permitido remover `super_root` ou `super_admin` via API.
  - Cadastro de `client` só pode ser feito por usuários autenticados e autorizados.
- **Permissões**: Controladas via CanCanCan (`Ability`), garantindo que cada papel só acesse o que for permitido.

### Empresas

- Cadastro e gerenciamento restrito a `admin`, `super_admin` e `super_root`.
- Dados obrigatórios: nome, CNPJ, endereço, etc.

### Cidades, Bairros, Estados e CEPs

- Estrutura relacional: Estado > Cidade > Bairro > CEP.
- Endpoints para busca por nome, CEP e sigla do estado.
- Respostas customizadas podem ser montadas via services (ex: CityResponseService).


## Lógica e Técnicas Utilizadas

- **Service Objects**: Toda lógica de negócio complexa e montagem de respostas customizadas ficam em arquivos de service, mantendo controllers enxutos.
- **Serializers**: Utilização do JSONAPI::Serializer para padronizar o JSON e facilitar inclusão de associações.
- **Cache**: Utilização de cache para listas de cidades, melhorando performance.
- **Background Jobs**: Atualização de dados e cache via jobs assíncronos.
- **Validações**: Todas as validações de dados ficam nos models ou validators customizados.
- **Autorização**: CanCanCan para controle de acesso por perfil.
- **Upload de arquivos**: CarrierWave para upload e processamento de avatares.
- **Dotenv**: Gerenciamento de variáveis de ambiente.
- **Testes**: Estrutura pronta para RSpec, FactoryBot, Shoulda Matchers, etc.

---

## Padrões de Programação

- **SRP (Single Responsibility Principle)**: Cada classe/arquivo tem uma única responsabilidade.
- **Clean Code**: Métodos curtos, nomes claros, controllers enxutos, lógica centralizada em services.
- **DRY (Don't Repeat Yourself)**: Reutilização de lógica via services e concerns.
- **RESTful**: Endpoints seguem padrão REST.
- **N+1 Query Prevention**: Uso de `includes` para otimizar consultas com associações.

---

## Exemplos de Uso

### Serialização customizada via Service

```ruby
# Controller
def show
  city = City.includes(:state, neighborhoods: :zips).find(params[:id])
  render json: CityResponseService.city_details(city)
end
```

### Busca de cidades por nome

```ruby
def search
  @cities = CityService.search(params[:query])
  render json: CitySerializer.new(@cities, include: [:state]).serializable_hash
end
```

---

## Aplicando SOLID ,Design Patterns ,Clean Code e Testes Automatizados. 

---

## Dúvidas

Consulte os arquivos em `services/`, `serializers/` e os controllers para exemplos de uso.  
Para dúvidas sobre regras de negócio, consulte este arquivo ou a documentação dos models.

---

## Criado por Daniel Djam
