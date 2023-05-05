-- @author: Marco Giberna
-- @email: marco.giberna@studenti.units.it
-- @email: marcogiberna@gmail.com

include "map_builder.lua"
include "trajectory_builder.lua"

options = {
  map_builder = MAP_BUILDER,
  trajectory_builder = TRAJECTORY_BUILDER,
  map_frame = "map", --The ROS frame ID to use for publishing submaps
  tracking_frame = "Archimede_imu_link", -- The ROS frame ID of the frame that is tracked by the SLAM algorithm
  published_frame = "odom", -- The ROS frame ID to use as the child frame for publishing poses. For example “odom” if an “odom” frame is supplied by a different part of the system
  odom_frame = "odom", -- not used if provide_odom_frame = false
  provide_odom_frame = false, -- set to false if odom is already provided by another part of the system, otherwise transformation between odom_frame and published_frame will be provided
  publish_frame_projected_to_2d = false,
--  use_pose_extrapolator = true, -- the used version of cartographer doesn't have this flag
  use_odometry = true, -- subscribes to nav_msgs/Odometry on the topic “odom”, includes its information on SLAM
  use_nav_sat = false,
  use_landmarks = false,
  num_laser_scans = 1,
  num_multi_echo_laser_scans = 0,
  num_subdivisions_per_laser_scan = 1,
  num_point_clouds = 1,
  -- publishing rates on publisher topics 
  lookup_transform_timeout_sec = 0.2, --Timeout in seconds to use for looking up transforms (increase it if it gives lookup warnings, for examples due to different publishing frequencies within the tf_tree)
  submap_publish_period_sec = 0.3,
  pose_publish_period_sec = 5e-3,
  trajectory_publish_period_sec = 30e-3,
  --consider to modify the following sampling ratios
  --check publishing rates with rostopic hz /topic
  rangefinder_sampling_ratio = 1., 
  odometry_sampling_ratio = 1.,
  fixed_frame_pose_sampling_ratio = 1.,
  imu_sampling_ratio = 1.,
  landmarks_sampling_ratio = 1.,
}

MAP_BUILDER.use_trajectory_builder_3d = true
MAP_BUILDER.num_background_threads = 4

TRAJECTORY_BUILDER_3D.num_accumulated_range_data = 50

POSE_GRAPH.optimization_problem.huber_scale = 5e2
POSE_GRAPH.optimize_every_n_nodes = 10
POSE_GRAPH.constraint_builder.sampling_ratio = 0.03
POSE_GRAPH.optimization_problem.ceres_solver_options.max_num_iterations = 10
POSE_GRAPH.constraint_builder.min_score = 0.62
POSE_GRAPH.constraint_builder.global_localization_min_score = 0.66
POSE_GRAPH.matcher_translation_weight = 1e5
POSE_GRAPH.matcher_rotation_weight = 0.0001

return options