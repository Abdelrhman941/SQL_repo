# **CMD for PostgreSQL Quick Reference**

## **Connect**

```bash
psql -h <HOST> -p <PORT> -U <USER> -d <DB>
```

👉 Example:

```bash
psql -h localhost -p 5432 -U postgres
```

> user connects to default DB with same name as user if `-d <DB>` not provided

<body>
    <div style = "
        width: 100%;
        height: 30px;
        background: linear-gradient(to right,rgb(235, 238, 212),rgb(235, 238, 212));">
    </div>
</body>

## **📌 Basics**

| use              | command                                      | example                                 |
| ---------------- | -------------------------------------------- | --------------------------------------- |
| list DBs         | `\l`                                         | `postgres=# \l`                         |
| connect DB       | `\c dbname`                                  | `postgres=# \c testdb`                  |
| current DB       | `SELECT current_database();`                 | `postgres=# SELECT current_database();` |
| list tables      | `\dt`                                        | `testdb=# \dt`                          |
| describe table   | `\d table`                                   | `testdb=# \d t1`                        |
| list users/roles | `\du`                                        | `postgres=# \du`                        |
| server version   | `SELECT version();` / `SHOW server_version;` | `postgres=# SELECT version();`          |
| data directory   | `SHOW data_directory;`                       | `postgres=# SHOW data_directory;`       |
| clear screen     | `\! cls` (Win)                               | `postgres=# \! cls`                     |

<body>
    <div style = "
        width: 100%;
        height: 30px;
        background: linear-gradient(to right,rgb(235, 238, 212),rgb(235, 238, 212));">
    </div>
</body>

## **📌 SQL Essentials**

| use             | command                              | example                                            |
| --------------- | ------------------------------------ | -------------------------------------------------- |
| create DB       | `CREATE DATABASE db;`                | `CREATE DATABASE testdb;`                          |
| drop DB         | `DROP DATABASE db;`                  | `DROP DATABASE testdb;`                            |
| create table    | `CREATE TABLE ...`                   | `CREATE TABLE t1(id int, first_name varchar(30));` |
| drop table      | `DROP TABLE table;`                  | `DROP TABLE t1;`                                   |
| insert row      | `INSERT INTO ... VALUES (...);`      | `INSERT INTO t1 VALUES (1,'ahmed');`               |
| insert multiple | `INSERT INTO ... VALUES (...),(..);` | `INSERT INTO t1 VALUES (2,'aya'),(3,'john');`      |
| select data     | `SELECT * FROM table;`               | `SELECT * FROM t1;`                                |

<body>
    <div style = "
        width: 100%;
        height: 30px;
        background: linear-gradient(to right,rgb(235, 238, 212),rgb(235, 238, 212));">
    </div>
</body>

## **📌 Meta / psql Helpers**

| use                | command       | example                  |
| ------------------ | ------------- | ------------------------ |
| quit               | `\q`          | `postgres=# \q`          |
| timing on/off      | `\timing`     | `postgres=# \timing`     |
| expanded display   | `\x`          | `testdb=# \x`            |
| edit last query    | `\e`          | `testdb=# \e`            |
| show query buffer  | `\p`          | `testdb=# \p`            |
| reset query buffer | `\r`          | `testdb=# \r`            |
| run SQL file       | `\i file.sql` | `postgres=# \i init.sql` |
| output to file     | `\o file.txt` | `postgres=# \o out.txt`  |
| run shell command  | `\! command`  | `postgres=# \! dir`      |

<body>
    <div style = "
        width: 100%;
        height: 30px;
        background: linear-gradient(to right,rgb(235, 238, 212),rgb(235, 238, 212));">
    </div>
</body>

## **📌 Add-ons (handy vs MySQL)**

| use                   | PostgreSQL equivalent           | example                                                                               |
| --------------------- | ------------------------------- | ------------------------------------------------------------------------------------- |
| clone table structure | `CREATE TABLE t2 AS TABLE t1;`  | `CREATE TABLE t2 AS TABLE t1;`                                                        |
| show columns          | `information_schema.columns`    | `SELECT column_name,data_type FROM information_schema.columns WHERE table_name='t1';` |
| create TYPE           | `CREATE TYPE ... AS (...)`      | `CREATE TYPE t1_type AS (id int, first_name varchar(30));`                            |
| table from TYPE       | `CREATE TABLE ... OF typename;` | `CREATE TABLE t4 OF t1_type;`                                                         |
| create DOMAIN         | `CREATE DOMAIN name AS type;`   | `CREATE DOMAIN t1_domain AS varchar(30);`                                             |
