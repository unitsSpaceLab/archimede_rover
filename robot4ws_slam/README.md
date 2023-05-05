# robot4ws_slam

## Cartographer

Cartographer is a system that provides real-time simultaneous localization and mapping (SLAM) in 2D and 3D across multiple platforms and sensor configurations.

### Installation

Install Cartographer by executing the following code.

``` 
sudo apt-get update
sudo apt-get install ros-melodic-cartographer*
```

### Usage

Two different approaches are implemented:

* 2D SLAM, online and offline;

* 3D SLAM, online and offline.

#### 2D SLAM
 It performs simultaneous localization and mapping in a 2D map. 
 
 Our default configuration exploits the laser scan, pointcloud and odometry. 

To perform 2D slam online, execute within a terminal:

```
source ~/catkin_ws/devel/setup.bash
roslaunch robot4ws_slam archimede_cartographer_2dslam.launch
```
An rviz is also automatically launched, with an appropriate configuration, to track the mapping process' progress.

To perform 2D slam from a recorded bag, execute:

```
source ~/catkin_ws/devel/setup.bash
roslaunch robot4ws_slam archimede_cartographer_2dslam_offline.launch bag_filenames:=/path/to/your/bag.bag
```

#### 3D SLAM
 It performs simultaneous localization and mapping in a 3D map, with obstacles depicted in a 2D fashion. 
 
 Our default configuration exploits just the laser scan, point cloud, imu and odometry.

To perform 3D SLAM online, execute within a terminal:

```
source ~/catkin_ws/devel/setup.bash
roslaunch robot4ws_slam archimede_cartographer_3dslam.launch
```
An rviz is also automatically launched, with an appropriate configuration, to track the mapping process' progress.

To perform 3D SLAM from a recorded bag, execute:

```
source ~/catkin_ws/devel/setup.bash
roslaunch robot4ws_slam archimede_cartographer_3dslam_offline.launch bag_filenames:=/path/to/your/bag.bag
```

### Further Information

To change SLAM configuration, by adding on removing some input sensors or to tune the algorithm, edit _/configuration\_files/archimede\_2d.lua_ for 2D SLAM or _/configuration\_files/archimede\_3d.lua_ for 3D SLAM. More parameters to be edited can be found in other _.lua_ files in the _/configuration\_files/backup_ directory. Whereas you find a parameter you'd rather change, copy and paste it inside the _archimede\_2d.lua_ or _archimede\_3d.lua_ configuration file, then edit it appropriately.

Launch Cartographer after starting the rover and its sensors, otherwise an error will occur.\

To save a map in .pgm and .yaml format from /map topic:
```
rosrun map_server map_saver -f map_file_name map:=/map
```