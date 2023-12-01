#############################################
### Roslov’s Extended PSR-12 Code Sniffer ###
#############################################

# Build argument: PHP image tag
ARG IMAGE_TAG=8.2.13

# Base image
FROM php:$IMAGE_TAG

# Maintainer
MAINTAINER Oleksandr Roslov "tr@dupkiller.net"

# Build argument: Package versions
ARG PSR12EXT_VERSION=9.0.1
ARG CS_VERSION=^3.7.2
ARG SLEVOMAT_VERSION=^8.14.1

# Installs libraries
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Sets PATHs
ENV PATH=/app:/root/.composer/vendor/bin:$PATH

# Sets the working directory
WORKDIR /app

# Installs Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer \
        --install-dir=/usr/local/bin \
        --version=2.6.5 \
    && composer clear-cache

# Installs Code Sniffer
RUN composer global require phpcsstandards/php_codesniffer:$CS_VERSION

# Installs Slevomat coding standard
RUN composer global require slevomat/coding-standard:$SLEVOMAT_VERSION

# Installs PSR-12 Extended
RUN composer global require roslov/psr12ext:$PSR12EXT_VERSION

# Adds PSR-12 Extended to the installed standards
RUN phpcs --config-set installed_paths /root/.composer/vendor/roslov/psr12ext/PSR12Ext/

# Sets PSR-12 Extended as default standard
RUN phpcs --config-set default_standard PSR12Ext

# Enables color output
RUN phpcs --config-set colors 1

# Changes report width
RUN phpcs --config-set report_width 120

# Checks the code style
CMD ["phpcs", "."]
