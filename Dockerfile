# FROM amazonlinux:2 AS base

# # Install official amazon-linux 2 PHP binaries
# RUN amazon-linux-extras enable -y php7.3 \
#     && yum -y install \
#         php-cli \
#         php-opcache \
#         php-intl \
#         php-mbstring \
#         php-process \
#         php-xml

FROM alpine AS base

RUN apk update \
    && apk add \
        php7 \
        php7-common \
        php7-opcache \
        php7-wddx \
        php7-bz2 \
        php7-curl \
        php7-xmlreader \
        php7-json \
        php7-mbstring \
        php7-openssl \
        php7-sodium \
        php7-fileinfo \
        php7-iconv \
        php7-zip \
        php7-sqlite3 \
        php7-sockets \
        php7-calendar \
        php7-simplexml \
        php7-xsl \
        php7-pdo_sqlite \
        php7-brotli \
        php7-posix \
        php7-tokenizer \
        php7-intl \
        php7-phar \
        php7-exif \
    && rm -rf /var/cache/apk/*

FROM amazonlinux:2 AS builder

# These are used only in docker during lambda build,
# different paths will be computed live on AWS.
ENV LAMBDA_PHP_APP_DIR="/root/lambda-app" \
    LAMBDA_PHP_RUNTIME_DIR="/opt/lambda-runtime" \
    LAMBDA_PHP_BUILD_DIR="/var/lambda-build"

# Install:
# - utility tools (nano, file, which)
# - commands needed for scripts (which, rsync, zip)
# - composer requirements (git, unzip)
RUN yum -y install \
        nano \
        which \
        file \
        git \
        unzip \
        zip \
        rsync

RUN mkdir -p "${LAMBDA_PHP_RUNTIME_DIR}"/etc/ssl

COPY --from=base /usr/lib/ ${LAMBDA_PHP_RUNTIME_DIR}/lib/
COPY --from=base /lib/ ${LAMBDA_PHP_RUNTIME_DIR}/lib/
COPY --from=base /usr/bin/php7 ${LAMBDA_PHP_RUNTIME_DIR}/bin/php-lambda-binary
COPY --from=base /etc/ssl/cert.pem ${LAMBDA_PHP_RUNTIME_DIR}/etc/ssl/cert.pem

RUN mv ${LAMBDA_PHP_RUNTIME_DIR}/lib/php7 ${LAMBDA_PHP_RUNTIME_DIR}/lib/php \
    && cd ${LAMBDA_PHP_RUNTIME_DIR}/bin && ln -s ../lib/ld-musl-x86_64.so.1 ld

# PHP configuration and lambda bootstrap
COPY /runtime/ ${LAMBDA_PHP_RUNTIME_DIR}/

# Set path so composer can run
ENV PATH="${LAMBDA_PHP_RUNTIME_DIR}/bin:$PATH"

# Install composer
RUN curl https://getcomposer.org/installer | php -- --filename=composer --install-dir=${LAMBDA_PHP_RUNTIME_DIR}/bin

# Install basic build & testing deps
# RUN composer global require --prefer-dist --prefer-stable \
#         phpunit/phpunit \
#         hirak/prestissimo

# Install runtime bootstrap deps
RUN cd "${LAMBDA_PHP_RUNTIME_DIR}/lambda-bootstrap" \
    && composer install \
    && yum -y clean all \
    && rm -rf /var/cache/yum

# Just some better prompt to spice things up
ENV PS1="\[\e[0;35m\][php-lambda]\[\e[0m \[\e[0;33m\]\u@\h\[\e[0m \[\e[0;34m\]\w\[\e[0m \[\e[1;32m\]→\[\e[0m\] "
ENV LAMBDA_TASK_ROOT="/root/lambda-app"

WORKDIR /root/lambda-app

