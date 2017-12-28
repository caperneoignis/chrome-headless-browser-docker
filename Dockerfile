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
#

# Base docker image
FROM caperneoignis/moodle-php-apache:7.1

ENV APACHE_WEB_ROOT="/var/www/html"

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
	supervisor \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

# Add Chrome as a user
#RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome \
#    && mkdir -p /home/chrome && chown -R chrome:chrome /home/chrome

# Run Chrome non-privileged
#USER chrome

# Expose port 9222
EXPOSE 9222

COPY files/supervisord.conf /etc/supervisord.conf

COPY files/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

WORKDIR /

ENTRYPOINT [ "/entrypoint.sh", "bash"]

