FROM hypriot/rpi-alpine-scratch
MAINTAINER zepptron

RUN apk update && \
    apk add curl && \
    apk add tar && \
    mkdir -p /root/prometheus && \
    curl -sSLO https://github.com/prometheus/prometheus/releases/download/v2.0.0/prometheus-2.0.0.linux-armv7.tar.gz && \
    tar -xvf prometheus-2.0.0.linux-armv7.tar.gz -C /root/prometheus/ --strip-components=1 && \
    rm prometheus-2.0.0.linux-armv7.tar.gz

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
WORKDIR /
ENTRYPOINT [ "/usr/bin/prometheus" ]
CMD ["--config.file=/etc/prometheus/prometheus.yml", \
     "--storage.tsdb.path=/nfs/prometheus/data", \
     "--storage.tsdb.retention=30d", \
     "--web.enable-lifecycle", \
     "--web.console.libraries=/usr/share/prometheus/console_libraries", \
     "--web.console.templates=/usr/share/prometheus/consoles" ]