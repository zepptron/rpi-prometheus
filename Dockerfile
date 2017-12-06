FROM hypriot/rpi-alpine
MAINTAINER zepptron <https://github.com/zepptron>

ENV VER="v2.0.0" \
    TAR="prometheus-2.0.0.linux-armv7.tar.gz"

RUN apk update && \
    apk add --no-cache curl && \
    apk add --no-cache tar && \
    mkdir -p /root/prometheus && \
    curl -sSLO https://github.com/prometheus/prometheus/releases/download/$VER/$TAR && \
    tar -xvf $TAR -C /root/prometheus/ --strip-components=1 && \
    rm $TAR

WORKDIR /root/prometheus

RUN mkdir -p /usr/share/prometheus && \
    mkdir -p /etc/prometheus && \
    mv ./prometheus /usr/bin/ && \
    mv ./promtool /usr/bin/ && \
    mv ./console_libraries /usr/share/prometheus/ && \
    mv ./consoles /usr/share/prometheus/ && \
    ln -s /usr/share/prometheus/console_libraries /etc/prometheus/

EXPOSE 9090
VOLUME [ "/nfs/prometheus/data" ]

ENTRYPOINT [ "/usr/bin/prometheus" ]
CMD ["--config.file=/etc/prometheus/prometheus.yml", \
     "--storage.tsdb.path=/nfs/prometheus/data", \
     "--storage.tsdb.retention=30d", \
     "--web.enable-lifecycle", \
     "--web.console.libraries=/usr/share/prometheus/console_libraries", \
     "--web.console.templates=/usr/share/prometheus/consoles" ]