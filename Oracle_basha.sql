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

 Complex views
 -------------
 
SQL> CREATE OR REPLACE VIEW V_COMP_EMP AS SELECT deptno, SUM(sal) AS total_sal FROM COPY_EMP GROUP BY deptno;

View created.

SQL> UPDATE V_COMP_EMP SET SAL=2976 where SAL =2975;
UPDATE V_COMP_EMP SET SAL=2976 where SAL =2975
                                     *
ERROR at line 1:
ORA-00904: "SAL": invalid identifier

SQL> UPDATE V_COMP_EMP SET deptno=21 where deptno =20;
UPDATE V_COMP_EMP SET deptno=21 where deptno =20
       *
ERROR at line 1:
ORA-01732: data manipulation operation not legal on this view
 
 
CREATE OR REPLACE VIEW V_COMP_EMP AS SELECT deptno, SUM(sal)  FROM COPY_EMP GROUP BY deptno; 
 
SQL> CREATE OR REPLACE VIEW V_COMP_EMP AS SELECT deptno, SUM(sal)  FROM COPY_EMP GROUP BY deptno;
CREATE OR REPLACE VIEW V_COMP_EMP AS SELECT deptno, SUM(sal)  FROM COPY_EMP GROUP BY deptno
                                                    *
ERROR at line 1:
ORA-00998: must name this expression with a column alias 

SQL> create user u1 identified by u1;

User created.

SQL> conn u1/u1;
ERROR:
ORA-01045: user U1 lacks CREATE SESSION privilege; logon denied

 grant create session to u1;
 
 SQL>  grant create session to u1;

Grant succeeded.

SQL> conn u1/u1;
Connected.
SQL>

SELECT * FROM V_COMP_EMP;

SELECT * FROM prvn.V_COMP_EMP
                   *
ERROR at line 1:
ORA-00942: table or view does not exist

SQL> conn prvn/prvn1
Connected.
SQL> grant select on V_COMP_EMP to u1;

Grant succeeded.

SQL> conn u1/u1;

Connected.

SQL> SELECT * FROM prvn.V_COMP_EMP;

    DEPTNO  TOTAL_SAL
---------- ----------
        30       9400
        20      10875
        10       8750
        
        SEQUENCES
        ==========

DESC user_sequences;

SQL> DESC user_sequences;
 Name                                                                                                              Null?    Type
 ----------------------------------------------------------------------------------------------------------------- -------- ----------------------------------------------------------------------------
 SEQUENCE_NAME                                                                                                     NOT NULL VARCHAR2(30)
 MIN_VALUE                                                                                                                 NUMBER
 MAX_VALUE                                                                                                                 NUMBER
 INCREMENT_BY                                                                                                      NOT NULL NUMBER
 CYCLE_FLAG                                                                                                                VARCHAR2(1)
 ORDER_FLAG                                                                                                                VARCHAR2(1)
 CACHE_SIZE                                                                                                        NOT NULL NUMBER
 LAST_NUMBER                                                                                                       NOT NULL NUMBER
 
SQL>  SELECT * FROM user_sequences;

no rows selected

SQL> CREATE SEQUENCE S1;

Sequence created.

SQL> DESC s1
SP2-0381: DESCRIBE sequence is not available
 
SQL> CREATE OR REPLACE SEQUENCE S1;
CREATE OR REPLACE SEQUENCE S1
                  *
ERROR at line 1:
ORA-00922: missing or invalid option
 
 SQL> SELECT * FROM user_sequences;

SEQUENCE_NAME                   MIN_VALUE  MAX_VALUE INCREMENT_BY C O CACHE_SIZE LAST_NUMBER
------------------------------ ---------- ---------- ------------ - - ---------- -----------
EMPLOYEES_SEQ                           1 1.0000E+28            1 N N          0           4
S1                                      1 1.0000E+28            1 N N         20           1
TEST_SEQ                                1 1.0000E+28            1 N N         20           1
 
SQL>  SELECT S1.CURRVAL FROM DUAL;
 SELECT S1.CURRVAL FROM DUAL
        *
ERROR at line 1:
ORA-08002: sequence S1.CURRVAL is not yet defined in this session
 
 SELECT S1.NEXTVAL FROM DUAL;
 
 SQL> SELECT S1.NEXTVAL FROM DUAL;

   NEXTVAL
----------
         1
 
 
SQL> SELECT S1.CURRVAL FROM DUAL;

   CURRVAL
----------
         1

aNY POINT OF TIME buffer contains one statement and its out value either it failure or success message
 
 SQL> SELECT S1.CURRVAL FROM DUAL;

   CURRVAL
----------
         1

SQL> /

   CURRVAL
----------
         1

SQL> /

   CURRVAL
----------
         1

SQL>
SQL> SELECT S1.NEXTVAL FROM DUAL;

   NEXTVAL
----------
         2

SQL> /

   NEXTVAL
----------
         3

SQL>
SQL> /

   NEXTVAL
----------
         4

SQL> /

   NEXTVAL
----------
         5
         
            NEXTVAL
----------
        20

SQL> SELECT * FROM user_sequences;

SEQUENCE_NAME                   MIN_VALUE  MAX_VALUE INCREMENT_BY C O CACHE_SIZE LAST_NUMBER
------------------------------ ---------- ---------- ------------ - - ---------- -----------
EMPLOYEES_SEQ                           1 1.0000E+28            1 N N          0           4
S1                                      1 1.0000E+28            1 N N         20          21
TEST_SEQ                                1 1.0000E+28            1 N N         20           1

SQL> SELECT S1.NEXTVAL FROM DUAL;

   NEXTVAL
----------
        21

SQL> SELECT * FROM user_sequences;

SEQUENCE_NAME                   MIN_VALUE  MAX_VALUE INCREMENT_BY C O CACHE_SIZE LAST_NUMBER
------------------------------ ---------- ---------- ------------ - - ---------- -----------
EMPLOYEES_SEQ                           1 1.0000E+28            1 N N          0           4
S1                                      1 1.0000E+28            1 N N         20          41
TEST_SEQ                                1 1.0000E+28            1 N N         20           1
 
 
  CREATE  SEQUENCE SS1
  INCREMENT BY 2
  MINVALUE 101
  MAXVALUE 150
  NOCYCLE
  NOCACHE;
  
  Sequence created.
  
 SQL> SELECT * FROM user_sequences;
 
 SEQUENCE_NAME                   MIN_VALUE  MAX_VALUE INCREMENT_BY C O CACHE_SIZE LAST_NUMBER
------------------------------ ---------- ---------- ------------ - - ---------- -----------
EMPLOYEES_SEQ                           1 1.0000E+28            1 N N          0           4
S1                                      1 1.0000E+28            1 N N         20          41
SS1                                   101        150            2 N N          0         101
TEST_SEQ                                1 1.0000E+28            1 N N         20           1
 
 
    NEXTVAL
----------
       149

SQL> /
SELECT SS1.NEXTVAL FROM DUAL
*
ERROR at line 1:
ORA-08004: sequence SS1.NEXTVAL exceeds MAXVALUE and cannot be instantiated
 
  CREATE  SEQUENCE SS2
  INCREMENT BY 2
  MINVALUE 101
  MAXVALUE 150
  NOCYCLE
  CACHE 0;
 
 SQL>  CREATE  SEQUENCE SS2  INCREMENT BY 2  MINVALUE 101  MAXVALUE 150  NOCYCLE  CACHE 0;
 CREATE  SEQUENCE SS2  INCREMENT BY 2  MINVALUE 101  MAXVALUE 150  NOCYCLE  CACHE 0
*
ERROR at line 1:
ORA-04010: the number of values to CACHE must be greater than 1
 
 CREATE  SEQUENCE SS2
  INCREMENT BY 2
  MINVALUE 101
  MAXVALUE 110
  CYCLE
  CACHE 2;
 
 
 ALTER SEQUENCE SS2 CACHE 3;
 
 
SQL> ALTER SEQUENCE SS2 CACHE 3;

Sequence altered.

ALTER SEQUENCE SS2 CACHE 3 MINVALUE 1 MAXVALUE 1;

 SQL> ALTER SEQUENCE SS2 CACHE 3 MINVALUE 1 MAXVALUE 1;
