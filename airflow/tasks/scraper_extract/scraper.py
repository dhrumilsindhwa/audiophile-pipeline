import re
import csv
import pathlib
import logging
import requests
from bs4 import BeautifulSoup

script_path = pathlib.Path(__file__).parent.resolve()

logging.basicConfig(filename="/tmp/logs.log", level=logging.INFO)
# truncating log file before new run
with open("/tmp/logs.log", "w"):
    pass

class Scraper:
    """
    Encapsulates all the logic for the web scraper.
    """

    def __init__(self) -> None:
        self.base_url = "https://crinacle.com/rankings/"

    def clean_headers(self, headers: list) -> list:

        clean_headers = []

        for header in headers:
            # Remove unnecessary terms
            if "(" in header or "/" in header:
                header = header.split(" ")[0]

            # Rename header for conformity between both IEMS and headphones
            if "Setup" == header:
                header = "driver_type"

            # Convert to snake_case
            clean_headers.append(
                re.sub(r"(?<=[a-z])(?=[A-Z])|[^a-zA-Z]", " ", header).replace(" ", "_").lower()
            )

        return clean_headers

    def scrape(self, device_type: str) -> list:

        url = self.base_url + device_type
        headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36"}
        try:
            response = requests.get(url, headers=headers)
            soup = BeautifulSoup(response.text, "html.parser")
        except requests.exceptions.RequestException as e:
            logging.error(e)
            return []

        # Find all tables within page, in this case, the only one
        data_table = soup.findChildren("table")[0]

        # Get all the headers for the table
        thead = data_table.find_all("thead", recursive=False)
        headers = thead[0].findChildren("th")
        headers = [cell.text for cell in headers]
        headers = self.clean_headers(headers)

        # Get all rows within the table (excluding links)
        tbody = data_table.find_all("tbody", recursive=False)
        rows = tbody[0].find_all("tr", recursive=False)

        device_data = []

        for row in rows:
            row_data = {}
            cells = row.find_all("td", recursive=False)
            if all(cell.get_text().strip() == "" for cell in cells):
                continue
            for i, cell in enumerate(cells):
                row_data[headers[i]] = cell.get_text()
            device_data.append(row_data)

        return device_data

    def convert_to_csv(self, device_data: list, device_type: str, data_level: str) -> None:

        with open(f"./{device_type}-{data_level}.csv", "w", encoding="utf-8") as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=device_data[0].keys())
            writer.writeheader()
            writer.writerows(device_data)


if __name__ == "__main__":
    scraper = Scraper()
    headphones = scraper.scrape(device_type="headphones")
    iems = scraper.scrape(device_type="iems")

    scraper.convert_to_csv(device_data=headphones, device_type="headphones", data_level="bronze")
    scraper.convert_to_csv(device_data=iems, device_type="iems", data_level="bronze")

