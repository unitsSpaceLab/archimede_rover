#!/usr/bin/env python3

import os
import sys
import csv
import rosbag2_py
import rclpy.serialization
from rosidl_runtime_py.utilities import get_message
from rosidl_runtime_py import message_to_ordereddict


def flatten_dict(d, parent_key=""):
    """
    Recursively flattens nested dictionaries and lists.
    """
    items = {}

    for k, v in d.items():
        new_key = f"{parent_key}_{k}" if parent_key else k

        if isinstance(v, dict):
            items.update(flatten_dict(v, new_key))

        elif isinstance(v, list):
            for i, item in enumerate(v):
                if isinstance(item, dict):
                    items.update(flatten_dict(item, f"{new_key}_{i}"))
                else:
                    items[f"{new_key}_{i}"] = item

        else:
            items[new_key] = v

    return items


def main(bag_path):

    if not os.path.exists(bag_path):
        print(f"Bag path {bag_path} does not exist.")
        return

    output_dir = os.path.join(bag_path, "topic_csvs")
    if os.path.exists(output_dir):
        print(f"Output folder is [{output_dir}]")
    else:
        os.makedirs(output_dir)
        print(f"Created output directory [{output_dir}]")

    reader = rosbag2_py.SequentialReader()

    storage_options = rosbag2_py.StorageOptions(
        uri=bag_path,
        storage_id="sqlite3"
    )

    converter_options = rosbag2_py.ConverterOptions(
        input_serialization_format="cdr",
        output_serialization_format="cdr"
    )

    reader.open(storage_options, converter_options)

    topic_types = reader.get_all_topics_and_types()
    type_map = {topic.name: topic.type for topic in topic_types}

    # Prepare CSV writers per topic
    csv_files = {}
    csv_writers = {}
    headers_written = {}

    print("Reading bag...")

    while reader.has_next():
        topic, data, timestamp = reader.read_next()

        msg_type = get_message(type_map[topic])
        msg = rclpy.serialization.deserialize_message(data, msg_type)

        msg_dict = message_to_ordereddict(msg)
        flat_msg = flatten_dict(msg_dict)

        # Prefix column names with topic name
        flat_msg = {
            f"_{k}": v
            for k, v in flat_msg.items()
        }

        flat_msg = {"timestamp": timestamp, **flat_msg}

        # Create CSV if first time seeing topic
        if topic not in csv_files:
            filename = os.path.join(output_dir, topic.replace("/", "_") + ".csv")
            f = open(filename, "w", newline="")
            writer = csv.DictWriter(f, fieldnames=flat_msg.keys())
            writer.writeheader()

            csv_files[topic] = f
            csv_writers[topic] = writer
            headers_written[topic] = True

            print(f"Created {filename}")

        # Write row
        csv_writers[topic].writerow(flat_msg)

    # Close files
    for f in csv_files.values():
        f.close()

    print("Done.")


if __name__ == "__main__":

    if len(sys.argv) != 2:
        print("Usage: python3 bag_to_csv.py <bag_folder>")
        sys.exit(1)

    main(sys.argv[1])