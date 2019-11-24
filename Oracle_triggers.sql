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
    
    
    
    
