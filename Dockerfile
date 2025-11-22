FROM php:8.3-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libbz2-dev \
    libpng-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libonig-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip git curl libzip-dev libjpeg-dev libpng-dev libfreetype6-dev libicu-dev libxml2-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mysqli \
    bcmath \
    calendar \
    mbstring \
    curl \
    gd \
    dom \
    xml \
    simplexml \
    zip \
    bz2 \
    exif \
    ftp \
    fileinfo

# Enable Apache mod_rewrite (commonly needed)
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod expires

# Clean up to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


# Disable PHP error reporting
RUN echo "display_errors = Off" >> /usr/local/etc/php/php.ini-production && \
    echo "display_startup_errors = Off" >> /usr/local/etc/php/php.ini-production && \
    echo "error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT" >> /usr/local/etc/php/php.ini-production && \
    cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# Set working directory
WORKDIR /var/www/html

COPY . .

# Expose port 80
EXPOSE 80