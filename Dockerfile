# Use the official PHP image as a parent image
FROM php:8.0-apache

# Set the working directory
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html/

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
    libgmp-dev \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libonig-dev \
    curl \
    git \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gmp gd zip soap mbstring pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Navigate to the application directory and install dependencies
WORKDIR /var/www/html/application
RUN composer install

# Enable Apache modules
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
