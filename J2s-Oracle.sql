--https://apexapps.oracle.com/pls/apex/f?p=44785:52:9246772564576:::52:P52_CONTENT_ID,P52_MODULE_ID,P52_ACTIVITY_ID,P52_EVENT_ID:21849,1795,9039,5763
--%APPDATA%


SYS.DBMS_OUTPUT.PUT_LINE
1.
set SERVEROUTPUT ON
BEGIN
DBMS_OUTPUT.PUT_LINE('Hello world');
END;

--2 variable demo

set SERVEROUTPUT ON
DECLARE
v_myName varchar2(20); 
--v_myName varchar2(20) := 'Steven'; 
BEGIN
DBMS_OUTPUT.PUT_LINE('My name is '||v_myName);
v_myName := 'Jhon';
DBMS_OUTPUT.PUT_LINE('My name is '||v_myName);
END;

--3 bind variable 

VARIABLE b_emp_salary NUMBER;
SET AUTOPRINT ON;
BEGIN
SELECT sal 
INTO :b_emp_salary 
FROM emp where  empno = '7698';
END;
/
 PRINT :b_emp_salary;
 --3.2
 
VARIABLE v_bind2 VARCHAR2(20);
SET AUTOPRINT ON;
EXEC :v_bind2 :='Praveen';

--3.3

VARIABLE b_emp_salary NUMBER;
SET AUTOPRINT ON;
DECLARE
v_empno VARCHAR2(60) := &empno;
BEGIN
DBMS_OUTPUT.PUT_LINE('entered v_empno = '||v_empno);
SELECT sal 
INTO :b_emp_salary 
FROM emp where  empno = v_empno;
END;
/
 PRINT :b_emp_salary;
 
 
--FUNCTIONS 4
 
SET SERVEROUTPUT ON;
DECLARE
  v_desc_siz          NUMBER(5);
  v_prod_description VARCHAR2(70) := 'you can use this product with radios fro high frequency';
BEGIN
  v_desc_siz := LENGTH(v_prod_description);
 DBMS_OUTPUT.PUT_LINE('size :: '|| v_desc_siz);
END;
/

-- 5 Sequence
CREATE SEQUENCE employees_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 
SELECT COUNT(*) FROM user_sequences;
SELECT * FROM user_sequences;

SELECT COUNT(*)
FROM all_sequences
WHERE sequence_name = 'SEQ_SSO_KEY_AUTHENTICATION'
AND sequence_owner  = 'MP' ;
--sequence end
 
 
 SET SERVEROUTPUT ON 

DECLARE
  v_new_emp_id NUMBER (10);
BEGIN
  v_new_emp_id := employees_seq.NEXTVAL;
  DBMS_OUTPUT.PUT_LINE('The new Employee Id is  :: '||v_new_emp_id);
END;

--WEEEK 2
--TYPE

SET SERVEROUTPUT ON
DECLARE
  v_hiredate emp.HIREDATE %TYPE;
  v_sal emp.sal%TYPE;
BEGIN
  SELECT HIREDATE, SAL INTO v_hiredate,v_sal FROM emp WHERE empno = '7698';
  DBMS_OUTPUT.PUT_LINE(' v_hiredate ::'||v_hiredate);
  DBMS_OUTPUT.PUT_LINE(' v_sal ::'||v_sal);
END;
/
--2.2
SET SERVEROUTPUt ON
DECLARE
  v_sum_sal NUMBER(10,2);
  v_deptno  NUMBER NOT NULL :=30;
BEGIN
  SELECT SUM(sal) INTO v_sum_sal FROM emp WHERE deptno = v_deptno;
  DBMS_OUTPUT.PUT_LINE('v_sum_sal :: '||v_sum_sal);
END;

pra•••••••••••••@gmail.com
   praveen.shanigrapu@gmail.com https://mail.google.com/mail/u/1
   pra•••••••••••••@gmail.com
   praveen.cse.java@gmail.com
   

      

   --Creating table with wxisting table
  CREATE TABLE copy_emp
  AS (SELECT * FROM emp);
  
 --INSERT DEMO STRT
  
