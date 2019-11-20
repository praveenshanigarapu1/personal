Object Type « Object Oriented 

Classes define attributes and methods.

Attributes are used to store an object's state, and methods are used to model an object's behaviors.

You create an object type using the CREATE [OR REPLACE] TYPE statement.

SQL>
SQL> CREATE Or Replace TYPE AddressType AS OBJECT (
     street VARCHAR2(15),
     city   VARCHAR2(15),
     state  CHAR(2),
     zip    VARCHAR2(5)
   );
   /

SQL> CREATE OR REPLACE TYPE address AS OBJECT
                (line1 VARCHAR2(20),
                 line2 VARCHAR2(20),
                 city VARCHAR2(20),
                 state_code VARCHAR2(2),
                 zip VARCHAR2(13));
    /

Type created.

SQL>
SQL> DECLARE
      off_add address :=address('19 J','R Rd','Vancouver','NJ','00000');
    BEGIN
      DBMS_OUTPUT.PUT_LINE(off_add.line1||' '||off_add.line2);
      DBMS_OUTPUT.PUT_LINE(off_add.city||', '||off_add.state_code||' '||off_add.zip);
    END;
    /
19 J R Rd
Vancouver, NJ 00000
                              
32.1.2 Object instances and initialization
SQL> DECLARE
     off_add address :=address('19 J','Reading Rd','Vancouver','NJ','00000');
   BEGIN
     DBMS_OUTPUT.PUT_LINE(off_add.line1||' '||off_add.line2);
     DBMS_OUTPUT.PUT_LINE(off_add.city||', '||off_add.state_code||' '||off_add.zip);
   END;
   /
19 J Reading Rd
Vancouver, NJ 00000                              
32.1.3 Nested object
SQL> CREATE Or Replace TYPE AddressType AS OBJECT (
      street VARCHAR2(15),
      city   VARCHAR2(15),
      state  CHAR(2),
      zip    VARCHAR2(5)
    );
    /
SQL>
SQL>
SQL> CREATE Or Replace TYPE PersonType AS OBJECT (
      id         NUMBER,
      first_name VARCHAR2(10),
      last_name  VARCHAR2(10),
      dob        DATE,
      phone      VARCHAR2(12),
      address    AddressType
    );
    /                              
32.1.4 Declare a function.
SQL> CREATE Or Replace TYPE ProductType AS OBJECT (
     id          NUMBER,
     name        VARCHAR2(15),
     description VARCHAR2(22),
     price       NUMBER(5, 2),
     days_valid  NUMBER,
 
     MEMBER FUNCTION getByDate RETURN DATE
   );
 32.1.5 The MEMBER FUNCTION clause declares the getByDate()                             
You can declare a procedure using MEMBER PROCEDURE.

A procedure is similar to a function except that a procedure doesn't typically return a value                              
 
CREATE Or Replace TYPE ProductType AS OBJECT (
  id          NUMBER,
  name        VARCHAR2(15),
  description VARCHAR2(22),
  price       NUMBER(5, 2),
  days_valid  NUMBER,

  MEMBER FUNCTION getByDate RETURN DATE
);
/                            
                              
32.1.6 The body defines the code for the method, and a body is created using the CREATE TYPE BODY statement                              
                              
SQL> CREATE Or Replace TYPE EmployeeType AS OBJECT (
      id          NUMBER,
      name        VARCHAR2(15),
      description VARCHAR2(22),
      salary       NUMBER(5, 2),
  
      MEMBER FUNCTION getByDate RETURN DATE
    );
    /

Type created.

SQL> CREATE Or Replace TYPE BODY EmployeeType AS
    MEMBER FUNCTION getByDate RETURN DATE IS
       v_by_date DATE;
     BEGIN
      SELECT SYSDATE
       INTO v_by_date
       FROM dual;
 
      RETURN v_by_date;
     END;
   END;
   /

Type body created.     
                              
32.1.7  Create a synonym and a public synonym for a type
You must have the CREATE PUBLIC SYNONYM privilege to run this statement.
                              
SQL> CREATE or replace PUBLIC SYNONYM pub_EmployeeType FOR EmployeeType;

Synonym created.

SQL> /

Synonym created.                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
