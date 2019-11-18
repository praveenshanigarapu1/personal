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
