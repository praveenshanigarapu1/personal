9.1.Create Index

An index for a database table is similar in concept to a book index.

When a row is added to the table, additional time is required to update the index for the new row.

Oracle database automatically creates an index for the primary key of a table and for columns included in a unique constraint.

You create an index using CREATE INDEX, which has the following simplified syntax:

CREATE [UNIQUE] INDEX index_name ON
table_name(column_name[, column_name...])
TABLESPACE table_space;

where

1.UNIQUE specifies the values in the indexed columns must be unique.
2.You can create an index on multiple columns; such an index is known as a composite index.
3.If you don't provide a tablespace, the index is stored in the user's default tablespace

SQL> create table Employee(
    ID                 VARCHAR2(4 BYTE)         NOT NULL,
    First_Name         VARCHAR2(10 BYTE),
    Last_Name          VARCHAR2(10 BYTE),
    Start_Date         DATE,
    End_Date           DATE,
    Salary             Number(8,2),
    City               VARCHAR2(10 BYTE),
    Description        VARCHAR2(15 BYTE)
  )
  /

SQL> CREATE INDEX employee_last_name_idx ON employee(last_name);

Index created.

SQL> drop index employee_last_name_idx;

Index dropped.
9.1.2.	Enforce uniqueness of values in a column using a unique index                     
SQL> CREATE UNIQUE INDEX employee_id_idx ON employee(id);

Index created.

SQL>
SQL> drop index employee_id_idx;

Index dropped.

























