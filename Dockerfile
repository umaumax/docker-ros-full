FROM osrf/ros:kinetic-desktop-full-xenial

# Install required tools
RUN apt-get update; apt-get install -y openssh-server git tree wget less vim sudo tmux x11-apps
# for catkin
# RUN apt-get install -y ros-kinetic-octomap-ros ros-kinetic-octomap-server ros-kinetic-octomap-rviz-plugins ros-kinetic-jsk-visualization ros-kinetic-hector-mapping ros-kinetic-hector-trajectory-server python-wstool python-catkin-tools protobuf-compiler

# Replace 1000 with your user / group id
ARG user=docker
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${uid} ${user} && \
    useradd -u ${uid} -g ${user} -r ${user} && \
    mkdir /home/${user} && \
    chown ${uid}:${gid} -R /home/${user}

RUN usermod -aG sudo ${user}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# replace proxy setting by adding below flags at docker build
# --build-arg HTTP_PROXY="$HTTP_PROXY" --build-arg HTTPS_PROXY="$HTTPS_PROXY" --build-arg FTP_PROXY="$FTP_PROXY"--build-arg http_proxy="$http_proxy" --build-arg https_proxy="$https_proxy" --build-arg ftp_proxy="$ftp_proxy"
RUN echo HTTP_PROXY="${HTTP_PROXY}"   | tee -a /etc/environment
RUN echo HTTPS_PROXY="${HTTPS_PROXY}" | tee -a /etc/environment
RUN echo FTP_PROXY="${FTP_PROXY}"     | tee -a /etc/environment
RUN echo http_proxy="${http_proxy}"   | tee -a /etc/environment
RUN echo https_proxy="${https_proxy}" | tee -a /etc/environment
RUN echo ftp_proxy="${ftp_proxy}"     | tee -a /etc/environment

# for opengl
RUN apt-get install -y libglew-dev
# FYI: [docker/Tutorials/Hardware Acceleration \- ROS Wiki]( http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration )
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

USER ${user}
WORKDIR /home/${user}
