-- Active: 1758118886049@@localhost@5432@sfpolice@public
-- ============================================================
-- 1. Preview Data
-- ============================================================
SELECT * 
FROM public.police_incident_reports 
LIMIT 5;

SELECT pd_id, incident_num, incident_code, category, descript, 
    day_of_week, date, time, pd_district, resolution, 
    address, x, y, location, data_loaded_at
FROM public.police_incident_reports 
LIMIT 50;

-- ============================================================
-- 2. Time Range (min, max years)
-- ============================================================
SELECT 
    DATE_PART('year', MIN(date)) AS min_year, 
    DATE_PART('year', MAX(date)) AS max_year
FROM public.police_incident_reports;

-- ============================================================
-- 3. Exploratory Data Analysis
-- ============================================================
-- Number of police districts
SELECT COUNT(DISTINCT pd_district) AS num_districts
FROM police_incident_reports;

-- Number of unique addresses
SELECT COUNT(DISTINCT address) AS num_addresses
FROM police_incident_reports;

-- Incidents by address
SELECT address, COUNT(*) AS incident_count
FROM police_incident_reports
GROUP BY address
ORDER BY incident_count DESC;

-- Min, Max, Avg incidents by address [subquery]
SELECT 
    MIN(s.count) AS min_incidents, 
    AVG(s.count) AS avg_incidents,
    MAX(s.count) AS max_incidents 
FROM (
    SELECT address, COUNT(*) 
    FROM police_incident_reports 
    GROUP BY address) s;

-- Classification of addresses as High/Low incident density
SELECT address, COUNT(*) AS incident_count,
    CASE 
        WHEN COUNT(*) > (
            SELECT AVG(s.count) 
            FROM (
                SELECT address, COUNT(*) 
                    FROM police_incident_reports 
                    GROUP BY address) s
        ) THEN 'High'
        ELSE 'Low'
    END AS state
FROM police_incident_reports
GROUP BY address
ORDER BY incident_count DESC;

-- ============================================================
-- 4. Data Cleanup Examples
-- ============================================================
-- Data Cleaning using CASE WHEN and LIKE
-- Data Cleaning using TRIM, UPPER, LOWER, INITCAP, SUBSTRING, POSITION, LENGTH, CONCAT, REPLACE, TRANSLATE, REGEXP_REPLACE, REGEXP_MATCHES, REGEXP_SPLIT_TO_ARRAY, REGEXP_SPLIT_TO_TABLE, SPLIT_PART, TO_CHAR, TO_NUMBER, TO_DATE, TO_TIMESTAMP, TO_TIMESTAMP_TZ, TO_JSON, TO_JSONB, TO_ASCII, TO_HEX, TO_BASE64, TO_REGCLASS, TO_REGPROC, TO_REGPROCEDURE, TO_REGOPER, TO_RE
-- Deduplication using Group By and Distinct 
-- Type Conversion using CAST and :: 

-- Deduplication
SELECT DISTINCT * 
FROM police_incident_reports;

-- Type Conversion
SELECT pd_id, (pd_id * 2) AS double_id
FROM police_incident_reports
LIMIT 3;

-- String Functions
SELECT split_part(CAST(pd_id AS varchar), '0', 1) AS split_id
FROM police_incident_reports
LIMIT 3;

-- ============================================================
-- 5. Aggregate vs Window Functions
-- ============================================================
-- Aggregate Functions:
--   • Syntax: func(col) [WITH GROUP BY]
--   • Examples: SUM, AVG, COUNT, MIN, MAX
--   • Collapse rows → one row per group (or full table if no GROUP BY)
--   • Use case: overall stats or grouped summaries
--   • Similarity: same core functions as window functions
--   • Difference: aggregate reduces row count, window keeps all rows

-- Window Functions:
--   • Syntax: func(col) OVER ([PARTITION BY ...] [ORDER BY ...])
--   • Functions: aggregates (SUM, AVG, COUNT...) + ranking (ROW_NUMBER, RANK...) + navigation (LAG, LEAD...)
--   • Keep all rows → adds calculation as new column
--   • Do NOT collapse rows
--   • Use case: running totals, ranks, comparisons, distributions
-- ====================================
-- OVER
-- ====================================
--   • Syntax: func(col) OVER ([PARTITION BY ...] [ORDER BY ...])
--   • Behavior: applies aggregate logic row-by-row
--   • Difference: vs GROUP BY → does not collapse rows
--   • Use case: totals, per-group counts, running sums
-- Example: each row + total table count
SELECT category, incident_num,COUNT(incident_num) OVER() AS total_incidents
FROM police_incident_reports
LIMIT 5; 

