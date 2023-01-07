CREATE DATABASE db_office;
USE db_office;
CREATE TABLE tbl_employee(
    emp_name VARCHAR(50) PRIMARY KEY NOT NULL,
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL);

DROP TABLE tbl_employee;

CREATE TABLE tbl_company(
    company_name VARCHAR(250) PRIMARY KEY NOT NULL , 
    city VARCHAR(50) NOT NULL);

DROP TABLE tbl_company;

CREATE TABLE tbl_works(
    company_name VARCHAR(250) NOT NULL,
    FOREIGN KEY (company_name) 
            REFERENCES tbl_company(company_name), 
    emp_name VARCHAR(50) NOT NULL PRIMARY KEY,
    FOREIGN KEY(emp_name) 
            REFERENCES tbl_employee(emp_name), 
    salary FLOAT NOT NULL);

DROP TABLE tbl_works;

CREATE TABLE tbl_manages(
    emp_name VARCHAR(50) NOT NULL PRIMARY KEY,
    FOREIGN KEY(emp_name) 
            REFERENCES tbl_employee(emp_name), 
    manager_name VARCHAR(50) NOT NULL);
DROP TABLE tbl_manages;

INSERT INTO tbl_employee(emp_name, street, city )
VALUES( 'Rashmi Khadka', 'Dolakha', 'Tamakoshi'),
       ('Pratima Dawadi', 'Lamjung', 'Raniban'),
       ('Pratigya Paudel ', 'Pokhara', 'Pokhara'),
       ('Jones','Kavre','Palase'),
       ('Shiwani Shah','Janakpur','Biratnagar'),
       ('Prinsa Joshi', 'Bhaktapur', 'Suryabinayak'),
       ('Nistha Bajracharya','Kathmandu','Kalanki'),
       ('Nishant Uprety','Kathmandu','Thapathali' ),
       ('Sandhya Khadka','Bhaktapur','Bhaktapur'),
       ('Sushank Ghimire ', 'Kathmandu', 'Kapan');

SELECT *FROM tbl_employee;

INSERT INTO tbl_company(company_name, city)
VALUES('Leapfrog tec', 'Thapathali'),
    ('Global IME', 'Baneswor'), 
    ('First Bank Corporation', 'Bhaktapur'),
    ('Small Bank Corporation','Lalitpur');

SELECT *FROM tbl_company;



INSERT INTO tbl_works(emp_name, company_name, salary)
VALUES('Rashmi Khadka', 'Leapfrog tec', 60000),
    ('Pratigya Paudel', 'First Bank Corporation', 18000),
    ('Pratima Dawadi', 'Global IME', 35000),
    ('Sushank Ghimire', 'Leapfrog tec', 95000),
    ('Prinsa Joshi','Small Bank Corporation',38000),
    ('Shiwani Shah','First Bank Corporation',9000),
    ('Nistha Bajracharya','Small Bank Corporation',52000),
    ('Nishant Uprety','Leapfrog tec',60000),
    ('Sandhya Khadka','First Bank Corporation',18000),
    ('Jones', 'Global IME',110000);

SELECT *FROM tbl_works;

INSERT INTO tbl_manages(emp_name, manager_name )
VALUES('Rashmi Khadka', 'Sushank Ghimire'),
('Nishant Uprety', 'Sushank Ghimire'),
('Sandhya Khadka','Pratigya Paudel'),
('Shiwani Shah','Pratigya Paudel'),
('Pratima Dawadi','Jones'),
('Prinsa Joshi', 'Nistha Bajracharya');

SELECT *FROM tbl_manages;

--2. Consider the employee database of Figure 5, where the primary keys are underlined. Give an expression in SQL for each of the following queries:

--2.a) Find the names of all employees who work for First Bank Corporation.
SELECT emp_name FROM tbl_works 
    WHERE company_name = 'First Bank Corporation';

-- 2.b) Find the names and cities of residence of all employees who work for First Bank Corporation.
--Using sub query
SELECT tbl_employee.emp_name, tbl_employee.city FROM tbl_employee
WHERE tbl_employee.emp_name = ANY (SELECT DISTINCT
            tbl_works.emp_name FROM tbl_works 
            WHERE tbl_works.company_name = 'First Bank Corporation');

