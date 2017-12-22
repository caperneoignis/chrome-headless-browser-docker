#!/bin/sh

exec google-chrome-stable --disable-dev-shm-usage --headless --disable-gpu "$@"
