-- @author: Marco Giberna
-- @email: marco.giberna@studenti.units.it
-- @email: marcogiberna@gmail.com

include "pose_graph.lua"

MAP_BUILDER = {
  use_trajectory_builder_2d = false,
  use_trajectory_builder_3d = false,
  num_background_threads = 4,
  pose_graph = POSE_GRAPH,
  collate_by_trajectory = false,
}