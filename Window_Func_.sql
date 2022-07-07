-- 1.  Отобразить сотрудников и напротив каждого, показать информацию о разнице текущей и первой зарплате. 

select emp_no, salary - f_salary as dif_salary -- показали разницу ЗП
from (
		select sl.emp_no, sl.salary, sl.from_date, sl.to_date,
		first_value(sl.salary) over(order by sl.salary) as f_salary 
		from salaries as sl
		where sl.to_date >= now()) as to1;

-- 2.  Отобразить департаменты и сотрудников, которые получают наивысшую зарплату в своем департаменте.
select *
from (
		select  sl.emp_no, 
		  dp.dept_name,
		  max(sl.salary) over (partition by dept_name) as max_salary
		from dept_emp as de
		join departments as dp 
		on dp.dept_no=de.dept_no
		join salaries as sl 
		on sl.emp_no=de.emp_no
		where sl.to_date>= now() 
		and de.to_date >= now()
		) as to1
order by to1.max_salary desc
;
-- 3.  Из таблицы должностей, отобразить сотрудника с его текущей должностью и предыдущей.
select to3.emp_no, to3.title, to3.prev_title
from 	
	(select  tt.emp_no, 
				tt.title, 
				tt.from_date, 
				tt.to_date,	
				lag(tt.title) over (partition by tt.emp_no order by tt.title) as prev_title  
		from titles as tt ) as to3
where to3.to_date >=now()
and to3.prev_title is not null
order by to3.prev_title
;
-- 4.  Из таблицы должностей, посчитать интервал в днях - сколько прошло времени от первой должности до текущей.
select t12.dif_date
from (
			SELECT  tt.emp_no,
					tt.title, tt.from_date, tt.to_date,
					datediff(tt.to_date, tt.from_date) as dif_date,
					lag(tt.title) over (partition by tt.emp_no order by tt.title) as prev_title			
			FROM titles as tt
			where tt.to_date < now() ) as t12
where prev_title is not null
;
/*5.  Выбрать сотрудников и отобразить их рейтинг по году принятия на работу. 
Выбрать последнюю строку и записать в переменную со значением из поля emp_no. 
Далее, выбрать по значению из переменной информацию из таблицы должностей, зарплат и департаментов.
 “Джоинить” по значению из переменной. */
select *
from (
		select emp_no, birth_date, first_name, last_name, gender, hire_date, rank_by_year,
			   LAST_VALUE(tb2.emp_no) OVER ( order by tb2.rank_by_year RANGE BETWEEN
			   UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) as last_row
		from (
					select em.emp_no, em.birth_date, em.first_name, em.last_name, em.gender, em.hire_date,
					dense_rank() over(order by year(em.hire_date) ) as rank_by_year     
					FROM employees as em ) tb2
) as tb4
where tb4.emp_no = tb4.last_row;
set @power := 222965;
with t as (select *
from employees as em 
where em.emp_no=@power) 
select t1.emp_no, t1.first_name, t1.last_name, t1.gender,
        em1.birth_date, em1.hire_date , sl.salary, 
        tt.title, de.dept_no, dp.dept_name
from t as t1
join employees as em1 on em1.emp_no=t1.emp_no
join salaries as sl on sl.emp_no=t1.emp_no
join dept_emp as de on de.emp_no=t1.emp_no
join titles as tt on tt.emp_no=t1.emp_no
join departments as dp on dp.dept_no=de.dept_no
where sl.to_date >= now() and de.to_date >= now()
and tt.to_date >= now()
;
 