#!/usr/bin/env bash

umask 000

if [[ "${APACHE_WEB_ROOT}" != "" ]]; then
    sed -i "s#<<APACHE_WEB_ROOT>>#${APACHE_WEB_ROOT}#" /etc/apache2/sites-enabled/000-default.conf
else
    #set a default if one is not present
    APACHE_WEB_ROOT="/var/www/html"
    sed -i "s#<<APACHE_WEB_ROOT>>#${APACHE_WEB_ROOT}#" /etc/apache2/sites-enabled/000-default.conf
fi

/usr/bin/supervisord -n -c /etc/supervisord.conf > /dev/null 2>&1 &

if [[ $# -eq 1 && $1 == "bash" ]]; then
    $@
else
    exec "$@"
fi
