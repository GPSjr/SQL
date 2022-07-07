/* 1.	Создать таблицу STUDENTS_INICIALY, с полями:
STUDENT_ID, добавить комментарий на русском – ИД студента
DEPARTMENT_ID, добавить комментарий на русском – ИД кафедры
TEACHER_ID, добавить комментарий на русском – ИД преподавателя
START_DATE, добавить комментарий на русском – Дата поступления
FULL_NAME, добавить комментарий на русском – ФИО студента
SCHOLARSHIP, добавить комментарий на русском – Стипендия студента
Нужно учесть тип данных для каждого поля (NUMBER, VACRAHAR2(100), DATE). 
Сохранить SQL запрос (название – 01_01.sql), для создания таблицы и для создания комментария для каждого поля. */
SELECT *
FROM HR.STUDENTS_GP;

CREATE TABLE HR.STUDENTS_GP 
(
STUDENT_ID NUMBER ,
DEPARTMENT_ID NUMBER,
TEACHER_ID NUMBER, 
START_DATE DATE,
FULL_NAME VARCHAR2(65),
SCHOLARSHIP NUMBER(8,2)
);

COMMENT ON COLUMN HR.STUDENTS_GP.STUDENT_ID IS 'ИД студента.';
COMMENT ON COLUMN HR.STUDENTS_GP.DEPARTMENT_ID IS 'ИД кафедры.';
COMMENT ON COLUMN HR.STUDENTS_GP.TEACHER_ID IS 'ИД преподавателя.';
COMMENT ON COLUMN HR.STUDENTS_GP.START_DATE IS 'Дата поступления';
COMMENT ON COLUMN HR.STUDENTS_GP.FULL_NAME IS 'ФИО студента';
COMMENT ON COLUMN HR.STUDENTS_GP.SCHOLARSHIP IS 'Стипендия студента.';

/*2.	Создать таблицу DEPARTMENTS_INICIALY, с полями:
DEPARTMENT_ID, добавить комментарий на русском – ИД кафедры
DEPARTMENT_NAME, добавить комментарий на русском – Название кафедры 
BLOCK_ID, добавить комментарий на русском – ИД корпуса */
SELECT *
FROM HR.DEPARTMENTS_GP;

CREATE TABLE HR.DEPARTMENTS_GP 
(
DEPARTMENT_ID NUMBER,
DEPARTMENT_NAME VARCHAR2(30), 
BLOCK_ID NUMBER
);

COMMENT ON COLUMN HR.DEPARTMENTS_GP.DEPARTMENT_ID IS 'ИД кафедры.';
COMMENT ON COLUMN HR.DEPARTMENTS_GP.DEPARTMENT_NAME IS 'Название кафедры.';
COMMENT ON COLUMN HR.DEPARTMENTS_GP.BLOCK_ID IS 'ИД корпуса';

-- 3.	Заполнить таблицу STUDENTS_INICIALY, 10-ми строчками
COMMIT;
INSERT INTO HR.STUDENTS_GP (STUDENT_ID, DEPARTMENT_ID, TEACHER_ID, START_DATE, FULL_NAME, SCHOLARSHIP)
SELECT 1, 50, 100, TO_DATE('01-08-2019','DD-MM-YYYY'), 'Беляев Матвей Артёмович', 700 FROM DUAL
UNION
SELECT 2, 50, 100, TO_DATE('22-08-2019','DD-MM-YYYY'), 'Блажевич Игорь Юрьевич', 690 FROM DUAL
UNION
SELECT 3, 50, 100, TO_DATE('01-08-2019','DD-MM-YYYY'), 'Валиева Руфина Рафаэлевна', 690 FROM DUAL
UNION
SELECT 4, 60, 200, TO_DATE('22-08-2019','DD-MM-YYYY'), 'Возвышаев Александр Андреевич', 730 FROM DUAL
UNION
SELECT 5, 60, 200, TO_DATE('01-08-2019','DD-MM-YYYY'), 'Гриненко Алексей Алексеевич', 740 FROM DUAL
UNION
SELECT 6, 70, 300, TO_DATE('22-08-2019','DD-MM-YYYY'), 'Жигляев Родион Алексеевич', 790 FROM DUAL
UNION
SELECT 7, 60, 200, TO_DATE('01-08-2019','DD-MM-YYYY'), 'Журавлева Анастасия Сергеевна', 730 FROM DUAL
UNION
SELECT 8, 60, 200, TO_DATE('29-08-2019','DD-MM-YYYY'), 'Зиборов Кирилл Викторович', 720 FROM DUAL
UNION
SELECT 9, 70, 300, TO_DATE('29-07-2019','DD-MM-YYYY'), 'Колосов Дмитрий Григорьевич', 800 FROM DUAL
UNION
SELECT 10, 70, 300, TO_DATE('28-07-2019','DD-MM-YYYY'), 'Красных Алексей Владимирович', 790 FROM DUAL;

