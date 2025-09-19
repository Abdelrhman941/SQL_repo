-- Active: 1754610173375@@localhost@3306@sakila
-- MySQL Data Types Overview
-- Sources:
-- https://www.w3schools.com/mysql/mysql_datatypes.asp
-- https://dev.mysql.com/doc/refman/8.0/en/data-types.html


-- ============================================================
-- 1. NUMERIC DATA TYPES
-- ============================================================
-- Integer Types:
-- -------------------------------------------------------------
-- | Type       | Storage | Minimum Signed   | Maximum Signed   |
-- |------------|---------|------------------|------------------|
-- | TINYINT    | 1 byte  | -128             | 127              |
-- | SMALLINT   | 2 bytes | -32,768          | 32,767           |
-- | MEDIUMINT  | 3 bytes | -8,388,608       | 8,388,607        |
-- | INT        | 4 bytes | -2,147,483,648   | 2,147,483,647    |
-- | BIGINT     | 8 bytes | -2^63            | 2^63-1           |
-- -------------------------------------------------------------

-- Decimal & Floating-Point Types:
-- ---------------------------------------------------------------
-- | Type         | Storage | Range (approximate)                 |
-- |--------------|---------|-------------------------------------|
-- | DECIMAL(M,D) | Varies  | Exact fixed-point (user-defined)    |
-- | FLOAT        | 4 bytes | ~ ±3.402823466E+38                  |
-- | DOUBLE       | 8 bytes | ~ ±1.7976931348623157E+308          |
-- ---------------------------------------------------------------
-- Examples:
SELECT 1;                           -- integer
SELECT 1 / 2;                       -- result depends on context (int vs float)
SELECT SQRT(15);                    -- floating-point result
SELECT 2.1E+2, -3.98E-4;            -- scientific notation

-- Type Conversion:
SELECT CONVERT(SQRT(15), DECIMAL);              -- convert to DECIMAL (default scale)
SELECT CEILING(SQRT(15));                       -- round up integer
SELECT CONVERT(SQRT(15), DECIMAL(5,2));         -- DECIMAL with precision (5,2)

-- ============================================================
-- 2. STRING DATA TYPES
-- ============================================================
-- Character Types:
-- ------------------------------------------------------------
-- | Type       | Max Length |
-- |------------|------------|
-- | CHAR(M)    | 0 – 255    | fixed-length
-- | VARCHAR(M) | 0 – 65535  | variable-length
-- ------------------------------------------------------------

-- Binary Types:
-- ------------------------------------------------------------
-- | Type        | Max Length |
-- |-------------|------------|
-- | BINARY(M)   | 0 – 255    |
-- | VARBINARY(M)| 0 – 65535  |
-- ------------------------------------------------------------

-- Text Types:
-- ------------------------------------------------------------
-- | Type        | Max Length  |
-- |-------------|-------------|
-- | TINYTEXT    | 255 bytes   |
-- | TEXT        | 64 KB       |
-- | MEDIUMTEXT  | 16 MB       |
-- | LONGTEXT    | 4 GB        |
-- ------------------------------------------------------------

-- Blob Types (binary large objects, same sizes as TEXT):
-- TINYBLOB, BLOB, MEDIUMBLOB, LONGBLOB

-- Special:
-- ENUM('val1', 'val2', ...), SET('a','b',...)

-- Examples:
SELECT _latin1'string';                        -- Latin1 charset
SELECT _binary'string';                        -- binary string
SELECT N'string';                              -- national charset (NCHAR/NVARCHAR)
SELECT _utf8mb4'string' COLLATE utf8mb4_danish_ci;
SELECT HEX(CAST('a' AS BINARY));               -- binary representation of 'a'


-- ============================================================
-- 3. DATE & TIME DATA TYPES
-- ============================================================
-- Supported Types:
-- ------------------------------------------------------------
-- | Type       | Format                  | Range / Notes                     |
-- |------------|-------------------------|---------------------------------- |
-- | DATE       | 'YYYY-MM-DD'            | 1000-01-01 to 9999-12-31          |
-- | TIME       | 'HH:MM:SS'              | -838:59:59 to 838:59:59           |
-- | DATETIME   | 'YYYY-MM-DD HH:MM:SS'   | 1000-01-01 to 9999-12-31          |
-- | TIMESTAMP  | 'YYYY-MM-DD HH:MM:SS'   | 1970-01-01 UTC to 2038-01-19 UTC  |
-- | YEAR       | 'YYYY'                  | 1901 to 2155, 0000                |
-- ------------------------------------------------------------
-- Examples:
SELECT DATE'2009-11-09';
SELECT TIMESTAMP'2012-12-31 11:30:45';
SELECT TIME'12:59:59';
SELECT YEAR'2025';

-- ============================================================
-- 4. NOTES
-- ============================================================
-- MySQL does not have a built-in function to "detect" or
-- "return" the data type of a given value (unlike some DBs).
-- You must check the column definition in the schema
-- (via INFORMATION_SCHEMA.COLUMNS) or rely on conversion.

-- Use CAST() or CONVERT() for explicit type changes.