--using joint 
SELECT tbl_employee.emp_name, tbl_employee.city
FROM tbl_employee
        INNER JOIN
    tbl_works ON tbl_employee.emp_name = tbl_works.emp_name
WHERE
    tbl_works.company_name = 'First Bank Corporation';

--2.c) Find the names, street addresses, and cities of residence of all employees who work for First Bank Corporation and earn more than $10,000.
--using sub query

SELECT tbl_employee.emp_name, tbl_employee.street, tbl_employee.city
FROM tbl_employee
WHERE
    tbl_employee.emp_name = ANY (SELECT 
            tbl_works.emp_name
        FROM tbl_works
        WHERE tbl_works.company_name = 'First Bank Corporation'
                AND tbl_works.salary > 10000);

--using joint 
SELECT 
    tbl_employee.emp_name,
    tbl_employee.street,
    tbl_employee.city
FROM
    tbl_employee
        INNER JOIN
    tbl_works ON tbl_employee.emp_name = tbl_works.emp_name
WHERE
    tbl_works.company_name = 'First Bank Corporation'
        AND tbl_works.salary > 10000;
    
--2.d) Find all employees in the database who live in the same cities as the companies for which they work.
--using sub query
SELECT tbl_employee.emp_name, tbl_employee.city
FROM tbl_employee
WHERE tbl_employee.city = (SELECT 
            tbl_company.city
        FROM tbl_company
        WHERE tbl_company.company_name = (SELECT tbl_works.company_name
            FROM tbl_works
            WHERE tbl_works.emp_name = tbl_employee.emp_name));

--Using Join:
SELECT  tbl_employee.emp_name, Tbl_employee.city
FROM tbl_employee
    INNER JOIN
    tbl_works ON tbl_employee.emp_name = tbl_works.emp_name
    INNER JOIN
    tbl_company ON tbl_works.company_name = tbl_company.company_name
    WHERE tbl_company.city = tbl_employee.city;

--2.e) Find all employees in the database who live in the same cities and on the same streets as do their managers.
--Using sub query:
SELECT 
    tbl_manages.emp_name AS employee,
    tbl_manages.manager_name AS manager
FROM tbl_manages
WHERE (SELECT tbl_employee.city
        FROM tbl_employee
        WHERE
            tbl_employee.emp_name = tbl_manages.manager_name) = (SELECT 
            tbl_employee.city
        FROM tbl_employee
        WHERE tbl_employee.emp_name = tbl_manages.emp_name)
        AND (SELECT tbl_employee.street
        FROM tbl_employee
        WHERE tbl_employee.emp_name = Tbl_manages.manager_name) = (SELECT 
            tbl_employee.street
        FROM tbl_employee
        WHERE tbl_employee.emp_name = tbl_manages.emp_name); 
    
--using joint
SELECT 
    tbl_manages.emp_name AS employee,
    tbl_manages.manager_name AS manager
FROM tbl_manages
    INNER JOIN
    tbl_employee AS emp ON tbl_manages.emp_name = emp.emp_name
    INNER JOIN
    tbl_employee AS manager ON Tbl_manages.manager_name = manager.emp_name
WHERE
    emp.city = manager.city
        AND emp.street = manager.street;

--2.f) Find all employees in the database who do not work for First Bank Corporation.
--Query
SELECT tbl_works.emp_name
FROM tbl_works
WHERE tbl_works.company_name != 'First Bank Corporation';

--joint
SELECT tbl_works.emp_name
FROM tbl_works
WHERE tbl_works.company_name != 'First Bank Corporation';

--2.h) Assume that the companies may be located in several cities. Find all companies located in city in which Small Bank Corporation is located.
--query
SELECT *FROM tbl_company
WHERE tbl_company.city = (SELECT 
    tbl_company.city
    FROM tbl_company
    WHERE tbl_company.company_name = 'Small Bank Corporation');

