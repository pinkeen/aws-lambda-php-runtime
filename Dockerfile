FROM amazonlinux:2 AS base

RUN amazon-linux-extras enable -y php7.3 \
    && yum -y install \
    php-cli \
    php-opcache \
    php-intl \
    php-mbstring \
    php-process \
    php-xml

FROM amazonlinux:2 AS runtime

RUN yum -y install \
    nano \
    which \
    file

ARG LAMBDA_APP_DIR="/lambda/app"
ARG LAMBDA_RUNTIME_DIR="/lambda/runtime"

ENV LAMBDA_APP_DIR=${LAMBDA_APP_DIR}
ENV LAMBDA_RUNTIME_DIR=${LAMBDA_RUNTIME_DIR}

RUN mkdir -p \
    ${LAMBDA_RUNTIME_DIR}/{lib/php/modules,bin,etc/php.d}

# Required by php-cli
COPY --from=base /usr/lib64/libedit.so.* ${LAMBDA_RUNTIME_DIR}/lib/
# Required by php-mbstring
COPY --from=base /usr/lib64/libonig.so.* ${LAMBDA_RUNTIME_DIR}/lib/
# Required by php-intl
COPY --from=base /usr/lib64/libicu* ${LAMBDA_RUNTIME_DIR}/lib/
# Required by php-xml
COPY --from=base /usr/lib64/libexslt* usr/lib64/libxslt* ${LAMBDA_RUNTIME_DIR}/lib/
# Extension binary modules
COPY --from=base /usr/lib64/php/modules/* ${LAMBDA_RUNTIME_DIR}/lib/php/modules/
# The CLI binary
COPY --from=base /usr/bin/php ${LAMBDA_RUNTIME_DIR}/bin/

# Fixed PHP configs
COPY /runtime/ ${LAMBDA_RUNTIME_DIR}/

RUN echo "source ${LAMBDA_RUNTIME_DIR}/etc/profile" > /root/.bashrc \
    && source /root/.bashrc \
    && curl https://getcomposer.org/installer | php -- --filename=composer --install-dir=${LAMBDA_RUNTIME_DIR}/bin

WORKDIR /lambda/app
