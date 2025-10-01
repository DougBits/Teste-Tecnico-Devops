# syntax=docker/dockerfile:1.4

### ESTÁGIO 1: PULL DA APLICAÇÃO

# Vamos usar a imagem simples e leve do Alpine apenas para preparar os arquivos
FROM alpine:3.14 AS init

# Selecionamos o diretório de trabalho temporário
WORKDIR /temp

# Instalamos os componentes básicos
RUN apk add --no-cache git unzip

# Clona o repositório da aplicação
RUN git clone https://github.com/DougBits/TesteTecnico-Devops-app-php.git

# Descompacta o arquivo
RUN cd TesteTecnico-Devops-app-php && unzip app.zip -d /temp/app

## Para um ambiente simples de aplicação WEB tudo estaria pronto aqui
## Mas caso a aplicação fosse mais complexa e dependesse de mais componentes,
## Poderíamos instalar eles (componentes do PHP) ou usar o Composer do PHP
## Para lidar com essas dependências e assim preparar o ambiente de forma mais
## Enxuta usando a conceito de multi-stage

### ESTÁGIO 2: SUBINDO A APLICAÇÃO

# Agora subimos a imagem final do apache
FROM php:8.2-apache

# Vamos atualizar a imagem. Isso evita vulnerabilidades de segurança já conhecidas.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Criamos um usuário não-root para segurança
RUN useradd -m phpuser

# Copia a aplicação do Build Stage anterior
COPY --from=init /temp/app /var/www/html

# Ajusta permissões para maior segurança, sem usar o usuário do apache
RUN chown -R phpuser:phpuser /var/www/html

# Configura Apache para rodar como phpuser
RUN sed -i 's|APACHE_RUN_USER=www-data|APACHE_RUN_USER=phpuser|' /etc/apache2/envvars \
    && sed -i 's|APACHE_RUN_GROUP=www-data|APACHE_RUN_GROUP=phpuser|' /etc/apache2/envvars

# Configura logging do PHP para stdout/stderr
RUN echo "log_errors = On" > /usr/local/etc/php/conf.d/logging.ini \
    && echo "error_log = /dev/stderr" >> /usr/local/etc/php/conf.d/logging.ini

# Executar como usuário não-root que criamos
USER phpuser

# Expor a porta 80 para acesso a Web
EXPOSE 80

# Inicializar o PHP Apache
CMD ["apache2-foreground"]