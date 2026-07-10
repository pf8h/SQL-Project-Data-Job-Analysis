SELECT * FROM job_postings_fact LIMIT 1;

SELECT    
    job_schedule_type,
    AVG(salary_year_avg) AS salary,
    AVG(salary_hour_avg) AS wage
FROM
    job_postings_fact
WHERE 
    job_posted_date > '2023-06-1'
GROUP BY
    job_schedule_type
;

SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS month_,
    COUNT(job_id) AS qty_jobs
FROM
    job_postings_fact
GROUP BY
    month_
ORDER BY
    month_ ASC;

SELECT
    job_postings_fact.job_health_insurance::BOOLEAN AS health_insur,
    company_dim.name AS company,
    job_posted_date
FROM 
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_posted_date >= '2023-04-01'
    AND job_posted_date < '2023-07-01'
    AND job_health_insurance IS TRUE
ORDER BY
    job_posted_date ASC
    ;

CREATE TABLE jobs_2023_01;
CREATE TABLE jobs_2023_02;
CREATE TABLE jobs_2023_03;

SELECT 
    *
FROM 
    job_postings_fact
WHERE 
    EXTRACT(MONTH FROM job_posted_date) = 1
;

CREATE TABLE jobs_2023_01 AS
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 1
;
CREATE TABLE jobs_2023_02 AS
    SELECT
        *
    FROM    
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 2
;
CREATE TABLE jobs_2023_03 AS
    SELECT 
        * 
    FROM 
        job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3
;

SELECT EXTRACT(MONTH FROM job_posted_date)
FROM jobs_2023_02;

CREATE TABLE test(
    test VARCHAR(5)
);
DROP TABLE test;

SELECT EXTRACT(MONTH FROM job_posted_date)
FROM jobs_2023_03;

DROP TABLE jobs_2023_01;
DROP TABLE jobs_2023_02;
DROP TABLE jobs_2023_03;

CREATE TABLE jobs_2023_01 AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;
CREATE TABLE jobs_2023_02 AS
    EXTRACT(MONTH FROM job_posted_date) = 2;
CREATE TABLE jobs_2023_03 AS
    EXTRACT(MONTH FROM job_posted_date) = 3;

CREATE TABLE jobs_2023_01 AS
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 1
;
CREATE TABLE job_2023_02 AS
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 2
;
CREATE TABLE job_2023_03 AS
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 3
;

SELECT * FROM jobs_2023_01;
SELECT * FROM jobs_2023_02;

RENAME TABLE 
    job_2023_02 TO jobs_2023_02;
RENAME TABLE
    job_2023_03 TO jobs_2023_03;

ALTER TABLE job_2023_02
RENAME TO jobs_2023_02;
ALTER TABLE job_2023_03
RENAME TO jobs_2023_03;

SELECT * FROM jobs_2023_02;
SELECT * FROM jobs_2023_03;

SELECT EXTRACT(MONTH FROM job_posted_date)
FROM jobs_2023_02;

SELECT EXTRACT(MONTH FROM job_posted_date)
FROM jobs_2023_03;

SELECT
    job_title_short,
    job_location,
    CASE
            WHEN job_location = 'New York, NY' THEN 'Local'
            WHEN job_location = 'Anywhere' THEN 'Remote'
            ELSE 'Onsite'
        END AS my_location
FROM
    job_postings_fact
;

SELECT
    CASE
            WHEN job_location = 'New York, NY' THEN 'Local'
            WHEN job_location = 'Anywhere' THEN 'Remote'
            ELSE 'Onsite'
        END AS site_location,
    COUNT(job_id) AS qty_jobs
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    site_location
;

SELECT
    CASE
        WHEN salary_year_avg >= 70000 AND salary_year_avg <= 110000 THEN 'mid'
        WHEN salary_year_avg > 110000 THEN 'high'
        ELSE 'low'
        END AS salary_bracket,
    COUNT(job_id) AS qty_jobs
FROM
    job_postings_fact
WHERE
    job_title_short = 'Business Analyst'
GROUP BY salary_bracket
ORDER BY qty_jobs DESC
;

SELECT * FROM job_postings_fact
LIMIT 1;

