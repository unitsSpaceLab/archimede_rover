-- @author: Marco Giberna
-- @email: marco.giberna@studenti.units.it
-- @email: marcogiberna@gmail.com

TRAJECTORY_BUILDER_2D = {
    use_imu_data = true,
    min_range = 0.,
    max_range = 30.,
    min_z = -0.8,
    max_z = 2.,
    missing_data_ray_length = 5.,
    num_accumulated_range_data = 1,
    voxel_filter_size = 0.025,
  
    adaptive_voxel_filter = {
      max_length = 0.5,
      min_num_points = 200,
      max_range = 50.,
    },
  
    loop_closure_adaptive_voxel_filter = {
      max_length = 0.9,
      min_num_points = 100,
      max_range = 50.,
    },
  
    use_online_correlative_scan_matching = false,
    real_time_correlative_scan_matcher = {
      linear_search_window = 0.1,
      angular_search_window = math.rad(20.),
      translation_delta_cost_weight = 1e-1,
      rotation_delta_cost_weight = 1e-1,
    },
}