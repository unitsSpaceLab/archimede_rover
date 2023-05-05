-- @author: Marco Giberna
-- @email: marco.giberna@studenti.units.it
-- @email: marcogiberna@gmail.com

include "trajectory_builder_2d.lua"
include "trajectory_builder_3d.lua"

TRAJECTORY_BUILDER = {
  trajectory_builder_2d = TRAJECTORY_BUILDER_2D,
  trajectory_builder_3d = TRAJECTORY_BUILDER_3D,
--  pure_localization_trimmer = {
--    max_submaps_to_keep = 3,
--  },
  collate_fixed_frame = true,
  collate_landmarks = false,
}