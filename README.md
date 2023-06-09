# End-to-End Data Pipeline for Audio Equipment Analysis with Terraform, Docker, Airflow, and Metabase

This project demonstrates an end-to-end data pipeline for audio equipment analysis, leveraging modern technologies and best practices in data engineering. The pipeline scrapes audio equipment data from Crinacle's website, processes and validates it, stores it in AWS cloud storage, and makes it available for further analysis and visualization through a Metabase dashboard. The project employs Terraform for infrastructure provisioning, Docker for containerization, and Apache Airflow for orchestration.

## Architecture

![Architecture Diagram](images/audiophile-flowchart.jpg)


Key Components:

1. Data Collection: The pipeline starts with a web scraping task that collects audio equipment data from Crinacle's website, generating the initial "bronze" dataset.
2. Data Storage: The bronze data is then loaded into an AWS S3 bucket for centralized storage and easy access.
3. Data Validation and Processing: The pipeline leverages Pydantic for initial data parsing and validation, transforming the bronze data into a cleaner "silver" dataset.
4. AWS Redshift and RDS Integration: The silver data is loaded into both AWS Redshift and RDS instances. Redshift is used for data warehousing and analytical processing, while RDS is available for use in future projects.
5. Data Transformation and Testing: The data is further transformed and tested using dbt, ensuring data quality and consistency in the warehouse.
6. Dashboard Creation: A Metabase dashboard is set up to visualize the processed data, providing insights into the audio equipment trends and performance.

## Dashboards
![Architecture Diagram](images/average_iem_ratings.png)

![Architecture Diagram](images/avg_headphones_rating.png)

![Architecture Diagram](images/headphoes-highest_rank_by_company.png)

![Architecture Diagram](images/IEM-highest_rank_by_company.png)

![Architecture Diagram](images/bang_2_buck_ratings.png)

![Architecture Diagram](images/total_count.png)

![Architecture Diagram](images/total_count_by_grade.png)

## Requirements:

> AWS CLI configuration with your AWS account.
> Terraform installed for provisioning AWS services.
> Docker and Docker-Compose installed for running Airflow and the pipeline.

## How to Run the Pipeline:

1. Run make infra to create the necessary AWS services. You will be prompted to enter a password for your Redshift and RDS clusters.
2. Run make config to generate a configuration file with Terraform outputs and your AWS credentials.
3. Run make base-build to build the base Airflow image with project requirements.
4. Run make build to build Docker images for Airflow.
5. Run make up to execute the pipeline.

This project showcases a comprehensive data engineering solution that integrates web scraping, data validation, storage, processing, and visualization. By utilizing Terraform, Docker, Airflow, and Metabase, this pipeline can be easily deployed, scaled, and maintained, providing a robust foundation for audio equipment analysis and future data-driven projects.