SELECT 
     (SELECT
        name
    FROM
        company_dim) AS company_,
    job_title_short,
    job_location,
    job_via,
    job_work_from_home,
    job_health_insurance,
    salary_year_avg,
    salary_hour_avg
FROM
    job_postings_fact
WHERE
    job_title_short LIKE '&Analyst&'
;

-- get company name for jobs that have health insurance
SELECT 
    name AS company
FROM 
    company_dim
WHERE
    company_id IN (
        SELECT
            company_id
        FROM
            job_postings_fact
        WHERE
            job_health_insurance IS TRUE
    )
;

SELECT
    name AS company
FROM
    company_dim
WHERE
    company_id IN
        (SELECT
            company_id
        FROM
            job_postings_fact
        WHERE
            job_no_degree_mention IS TRUE)
;

WITH company AS(
    SELECT name
    FROM company_dim
)
;
SELECT
    company,
    COUNT(job_id) AS qty_jobs
FROM
    job_postings_fact
GROUP BY company
ORDER BY qty_jobs
;

--2:38:00
SELECT
    company_dim.name,
    COUNT(job_postings_fact.job_id) AS qty_jobs
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
GROUP BY
    company_dim.name
ORDER BY
    qty_jobs DESC
;

SELECT
    (SELECT
        name
    FROM
        company_dim) AS company,
    COUNT(job_id) AS qty_jobs
FROM
    job_postings_fact
GROUP BY
    company
ORDER BY
    qty_jobs
;

WITH company AS (
    SELECT name
    FROM company_dim)
;
SELECT
    company,
    COUNT(job_id) AS qty_jobs
FROM
    job_postings_fact
GROUP BY    
    company
ORDER BY
    qty_jobs DESC
;

WITH jobs_per_company AS(
    SELECT
        company_id,
        COUNT(job_id) AS qty_jobs
    FROM    
        job_postings_fact
    GROUP BY
        company_id
)
    ;
SELECT
    name,
    jobs_per_company
FROM
    company_dim 

WITH jobs_per_company AS (
    SELECT
        company_id,
        COUNT(job_id) AS qty_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
    )
SELECT
    name,
    jobs_per_company.qty_jobs
FROM
    company_dim
LEFT JOIN
    jobs_per_company ON company_dim.company_id =  jobs_per_company.company_id
ORDER BY
    qty_jobs DESC
;

SELECT
    skills AS skill,
    COUNT(skills_job_dim.job_id) AS qty_jobs
FROM
    skills_dim
LEFT JOIN
    skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY
    skills
ORDER BY
    qty_jobs DESC
LIMIT 5;

SELECT
    skills AS skill,
    (SELECT
        COUNT(job_id) as qty_jobs
    FROM
        skills_job_dim)
FROM
    skills_dim
GROUP BY
    skills
ORDER BY
    qty_jobs DESC
LIMIT
    5
;

SELECT
    name,
    (SELECT
            COUNT(job_id)
        FROM
            job_postings_fact
        GROUP BY
            company_id) AS  qty_job_postings,
    CASE
        WHEN COUNT(company_id) >= 10 AND COUNT(company_id) <= 50 THEN 'med'
        WHEN COUNT(company_id) > 50 THEN 'large'
        ELSE 'small'
        END AS size
FROM
    company_dim
GROUP BY
    name
;

SELECT
    skills,
    COUNT(job_id) AS qty_jobs
FROM
    skills_dim
LEFT JOIN
    skills_job_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY
    skills
ORDER BY
    qty_jobs DESC
LIMIT
    5
;

SELECT
    skills,
    (SELECT
        COUNT(job_id)
        FROM
        skills_job_dim
        ) AS qty_jobs
FROM
    skills_dim
GROUP BY
    skills
ORDER BY
    qty_jobs
LIMIT 5
;

SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS qty_jobs
FROM
    skills_dim
LEFT JOIN
    skills_job_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY
    skills
ORDER BY
    qty_jobs DESC
LIMIT
    5
;

