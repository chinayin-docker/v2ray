#
#--------------------------------------------------------------------------
# V2Ray
# GitRepo: https://github.com/chinayin-docker/v2ray
#--------------------------------------------------------------------------
#

FROM chinayin/debian:bookworm-slim

ARG CHANGE_SOURCE=true
ENV CHANGE_SOURCE ${CHANGE_SOURCE}
ARG TZ=Asia/Shanghai
ENV TZ ${TZ}
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    echo "change source." \
;fi && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone;

RUN set -eux \
    ## add user
    && groupadd --gid 1000 v2ray \
    && useradd --uid 1000 --gid v2ray --shell /bin/bash --create-home v2ray \
    ## alias
    && printf "alias ls='ls --color=auto'\nalias ll='ls -l --color=auto'\nalias l='ls -lA --color=auto'" >> /etc/profile.d/ll.sh \
    ## set limits.conf
    && printf "* soft nofile 65536\n* hard nofile 65536\n" >> /etc/security/limits.conf \
    ## set sysctl.conf
    && printf "vm.max_map_count=262144\nfs.file-max=65536" >> /etc/sysctl.conf \
    ## install packages
    && install_packages ca-certificates curl \
        net-tools iputils-ping \
        zip unzip wget qrencode libcap2-bin dbus

ENV V2RAY_VERSION 5.28.0
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
  && for NAME in 'v2ray'; do \
    install -m 755 "${TMP_DIRECTORY}/$NAME" "${BIN_PATH}/$NAME"; \
  done \
  && for NAME in 'geoip.dat' 'geosite.dat'; do \
    install -m 644 "${TMP_DIRECTORY}/$NAME" "${V2RAY_LOCATION_ASSET}/$NAME"; \
  done \
  ## clean up
  && rm -rf "${TMP_DIRECTORY}" \
  ## test
  && v2ray test \
  && echo "V2Ray $V2RAY_VERSION is installed."

EXPOSE 1080 1087

CMD ["v2ray","run"]
