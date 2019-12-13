View 

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
