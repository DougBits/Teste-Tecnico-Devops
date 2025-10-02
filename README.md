# Teste Técnico de Implementação de Projeto DevOps

> **Observação:** Como não foi fornecido um link para a aplicação PHP, simulei uma aplicação simples em outro repositório para validações e testes.

---

## Etapa 1: Containerização da Aplicação

Para a implementação do **Dockerfile**, a ideia foi criar algo simples e objetivo:

1. Baixar o arquivo da aplicação.
2. Fazer o `unzip` em uma instância do **Alpine Linux** (leve e eficiente).
3. Usar **multi-stage builds** para criar a instância final usando a imagem oficial **PHP com Apache**.
4. Enviar a imagem final para um repositório público no **DockerHub**.

---

## Etapa 2: Criação do Pipeline de Integração Contínua (CI)

O **workflow principal** foi configurado para:

- Ser acionado a cada push na branch `main`.
- Utilizar **variáveis do GitHub** para maior segurança.

> Idealmente, o acionamento seria feito em repositórios dos desenvolvedores, mas aqui optei por simplificar usando o repositório principal.

---

## Etapa 3: Infraestrutura como Código (IaC) e Implantação (CD)

Escolhi o **EKS (Kubernetes gerenciado)** ao invés do ECS/Docker para:

- Facilitar a escalabilidade futura.
- Demonstrar conhecimento em **Kubernetes**.

Observações sobre a implementação:

- O **Terraform** está básico, contemplando apenas o necessário.
- Para equipes grandes, seria essencial:
  - Controle de estado com **AWS S3** e **DynamoDB**.
  - Evitar conflitos de versões e destruição de recursos.
- Kubernetes simples:
  - Um **worker** com **dois pods**, garantindo mínima **alta disponibilidade** e **failover**.

> ECS/Docker seria mais simples e barato, mas não demonstraria habilidades em Kubernetes.

---

## Etapa 4: Estratégia de Observabilidade

Sugiro utilizar a stack **Prometheus + Grafana** (gratuitas e robustas).

### Pontos cruciais para monitoramento:

1. **Saúde do Cluster**
   - Nós, etcd, CoreDNS, Control Plane, kube-state-metrics
   - Essencial para identificar sobrecargas ou falhas nos componentes chave do Kubernetes.

2. **Saúde da Aplicação**
   - Monitoramento via requisições HTTP retornando **200 OK**.

3. **Saúde dos Workers e Pods**
   - Monitoramento de **CPU, memória, disco e rede**
   - Detectar gargalos e sobrecargas.

> A implementação do Prometheus, que coleta os dados e envia para o Grafana, pode ser feita via **Helm Charts**.

---