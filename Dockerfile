#############################################
### Roslov’s Extended PSR-12 Code Sniffer ###
#############################################

# Build argument: PHP image tag
ARG IMAGE_TAG=8.2.26

# Base image
FROM php:${IMAGE_TAG}-alpine

# Build argument: Package versions
ARG PSR12EXT_VERSION=^11.0.0
ARG CS_VERSION=^3.11.1
ARG SLEVOMAT_VERSION=^8.15.0

# Installs libraries
RUN apk update && apk add --no-cache \
    git \
    unzip

# Copies base scripts and configs
COPY image-files/ /

# Sets PATHs
ENV PATH=/app:/root/.composer/vendor/bin:$PATH

# Sets the working directory
WORKDIR /app

# Installs Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
COPY --from=composer:2.8.3 /usr/bin/composer /usr/bin/composer

# Installs Code Sniffer
RUN composer global config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
RUN composer global require squizlabs/php_codesniffer:$CS_VERSION

# Installs Slevomat coding standard
RUN composer global require slevomat/coding-standard:$SLEVOMAT_VERSION

# Installs PSR-12 Extended
RUN composer global require roslov/psr12ext:$PSR12EXT_VERSION

# Adds PSR-12 Extended and its version compatible with PhpStorm (available since v13.1.0) to the installed standards
RUN phpcs --config-set installed_paths /root/.composer/vendor/roslov/psr12ext/PSR12Ext/,/root/.composer/vendor/roslov/psr12ext/PSR12ExtForPhpStorm/

# Sets PSR-12 Extended as default standard
RUN phpcs --config-set default_standard PSR12Ext

# Enables color output
RUN phpcs --config-set colors 1

# Changes report width
RUN phpcs --config-set report_width 120

# Sets the target PHP version for PHPCS based on the current PHP version
RUN phpcs --config-set php_version $(php -r 'echo PHP_VERSION_ID;')

# Checks the code style
CMD ["phpcs", "."]
