--------------------------------------------------------
PACKAGES MIGRATION PROGRESS
--------------------------------------------------------
(PUSHED)
robot4ws_msgs  --->     DONE (should work)

(PUSHED)
rover4ws_teleop_keyboard  --->  DONE (should work)

(PUSHED)
robot4ws_description  --->  PARTIALLY DONE, works in gazebo, sensors should be ok (IMU, rs, laser scan, optional 3d lidar)
                            TODO: - rocker differential

(PUSHED)
robot4ws_kinematics  --->   OK (should work in general)
                            TODO FIX: - car_like: goes forward with cmd_vel: vx=0 AND (vy!=0 OR wz!=0)
                                      - inner_ackermann: some wheels snaps of pi (unphysical) for some cmds (e.g. [0,-0.1,-0.05])
                                      - full_ackermann: inerited from inner_ackermann (same problem)
                            MAIN CHANGES: - kinematic node can publish (default) as actuator_msgs/msg/Actuators, easier to use with gazebo_plugin

(PUSHED)
robot4ws_gazebo_plugins  --->   WORK IN PROGRESS: - kinematic plugin: DONE - JointsControllerPlugin (works with actuator_msgs/msg/Actuators) / JointsControllerPluginDynamixel
                                                  - odometry: DONE - implemented directly in robot4ws_description with official OdometryPublisher plugin
                                                  - terramechanics plugin: DONE -> in [*gz_terramechanics*](https://github.com/unitsSpaceLab/gz-terramechanics.git) repo
                                TO DO: - terrain ml model plugin

(PUSHED)
robot4ws_teleop_joystick

(PUSHED)
robot4ws_simulations

-------------------------------------------------------