--4.	Наполнить таблицу DEPARTMENTS_INICIALY, 5-мя строчками
COMMIT;
INSERT INTO HR.DEPARTMENTS_GP (DEPARTMENT_ID, DEPARTMENT_NAME, BLOCK_ID)
SELECT 50, 'Менеджмент', 1 FROM DUAL
UNION
SELECT 60, 'Социология', 1 FROM DUAL
UNION
SELECT 70, 'История', 2 FROM DUAL
UNION
SELECT 80, 'Математика', 2 FROM DUAL
UNION
SELECT 90, 'Филология', 3 FROM DUAL;

--5.	Вывести список студентов, у которых максимальная стипендия, в рамках своей ид кафедры
SELECT  TB1.FULL_NAME, 
        TB1.SCHOLARSHIP,
        tb1.DEPARTMENT_ID
FROM HR.STUDENTS_GP TB1
WHERE TB1.SCHOLARSHIP IN (
                SELECT  MAX(ST.SCHOLARSHIP) AS SCHOLARSHIP_
                FROM HR.STUDENTS_GP ST
                GROUP BY ST.DEPARTMENT_ID 
                );
                
--6.	Вывести все поля из таблицы студентов, но вместо столбца DEPARTMENT_ID, нужно вывести поле DEPARTMENT_NAME из таблицы департаментов. 
SELECT  ST.STUDENT_ID, 
        DP.DEPARTMENT_NAME, 
        ST.TEACHER_ID, 
        ST.START_DATE, 
        ST.FULL_NAME, 
        ST.SCHOLARSHIP
FROM HR.STUDENTS_GP ST
INNER JOIN HR.DEPARTMENTS_GP DP
ON ST.DEPARTMENT_ID = DP.DEPARTMENT_ID;

--7.	Вывести список названий кафедр, где количество студентов больше либо равняется 4. 
SELECT  DP.DEPARTMENT_NAME,
        COUNT(ST.STUDENT_ID)
FROM HR.DEPARTMENTS_GP DP
INNER JOIN HR.STUDENTS_GP ST
ON DP.DEPARTMENT_ID = ST.DEPARTMENT_ID
WHERE 1=1
HAVING COUNT(ST.STUDENT_ID) >= 4
GROUP BY DP.DEPARTMENT_NAME;

--8.	Создать вьюшку на основе SQL запроса 01_06.sql. Название вью – STUDENTS_DEP_INICIALY
CREATE VIEW HR.STUDENTS_DEP_GP AS
SELECT  ST.STUDENT_ID, 
        DP.DEPARTMENT_NAME, 
        ST.TEACHER_ID, 
        ST.START_DATE, 
        ST.FULL_NAME, 
        ST.SCHOLARSHIP
FROM HR.STUDENTS_GP ST
INNER JOIN HR.DEPARTMENTS_GP DP
ON ST.DEPARTMENT_ID = DP.DEPARTMENT_ID;

--9.	Предоставить доступ на SELECT пользователю SLP
GRANT SELECT ON HR.STUDENTS_GP TO SLP;

-- 10.	Вывести названия департаментов, по которым есть студенты.
SELECT  ST.DEPARTMENT_NAME
FROM STUDENTS_DEP_GP ST
WHERE 1=1
HAVING COUNT(ST.STUDENT_ID) > 0
GROUP BY ST.DEPARTMENT_NAME;

--11.	Вывести студентов, которые поступили в университет только июле 2019 года. 
--Добавить один псевдостолбец, на основе функции to_char, которая бы выводила название месяца. 
SELECT  ST.*,
        TO_CHAR(ST.START_DATE,'Month') AS Manth
FROM HR.STUDENTS_GP ST
WHERE 1=1 
AND ST.START_DATE BETWEEN TO_DATE('01-07-2019','DD-MM-YYYY') 
AND TO_DATE('31-07-2019','DD-MM-YYYY')
ORDER BY ST.START_DATE ASC;

--12.	Создать вьюшку STUDENTS_FULL_INICIALY, на основе таблиц STUDENTS_INICIALY и  DEPARTMENTS_INICIALY. 
--Вывести все столбцы, кроме столбцов, по которым джоиним таблицы
CREATE VIEW HR.STUDENTS_GPS AS
SELECT  ST.STUDENT_ID,
        ST.TEACHER_ID, 
        ST.START_DATE, 
        ST.FULL_NAME, 
        ST.SCHOLARSHIP, 
        DP.DEPARTMENT_NAME, 
        DP.BLOCK_ID
