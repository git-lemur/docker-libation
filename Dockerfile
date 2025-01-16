# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble


# set version label
ARG BUILD_DATE
ARG VERSION
ARG LIBATION_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="git-lemur"

ENV \
  CUSTOM_PORT="8080" \
  CUSTOM_HTTPS_PORT="8181" \
  HOME="/config" \
  TITLE="Libation" \
  QTWEBENGINE_DISABLE_SANDBOX="1"

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.svg \
    https://raw.githubusercontent.com/rmcrackan/Libation/refs/heads/master/Images/libation_glass.svg && \
  echo "**** install runtime packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    dbus \
    fcitx-rime \
    fonts-wqy-microhei \
    libnss3 \
    libopengl0 \
    libqpdf29t64 \
    libxkbcommon-x11-0 \
    libxcb-cursor0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    poppler-utils \
    python3 \
    python3-xdg \
    ttf-wqy-zenhei \
    wget \
    xz-utils && \
  apt-get install -y \
    speech-dispatcher && \
  echo "**** install libation ****" && \
  mkdir -p \
    /opt/libation && \
  if [ -z ${LIBATION_RELEASE+x} ]; then \
    LIBATION_RELEASE=$(curl -sX GET "https://api.github.com/repos/rmcrackan/Libation/releases/latest" \
    | jq -r .tag_name); \
  fi && \
  LIBATION_VERSION="$(echo ${LIBATION_RELEASE} | cut -c2-)" && \
  LIBATION_URL="https://github.com/rmcrackan/Libation/releases/download/v${LIBATION_VERSION}/Libation.${LIBATION_VERSION}-linux-chardonnay-amd64.deb" && \
  curl -o \
    /tmp/libation.deb -L \
    "$LIBATION_URL" && \
  dpkg -i /tmp/libation.deb && \
  dbus-uuidgen > /etc/machine-id && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY /root /