-- Example: Normal Group By (collapses rows)
SELECT category, COUNT(incident_num) 
FROM police_incident_reports
GROUP BY category;

-- Example: Each row + total category
SELECT category, pd_district, descript, 
    COUNT(incident_num) OVER(PARTITION BY category) AS category_count
FROM police_incident_reports;

-- Example: Distinct + Window = Normal Group By
SELECT DISTINCT category, 
    COUNT(incident_num) OVER(PARTITION BY category) AS category_count
FROM police_incident_reports;

-- Example: Running Count (cumulative)
SELECT pd_id, category,
    COUNT(pd_id) OVER(PARTITION BY category ORDER BY pd_id) AS running_count
FROM police_incident_reports;

-- Example: Percentage (progress within category)
SELECT pd_id, category,
    CONCAT(
        COUNT(pd_id) OVER(PARTITION BY category ORDER BY pd_id), '/', 
        COUNT(incident_num) OVER(PARTITION BY category)
    ) AS ratio
FROM police_incident_reports;

-- ====================================
-- ROW_NUMBER
-- ====================================
--   • Syntax: ROW_NUMBER() OVER ([PARTITION BY ...] [ORDER BY ...])
--   • Behavior: assigns unique sequential numbers
--   • Similarity: like RANK but no ties, always consecutive
--   • Difference: cannot have duplicate numbers
--   • Use case: pagination, picking first-N per group
-- Unique row numbers
SELECT ROW_NUMBER() OVER() AS Row_num, *
FROM police_incident_reports;

-- Partitioned by category, ordered by date
SELECT category, pd_district, date,
    ROW_NUMBER() OVER(PARTITION BY category ORDER BY date) AS rn
FROM police_incident_reports;

-- First 2 incidents by category
SELECT * 
FROM (
    SELECT category, pd_district, date,
    ROW_NUMBER() OVER(PARTITION BY category ORDER BY date) AS Row_num
    FROM police_incident_reports
) t
WHERE t.Row_num <= 2;

-- ====================================
-- RANK vs DENSE_RANK
-- ====================================
--   • Syntax: RANK() OVER(...) / DENSE_RANK() OVER(...)
--   • Behavior: assigns order based on ORDER BY
--   • RANK(): gaps allowed (1,2,2,4)
--   • DENSE_RANK(): no gaps (1,2,2,3)
--   • Similarity: both handle ties
--   • Use case: leaderboards, scores, categories
SELECT category, pd_district, 
    RANK() OVER(PARTITION BY incident_code ORDER BY pd_district) AS rank,
    DENSE_RANK() OVER(PARTITION BY incident_code ORDER BY pd_district) AS dense_rank
FROM police_incident_reports;

-- ====================================
-- NTILE(n)
-- ====================================
--   • Syntax: NTILE(n) OVER([PARTITION BY ... ORDER BY ...])
--   • Behavior: splits rows into n buckets almost equally
--   • Similarity: like percentiles but in discrete buckets
--   • Use case: quartiles, deciles, stratified grouping
SELECT category, date,
    NTILE(4) OVER(PARTITION BY category ORDER BY date) AS quartile
FROM police_incident_reports;

-- ====================================
-- LAG / LEAD
-- ====================================
--   • Syntax: LAG(col, offset) OVER(...), LEAD(col, offset) OVER(...)
--   • Behavior: fetch value from previous or next row
--   • Similarity: like self-join on shifted data
--   • Use case: diffs between rows, time series comparisons
SELECT pd_id, category, date,
    LAG(date) OVER(PARTITION BY category ORDER BY date) AS prev_date,
    LEAD(date) OVER(PARTITION BY category ORDER BY date) AS next_date
FROM police_incident_reports;

