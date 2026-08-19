/* this shows the most optimal skills for the analytics field, based on demand and salary
data is from 2023
variables will be marked for your convenience
shouts luke barousse */

WITH ids AS (
        SELECT
            skills,
            MAX(type) AS category,
            COUNT(skills_job_dim.job_id) AS qty_jobs,
            ARRAY_AGG(DISTINCT job_title_short) AS position
        FROM
            skills_dim
        INNER JOIN
            skills_job_dim
            ON skills_job_dim.skill_id = skills_dim.skill_id
        INNER JOIN
            job_postings_fact
            ON job_postings_fact.job_id = skills_job_dim.job_id
        GROUP BY
            skills
    ),
tps AS (
    SELECT
        skills,
        ROUND(AVG(salary_year_avg),2) AS avg_salary,
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
    GROUP BY
        skills
)
SELECT
    ids.skills AS skill,
    ids.qty_jobs AS demand,
    tps.avg_salary AS avg_salary,
    tps.category AS category
FROM
    ids
INNER JOIN
    tps
    ON tps.skills = ids.skills
WHERE
    ids.qty_jobs >= 25 -- enter minimum number of jobs skill is used in
ORDER BY -- order can be rearranged according to priority
    demand DESC,
    avg_salary DESC
;

/* the above version copy/pastes files 3 & 4. this is an alternate version, which omits cte for conciseness and includes a filter for your desired position

SELECT
    skills,
    MAX(type) AS category,
    COUNT(job_postings_fact.job_id) AS demand,
    ROUND(AVG(salary_year_avg),2) AS avg_salary,
    ARRAY_AGG(DISTINCT job_title_short) AS position
FROM
    skills_dim
INNER JOIN
    skills_job_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
INNER JOIN
    job_postings_fact
    ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE 
    job_title_short LIKE '%Analyst%' -- enter search between percent signs (%%)
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
HAVING
    COUNT(job_postings_fact.job_id) >= 25 -- enter minimum number of jobs skill is used in
ORDER BY -- order can be rearranged according to priority
    demand DESC,
    avg_salary DESC
;
*/