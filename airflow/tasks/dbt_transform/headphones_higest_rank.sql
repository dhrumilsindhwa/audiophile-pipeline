WITH iem_ranks AS (
    SELECT DISTINCT
        rank_grade,
        CASE
            WHEN rank_grade = 'S+' THEN 10
            WHEN rank_grade = 'S' THEN 10.5
            WHEN rank_grade = 'S-' THEN 11
            WHEN rank_grade = 'A+' THEN 11.5
            WHEN rank_grade = 'A' THEN 12
            WHEN rank_grade = 'A-' THEN 12.5
            WHEN rank_grade = 'B+' THEN 13
            WHEN rank_grade = 'B' THEN 13.5
            WHEN rank_grade = 'B-' THEN 14
            WHEN rank_grade = 'C+' THEN 14.5
            WHEN rank_grade = 'C' THEN 15
            WHEN rank_grade = 'C-' THEN 15.5
            WHEN rank_grade = 'D+' THEN 16
            WHEN rank_grade = 'D' THEN 16.5
            WHEN rank_grade = 'D-' THEN 17
            WHEN rank_grade = 'E+' THEN 17.5
            WHEN rank_grade = 'E' THEN 18
            WHEN rank_grade = 'E-' THEN 18.5
            WHEN rank_grade = 'F+' THEN 19
            WHEN rank_grade = 'F' THEN 19.5
            WHEN rank_grade = 'F-' THEN 20
            ELSE NULL
        END AS rank_value
    FROM
        inearmonitor
),
headphone_ranks AS (
    SELECT DISTINCT
        rank_grade,
        CASE
            WHEN rank_grade = 'S+' THEN 10
            WHEN rank_grade = 'S' THEN 10.5
            WHEN rank_grade = 'S-' THEN 11
            WHEN rank_grade = 'A+' THEN 11.5
            WHEN rank_grade = 'A' THEN 12
            WHEN rank_grade = 'A-' THEN 12.5
            WHEN rank_grade = 'B+' THEN 13
            WHEN rank_grade = 'B' THEN 13.5
            WHEN rank_grade = 'B-' THEN 14
            WHEN rank_grade = 'C+' THEN 14.5
            WHEN rank_grade = 'C' THEN 15
            WHEN rank_grade = 'C-' THEN 15.5
            WHEN rank_grade = 'D+' THEN 16
            WHEN rank_grade = 'D' THEN 16.5
            WHEN rank_grade = 'D-' THEN 17
            WHEN rank_grade = 'E+' THEN 17.5
            WHEN rank_grade = 'E' THEN 18
            WHEN rank_grade = 'E-' THEN 18.5
            WHEN rank_grade = 'F+' THEN 19
            WHEN rank_grade = 'F' THEN 19.5
            WHEN rank_grade = 'F-' THEN 20
            ELSE NULL
        END AS rank_value
    FROM
        headphone
),
mapped_ranks AS (
    SELECT
        rank_grade,
        rank_value
    FROM iem_ranks
    UNION
    SELECT
        rank_grade,
        rank_value
    FROM headphone_ranks
),
headphone_companies AS (
    SELECT
        DISTINCT SPLIT_PART(model, ' ', 1) AS company_name
    FROM
        headphone
),
inearmonitor_companies AS (
    SELECT
        DISTINCT SPLIT_PART(model, ' ', 1) AS company_name
    FROM
        inearmonitor
),
all_companies AS (
    SELECT company_name FROM headphone_companies
    UNION
    SELECT company_name FROM inearmonitor_companies
),
final AS (
    SELECT
        all_companies.company_name,
        AVG(mapped_ranks.rank_value) AS average_rating,
        COUNT(all_companies.company_name) AS number_of_products
    FROM
        headphone,
        mapped_ranks,
        all_companies
    WHERE
        headphone.rank_grade = mapped_ranks.rank_grade
        AND all_companies.company_name = SPLIT_PART(headphone.model, ' ', 1)
    GROUP BY
        all_companies.company_name
)
SELECT
    *
FROM
    final
