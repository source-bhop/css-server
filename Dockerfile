FROM ubuntu:20.04

ARG CSS_DIR
ARG STEAMCMD_DIR

ENV _CSS_DIR=$CSS_DIR
ENV _STEAMCMD_DIR=$STEAMCMD_DIR
ENV TZ=Europe/Moscow
ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y \
        curl \
        ca-certificates \
        lib32gcc-s1 \
        lib32stdc++6 \
        unzip \
        tzdata \
        wget && \
    ln -snf /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    echo "Europe/Moscow" > /etc/timezone && \
    useradd -m steam

# steamcmd
RUN mkdir -p $_STEAMCMD_DIR && \
    cd $_STEAMCMD_DIR && \
    curl -sL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xzv

# CSS
RUN mkdir -p $_CSS_DIR && \
    $_STEAMCMD_DIR/steamcmd.sh +login anonymous \
    +force_install_dir $_CSS_DIR \
    +app_update 232330 validate +quit

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh && chown -R steam:steam $_CSS_DIR $_STEAMCMD_DIR

USER steam

# fix: /home/steam/.steam/sdk32/steamclient.so: cannot open shared object file: No such file or directory
RUN mkdir -p /home/steam/.steam/sdk32 && \
    cp $_STEAMCMD_DIR/linux32/steamclient.so /home/steam/.steam/sdk32/steamclient.so

WORKDIR ${_CSS_DIR}

ENTRYPOINT ["/startup.sh"]