SELECT
    name AS company,
    COUNT(postings.job_id) AS qty_jobs,
    CASE
        WHEN COUNT(postings.job_id) > 50 THEN 'Large'
        WHEN COUNT(postings.job_id) <= 50 AND COUNT(postings.job_id) >= 10 THEN 'Medium'
        ELSE 'Small'
        END AS company_size
FROM
    company_dim
LEFT JOIN
    job_postings_fact AS postings
    ON company_dim.company_id = postings.company_id
GROUP BY
    company
;

WITH cte_qty_jobs AS(
    SELECT
        job_id,
        COUNT(job_id) AS qty_jobs
    FROM
        job_postings_fact
    WHERE
        job_work_from_home IS TRUE
)
SELECT
    skills,
    skill_id,
    cte_qty_jobs.qty_jobs AS qty_postings
FROM
    skills_dim
LEFT JOIN
    skills_job_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
LEFT JOIN
    cte_qty_jobs
    ON skills_job_dim.job_id = cte_qty_jobs._job_id
GROUP BY
    skills
ORDER BY
    qty_postings DESC
LIMIT
    5
;

WITH cte_qty_jobs AS(
    SELECT
        job_postings_fact.job_id AS job_id_,
        skills_job_dim.skill_id AS cte_link
    FROM
    skills_job_dim
    LEFT JOIN
        job_postings_fact
            ON skills_job_dim.job_id = job_postings_fact.job_id
    GROUP BY
        skill_id    
)
SELECT
    skills,
    skills_dim.skill_id AS skill_id_,
    COUNT(cte_qty_jobs.job_id_) AS qty_jobs
FROM
    skills_dim
LEFT JOIN
    cte_qty_jobs
    ON skills_dim.skill_id = cte_qty_jobs.cte_link
GROUP BY
    skills
ORDER BY
    cte_qty_jobs.qty_jobs DESC
LIMIT
    5
;

WITH AS(GROUP BY)

WITH AS (
    SELECT
        COUNT(job_postings_fact.job_id) AS qty_remote_jobs
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_work_from_home IS TRUE
)

-- top 5 skills for remote jobs
WITH CTE_LINK AS (
    SELECT
        skills_job_dim.skill_id AS LINK,
        COUNT(skills_job_dim.job_id) AS qty_jobs
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_work_from_home IS TRUE
    GROUP BY
        skills_job_dim.skill_id
)
SELECT
    skill_id,
    skills,
    qty_jobs
FROM
    skills_dim
INNER JOIN
    CTE_LINK on CTE_LINK.LINK = skills_dim.skill_id
GROUP BY
    skills
ORDER BY
    qty_jobs DESC
LIMIT
    5
;

WITH CTE_LINK AS (
    SELECT
        skill_id,
        COUNT(job_postings_fact.job_id) AS qty_jobs
    FROM
        skills_job_dim
    INNER JOIN
        job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_work_from_home IS TRUE
    GROUP BY 
        skill_id
)
SELECT
    skills_dim.skill_id,
    skills AS skill,
    qty_jobs
FROM
    skills_dim
INNER JOIN
    CTE_LINK ON CTE_LINK.skill_id = skills_dim.skill_id
ORDER BY
    qty_jobs DESC
LIMIT
    5
;

WITH CTE_LINK AS (
    SELECT
        skills_job_dim.skill_id AS LINK,
        COUNT(job_postings_fact.job_id) AS qty_jobs_remote
    FROM
        skills_job_dim
    INNER JOIN
        job_postings_fact
        ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_postings_fact.job_work_from_home IS TRUE
    GROUP BY
        skills_job_dim.skill_id
)
SELECT
    skills_dim.skills AS skill,
    skills_dim.skill_id AS skill_id,
    CTE_LINK.qty_jobs_remote AS qty_jobs_remote
FROM
    skills_dim
INNER JOIN
    CTE_LINK
    ON CTE_LINK.LINK = skills_dim.skill_id
ORDER BY
    qty_jobs_remote DESC
LIMIT
    5
;

SELECT
    skills,
    skills_dim.skill_id,
    COUNT(skills_job_dim.job_id) AS qty_jobs
FROM
    skills_dim
INNER JOIN
    skills_job_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
INNER JOIN
    job_postings_fact
    ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    job_work_from_home IS TRUE
