
CREATE TABLE Teacher (
    teacher_id INT PRIMARY KEY IDENTITY(1,1),
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY IDENTITY(1,1),
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone_number NVARCHAR(20)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY IDENTITY(1,1),
    course_name NVARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY IDENTITY(1,1),
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    CONSTRAINT UC_Enrollment UNIQUE (student_id, course_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    student_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

insert into teacher (first_name, last_name, email) values
('john', 'smith', 'john.smith@school.edu'),
('mary', 'johnson', 'mary.johnson@school.edu'),
('robert', 'williams', 'robert.williams@school.edu'),
('sarah', 'davis', 'sarah.davis@school.edu'),
('michael', 'brown', 'michael.brown@school.edu');


insert into students (first_name, last_name, date_of_birth, email, phone_number) values
('emma', 'wilson', '2000-05-15', 'emma.wilson@example.com', '555-123-4567'),
('james', 'taylor', '2001-07-22', 'james.taylor@example.com', '555-234-5678'),
('olivia', 'anderson', '1999-03-10', 'olivia.anderson@example.com', '555-345-6789'),
('noah', 'thomas', '2002-11-05', 'noah.thomas@example.com', '555-456-7890'),
('sophia', 'jackson', '2000-01-30', 'sophia.jackson@example.com', '555-567-8901'),
('lucas', 'white', '2001-09-18', 'lucas.white@example.com', '555-678-9012'),
('ava', 'harris', '1999-12-25', 'ava.harris@example.com', '555-789-0123');

insert into courses (course_name, credits, teacher_id) values
('introduction to sql', 3, 1),
('data structures', 4, 2),
('web development', 3, 3),
('computer networks', 4, 4),
('machine learning', 4, 5),
('database design', 3, 1);


insert into enrollments (student_id, course_id, enrollment_date) values
(1, 1, '2023-08-15'),
(1, 2, '2023-08-16'),
(1, 3, '2023-08-17'),
(1, 4, '2023-08-18'),
(1, 5, '2023-08-19'),
(1, 6, '2023-08-20'),
(2, 1, '2023-08-15'),
(2, 2, '2023-08-16'),
(2, 3, '2023-08-17'),
(3, 1, '2023-08-15'),
(3, 4, '2023-08-16'),
(4, 2, '2023-08-15'),
(4, 5, '2023-08-16'),
(5, 3, '2023-08-15'),
(5, 6, '2023-08-16'),
(6, 1, '2023-08-15'),
(6, 4, '2023-08-16'),
(7, 2, '2023-08-15');


insert into payments (student_id, amount, payment_date) values
(1, 500.00, '2023-08-10'),
(1, 700.00, '2023-08-11'),
(2, 800.00, '2023-08-10'),
(2, 300.00, '2023-08-12'),
(3, 1000.00, '2023-08-10'),
(4, 450.00, '2023-08-10'),
(5, 650.00, '2023-08-10'),
(5, 550.00, '2023-08-11'),
(6, 750.00, '2023-08-10'),
(7, 900.00, '2023-08-10');


--part 4 

-- 1. Write an SQL query to calculate the average number of students enrolled in each course
select avg(num_students) as average_students_per_course
from (
    select course_id, count(student_id) as num_students
    from enrollments
    group by course_id
) as course_stats;

-- 2. Identify the student(s) who made the highest payment
select s.student_id, s.first_name, s.last_name
from students s
inner join payments p on s.student_id = p.student_id
where p.amount = (
    select max(amount)
    from payments
);

-- 3. Retrieve a list of courses with the highest number of enrollments
select c.course_id, c.course_name, enrollment_count
from courses c
inner join (
    select course_id, count(student_id) as enrollment_count
    from enrollments
    group by course_id
) as enrollment_data on c.course_id = enrollment_data.course_id
where enrollment_data.enrollment_count = (
    select max(enrollment_count)
    from (
        select course_id, count(student_id) as enrollment_count
        from enrollments
        group by course_id
    ) as max_data
);

-- 4. Calculate the total payments made to courses taught by each teacher
select t.teacher_id, t.first_name, t.last_name, isnull(total_money, 0) as total_payment_amount
from teacher t
left join (
    select c.teacher_id, sum(p.amount) as total_money
    from courses c
    inner join enrollments e on c.course_id = e.course_id
    inner join payments p on e.student_id = p.student_id
    group by c.teacher_id
) as teacher_earnings on t.teacher_id = teacher_earnings.teacher_id;

-- 5. Identify students who are enrolled in all available courses
select s.student_id, s.first_name, s.last_name
from students s
where (
    select count(distinct course_id)
    from enrollments
    where student_id = s.student_id
) = (
    select count(*)
    from courses
);

-- 6. Retrieve the names of teachers who have not been assigned to any courses
select t.teacher_id, t.first_name, t.last_name
from teacher t
where t.teacher_id not in (
    select distinct teacher_id
    from courses
    where teacher_id is not null
);

-- 7. Calculate the average age of all students
select avg(datediff(year, date_of_birth, getdate())) as avg_student_age
from students;

-- 8. Identify courses with no enrollments
select c.course_id, c.course_name
from courses c
where c.course_id not in (
    select distinct course_id
    from enrollments
);

-- 9. Calculate the total payments made by each student for each course they are enrolled in
select s.student_id, s.first_name, s.last_name, c.course_id, c.course_name, sum(p.amount) as money_paid
from students s
inner join enrollments e on s.student_id = e.student_id
inner join courses c on e.course_id = c.course_id
inner join payments p on s.student_id = p.student_id
group by s.student_id, s.first_name, s.last_name, c.course_id, c.course_name;

-- 10. Identify students who have made more than one payment
select s.student_id, s.first_name, s.last_name, count(p.payment_id) as payment_count
from students s
inner join payments p on s.student_id = p.student_id
group by s.student_id, s.first_name, s.last_name
having count(p.payment_id) > 1;

-- 11. Write an SQL query to calculate the total payments made by each student
select s.student_id, s.first_name, s.last_name, sum(p.amount) as total_fees_paid
from students s
inner join payments p on s.student_id = p.student_id
group by s.student_id, s.first_name, s.last_name;

-- 12. Retrieve a list of course names along with the count of students enrolled in each course
select c.course_id, c.course_name, count(e.student_id) as student_count
from courses c
left join enrollments e on c.course_id = e.course_id
group by c.course_id, c.course_name;

-- 13. Calculate the average payment amount made by students
select avg(p.amount) as avg_payment
from payments p;

-- part 3

-- 1. Calculate the total payments made by a specific student
select s.student_id, s.first_name, s.last_name, sum(p.amount) as total_payment
from students s
inner join payments p on s.student_id = p.student_id
where s.student_id = 1  -- Change this value to query a different student
group by s.student_id, s.first_name, s.last_name;

-- 2. Retrieve courses with count of enrolled students
select c.course_id, c.course_name, count(e.student_id) as enrolled_students
from courses c
left join enrollments e on c.course_id = e.course_id
group by c.course_id, c.course_name
order by enrolled_students desc;

-- 3. Find students who have not enrolled in any course
select s.student_id, s.first_name, s.last_name
from students s
left join enrollments e on s.student_id = e.student_id
where e.enrollment_id is null;

-- 4. Retrieve students and their enrolled courses
select s.student_id, s.first_name, s.last_name, c.course_name
from students s
inner join enrollments e on s.student_id = e.student_id
inner join courses c on e.course_id = c.course_id
order by s.last_name, s.first_name, c.course_name;

-- 5. List teachers and their assigned courses
select t.teacher_id, t.first_name, t.last_name, c.course_name
from teacher t
left join courses c on t.teacher_id = c.teacher_id
order by t.last_name, t.first_name;

-- 6. Retrieve students and enrollment dates for a specific course
select s.student_id, s.first_name, s.last_name, e.enrollment_date
from students s
inner join enrollments e on s.student_id = e.student_id
inner join courses c on e.course_id = c.course_id
where c.course_id = 1  -- Change this value to query a different course
order by e.enrollment_date;

-- 7. Find students who have not made any payments
select s.student_id, s.first_name, s.last_name
from students s
left join payments p on s.student_id = p.student_id
where p.payment_id is null;

-- 8. Identify courses with no enrollments
select c.course_id, c.course_name
from courses c
left join enrollments e on c.course_id = e.course_id
where e.enrollment_id is null;

-- 9. Identify students enrolled in more than one course
select s.student_id, s.first_name, s.last_name, count(e.course_id) as course_count
from students s
inner join enrollments e on s.student_id = e.student_id
group by s.student_id, s.first_name, s.last_name
having count(e.course_id) > 1
order by course_count desc;

-- 10. Find teachers not assigned to any courses
select t.teacher_id, t.first_name, t.last_name
from teacher t
left join courses c on t.teacher_id = c.teacher_id
where c.course_id is null;


