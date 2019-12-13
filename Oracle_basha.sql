View 

SET LINESIZE 100;
SET PAGESIZE 100;

CREATE VIEW  v_emp as SELECT * FROM emp;

conn SYS/XE AS SYSDBA;

SQL> GRANT CREATE VIEW TO prvn;

Grant succeeded.

CREATE VIEW  v_emp as SELECT * FROM emp;

SQL> CREATE VIEW  v_emp as SELECT * FROM emp;
CREATE VIEW  v_emp as SELECT * FROM emp
             *
ERROR at line 1:
ORA-00955: name is already used by an existing object

SQL> CREATE OR REPLACE VIEW  v_emp as SELECT * FROM emp;

View created.

SQL> select empno, ename, sal from v_emp;

     EMPNO ENAME             SAL
---------- ---------- ----------
      7698 BLAKE            2850
      7566 JONES            2975
      7788 SCOTT            3000
      7902 FORD             3000
      7369 SMITH             800
      7499 ALLEN            1600
      7521 WARD             1250
      7654 MARTIN           1250
      7844 TURNER           1500
      7876 ADAMS            1100
      7900 JAMES             950
      7782 CLARK            2450
      7839 KING             5000
      7934 MILLER           1300

14 rows selected.
SQL> select empno, ename, sal from v_emp where sal <= 2500; 

     EMPNO ENAME             SAL
---------- ---------- ----------
      7369 SMITH             800
      7499 ALLEN            1600
      7521 WARD             1250
      7654 MARTIN           1250
      7844 TURNER           1500
      7876 ADAMS            1100
      7900 JAMES             950
      7782 CLARK            2450
      7934 MILLER           1300

9 rows selected.
 select empno, ename, sal, comm, sal+NVL(comm,0) AS t_sal from v_emp ; 

     EMPNO ENAME             SAL       COMM      T_SAL
---------- ---------- ---------- ---------- ----------
      7698 BLAKE            2850                  2850
      7566 JONES            2975                  2975
      7788 SCOTT            3000                  3000
      7902 FORD             3000                  3000
      7369 SMITH             800                   800
      7499 ALLEN            1600        300       1900
      7521 WARD             1250        500       1750
      7654 MARTIN           1250       1400       2650
      7844 TURNER           1500          0       1500
      7876 ADAMS            1100                  1100
      7900 JAMES             950                   950
      7782 CLARK            2450                  2450
      7839 KING             5000                  5000
      7934 MILLER           1300                  1300

14 rows selected.
SQL> select deptno, SUM(sal) AS deptsal from v_emp where sal <= 4000 GROUP BY deptno;

    DEPTNO    DEPTSAL
---------- ----------
        30       9400
        20      10875
        10       3750

SQL> select deptno, SUM(sal) AS deptsal from v_emp where sal <= 4000 GROUP BY deptno HAVING SUM(SAL) > 5000;

    DEPTNO    DEPTSAL
---------- ----------
        30       9400
        20      10875

SQL> select empno, ename, sal, comm, sal+NVL(comm,0) AS t_sal from v_emp ORDER BY t_sal ;

     EMPNO ENAME             SAL       COMM      T_SAL
---------- ---------- ---------- ---------- ----------
      7369 SMITH             800                   800
      7900 JAMES             950                   950
      7876 ADAMS            1100                  1100
      7934 MILLER           1300                  1300
      7844 TURNER           1500          0       1500
      7521 WARD             1250        500       1750
      7499 ALLEN            1600        300       1900
      7782 CLARK            2450                  2450
      7654 MARTIN           1250       1400       2650
      7698 BLAKE            2850                  2850
      7566 JONES            2975                  2975
      7902 FORD             3000                  3000
      7788 SCOTT            3000                  3000
      7839 KING             5000                  5000

14 rows selected.


SQL> CREATE OR REPLACE VIEW v_emp AS SELECT  EMPNO, ENAME,JOB, MGR, HIREDATE, SAL, COMM, DEPTNO FROM emp;

