cmake_minimum_required(VERSION 3.8)
project(utilities)

if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
endif()
if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()


# find dependencies
find_package(ament_cmake REQUIRED)
find_package(ament_cmake_python REQUIRED)
find_package(rclpy REQUIRED)
find_package(geometry_msgs REQUIRED)


# Install Python modules
ament_python_install_package(${PROJECT_NAME})

# Install Python executables
install(PROGRAMS
  utilities/pub_cmd_vel_from_csv.py
  DESTINATION lib/${PROJECT_NAME})


# # Install launch files directory
# install(DIRECTORY
#   launch
#   config
#   DESTINATION share/${PROJECT_NAME})

ament_package()
