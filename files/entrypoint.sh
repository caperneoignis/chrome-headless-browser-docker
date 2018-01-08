#!/usr/bin/env bash

umask 022

#do a string replace for configuration files for the web root. 
if [[ "${APACHE_WEB_ROOT}" != "" ]]; then
    sed -i "s#<<APACHE_WEB_ROOT>>#${APACHE_WEB_ROOT}#" /etc/apache2/sites-enabled/000-default.conf
	sed -i "s#%%APACHE_WEB_ROOT%%#${APACHE_WEB_ROOT}#" /etc/apache2/apache2.conf
else
    #set a default if one is not present
    APACHE_ROOT="/var/www/html"
    sed -i "s#<<APACHE_WEB_ROOT>>#${APACHE_ROOT}#" /etc/apache2/sites-enabled/000-default.conf
	sed -i "s#%%APACHE_WEB_ROOT%%#${APACHE_ROOT}#" /etc/apache2/apache2.conf
fi

if [[ "${SERVER_NAME}" != "" ]]; then
	sed -i "s#<<SERVER_NAME>>#${SERVER_NAME}#" /etc/apache2/apache2.conf
else
    #set a default if one is not present
    SERVER_NAME="TestServer"
	sed -i "s#<<SERVER_NAME>>#${SERVER_NAME}#" /etc/apache2/apache2.conf
fi

if [[ "${RMT_DBG_ADDR}" == "" ]]; then
    RMT_DBG_ADDR=0.0.0.0
fi
if [[ "${RMT_DBG_PORT}" == "" ]]; then
    RMT_DBG_PORT=9222
fi
if [[ "${RMT_DBG_WIN_SIZE}" == "" ]]; then
    RMT_DBG_WIN_SIZE="1920,1080"
fi
#I want this to run in a sub shell and output to go to txt file
/usr/bin/google-chrome-stable \
--disable-gpu \
--headless \
--remote-debugging-address=${RMT_DBG_ADDR} \
--remote-debugging-port=${RMT_DBG_PORT} \
--no-sandbox \
--window-size=${RMT_DBG_WIN_SIZE} > ${APACHE_WEB_ROOT}/chrome.log 2>&1 &

if [[ $# -eq 1 && $1 == "bash" ]]; then
    $@
else
    exec "$@"
fi
