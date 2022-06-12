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
  where e.EMAIL = c.EMAIL
  ORDER BY LAST_NAME;
```

> For each customer, display their id, first name, last name, city, and their largest sale, total sales, largest sale as a percentage of total sales, average sales amount, and a count of how many sales they have each transacted.
If they have no sales, show 0 for the aggregated amounts. Sort the result by the customer's id number.
---
```
SELECT cust_id,
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