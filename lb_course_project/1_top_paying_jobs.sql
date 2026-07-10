/* this calculates the top paying jobs for your desired position
data is from 2023
variables will be marked for your convenience
shouts to luke barousse */

SELECT
    job_title,
    name AS company,
    job_title_short AS position,
    salary_year_avg AS salary,
    job_location AS location
FROM
    job_postings_fact
LEFT JOIN
    company_dim
    ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short LIKE '%Business%' -- enter search between percent signs (%%)
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
;
