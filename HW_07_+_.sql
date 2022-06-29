SELECT *
FROM HR.EMPLOYEES_GP;

SELECT *
FROM HR.JOBS_GP;

COMMIT;

-- Создать копию таблицы Employees как Employees_inicialy
CREATE TABLE HR.EMPLOYEES_GP AS
SELECT *
FROM HR.EMPLOYEES EM;

-- В таблице Employees_inicialy, повысить всем сотрудникам зарплату на 25%;
UPDATE HR.EMPLOYEES_GP EM 
SET EM.salary = em.salary * 0.25 + em.salary;

-- В таблице Employees_inicialy, уволить сотрудника с идентификатором 135;
DELETE 
FROM HR.EMPLOYEES_GP EM
WHERE EM.EMPLOYEE_ID = 135;

-- В таблице Employees_inicialy, перевести сотрудника с идентификатором 140 в департамент 60
UPDATE HR.EMPLOYEES_GP EM 
SET EM.DEPARTMENT_ID = 60
WHERE EM.EMPLOYEE_ID = 140;

-- Создать копию таблицы jobs_inicialy
CREATE TABLE HR.JOBS_GP AS
SELECT *
FROM HR.JOBS;

--В таблицу jobs_inicialy, добавить новую должность  - QA (quality assurance)
INSERT INTO HR.JOBS_GP ( JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY )
SELECT 'QA', 'Quality Assurance', 0, 0 FROM DUAL;

-- Добавить нового сотрудника (себя в отдел 80 с новой ид должностью QA) в таблицу Employees_inicialy;
INSERT INTO HR.EMPLOYEES_GP (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
SELECT 207, 'Gennadyi', 'Sibilev', 'SIBILEV', '321.161.4554', TRUNC(sysdate,'dd'), 'QA', 5000, NULL, 100, 80
FROM DUAL;

-- Подготовить скрипты на удаление таблицы Employees_inicialy и jobs_inicialy
DROP TABLE HR.EMPLOYEES_GP;
DROP TABLE HR.HR.JOBS_GP;
