-- 1.Show the average employee salary for every year. 
-- (average salary among those existed in the each year from earliest till 2005)

select 	year(sl.from_date) as years, 
		round(avg(sl.salary)) as avg_emp_sal 
from salaries as sl 
where year(sl.to_date) < 2006 
group by year(sl.from_date)
order by 1; 

-- 2 Show the average employee salary for every department. Note: take currentdepartments and current salaries

select 	de.dept_no, 
		round(avg(sl.salary)) as avg_emp_sal 
from salaries as sl 
inner join dept_emp as de 
on sl.emp_no = de.emp_no 
where sl.to_date >=now() 
and de.to_date >= now() 
group by de.dept_no 
order by 1;

/* 3 Show the average employee salary for every department for every year. 
Note: for the average salary of department X in year Y, we need to take the average of all salaries
 in year Y of employees who were in department X in year Y. */

SELECT  dap.dept_name, 
		avg(sl.salary) over (partition by dp.dept_no) as sum_sal
FROM dept_emp as dp
join salaries as sl
on dp.emp_no = sl.emp_no
join departments as dap
on dp.dept_no = dap.dept_no
group by dap.dept_name
;
-- 4.Show, for each year, the largest department (by the number of employees)in that year, and its average salary.
	select year_, dept_name, sum_sal, max_cnt_emp
    from 
    (
    SELECT  year(em.hire_date) as year_,
		dap.dept_name, 
		avg(sl.salary) over (partition by dp.dept_no) as sum_sal,
		max( count(dp.emp_no) ) over (partition by year(dp.from_date)) as max_cnt_emp,
		count(dp.emp_no) as cnt_emp
		FROM dept_emp as dp
		join salaries as sl
		on dp.emp_no = sl.emp_no
		join departments as dap
		on dp.dept_no = dap.dept_no
        join employees as em
		on dp.emp_no = em.emp_no
		group by year(em.hire_date), dap.dept_name 
        order by 4 desc) as tb2
where tb2.cnt_emp = tb2.max_cnt_emp
group by 1 
;

-- 5 Show the details of the current manager who is the longest time in their role

select em.*,
		datediff(em.to_date, em.from_date) as dif
from dept_emp as em
where em.emp_no in ('10009', '10137'); -- Нашел самого древнего сотрудника 

select em.emp_no, em.birth_date, concat(em.first_name,'  ', em.last_name,'  ', em.gender) as Full_name_and_gender,
 		em.hire_date, sl.from_date,
		sl.salary,
        tt.title,
        dep2.dept_name, dep2.dept_no,
        dep.emp_no,
        concat(em2.first_name,'  ', em2.last_name,'  ', em2.gender) as  Full_name_and_gender_Boss      
from employees as em
join salaries as sl
on em.emp_no = sl.emp_no
join dept_emp as dp
on sl.emp_no = dp.emp_no
join dept_manager as dep
on dp.dept_no = dep.dept_no
join titles as tt
on dp.emp_no = tt.emp_no
join departments as dep2
on dp.dept_no = dep2.dept_no
join employees as em2
on dep.emp_no = em2.emp_no
where em.emp_no in ('10009', '10137')
and tt.to_date >= now() and sl.to_date >= now()
and dep.to_date >= now() and dp.to_date >= now();

-- 6 Show top-10 current employees around the company with highest difference between their salary and current average 
-- salary of their department

select *
from (
	select to2.*,
			dense_rank() over(partition by to2.dept_name order by to2.dif desc) as rank_
		from (
				select to1.dept_name, to1.avg_salary, to1.emp_no, (to1.salary - to1.avg_salary)  as dif 
				from (
				select  sl.emp_no, 
				  dp.dept_name,
				  round(avg(sl.salary) over (partition by dp.dept_name),2 ) as avg_salary,
				  sl.salary
				from dept_emp as de
				join departments as dp 
				on dp.dept_no=de.dept_no
				join salaries as sl 
				on sl.emp_no=de.emp_no
				where sl.to_date>= now() 
				and de.to_date >= now()
				) as to1
                ) as to2
 where to2.dif > 0  ) as to4
where to4.rank_ <= 10  
order by to4.rank_ 
;
/* 7 Из-за кризиса на одно подразделение на своевременную выплату зарплаты выделяется всего 500 тысяч долларов. 
Правление решило, что низкооплачиваемые сотрудники будут первыми получать зарплату.
 Показать список всех сотрудников, которые будут вовремя получать зарплату 
 (обратите внимание, что мы должны платить зарплату за один месяц, но в базе данных мы храним годовые суммы). */

select tb2.*
from
(select de.emp_no,
		de.dept_no,
		dp.dept_name,
        round(sum(sl.salary/12) over (partition by de.dept_no order by sl.salary desc)) as sum_de
from dept_emp as de
join departments as dp 
on dp.dept_no=de.dept_no
join salaries as sl
on sl.emp_no=de.emp_no
where sl.to_date>= now() and de.to_date>= now() 
order by 3   ) as tb2
where tb2.sum_de < 500000
;

/*Разработайте базу данных для управления курсами. База данных содержит следующие сущности:
a.students: student_no, teacher_no, course_no, student_name, email, birth_date.b.teachers: teacher_no, teacher_name, phone_noc.courses:
 course_no, course_name, start_date, end_date.●Секционировать по годам, таблицу studentsпо полю birth_dateс помощью механизма range● 
 В таблице studentsсделать первичный ключ в сочетании двух полей student_noи birth_date*/

create database Courses;
use Courses;

