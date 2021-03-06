A correlated subquery references one or more columns in the outer query.

The subquery is known as a correlated subquery because the subquery is related to the outer query.

A correlated subquery is used for a query depending on a value in each row contained in the outer query.

SQL> SELECT id, first_name, salary
   FROM employee outer
   WHERE salary >
     (SELECT AVG(salary)
      FROM employee inner
      WHERE inner.id = outer. id);

2.37.2.	Using EXISTS and NOT EXISTS with a Correlated Subquery
SQL> SELECT empno, ename
  FROM employee outer
  WHERE EXISTS
    (SELECT empno
     FROM employee inner
     WHERE inner.manager_id = outer.empno);
2.37.3.	A correlated subquery: the subquery references a column from a table referred to in the parent statement.
SQL> SELECT deptno, ename, sal
     FROM   emp e1
     WHERE  sal = (SELECT MAX(sal) FROM emp
                      WHERE  deptno = e1.deptno)
                      
2.37.4.	The subquery returning the literal value 1

SQL> SELECT empno, ename
    FROM employee outer
    WHERE EXISTS
      (SELECT 1
       FROM employee inner
       WHERE inner.manager_id = outer.empno);

	2.37.5.	Using NOT EXISTS with a Correlated Subquery

SQL> SELECT empno, ename
   FROM employee outer
   WHERE NOT EXISTS
     (SELECT 1
      FROM employee inner
      WHERE inner.empno = outer.manager_id);

2.37.6.	list all employees who is younger than Joe
SQL> select ename, init, bdate
  from   employees
  where  bdate > (select bdate
                  from   employees
                  where  ename = 'JONES');


2.37.7.	List all employees who attended XML course and Java course

SQL> select attendee
   from   registrations
   where  course   = 'JAV'
   and    attendee in (select attendee
                       from   registrations
                       where  course = 'XML');

2.37.8.	Extract a Subset of the Results
SQL> SELECT username,score FROM
    (SELECT username,score FROM myTable ORDER BY score DESC) t
      WHERE rownum <= 10;














