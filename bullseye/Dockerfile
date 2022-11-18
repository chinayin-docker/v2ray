#
#--------------------------------------------------------------------------
# V2Ray
# GitRepo: https://github.com/chinayin-docker/v2ray
#--------------------------------------------------------------------------
#

FROM chinayin/debian:bullseye-slim

ARG CHANGE_SOURCE=true
ENV CHANGE_SOURCE ${CHANGE_SOURCE}
ARG TZ=Asia/Shanghai
ENV TZ ${TZ}
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list && \
    sed -i 's/security-cdn.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list \
;fi && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone;

RUN set -eux \
    ## alias
    && printf "alias ls='ls --color=auto'\nalias ll='ls -l --color=auto'\nalias l='ls -lA --color=auto'" >> /root/.bashrc \
    ## set limits.conf
    && printf "* soft nofile 65536\n* hard nofile 65536\n" >> /etc/security/limits.conf \
    && printf "elasticsearch soft memlock unlimited\nelasticsearch hard memlock unlimited\n" >> /etc/security/limits.conf \
    ## set sysctl.conf
    && printf "vm.max_map_count=262144" >> /etc/sysctl.conf \
    && printf "fs.file-max=65536" >> /etc/sysctl.conf \
    ## install packages
    && install_packages ca-certificates curl \
        zip unzip wget qrencode libcap2-bin dbus

ENV V2RAY_VERSION 4.31.0
ENV V2RAY_LOCATION_CONFIG /etc/v2ray
ENV V2RAY_LOCATION_ASSET /usr/local/share/v2ray

RUN set -eux \
  && BIN_PATH="/usr/local/bin" \
  && LOG_PATH="/var/log/v2ray" \
  && TMP_DIRECTORY="$(mktemp -d)" \
  && ZIP_FILE="${TMP_DIRECTORY}/v2ray.zip" \
	## download
	&& arch="$(dpkg --print-architecture)" \
	&& case "$arch" in \
		'amd64') \
			DOWNLOAD_URL="https://github.com/v2fly/v2ray-core/releases/download/v$V2RAY_VERSION/v2ray-linux-64.zip"; \
			;; \
		'arm64') \
			DOWNLOAD_URL="https://github.com/v2fly/v2ray-core/releases/download/v$V2RAY_VERSION/v2ray-linux-arm64-v8a.zip"; \
			;; \
		*) echo >&2 "error: unsupported architecture: '$arch'"; exit 1 ;; \
	esac \
  && curl -fsSL --compressed "$DOWNLOAD_URL" -o "$ZIP_FILE"  \
  && unzip -q "$ZIP_FILE" -d "$TMP_DIRECTORY" \
  && curl -fsSL --compressed "https://github.com/v2fly/geoip/releases/latest/download/geoip.dat" -o "${TMP_DIRECTORY}/geoip.dat"  \
  && curl -fsSL --compressed "https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat" -o "${TMP_DIRECTORY}/geosite.dat"  \
  ## install
  && install -d "$V2RAY_LOCATION_CONFIG" \
  && install -d "$V2RAY_LOCATION_ASSET" \
  && install -d "$LOG_PATH" \
  && echo "{}" > "${V2RAY_LOCATION_CONFIG}/config.json" \
  && for NAME in 'v2ray' 'v2ctl'; do \
    install -m 755 "${TMP_DIRECTORY}/$NAME" "${BIN_PATH}/$NAME"; \
  done \
  && for NAME in 'geoip.dat' 'geosite.dat'; do \
    install -m 644 "${TMP_DIRECTORY}/$NAME" "${V2RAY_LOCATION_ASSET}/$NAME"; \
  done \
  ## clean up
  && rm -rf "${TMP_DIRECTORY}" \
  ## test
  && v2ray -test \
  && echo "V2Ray $V2RAY_VERSION is installed."

EXPOSE 1080

CMD ["v2ray"]