ALTER SEQUENCE SS2 CACHE 3 MINVALUE 1 MAXVALUE 1
*
ERROR at line 1:
ORA-04004: MINVALUE must be less than MAXVALUE
 
 --DECREMENTAL sEQUENCE
 
CREATE  SEQUENCE SS3
  INCREMENT BY -1
  MINVALUE 1
  MAXVALUE 5
  CYCLE
  CACHE 2; 
 
 
 SQL> SELECT SS3.NEXTVAL FROM DUAL;

   NEXTVAL
----------
         5

SQL>
SQL> /

   NEXTVAL
----------
         4

SQL> /

   NEXTVAL
----------
         3

SQL> /

   NEXTVAL
----------
         2

SQL> /

   NEXTVAL
----------
         1

SQL> /

   NEXTVAL
----------
         5
 
 CREATE  SEQUENCE SS4
  INCREMENT BY 1
  START WITH 101  --HIGHEST PRIORITY
  MINVALUE 1
  MAXVALUE 105
  CYCLE
  CACHE 2;
  
 SQL> ALTER SEQUENCE SS4  START WITH 2;
ALTER SEQUENCE SS4  START WITH 2
                    *
ERROR at line 1:
ORA-02283: cannot alter starting sequence number
 
 
 CREATE  SEQUENCE SS5
  INCREMENT BY 1
  START WITH 1 --HIGHEST PRIORITY
  MINVALUE 1
  MAXVALUE 10
  CYCLE
  CACHE 11;
 
 
 
SQL> CREATE  SEQUENCE SS5  INCREMENT BY 1  START WITH 1 --HIGHEST PRIORITY  MINVALUE 1  MAXVALUE 10  CYCLE  CACHE 11;

Sequence created.

SQL> DROP SEQUENCE SS5;

Sequence dropped.
 
 
 CREATE  SEQUENCE SS5
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 10
  CYCLE
  CACHE 11;
 
 SQL> CREATE  SEQUENCE SS5  INCREMENT BY 1  MINVALUE 1  MAXVALUE 10  CYCLE  CACHE 11;
CREATE  SEQUENCE SS5  INCREMENT BY 1  MINVALUE 1  MAXVALUE 10  CYCLE  CACHE 11
*
ERROR at line 1:
ORA-04013: number to CACHE must be less than one cycle
 
 IT GET ONLY IN THE ABSEMCE OF (  START WITH  )
 
 
 CREATE  SEQUENCE SS6
  INCREMENT BY 0.1
  MINVALUE 1
  MAXVALUE 10
 
 
 SQL>  CREATE  SEQUENCE SS6  INCREMENT BY 0.1  MINVALUE 1  MAXVALUE 10;
 CREATE  SEQUENCE SS6  INCREMENT BY 0.1  MINVALUE 1  MAXVALUE 10


ERROR at line 1:
ORA-04001: sequence parameter INCREMENT must be an integer

 SQL>  SELECT SS3.NEXTVAL, SS3.NEXTVAL FROM DUAL;

   NEXTVAL    NEXTVAL
---------- ----------
         2          2

SQL>  SELECT SS3.NEXTVAL, SS3.NEXTVAL FROM DUAL;

   NEXTVAL    NEXTVAL
---------- ----------
         1          1
         
  IF WE DROP THEN WE LOSE ALL GRANT PREVILLAGES, SO WE REGRANT ALL PRIVILAGES.       

SYNONYMS
========
SQL> DESC USER_SYNONYMS
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 SYNONYM_NAME                              NOT NULL VARCHAR2(30)
 TABLE_OWNER                                        VARCHAR2(30)
 TABLE_NAME                                NOT NULL VARCHAR2(30)
 DB_LINK                                            VARCHAR2(128)
 
 

CREATE PRIVATE STNONYM SN1 FOR emp;

SQL> CREATE PRIVATE SYNONYM SN1 FOR emp;
CREATE PRIVATE SYNONYM SN1 FOR emp
               *
ERROR at line 1:
ORA-00905: missing keyword

SQL> CREATE  SYNONYM PN1 FOR emp;

Synonym created.

SQL> DESC PN1;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMPNO                                              NUMBER
 ENAME                                              VARCHAR2(10)
 JOB                                                VARCHAR2(9)
 MGR                                                NUMBER
 HIREDATE                                           DATE
 SAL                                                NUMBER
 COMM                                               NUMBER
 DEPTNO                                             NUMBER(2)

SELECT * FROM PN1;

SQL> SELECT * FROM PN1;

     EMPNO ENAME      JOB              MGR HIREDATE         SAL       COMM     DEPTNO
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7566 JONES      MANAGER         7839 02-APR-81       2975                    20
      7788 SCOTT      ANALYST         7566 19-APR-87       3000                    20
      7902 FORD       ANALYST         7566 03-DEC-81       3000                    20
      7369 SMITH      CLERK           7902 17-DEC-80        800                    20
      7876 ADAMS      CLERK           7788 23-MAY-87       1100                    20
      7698 BLAKE      MANAGER         7839 01-MAY-81       2850                    30
      7499 ALLEN      SALESMAN        7698 20-FEB-81       1600        300         30
      7521 WARD       SALESMAN        7698 22-FEB-81       1250        500         30
      7654 MARTIN     SALESMAN        7698 28-SEP-81       1250       1400         30
      7844 TURNER     SALESMAN        7698 08-SEP-81       1500          0         30
      7900 JAMES      CLERK           7698 03-DEC-81        950                    30
      7782 CLARK      MANAGER         7839 09-JUN-81       2450                    10
      7839 KING       PRESIDENT            17-NOV-81       5000                    10
      7934 MILLER     CLERK           7782 23-JAN-82       1300                    10

14 rows selected.

CREATE  SYNONYM SN1 FOR copy_emp;


SYNONYM_NAME                   TABLE_NAME                     TABLE_OWNER
------------------------------ ------------------------------ ------------------------------
PN1                            EMP                            PRVN
SN1                            COPY_EMP                       PRVN


SQL> CREATE  OR REPLACE SYNONYM SN1 FOR copy_emp;

Synonym created.


SQL> RENAME SN1 TO SN2


SQL> SELECT SYNONYM_NAME, TABLE_NAME, TABLE_OWNER FROM  USER_SYNONYMS;

SYNONYM_NAME                   TABLE_NAME                     TABLE_OWNER
------------------------------ ------------------------------ ------------------------------
PN1                            EMP                            PRVN
SN2                            COPY_EMP                       PRVN

TRUNCATE SN2;

SQL> TRUNCATE SN2;
TRUNCATE SN2
           *
ERROR at line 1:
ORA-03290: Invalid truncate command - missing CLUSTER or TABLE keyword

SQL> COMMENT ON SYNONYM SN2 IS 'COMMENT ADDED';
COMMENT ON SYNONYM SN2 IS 'COMMENT ADDED'
           *
ERROR at line 1:
ORA-32594: invalid object category for COMMENT command

 COMMENT ON TABLE SN2 IS 'COMMENT ADDED';


SQL>  COMMENT ON TABLE SN2 IS 'COMMENT ADDED';

Comment created.

SQL> SELECT * FROM   USER_TAB_COMMENTS WHERE table_name ='copy_emp';

no rows selected

SQL> SELECT * FROM   USER_TAB_COMMENTS WHERE table_name ='COPY_EMP';

TABLE_NAME                     TABLE_TYPE
------------------------------ -----------
COMMENTS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COPY_EMP                       TABLE
COMMENT ADDED

SQL> GRANT SELECT ON SN2 TO U1;

Grant succeeded.


SQL> DROP SYNONYM SN2;

Synonym dropped.

PUBLIC SYNONYMS
----------------


SQL> CREATE USER SH IDENTIFIED BY SH;

User created.

GRANT CONNECT, RESOURCE, DBA TO books_admin;

 GRANT CONNECT TO SH;

Warning: You are no longer connected to ORACLE.
SQL>  GRANT CONNECT TO SH;
SP2-0640: Not connected
SQL> CONN prvn/prvn1
Connected.
SQL>  GRANT CONNECT TO SH;

Grant succeeded.


