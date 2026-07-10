/* this shows the top skills based on salary for your role
date is from 2023
variables will be marked for your convenience
shouts to luke barousse */

SELECT
    skills,
    AVG(salary_year_avg) AS avg_salary,
    ARRAY_AGG(DISTINCT type) AS category,
    ARRAY_AGG(DISTINCT job_title_short) AS used_by
FROM
    skills_dim
LEFT JOIN
    skills_job_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
LEFT JOIN
    job_postings_fact
    ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    job_title_short LIKE '%Business%' -- enter search between percent signs (%%)
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
;
