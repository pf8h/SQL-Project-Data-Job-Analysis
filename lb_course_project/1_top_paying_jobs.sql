/* this calculates the top paying jobs for your desired position
data is from 2023
variables will be marked for your convenience
shouts to luke barousse */

SELECT
    job_title,
    salary_year_avg AS salary,
    name AS company,
    job_location,
    job_title_short AS position
FROM
    job_postings_fact
LEFT JOIN
    company_dim
    ON company_dim.company_id = job_postings_fact.company_id
WHERE
    salary_year_avg IS NOT NULL
    AND job_title_short LIKE '%Business%' -- enter search between percent signs (%%)
ORDER BY
    salary_year_avg DESC
LIMIT 
    100
;