SQL> CREATE OR REPLACE PUBLIC SYNONYM ps1 FOR copy_emp;
CREATE OR REPLACE PUBLIC SYNONYM ps1 FOR copy_emp
*
ERROR at line 1:
ORA-01031: insufficient privileges

SQL> CONN prvn/prvn1
SQL> GRANT CREATE PUBLIC SYNONYM TO SH;

Grant succeeded.

SQL> CONN SH/SH;
Connected.
SQL> CREATE OR REPLACE PUBLIC SYNONYM ps1 FOR copy_emp;

Synonym created.

SQL> CONN prvn/prvn1


SQL> REVOKE CREATE PUBLIC SYNONYM FROM SH;

Revoke succeeded.

SQL> CONN SH/SH
Connected.
SQL> CREATE OR REPLACE PUBLIC SYNONYM ps1 FOR copy_emp;
CREATE OR REPLACE PUBLIC SYNONYM ps1 FOR copy_emp
*
ERROR at line 1:
ORA-01031: insufficient privileges

SQL> CONN prvn/prvn1

SQL> CONN prvn/prvn1
Connected.
SQL> GRANT DBA TO SH;

Grant succeeded.

SQL> CREATE OR REPLACE PUBLIC SYNONYM ps1 FOR copy_emp;

Synonym created.
SQL> select * FROM ALL_USERS;

USERNAME                          USER_ID CREATED
------------------------------ ---------- ---------
XS$NULL                        2147483638 29-MAY-14
SH                                     50 14-DEC-19
U1                                     49 13-DEC-19
PRVN                                   48 02-APR-17
APEX_040000                            47 29-MAY-14
APEX_PUBLIC_USER                       45 29-MAY-14
FLOWS_FILES                            44 29-MAY-14
HR                                     43 29-MAY-14
MDSYS                                  42 29-MAY-14
ANONYMOUS                              35 29-MAY-14
XDB                                    34 29-MAY-14
CTXSYS                                 32 29-MAY-14
APPQOSSYS                              30 29-MAY-14
DBSNMP                                 29 29-MAY-14
ORACLE_OCM                             21 29-MAY-14
DIP                                    14 29-MAY-14
OUTLN                                   9 29-MAY-14
SYSTEM                                  5 29-MAY-14
SYS                                     0 29-MAY-14

19 rows selected.

SQL> CONN prvn/prvn1
Connected.
SQL> GRANT SELECT ON PS1 TO PUBLIC;

Grant succeeded.

SQL> create user u2 identified by u2;

User created.

SQL> select * from ps1;

     EMPNO ENAME      JOB              MGR HIREDATE         SAL       COMM     DEPTNO
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7566 JONES      MANAGER         7839 02-APR-81       2975                    20
      7788 SCOTT      ANALYST         7566 19-APR-87       3000                    20
      7902 FORD       ANALYST         7566 03-DEC-81       3000                    20
      7369 SMITH      CLERK           7902 17-DEC-80        800                    20
      7876 ADAMS      CLERK           7788 23-MAY-87       1100                    20
      7698 BLAKE      MANAGER         7839 01-MAY-81       2850                    30
      7499 ALLEN      SALESMAN        7698 20-FEB-81       1600        300         30
      7521 WARD       SALESMAN        7698 22-FEB-81       1250        500         30
      7654 MARTIN     SALESMAN        7698 28-SEP-81       1250       1400         30
      7844 TURNER     SALESMAN        7698 08-SEP-81       1500          0         30
      7900 JAMES      CLERK           7698 03-DEC-81        950                    30
      7782 CLARK      MANAGER         7839 09-JUN-81       2450                    10
      7839 KING       PRESIDENT            17-NOV-81       5000                    10
      7934 MILLER     CLERK           7782 23-JAN-82       1300                    10

14 rows selected.

Indexes
=======

set lines 120 pages 500  feed 1 numwidth 5




 EMPNO       NUMBER(4)
 ENAME       VARCHAR2(10)
 JOB         VARCHAR2(9)
 MGR         NUMBER
 HIREDATE    DATE
 SAL         NUMBER
 COMM        NUMBER


CREATE TABLE emp_index(
 EMPNO       NUMBER(4),
 ENAME       VARCHAR2(10),
 JOB         VARCHAR2(9),
 SAL         NUMBER(7,2),
 COMM        NUMBER(7,2)
 );           


SQL> CREATE TABLE emp_index( EMPNO NUMBER(4), ENAME  VARCHAR2(10), JOB  VARCHAR2(9), SAL  NUMBER(7,2), COMM NUMBER(7,2) );

Table created.

SQL> INSERT INTO emp_index SELECT empno, ename, job, sal, comm  From emp;

14 rows created.


index segment 

CREATE INDEX i1 on emp_index(empno);

SQL> CREATE INDEX i1 on emp_index(empno);

Index created.

(empno)data copied as it into index segment 

SQL> DROP index i1;

Index dropped.

SQL> CREATE INDEX i1 on emp_index(empno ASC);

Index created.

(empno)data copied as it into index segment in ASC order

SQL> DROP index i1;

Index dropped.


SQL> CREATE INDEX i1 on emp_index(empno DESC);

Index created.
(empno)data copied as it into index segment in DESC order

SQL> CREATE INDEX i2 on emp_index(empno);
CREATE INDEX i2 on emp_index(empno)
             *
ERROR at line 1:
ORA-00955: name is already used by an existing object

SQL> CREATE UNIQUE INDEX i3 on emp_index(job);
CREATE UNIQUE INDEX i3 on emp_index(job)
                          *
ERROR at line 1:
ORA-01452: cannot CREATE UNIQUE INDEX; duplicate keys found

 CREATE UNIQUE INDEX i3 on emp_index(ename);
 
 
SQL>  CREATE UNIQUE INDEX i3 on emp_index(ename);

Index created.

SQL> SELECT index_name, index_type, table_type, uniqueness, status From user_indexes where table_name = 'EMP_INDEX';

INDEX_NAME                     INDEX_TYPE                  TABLE_TYPE  UNIQUENES STATUS
------------------------------ --------------------------- ----------- --------- --------
I1                             FUNCTION-BASED NORMAL       TABLE       NONUNIQUE VALID
I2                             NORMAL                      TABLE       NONUNIQUE VALID
I3                             NORMAL                      TABLE       UNIQUE    VALID

3 rows selected.

SQL> SELECT table_name from DICT where table_name like 'USER_%INDEX%' OR table_name like 'USER_%IND%' ;

TABLE_NAME
------------------------------
USER_ADDM_FINDINGS
USER_ADVISOR_FINDINGS
USER_INDEXES
USER_INDEXTYPES
USER_INDEXTYPE_ARRAYTYPES
USER_INDEXTYPE_COMMENTS
USER_INDEXTYPE_OPERATORS
USER_IND_COLUMNS
USER_IND_EXPRESSIONS
USER_IND_PARTITIONS
USER_IND_PENDING_STATS
USER_IND_STATISTICS
USER_IND_SUBPARTITIONS
USER_JOIN_IND_COLUMNS
USER_OPBINDINGS
USER_PART_INDEXES
USER_SQLSET_BINDS
USER_SQLTUNE_BINDS
USER_XML_INDEXES

19 rows selected.


desc COLUMN_LENGTH, CHAR_LENGTH,

SQL> SELECT INDEX_NAME, TABLE_NAME,  COLUMN_POSITION,  DESCEND, COLUMN_LENGTH, CHAR_LENGTH FROM USER_IND_COLUMNS
     WHERE TABLE_NAME = 'EMP_INDEX';

INDEX_NAME                     TABLE_NAME                     COLUMN_POSITION DESC COLUMN_LENGTH CHAR_LENGTH
------------------------------ ------------------------------ --------------- ---- ------------- -----------
I1                             EMP_INDEX                                    1 DESC            34           0
I2                             EMP_INDEX                                    1 ASC             22           0
I3                             EMP_INDEX                                    1 ASC             10          10


GLOBAL index -- on normal table also;

SQL> CREATE  INDEX i4 on emp_index(job) GLOBAL;

Index created.

SQL> SELECT INDEX_NAME, TABLE_NAME,  COLUMN_POSITION,  DESCEND, COLUMN_LENGTH, CHAR_LENGTH FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'EMP_INDEX';