SELECT * FROM COPY_EMP;
DECLARE
v_min_sal COPY_EMP.SAL %TYPE := 5000;
v_empno COPY_EMP.EMPNO %TYPE; 
BEGIN
SELECT (max(EMPNO)+1) into v_empno FROM COPY_EMP;
DBMS_OUTPUT.PUT_LINE('v_empno ::'||v_empno);
INSERT INTO copy_emp (EMPNO, ENAME, JOB ,  MGR,HIREDATE, SAL, COMM, DEPTNO)
VALUES(v_empno,'abc','test',40,current_date,v_min_sal+3500,0,40) ;
END;
/

SELECT * FROM COPY_EMP WHERE EMPNO =  (SELECT max(empno) from copy_emp); 
  
 --INSERT DEMO END 
 
 --Update demo SATRT
 
 select * from COPY_EMP WHERE EMPNO =  (SELECT max(empno) from copy_emp); 
DECLARE
    increase_sal COPY_EMP.SAL%TYPE := 500;
    v_empno COPY_EMP.EMPNO%TYPE;
  BEGIN
    SELECT MAX(EMPNO) INTO v_empno FROM COPY_EMP;
    UPDATE COPY_EMP SET sal = sal + increase_sal WHERE empno = v_empno;
  END;
/
select * from COPY_EMP WHERE EMPNO =  (SELECT max(empno) from copy_emp);
 
 --Update demo END
 
 --DELETE START
 
 SET SERVEROUTPUT ON;
SELECT * FROM COPY_EMP;

DECLARE
v_empno COPY_EMP.EMPNO %TYPE; 
BEGIN
SELECT max(EMPNO) into v_empno FROM COPY_EMP;
DBMS_OUTPUT.PUT_LINE('v_empno ::'||v_empno);
DELETE FROM COPY_EMP WHERE empno = v_empno;
END;
/
SELECT * FROM COPY_EMP WHERE EMPNO =  (SELECT max(empno)-1 FROM copy_emp); 
 --DELETE END  
 
 -- MERGE START
 
 CREATE TABLE merge_emp
  AS (SELECT * FROM emp where EMPNO=0);
 select * from MERGE_EMP;
 --Not executed
 BEGIN
 MERGE INTO MERGE_EMP m
 USING (SELECT EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO FROM COPY_EMP) e 
 ON(
 m.EMPNO = e.EMPNO
 )WHEN MATCHED THEN
 UPDATE
 SET  m.EMPNO= e.EMPNO, 
      m.ENAME=e.ENAME,
      --m.JOB =e.JOB,
      m.MGR=e.MGR,
      m.HIREDATE=e.HIREDATE,
      m.SAL=e.SAL,
      m.COMM=e.COMM,
      m.DEPTNO=e.DEPTNO
 WHEN NOT MATCHED THEN
 INSERT   VALUES(e.EMPNO,e.ENAME,null,e.MGR,e.HIREDATE,e.SAL,e.COMM,e.DEPTNO);
  END;
 
  -- MERGE START END
  
  --number of updated rows START
  
  select * from COPY_EMP WHERE EMPNO =  (SELECT max(empno) from copy_emp); 
DECLARE
    increase_sal COPY_EMP.SAL%TYPE := 500;
    v_empno COPY_EMP.EMPNO%TYPE;
    v_rows_updated VARCHAR2(80);
  BEGIN
    SELECT MAX(EMPNO) INTO v_empno FROM COPY_EMP;
    UPDATE COPY_EMP SET sal = sal + increase_sal WHERE empno = v_empno;
    v_rows_updated := SQL%ROWCOUNT || ' - Rows updatted';
    DBMS_OUTPUT.PUT_LINE('v_rows_updated:: '||v_rows_updated);
  END;
/
select * from COPY_EMP WHERE EMPNO =  (SELECT max(empno) from copy_emp);
 --number of updated rows end
 
 --Week 3
 --1 PL/SQL Records
 
 1)
 
 SET SERVEROUTPUT ON
