#!/usr/bin/env bash

umask 022

if [[ "${RMT_DBG_ADDR}" == "" ]]; then
    RMT_DBG_ADDR=0.0.0.0
fi
if [[ "${RMT_DBG_PORT}" == "" ]]; then
    RMT_DBG_PORT=9222
fi
if [[ "${RMT_DBG_WIN_SIZE}" == "" ]]; then
    RMT_DBG_WIN_SIZE="1920,1080"
fi
#I want this to run in a sub shell
/usr/bin/google-chrome-stable --disable-gpu --headless --remote-debugging-address=${RMT_DBG_ADDR} --remote-debugging-port=${RMT_DBG_PORT} --no-sandbox --window-size=${RMT_DBG_WIN_SIZE}
