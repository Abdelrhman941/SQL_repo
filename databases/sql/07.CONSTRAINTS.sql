-- Active: 1754610173375@@localhost@3306@mysql
show databases;
---------------------------------------------------------
DROP DATABASE IF EXISTS testdb;
CREATE DATABASE IF NOT EXISTS testdb;
--------------------------------------------------------- 
-- create table
USE testdb;
DROP TABLE IF EXISTS t1;

CREATE TABLE t1 (
    id INT UNIQUE, 
    first_name VARCHAR(20)
    );
DESC t1;
INSERT INTO t1 VALUES (1, 'ahmed'), (2, 'aya'), (3, 'john');
TABLE t1;

---- insert a row with the same id :
-- INSERT INTO t1 VALUES (1, 'ali'); -- error
--------------------------------------------------------- 
-- other ways to define unique constraint
CREATE TABLE t2 (
    id INT, 
    first_name VARCHAR(20),
    UNIQUE (id)
    );
DESC t2;
--------------------------------------------------------- 
CREATE TABLE t3 (
    id INT, 
    first_name VARCHAR(20),
    CONSTRAINT id_unique UNIQUE (id)
    );
DESC t3;
--------------------------------------------------------- 
CREATE TABLE t4 (
    id INT AUTO_INCREMENT, 
    first_name VARCHAR(20),
    CONSTRAINT id_unique UNIQUE (id)
    );
DESC t4;

-- insert a row without id
INSERT INTO t4 (first_name) VALUES ('ahmed');
TABLE t4;
INSERT INTO t4 (first_name) VALUES ('sami'), ('aya');
TABLE t4;

-- insert a row with id
INSERT INTO t4 VALUES (10, 'ali');
TABLE t4;
INSERT INTO t4 (first_name) VALUES ('hasan');
TABLE t4;

-- check the auto increment value
SHOW VARIABLES LIKE 'auto_increment%';
--------------------------------------------------------- 
-- primary and foreign keys
CREATE TABLE t5 (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    first_name VARCHAR(20),
    CONSTRAINT id_unique UNIQUE (id)
    );
TABLE t5;

-- another way to define primary key
CREATE TABLE t5 (
    id INT AUTO_INCREMENT, 
    first_name VARCHAR(20),
    CONSTRAINT id_unique UNIQUE (id),
    PRIMARY KEY (id)
    );

-- insert a few rows into t5
INSERT INTO t5 (first_name) VALUES ('ahmed'), ('ali'), ('aya');
TABLE t5;

---- insert a row with existing id
-- INSERT INTO t5 VALUES (1, 'sami'); -- error
--------------------------------------------------------- 
-- create a table t6 with foreign key to primary key of t5
CREATE TABLE t6 (
    id INT, 
    class VARCHAR(20),
    FOREIGN KEY (id) REFERENCES t5(id)
    );
TABLE t6;

-- insert a few rows into t6
INSERT INTO t6 
VALUES  (1, 'Math'), 
        (1, 'English'), 
        (2, 'Math'), 
        (3, 'Science'),
        (3, 'Math');        
TABLE t6;

---- insert a row with non-existing id
-- INSERT INTO t6 VALUES (4, 'Math'); -- error
--------------------------------------------------------- 
DROP TABLE t1;
DROP TABLE t2;
DROP TABLE t3;
DROP TABLE t4;
DROP TABLE t5;   -- when it has foreign key references delete t6 first
DROP TABLE t6;

--------------------------------------------------------- 
-- auto increment -> it's identifier that generates a unique value for each row.
-- UNIQUE         -> It must be unique + can be null + can be multiple cols in the table.
-- PRIMARY KEY    -> It must be unique + NOT NULL    + just one col in the table.
-- FOREIGN KEY    -> It must match a PRIMARY KEY in another table. 
--------------------------------------------------------- 