/* 1.	Вывести в все строки из таблицы продуктов, и сгенерировать три строки внизу (на основе таблицы dual),
с ид продуктом – 110, 120, 130 и названием продукта - TEST11, TEST12, TEST13.
Количество продуктов и цена – произвольная */
SELECT *
FROM HR.PRODUCTS P1
            UNION
SELECT 110, 'TEST11', 2, 200
FROM DUAL 
            UNION
SELECT 120, 'TEST12',32, 300
FROM DUAL 
            UNION
SELECT 130, 'TEST13', 22, 400
FROM DUAL;

--2.	Вывести ид продуктов, которых нет в таблице продаж. Далее, на основе этих ид, вывести название продуктов, количество продуктов и цену
SELECT  TB2.PRODUCT_ID, 
        TB2.PRODUCT_NAME, 
        TB2.COUNT_PRODUCT, 
        TB2.PRICE_SALES
FROM (
    SELECT T2.PRODUCT_ID
    FROM HR.PRODUCTS T2
    MINUS 
    SELECT T1.PRODUCT_ID
    FROM HR.SALES T1 
    ) TB
INNER JOIN HR.PRODUCTS TB2
ON tb.product_id = tB2.product_id
ORDER BY 1 ASC ;

-- или можно так
SELECT *
FROM HR.PRODUCTS PD
WHERE PD.PRODUCT_ID IN ( SELECT PD.PRODUCT_ID
                         FROM HR.PRODUCTS PD 
                         MINUS
                         SELECT SL.PRODUCT_ID
                         FROM HR.SALES SL )
ORDER BY 1 ASC;

--3. Из таблицы должностей, вывести все столбцы и сделать итоговую строку с суммой по минимальной ЗП и максимальной ЗП.  
SELECT JB.*
FROM (
        SELECT *
        FROM HR.JOBS 
        ORDER BY 1 ) JB

UNION ALL

SELECT ' ', 'Итого:', SUM(TT.MIN_SALARY), SUM(TT.Max_SALARY)
FROM HR.JOBS TT;