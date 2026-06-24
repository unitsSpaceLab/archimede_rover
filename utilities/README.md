# Occasional utilities


* ***bag_to_csv.py*** : extract all the topics data containt in a ros2 bag and writes them to .csv files.

    **usage**: ```python3 bag_to_csv.py /path/to/bag```, where ```bag``` is a folder with the following initial structure (automatically created when the bag is saved):
    ```
    bag
    ├── bag_0.db3
    └── metadata.yaml
    ```
    This will create a ***topic_csvs*** folder within bag folder (or use an existing one if already exists), which will contain the csv files named by topic. Final structure:
    ```
    bag
    ├── bag_0.db3
    ├── metadata.yaml
    └── topic_csvs
        ├── _topic_name1.csv
        ├── ...
        └── _topic_nameN.csv
    ```

* ***pub_cmd_vel_from_csv.py*** : runs a ros2 node that reads high level command velocity data from a csv file and publishes them at the specified timestamp. Published topic and csv file path are hardcoded for now, change them from the code. Check ***util_files/cmd_vel_sequence.py*** for an example of csv file structure.

    **usage**: ```ros2 run utilities pub_cmd_vel_from_csv.py```
