FROM bitnami/minideb:buster

# Install supercronic
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64 \
  SUPERCRONIC=supercronic-linux-amd64 \
  SUPERCRONIC_SHA1SUM=048b95b48b708983effb2e5c935a1ef8483d9e3e

RUN install_packages \
  openssl ca-certificates gnupg2 dirmngr curl wget lsb-release qpress \
  && curl -fsSLO "$SUPERCRONIC_URL" \
  && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
  && chmod +x "$SUPERCRONIC" \
  && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
  && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

# Install xtrabackup
RUN wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb \
  && dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb \
  && apt-get update \
  && install_packages percona-xtrabackup-80 qpress

# Install minio
#RUN curl -fsSLO https://dl.minio.io/client/mc/release/linux-amd64/mc \
#  && chmod +x ./mc \
#  && mv ./mc /usr/local/bin/

WORKDIR /app

COPY config/crontab scripts/* .
RUN chmod +x ./*.sh

CMD ["bash", "-c", "/app/xtrabackup.sh"]
