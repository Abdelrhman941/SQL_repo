# **SQL for Data Analysis**

## **Dataset**
* Source: [SFData – Police Incident Reports](https://data.sfgov.org/Public-Safety/Police-Department-Incident-Reports-Historical-2003/tmnf-yvry/data)
* Save as CSV in [Datasets Folder](./Datasets/)

<body>
    <div style = "
        width: 100%;
        height: 20px;
        background: linear-gradient(to right,rgb(235, 238, 212),rgb(235, 238, 212));">
    </div>
</body>

## **Load Data into PostgreSQL**
- **in terminal or psql shell:**

    ```sql
    -- Connect to PostgreSQL
    psql -U postgres;

    -- Create and switch to database
    CREATE DATABASE sfpolice;
    \c sfpolice
    SELECT current_database();

    -- Create table
    CREATE TABLE police_incident_reports (
        pd_id BIGINT,
        incident_num BIGINT,
        incident_code BIGINT,
        category TEXT,
        descript TEXT,
        day_of_week TEXT,
        date DATE,
        time TIME,
        pd_district TEXT,
        resolution TEXT,
        address TEXT,
        x DOUBLE PRECISION,
        y DOUBLE PRECISION,
        location TEXT,
        data_loaded_at TIMESTAMP
    );

    -- Load CSV
    \COPY police_incident_reports
    FROM 'D:/Data_Science/Data Collection/SQL/Datasets/Police_Department.csv'
    DELIMITER ','
    CSV HEADER
    QUOTE '"'
    ENCODING 'UTF8';
    ```

<body>
    <div style = "
        width: 100%;
        height: 20px;
        background: linear-gradient(to right,rgb(235, 238, 212),rgb(235, 238, 212));">
    </div>
</body>

![image](https://i.postimg.cc/Pfpq058n/image.png)

## **Data Profiling**

* **Exploratory Data Analysis (EDA)**
* Structure & distribution checks
* Visualization of trends
* Data quality review

## **Data Cleanup**

* Handle duplicates
* Remove/standardize nulls
* General cleaning

<body>
    <div style = "
        width: 100%;
        height: 20px;
        background: linear-gradient(to right,rgb(235, 238, 212),rgb(235, 238, 212));">
    </div>
</body>

![Aggregate Function VS Window Function](https://i.postimg.cc/3wmcFyBK/image.png)

<body>
    <div style = "
        width: 100%;
        height: 20px;
        background: linear-gradient(to right,rgb(235, 238, 212),rgb(235, 238, 212));">
    </div>
</body>


## **Aggregate & Window Functions:**
| Function          | Syntax Example             | What it does            | Notes                                                                                               | Example Query                                                                                                                                      |
| ----------------- | -------------------------- | ----------------------- | --------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Aggregate**     | `SUM(col)`                 | Collapse rows → 1/group | Needs `GROUP BY` (unless whole table). Includes: `SUM, AVG, MIN, MAX, COUNT`.                       | `SELECT dept, SUM(salary) FROM employees GROUP BY dept;`                                                                                           |
| **Window (OVER)** | `SUM(col) OVER(...)`       | Keep all rows + calc    | Same funcs as Aggregate, but does **not reduce rows**. Use `PARTITION BY` + `ORDER BY` for control. | `SELECT name, dept, SUM(salary) OVER(PARTITION BY dept) FROM employees;`                                                                           |
| **ROW\_NUMBER**   | `ROW_NUMBER() OVER(...)`   | Unique seq. per row     | Always consecutive, restarts with `PARTITION BY`.                                                   | `SELECT name, ROW_NUMBER() OVER(PARTITION BY dept ORDER BY salary DESC) FROM employees;`                                                           |
| **RANK**          | `RANK() OVER(...)`         | Rank with gaps          | Ties → same rank, next rank skipped.                                                                | `SELECT name, RANK() OVER(ORDER BY salary DESC) FROM employees;`                                                                                   |
| **DENSE\_RANK**   | `DENSE_RANK() OVER(...)`   | Rank w/o gaps           | Ties → same rank, next rank continues with no gap.                                                  | `SELECT name, DENSE_RANK() OVER(ORDER BY salary DESC) FROM employees;`                                                                             |
| **NTILE(n)**      | `NTILE(4) OVER(...)`       | Split into n buckets    | Distributes rows into `n` groups as evenly as possible.                                             | `SELECT name, NTILE(4) OVER(ORDER BY salary DESC) FROM employees;`                                                                                 |
| **LAG / LEAD**    | `LAG(col), LEAD(col)`      | Prev / next row value   | Needs `ORDER BY`. Useful for diffs, trends.                                                         | `SELECT date, sales, LAG(sales) OVER(ORDER BY date) FROM sales_data;`                                                                              |
| **FIRST\_VALUE**  | `FIRST_VALUE(col)`         | First in frame          | Requires `ORDER BY`. Watch frame clause (`ROWS BETWEEN`).                                           | `SELECT name, FIRST_VALUE(salary) OVER(PARTITION BY dept ORDER BY salary DESC) FROM employees;`                                                    |
| **LAST\_VALUE**   | `LAST_VALUE(col ROWS ...)` | Last in frame           | Needs explicit frame: default may not give expected result.                                         | `SELECT name, LAST_VALUE(salary) OVER(PARTITION BY dept ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) FROM employees;` |
| **CUME\_DIST**    | `CUME_DIST() OVER(...)`    | Cumulative % (0–1)      | = proportion of rows ≤ current. Always between `0` and `1`.                                         | `SELECT name, CUME_DIST() OVER(ORDER BY salary) FROM employees;`                                                                                   |
| **PERCENT\_RANK** | `PERCENT_RANK() OVER(...)` | Relative rank (0–1)     | Formula: `(rank-1)/(n-1)`. Slightly different from `CUME_DIST`.                                     | `SELECT name, PERCENT_RANK() OVER(ORDER BY salary) FROM employees;`                                                                                |
* **Key Points:**
  - Aggregate functions reduce rows; window functions do not.
  - Use `PARTITION BY` to group within window functions.
  - `ORDER BY` controls sequence in window functions.
  - Frame clauses (`ROWS BETWEEN`) define the subset of rows for calculations.
  - Functions like `ROW_NUMBER`, `RANK`, and `DENSE_RANK` assign rankings based on order.
  - `LAG` and `LEAD` access values from previous or next rows.
  - Cumulative distribution functions (`CUME_DIST`, `PERCENT_RANK`) provide relative positioning.