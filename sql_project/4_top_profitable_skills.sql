/* this shows the top skills based on salary for your desired position
date is from 2023
variables will be marked for your convenience
shouts to luke barousse */

SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary,
    MAX(type) AS category,
    ARRAY_AGG(DISTINCT job_title_short) AS position
FROM skills_dim
INNER JOIN
    skills_job_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
INNER JOIN
    job_postings_fact
    ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    salary_year_avg IS NOT NULL
    AND job_title_short LIKE '%Business%' -- enter search between percent signs (%%)
GROUP BY
    skills
HAVING
    COUNT(skills_job_dim.job_id) >= 25 -- enter minimum number of jobs skill is used in
ORDER BY
    avg_salary DESC
;