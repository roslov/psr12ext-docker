Docker Image For Roslov’s PSR-12 Extended Coding Standard
=========================================================

This is the Docker image for automatic checking and fixing the PHP code style
by [Roslov’s PSR-12 Extended Coding Standard](https://github.com/roslov/psr12ext).


Standalone Usage Example
------------------------

**PHPCS (PHP code sniffer)**

```
docker run --rm -v ${PWD}:/app roslov/psr12ext:php-7.4 phpcs foo.php
```

**PHPCBF (PHP code fixer)**

```
docker run --rm -v ${PWD}:/app roslov/psr12ext:php-7.4 phpcbf foo.php
```

Where `foo.php` is an existing file in the current working directory.


How To Build Images
-------------------

Example 1 — manual build:

```sh
docker build \
    --build-arg IMAGE_TAG=7.4.5 \
    --build-arg PSR12EXT_VERSION=3.0.1 \
    --build-arg CS_VERSION=3.5.5 \
    --build-arg SLEVOMAT_VERSION=6.3.3 \
    -t roslov/psr12ext:php-7.4-ext-3.0.1-sl-6.3.3-cs-3.5.5 \
    -t roslov/psr12ext:php-7.4-ext-3.0.1 \
    -t roslov/psr12ext:php-7.4 \
    .

docker push roslov/psr12ext:php-7.4-ext-3.0.1-sl-6.3.3-cs-3.5.5
docker push roslov/psr12ext:php-7.4-ext-3.0.1
docker push roslov/psr12ext:php-7.4
```

Example 2 — build via a build script:

```sh
./build.sh --psr12ext=14.0.0 --cs=4.0.0 --slevomat=8.24.0
```
