-- MySQL DDL (Data Definition Language)
-- Covers: CREATE, DROP, ALTER, RENAME for databases, tables, views
-- ============================================================

-- ============================================================
-- 1. DATABASE COMMANDS
-- ============================================================
----------------------
-- Create Database
----------------------
-- CREATE DATABASE testdb;
CREATE DATABASE IF NOT EXISTS testdb;

----------------------
-- Drop Database
----------------------
DROP DATABASE testdb;
DROP DATABASE IF EXISTS testdb;

----------------------
-- Inspect Database
----------------------
SHOW CREATE DATABASE testdb;

-- ============================================================
-- 2. TABLE COMMANDS
-- ============================================================
----------------------
-- Select Database
----------------------
USE testdb;

----------------------
-- Create Simple Table
----------------------
CREATE TABLE t1 (
    id INT,
    first_name VARCHAR(20)
);

----------------------
-- Drop Table
----------------------
DROP TABLE t1;

----------------------
-- Create Table with NULL/NOT NULL
----------------------
CREATE TABLE t1 (
    id INT NOT NULL,
    first_name VARCHAR(20) NULL
);

----------------------
-- Inspect Table
----------------------
SHOW COLUMNS FROM t1;
SHOW CREATE TABLE t1;

----------------------
-- Create Table with More Column Specs
----------------------
CREATE TABLE t1 (
    id MEDIUMINT NOT NULL,
    first_name VARCHAR(20) NULL,
    date_of_birth DATE NULL,                        -- date type
    country VARCHAR(25) NOT NULL DEFAULT 'Egypt'    -- default value
);

-- ============================================================
-- 3. ALTER TABLE COMMANDS
-- ============================================================
----------------------
-- Add Column
----------------------
ALTER TABLE t1 ADD COLUMN last_name VARCHAR(25);

----------------------
-- Drop Column
----------------------
ALTER TABLE t1 DROP COLUMN last_name;

----------------------
-- Modify Column Definition
----------------------
ALTER TABLE t1 ADD COLUMN date_of_birth VARCHAR(25);
SHOW COLUMNS FROM t1;
ALTER TABLE t1 MODIFY COLUMN date_of_birth DATETIME;
SHOW COLUMNS FROM t1;

----------------------
-- Rename Column
----------------------
ALTER TABLE t1 RENAME COLUMN date_of_birth TO dob;
SHOW COLUMNS FROM t1;

----------------------
-- Rename Table
----------------------
ALTER TABLE t1 RENAME TO tbl1;
RENAME TABLE tbl1 TO t1;

-- ============================================================
-- 4. CLONE TABLES
-- ============================================================
----------------------
-- Create Empty Table with Same Structure
----------------------
CREATE TABLE t2 LIKE t1;

----------------------
-- Create Table from Query (with data)
----------------------
CREATE TABLE t3 AS SELECT * FROM t1;


-- ============================================================
-- 5. VIEW COMMANDS
-- ============================================================
----------------------
-- Create View
----------------------
CREATE VIEW v1 AS
SELECT id, first_name FROM t1;

----------------------
-- Alter View (redefine SELECT)
----------------------
ALTER VIEW v1 AS
SELECT first_name, id FROM t1;

----------------------
-- Drop View
----------------------
DROP VIEW v1;