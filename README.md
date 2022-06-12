# Sales Analysis with Oracle Database and Oracle SQL
- Database development and Sales analysis.
- Database Used Oracle 18c XE.

## Skills used
- Multi Table JOIN
- Self JOIN
- Aggregate Function
- Analytical SQL
- Common Table Expresion (CTE)
- SQL **Exist**
- **DML** and **DDL** Operation.

> Show details of the highest paid employee. Display their first and last name, salary, job id, department name, city, and country name.
---

```	
SELECT first_name,last_name,salary,job_id,department_name,city,COUNTRY_NAME
  FROM employees    e,
       departments  d,
       locations    l,
       countries    c
 WHERE     e.department_id = d.department_id
       AND d.location_id = l.location_id
       AND l.COUNTRY_ID = c.COUNTRY_ID
       AND salary = (select max(salary) from employees);
```
	   
> Show any employee who still appears as a consultant. Display the first and last name, job id, salary, and manager id, all from the employees table.
Sort the result by last name.
---

```
SELECT e.first_name,
       e.last_name,
       e.job_id,
       e.salary,
       e.MANAGER_ID
FROM employees e , consultants c
WHERE e.EMAIL = c.EMAIL
ORDER BY LAST_NAME;
```

> For each customer, display their id, first name, last name, city, and their largest sale, total sales, largest sale as a percentage of total sales, average sales amount, and a count of how many sales they have each transacted.
If they have no sales, show 0 for the aggregated amounts. Sort the result by the customer''s id number.
---

```
SELECT 	 cust_id,
         cust_fname,
         cust_lname,
         cust_city,
         NVL(MAX (s.SALES_AMT),0),
         NVL(SUM (s.SALES_AMT),0),
         NVL(MAX (s.SALES_AMT)*100/SUM (s.SALES_AMT),0),
         NVL(AVG (s.SALES_AMT),0),
         COUNT (s.SALES_ID)
FROM customers c LEFT JOIN sales s
		ON c.CUST_ID = s.SALES_CUST_ID
GROUP BY cust_id,
         cust_fname,
         cust_lname,
         cust_city
ORDER BY cust_id;
```

> Show the managers who manage entire departments. Display the first and last names, department names, addresses, cities, and states.
Sort the output by department id.
---

```
SELECT   e.FIRST_NAME,
         e.LAST_NAME,
         d.DEPARTMENT_NAME,
         l.STREET_ADDRESS,
         l.CITY,
         l.STATE_PROVINCE
FROM departments d, employees e, locations l
WHERE d.MANAGER_ID = e.EMPLOYEE_ID
      AND d.location_id = l.location_id
ORDER BY d.DEPARTMENT_ID;
```

> Show any employee who earns the same or more salary as her/his manager. Show the first name, last name, job id, and salary of the employee, and the first name, last name, job id, and salary of the manager. 
Use meaningful column aliases throughout.
---

```
SELECT e.FIRST_NAME EMP_FIRST_NAME,
       e.LAST_NAME EMP_LAST_NAME,
       e.JOB_ID EMP_JOB_ID,
       e.SALARY EMP_SALARY,
       m.FIRST_NAME MGR_FIRST_NAME,
       m.LAST_NAME MGR_LAST_NAME,
       m.JOB_ID MGR_JOB_ID,
       m.SALARY MSG_SALARY
FROM employees e, employees m
WHERE m.EMPLOYEE_ID = e.MANAGER_ID
	  AND e.SALARY >= m.SALARY;
```

> Find any employee who is now at the same job they had in the past. That is, they performed a job, moved on to another job, and are now back at their original job. Show employee id, first name, last name, job id, and salary.
---

```
SELECT e.employee_id,
       e.first_name,
       e.last_name,
       e.job_id
  FROM employees e, job_history j
 WHERE e.employee_id = j.EMPLOYEE_ID
       AND e.job_id = j.job_id;
```

> Show any employee who is not a manager, but earns more than any manager in the employees table. Show first name, last name, job id, and salary. 
Sort the result by salary.
---

```
SELECT first_name,
         last_name,
         job_id,
         salary
    FROM employees e
   WHERE     e.employee_id NOT IN (SELECT ee.manager_id FROM employees ee WHERE ee.manager_id IS NOT NULL)
         AND EXISTS
                 (SELECT 1
                    FROM employees eee, employees man
                   WHERE eee.employee_id = man.manager_id
                  HAVING MIN (eee.salary) < e.salary)
ORDER BY e.salary;
```

> For every geographic region, provide a count of the employees in that region. Display region name, and the count. Be sure to include all employees, even if they have not been assigned a department. Sort the result by region name.
---

```
SELECT dd.region_name, COUNT (e.employee_id)
    FROM employees e,
         (SELECT d.department_id, r.region_name
            FROM departments d,
                 locations  l,
                 countries  c,
                 regions    r
           WHERE     d.location_id = l.location_id
                 AND l.country_id = c.country_id
                 AND c.region_id = r.region_id) dd
WHERE e.department_id = dd.department_id(+)
GROUP BY dd.region_name
ORDER BY dd.region_name; 
```

> Update Kimberely Grant so that her department matches that of the other sales representatives. In the same update statement, change her first name to Kimberly.
---

```
UPDATE employees
   SET department_id =
           (SELECT DISTINCT department_id
              FROM employees
             WHERE     UPPER (job_id) = UPPER ('sa_rep')
                   AND department_id IS NOT NULL),
       first_name = 'Kimberly'
 WHERE first_name = 'Kimberely';
```

> Employees Stiles and Seo are going to be earning the same pay as employee Ladwig. Write an update statement to change both salaries in one statement.
---

