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
