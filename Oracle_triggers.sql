28.Trigger

Introduction 

	28.1.1.	A trigger is an event within the DBMS that can cause some code to execute automatically.
  
  There are four types of database triggers:

1.Table-level triggers can initiate activity before or after an INSERT, UPDATE, or DELETE event.
2.View-level triggers defines what can be done to the view.
3.Database-level triggers can be activated at startup and shutdown of a database.
4.Session-level triggers can be used to store specific information.

SQL> create table company(
       product_id        number(4)    not null,
       company_id          NUMBER(8)    not null,
       company_short_name  varchar2(30) not null,
       company_long_name   varchar2(60)
    );
    
 SQL> create table product_audit(
     product_id number(4) not null,
     num_rows number(8) not null
  );


SQL> CREATE OR REPLACE TRIGGER myTrigger
  AFTER INSERT ON company
  FOR EACH ROW
  BEGIN
    UPDATE product_audit
    SET num_rows =num_rows+1
    WHERE product_id =:NEW.product_id;
    IF (SQL%NOTFOUND) THEN
      INSERT INTO product_audit VALUES (:NEW.product_id,1);
    END IF;
  END;
  /
28.1.2.	Placing triggers on tables

Statement-level triggers

Use statement-level triggers when you need to check business rules that are not row dependent

SQL> create table Employee(
    ID                 VARCHAR2(4 BYTE)         NOT NULL primary key,
    First_Name         VARCHAR2(10 BYTE),
    Last_Name          VARCHAR2(10 BYTE),
    Start_Date         DATE,
    End_Date           DATE,
    Salary             Number(8,2),
    City               VARCHAR2(10 BYTE),
    Description        VARCHAR2(15 BYTE)
  )
  /
 
 
 SQL> create or replace trigger emp_bid
   before insert or delete
   on employee
   referencing new as new old as old
  begin
      if to_char(sysdate,'Dy') in ('Sat','Sun') then
          raise_application_error(-20999,'No create/delete employees on weekend!');
      end if;
  end;
  /
 
 28.1.3.Trigger Which Modifies a Mutating Table
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

SQL> CREATE OR REPLACE TRIGGER LimitSalary
    BEFORE INSERT OR UPDATE OF salary ON employee
    FOR EACH ROW
  DECLARE
    v_MaxSalary CONSTANT NUMBER := 2000;
    v_CurrentSalary NUMBER;
  BEGIN
    SELECT salary
      INTO v_CurrentSalary
      FROM employee
      WHERE id = :new.id;

    IF v_CurrentSalary > v_MaxSalary THEN
      RAISE_APPLICATION_ERROR(-20000, 'Too high in salary ' || :new.id);
    END IF;
  END LimitSalary;
  /
28.1.4.	Solution for the Mutating Tables Problem
SQL> CREATE OR REPLACE PACKAGE EmployeeData AS
     TYPE t_Salary IS TABLE OF employee.salary%TYPE INDEX BY BINARY_INTEGER;
     TYPE t_IDs IS TABLE OF employee.ID%TYPE INDEX BY BINARY_INTEGER;
 
     v_EmployeeSalary t_Salary;
     v_EmployeeIDs    t_IDs;
     v_NumEntries    BINARY_INTEGER := 0;
   END EmployeeData;
   /


SQL> CREATE OR REPLACE TRIGGER RLimitSalary
    BEFORE INSERT OR UPDATE OF salary ON employee
    FOR EACH ROW
  BEGIN
    /* Record the new data in EmployeeData. We don't make any
       changes to employee, to avoid the ORA-4091 error. */
    EmployeeData.v_NumEntries := EmployeeData.v_NumEntries + 1;
    EmployeeData.v_EmployeeSalary(EmployeeData.v_NumEntries) := :new.salary;
    EmployeeData.v_EmployeeIDs(EmployeeData.v_NumEntries) := :new.id;
  END RLimitSalary;
  /