--select * from emp;
DECLARE
  TYPE rec_emp IS  RECORD
    (
      v_empno emp.empno %TYPE,
      v_ename emp.ename%TYPE,
      v_job emp.job%TYPE,
      v_sal emp.sal%TYPE
    );
    v_rec_emp rec_emp;

BEGIN
  SELECT empno,ename,job,sal INTO v_rec_emp FROM emp WHERE empno = '7369';
  DBMS_OUTPUT.PUT_LINE('empno :: '||v_rec_emp.v_empno||' Ename ::'||v_rec_emp.v_ename||' Job::'||v_rec_emp.v_job||' Sal ::'||v_rec_emp.v_sal);
END;
/

2)

DECLARE
 TYPE rec_dept IS RECORD
   (
    v_deptno DEPT.DEPTNO % TYPE,
    v_dname DEPT.DNAME % TYPE 
   );
   v_rec_dept rec_dept;
  TYPE rec_emp IS  RECORD
    (
      v_empno emp.empno %TYPE,
      v_ename emp.ename%TYPE,
      v_job emp.job%TYPE,
      v_sal emp.sal%TYPE
      
    );
    v_rec_emp rec_emp;

BEGIN
  SELECT empno,ename,job,sal INTO v_rec_emp FROM emp WHERE empno = '7369';
  SELECT DEPTNO,DNAME INTO v_rec_dept FROM dept where DEPTNO = 10;
  
  DBMS_OUTPUT.PUT_LINE('empno :: '||v_rec_emp.v_empno||' Ename ::'||v_rec_emp.v_ename||' Job::'||v_rec_emp.v_job||' Sal ::'||v_rec_emp.v_sal);
  DBMS_OUTPUT.PUT_LINE('v_recdept :: '||v_rec_dept.v_deptno);
END;
/

3)
--NoT executed

SET SERVEROUTPUT ON
DECLARE
 v_empno COPY_EMP.EMPNO % TYPE := 7941;
 v_job COPY_EMP.JOB % TYPE :='Analyst';
 v_sal COPY_EMP.SAL % TYPE := 11500;
 v_rec_emp COPY_EMP%ROWTYPE;

BEGIN
 SELECT *  INTO v_rec_emp FROM COPY_EMP WHERE EMPNO = v_empno;
  DBMS_OUTPUT.PUT_LINE('**************Before Promotion*********');
  DBMS_OUTPUT.PUT_LINE('empno :: '||v_rec_emp.EMPNO||' Ename ::'||v_rec_emp.ename||' Job::'||v_rec_emp.job||' Sal ::'||v_rec_emp.sal);
  
  --Update Promotion details into table
  v_rec_emp.JOB := v_job;
  --v_rec_emp.sal := (v_rec_emp.sal+1); changes salary all the time
  v_rec_emp.sal := (v_sal+1);
  UPDATE COPY_EMP SET ROW = v_rec_emp  WHERE empno = 7941;
  SELECT *  INTO v_rec_emp FROM COPY_EMP WHERE EMPNO = v_empno;
  DBMS_OUTPUT.PUT_LINE('**************After Promotion*********');
  DBMS_OUTPUT.PUT_LINE('empno :: '||v_rec_emp.EMPNO||' Ename ::'||v_rec_emp.ename||' Job::'||v_rec_emp.job||' Sal ::'||v_rec_emp.sal);
 
END;
/


+601127298720


create table t (
  x int , 
  y int as ( x + 1 )
);

insert into t values (1, default);

declare
  rw t%rowtype;
begin
  rw.x := 2;
  
  update t
  set    row = rw;
end;
/

ORA-54017: UPDATE operation disallowed on virtual columns

alter table t modify y invisible;
select * from t;

X  
1  

declare
  rw t%rowtype;
begin
  rw.x := 2;
  
  update t
  set    row = rw;
end;
/
select * from t;

X  
2 

select x, y from t;

X  Y  
2  3 

declare
  rw t%rowtype;
begin
  rw.x := 2;
  
  update t
  set    row = rw;