INDEX_NAME                     TABLE_NAME                     COLUMN_POSITION DESC COLUMN_LENGTH CHAR_LENGTH
------------------------------ ------------------------------ --------------- ---- ------------- -----------
I1                             EMP_INDEX                                    1 DESC            34           0
I2                             EMP_INDEX                                    1 ASC             22           0
I3                             EMP_INDEX                                    1 ASC             10          10
I4                             EMP_INDEX                                    1 ASC              9           9

4 rows selected.

Global by default taking ASC order;


SQL> CREATE  INDEX i4 on emp_index(job) LOCAL;
CREATE  INDEX i4 on emp_index(job) LOCAL
*
ERROR at line 1:
ORA-00439: feature not enabled: Partitioning


SQL> CREATE  INDEX ic1 on emp_index(empno, ename, job);

Index created.

SQL> SELECT INDEX_NAME, TABLE_NAME,  COLUMN_POSITION,  DESCEND, COLUMN_LENGTH, CHAR_LENGTH FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'EMP_INDEX';

INDEX_NAME                     TABLE_NAME                     COLUMN_POSITION DESC COLUMN_LENGTH CHAR_LENGTH
------------------------------ ------------------------------ --------------- ---- ------------- -----------
I1                             EMP_INDEX                                    1 DESC            34           0
I2                             EMP_INDEX                                    1 ASC             22           0
I3                             EMP_INDEX                                    1 ASC             10          10
I4                             EMP_INDEX                                    1 ASC              9           9

IC1                            EMP_INDEX                                    1 ASC             22           0
IC1                            EMP_INDEX                                    2 ASC             10          10
IC1                            EMP_INDEX                                    3 ASC              9           9

7 rows selected.

SQL> drop index ic1;

Index dropped.

SQL> CREATE  INDEX ic1 on emp_index(empno DESC, ename DESC, job DESC);

Index created.

SQL> SELECT INDEX_NAME, TABLE_NAME,  COLUMN_POSITION,  DESCEND, COLUMN_LENGTH, CHAR_LENGTH FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'EMP_INDEX';

INDEX_NAME                     TABLE_NAME                     COLUMN_POSITION DESC COLUMN_LENGTH CHAR_LENGTH
------------------------------ ------------------------------ --------------- ---- ------------- -----------
I1                             EMP_INDEX                                    1 DESC            34           0
I2                             EMP_INDEX                                    1 ASC             22           0
I3                             EMP_INDEX                                    1 ASC             10          10
I4                             EMP_INDEX                                    1 ASC              9           9
IC1                            EMP_INDEX                                    1 DESC            34           0
IC1                            EMP_INDEX                                    2 DESC            16           0
IC1                            EMP_INDEX                                    3 DESC            15           0

7 rows selected.

SQL> COLUMN INDEX_NAME FORMAT A10
SQL> COLUMN INDEX_TYPE FORMAT A30
SQL> COLUMN TABLE_NAME FORMAT A12
SQL> COLUMN COLUMN_NAME FORMAT A15
SQL> SET NUMWIDTH 10
SQL>

SQL> SELECT INDEX_NAME, TABLE_NAME,  COLUMN_POSITION,  DESCEND, COLUMN_LENGTH, CHAR_LENGTH 
      FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'EMP_INDEX';
INDEX_NAME TABLE_NAME   COLUMN_POSITION DESC COLUMN_LENGTH CHAR_LENGTH
---------- ------------ --------------- ---- ------------- -----------
I1         EMP_INDEX                  1 DESC            34           0
I2         EMP_INDEX                  1 ASC             22           0
I3         EMP_INDEX                  1 ASC             10          10
I4         EMP_INDEX                  1 ASC              9           9
IC1        EMP_INDEX                  1 DESC            34           0
IC1        EMP_INDEX                  2 DESC            16           0
IC1        EMP_INDEX                  3 DESC            15           0

7 rows selected.

SQL>
SELECT INDEX_NAME, index_type, TABLE_NAME,  COLUMN_POSITION,  DESCEND, COLUMN_LENGTH, CHAR_LENGTH     
FROM USER_INDEXES ui join USER_IND_COLUMNS uic using(TABLE_NAME, INDEX_NAME) 
where TABLE_NAME ='EMP_INDEX';

INDEX_NAME INDEX_TYPE                     TABLE_NAME   COLUMN_POSITION DESC COLUMN_LENGTH CHAR_LENGTH
---------- ------------------------------ ------------ --------------- ---- ------------- -----------
I1         FUNCTION-BASED NORMAL          EMP_INDEX                  1 DESC            34           0
I2         NORMAL                         EMP_INDEX                  1 ASC             22           0
I3         NORMAL                         EMP_INDEX                  1 ASC             10          10
I4         NORMAL                         EMP_INDEX                  1 ASC              9           9
IC1        FUNCTION-BASED NORMAL          EMP_INDEX                  1 DESC            34           0
IC1        FUNCTION-BASED NORMAL          EMP_INDEX                  2 DESC            16           0
IC1        FUNCTION-BASED NORMAL          EMP_INDEX                  3 DESC            15           0

7 rows selected.


Functional index
----------------
SQL> CREATE  INDEX if5 on emp_index(UPPER(empno));

Index created.

 SQL> CREATE  INDEX if6 on emp_index(sal*2);

Index created.
SQL> CREATE  INDEX if7 on emp_index(sal+comm);

Index created.

 SQL> SELECT INDEX_NAME, index_type, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION,  DESCEND, COLUMN_LENGTH, CHAR_LENGTH    
FROM USER_INDEXES ui join USER_IND_COLUMNS uic using(TABLE_NAME, INDEX_NAME) where TABLE_NAME ='EMP_INDEX';

INDEX_NAME INDEX_TYPE                     TABLE_NAME   COLUMN_POSITION DESC COLUMN_LENGTH CHAR_LENGTH
---------- ------------------------------ ------------ --------------- ---- ------------- -----------
I1         FUNCTION-BASED NORMAL          EMP_INDEX                  1 DESC            34           0
I2         NORMAL                         EMP_INDEX                  1 ASC             22           0
I3         NORMAL                         EMP_INDEX                  1 ASC             10          10
I4         NORMAL                         EMP_INDEX                  1 ASC              9           9
IC1        FUNCTION-BASED NORMAL          EMP_INDEX                  1 DESC            34           0
IC1        FUNCTION-BASED NORMAL          EMP_INDEX                  2 DESC            16           0
IC1        FUNCTION-BASED NORMAL          EMP_INDEX                  3 DESC            15           0
IF5        FUNCTION-BASED NORMAL          EMP_INDEX                  1 ASC             40          40
IF6        FUNCTION-BASED NORMAL          EMP_INDEX                  1 ASC             22           0
IF7        FUNCTION-BASED NORMAL          EMP_INDEX                  1 ASC             22           0


Rever ky indedx
----------------
CREATE  INDEX ir8 on emp_index(sal+comm);                                          
INDEX_NAME INDEX_TYPE                     TABLE_NAME   COLUMN_NAME     COLUMN_POSITION DESC COLUMN_LENGTH CHAR_LENGTH
---------- ------------------------------ ------------ --------------- --------------- ---- ------------- -----------
I1         FUNCTION-BASED NORMAL          EMP_INDEX    SYS_NC00006$                  1 DESC            34           0
I2         NORMAL                         EMP_INDEX    EMPNO                         1 ASC             22           0
I3         NORMAL                         EMP_INDEX    ENAME                         1 ASC             10          10
I4         NORMAL                         EMP_INDEX    JOB                           1 ASC              9           9
IF5        FUNCTION-BASED NORMAL          EMP_INDEX    SYS_NC00007$                  1 ASC             40          40
IF6        FUNCTION-BASED NORMAL          EMP_INDEX    SYS_NC00008$                  1 ASC             22           0
IF7        FUNCTION-BASED NORMAL          EMP_INDEX    SYS_NC00009$                  1 ASC             22           0

7 rows selected.

SQL> drop index i3;

Index dropped.

SQL> CREATE  INDEX ir8 on emp_index(ename) REVERSE;

Index created.


