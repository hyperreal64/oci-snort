FROM fedora:latest
LABEL maintainer "Jeffrey Serio <hyperreal64@pm.me>"

COPY config /config

RUN printf "fastestmirror=True\ndeltarpm=True\n" | tee -a /etc/dnf/dnf.conf \
    && dnf update -y \
    && rpm --import https://forensics.cert.org/forensics.asc \
    && source /etc/os-release \
    && dnf install -y https://forensics.cert.org/cert-forensics-tools-release-${VERSION_ID}.rpm \
    && dnf install -y snort pulledpork \
    && dnf clean all \
    && chmod +x /config/entrypoint.sh

ENTRYPOINT ["/config/entrypoint.sh"]