View created.
Advantages
---------
1.data hiding is possible with views
we can hide the data sensitive data which can not viewed.
we can create the view by excluding the sensitive date, then we can grant the access on views, instead of giving access to the tables. 
 
 SQL> select * from tab where tabtype = 'VIEW';

TNAME                          TABTYPE  CLUSTERID
------------------------------ ------- ----------
V_EMP                          VIEW

USER_VIEWS is the data dictionary
SQL> select * from USER_VIEWS;

SQL> DESC USER_VIEWS;
 Name                                                  Null?    Type
 ----------------------------------------------------- -------- ------------------------------------
 VIEW_NAME                                             NOT NULL VARCHAR2(30)
 TEXT_LENGTH                                                    NUMBER
 TEXT                                                           LONG
 TYPE_TEXT_LENGTH                                               NUMBER
 TYPE_TEXT                                                      VARCHAR2(4000)
 OID_TEXT_LENGTH                                                NUMBER
 OID_TEXT                                                       VARCHAR2(4000)
 VIEW_TYPE_OWNER                                                VARCHAR2(30)
 VIEW_TYPE                                                      VARCHAR2(30)
 SUPERVIEW_NAME                                                 VARCHAR2(30)
 EDITIONING_VIEW                                                VARCHAR2(1)
 READ_ONLY                                                      VARCHAR2(1)

select VIEW_NAME ,TEXT_LENGTH,TEXT  from USER_VIEWS;
SQL> select VIEW_NAME ,TEXT_LENGTH,TEXT  from USER_VIEWS;

VIEW_NAME                      TEXT_LENGTH TEXT
------------------------------ ----------- --------------------------------------------------------------------------------
V_EMP                                   67 SELECT  EMPNO, ENAME,JOB, MGR, HIREDATE, SAL, COMM, DEPTNO FROM emp


SQL> CREATE OR REPLACE VIEW  vv_emp as SELECT * FROM v_emp;

View created.


SQL> Select text  from USER_VIEWS WHERE view_name='V_EMP';

TEXT
--------------------------------------------------------------------------------
SELECT  EMPNO, ENAME,JOB, MGR, HIREDATE, SAL, COMM, DEPTNO FROM emp

SELECT * FROM v_emp;


HOW a view gets dat from base table
-----------------------------------
SELECT * FROM (Select text  from USER_VIEWS WHERE view_name='V_EMP');

SELECT * FROM (SELECT  EMPNO, ENAME,JOB, MGR, HIREDATE, SAL, COMM, DEPTNO FROM emp);

Force View
---------
SQL> DESC emp5
ERROR:
ORA-04043: object emp5 does not exist

SQL> CREATE OR REPLACE VIEW v_emp5 AS SELECT * FROM emp5;
CREATE OR REPLACE VIEW v_emp5 AS SELECT * FROM emp5
                                               *
ERROR at line 1:
ORA-00942: table or view does not exist


SQL> CREATE OR REPLACE FORCE VIEW v_emp5 AS SELECT * FROM emp5;

Warning: View created with compilation errors.

SQL> SELECT * FROM v_emp5;
SELECT * FROM v_emp5
              *
ERROR at line 1:
ORA-04063: view "PRVN.V_EMP5" has errors

SQL> select VIEW_NAME ,TEXT_LENGTH,TEXT  from USER_VIEWS;

VIEW_NAME                      TEXT_LENGTH TEXT
------------------------------ ----------- --------------------------------------------------------------------------------
V_EMP                                   67 SELECT  EMPNO, ENAME,JOB, MGR, HIREDATE, SAL, COMM, DEPTNO FROM emp
VV_EMP                                  78 SELECT "EMPNO","ENAME","JOB","MGR","HIREDATE","SAL","COMM","DEPTNO" FROM v_emp
V_EMP5                                  18 SELECT * FROM emp5

User object
-----------