SQL> SELECT INDEX_NAME, index_type, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION,  DESCEND, COLUMN_LENGTH, CHAR_LENGTH  
     FROM USER_INDEXES ui join USER_IND_COLUMNS uic using(TABLE_NAME, INDEX_NAME) where TABLE_NAME ='EMP_INDEX';

INDEX_NAME INDEX_TYPE                     TABLE_NAME   COLUMN_NAME     COLUMN_POSITION DESC COLUMN_LENGTH CHAR_LENGTH
---------- ------------------------------ ------------ --------------- --------------- ---- ------------- -----------
I1         FUNCTION-BASED NORMAL          EMP_INDEX    SYS_NC00006$                  1 DESC            34           0
I2         NORMAL                         EMP_INDEX    EMPNO                         1 ASC             22           0
IR8        NORMAL/REV                     EMP_INDEX    ENAME                         1 ASC             10          10
I4         NORMAL                         EMP_INDEX    JOB                           1 ASC              9           9
IF5        FUNCTION-BASED NORMAL          EMP_INDEX    SYS_NC00007$                  1 ASC             40          40
IF6        FUNCTION-BASED NORMAL          EMP_INDEX    SYS_NC00008$                  1 ASC             22           0
IF7        FUNCTION-BASED NORMAL          EMP_INDEX    SYS_NC00009$                  1 ASC             22           0

7 rows selected.
                                          
 INDEX ORGANIZED TABLES(IOT)
 ---------------------------

SQL> drop table emp_index purge;

Table dropped.
Purge removes from recycle bin also.                                          
                                          
SQL> CREATE TABLE emp_iot(
  2   EMPNO       NUMBER(4),
  3   ENAME       VARCHAR2(10),
  4   JOB         VARCHAR2(9),
  5   SAL         NUMBER(7,2),
  6   COMM        NUMBER(7,2)
  7   ) ORGANIZATION INDEX;
 ) ORGANIZATION INDEX
                *
ERROR at line 7:
ORA-25175: no PRIMARY KEY constraint found
  
                                    with unique
SQL> CREATE TABLE emp_iot(
  EMPNO       NUMBER(4) unique,
  ENAME       VARCHAR2(10),
  JOB         VARCHAR2(9),
  SAL         NUMBER(7,2),
  COMM        NUMBER(7,2)
  ) ORGANIZATION INDEX;
 ) ORGANIZATION INDEX
                *
ERROR at line 7:
ORA-25175: no PRIMARY KEY constraint found
                                          
 SQL> CREATE TABLE emp_iot(
   EMPNO       NUMBER(4) Primary key,
   ENAME       VARCHAR2(10),
   JOB         VARCHAR2(9),
   SAL         NUMBER(7,2),
   COMM        NUMBER(7,2)
   ) ORGANIZATION INDEX;

Table created.
 
 SQL> CREATE TABLE emp_normal(
    EMPNO       NUMBER(4) ,
    ENAME       VARCHAR2(10),
    JOB         VARCHAR2(9),
    SAL         NUMBER(7,2),
    COMM        NUMBER(7,2)
    ) ;

Table created.
                                          
INSERT INTO emp_index SELECT empno, ename, job, sal, comm  From emp;                                          
SQL> commit;

Commit complete.                                          
                                          
insert into emp_iot (empno) values(2);                                          
insert into emp_iot (empno) values(1);                                        
insert into emp_iot (empno) values(4);                                        
insert into emp_iot (empno) values(5);                                        
insert into emp_iot (empno) values(6);                                        
insert into emp_iot (empno) values(7);
insert into emp_iot (empno) values(9);
insert into emp_iot (empno) values(8);


     EMPNO ENAME      JOB              SAL       COMM
---------- ---------- --------- ---------- ----------
         1
         4
         5
         6
         7
         8
         9

Its in sorted order
-------------------

ont update the data rearranges automatically

IOT FLASHBACK
------------
 flashback table EMP_IOT TO BEFORE DROP;
 
 SQL> flashback table EMP_IOT TO BEFORE DROP;
flashback table EMP_IOT TO BEFORE DROP
*
ERROR at line 1:
ORA-38305: object not in RECYCLE BIN


SQL> SHO RECYCLEBIN;
SQL> ;
  1* flashback table EMP_IOT TO BEFORE DROP
SQL> SELECT * FROM TAB WHERE TNAME='EMP_IOT';

TNAME                          TABTYPE  CLUSTERID
------------------------------ ------- ----------
EMP_IOT                        TABLE

1 row selected.

SELECT * FROM USER_TABLES;
SQL> SELECT TABLE_NAME, IOT_NAME, IOT_TYPE FROM USER_TABLES WHERE TABLE_NAME = 'EMP_IOT';

TABLE_NAME   IOT_NAME                       IOT_TYPE
------------ ------------------------------ ------------
EMP_IOT                                     IOT

1 row selected.

SQL> DESC USER_OBJECTS;
 Name                                                              Null?    Type
 ----------------------------------------------------------------- -------- --------------------------------------------
 OBJECT_NAME                                                                VARCHAR2(128)
 SUBOBJECT_NAME                                                             VARCHAR2(30)
 OBJECT_ID                                                                  NUMBER
 DATA_OBJECT_ID                                                             NUMBER
 OBJECT_TYPE                                                                VARCHAR2(19)
 CREATED                                                                    DATE
 LAST_DDL_TIME                                                              DATE
 TIMESTAMP                                                                  VARCHAR2(19)
 STATUS                                                                     VARCHAR2(7)
 TEMPORARY                                                                  VARCHAR2(1)
 GENERATED                                                                  VARCHAR2(1)
 SECONDARY                                                                  VARCHAR2(1)
 NAMESPACE                                                                  NUMBER
 EDITION_NAME                                                               VARCHAR2(30)


COLUMN OBJECT_NAME FORMAT A50
COLUMN OBJECT_TYPE FORMAT A50

OBJECT_NAME                                        OBJECT_TYPE
-------------------------------------------------- --------------------------------------------------
EMP_IOT                                            TABLE

1 row selected.


OBJECT TYPES
=============

SQL> DESC USER_TYPES
 Name                                                              Null?    Type
 ----------------------------------------------------------------- -------- --------------------------------------------
 TYPE_NAME                                                         NOT NULL VARCHAR2(30)
 TYPE_OID                                                          NOT NULL RAW(16)
 TYPECODE                                                                   VARCHAR2(30)
 ATTRIBUTES                                                                 NUMBER
 METHODS                                                                    NUMBER
 PREDEFINED                                                                 VARCHAR2(3)
 INCOMPLETE                                                                 VARCHAR2(3)
 FINAL                                                                      VARCHAR2(3)
 INSTANTIABLE                                                               VARCHAR2(3)
 SUPERTYPE_OWNER                                                            VARCHAR2(30)
 SUPERTYPE_NAME                                                             VARCHAR2(30)
 LOCAL_ATTRIBUTES                                                           NUMBER
 LOCAL_METHODS                                                              NUMBER
 TYPEID                                                                     RAW(16)

SQL> SELECT TYPE_NAME,  ATTRIBUTES, INSTANTIABLE, METHODS FROM USER_TYPES;

no rows selected

SQL>


CREATE Or Replace TYPE Type_Address AS OBJECT (
hno number(3),
street VARCHAR2(5),
city   VARCHAR2(5)
);
 /

 CREATE Or Replace TYPE Type_Address AS OBJECT (
hno number(3),
street VARCHAR2(5),
city   VARCHAR2(5)
);
 /
 
 COLUMN TYPE_NAME FORMAT A20;
 COLUMN TYPECODE FORMAT A10;
 COLUMN INDEX_NAME FORMAT A10;
 COLUMN INDEX_NAME FORMAT A10;
 
Type created.

SQL> SELECT TYPE_NAME, TYPECODE,  ATTRIBUTES, INSTANTIABLE, METHODS FROM USER_TYPES;

TYPE_NAME            TYPECODE   ATTRIBUTES INS    METHODS
-------------------- ---------- ---------- --- ----------
TYPE_ADDRESS         OBJECT              3 YES          0

COLUMN object_name FORMAT A20;


SQL> SELECT object_name,object_type, status FROM user_objects WHERE object_type = 'TYPE';

