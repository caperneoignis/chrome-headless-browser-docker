# Run Chrome Headless in a container
#
# What was once a container using the experimental build of headless_shell from
# tip, this container now runs and exposes stable Chrome headless via 
# google-chome --headless.
#
# What's New 
# 
# 1. Pulls from Chrome Stable
# 2. You can now use the ever-awesome Jessie Frazelle seccomp profile for Chrome.
#     wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json -O ~/chrome.json
#
#
# To run (without seccomp):
# docker run -d -p 9222:9222 --cap-add=SYS_ADMIN justinribeiro/chrome-headless
# 
# To run a better way (with seccomp):
# docker run -d -p 9222:9222 --security-opt seccomp=$HOME/chrome.json justinribeiro/chrome-headless 
#
# Basic use: open Chrome, navigate to http://localhost:9222/
#

# Base docker image
FROM debian:sid
LABEL name="chrome-headless" \ 
			maintainer="Lee K." \
			version="1.4" \
			description="Google Chrome Headless in a container"

# Install deps + add Chrome Stable + purge all the things
RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
  gnupg \
	--no-install-recommends \
	&& curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update && apt-get install -y \
	google-chrome-stable \
	--no-install-recommends \
	&& apt-get purge --auto-remove -y curl gnupg \
	&& rm -rf /var/lib/apt/lists/*

# Expose port 9222
EXPOSE 9222
COPY files/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
# Autorun chrome headless with no GPU
ENTRYPOINT [ "./entrypoint" ]
