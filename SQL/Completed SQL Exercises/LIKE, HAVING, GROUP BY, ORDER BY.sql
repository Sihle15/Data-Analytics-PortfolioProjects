USE hr;
/*SELECT  DEP_ID ,COUNT(*) FROM employees
GROUP BY DEP_ID;

SELECT DEP_ID,COUNT(*) AS 'NUM_EMPLOYEES', AVG(SALARY) "AVG_SALARY"
FROM employees
GROUP BY DEP_ID
HAVING COUNT(*) < 4
ORDER BY AVG_SALARY;*/
/*1.Retrieve the list of all employees, first and last names, whose first names start with ‘S’.
SELECT F_NAME, L_NAME from employees
WHERE F_NAME LIKE "S%";

2.Arrange all the records of the EMPLOYEES table in ascending order of the date of birth
SELECT * FROM employees
ORDER BY B_DATE;*/
#3.Group the records in terms of the department IDs and filter them of ones that have average 
#salary more than or equal to 60000. Display the department ID and the average salary.
SELECT DEP_ID, AVG(SALARY) AS "AVG_SALARY"
FROM EMPLOYEES
GROUP BY DEP_ID
HAVING AVG_SALARY >= 60000
ORDER BY AVG_SALARY DESC;
