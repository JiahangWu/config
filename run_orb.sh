#!/bin/bash
PROJECT=orb

xhost +localhost
XSOCK=/tmp/.X11-unix

docker run -it -d \
		--restart=always \
		--name=vnc_$PROJECT \
		--publish=9999:8080 \
		--env="DISPLAY_WIDTH=2560" \
		--env="DISPLAY_HEIGHT=1440" \
		--env="RUN_XTERM=no" \
		--network=x11 \
	theasp/novnc

docker run -it -d \
		--restart=always \
		--name=$PROJECT \
		--volume=$XSOCK:$XSOCK:rw \
		--env="DISPLAY=vnc_$PROJECT:0.0" \
		--mount type=bind,source=/Users/ryan/Code/SLAM,target=/root \
		--mount type=bind,source=/Users/ryan/Code/Docker/ubuntu20/.bashrc,target=/root/.bashrc \
		--mount type=bind,source=/Users/ryan/Code/Docker/ubuntu20/rc.local,target=/etc/rc.local \
		--network=x11 \
	ubuntu:20.04 /bin/bash -c "/etc/rc.local;/bin/bash"

docker inspect -f "{{ .NetworkSettings.IPAddress }}" $PROJECT

# docker stop $PROJECT
# docker stop vnc_$PROJECT

docker attach $PROJECT
