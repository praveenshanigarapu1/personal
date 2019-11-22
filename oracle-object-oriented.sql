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
                              
32.1.8 Using DESCRIBE to Get Information on Object Types                              
                              
SQL> desc EmployeeType;
 Name            Null?    Type
 
 ID                       NUMBER
 NAME                     VARCHAR2(15)
 DESCRIPTION              VARCHAR2(22)
 SALARY                   NUMBER(5,2)

METHOD
------
 MEMBER FUNCTION GETBYDATE RETURNS DATE                              
                              
 32.1.9  Object types with member functions                            
                              
 SQL> create or replace type employeeType is object (
       empNo    NUMBER,
       eName    VARCHAR2(10),
       job      VARCHAR2(9),
       hireDate DATE,
       sal      NUMBER,
       comm     NUMBER,
       member   procedure p_changeName (i_newName_tx VARCHAR2),
       member   function  f_getIncome_nr  return VARCHAR2
   )
   /

SP2-0816: Type created with compilation warnings

SQL>
SQL> create or replace type body employeeType as
      member function f_getIncome_nr return VARCHAR2 is
      begin
          return sal+comm;
      end f_getIncome_nr;

      member procedure p_changeName (i_newName_tx VARCHAR2) is
      begin
          eName:=i_newName_tx;
      end p_changeName;
  end;
  /

SP2-0818: Type Body created with compilation warnings

SQL>
SQL> desc employeeType
 Name                           Null?    Type
 ---------------------------------
 EMPNO                                   NUMBER
 ENAME                                   VARCHAR2(10)
 JOB                                     VARCHAR2(9)
 HIREDATE                                DATE
 SAL                                     NUMBER
 COMM                                    NUMBER

METHOD
------
 MEMBER PROCEDURE P_CHANGENAME
 Argument Name                  Type                    In/Out Default?
 ------------------------------ ----------------------- ------ --------
 I_NEWNAME_TX                   VARCHAR2                IN

METHOD
------
 MEMBER FUNCTION F_GETINCOME_NR RETURNS VARCHAR2

SQL> /

SP2-0818: Type Body created with compilation warnings

SQL>
SQL> drop type employeeType;

Type dropped.                             
32.1.10     Add attribute                          
                              
SQL> create or replace type employeeType is object (
      empNo    NUMBER,
      eName    VARCHAR2(10)
  )
  /

Type created.

SQL>
SQL> desc employeeType;
 Name                  Null?    Type
 --------------------------------
 EMPNO                          NUMBER
 ENAME                          VARCHAR2(10)

SQL>
SQL>
SQL> alter type employeeType
      add attribute birthdate_dt DATE; -- add attribute
    /                              
32.1.11 Drop attribute

                              SQL> create or replace type employeeType is object (
        empNo    NUMBER,
        deptNo   NUMBER
    )
    /

Type created.

SQL> desc employeeType
 Name           Null?    Type
 -----------------------------
 EMPNO                   NUMBER
 DEPTNO                  NUMBER

SQL> /

Type created.

SQL>
SQL> alter type employeeType
      drop attribute empno
    /
32.1.12  Object elements are referenced by using variable.attribute and variable.method notation                              

                              SQL> create or replace type employeeType is object (
       empNo    NUMBER,
       eName    VARCHAR2(10),
       job      VARCHAR2(9),
       hireDate DATE,
       sal      NUMBER,
       comm     NUMBER,
       member   procedure p_changeName (i_newName_tx VARCHAR2),
       member   function  f_getIncome_nr  return VARCHAR2
   )
   /

SP2-0816: Type created with compilation warnings

SQL>
SQL> create or replace type body employeeType as
       member function f_getIncome_nr return VARCHAR2 is
       begin
           return sal+comm;
       end f_getIncome_nr;
 
       member procedure p_changeName (i_newName_tx VARCHAR2) is
       begin
           eName:=i_newName_tx;
       end p_changeName;
   end;
   /

SP2-0818: Type Body created with compilation warnings

SQL>
SQL>
SQL> declare
        v_employeeType employeeType;
    begin
        v_employeeType:=employeeType(100,'TestEmp', 'JobTitle', sysdate,1000, 500);
        v_employeeType.sal:=v_employeeType.sal+500;
  
        DBMS_OUTPUT.put_line('Employee:'||v_employeeType.eName||' has income '||v_employeeType.f_getIncome_nr());
    end;
    /
Employee:TestEmp has income 2000
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
