
SQL> SHOW SERVEROUTPUT
serveroutput OFF
SQL> SET SERVEROUTPUT ON
SQL> SHOW SERVEROUTPUT
serveroutput ON SIZE UNLIMITED FORMAT WORD_WRAPPED

SQL> BEGIN
   NULL;
   END;
   /

PL/SQL procedure successfully completed.

2.
SQL> BEGIN
   DBMS_OUTPUT.PUT_LINE('Welcome');
   END;
   /
Welcome


3.
SQL> BEGIN
   DBMS_OUTPUT.PUT_LINE('Welcome');
   DBMS_OUTPUT.PUT_LINE(1234);
   DBMS_OUTPUT.PUT_LINE(SYSDATE);
   DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);
   DBMS_OUTPUT.PUT_LINE(SYSDATE);
   DBMS_OUTPUT.PUT_LINE(USER);
   DBMS_OUTPUT.PUT_LINE(1+2+3);
   END;
   /
Welcome
1234
17-DEC-19
17-DEC-19 09.43.03.714000000 AM +08:00
17-DEC-19
PRVN
6

PL/SQL procedure successfully completed.

4.
SQL> BEGIN
   DBMS_OUTPUT.PUT('AAA');
   DBMS_OUTPUT.PUT('BBB');
   DBMS_OUTPUT.PUT('CCC');
   DBMS_OUTPUT.PUT('DDD');
   END;
   /

PL/SQL procedure successfully completed.

5.

SQL> BEGIN
  2  DBMS_OUTPUT.PUT('AAA');
  3  DBMS_OUTPUT.PUT('BBB');
  4  DBMS_OUTPUT.PUT('CCC');
  5  DBMS_OUTPUT.PUT_LINE('DDD');
  6  END;
  7  /
AAABBBCCCDDD

PL/SQL procedure successfully completed.

6.
SQL> BEGIN
  DBMS_OUTPUT.PUT('AAA');
  DBMS_OUTPUT.PUT('BBB');
  DBMS_OUTPUT.PUT('CCC');
  DBMS_OUTPUT.PUT('DDD');
  DBMS_OUTPUT.NEW_LINE();
  END;
  /
AAABBBCCCDDD

PL/SQL procedure successfully completed.
















