FROM php:8.2-fpm AS php-backend

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    libpq-dev \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo_pgsql

# Define o diretório de trabalho
WORKDIR /var/www

# Copia os arquivos do projeto Laravel
COPY . .

# Instala o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instala as dependências do Laravel
RUN composer install --no-dev --optimize-autoloader

# Ajusta permissões
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Expõe a porta do PHP-FPM
EXPOSE 9000

# Define o comando padrão
CMD ["php-fpm"]
