/* Создать процедуру - DEL_JOBS_INICIALY 
Входящий параметр: 
P_JOB_ID
Общая логика процедуры:
Удаление существующей должности в справочнике HR.JOBS_INICIALY (создать свою копию таблицы).
Исключение:
Процедура должна проверить существование удаляемой должности, если должности нет, 
выдаем сообщение “Данной должности не существует” и останавливаем дальнейшие действия.
Действие:
Удаление должности по P_JOB_ID из  HR.JOBS_INICIALY. В конце удаление нужно поставить commit;
После commit, выдать сообщение (через DBMS_OUTPUT.PUT_LINE) “Переданный код должности, успешно удален”. */

CREATE OR REPLACE PROCEDURE DEL_JOBS_GS (
                               P_JOB_ID IN HR.JOBS_GS.JOB_ID%TYPE
                               ) IS
V_JOB_TITLE HR.JOBS_GS.JOB_TITLE%TYPE;

BEGIN
  BEGIN
    SELECT JB.JOB_ID
    INTO V_JOB_TITLE
    FROM HR.JOBS_GS JB
    WHERE JB.JOB_ID = P_JOB_ID;
    
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR (-20001, 'This position does not exist.');  
  END;  
  
DELETE FROM HR.JOBS_GS  WHERE HR.JOBS_GS.JOB_ID = P_JOB_ID;
COMMIT;

DBMS_OUTPUT.PUT_LINE('Position successfully deleted');

END;
/
-- ПРОВЕРКА ПРОЦЕДУРЫ
SELECT *
FROM HR.JOBS_GS;

--ВЫЗОВ ПРОЦЕДУРЫ
BEGIN
HR.DEL_JOBS_GS(P_JOB_ID => 'PR_REP');
END;
/

/* 
Создать функцию - SEARCH_JOB_INICIALY (RETURN VARCHAR2)
Входящий параметр: 
P_JOB_ID
Общая логика функции:
Функция должна проверить по коду должности, есть ли такая должность в таблице сотрудников или в таблице должностей. 
Действие/проверка:
Если должность, есть на сотруднике (таблица employees), вернуть (через return) “Данная должность есть на сотруднике”.
Если должность, есть в справочнике должностей (таблица jobs), вернуть (через return)  “Данная должность есть в справочнике должностей”.
Если нету должности, ни там, ни там (иначе), вернуть (через return)  “Нет такой должности”.
*/

CREATE FUNCTION SEARCH_JOB_GS (
                                P_JOB_ID IN VARCHAR2
                                ) RETURN VARCHAR2 IS
V_INFO VARCHAR2(80) := 'No such position';

BEGIN 
  
  BEGIN
    SELECT DISTINCT 'This position is on the employee'
    INTO V_INFO
    FROM HR.EMPLOYEES EM
    WHERE EM.JOB_ID = P_JOB_ID;
    RETURN V_INFO;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  
  BEGIN
       SELECT 'Department is in catalog'
       INTO V_INFO
       FROM HR.JOBS J
       WHERE J.JOB_ID = P_JOB_ID;
   EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
   END;

RETURN V_INFO;

END;
/

-- ВЫЗОВ ПРОЦЕДУРЫ 
SELECT SEARCH_JOB_GS(P_JOB_ID => 'IT_PROG')
FROM DUAL;

/*Создать функцию, которая в зависимости от ид сотрудника возвращала его зарплату:*/
CREATE FUNCTION GETSALARY_GS (
                             P_EMP_ID IN NUMBER
                             ) RETURN NUMBER IS 
V_SALARY HR.EMPLOYEES.SALARY%TYPE;

BEGIN

      BEGIN
      SELECT EM.SALARY 
      INTO V_SALARY 
      FROM HR.EMPLOYEES EM 
      WHERE EM.EMPLOYEE_ID = P_EMP_ID;
      EXCEPTION WHEN OTHERS THEN V_SALARY := 999; 
      END;

RETURN V_SALARY; 
END;
/


SELECT SYSDATE,GETSALARY_GS(P_EMP_ID => 100) AS SALARY
FROM DUAL;

/*Создать функцию, которая по ИД сотрудника показывала с какого региона сотрудник:*/
CREATE FUNCTION GETREGION_NAME(P_EMP_ID IN NUMBER) RETURN VARCHAR2 IS 

V_REGION_NAME HR.REGIONS.REGION_NAME%TYPE;

BEGIN

     BEGIN
        SELECT RG.REGION_NAME
        INTO V_REGION_NAME
        FROM HR.EMPLOYEES EM
        JOIN HR.DEPARTMENTS DP
        ON EM.DEPARTMENT_ID = DP.DEPARTMENT_ID
        JOIN LOCATIONS LC
        ON LC.LOCATION_ID = DP.LOCATION_ID
        JOIN COUNTRIES CN
        ON CN.COUNTRY_ID = LC.COUNTRY_ID
        JOIN REGIONS RG
        ON RG.REGION_ID = CN.REGION_ID
        WHERE EM.EMPLOYEE_ID = P_EMP_ID;
     EXCEPTION WHEN OTHERS THEN V_REGION_NAME:='НЕТ ТАКОГО СОТРУДНИКА';
     END;

RETURN V_REGION_NAME;

END;
/


select em.*, nvl(GETREGION_NAME(P_EMP_ID => em.employee_id), 'not_difiend') as REGION_NAME
from hr.employees em;

-- создание пакета
CREATE PACKAGE UTIL_GS AS

 FUNCTION GETREGION_NAME(P_EMP_ID IN NUMBER) RETURN VARCHAR2;

END UTIL_GS;
/

CREATE PACKAGE BODY UTIL_GS AS

FUNCTION GETREGION_NAME(P_EMP_ID IN NUMBER) RETURN VARCHAR2 IS 

V_REGION_NAME VARCHAR2(100);
BEGIN

     BEGIN
        SELECT RG.REGION_NAME
        INTO V_REGION_NAME
        FROM HR.EMPLOYEES EM
        JOIN HR.DEPARTMENTS DP
        ON EM.DEPARTMENT_ID = DP.DEPARTMENT_ID
        JOIN LOCATIONS LC
        ON LC.LOCATION_ID = DP.LOCATION_ID
        JOIN COUNTRIES CN
        ON CN.COUNTRY_ID = LC.COUNTRY_ID
        JOIN REGIONS RG
        ON RG.REGION_ID = CN.REGION_ID
        WHERE EM.EMPLOYEE_ID = P_EMP_ID;
        EXCEPTION WHEN OTHERS THEN V_REGION_NAME:=NULL;
     END;

RETURN V_REGION_NAME;

END;

END UTIL_GS;
/
