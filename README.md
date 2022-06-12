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
	
`SELECT first_name,last_name,salary,job_id,department_name,city,COUNTRY_NAME
  `FROM employees    e,
       `departments  d,
       `locations    l,
       `countries    c
 `WHERE     e.department_id = d.department_id
       `AND d.location_id = l.location_id
       `AND l.COUNTRY_ID = c.COUNTRY_ID
       `AND salary = (select max(salary) from employees);`
	   
> Show any employee who still appears as a consultant. Display the first and last name, job id, salary, and manager id, all from the employees table.
> Sort the result by last name.