```
UPDATE employees
   SET salary =
           (SELECT salary
              FROM employees
             WHERE last_name = 'Ladwig')
 WHERE last_name IN ('Stiles', 'Seo');
```

> Remove any consultants who are now full-time employees with one delete statement.
---

```
DELETE FROM
    CONSULTANTS cc
      WHERE EXISTS
                (SELECT 1
                   FROM consultants c, employees e
                  WHERE     c.email = e.email
                        AND c.email = cc.email);
```

> The regions are expanding. Americas will now be called North America, and Middle East and Africa will now be called Middle East. 
Write the update statements to change these regions.
---

```
UPDATE regions
       SET region_name = 'North America'
     WHERE UPPER (region_name) = UPPER ('Americas');

    UPDATE regions
       SET region_name = 'Middle East'
     WHERE UPPER (region_name) = UPPER ('Middle East and Africa');
```

> Add a new row for South America to the Regions table. Add another row for Africa. 
---

```
INSERT INTO regions VALUES (5, 'South America');

INSERT INTO regions VALUES (6, 'Africa');
```

> For each sales representative, show their biggest sale. Display the sales representative's id, first and last names, their largest sales amount, the timestamp of the sale, the customer id, and customer last name. 
Sort the result by the sales rep's id number.
---

```
WITH
    SALES_REP_RANK
    AS
        (SELECT sales_cust_id,
                sales_amt,
                s.SALES_REP_ID,
                s.SALES_TIMESTAMP,
                RANK ()
                    OVER (PARTITION BY s.SALES_REP_ID
                          ORDER BY sales_amt DESC)    max_amt
           FROM sales s)
  SELECT a.SALES_REP_ID,
         e.LAST_NAME,
         a.sales_amt,
         a.SALES_TIMESTAMP,
         a.SALES_CUST_ID,
         c.CUST_LNAME
    FROM SALES_REP_RANK a, employees e, customers c
   WHERE     a.SALES_REP_ID = e.EMPLOYEE_ID
         AND a.SALES_CUST_ID = c.CUST_ID
         AND a.max_amt = 1
ORDER BY a.SALES_REP_ID;
```

> Show the commissioned employees whose total pay is above the average total pay of commissioned employees. Total pay is salary added to commission percent multiplied by the total sales for that salesperson.
Show first name, last name, and total pay. Sort the result by the total pay.
---

```
SELECT *
    FROM (SELECT e.employee_id,
                 e.first_name,
                 e.last_name,
                 ROUND (e.salary + (e.commission_pct * s.sales_amt), 2)    total_pay
            FROM employees e, sales s
           WHERE     e.EMPLOYEE_ID = s.SALES_REP_ID
                 AND EXISTS
                         (  SELECT 1
                              FROM employees e1, sales s1
                             WHERE     e1.EMPLOYEE_ID = s1.SALES_REP_ID
                                   AND e.employee_id = s1.sales_rep_id
                                   AND e.commission_pct IS NOT NULL
                            HAVING ROUND (
                                         e.salary
                                       + (e.commission_pct * s.sales_amt),
                                       2) >
                                   AVG (
                                       ROUND (
                                             e1.salary
                                           + (e1.commission_pct * s1.sales_amt),
                                           2))
                          GROUP BY s1.sales_rep_id)
                 AND e.commission_pct IS NOT NULL)
ORDER BY TOTAL_PAY;
```

> Sales managers earn a commission on the total sales of all their sales representatives.
For each sales manager, calculate their total compensation, which is the manager's salary added to the product of the manager's commission percent multiplied by the total sales of the manager's sales representatives.
Show the manager's employee id, the manager's last name, and their total compensation. Sort by the manager's employee id number.
---

```
WITH
    sales_man_com_pay
    AS
        (SELECT e.manager_id
           FROM employees e, sales s
          WHERE     e.EMPLOYEE_ID = s.SALES_REP_ID
                AND e.commission_pct IS NOT NULL)
  SELECT ee.employee_id,
         ee.last_name,
         ROUND (ee.salary * ee.commission_pct * SUM (rep.sales_amt), 2)    total_compensation
    FROM employees ee,
         (SELECT e.manager_id, s.sales_rep_id, s.sales_amt
            FROM employees e, sales s
           WHERE e.employee_id = s.sales_rep_id AND e.manager_id IS NOT NULL)
         rep
   WHERE ee.employee_id = rep.manager_id
GROUP BY ee.employee_id,
         ee.last_name,
         ee.commission_pct,
         ee.salary
ORDER BY ee.employee_id;
```

> For every customer’s biggest sales amount, show the sales representative’s last name, his or her manager’s last name, the customer’s first and last names, customer’s city and country, and the amount of their largest sale. 
Sort by the salesperson’s last name.
---

```
SELECT e.LAST_NAME     sales_ref_last_name,
       m.LAST_NAME     MGR_LAST_NAME,
       c.CUST_FNAME,
       c.CUST_LNAME,
       c.CUST_CITY,
       ctr.COUNTRY_NAME,
       sales_amt
  FROM (SELECT sales_cust_id,
               sales_amt,
               s.SALES_REP_ID,
               RANK () OVER (PARTITION BY sales_cust_id ORDER BY sales_amt desc)    max_amt
          FROM sales s) a,
       employees  e,
       customers  c,
       employees  m,
       countries  ctr
 WHERE     e.EMPLOYEE_ID = a.SALES_REP_ID
       AND a.SALES_CUST_ID = c.CUST_ID
       AND e.MANAGER_ID = m.EMPLOYEE_ID
       AND c.CUST_COUNTRY = ctr.COUNTRY_ID
       AND a.max_amt = 1
order by e.LAST_NAME;
```