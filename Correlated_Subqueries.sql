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


































