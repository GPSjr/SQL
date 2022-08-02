/* Сделать PL-SQL блок, который в зависимости от переменной сотрудника, выводил бы его департамент. 
Далее, если его департамент равен 60, тогда вывести название данного департамента, 
в противном случае, вывести сообщение - "данный сотрудник не из департамента 60".*/

declare 

v_dep_id number(3);
v_dep_name varchar2(25);
v_emp_id number := 104; 

begin

select dp.department_name
into v_dep_name
from hr.employees em
join hr.departments dp 
on em.department_id = dp.department_id
where em.employee_id = v_emp_id;

select em.department_id
into v_dep_id
from hr.employees em
join hr.departments dp 
on em.department_id = dp.department_id
where em.employee_id = v_emp_id; 

if v_dep_id = 60 then 
  dbms_output.put_line(v_dep_name);

else dbms_output.put_line('This employee is not from department 60');

end if;

end;
/

/*В PL-SQL блок сделать переменную по сотруднику и сразу же присвоить этой переменной значение 101, 
далее по переменной (сотрудник) вычислить его зарплату и в зависимости от зарплаты, 
выдать сообщение - "LOW_SALARY" или "MIDDLE_SALARY" или "HIGHT_SALARY".*/
declare

v_salary number;
v_emp_id number := 101;

begin

select em.salary
into v_salary
from hr.employees em  
where em.employee_id = v_emp_id;

if v_salary between 0 and 9000
  then dbms_output.put_line('LOW_SALARY');

elsif v_salary between 9001 and 15000
  then dbms_output.put_line('MIDDLE_SALARY');

else dbms_output.put_line('HIGHT_SALARY ');

end if;

end;
/

/*Далее создать PL-SQL блок, который в зависимости от переданной зарплаты 
(создать переменную и присвоить какое-то значение ЗП), выводил бы список из названий департаментов 
(таблица JOBS), которые подходили бы по минимальной и максимальной зарплате из переменной ЗП.*/

declare
v_job_titl varchar2(400);
v_salary number(7) := 17000;

begin

SELECT LISTAGG(J.JOB_TITLE,'.
') WITHIN GROUP(ORDER BY J.JOB_TITLE ) AS LIST_JOB_TITLE
into v_job_titl
FROM HR.JOBS J
WHERE v_salary between J.MIN_SALARY and J.MAX_SALARY ;

dbms_output.put_line (v_job_titl);
end;
/
