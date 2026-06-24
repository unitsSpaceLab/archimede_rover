#!/usr/bin/env python3.10

import rclpy
from rclpy.node import Node
from rclpy.parameter import Parameter
from geometry_msgs.msg import Twist
import pandas


class cmdVelPubNode(Node):
    def __init__(self):
        # import the cmd_vel file
        cmd_vel_path = '~/archimede_ros2_ws/src/archimede_rover/utilities/util_files/cmd_vel_sequence.csv'
        topic_name = 'Archimede/cmd_vel'
        use_sim_time = True

        self.file = pandas.read_csv(cmd_vel_path)

        super().__init__('cmd_vel_publisher_node',
            parameter_overrides=[Parameter("use_sim_time", Parameter.Type.BOOL, True)]
        )

        self.pub = self.create_publisher(Twist, topic_name,1)
        self.msg = Twist()

        timer_period = 0.02  # seconds
        self.timer = self.create_timer(timer_period, self.pub_cmd_vel)

        self.current_row = 0
        self.final_row = len(self.file.time) # for running until end of self.file

        # reset the files starting time
        self.file.time = self.file.time - self.file.time[self.current_row]
        # convert files timestamps second -> nanoseconds
        self.file.time = self.file.time * 1e9

        self.time_start = self.get_clock().now().nanoseconds

        self.get_logger().info('cmd_vel publisher node initialized')


    def pub_cmd_vel(self):
        if (self.get_clock().now().nanoseconds - self.time_start) < self.file.time[self.current_row]:
            return

        self.msg.linear.x = self.file.field_linear_x[self.current_row]
        self.msg.linear.y = self.file.field_linear_y[self.current_row]
        self.msg.linear.z = self.file.field_linear_z[self.current_row]
        self.msg.angular.x = self.file.field_angular_x[self.current_row]
        self.msg.angular.y = self.file.field_angular_y[self.current_row]
        self.msg.angular.z = self.file.field_angular_z[self.current_row]

        self.pub.publish(self.msg)

        self.current_row += 1

        if self.current_row == self.final_row:
            self.get_logger().info('Last message reached! Shutting down cmd_vel publisher node')
            return super().destroy_node()



def main(args=None) -> None:
    rclpy.init(args=args)
    node = cmdVelPubNode()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    node.destroy_node()
    rclpy.try_shutdown()


if __name__ == '__main__':
    main()