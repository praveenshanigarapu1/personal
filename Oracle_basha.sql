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