-- ====================================
-- FIRST_VALUE / LAST_VALUE
-- ====================================
--   • Syntax: FIRST_VALUE(col) OVER(...), LAST_VALUE(col) OVER(...)
--   • Behavior: returns first/last row value within frame
--   • Difference: LAST_VALUE needs explicit frame (otherwise = current row)
--   • Use case: find earliest/latest in group
SELECT category, date,
    FIRST_VALUE(date) OVER(PARTITION BY category ORDER BY date) AS first_date,
    LAST_VALUE(date) OVER(PARTITION BY category ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_date
FROM police_incident_reports;

-- ====================================
-- CUME_DIST / PERCENT_RANK
-- ====================================
--   • Syntax: CUME_DIST() OVER(...), PERCENT_RANK() OVER(...)
--   • CUME_DIST(): cumulative distribution (fraction of rows ≤ current)
--   • PERCENT_RANK(): relative rank = (rank-1)/(n-1)
--   • Similarity: both normalized 0–1
--   • Use case: percentiles, relative scoring
SELECT category, pd_district,
    CUME_DIST() OVER(PARTITION BY category ORDER BY pd_district) AS cume_dist,
    PERCENT_RANK() OVER(PARTITION BY category ORDER BY pd_district) AS percent_rank
FROM police_incident_reports;

-- ============================================================
-- 6. HR Example Dataset
-- ============================================================
CREATE DATABASE hr;

CREATE TABLE employees (
    employee_id INT,
    first_name VARCHAR(20) DEFAULT NULL,
    last_name VARCHAR(25) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) DEFAULT NULL,
    hire_date DATE NOT NULL,
    job_id INT NOT NULL,
    salary DECIMAL(8, 2) NOT NULL,
    manager_id INT DEFAULT NULL,
    department_id VARCHAR(25) DEFAULT NULL
);

