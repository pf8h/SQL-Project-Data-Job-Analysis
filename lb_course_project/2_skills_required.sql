/* this shows the skills required for the top paying jobs of your desired position
data is from 2023
variables will be marked for your convenience
shouts to luke barousse */

WITH tpj AS (
    SELECT
        job_title,
        name AS company,
        salary_year_avg AS salary,
        job_location,
        job_title_short AS position,
        job_id
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
),
skill_order AS (
    SELECT
        skill_id,
        COUNT(skill_id) OVER (PARTITION BY skill_id) AS skill_count,
        job_id
    FROM
        skills_job_dim
    ORDER BY
        skill_count DESC
)
SELECT
    job_title,
    ARRAY_AGG(DISTINCT salary) AS salary,
    ARRAY_AGG(DISTINCT company) AS company,
    ARRAY_AGG(skills ORDER BY skill_count DESC) AS skills,
    ARRAY_AGG(DISTINCT position) AS position
FROM
    tpj
INNER JOIN
    skills_job_dim
    ON skills_job_dim.job_id = tpj.job_id
INNER JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN
    skill_order
    ON skill_order.job_id = tpj.job_id
    AND skill_order.skill_id = skills_job_dim.skill_id
GROUP BY
    job_title
ORDER BY
    salary DESC
LIMIT
    100
;