SQL> DESC user_objects;
 Name                                                                                                              Null?    Type
 ----------------------------------------------------------------------------------------------------------------- -------- ----------------------------------------------------------------------------
 OBJECT_NAME                                                                                                               VARCHAR2(128)
 SUBOBJECT_NAME                                                                                                            VARCHAR2(30)
 OBJECT_ID                                                                                                                 NUMBER
 DATA_OBJECT_ID                                                                                                            NUMBER
 OBJECT_TYPE                                                                                                               VARCHAR2(19)
 CREATED                                                                                                                   DATE
 LAST_DDL_TIME                                                                                                             DATE
 TIMESTAMP                                                                                                                 VARCHAR2(19)
 STATUS                                                                                                                    VARCHAR2(7)
 TEMPORARY                                                                                                                 VARCHAR2(1)
 GENERATED                                                                                                                 VARCHAR2(1)
 SECONDARY                                                                                                                 VARCHAR2(1)
 NAMESPACE                                                                                                                 NUMBER
 EDITION_NAME                                                                                                              VARCHAR2(30)

SQL> SELECT object_name,object_type, status FROM user_objects WHERE object_name = 'V_EMP5';


OBJECT_NAME           OBJECT_TYPE         STATUS
---------------------------------------------------------
V_EMP5                   VIEW             INVALID
                         
SQL> CREATE TABLE EMP5 AS SELECT * FROM EMP;

Table created.

SQL> SELECT object_name,object_type, status FROM user_objects WHERE object_name = 'V_EMP5';

OBJECT_NAME                                                                                                                                                             OBJECT_TYPE          STATUS
-------------------------------------------------------------------------------------------------------------------------------- ------------------- -------
V_EMP5                                                                                                                                                                  VIEW                 INVALID

SQL> SELECT * FROM v_emp5;

     EMPNO ENAME      JOB              MGR HIREDATE         SAL       COMM     DEPTNO
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7698 BLAKE      MANAGER         7839 01-MAY-81       2850                    30
      7566 JONES      MANAGER         7839 02-APR-81       2975                    20
      7788 SCOTT      ANALYST         7566 19-APR-87       3000                    20
      7902 FORD       ANALYST         7566 03-DEC-81       3000                    20
      7369 SMITH      CLERK           7902 17-DEC-80        800                    20
      7499 ALLEN      SALESMAN        7698 20-FEB-81       1600        300         30
      7521 WARD       SALESMAN        7698 22-FEB-81       1250        500         30
      7654 MARTIN     SALESMAN        7698 28-SEP-81       1250       1400         30
      7844 TURNER     SALESMAN        7698 08-SEP-81       1500          0         30
      7876 ADAMS      CLERK           7788 23-MAY-87       1100                    20
      7900 JAMES      CLERK           7698 03-DEC-81        950                    30
      7782 CLARK      MANAGER         7839 09-JUN-81       2450                    10
      7839 KING       PRESIDENT            17-NOV-81       5000                    10
      7934 MILLER     CLERK           7782 23-JAN-82       1300                    10

14 rows selected.

SQL> SELECT object_name,object_type, status FROM user_objects WHERE object_name = 'V_EMP5';

OBJECT_NAME                                                                         OBJECT_TYPE          STATUS
-----------------------------------------------------------------------------------------------------------------------

V_EMP5                                                                              VIEW                 VALID

DROP TABLE EMP5;

SQL> DROP TABLE EMP5;

Table dropped.

SQL> SELECT object_name,object_type, status FROM user_objects WHERE object_name = 'V_EMP5';

OBJECT_NAME            OBJECT_TYPE          STATUS
------------------------------------------------------
V_EMP5                 VIEW                 INVALID


Read only views
----------------


SQL> CREATE OR REPLACE VIEW V_RO_EMP AS SELECT * FROM emp WITH READ ONLY;

View created.

SQL> CREATE OR REPLACE VIEW V_C_TEST_RO_EMP AS SELECT * FROM COPY_EMP ;

