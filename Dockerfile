FROM amazonlinux:2 AS base

RUN amazon-linux-extras enable -y php7.3 \
    && yum -y install \
    php-cli \
    php-opcache \
    php-intl \
    php-mbstring \
    php-process \
    php-xml


FROM amazonlinux:2 AS builder

ARG LAMBDA_PHP_APP_DIR="/root/lambda-app"
ARG LAMBDA_PHP_RUNTIME_DIR="/opt/lambda-runtime"

ENV LAMBDA_PHP_APP_DIR=${LAMBDA_PHP_APP_DIR} \
    LAMBDA_PHP_RUNTIME_DIR=${LAMBDA_PHP_RUNTIME_DIR}

RUN mkdir -p \
    ${LAMBDA_PHP_RUNTIME_DIR}/{lib/php/modules,bin,etc/php.d}

# Required by php-cli
COPY --from=base /usr/lib64/libedit.so.* ${LAMBDA_PHP_RUNTIME_DIR}/lib/
# Required by php-mbstring
COPY --from=base /usr/lib64/libonig.so.* ${LAMBDA_PHP_RUNTIME_DIR}/lib/
# Required by php-intl
COPY --from=base /usr/lib64/libicu* ${LAMBDA_PHP_RUNTIME_DIR}/lib/
# Required by php-xml
COPY --from=base /usr/lib64/libexslt* usr/lib64/libxslt* ${LAMBDA_PHP_RUNTIME_DIR}/lib/
# Extension binary modules
COPY --from=base /usr/lib64/php/modules/* ${LAMBDA_PHP_RUNTIME_DIR}/lib/php/modules/

# The CLI binary
COPY --from=base /usr/bin/php ${LAMBDA_PHP_RUNTIME_DIR}/bin/php-lambda-binary

RUN yum -y install \
    nano \
    which \
    file \
    git \
    unzip

COPY /runtime/ ${LAMBDA_PHP_RUNTIME_DIR}/

ENV PATH="${LAMBDA_PHP_RUNTIME_DIR}/bin:$PATH"

RUN curl https://getcomposer.org/installer | php -- --filename=composer --install-dir=${LAMBDA_PHP_RUNTIME_DIR}/bin

RUN composer global require \
        --prefer-dist \
        --prefer-stable \
            phpunit/phpunit \
            hirak/prestissimo

RUN cd "${LAMBDA_PHP_RUNTIME_DIR}/lambda-bootstrap" && composer install

WORKDIR /lambda/app

ENV PS1="\[\e[0;35m\][php-lambda]\[\e[0m \[\e[0;33m\]\u@\h\[\e[0m \[\e[0;34m\]\w\[\e[0m \[\e[1;32m\]→\[\e[0m\] "