--2.i) Find all employees who earn more than the average salary of all employees of their company.
--Query:

SELECT  tbl_works.emp_name, tbl_works.company_name
FROM (SELECT 
        company_name, AVG(salary) AS average_salary
    FROM tbl_works
    GROUP BY company_name) AS avg_salary
        JOIN tbl_works ON avg_salary.company_name = tbl_works.company_name
        WHERE tbl_works.salary > avg_salary.average_salary;

--2.j) Find the company that has the most employees.
--Query:


SELECT TOP 1 company_name, employee_count
FROM (SELECT 
        company_name, COUNT(emp_name) AS employee_count
    FROM tbl_works
    GROUP BY company_name) as C1
    ORDER BY employee_count DESC;


--2.k) Find the company that has the smallest payroll.
--Query:
SELECT TOP 1 company_name, payroll
FROM (SELECT 
    company_name, SUM(salary) AS payroll
    FROM tbl_works
    GROUP BY company_name) AS total_payroll
ORDER BY payroll ASC;


--2.l) Find those companies whose employees earn a higher salary, on average, than the average salary at First Bank Corporation.
--Query:
SELECT company_name,average_salary
FROM (SELECT 
    company_name, AVG(salary) AS average_salary
    FROM tbl_works
    GROUP BY company_name) AS avg_salary
WHERE avg_salary.average_salary > (SELECT avgs
        FROM (SELECT 
            company_name, AVG(salary) AS avgs
            FROM tbl_works
            GROUP BY company_name) AS avgs_salary
        WHERE avgs_salary.company_name = 'First Bank Corporation');

--3. Consider the relational database of given data. Give an expression in SQL for each of the following queries:
--3.a) Modify the database so that Jones now lives in Newtown.
--Query
UPDATE tbl_employee 
SET city = 'Newtown', street = 'New Street' 
WHERE emp_name = 'Jones'; 
--Check if the query worked or not by selecting data from employee table: 
SELECT * FROM tbl_employee WHERE emp_name = 'Jones'; 

--3.b) Give all employees of First Bank Corporation a 10 percent raise
--Query:
UPDATE tbl_works 
SET  salary = salary * 1.1
WHERE company_name = 'First Bank Corporation';
--Check if the query worked or not by selecting data from works table

SELECT *FROM tbl_works
WHERE company_name = 'First Bank Corporation';

--3.c) Give all managers of First Bank Corporation a 10 percent raise.
--Using sub query:

UPDATE tbl_works 
SET salary = salary * 1.1
WHERE emp_name = ANY (SELECT DISTINCT
    manager_name
   FROM tbl_manages)
        AND company_name = 'First Bank Corporation';

--Using Join:

UPDATE tbl_works
    INNER JOIN
    tbl_manages ON tbl_manages.manager_name = tbl_works.emp_name 
SET  salary = salary * 1.1
WHERE tbl_works.company_name = 'First Bank Corporation';

--Check if the query worked or not by selecting data from works table:"
SELECT  *FROM tbl_works
WHERE company_name = 'First Bank Corporation';

--3.d) Give all managers of First Bank Corporation a 10 percent raise unless the salary becomes greater than $100,000; in such cases, give only a 3 percent raise
--Using sub query:
UPDATE work
SET work.salary = 
  CASE 
    WHEN work.salary * 1.1 <= 100000 THEN work.salary * 1.1
    ELSE work.salary * 1.03
  END
FROM tbl_works work
INNER JOIN tbl_manages m ON work.emp_name = m.emp_name
WHERE work.company_name = 'First Bank Corporation';
--check if the query worked or not by selecting data from works table this query only checks data for the employee of first bank corporation who are managers*
SELECT *FROM tbl_works
WHERE company_name = 'First Bank Corporation'
        AND emp_name = ANY (SELECT DISTINCT manager_name
        FROM tbl_manages);

--3.e) Delete all tuples in the works relation for employees of Small Bank Corporation.
--Query:

DELETE FROM tbl_works
WHERE company_name = 'Small Bank Corporation';

SELECT * FROM tbl_works
 WHERE company_name = 'Small Bank Corporation';