View created.

SQL> select * FROM V_C_TEST_RO_EMP where deptno =20;

     EMPNO ENAME      JOB              MGR HIREDATE         SAL       COMM     DEPTNO
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7566 JONES      MANAGER         7839 02-APR-81       2975                    20
      7788 SCOTT      ANALYST         7566 19-APR-87       3000                    20
      7902 FORD       ANALYST         7566 03-DEC-81       3000                    20
      7369 SMITH      CLERK           7902 17-DEC-80        800                    20
      7876 ADAMS      CLERK           7788 23-MAY-87       1100                    20

SQL> UPDATE V_C_TEST_RO_EMP SET SAL=2975 where deptno =20;

5 rows updated.

SQL> commit;

Commit complete.

SQL> select * FROM V_C_TEST_RO_EMP where deptno =20;

     EMPNO ENAME      JOB              MGR HIREDATE         SAL       COMM     DEPTNO
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7566 JONES      MANAGER         7839 02-APR-81       2975                    20
      7788 SCOTT      ANALYST         7566 19-APR-87       2975                    20
      7902 FORD       ANALYST         7566 03-DEC-81       2975                    20
      7369 SMITH      CLERK           7902 17-DEC-80       2975                    20
      7876 ADAMS      CLERK           7788 23-MAY-87       2975                    20


select * FROM COPY_EMP  where deptno =20;

SQL> SELECT object_name,object_type, status FROM user_objects WHERE object_name like '%EMP%'
----------------------------------------------------------------------------------------

SQL> create table emp as select * from emp_t;

SQL> CREATE OR REPLACE VIEW VC_EMP AS SELECT * FROM COPY_EMP WHERE deptno = 20 WITH CHECK OPTION;

View created.

 UPDATE VC_EMP SET SAL=2975 where deptno =20;

SQL>  UPDATE VC_EMP SET SAL=2975 where deptno =20;

5 rows updated.


SQL> select * FROM COPY_EMP  where deptno =20;

     EMPNO ENAME      JOB              MGR HIREDATE         SAL       COMM     DEPTNO
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7566 JONES      MANAGER         7839 02-APR-81       2975                    20
      7788 SCOTT      ANALYST         7566 19-APR-87       2975                    20
      7902 FORD       ANALYST         7566 03-DEC-81       2975                    20
      7369 SMITH      CLERK           7902 17-DEC-80       2975                    20
      7876 ADAMS      CLERK           7788 23-MAY-87       2975                    20

 SQL> DROP TABLE COPY_EMP;

Table dropped.

SQL> create table copy_emp as select * from emp;

Table created.

SQL>  select * FROM COPY_EMP  where deptno =20;

     EMPNO ENAME      JOB              MGR HIREDATE         SAL       COMM     DEPTNO
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7566 JONES      MANAGER         7839 02-APR-81       2975                    20
      7788 SCOTT      ANALYST         7566 19-APR-87       3000                    20
      7902 FORD       ANALYST         7566 03-DEC-81       3000                    20
      7369 SMITH      CLERK           7902 17-DEC-80        800                    20
      7876 ADAMS      CLERK           7788 23-MAY-87       1100                    20

UPDATE VC_EMP SET SAL=2975 where deptno =20;
 
CREATE OR REPLACE VIEW VC_EMP AS SELECT * FROM COPY_EMP WHERE SAL = 2975 WITH CHECK OPTION; 
 
 SQL> CREATE OR REPLACE VIEW VC_EMP AS SELECT * FROM COPY_EMP WHERE SAL = 2975 WITH CHECK OPTION;

View created.


SQL> UPDATE VC_EMP SET SAL=2976 where SAL =2975;
UPDATE VC_EMP SET SAL=2976 where SAL =2975
       *
ERROR at line 1:
ORA-01402: view WITH CHECK OPTION where-clause violation

SQL> commit;

Commit complete.

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
