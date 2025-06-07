FROM debian:bookworm-slim

ARG CSS_DIR
ARG STEAMCMD_DIR

ENV CSS_DIR=$CSS_DIR
ENV STEAMCMD_DIR=$STEAMCMD_DIR

RUN apt update && \
    apt install -y curl ca-certificates lib32gcc-s1 unzip wget && \
    useradd -m steam

# steamcmd
RUN mkdir -p $STEAMCMD_DIR && \
    cd $STEAMCMD_DIR && \
    curl -sL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xzv

# CSS
RUN mkdir -p $CSS_DIR && \
    $STEAMCMD_DIR/steamcmd.sh +login anonymous \
    +force_install_dir $CSS_DIR \
    +app_update 232330 validate +quit

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

USER steam
WORKDIR ${CSS_DIR}

ENTRYPOINT ["/startup.sh"]
