# Teste Técnico de Implementação de Projeto DevOps

> **Obs:** Uma vez que não foi informado um link para a aplicação PHP, simulei uma aplicação simples em outro repositório para validações e testes.


## Etapa 1: Containerização da Aplicação

Para a implementação do Dockerfile, pensei em algo simples e objetivo, que apenas baixa o arquivo, faz o unzip em uma instância do Alpine — por ser leve e simples — e depois, usando a técnica de multi-stage, crio de fato a instância final usando a imagem oficial do PHP com Apache. Em seguida, faço o envio da mesma para um repositório público do DockerHub.

---

## Etapa 2: Criação do Pipeline de Integração Contínua (CI)

O workflow principal também é simples e é acionado sempre que há um push no branch principal do repositório.  
O ideal seria que isso fosse feito quando o push ocorresse nos repositórios dos desenvolvedores, mas como aqui não foi solicitado dessa forma, deixei como sendo do próprio repositório enviado.  
Estou fazendo uso de variáveis do GitHub para aumentar a segurança.

---

## Etapa 3: Infraestrutura como Código (IaC) e Implantação (CD)

Optei por usar o **EKS** e não o ECS/Docker porque isso deixa o ambiente pronto para ser escalado futuramente.  
Apesar do EKS ser mais caro que as demais opções devido ao Control Plane, ele oferece uma plataforma mais robusta para este fim.  
Não mudaria muito a escolha do ECS/Docker e seria até mais simples, na verdade, mas dependeria dos pré-requisitos e da estratégia de negócios.  
Aqui optei por mostrar meus conhecimentos de Kubernetes, então o fiz assim.  

O **Terraform** está bem simples e contempla apenas o básico. Seria essencial a implementação de um controle de estado com **AWS S3** e **DynamoDB** para uma equipe grande que realiza muitos deploys diários, a fim de evitar conflitos de versões e destruição de recursos. Portanto, essas ficam como possíveis melhorias futuras para a aplicação.

A parte do **Kubernetes** também está bem simples, subindo apenas um worker com dois pods, para trabalhar com o mínimo de alta disponibilidade e failover.

---

## Etapa 4: Estratégia de Observabilidade

Como estratégia de observabilidade, sugiro que seja utilizada a stack **Prometheus + Grafana**, principalmente por serem ferramentas gratuitas e robustas.  

Estes são os pontos cruciais para serem monitorados na aplicação:

- **Saúde do Cluster** (Nós, etcd, CoreDNS, Control Plane, kube-state-metrics): essencial para entender se tudo está funcionando como deve, ou se algo está sobrecarregado. São componentes-chave e básicos do Kubernetes.  
- **Saúde da aplicação:** esse monitoramento pode ser feito através de requisições HTTP que devem retornar `200` quando a aplicação está saudável.  
- **Saúde dos Workers e Pods:** monitorar disco, memória, CPU e rede para identificar gargalos ou sobrecargas.  

> A implementação do Prometheus, que coleta os dados enviados para o Grafana, pode ser feita através do **Helm**.