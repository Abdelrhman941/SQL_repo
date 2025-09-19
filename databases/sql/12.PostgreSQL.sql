-- Active: 1758118886049@@localhost@5432@testdb
-- ==========================================================================
-- 1. Server Information
-- ==========================================================================
-- Check PostgreSQL version
SELECT version();
SHOW server_version;

-- Show location of the database cluster
SHOW data_directory;
-- ==========================================================================
-- 2. Database Management
-- ==========================================================================
-- Create a new database
CREATE DATABASE testdb;

-- Show current database
SELECT current_database();

-- NOTE:
-- Unlike MySQL, you cannot switch databases with "USE testdb;" in PostgreSQL.
-- Instead, you must reconnect with the new database name.
-- ==========================================================================
-- 3. Table Creation
-- ==========================================================================
-- Create a simple table
CREATE TABLE t1 (
    id INT,
    first_name VARCHAR(30)
);

-- Insert single row
INSERT INTO t1 VALUES (1, 'ahmed');

-- Insert multiple rows
INSERT INTO t1 VALUES 
    (2, 'aya'), 
    (3, 'john');
-- ==========================================================================
-- 4. Table Copying (MySQL vs PostgreSQL)
-- ==========================================================================
-- MySQL:   CREATE TABLE t2 LIKE t1;       -- ❌ Not supported in PostgreSQL
-- Instead, in PostgreSQL:

-- Copy structure + data from t1
CREATE TABLE t2 AS SELECT * FROM t1;

-- Copy structure only from t1 (no data)
CREATE TABLE t3 AS TABLE t1;
-- ==========================================================================
-- 5. Inspecting Table Structure
-- ==========================================================================
-- MySQL:   SHOW COLUMNS FROM t1;  /  DESC t1;   -- ❌ Not supported
-- Instead, in PostgreSQL:
SELECT column_name, data_type, table_name
FROM information_schema.columns
WHERE table_name = 't1';
-- ==========================================================================
-- 6. Advanced Table & Type Features
-- ==========================================================================
-- (a) Create a composite TYPE and then a table based on it
CREATE TYPE t1_type AS (
    id INT,
    first_name VARCHAR(30)
);
CREATE TABLE t4 OF t1_type;

-- (b) Create a DOMAIN (custom data type with constraints)
CREATE DOMAIN t1_domain AS VARCHAR(30);