OBJECT_NAME          OBJECT_TYPE         STATUS
-------------------- ------------------- -------
TYPE_ADDRESS         TYPE                VALID


SQL> DESC TYPE_ADDRESS;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 HNO                                                NUMBER(3)
 STREET                                             VARCHAR2(5)
 CITY                                               VARCHAR2(5)

SQL>  INSERT INTO TYPE_ADDRESS (HNO, STREE, CITY) VALUES(1, 'A', 'C');
 INSERT INTO TYPE_ADDRESS (HNO, STREE, CITY) VALUES(1, 'A', 'C')
             *
ERROR at line 1:
ORA-04044: procedure, function, package, or type is not allowed here



SQL> ALTER TYPE TYPE_ADDRESS FINAL;

Type altered.

SQL> ALTER TYPE TYPE_ADDRESS NOT FINAL;

Type altered.

SQL> ALTER TYPE TYPE_ADDRESS INSTANTIABLE;

Type altered.

SQL> ALTER TYPE TYPE_ADDRESS NOT INSTANTIABLE;

Type altered.

SQL> ALTER TYPE TYPE_ADDRESS ADD (C1 NUMBER);
ALTER TYPE TYPE_ADDRESS ADD (C1 NUMBER)
*
ERROR at line 1:
ORA-06545: PL/SQL: compilation error - compilation aborted
ORA-06550: line 10, column 30:
PLS-00103: Encountered the symbol "(" when expecting one of the following:
not final instantiable order overriding static member
constructor map attribute
The symbol "attribute" was substituted for "(" to continue.
ORA-06550: line 0, column 0:
PLS-00565: TYPE_ADDRESS must be completed as a potential REF target (object
type)

DDL OPERATIONS
----------------------------------------
SQL> ALTER TYPE TYPE_ADDRESS ADD ATTRIBUTE(C1 NUMBER);

Type altered.

SQL> ALTER TYPE TYPE_ADDRESS ADD ATTRIBUTE C1 NUMBER;
ALTER TYPE TYPE_ADDRESS ADD ATTRIBUTE C1 NUMBER
*
ERROR at line 1:
ORA-22324: altered type has compilation errors
ORA-22328: object "PRVN"."TYPE_ADDRESS" has errors.
PLS-00410: duplicate fields in RECORD,TABLE or argument list are not permitted
ORA-06550: line 0, column 0:
PL/SQL: Compilation unit analysis terminated


SQL> ALTER TYPE TYPE_ADDRESS ADD ATTRIBUTE C2 NUMBER;

Type altered.

SQL> ALTER TYPE TYPE_ADDRESS DROP C2;
ALTER TYPE TYPE_ADDRESS DROP C2
*
ERROR at line 1:
ORA-06545: PL/SQL: compilation error - compilation aborted
ORA-06550: line 12, column 31:
PLS-00103: Encountered the symbol "C2" when expecting one of the following:
not final instantiable order overriding static member
constructor map attribute
The symbol "attribute" was substituted for "C2" to continue.
ORA-06550: line 0, column 0:
PLS-00565: TYPE_ADDRESS must be completed as a potential REF target (object
type)


SQL> ALTER TYPE TYPE_ADDRESS DROP ATTRIBUTE C2;

Type altered.

SQL> ALTER TYPE TYPE_ADDRESS DROP ATTRIBUTE C1;

Type altered.

SQL> DESC TYPE_ADDRESS
ERROR:
ORA-22337: the type of accessed object has been evolved


SQL> ALTER TYPE TYPE_ADDRESS COMPILE;

Type altered.

SQL> DESC TYPE_ADDRESS
ERROR:
ORA-22337: the type of accessed object has been evolved

ITS not adviasable to alter type


SQL> DROP TYPE TYPE_ADDRESS;

Type dropped.

SQL> SELECT object_name,object_type, status FROM user_objects WHERE object_type = 'TYPE';

no rows selected

CREATE OBJECT WITH 2 LEVELS
---------------------------

SQL> CREATE Or Replace TYPE AREA_Type AS OBJECT (
  street VARCHAR2(5),
  LOCALITY   VARCHAR2(5)
  );
  /

Type created.

SQL> CREATE Or Replace TYPE ADD_Type AS OBJECT (
  area AREA_Type,
  CITY   VARCHAR2(5)
  );
  /

Type created.

SQL> DESC ADD_Type
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 AREA                                               AREA_TYPE
 CITY                                               VARCHAR2(5)

SQL> SELECT object_name,object_type, status FROM user_objects WHERE object_type = 'TYPE';

OBJECT_NAME          OBJECT_TYPE         STATUS
-------------------- ------------------- -------
ADD_TYPE             TYPE                VALID
AREA_TYPE            TYPE                VALID

SQL> SHOW DESC
describe DEPTH 1 LINENUM OFF INDENT ON
SQL> SET DESC DEPTH 2
SQL> SHOW DESC
describe DEPTH 2 LINENUM OFF INDENT ON
SQL> DESC ADD_Type
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 AREA                                               AREA_TYPE
   STREET                                           VARCHAR2(5)
   LOCALITY                                         VARCHAR2(5)
 CITY                                               VARCHAR2(5)

SQL> CREATE Or Replace TYPE ADDRESS_Type AS OBJECT (
  2  area ADD_Type,
  3  PIN   NUMBER(6)
  4  );
  5  /

Type created.

SQL> SHOW DESC
describe DEPTH 2 LINENUM OFF INDENT ON
SQL> SET DESC DEPTH 3
SQL> DESC ADDRESS_Type
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 AREA                                               ADD_TYPE
   AREA                                             AREA_TYPE
     STREET                                         VARCHAR2(5)
     LOCALITY                                       VARCHAR2(5)
   CITY                                             VARCHAR2(5)
 PIN                                                NUMBER(6)

SQL> SELECT object_name,object_type, status FROM user_objects WHERE object_type = 'TYPE';

OBJECT_NAME          OBJECT_TYPE         STATUS
-------------------- ------------------- -------
ADD_TYPE             TYPE                VALID
ADDRESS_TYPE         TYPE                VALID
AREA_TYPE            TYPE                VALID


SQL> DROP TYPE ADD_TYPE;
DROP TYPE ADD_TYPE
*
ERROR at line 1:
ORA-02303: cannot drop or replace a type with type or table dependents


SQL> DROP TYPE ADDRESS_TYPE;

Type dropped.

SQL> SELECT object_name,object_type, status FROM user_objects WHERE object_type = 'TYPE';

OBJECT_NAME          OBJECT_TYPE         STATUS
-------------------- ------------------- -------
ADD_TYPE             TYPE                VALID
AREA_TYPE            TYPE                VALID

SQL> DROP TYPE ADD_TYPE;

Type dropped.

SQL> DROP TYPE AREA_TYPE;

Type dropped.

SQL> SELECT object_name,object_type, status FROM user_objects WHERE object_type = 'TYPE';

no rows selected

OBJECT TABLE
------------

SQL> CREATE Or Replace TYPE AREA_Type AS OBJECT (
  2  street VARCHAR2(5),
  3  LOCALITY   VARCHAR2(5)
  4  );
  5  /

Type created.

SQL>
SQL> CREATE Or Replace TYPE ADD_Type AS OBJECT (
  2  area AREA_Type,
  3  CITY   VARCHAR2(5)
  4  );
  5  /

Type created.

SQL>
SQL>
SQL> CREATE Or Replace TYPE ADDRESS_Type AS OBJECT (
  2  area ADD_Type,
  3  PIN   NUMBER(6)
  4  );
  5  /

Type created.

SQL> DESC ADDRESS_Type
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 AREA                                               ADD_TYPE
   AREA                                             AREA_TYPE
     STREET                                         VARCHAR2(5)
     LOCALITY                                       VARCHAR2(5)
   CITY                                             VARCHAR2(5)
 PIN                                                NUMBER(6)

SQL> SET DESC DEPTH 5;
SQL> DESC ADDRESS_Type
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 AREA                                               ADD_TYPE
   AREA                                             AREA_TYPE
     STREET                                         VARCHAR2(5)
     LOCALITY                                       VARCHAR2(5)
   CITY                                             VARCHAR2(5)
 PIN                                                NUMBER(6)