end;
/

-----------------------------------------------------------------------------------------------------------------------------------------------------
View


1.view is a predefined query on one or more tables.
2.Retrieving information from a view is done in the same manner as retrieving from a table.
3.With some views you can also perform DML operations (delete, insert, update) on the base tables.
4.Views don't store data, they only access rows in the base tables.
5.user_tables, user_sequences, and user_indexes are all views.
6.View Only allows a user to retrieve data.
7.view can hide the underlying base tables.
8.By writing complex queries as a view, we can hide complexity from an end user.
9.View only allows a user to access certain rows in the base tables.

8.1.Create View

You create a view using CREATE VIEW , which has the following simplified syntax:

CREATE [OR REPLACE] VIEW [{FORCE | NOFORCE}] VIEW view_name
[(alias_name[, alias_name...])] AS subquery
[WITH {CHECK OPTION | READ ONLY} CONSTRAINT constraint_name];


1.OR REPLACE specifies the view is to replace an existing view if present.
2.FORCE specifies the view is to be created even if the base tables don't exist.
3.NOFORCE specifies the view is not to be created if the base tables don't exist; NOFORCE is the default.
4.alias_name specifies the name of an alias for an expression in the subquery.
5.There must be the same number of aliases as there are expressions in the subquery.
6.subquery specifies the subquery that retrieves from the base tables.
7.If you've supplied aliases, you can use those aliases in the list after the SELECT clause.
8.WITH CHECK OPTION specifies that only the rows that would be retrieved by the subquery can be inserted, updated, or deleted.
9.By default, rows are not checked that they are retrievable by the subquery before they are inserted, updated, or deleted.
10.constraint_name specifies the name of the WITH CHECK OPTION or READ ONLY constraint.
11.WITH READ ONLY specifies that rows may only read from the base tables.

There are two basic types of views:

Simple views, which contain a subquery that retrieves from one base table

Complex views, which contain a subquery that:

1.Retrieves from multiple base tables
2.Groups rows using a GROUP BY or DISTINCT clause
3.Contains a function call


create table Employee(
      ID                 VARCHAR2(4 BYTE)         NOT NULL,
      First_Name         VARCHAR2(10 BYTE),
      Last_Name          VARCHAR2(10 BYTE),
      Start_Date         DATE,
      End_Date           DATE,
      Salary             Number(8,2),
     City               VARCHAR2(10 BYTE),
     Description        VARCHAR2(15 BYTE)
   )

CREATE VIEW my_view AS
    SELECT *
    FROM employee
    WHERE id < 5;


select * from my_view;
drop table Employee

2. Choose specific column from base table

CREATE VIEW employee_view AS
    SELECT id, first_name, last_name
    FROM employee;

select * from employee_view;

3.Creating a View with a CHECK OPTION Constraint

You can specify that DML operations on a view must satisfy the subquery by adding a CHECK OPTION constraint to the view.

INSERT INTO myView (id) VALUES (0);
INSERT INTO myView (id) VALUES (7);

4.Creating a View with a READ ONLY Constraint
You can make a view read only by adding a READ ONLY constraint to the view.


SQL> CREATE VIEW myView AS
  2  SELECT *
  3  FROM employee
  4  WITH READ ONLY CONSTRAINT my_view_read_only;

View created.

SQL>
SQL> INSERT INTO myView (id) VALUES (1);
INSERT INTO myView (id) VALUES (1)
                    *
ERROR at line 1:
ORA-01733: virtual column not allowed here

5.Create view based on user-defined function


create or replace function f_emp_dsp (i_empNo VARCHAR)
 return VARCHAR2 is v_out VARCHAR2 (256);
 begin
     DBMS_OUTPUT.put_line('Inside of F_EMP_DSP');
     select initcap(first_name)||': '||initcap(last_name)
       into v_out from employee where id = i_empNo;
     return v_out;
 end f_emp_dsp;
 /

 create or replace view v_emp as
    select f_emp_dsp(id) emp_dsp
    from employee;

select * from v_emp;


  
