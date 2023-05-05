# Introduction
This repository contains all the code required to run the docker implementation for Archimede rover.

# Installation
## Docker Desktop
Install Docker Desktop from [here](https://www.docker.com/products/docker-desktop/).

# Build and Run
## Build Image
To build the docker image from Dockerfile, execute the following whitin the 'Dockerfile' file's directory. \
```docker build . -t ros-archimede```

## Run Container
Execute the following code to run a container from the previously built image. \
The "env" and "volume" arguments are required to allow the processes using graphical interfaces. \
The "network" argument is needed in order to make the processes within the locally run/hosted container able to communicate with processes run localally. \
The "privileged" flag is required to use the host's X11 unix socket and the host network driver simultaneously. \
```docker run -it --env="DISPLAY" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --privileged --network=host ros-archimede```

# Create a New Docker from Ros-Archimede Images
To build new images starting from ros-archimede image, create a new Dockerfile.new_name based on it. Add at the beginning of your file:\
``` FROM ros-archimede:latest``` \
To build it, run within the same directory: \
```docker build Dockerfile.new_name . -t your-new-name```

# Notes
Dockerfile.ros.melodic.realsense is an example of new image built from the basic Dockerfile image.\
ros_entrypoint.sh is not actually used by Dockerfile now. 
