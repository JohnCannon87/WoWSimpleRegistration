# Use the official PHP image as the base image
FROM php:8.0-apache

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    libgmp-dev \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    && docker-php-ext-install gmp gd zip soap mbstring pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP dependencies
RUN composer install --working-dir=application

# Copy the sample config file and allow configuration via environment variables
COPY application/config/config.php.sample application/config/config.php

# Set environment variables for configuration
ENV BASE_URL=${BASE_URL:-"http://localhost"}
ENV PAGE_TITLE=${PAGE_TITLE:-"Simple Register"}
ENV LANGUAGE=${LANGUAGE:-"english"}
ENV DEBUG_MODE=${DEBUG_MODE:-false}
ENV REALMLIST=${REALMLIST:-"logon.myserver.com"}
ENV GAME_VERSION=${GAME_VERSION:-"3.3.5a (12340)"}
ENV EXPANSION=${EXPANSION:-2}
ENV SERVER_CORE=${SERVER_CORE:-0}
ENV BNET_SUPPORT=${BNET_SUPPORT:-false}
ENV SRP6_SUPPORT=${SRP6_SUPPORT:-true}
ENV SRP6_VERSION=${SRP6_VERSION:-2}
ENV DISABLE_TOP_PLAYERS=${DISABLE_TOP_PLAYERS:-false}
ENV DISABLE_ONLINE_PLAYERS=${DISABLE_ONLINE_PLAYERS:-false}
ENV DISABLE_CHANGE_PASSWORD=${DISABLE_CHANGE_PASSWORD:-false}
ENV MULTIPLE_EMAIL_USE=${MULTIPLE_EMAIL_USE:-false}
ENV TEMPLATE=${TEMPLATE:-"light"}
ENV SMTP_HOST=${SMTP_HOST:-"smtp1.example.com"}
ENV SMTP_PORT=${SMTP_PORT:-587}
ENV SMTP_AUTH=${SMTP_AUTH:-true}
ENV SMTP_USER=${SMTP_USER:-"user@example.com"}
ENV SMTP_PASS=${SMTP_PASS:-"SECRET"}
ENV SMTP_SECURE=${SMTP_SECURE:-"tls"}
ENV SMTP_MAIL=${SMTP_MAIL:-"no-reply@example.com"}
ENV VOTE_SYSTEM=${VOTE_SYSTEM:-true}
ENV CAPTCHA_TYPE=${CAPTCHA_TYPE:-0}
ENV CAPTCHA_KEY=${CAPTCHA_KEY:-""}
ENV CAPTCHA_SECRET=${CAPTCHA_SECRET:-""}
ENV CAPTCHA_LANGUAGE=${CAPTCHA_LANGUAGE:-"en"}
ENV SOAP_FOR_REGISTER=${SOAP_FOR_REGISTER:-false}
ENV SOAP_HOST=${SOAP_HOST:-"127.0.0.1"}
ENV SOAP_PORT=${SOAP_PORT:-7878}
ENV SOAP_URI=${SOAP_URI:-"urn:MaNGOS"}
ENV SOAP_STYLE=${SOAP_STYLE:-"SOAP_RPC"}
ENV SOAP_USERNAME=${SOAP_USERNAME:-"admin_soap"}
ENV SOAP_PASSWORD=${SOAP_PASSWORD:-"admin_soap"}
ENV SOAP_CA_COMMAND=${SOAP_CA_COMMAND:-"account create {USERNAME} {PASSWORD}"}
ENV TWO_FA_SUPPORT=${TWO_FA_SUPPORT:-false}
ENV SOAP_2D_COMMAND=${SOAP_2D_COMMAND:-"account set 2fa {USERNAME} off"}
ENV SOAP_2E_COMMAND=${SOAP_2E_COMMAND:-"account set 2fa {USERNAME} {SECRET}"}
ENV DB_AUTH_HOST=${DB_AUTH_HOST:-"127.0.0.1"}
ENV DB_AUTH_PORT=${DB_AUTH_PORT:-3306}
ENV DB_AUTH_USER=${DB_AUTH_USER:-"root"}
ENV DB_AUTH_PASS=${DB_AUTH_PASS:-"root"}
ENV DB_AUTH_DBNAME=${DB_AUTH_DBNAME:-"auth"}

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
