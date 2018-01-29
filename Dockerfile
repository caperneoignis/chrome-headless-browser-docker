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

LABEL name="chrome-headless with apache" \ 
			maintainer="Lee K." \
			version="1.5" \
			description="Google Chrome Headless in a container"

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
//fixes issue with chrome and potentially speeds up system. 
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

# Install deps + add Chrome Stable + purge all the things
RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
  gnupg \
  git \
  sudo \
	--no-install-recommends
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
	
RUN apt-get update && apt-get install -y \
	google-chrome-stable \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

EXPOSE 9222

#overwrite old configs with custom configs with export Document root
#even though these files exist as is in the php image, I want to include them, so someone doesn't have to go to the other image and change those. 
COPY configs/000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY configs/apache2.conf /etc/apache2/apache2.conf

COPY files/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

#overwrite old configs, then start php-entrypoint. followed by starting apache2 in the foreground
ENTRYPOINT [ "/entrypoint.sh", "docker-php-entrypoint"]

#set work directory to be the root system, since CI/CD like gitlab run from custom directory in build image. 
WORKDIR /

CMD ["apache2-foreground"]

