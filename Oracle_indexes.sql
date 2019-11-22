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
9.1.7.	Creates an index on the new added column
SQL> -- Adds the new column
SQL> ALTER TABLE employee ADD employee_dup_id VARCHAR2(7);

Table altered.

SQL>
SQL> -- Updates the new column with the value of the employee_id column
SQL> UPDATE employee
  2  SET    employee_dup_id = employee_id;

10 rows updated.

SQL>
SQL>
SQL> -- Creates an index on the new column
SQL> CREATE UNIQUE INDEX employee_test_idx2
  2     ON employee(employee_dup_id);

Index created.
9.1.8.	Create a fully indexed table named myCode
SQL> create table myCode(
    codeValue  VARCHAR2(1) primary key,
    Description VARCHAR2(25)
  );

Table created.

SQL>
SQL> create index i1 on myCode (codeValue, Description);

Index created.
9.1.9.	indextype is ctxsys.context
SQL>
SQL> create table t ( x clob );

Table created.

SQL>
SQL> set autotrace traceonly explain
SQL> select * from t;

Execution Plan
----------------------------------------------------------
Plan hash value: 1601196873

----------------------------------
| Id  | Operation         | Name |
----------------------------------
|   0 | SELECT STATEMENT  |      |
|   1 |  TABLE ACCESS FULL| T    |
----------------------------------

Note
-----
   - rule based optimizer used (consider using cbo)

SQL>
SQL> create index t_idx on t(x) indextype is ctxsys.context;

Index created.

SQL> select * from t;

Execution Plan
----------------------------------------------------------
Plan hash value: 1601196873

----------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost  |
----------------------------------------------------------
|   0 | SELECT STATEMENT  |      |    82 |  8200 |     1 |
|   1 |  TABLE ACCESS FULL| T    |    82 |  8200 |     1 |
----------------------------------------------------------

Note
-----
   - cpu costing is off (consider enabling it)

SQL>
SQL> set autotrace off
                       
    EXPLAIN PLAN FOR
    SELECT * FROM Dual;
    
    SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

	9.1.10.	Create index for upper case last name
   SQL> create index upper_emp_idx on emp upper(lastname);

Index created.
		       
9.1.11.	Create index along with the column definition
SQL> CREATE TABLE emp2
  2  (emp_id        NUMBER PRIMARY KEY
  3                  USING INDEX
  4                  (CREATE INDEX pk_idx ON emp2(emp_id) TABLESPACE users)
  5   ,lastname      VARCHAR2(20) CONSTRAINT lastname_create_nn NOT NULL
  6   ,firstname     VARCHAR2(15) CONSTRAINT firstname_create_nn NOT NULL
  7   ,phone     VARCHAR2(12)
  8   ,company_name  VARCHAR2(50)
  9   ,CONSTRAINT unique_emp_phone UNIQUE (phone)
 10    USING INDEX
 11   (CREATE INDEX phone_idx ON emp2 (phone) TABLESPACE users)
 12   );

Table created.
9.1.14.	Demonstrate a bitmap join index.
SQL> create unique index pk_idx on emp (emp_id);

SQL>
SQL> select index_name, table_name, column_name from user_ind_columns where table_name = 'EMP';


SQL>
SQL> select constraint_name, table_name, column_name from user_cons_columns where table_name = 'EMP'
		       
9.1.		       
SQL> select count(*) from emp, dept where emp.deptno = dept.deptno and dept.dname = 'SALES';

  COUNT(*)
----------
         6

1 row selected.


Execution Plan
----------------------------------------------------------
Plan hash value: 2157540364

-------------------------------------
| Id  | Operation            | Name |
-------------------------------------
|   0 | SELECT STATEMENT     |      |
|   1 |  SORT AGGREGATE      |      |
|   2 |   MERGE JOIN         |      |
|   3 |    SORT JOIN         |      |
|*  4 |     TABLE ACCESS FULL| DEPT |
|*  5 |    SORT JOIN         |      |
|   6 |     TABLE ACCESS FULL| EMP  |
-------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - filter("DEPT"."DNAME"='SALES')
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
       filter("EMP"."DEPTNO"="DEPT"."DEPTNO")

Note
-----
   - rule based optimizer used (consider using cbo)


Statistics
----------------------------------------------------------
          1  recursive calls
          0  db block gets
          6  consistent gets
          0  physical reads
          0  redo size
        411  bytes sent via SQL*Net to client
        380  bytes received via SQL*Net from client
          2  SQL*Net roundtrips to/from client
          2  sorts (memory)
          0  sorts (disk)
          1  rows processed

SQL>
SQL> set autotrace off;		       
		       
9.1.15.	create unique index with case ... when statement		       
SQL> create unique index oau_reg on registrations
  2  ( case course when 'OAU' then attendee else null end
  3  , case course when 'OAU' then course   else null end );

Index created.

SQL>
SQL> insert into registrations values (12,'OAU',sysdate,null);

1 row created.

SQL>
SQL> drop index oau_reg;		       
		       
		       
		       
		       
		       
		       
		       
		       
		       
		       
		       
		       
		       
		       
		       
		       
		       
		       
		       
		       
		       