SQL> CREATE TABLE EMP_TYPE1(
     EMPNO NUMBER(4),
     ENAME VARCHAR(6),
     ADDRESS AREA_TYPE,
     SAL NUMBER(5)
     );

Table created.

SQL> DESC EMP_TYPE1
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMPNO                                              NUMBER(4)
 ENAME                                              VARCHAR2(6)
 ADDRESS                                            AREA_TYPE
   STREET                                           VARCHAR2(5)
   LOCALITY                                         VARCHAR2(5)
 SAL                                                NUMBER(5)

SQL> SQL> CREATE TABLE EMP_TYPE2(
  2  EMPNO NUMBER(4),
  3  ENAME VARCHAR(6),
  4  ADDRESS ADD_Type,
  5  SAL NUMBER(5)
  6  );


Table created.

SQL>
SQL> CREATE TABLE EMP_TYPE3(
  EMPNO NUMBER(4),
  ENAME VARCHAR(6),
  ADDRESS ADDRESS_Type,
  SAL NUMBER(5)
  );

Table created.

SQL> DESC EMP_TYPE1
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMPNO                                              NUMBER(4)
 ENAME                                              VARCHAR2(6)
 ADDRESS                                            AREA_TYPE
   STREET                                           VARCHAR2(5)
   LOCALITY                                         VARCHAR2(5)
 SAL                                                NUMBER(5)

SQL> DESC EMP_TYPE2
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMPNO                                              NUMBER(4)
 ENAME                                              VARCHAR2(6)
 ADDRESS                                            ADDRESS_TYPE
   AREA                                             ADD_TYPE
     AREA                                           AREA_TYPE
       STREET                                       VARCHAR2(5)
       LOCALITY                                     VARCHAR2(5)
     CITY                                           VARCHAR2(5)
   PIN                                              NUMBER(6)
 SAL                                                NUMBER(5)

SQL> DESC EMP_TYPE3
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMPNO                                              NUMBER(4)
 ENAME                                              VARCHAR2(6)
 ADDRESS                                            ADDRESS_TYPE
   AREA                                             ADD_TYPE
     AREA                                           AREA_TYPE
       STREET                                       VARCHAR2(5)
       LOCALITY                                     VARCHAR2(5)
     CITY                                           VARCHAR2(5)
   PIN                                              NUMBER(6)
 SAL                                                NUMBER(5)
INSERT INTO EMP_TYPE1 VALUES(1,'A',AREA_TYPE('S1','L1'), 100);
INSERT INTO EMP_TYPE1 VALUES(2,'B',AREA_TYPE('S2','L2'),200 );
INSERT INTO EMP_TYPE1 VALUES(3,'C',AREA_TYPE('S3','L3'),300 );
INSERT INTO EMP_TYPE1 VALUES(4,'D',AREA_TYPE('S4','L4'),400 ); 
INSERT INTO EMP_TYPE1 VALUES(5,'E',AREA_TYPE('S5','L5'),500 ); 
INSERT INTO EMP_TYPE1 VALUES(6,'F',AREA_TYPE('S6','L6'),600 ); 

INSERT INTO EMP_TYPE2 VALUES(1,'A',ADD_TYPE(AREA_TYPE('S1','L1'), 'C1'), 100);
INSERT INTO EMP_TYPE2 VALUES(2,'B',ADD_TYPE(AREA_TYPE('S2','L2'), 'C2'),200 );
INSERT INTO EMP_TYPE2 VALUES(3,'C',ADD_TYPE(AREA_TYPE('S3','L3'), 'C3'),300 );
INSERT INTO EMP_TYPE2 VALUES(4,'D',ADD_TYPE(AREA_TYPE('S4','L4'), 'C4'),400 ); 
INSERT INTO EMP_TYPE2 VALUES(5,'E',ADD_TYPE(AREA_TYPE('S5','L5'), 'C5'),500 ); 
INSERT INTO EMP_TYPE2 VALUES(6,'F',ADD_TYPE(AREA_TYPE('S6','L6'), 'C6'),600 ); 

COMMIT;

INSERT INTO EMP_TYPE3 VALUES(1,'A',ADDRESS_Type(ADD_TYPE(AREA_TYPE('S1','L1'), 'C1'), 100), 112);
INSERT INTO EMP_TYPE3 VALUES(2,'B',ADDRESS_Type(ADD_TYPE(AREA_TYPE('S2','L2'), 'C2'),200 ),112);
INSERT INTO EMP_TYPE3 VALUES(3,'C',ADDRESS_Type(ADD_TYPE(AREA_TYPE('S3','L3'), 'C3'),300 ),112);
INSERT INTO EMP_TYPE3 VALUES(4,'D',ADDRESS_Type(ADD_TYPE(AREA_TYPE('S4','L4'), 'C4'),400 ),112); 
INSERT INTO EMP_TYPE3 VALUES(5,'E',ADDRESS_Type(ADD_TYPE(AREA_TYPE('S5','L5'), 'C5'),500 ),112); 
INSERT INTO EMP_TYPE3 VALUES(6,'F',ADDRESS_Type(ADD_TYPE(AREA_TYPE('S6','L6'), 'C6'),600 ),112); 

COMMIT;

SQL> DESC EMP_TYPE1;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMPNO                                              NUMBER(4)
 ENAME                                              VARCHAR2(6)
 ADDRESS                                            AREA_TYPE
   STREET                                           VARCHAR2(5)
   LOCALITY                                         VARCHAR2(5)
 SAL                                                NUMBER(5)