GROUP BY
    skills_dim.skill_id
ORDER BY 
    qty_jobs DESC
LIMIT
    5
;

WITH CTE_LINK AS (
    SELECT
        skill_id,
        COUNT(skills_job_dim.job_id) AS qty_jobs
    FROM
        skills_job_dim
    INNER JOIN
        job_postings_fact
        ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_work_from_home IS TRUE
    GROUP BY
        skill_id
)
SELECT
    skills,
    CTE_LINK.skill_id,
    qty_jobs AS remote_jobs
FROM
    skills_dim
INNER JOIN
    CTE_LINK
    ON CTE_LINK.skill_id = skills_dim.skill_id
ORDER BY
    qty_jobs DESC
LIMIT
    5
;

SELECT  
    EXTRACT(MONTH FROM job_posted_date)
FROM
    jobs_2023_01
UNION ALL
SELECT
    EXTRACT(MONTH FROM job_posted_date)
FROM
    jobs_2023_02
;

SELECT
    *
FROM
    jobs_2023_01
UNION
SELECT
    *
FROM
    jobs_2023_02
UNION
SELECT
    *
FROM
    jobs_2023_03
;

WITH CTE_SKILL AS (
    SELECT
        skill_id
        skills,
        type
    FROM
        skills_dim
)
SELECT

FROM
    jobs_2023_01
RIGHT JOIN
    skills_job_dim
    ON skills_job_dim.job_id = jobs_2023_01.job_id
RIGHT JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE   
    salary_year_avg < 70000
UNION ALL
SELECT

FROM
    jobs_2023_02
WHERE
    salary_year_avg < 70000
UNION ALL
SELECT

FROM
    jobs_2023_03
WHERE
    salary_year_avg < 70000
;

SELECT
    skills_dim.skills,
    skills_dim.type
FROM
    skills_dim
LEFT JOIN
    job_2023_01

SELECT
    skills,
    type,
    EXTRACT(MONTH FROM job_posted_date) AS month_,
    salary_year_avg AS salary
FROM
    skills_dim
LEFT JOIN
    skills_job_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
LEFT JOIN
    jobs_2023_01
    ON jobs_2023_01.job_id = skills_job_dim.job_id
WHERE
    salary_year_avg < 70000
UNION ALL
SELECT
    skills,
    type,
    EXTRACT(MONTH FROM job_posted_date) AS month_,
    salary_year_avg AS salary
FROM
    skills_dim
LEFT JOIN
    skills_job_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
LEFT JOIN
    jobs_2023_02
    ON jobs_2023_02.job_id = skills_job_dim.job_id
WHERE
    salary_year_avg < 70000
UNION ALL
SELECT
    skills,
    type,
    EXTRACT(MONTH FROM job_posted_date) AS month_,
    salary_year_avg AS salary
FROM
    skills_dim
LEFT JOIN
    skills_job_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
LEFT JOIN
    jobs_2023_03
    ON jobs_2023_03.job_id = skills_job_dim.job_id
WHERE
    salary_year_avg < 70000
;

SELECT
    *
FROM
    jobs_2023_01
WHERE
    salary_year_avg > 70000
UNION ALL
SELECT
    *
FROM
    jobs_2023_02
WHERE
    salary_year_avg > 70000
UNION ALL
SELECT
    *
FROM
    jobs_2023_03
WHERE
    salary_year_avg > 70000
;

SELECT
    q1_job_postings.job_title_short AS position,
    q1_job_postings.salary_year_avg AS salary,
    q1_job_postings.job_location AS location_,
    q1_job_postings.job_work_from_home AS wfh,
    q1_job_postings.job_health_insurance AS health_insurance,
    EXTRACT(MONTH FROM q1_job_postings.job_posted_date) AS month_
FROM
    (
        SELECT * FROM jobs_2023_01 UNION ALL
        SELECT * FROM jobs_2023_02 UNION ALL
        SELECT * FROM jobs_2023_03
    ) AS q1_job_postings
WHERE
    salary_year_avg > 70000
ORDER BY
    month_ DESC
;

SELECT
    *
FROM
    skills_dim
LIMIT 50
;