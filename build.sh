#!/bin/bash
set -e

# Builds, tags and pushes images
#
# Options:
# `--psr12ext` — PSR-12 Ext coding standard version (required)
# `--slevomat` — Slevomat coding standard version (required)
# `--cs` — Code Sniffer version (required)
# `--repo` — Docker Hub repository to push images to (optional)
#
# Example:
# ./build.sh --psr12ext=3.0.1 --cs=3.5.5 --slevomat=6.3.5

REPO=roslov/psr12ext

for i in "$@"
do
case $i in
    --psr12ext=*)
    PSR12EXT_VERSION="${i#*=}"
    shift # past argument=value
    ;;
    --cs=*)
    CS_VERSION="${i#*=}"
    shift # past argument=value
    ;;
    --slevomat=*)
    SLEVOMAT_VERSION="${i#*=}"
    shift # past argument=value
    ;;
    --repo=*)
    REPO="${i#*=}"
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done

if [ -z "$PSR12EXT_VERSION" ]
then
      echo '`--psr12ext` option is missing'
      exit 1
fi
if [ -z "$CS_VERSION" ]
then
      echo '`--cs` option is missing'
      exit 1
fi
if [ -z "$SLEVOMAT_VERSION" ]
then
      echo '`--slevomat` option is missing'
      exit 1
fi
if [ -z "$REPO" ]
then
      echo '`--repo` option is missing'
      exit 1
fi

echo '=============================================================='
echo 'PSR-12 EXT CODING STANDARD IMAGE BUILDER'
echo '=============================================================='
echo ''

echo "PSR-12 Ext coding standard version: $PSR12EXT_VERSION"
echo "Slevomat coding standard version: $SLEVOMAT_VERSION"
echo "Code Sniffer version: $CS_VERSION"
echo "Docker Hub repository: $REPO"

phpVers=('8.1.7' '8.0.20' '7.4.30' '7.3.33' '7.2.34')
regexp='([0-9]+\.[0-9]+)\.([0-9]+)'
for PHP_FULL_VERSION in "${phpVers[@]}"
do
    if [[ $PHP_FULL_VERSION =~ $regexp ]]; then
        PHP_SHORT_VERSION="${BASH_REMATCH[1]}"

        echo ''
        echo '=============================================================='
        echo "Building PHP $PHP_FULL_VERSION images..."
        echo '=============================================================='
        echo ''

        docker build \
            --build-arg IMAGE_TAG="$PHP_FULL_VERSION" \
            --build-arg PSR12EXT_VERSION="$PSR12EXT_VERSION" \
            --build-arg CS_VERSION="$CS_VERSION" \
            --build-arg SLEVOMAT_VERSION="$SLEVOMAT_VERSION" \
            -t "$REPO:php-$PHP_SHORT_VERSION-ext-$PSR12EXT_VERSION-sl-$SLEVOMAT_VERSION-cs-$CS_VERSION" \
            -t "$REPO:php-$PHP_SHORT_VERSION-ext-$PSR12EXT_VERSION" \
            -t "$REPO:php-$PHP_SHORT_VERSION" \
            .

        echo ''
        echo '=============================================================='
        echo "Testing PHP $PHP_FULL_VERSION images..."
        echo '=============================================================='
        echo ''

        docker run \
            --rm -v "${PWD}"/tests:/app \
            "$REPO:php-$PHP_SHORT_VERSION-ext-$PSR12EXT_VERSION-sl-$SLEVOMAT_VERSION-cs-$CS_VERSION" \
            phpcs \
            TestA.php
        echo 'Tests passed.'
    fi
done

phpVers=('8.1' '8.0' '7.4' '7.3' '7.2')
for PHP_SHORT_VERSION in "${phpVers[@]}"
do
    echo ''
    echo '=============================================================='
    echo "Pushing PHP $PHP_SHORT_VERSION images..."
    echo '=============================================================='
    echo ''

    docker push "$REPO:php-$PHP_SHORT_VERSION-ext-$PSR12EXT_VERSION-sl-$SLEVOMAT_VERSION-cs-$CS_VERSION"
    docker push "$REPO:php-$PHP_SHORT_VERSION-ext-$PSR12EXT_VERSION"
    docker push "$REPO:php-$PHP_SHORT_VERSION"
done

echo ''
echo '=============================================================='
echo 'Done.'
echo '=============================================================='
