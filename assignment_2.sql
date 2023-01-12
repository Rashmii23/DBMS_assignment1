-- Create a university database that consists of tables such as the schema diagram above
CREATE database university;

USE university;

-- Please complete SQL data definition and tuples of some tables others
CREATE TABLE department(
    department_name VARCHAR(255) PRIMARY KEY NOT NULL,
    building VARCHAR(255) NOT NULL,
    budget INT NOT NULL
);
DROP TABLE department;

CREATE TABLE course(
    course_id INT PRIMARY KEY NOT NULL,
    course_title VARCHAR(255) NOT NULL,
    department_name VARCHAR(255) NOT NULL,
    credits INT NOT NULL,
    FOREIGN KEY (department_name) REFERENCES department(department_name)
);
 DROP TABLE course;

CREATE TABLE section(
    course_id INT NOT NULL,
    sec_id INT NOT NULL,
    semester VARCHAR(255) NOT NULL,
    year INT NOT NULL,
    building VARCHAR(255) NOT NULL,
    room_number INT NOT NULL,
    time_slot_id VARCHAR(255) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);
 DROP TABLE  section;

CREATE TABLE instructor(
    instructor_id INT PRIMARY KEY NOT NULL,
    instructor_name VARCHAR(255) NOT NULL,
    department_name VARCHAR(255) NOT NULL,
    salary INT NOT NULL,
    FOREIGN KEY (department_name) REFERENCES department(department_name)
);
 DROP TABLE  instructor;

CREATE TABLE teaches(
    instructor_id INT NOT NULL,
    course_id VARCHAR(255) NOT NULL,
    sec_id INT NOT NULL,
    semester VARCHAR(255) NOT NULL,
    year INT NOT NULL,
    FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id)
);
DROP TABLE teaches;

CREATE TABLE student(
    student_id INT PRIMARY KEY NOT NULL,
    student_name VARCHAR(255) NOT NULL,
    department_name VARCHAR(255) NOT NULL,
    total_cred INT NOT NULL,
    FOREIGN KEY (department_name) REFERENCES department(department_name)
);
DROP TABLE student;
-- Fillthe tuple of each table at least 10 tuples

INSERT INTO department (department_name, building, budget)
VALUES ('Computer Science', 'Kathmandu', 70000),
       ('Business Studies', 'Pokhara', 200000),
       ('Engineering', 'Biratnagar', 300000),
       ('Mathematics', 'Lalitpur', 40000),
       ('Physics', 'Kathmandu', 500000),
       ('Chemistry', 'Pokhara', 600000),
       ('Biology', 'Biratnagar', 30000),
       ('Geography', 'Lalitpur', 800000),
       ('History', 'Kathmandu', 900000),
       ('Political Science', 'Pokhara', 100000);



INSERT INTO student (student_id, student_name, department_name, total_cred)
VALUES (1, 'Aarav', 'Computer Science', 120),
(2, 'Advait', 'Business Studies', 110),
(3, 'Aryan', 'Engineering', 130),
(4, 'Esha', 'Computer Science', 115),
(5, 'Hriday', 'Business Studies', 125),
(6, 'Sameep', 'Business Studies', 110),
(7, 'Aashish', 'Engineering', 130),
(8, 'Ved', 'Computer Science', 115),
(9, 'Yug', 'Business Studies', 125),
(10, 'laxmi', 'Business Studies', 125);

INSERT INTO course (course_id, course_title, department_name, credits)
VALUES (1, 'Introduction to Programming', 'Computer Science', 3),
       (2, 'Business Management', 'Business Studies', 4),
       (3, 'Civil Engineering', 'Engineering', 5),
       (4, 'Linear Algebra', 'Mathematics', 3),
       (5, 'Classical Mechanics', 'Physics', 4),
       (6, 'Game Design', 'Computer Science', 3),
       (7, 'Genetics', 'Biology', 4),
       (8, 'Physical Geography', 'Geography', 3),
       (9, 'Modern World History', 'History', 4),
       (10, 'Political Philosophy', 'Political Science', 3);



INSERT INTO section (course_id, sec_id, semester, year, building, room_number, time_slot_id)
VALUES (1, 1, 'Fall', 2022, 'Kathmandu', 101, 'A1'),
       (2, 2, 'Spring', 2022, 'Pokhara', 202, 'B1'),
       (3, 1, 'Fall', 2022, 'Biratnagar', 303, 'C1'),
       (4, 2, 'Spring', 2022, 'Lalitpur', 404, 'D1'),
       (5, 1, 'Fall', 2022, 'Kathmandu', 505, 'E1'),
       (6, 2, 'Fall', 2022, 'Pokhara', 606, 'F1'),
       (7, 1, 'Spring', 2022, 'Biratnagar', 707, 'G1'),
       (8, 2, 'Fall', 2022, 'Lalitpur', 808, 'H1'),
       (9, 1, 'Spring', 2022, 'Kathmandu', 909, 'I1'),
       (10, 2, 'Fall', 2022, 'Pokhara', 1010, 'J1');

INSERT INTO instructor (instructor_id, instructor_name, department_name, salary)
VALUES (1, 'Rashmi','Computer Science', 9000),
    (2, 'Shiwani', 'Business Studies', 15000),
    (3, 'Hardik', 'Engineering', 9900),
    (4, 'Chaitra', 'Mathematics', 9900),
    (5, 'Seema', 'Physics', 8000),
    (6, 'Gayetri', 'Computer Science', 9000),
    (7, 'Resham', 'Biology', 8500),
    (8, 'Binod', 'Geography', 80000),
    (9, 'Bishnu', 'History', 8000),
    (10, 'Sushank', 'Political Science', 9000);

INSERT INTO teaches (instructor_id, course_id, sec_id, semester, year)
VALUES (1, 1, 1, 'Fall', 2022),
(2, 2, 2, 'Spring', 2022),
(3, 3, 1, 'Fall', 2022),
(4, 4, 2, 'Spring', 2022),
(5, 5, 1, 'Fall', 2022),
(6, 6, 2, 'Fall', 2022),
(7, 7, 1, 'Spring', 2022),
(8, 8, 2, 'Fall', 2022),
(9, 9, 1, 'Spring', 2022),
(10, 10, 2, 'Fall', 2022);

SELECT * FROM teaches

--Question 4 i)
SELECT instructor_name
FROM instructor
WHERE department_name = 'History';

--Question 4 ii)
SELECT i.instructor_id, i.department_name
FROM instructor i
JOIN department d ON i.department_name = d.department_name
WHERE d.budget > 95000;

--Question 4 iii)
SELECT i.instructor_name, c.course_title
FROM instructor i
JOIN teaches t ON i.instructor_id = t.instructor_id
JOIN course c ON t.course_id = c.course_id
WHERE i.department_name = 'Computer Science';


--Question 4 iv)
SELECT s.student_name
FROM student s
--JOIN teaches t ON s.student_id = t.student_id
JOIN course c ON t.course_id = c.course_id
WHERE c.course_title = 'Game Design';



--Question 4 v)
SELECT department_name, MAX(salary)
FROM instructor
GROUP BY department_name;


--Question 4 vi)
SELECT TOP 1 department_name, salary
FROM instructor
WHERE salary
	IN (
		SELECT MAX(salary)
		FROM instructor
		GROUP BY department_name
	)
ORDER BY salary

--Question 4 vii)


DROP DATABASE university