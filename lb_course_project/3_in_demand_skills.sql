/* this shows the most desired skills for your desired position
data is from 2023
variables will be marked for your convenience
shouts to luke barousse */

SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS qty_jobs,
    ARRAY_AGG(DISTINCT job_title_short) AS positions
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
GROUP BY
    skills
ORDER BY
    qty_jobs DESC
;