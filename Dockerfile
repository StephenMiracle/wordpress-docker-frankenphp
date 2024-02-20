ARG WORDPRESS_VERSION=latest
ARG PHP_VERSION=8.3
ARG USER=www-data

FROM wordpress:$WORDPRESS_VERSION as wp



FROM dunglas/frankenphp:latest-php$PHP_VERSION as base
ENV CADDY_GLOBAL_OPTIONS=$WP_DEBUG



RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    ghostscript \
    curl \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libzip-dev \
    unzip \
    git \
    libmagickwand-dev \
    libjpeg-dev \
    libwebp-dev \
    libzip-dev \
    libmagickcore-dev \
    libmagickwand-6.q16-6 \
    libmagickcore-6.q16-6

RUN pecl install imagick-3.6.0

RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp

# install the PHP extensions we need (https://make.wordpress.org/hosting/handbook/handbook/server-environment/#php-extensions)
RUN install-php-extensions \
    bcmath \
    exif \
    gd \
    intl \
    mysqli \
    redis \
    memcached \
    zip \
    opcache \ 
    imagick

WORKDIR /var/www/html

VOLUME /var/www/html


# COPY composer.json composer.json
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer


COPY --from=wp /usr/src/wordpress /var/www/html
COPY --from=wp /usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d/
COPY --from=wp /usr/local/bin/docker-entrypoint.sh /usr/local/bin/
COPY --from=wp --chown=root:root /usr/src/wordpress /var/www/html


COPY Caddyfile /etc/caddy/Caddyfile

RUN sed -i \
    -e 's/\[ "$1" = '\''php-fpm'\'' \]/\[\[ "$1" == frankenphp* \]\]/g' \
    -e 's/php-fpm/frankenphp/g' \
    /usr/local/bin/docker-entrypoint.sh



RUN useradd -D ${USER} && \
    # Caddy requires an additional capability to bind to port 80 and 443
    setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/frankenphp
# Caddy requires write access to /data/caddy and /config/caddy

RUN chown -R ${USER}:${USER} /data/caddy && \
    chown -R ${USER}:${USER} /config/caddy && \
    chown -R ${USER}:${USER} /var/www/html && \
    chown -R ${USER}:${USER} /usr/local/bin/docker-entrypoint.sh

USER $USER

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]