SQL> COLUMN ADDRESS FORMAT A21;
SQL> SELECT * FROM EMP_TYPE1;

     EMPNO ENAME  ADDRESS(STREET, LOCAL        SAL
---------- ------ --------------------- ----------
         1 A      AREA_TYPE('S1', 'L1')        100
         2 B      AREA_TYPE('S2', 'L2')        200
         3 C      AREA_TYPE('S3', 'L3')        300
         4 D      AREA_TYPE('S4', 'L4')        400
         5 E      AREA_TYPE('S5', 'L5')        500
         6 F      AREA_TYPE('S6', 'L6')        600
         1 A      AREA_TYPE('S1', 'L1')        100
         2 B      AREA_TYPE('S2', 'L2')        200
         3 C      AREA_TYPE('S3', 'L3')        300
         4 D      AREA_TYPE('S4', 'L4')        400
         5 E      AREA_TYPE('S5', 'L5')        500

     EMPNO ENAME  ADDRESS(STREET, LOCAL        SAL
---------- ------ --------------------- ----------
         6 F      AREA_TYPE('S6', 'L6')        600

12 rows selected.

SQL> DESC EMP_TYPE2;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMPNO                                              NUMBER(4)
 ENAME                                              VARCHAR2(6)
 ADDRESS                                            ADD_TYPE
   AREA                                             AREA_TYPE
     STREET                                         VARCHAR2(5)
     LOCALITY                                       VARCHAR2(5)
   CITY                                             VARCHAR2(5)
 SAL                                                NUMBER(5)

SQL> COLUMN ADDRESS FORMAT A41;
SQL> SELECT * FROM EMP_TYPE2;

     EMPNO ENAME  ADDRESS(AREA(STREET, LOCALITY), CITY)            SAL
---------- ------ ----------------------------------------- ----------
         1 A      ADD_TYPE(AREA_TYPE('S1', 'L1'), 'C1')            100
         2 B      ADD_TYPE(AREA_TYPE('S2', 'L2'), 'C2')            200
         3 C      ADD_TYPE(AREA_TYPE('S3', 'L3'), 'C3')            300
         4 D      ADD_TYPE(AREA_TYPE('S4', 'L4'), 'C4')            400
         5 E      ADD_TYPE(AREA_TYPE('S5', 'L5'), 'C5')            500
         6 F      ADD_TYPE(AREA_TYPE('S6', 'L6'), 'C6')            600

6 rows selected.

 SQL> COLUMN ADDRESS FORMAT A61;
SQL> DESC EMP_TYPE3;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMPNO                                              NUMBER(4)
 ENAME                                              VARCHAR2(6)
 ADDRESS                                            ADDRESS_TYPE
   AREA                                             ADD_TYPE
     AREA                                           AREA_TYPE
       STREET                                       VARCHAR2(5)
       LOCALITY                                     VARCHAR2(5)
     CITY                                           VARCHAR2(5)
   PIN                                              NUMBER(6)
 SAL                                                NUMBER(5)

SQL> SELECT * FROM EMP_TYPE3;

     EMPNO ENAME  ADDRESS(AREA(AREA(STREET, LOCALITY), CITY), PIN)                     SAL
---------- ------ ------------------------------------------------------------- ----------
         1 A      ADDRESS_TYPE(ADD_TYPE(AREA_TYPE('S1', 'L1'), 'C1'), 100)             112
         1 A      ADDRESS_TYPE(ADD_TYPE(AREA_TYPE('S1', 'L1'), 'C1'), 100)             112
         2 B      ADDRESS_TYPE(ADD_TYPE(AREA_TYPE('S2', 'L2'), 'C2'), 200)             112
         3 C      ADDRESS_TYPE(ADD_TYPE(AREA_TYPE('S3', 'L3'), 'C3'), 300)             112
         4 D      ADDRESS_TYPE(ADD_TYPE(AREA_TYPE('S4', 'L4'), 'C4'), 400)             112
         5 E      ADDRESS_TYPE(ADD_TYPE(AREA_TYPE('S5', 'L5'), 'C5'), 500)             112
         6 F      ADDRESS_TYPE(ADD_TYPE(AREA_TYPE('S6', 'L6'), 'C6'), 600)             112

7 rows selected.


SQL> SELECT EMPNO, ENAME, SAL, ADDRESS FROM EMP_TYPE1;

     EMPNO ENAME         SAL ADDRESS(STREET, LOCAL
---------- ------ ---------- ---------------------
         1 A             100 AREA_TYPE('S1', 'L1')
         2 B             200 AREA_TYPE('S2', 'L2')
         3 C             300 AREA_TYPE('S3', 'L3')
         4 D             400 AREA_TYPE('S4', 'L4')
         5 E             500 AREA_TYPE('S5', 'L5')
         6 F             600 AREA_TYPE('S6', 'L6')
         1 A             100 AREA_TYPE('S1', 'L1')
         2 B             200 AREA_TYPE('S2', 'L2')
         3 C             300 AREA_TYPE('S3', 'L3')
         4 D             400 AREA_TYPE('S4', 'L4')
         5 E             500 AREA_TYPE('S5', 'L5')

     EMPNO ENAME         SAL ADDRESS(STREET, LOCAL
---------- ------ ---------- ---------------------
         6 F             600 AREA_TYPE('S6', 'L6')

SQL> SELECT EMPNO, ENAME, SAL, T1.ADDRESS.STREET FROM EMP_TYPE1 T1;

     EMPNO ENAME         SAL ADDRE
---------- ------ ---------- -----
         1 A             100 S1
         2 B             200 S2
         3 C             300 S3
         4 D             400 S4
         5 E             500 S5
         6 F             600 S6
         1 A             100 S1
         2 B             200 S2
         3 C             300 S3
         4 D             400 S4
         5 E             500 S5
         6 F             600 S6

12 rows selected.

SQL> SELECT EMPNO, ENAME, SAL, ADDRESS.STREET FROM EMP_TYPE1 T1;
SELECT EMPNO, ENAME, SAL, ADDRESS.STREET FROM EMP_TYPE1 T1
                          *
ERROR at line 1:
ORA-00904: "ADDRESS"."STREET": invalid identifier

                                     
   SELECT EMPNO, ENAME, SAL, T1.ADDRESS.STREET FROM EMP_TYPE1 T1;
T1 - ALIAS NAME MANDATORY TO ACCESS OBJECT VALUES
ADDRESS - COLUMN NAME WE NEED TO SPECIFY, BUT NOT OBJECT TYPE                                     
                                     
SQL> SELECT EMPNO, ENAME, SAL, T2.ADDRESS.AREA.STREET FROM EMP_TYPE2 T2;

     EMPNO ENAME         SAL ADDRE
---------- ------ ---------- -----
         1 A             100 S1
         2 B             200 S2
         3 C             300 S3
         4 D             400 S4
         5 E             500 S5
         6 F             600 S6

6 rows selected.                                     
                                     
  SQL> DESC EMP_TYPE3;
 Name                                                  Null?    Type
 ----------------------------------------------------- -------- ------------------------------------
 EMPNO                                                          NUMBER(4)
 ENAME                                                          VARCHAR2(6)
 ADDRESS                                                        ADDRESS_TYPE
   AREA                                                         ADD_TYPE
     AREA                                                       AREA_TYPE
       STREET                                                   VARCHAR2(5)
       LOCALITY                                                 VARCHAR2(5)
     CITY                                                       VARCHAR2(5)
   PIN                                                          NUMBER(6)
 SAL                                                            NUMBER(5)

SQL> SELECT EMPNO, ENAME, SAL, T3.ADDRESS.AREA.AREA.STREET FROM EMP_TYPE3 T3;

     EMPNO ENAME         SAL ADDRE
---------- ------ ---------- -----
         1 A             112 S1
         1 A             112 S1
         2 B             112 S2
         3 C             112 S3
         4 D             112 S4
         5 E             112 S5
         6 F             112 S6

7 rows selected.
                                     
 SQL> SELECT EMPNO, ENAME, SAL, T3.ADDRESS.AREA.AREA.STREET AS STREET FROM EMP_TYPE3 T3 WHERE T3.ADDRESS.AREA.AREA.STREET = 'S3';

     EMPNO ENAME         SAL STREE
---------- ------ ---------- -----
         3 C             112 S3
                                    
UPDATE SET T3.ADDRESS.AREA.AREA.STREET = 'S311'  FROM EMP_TYPE3 T3 WHERE T3.ADDRESS.AREA.AREA.STREET = 'S3'                                   
                                     
 SQL> UPDATE EMP_TYPE3 T3 SET T3.ADDRESS.AREA.AREA.STREET = 'S311'  WHERE T3.ADDRESS.AREA.AREA.STREET = 'S3' ;

1 row updated.

SQL> SELECT EMPNO, ENAME, SAL, T3.ADDRESS.AREA.AREA.STREET AS STREET FROM EMP_TYPE3 T3 WHERE T3.ADDRESS.AREA.AREA.STREET = 'S3';

no rows selected

SQL> SELECT EMPNO, ENAME, SAL, T3.ADDRESS.AREA.AREA.STREET AS STREET FROM EMP_TYPE3 T3 WHERE T3.ADDRESS.AREA.AREA.STREET = 'S311';

     EMPNO ENAME         SAL STREE
---------- ------ ---------- -----
         3 C             112 S311
                                    
                                     
NESTED TABLES
------------

SQL> CREATE OR REPLACE TYPE PROJECT_TYPE AS OBJECT (
  NAME VARCHAR(6),
  ROLE NUMBER(5)
  );
  /

Type created.

SQL> CREATE OR REPLACE TYPE PROJECT_TABLE AS TABLE OF PROJECT_TYPE;
    /

Warning: Type created with compilation errors.

SQL> CREATE TYPE PROJECT_TABLE AS TABLE OF PROJECT_TYPE;
    /

Type created.                                  
                                     
SQL> CREATE TABLE EMP_NT(
    EMPNO NUMBER(4),
    ENAME VARCHAR(6),
    PROJECTS PROJECT_TABLE
    )
    NESTED TABLE PROJECTS STORE AS PROJECTS_NT;

Table created.
                                     
 SQL> INSERT INTO EMP_NT VALUES(1, 'PRAVEE', PROJECT_table(PROJECT_TYPE('NAME1', 1), PROJECT_TYPE('NAME2', 2)));

1 row created.

                                                                                                  SQL> show desc
describe DEPTH 1 LINENUM OFF INDENT ON
SQL> set desc depth 3
SQL> desc emp_nt;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMPNO                                              NUMBER(4)
 ENAME                                              VARCHAR2(6)
 PROJECTS                                           PROJECT_TABLE
   NAME                                             VARCHAR2(6)
   ROLE                                             NUMBER(5)
                                     
                                     
                                     
