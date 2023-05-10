import sys
import boto3
import pathlib
from dotenv import dotenv_values
from botocore.exceptions import ClientError, NoCredentialsError

script_path = pathlib.Path(__file__).parent.resolve()
config = dotenv_values(f"{script_path}/configuration.env")

data_level = sys.argv[1]
files = [f"/opt/headphones-{data_level}.csv", f"/opt/iems-{data_level}.csv"]

AWS_BUCKET = config["bucket_name"]


def connect_s3():

    try:
        s3_conn = boto3.resource("s3")
        return s3_conn
    except NoCredentialsError as e:
        raise (e)


def upload_csv_s3():

    s3_conn = connect_s3()
    for file in files:
        s3_conn.meta.client.upload_file(Filename=f"/opt/{file}", Bucket=AWS_BUCKET, Key=file)


if __name__ == "__main__":
    upload_csv_s3()