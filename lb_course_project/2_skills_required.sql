/* this shows the skills required for the top paying jobs of your desired position
data is from 2023
variables will be marked for your convenience
shouts to luke barousse */

WITH top_paying_jobs AS (
    SELECT
        job_title,
        name AS company,
        job_title_short AS position,
        salary_year_avg AS salary,
        job_location AS location,
        job_id
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
)
SELECT
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN
    skills_job_dim
    ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
LIMIT
    1000
;