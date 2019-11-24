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


























