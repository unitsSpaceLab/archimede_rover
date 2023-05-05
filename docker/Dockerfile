FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

RUN apt-get clean && apt-get update && \
    apt-get install -y \
    locales

RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8



RUN apt-get install -y --no-install-recommends\
    git \
    cmake \
    build-essential \
    curl \
    wget \
    nano \
    ca-certificates \
    gnupg2 \
    lsb-release \
    devilspie \
    xfce4-terminal \
    psmisc \
    && rm -rf /var/lib/apt/lists/*

# attempt to make GUIs work
ENV QT_X11_NO_MITSHM=1
RUN wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -; \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'

# ROS installation
ENV ROS_DISTRO=melodic

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 67170598AF249743
RUN apt update 
RUN apt install -y ros-melodic-desktop-full 

# install bootstrap dependencies
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
RUN apt install -y \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential 

# rosdep init/update
RUN rosdep init && rosdep update

# install archimede rover dependencies
RUN apt-get install -y \
    gazebo9 \
    ros-melodic-gazebo-* \
    ros-melodic-cartographer \
    ros-melodic-realsense2* \
    ros-melodic-hector-gazebo-plugins \
    ros-melodic-ddynamic-reconfigure 

# set up archimede env
RUN mkdir -p  ~/catkin_ws/src
RUN cd ~/catkin_ws/src && \
    . /opt/ros/melodic/setup.sh && \
    catkin_init_workspace && \
    git clone https://github.com/unitsSpaceLab/archimede_rover --recurse-submodules
RUN cd ~/catkin_ws/src && \
    git clone https://github.com/rickstaa/realsense-ros-gazebo --recurse-submodules
RUN cd ~/catkin_ws && \
    . /opt/ros/melodic/setup.sh && \
    catkin_make || catkin_make

# switch to melodic robot4ws_description repo (to avoid errors)
RUN cd ~/catkin_ws/src/archimede_rover/robot4ws_description && \
    git checkout melodic

# sourcing custom user ROS environment
RUN echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
#RUN echo "ROS_MASTER_URI=http://localhost:11311" >> ~/.bashrc

RUN apt upgrade -y libignition-math2

# setup entrypoint
WORKDIR /root
#COPY ./ros_entrypoint.sh /ros_entrypoint.sh
#ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
