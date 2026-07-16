/* this shows the most optimal skills for your position, based on salary and demand
data is from 2023
variables will be marked for your convenience
shouts luke barousse */

WITH ids AS (
    SELECT
        skills,
        ARRAY_AGG(DISTINCT type) AS category,
        COUNT(skills_job_dim.job_id) AS qty_jobs,
        ARRAY_AGG(DISTINCT job_title_short) AS position,
        skill_jobs_dim.skill_id AS link_1
    FROM
        skills_dim
    INNER JOIN
        skills_job_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    INNER JOIN
        job_postings_fact
        ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_title_short LIKE '%Business%' -- enter search between percent signs (%%)
    GROUP BY
        skills
    ORDER BY
        qty_jobs DESC
),
tps AS (
    SELECT
    skills,
    ROUND(AVG(salary_year_avg),2) AS avg_salary,
    ARRAY_AGG(DISTINCT type) AS category,
    ARRAY_AGG(DISTINCT job_title_short) AS position,
    skills_job_dim.skill_id AS link_2
FROM skills_dim
LEFT JOIN
    skills_job_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
LEFT JOIN
    job_postings_fact
    ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    salary_year_avg IS NOT NULL
    AND job_title_short LIKE '%Business%' -- enter search between percent signs (%%)
GROUP BY
    skills
HAVING
    COUNT(skills_job_dim.job_id) >= 25
ORDER BY
    avg_salary DESC
;
)