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

9.1.3.	Create combined-column index                       
SQL> CREATE TABLE person (
  2       person_code VARCHAR2(3) PRIMARY KEY,
  3       first_name  VARCHAR2(15),
  4       last_name   VARCHAR2(20),
  5       hire_date   DATE
  6       );

Table created.

SQL>
SQL>
SQL>
SQL> CREATE INDEX person_name_index ON person(last_name, first_name);

Index created.

SQL>
SQL> drop index person_name_index;

Index dropped                       

9.1.4.	Create a composite index on multiple columns
SQL> CREATE INDEX employee_first_last_name_idx ON
  2  employee (first_name, last_name);

Index created.

SQL>
SQL> drop index employee_first_last_name_idx;

Index dropped.

9.1.5.	Creating a Function-Based Index                       
                       
You must set the initialization parameter QUERY_REWRITE_ENABLED to true in order to take advantage of function-based indexes.
SQL> ALTER SYSTEM SET QUERY_REWRITE_ENABLED=TRUE;
SQL> CREATE INDEX employee_last_name_func_idx
  2  ON employee(UPPER(last_name));

Index created.

SQL> SELECT first_name, last_name
  2  FROM employee
  3  WHERE last_name = UPPER('PRICE');

no rows selected

SQL>
SQL>drop index employee_last_name_func_idx;

9.1.6.	Create index based on cluster

SQL> create cluster emp_dept_cluster ( deptno number(2) ) size 1024
  2  /


SQL> create index emp_dept_cluster_idx on cluster emp_dept_cluster
  2  /

Index created.

SQL>
SQL> create table dept
    ( deptno number(2) primary key,
      dname  varchar2(14),
      loc    varchar2(13)
    )
    cluster emp_dept_cluster(deptno)
    /

Table created.

SQL>
SQL> create table emp
 ( empno number primary key,
   ename varchar2(10),
   job   varchar2(9),
   mgr   number,
   hiredate date,
   sal   number,
   comm  number,
   deptno number(2)
 )
 cluster emp_dept_cluster(deptno)
 /

Table created.

SQL>
SQL> begin
      for x in ( select * from dept )
      loop
          insert into dept values ( x.deptno, x.dname, x.loc );
          insert into emp select * from emp where deptno = x.deptno;
      end loop;
  end;
  /

PL/SQL procedure successfully completed.

SQL>
SQL> drop cluster emp_dept_cluster;
drop cluster emp_dept_cluster
*
ERROR at line 1:
ORA-00951: cluster not empty


SQL> drop table emp;

Table dropped.

SQL> drop table dept;

Table dropped.

SQL> drop index emp_dept_cluster_idx;

Index dropped.
-------------------------------------------                       
create cluster emp_dept_cluster ( deptno number(2) ) size 1024

create index emp_dept_cluster_idx on cluster emp_dept_cluster
drop table dept_t
create table dept_t
    ( deptno number(2) primary key,
      dname  varchar2(14),
      loc    varchar2(13)
    )
    cluster emp_dept_cluster(deptno)
    
     create table emp_T
 ( empno number primary key,
   ename varchar2(10),
   job   varchar2(9),
   mgr   number,
   hiredate date,
   sal   number,
   comm  number,
   deptno number(2)
 )
 cluster emp_dept_cluster(deptno)
 
 
 begin
      for x in ( select * from dept )
      loop
          insert into dept_t values ( x.deptno, x.dname, x.loc );
          insert into emp_t select * from emp where deptno = x.deptno;
      end loop;
  end;
 
 select * from dept_t
 select * from emp_t
------------------------------------------












