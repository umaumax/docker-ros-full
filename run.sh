#!/usr/bin/env bash
tag="ros-kinetic-desktop-full-xenial:latest"

val=$(stty size)
rows=$(echo $val | cut -d ' ' -f 1)
cols=$(echo $val | cut -d ' ' -f 2)

# FYI: [docker/Tutorials/Hardware Acceleration \- ROS Wiki]( http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration )
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]; then
	xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
	if [ ! -z "$xauth_list" ]; then
		echo $xauth_list | xauth -f $XAUTH nmerge -
	else
		touch $XAUTH
	fi
	chmod a+r $XAUTH
fi

nvidia-docker run \
	--env="DISPLAY" \
	--env="QT_X11_NO_MITSHM=1" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--env="XAUTHORITY=$XAUTH" \
	--volume="$XAUTH:$XAUTH" \
	--runtime=nvidia \
	-i -t \
	--privileged -v $HOME/dev:$HOME/dev --workdir $HOME \
	$tag \
	/bin/bash -c "stty rows $rows cols $cols; source source_this_file.sh; exec bash -l"
