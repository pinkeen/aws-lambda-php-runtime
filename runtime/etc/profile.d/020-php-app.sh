mkdir -p "${LAMBDA_APP_DIR}"/.local/{bin,etc,var/lib/php/{cache,composer}}

export COMPOSER_HOME="${LAMBDA_APP_DIR}/.local/var/lib/php/composer"
export LD_LIBRARY_PATH="${LAMBDA_APP_DIR}/.local/lib:${LD_LIBRARY_PATH}"
export PATH="${LAMBDA_APP_DIR}/.local/bin:${PATH}"
