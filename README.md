# special thanks to
[justinribeiro](https://github.com/justinribeiro/dockerfiles/tree/master/chrome-headless) I used his MakeFile with the  test script I had acquired from the forked repo that post the version informaiton. 

# chrome-headless-browser-docker

This repository contains one docker builds.

[![Build Status](https://travis-ci.org/caperneoignis/chrome-headless-browser-docker.svg?branch=master)](https://travis-ci.org/caperneoignis/chrome-headless-browser-docker)


## Chrome Headless Browser

This docker image contain the Linux Dev channel Chromium (https://www.chromium.org/getting-involved/dev-channel), with the required dependencies and the command line argument running headless mode provided.

---

### Variables that can be set at run time

| Variable | Default| 
|----------|--------|
| RMT_DBG_ADDR | 0.0.0.0 |
| RMT_DBG_PORT | 9222 |
| RMT_DBG_WIN_SIZE | "1920,1080" |

These variables can be set with the -e switch at run time, so you can get different settings for the chrome browser at run time.

## How to run the container:

To run the container with remote-debugging:
```
docker run -d -p 9222:9222 --cap-add=SYS_ADMIN caperneoignis/chrome-headless-browser
```
To run the container with remote-debugging and different setting:
```
docker run -d -p 9223:9223 -e RMT_DBG_PORT=9223 --cap-add=SYS_ADMIN caperneoignis/chrome-headless-browser
```
See the following sections for alternate ways to start the container.

## Why cap-add=SYS_ADMIN is needed

Currently, there is a user namespace issue in OSX that generates this error:
```
Failed to move to new namespace: PID namespaces supported, Network namespace supported,
but failed: errno = Operation not permitted
```

There are two mitigations, but none of them are ideal as it gives the container some special capabilities:

1. Use a special seccomp profile, as stated in https://twitter.com/jessfraz/status/681934414687801345
```
docker run -d --name chrome -p 9222:9222 --security-opt seccomp:/path/to/chrome.json caperneoignis/chrome-headless-browser
```

2. Use CAP_SYS_ADMIN
```
docker run -d --name chrome -p 9222:9222 --cap-add=SYS_ADMIN caperneoignis/chrome-headless-browser
```
