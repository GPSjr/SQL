/* 1.	Вывести все данные из таблицы продаж, поля – все кроме ид сотрудника.
Добавить в выборку поля – имя, фамилия, телефон, почту и зарплату из таблицы сотрудников. 
Порядок полей – сразу запрашиваемые поля из таблицы сотрудников, потом запрашиваемые поля из таблицы продаж. */
SELECT  EM.FIRST_NAME, -- Вывел данные за Апрель т.к. в таблице SL есть только Март и Апрель ) 
        EM.LAST_NAME,
        EM.PHONE_NUMBER,
        EM.EMAIL,
        EM.SALARY,
        SL.DT_OPERATIONS,
        SL.PRODUCT_ID,
        SL.COUNT_SALES,
        SL.SUM_SALES
FROM HR.EMPLOYEES EM
INNER JOIN HR.SALES SL
ON EM.EMPLOYEE_ID = SL.EMPLOYEE_ID
WHERE 1=1
AND SL.DT_OPERATIONS BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -26)
AND ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -24) -1/86400;

/* 2.	Дополнить предыдущий отчет одним полем – название должности (из таблицы должности).
Так же добавить фильтр, вывести сотрудников только с должностью Sales Representative. */
SELECT  EM.FIRST_NAME, -- Вывел данные за Апрель т.к. в таблице SL есть только Март и Апрель ) 
        EM.LAST_NAME,
        EM.PHONE_NUMBER,
        EM.EMAIL,
        EM.SALARY,
        SL.DT_OPERATIONS,
        SL.PRODUCT_ID,
        SL.COUNT_SALES,
        SL.SUM_SALES,
        JB.JOB_TITLE
FROM HR.EMPLOYEES EM
INNER JOIN HR.SALES SL
ON EM.EMPLOYEE_ID = SL.EMPLOYEE_ID
LEFT JOIN HR.JOBS JB
ON EM.JOB_ID = JB.JOB_ID
WHERE 1=1
AND SL.DT_OPERATIONS BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -26)
AND ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -24) -1/86400
AND JB.JOB_TITLE = 'Sales Representative';

/* 3.	Из таблицы products, вывести название продуктов и дополнить всеми полями из таблицы продаж. 
Обязательно нужно отобразить все названия продуктов, даже если по ним не было продаж. Сделать сортировку по ид продукта */
SELECT  SL.EMPLOYEE_ID,
        SL.DT_OPERATIONS,
        SL.PRODUCT_ID,
        SL.COUNT_SALES,
        SL.SUM_SALES,
        PD.PRODUCT_NAME,
        PD.COUNT_PRODUCT,
        PD.PRICE_SALES
FROM HR.SALES SL
FULL JOIN HR.PRODUCTS PD
ON SL.PRODUCT_ID = PD.PRODUCT_ID
ORDER BY SL.PRODUCT_ID;

-- 1.	Получить список регионов и количество сотрудников в каждом регионе
SELECT  COUNT(EM.EMPLOYEE_ID) AS EMP,
        NVL(RG.REGION_NAME, 'Not Difine') AS REGION_NAM
FROM HR.REGIONS RG
LEFT JOIN HR.COUNTRIES CN
ON RG.REGION_ID = CN.REGION_ID
INNER JOIN HR.LOCATIONS LC
ON CN.COUNTRY_ID = LC.COUNTRY_ID
LEFT JOIN HR.DEPARTMENTS DP
ON DP.LOCATION_ID = LC.LOCATION_ID
RIGHT JOIN EMPLOYEES EM
ON DP.DEPARTMENT_ID = EM.DEPARTMENT_ID
WHERE 1=1
GROUP BY RG.REGION_NAME;

--2.	Показать всех менеджеров, которые имеют в подчинении больше 6-ти сотрудников.
SELECT  MAN.FIRST_NAME,
        COUNT(EMP.EMPLOYEE_ID) AS CNT_EMPL      
FROM HR.EMPLOYEES EMP
INNER JOIN HR.EMPLOYEES MAN
ON EMP.MANAGER_ID = MAN.EMPLOYEE_ID
GROUP BY MAN.FIRST_NAME
HAVING COUNT(EMP.EMPLOYEE_ID) > 6
ORDER BY 2 DESC;

-- 3.	Получить список департаментов и количество продаж в каждом департаментов.
SELECT  TT.DEPARTMENT_NAME,
        SUM(TT.COUNT_SALES) AS COUNT_SALES
FROM (
    SELECT  DP.DEPARTMENT_NAME,
            SL.COUNT_SALES
    FROM HR.DEPARTMENTS DP
    INNER JOIN HR.EMPLOYEES EM
    ON DP.DEPARTMENT_ID = EM.DEPARTMENT_ID
    INNER JOIN HR.SALES SL
    ON EM.EMPLOYEE_ID = SL.EMPLOYEE_ID ) TT
GROUP BY TT.DEPARTMENT_NAME;