create table students (
student_no int auto_increment ,
techer_no int not null,
course_no int not null,
student_name varchar(30) not null,
email varchar(30),
birth_date date not null,
primary key (student_no, birth_date)
)

partition by range(year(birth_date)) (
partition p0 values less than (2000),
partition p1 values less than (2001),
partition p2 values less than (2002),
partition p3 values less than (2003),
partition p4 values less than (2004),
partition p5 values less than (2005),
partition p6 values less than (2006),
partition p7 values less than (2007),
partition p8 values less than (2008),
partition p9 values less than (2009),
partition p10 values less than (2010),
partition p11 values less than maxvalue
  ) ;
  
  create table teachers (
teacherid int auto_increment primary key,
teacher_no int not null,
teacher_name varchar(25) not null,
phone_no varchar(15) default null);

create table course (
courseid int auto_increment primary key,
course_no int not null,
course_name varchar(25) not null,
start_date date not null,
end_date date not null);
						-- Создать индекс по полю students.email
create index idx_students_email
on students(email);
						-- Создать уникальный индекс по полю teachers.phone_no
create unique index idx_teachers_phone_no
on teachers(phone_no);
						-- На свое усмотрение добавить тестовые данные в наши три таблицы.
insert into students(techer_no, course_no, student_name, email, birth_date)
values 
					(11, 1, 'Vin Diesel', 'diesel@gmail.com', '2001-01-24'),
                    (11, 1, 'Paul Walker', 'walker@gmail.com', '2002-02-22'),
                    (12, 2, 'Michelle Rodriguez', 'rodriguez@gmail.com', '2003-04-25'),
                    (12, 2,  'Jordana Brewster', 'brewster@gmail.com', '2004-05-21'),
                    (13, 3,  'Gal Gadot', 'gadot@gmail.com', '2005-06-17'),
                    (13, 3, 'Sung Kang', 'kang@gmail.com', '2006-07-19'),
                    (14, 4, ' Dwayne Johnson;', 'johnson@gmail.com', '2007-08-18'),
                    (14, 4, 'Don Omar', 'omar@gmail.com', '2008-09-16'),
                    (15, 5, 'John Ortiz', 'ortiz@gmail.com', '2009-10-15'),
                    (15, 5, 'Tego Calderon', 'calderon@gmail.com', '2010-11-14'),
                    (16, 6, 'Laz Alonso', 'alonso@gmail.com', '2009-12-13'),
                    (16, 6, 'Christopher Ludacris', 'ludacris@gmail.com', '2005-05-12');
                  
insert into teachers(teacher_no, teacher_name, phone_no)
values 
					(11, 'Matthew LeBlanc', '380674521489'),
                    (12, 'David Schwimmer', '380731245697'),
                    (13, 'Matthew Perry', '380667535951'),
                    (14, 'Courteney Cox', '380664199101'),
                    (15, 'Jennifer Aniston', '380731245543'),
                    (16, 'Bradley Pitt;', '380738701789');
                    
insert into course(course_no, course_name, start_date, end_date)
values
				  (1, 'CS GO', 			'2021-05-11', '2022-02-01'),
                  (2, 'Warhammer ', 	'2021-06-12', '2022-03-02'),
                  (3, 'Stronghold ', 	'2021-07-13', '2022-04-04'),
                  (4, 'Simcity', 		'2020-08-13', '2022-05-06'),
                  (5, 'Anno', 			'2021-09-14', '2022-06-08'),
                  (6, 'Wows', 			'2021-10-15', '2022-07-10');
                  
					/*Отобразить данные за любой год из таблицы studentsи зафиксировать в виду 
					комментария план выполнения запроса, где будет видно что запрос будет выполняться по конкретной секции.*/
explain
select *
from students as st
where st.birth_date between '2005-01-01' and '2005-12-31'; 
				/* id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
				'1', 'SIMPLE',   'students',    'p6',    'ALL',   NULL,  NULL, NULL, NULL, '4', '25.00', 'Using where'*/

		/*Отобразить данные учителя, по любому одному номеру телефона и зафиксировать план выполнения запроса, где будет видно, что запрос будет выполняться по индексу, а не 
		методом ALL. Далее индекс из поля teachers.phone_no сделать невидимым и зафиксировать план выполнения запроса, где ожидаемый результат 
		метод ALL. В итоге индекс оставить в статусе -видимый.*/
explain
select *
from teachers as te
where te.phone_no= '380738701789'; 
			/*
            # id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
			'1', 'SIMPLE', 'teachers', NULL, 'const', 'idx_teachers_phone_no', 'idx_teachers_phone_no', '63', 'const', '1', '100.00', NULL */

alter table teachers alter index idx_teachers_phone_no invisible;
			/*  # id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
				'1', 'SIMPLE', 'teachers', NULL, 'ALL', NULL, NULL, NULL, NULL, '6', '16.67', 'Using where' */
alter table teachers alter index idx_teachers_phone_no visible;

-- Специально сделаем 3 дубляжа в таблице students (добавим еще 3 одинаковые строки).

insert into students(techer_no, course_no, student_name, email, birth_date)
values 
					(15, 5, 'Tego Calderon', 'calderon@gmail.com', '2010-11-14'),
                    (16, 6, 'Laz Alonso', 'alonso@gmail.com', '2009-12-13'),
                    (16, 6, 'Christopher Ludacris', 'ludacris@gmail.com', '2005-05-12');

-- Написать запрос, который выводит строки с дубляжами.

Select *  
from (
		Select * ,
		row_number() over (partition by student_name order by student_no) as rownumber 
		from students ) as tb2
 where tb2.rownumber > 1;