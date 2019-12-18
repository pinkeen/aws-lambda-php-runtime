if [ "$-" != *i* ] ; then
	return 0
fi

cat << EOF
==================================
==  AWS Lambda PHP CLI Runtime  ==
==================================

--- Runtime Configuration ---

$(env | grep -e '^LAMBDA_')

--- PHP Binary - $(which php) ---

$(php --version)

--- PHP Modules - $(which php) ---

$(php -m)

--- Composer - $(which composer) ---

$(composer --version)
EOF

alias ls='ls --color=auto -N'
alias ll='ls -lh --group-directories-first'
alias l='ls -lAh --group-directories-first'

export PS1="\[\e[0;35m\][php-lambda]\[\e[0m \[\e[0;33m\]\u@\h\[\e[0m \[\e[0;34m\]\w\[\e[0m \[\e[1;32m\]→\[\e[0m\] "