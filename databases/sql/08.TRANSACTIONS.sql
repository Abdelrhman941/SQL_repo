-- Active: 1754610173375@@localhost@3306@mysql
---------------------------------------------------------
-- ACID Transactions : Atomicity, Consistency, Isolation, Durability
---------------------------------------------------------
-- Atomicity   : All or nothing (either all changes happen or none).
    -- Example : Transfer $100 → if debit from A fails, credit to B is rolled back.

-- Consistency : Data remains valid before and after a transaction.
    -- Example : Total balance of A + B stays the same before and after transfer.

-- Isolation   : Transactions don’t see each other’s half-done work.
    -- Example : Another user never sees money missing from both accounts at once.

-- Durability  : Once committed, changes are permanent (survive crashes).
    -- Example : After COMMIT, the transfer remains even if the server restarts.
---------------------------------------------------------
show databases;
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;
CREATE TABLE t1 (id INT, first_name VARCHAR(20));
SHOW COLUMNS FROM t1;
INSERT INTO t1 VALUES (1, 'ahmed'), (2, 'aya'), (3, 'john');
TABLE t1;
UPDATE t1 SET first_name = 'ali' WHERE id = 1;
---------------------------------------------------------
-- start transaction [autocommit -> default]
START TRANSACTION;
-- update t1 
UPDATE t1 SET first_name = 'sawsan' WHERE id = 1;
-- check the t1 rows from another session
table t1;           -- here will show the new value 'sawsan' , but in workbanch it will show the old value 'ali'
-- commit transaction
COMMIT;             -- or ROLLBACK;
TABLE t1;
---------------------------------------------------------
-- start transaction without commit 
START TRANSACTION;
-- update t1
UPDATE t1 SET first_name = 'fekri' WHERE id = 1;
ROLLBACK;
TABLE t1;
---------------------------------------------------------
SET autocommit = 0;  -- disable autocommit mode and will deeal with transaction manually
UPDATE t1 SET first_name = 'fekri' WHERE id = 1;
ROLLBACK;
SET autocommit = 1;
UPDATE t1 SET first_name = 'fekri' WHERE id = 1;