FROM HR.STUDENTS_GP ST
INNER JOIN HR.DEPARTMENTS_GP DP
ON ST.DEPARTMENT_ID = DP.DEPARTMENT_ID;

--13.	Создадим специально ошибку, для этого вставим в таблицу STUDENTS_INICIALY, 
--дубликаты по студентам по таким студентам (типа кто ошибочно вставил еще раз данные по существующим студентам):
COMMIT;
INSERT INTO HR.STUDENTS_GP (STUDENT_ID, DEPARTMENT_ID, TEACHER_ID, START_DATE, FULL_NAME, SCHOLARSHIP)
SELECT 1, 50, 100, TO_DATE('01-08-2019','DD-MM-YYYY'), 'Беляев Матвей Артёмович', 700 FROM DUAL
UNION
SELECT 2, 50, 100, TO_DATE('22-08-2019','DD-MM-YYYY'), 'Блажевич Игорь Юрьевич', 690 FROM DUAL
UNION
SELECT 3, 50, 100, TO_DATE('01-08-2019','DD-MM-YYYY'), 'Валиева Руфина Рафаэлевна', 690 FROM DUAL;

--14.	Написать SQL запрос, который выводит строчки с дубликатами из таблицы STUDENTS_INICIALY
SELECT *
FROM HR.STUDENTS_GP ST
WHERE EXISTS (
                SELECT 1 
                FROM HR.STUDENTS_GP GP
                WHERE GP.STUDENT_ID = ST.STUDENT_ID
                AND ST.ROWID < GP.ROWID);
                
--15.	Получить список сотрудников с самым длинным именем 
SELECT  EM.*,
        LENGTH(EM.FIRST_NAME) AS LNG
FROM HR.EMPLOYEES EM
WHERE LENGTH(EM.FIRST_NAME) > 10
ORDER BY LENGTH(EM.FIRST_NAME) DESC;

--16.	Получить список сотрудников, менеджеры которых устроились на работу в 2005ом году.
SELECT *
FROM HR.EMPLOYEES EMP
WHERE 1=1
AND EMP.MANAGER_ID IN (
                        SELECT  EMP.MANAGER_ID  
                        FROM HR.EMPLOYEES MAN 
                        INNER JOIN HR.EMPLOYEES EMP
                        ON MAN.EMPLOYEE_ID = EMP.MANAGER_ID
                        WHERE MAN.HIRE_DATE BETWEEN TO_DATE('01-01-2005','DD-MM-YYYY') AND TO_DATE('31-12-2005','DD-MM-YYYY')
                        GROUP BY EMP.FIRST_NAME,EMP.HIRE_DATE,EMP.MANAGER_ID 
                        );
                        
--17.	Выбрать всех сотрудников, у которых есть менеджеры (только подчиненные сотрудники).
select *
from HR.EMPLOYEES EMP
where 1=1
and emp.employee_id  not in (
                        SELECT  emp.manager_id  
                        FROM HR.EMPLOYEES MAN 
                        INNER JOIN HR.EMPLOYEES EMP
                        ON MAN.EMPLOYEE_ID = EMP.MANAGER_ID
                        );
                        
--18.	Выбрать всех сотрудников, которые являются менеджерами
SELECT *
FROM HR.EMPLOYEES EM
WHERE EM.EMPLOYEE_ID IN (
                        SELECT DP.MANAGER_ID
                        FROM HR.DEPARTMENTS DP
                        WHERE DP.MANAGER_ID IS NOT NULL);
                        
/* 19.На основе SQL запроса из 14-го задания и нового скрытого столбца rowid, 
написать такой SQL запрос, который бы удалял (командой delete) бы эти 3 дублирующие записи. */
DELETE
FROM HR.STUDENTS_GP ST
WHERE EXISTS (
                SELECT 1 
                FROM HR.STUDENTS_GP GP
                WHERE GP.STUDENT_ID = ST.STUDENT_ID
                AND ST.ROWID < GP.ROWID);
                
COMMIT;

/*20 Есть вьюшка EMP_VIEW_TST. На основе этой вьюшки, вывести 3 столбец, 
в котором должна быть цифра, с количеством сотрудников, которые зарабатывают меньше,
чем текущий сотрудник.*/
SELECT  ST.* ,
        (DENSE_RANK() OVER (ORDER BY ST.salary DESC) - 1) AS rank_sal
FROM emp_view_tst ST;