SQL> CREATE OR REPLACE TRIGGER SLimitSalary
    AFTER INSERT OR UPDATE OF salary ON employee
  DECLARE
    v_MaxEmployees     CONSTANT NUMBER := 5;
    v_CurrentEmployees NUMBER;
    v_EmployeeID       employee.ID%TYPE;
    v_Salary           employee.salary%TYPE;
  BEGIN
    /* Loop through each student inserted or updated, and verify
       that we are still within the limit. */
    FOR v_LoopIndex IN 1..EmployeeData.v_NumEntries LOOP
      v_EmployeeID := EmployeeData.v_EmployeeIDs(v_LoopIndex);
      v_Salary := EmployeeData.v_EmployeeSalary(v_LoopIndex);


      SELECT COUNT(*)
        INTO v_CurrentEmployees
        FROM employee
        WHERE salary = v_Salary;

      -- If there isn't room, raise an error.
      IF v_CurrentEmployees > v_MaxEmployees THEN
        RAISE_APPLICATION_ERROR(-20000,
          'Too much salary ' || v_Salary ||
          ' because of employee ' || v_EmployeeID);
      END IF;
    END LOOP;

    -- Reset the counter so the next execution will use new data.
    EmployeeData.v_NumEntries := 0;
  END SLimitSalary;

28.1.5.	Raise Exception from trigger

SQL> create or replace trigger emp_biu
    before insert or update on employee
   referencing new as new old as old
    for each row
   begin
       if nvl(:new.salary,0) >= 10000 then
           raise_application_error (-20999,'Salary with
              commissions should be less than 10000');
       end if;
   end;
   /

Trigger created.

SQL>
SQL> update employee set salary = 20000;
update employee set salary = 20000
       *
ERROR at line 1:
ORA-20999: Salary with
commissions should be less than 10000
ORA-06512: at "JAVA2S.EMP_BIU", line 3
ORA-04088: error during execution of trigger 'JAVA2S.EMP_BIU'


28.1.6.	Trigger for auditing

SQL> CREATE TABLE EMP(
      EMPNO NUMBER(4) NOT NULL,
      ENAME VARCHAR2(10),
      JOB VARCHAR2(9),
      MGR NUMBER(4),
      HIREDATE DATE,
      SAL NUMBER(7, 2),
      COMM NUMBER(7, 2),
      DEPTNO NUMBER(2)
  );
SQL> CREATE TABLE DEPT(
      DEPTNO NUMBER(2),
      DNAME VARCHAR2(14),
      LOC VARCHAR2(13)
  );
SQL> CREATE TABLE DEPT$AUDIT (
      DEPTNO       NUMBER,
      DNAME        VARCHAR2(14 byte),
      LOC          VARCHAR2(13 byte),
      CHANGE_TYPE  VARCHAR2(1 byte),
      CHANGED_BY   VARCHAR2(30 byte),
      CHANGED_TIME DATE
  );

SQL> CREATE OR REPLACE TRIGGER auditDEPTAR AFTER
   INSERT OR UPDATE OR DELETE ON DEPT FOR EACH ROW
   declare
   my DEPT$audit%ROWTYPE;
   begin
       if inserting then my.change_type := 'I';
       elsif updating then my.change_type :='U';
       else my.change_type := 'D';
       end if;
 
       my.changed_by := user;
       my.changed_time := sysdate;
 
       case my.change_type
       when 'I' then
          my.DEPTNO := :new.DEPTNO;
          my.DNAME := :new.DNAME;
          my.LOC := :new.LOC;
       else
          my.DEPTNO := :old.DEPTNO;
          my.DNAME := :old.DNAME;
          my.LOC := :old.LOC;
       end case;
 
       insert into DEPT$audit values my;
   end;
   /

28.1.7.	Trigger with a REFERENCING clause

SQL> create table company(
       product_id        number(4)    not null,
       company_id          NUMBER(8)    not null,
       company_short_name  varchar2(30) not null,
       company_long_name   varchar2(60)
    );

Table created.

SQL> create table product_audit(
      product_id number(4) not null,
      num_rows number(8) not null
   );

Table created.

SQL> CREATE OR REPLACE TRIGGER myTrigger
  AFTER INSERT ON company
  REFERENCING NEW AS new_org
  FOR EACH ROW
  BEGIN
    UPDATE product_audit
    SET num_rows =num_rows+1
    WHERE product_id =:new_org.product_id;
    IF (SQL%NOTFOUND) THEN
      INSERT INTO product_audit VALUES (:new_org.product_id,1);
    END IF;
  END;
  /

Trigger created.