-- (INSERT statements remain as in your script)
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (100,'Steven','King','steven.king@sqltutorial.org','515.123.4567','1987-06-17',4,24000.00,NULL,'Executive');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (101,'Neena','Kochhar','neena.kochhar@sqltutorial.org','515.123.4568','1989-09-21',5,17000.00,100,'Executive');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (102,'Lex','De Haan','lex.de haan@sqltutorial.org','515.123.4569','1993-01-13',5,17000.00,100,'Executive');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (103,'Alexander','Hunold','alexander.hunold@sqltutorial.org','590.423.4567','1990-01-03',9,9000.00,102,'IT');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (104,'Bruce','Ernst','bruce.ernst@sqltutorial.org','590.423.4568','1991-05-21',9,6000.00,103,'IT');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (105,'David','Austin','david.austin@sqltutorial.org','590.423.4569','1997-06-25',9,4800.00,103,'IT');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (106,'Valli','Pataballa','valli.pataballa@sqltutorial.org','590.423.4560','1998-02-05',9,4800.00,103,'IT');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (107,'Diana','Lorentz','diana.lorentz@sqltutorial.org','590.423.5567','1999-02-07',9,4200.00,103,'IT');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (108,'Nancy','Greenberg','nancy.greenberg@sqltutorial.org','515.124.4569','1994-08-17',7,12000.00,101,'Finance');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (109,'Daniel','Faviet','daniel.faviet@sqltutorial.org','515.124.4169','1994-08-16',6,9000.00,108,'Finance');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (110,'John','Chen','john.chen@sqltutorial.org','515.124.4269','1997-09-28',6,8200.00,108,'Finance');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (111,'Ismael','Sciarra','ismael.sciarra@sqltutorial.org','515.124.4369','1997-09-30',6,7700.00,108,'Finance');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (112,'Jose Manuel','Urman','jose manuel.urman@sqltutorial.org','515.124.4469','1998-03-07',6,7800.00,108,'Finance');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (113,'Luis','Popp','luis.popp@sqltutorial.org','515.124.4567','1999-12-07',6,6900.00,108,'Finance');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (114,'Den','Raphaely','den.raphaely@sqltutorial.org','515.127.4561','1994-12-07',14,11000.00,100,'Administration Assistant');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (115,'Alexander','Khoo','alexander.khoo@sqltutorial.org','515.127.4562','1995-05-18',13,3100.00,114, 'Administration Assistant');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (116,'Shelli','Baida','shelli.baida@sqltutorial.org','515.127.4563','1997-12-24',13,2900.00,114,'Administration Assistant');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (117,'Sigal','Tobias','sigal.tobias@sqltutorial.org','515.127.4564','1997-07-24',13,2800.00,114,'Administration Assistant');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (118,'Guy','Himuro','guy.himuro@sqltutorial.org','515.127.4565','1998-11-15',13,2600.00,114,'Administration Assistant');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (119,'Karen','Colmenares','karen.colmenares@sqltutorial.org','515.127.4566','1999-08-10',13,2500.00,114,'Administration Assistant');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (120,'Matthew','Weiss','matthew.weiss@sqltutorial.org','650.123.1234','1996-07-18',19,8000.00,100,'Shipping');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (121,'Adam','Fripp','adam.fripp@sqltutorial.org','650.123.2234','1997-04-10',19,8200.00,100,'Shipping');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (122,'Payam','Kaufling','payam.kaufling@sqltutorial.org','650.123.3234','1995-05-01',19,7900.00,100,'Shipping');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (123,'Shanta','Vollman','shanta.vollman@sqltutorial.org','650.123.4234','1997-10-10',19,6500.00,100,'Shipping');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (126,'Irene','Mikkilineni','irene.mikkilineni@sqltutorial.org','650.124.1224','1998-09-28',18,2700.00,120,'Shipping');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (145,'John','Russell','john.russell@sqltutorial.org',NULL,'1996-10-01',15,14000.00,100,'Sales');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (146,'Karen','Partners','karen.partners@sqltutorial.org',NULL,'1997-01-05',15,13500.00,100,'Sales');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (176,'Jonathon','Taylor','jonathon.taylor@sqltutorial.org',NULL,'1998-03-24',16,8600.00,100,'Sales');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (177,'Jack','Livingston','jack.livingston@sqltutorial.org',NULL,'1998-04-23',16,8400.00,100,'Sales');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (178,'Kimberely','Grant','kimberely.grant@sqltutorial.org',NULL,'1999-05-24',16,7000.00,100,'Sales');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (179,'Charles','Johnson','charles.johnson@sqltutorial.org',NULL,'2000-01-04',16,6200.00,100,'Sales');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (192,'Sarah','Bell','sarah.bell@sqltutorial.org','650.501.1876','1996-02-04',17,4000.00,123,'Shipping');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (193,'Britney','Everett','britney.everett@sqltutorial.org','650.501.2876','1997-03-03',17,3900.00,123,'Shipping');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (200,'Jennifer','Whalen','jennifer.whalen@sqltutorial.org','515.123.4444','1987-09-17',3,4400.00,101,'Public Accountant');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (201,'Michael','Hartstein','michael.hartstein@sqltutorial.org','515.123.5555','1996-02-17',10,13000.00,100,'Accounting Manager');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (202,'Pat','Fay','pat.fay@sqltutorial.org','603.123.6666','1997-08-17',11,6000.00,201,'Accounting Manager');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (203,'Susan','Mavris','susan.mavris@sqltutorial.org','515.123.7777','1994-06-07',8,6500.00,101,'President');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (204,'Hermann','Baer','hermann.baer@sqltutorial.org','515.123.8888','1994-06-07',12,10000.00,101,'Public Relations');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (205,'Shelley','Higgins','shelley.higgins@sqltutorial.org','515.123.8080','1994-06-07',2,12000.00,101,'Accounting');
INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,manager_id,department_id) VALUES (206,'William','Gietz','william.gietz@sqltutorial.org','515.123.8181','1994-06-07',1,8300.00,205,'Accounting');

-------
-- rank() and dense_rank()
-------
SELECT
    first_name,
    last_name,
    department_id,
    salary,
    RANK() OVER(partition by department_id ORDER BY salary DESC) rank,
    DENSE_RANK() OVER(partition by department_id ORDER BY salary DESC) dense_rank
FROM
    employees;

-------
-- lead() and lag()
-------
SELECT
    first_name,
    last_name,
    department_id,
    salary,
    LAG(salary, 1) OVER(partition by department_id ORDER BY salary DESC) lag,
    salary - LAG(salary, 1) OVER(partition by department_id ORDER BY salary DESC) diff
FROM
    employees;

SELECT
    first_name,
    last_name,
    department_id,
    salary,
    LEAD(salary, 1) OVER(partition by department_id ORDER BY salary DESC) lead,
    salary - LEAD(salary, 1) OVER(partition by department_id ORDER BY salary DESC) diff
FROM
    employees;

-------
-- ntile()
-------
SELECT
    first_name,
    last_name,
    department_id,
    salary,
    NTILE(4) OVER(partition by department_id ORDER BY salary) quartile
FROM
    employees
ORDER BY
    department_id,
    quartile;