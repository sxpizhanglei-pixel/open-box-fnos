FROM alpine:latest
RUN apk add --no-cache ca-certificates curl jq bash iptables iproute2 tzdata yq unzip
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then SB_ARCH="amd64"; else SB_ARCH="arm64"; fi && \
    LATEST_SB=$(curl -sL https://api.github.com/repos/SagerNet/sing-box/releases/latest | jq -r '.tag_name') && \
    VERSION=${LATEST_SB#v} && \
    curl -Lso /tmp/sing-box.tar.gz "https://github.com/SagerNet/sing-box/releases/download/${LATEST_SB}/sing-box-${VERSION}-linux-${SB_ARCH}.tar.gz" && \
    tar -zxf /tmp/sing-box.tar.gz -C /tmp/ && \
    mv /tmp/sing-box-${VERSION}-linux-${SB_ARCH}/sing-box /usr/local/bin/sing-box && \
    chmod +x /usr/local/bin/sing-box && \
    /usr/local/bin/sing-box version && \
    rm -rf /tmp/*
RUN mkdir -p /app/ui && \
    curl -Lo /tmp/ui.zip "https://github.com/MetaCubeX/Yacd-meta/archive/gh-pages.zip" && \
    unzip /tmp/ui.zip -d /tmp/ && \
    mv /tmp/Yacd-meta-gh-pages/* /app/ui/ && \
    rm -rf /tmp/*
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
WORKDIR /app
EXPOSE 9090
ENTRYPOINT ["/app/entrypoint.sh"]
