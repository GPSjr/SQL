-- 1.	Вывести количество сотрудников в разрезе менеджеров. Нужно сделать сортировку по кол-ву от большего к малому.
SELECT  EM.MANAGER_ID,
        COUNT(EM.EMPLOYEE_ID)
FROM HR.EMPLOYEES EM
WHERE 1=1
GROUP BY EM.MANAGER_ID
ORDER BY 2 DESC;

/* 2.	Сделать аналогичный отчет как из второго задание, только добавить некоторые фильтры. 
Убрать сотрудников, у которых нет номера менеджера, а также вывести только те номера менеджеров
, у которых количество сотрудников больше 5. Нужно сделать сортировку по кол-ву по возрастанию. */
SELECT  EM.MANAGER_ID,
        COUNT(EM.EMPLOYEE_ID) AS COUNT_EMP
FROM HR.EMPLOYEES EM
WHERE 1=1
AND EM.MANAGER_ID IS NOT NULL
HAVING COUNT(EM.EMPLOYEE_ID) > 5
GROUP BY EM.MANAGER_ID
ORDER BY 2 ASC;

/* 3.	Вывести из таблицы сотрудников, ид сотрудника, имя, дату приема на работу и сделать «искусственный» столбец на основе поля 
ид сотрудника – если ид сотрудника от 100 до 130 тогда это будет «Level_1», если от 131 до 180, то это «Level_2», 
а все остальные это «Level_3». Назвать этот «искусственный» столбец - Degree. */
SELECT  EM.EMPLOYEE_ID,
        EM.FIRST_NAME,
        EM.HIRE_DATE,
        CASE 
        WHEN EM.EMPLOYEE_ID BETWEEN 100 AND 130 THEN 'Level_1'
        WHEN EM.EMPLOYEE_ID BETWEEN 131 AND 180 THEN 'Level_2'
        ELSE 'Level_3' 
          END AS "DEGREE"
FROM HR.EMPLOYEES EM;

-- 4.	Из таблицы сотрудников, вывести уникальный список должностей. К значению каждой должности, при конкатенировать ‘JOB - ’ 
SELECT  DISTINCT ('JOB-'|| EM.JOB_ID) 
FROM HR.EMPLOYEES EM;

-- 5.	Получить список всех сотрудников, заменив в значении PHONE_NUMBER все '.' на null;
select  em.first_name, 
        em.last_name, 
        replace (em.phone_number ,'.', null)  as mob_tel
from hr.employees em;

-- 6.	Получить список всех сотрудников, которые пришли на работу в первый день любого месяца. 
select  em.first_name, 
        em.last_name, 
        em.phone_number, 
        to_char(em.hire_date,'dd') as day
from hr.employees em
where to_char(em.hire_date,'dd') = 1;

-- 7.	Получить отчет сколько сотрудников приняли на работу в каждый день недели. Сортировать по количеству; 
SELECT  COUNT(*), 
        TO_CHAR(EM.HIRE_DATE,'day') AS DAY
FROM HR.EMPLOYEES EM
GROUP BY TO_CHAR(EM.HIRE_DATE,'day')
ORDER BY COUNT(*) DESC;