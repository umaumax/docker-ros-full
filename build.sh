#!/usr/bin/env bash
tag="ros-kinetic-desktop-full-xenial:latest"

httpproxy="${HTTP_PROXY:-$http_proxy}"
httpsproxy="${HTTPS_PROXY:-$https_proxy}"
ftpproxy="${FTP_PROXY:-$ftp_proxy}"

nvidia-docker build \
	-t $tag \
	--build-arg user="$(whoami)" --build-arg uid="$(id -u)" --build-arg gid="$(id -g)" \
	--build-arg HTTP_PROXY=$httpproxy \
	--build-arg http_proxy=$httpproxy \
	--build-arg FTP_PROXY=$ftpproxy \
	--build-arg ftp_proxy=$ftpproxy \
	--build-arg HTTPS_PROXY=$httpsproxy \
	--build-arg https_proxy=$httpsproxy \
	"$@" .
