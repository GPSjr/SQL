/* 1.	Вывести все данные из таблицы продаж, при этом вторым столбцом нужно вывести 
имя и фамилию из таблицы сотрудников. Имя и фамилию нужно присоединить вместе, 
чтобы получился один столбец под названием name_emp. */  
SELECT  SL.*,
        ( SELECT (EM.FIRST_NAME || ' ' || EM.LAST_NAME) AS EMT 
        FROM HR.EMPLOYEES EM 
        WHERE EM.EMPLOYEE_ID = SL.EMPLOYEE_ID) NAME_EMP
FROM HR.SALES SL;

-- 2.	Вывести данные из таблицы продуктов, по которым были продажи
SELECT *
FROM HR.PRODUCTS PD
WHERE EXISTS (  SELECT * 
                FROM HR.SALES SL 
                WHERE SL.PRODUCT_ID = PD.PRODUCT_ID );

-- 3.	Создать SQL запрос, который бы всегда выводил данные по продажам за предыдущим месяц два года назад 
SELECT *
FROM HR.SALES SL
WHERE 1=1
AND SL.DT_OPERATIONS BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -27)
AND ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -26) -1/86400
ORDER BY 2;

-- 4.	Получить максимальную зарплату среди всех средних зарплат по департаменту
SELECT  MAX(TB1.SL) AS MAX_AVG
FROM    (SELECT  ROUND(AVG( EM.SALARY), 0) AS SL,
                (SELECT DP.DEPARTMENT_NAME 
                FROM HR.DEPARTMENTS DP 
                WHERE DP.DEPARTMENT_ID = EM.DEPARTMENT_ID) DEP_NAME
        FROM HR.EMPLOYEES EM
        GROUP BY EM.DEPARTMENT_ID ) TB1;

-- 5.	Получить список сотрудников с самым длинным именем (погуглить функцию LENGTH);
SELECT  EM.*,
        LENGTH(EM.FIRST_NAME) AS LNG
FROM HR.EMPLOYEES EM
WHERE LENGTH(EM.FIRST_NAME) > 10
ORDER BY LENGTH(EM.FIRST_NAME) DESC; 