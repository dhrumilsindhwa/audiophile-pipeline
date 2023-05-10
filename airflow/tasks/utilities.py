import csv


def convert_to_csv(device_data: list, device_type: str, data_level: str) -> None:

    with open(f"/tmp/{device_type}-{data_level}.csv", "w") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=device_data[0].keys())
        writer.writeheader()
        writer.writerows(device_data)