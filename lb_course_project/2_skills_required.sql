/* this shows the skills required for your desired position
data is from 2023
variables will be marked for your convenience
shouts to luke barousse */

SELECT DISTINCT
    skills,
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
    job_title_short LIKE '%Analyst%' -- enter search between percent signs (%%)
GROUP BY
    skills
;


SELECT
    skills,
    --type,
    job_title_short
FROM
    skills_dim
LEFT JOIN
    skills_job_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
LEFT JOIN
    job_postings_fact
    ON job_postings_face.job_id = skills_job_dim.job_id

;