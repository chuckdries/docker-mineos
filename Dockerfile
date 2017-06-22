FROM ubuntu:xenial
MAINTAINER Yuji ODA
ENV MINEOS_VERSION 1.1.7

# Installing Dependencies
RUN apt-get update; \
    apt-get -y install screen nodejs npm rdiff-backup openjdk-8-jre-headless build-essential uuid pwgen curl sudo

# Installing MineOS scripts
RUN ln -s /usr/bin/nodejs /usr/bin/node; \
    mkdir -p /usr/games /usr/games/minecraft /var/games/minecraft; \
    curl -L https://github.com/hexparrot/mineos-node/archive/v${MINEOS_VERSION}.tar.gz | tar xz -C /usr/games/minecraft --strip=1; \
    cd /usr/games/minecraft; \
    npm install; \
    chmod +x service.js mineos_console.js generate-sslcert.sh webui.js; \
    ln -s /usr/games/minecraft/mineos_console.js /usr/local/bin/mineos

# Customize server settings
ADD mineos.conf /etc/mineos.conf

# Add start script
ADD start.sh /usr/games/minecraft/start.sh
RUN chmod +x /usr/games/minecraft/start.sh

# Add minecraft user and change owner files.
RUN useradd -s /bin/bash -d /usr/games/minecraft -m minecraft; \
    chown -R minecraft:minecraft /usr/games/minecraft /var/games/minecraft

# Cleaning
RUN apt-get clean

VOLUME /var/games/minecraft
WORKDIR /usr/games/minecraft
EXPOSE 8443 25565 25566 25567 25568 25569 25570

CMD ["./start.sh"]
