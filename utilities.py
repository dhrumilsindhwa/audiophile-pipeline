import csv
import os


def convert_to_csv(device_data: list, device_type: str, data_level: str) -> None:
    """Converts a list of dictionaries to a csv file
    """
    output_folder = "output"
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    with open(f"{output_folder}/{device_type}-{data_level}.csv", "w", encoding="utf-8") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=device_data[0].keys())
        writer.writeheader()
        writer.writerows(device_data)
