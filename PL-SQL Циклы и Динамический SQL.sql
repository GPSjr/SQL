/*������� ������ �� ����� + �������� �� ������� �����������, 
� ����������� �� ���� ������ �� ������, �������� ������ ���, 
������� ������ �� ������ ����� 2007 ����.*/

begin
  
        for c_name in ( select em.first_name || ' ' || em.last_name as v_name, em.hire_date
                from hr.employees em ) loop
                
        if c_name.hire_date > TO_DATE('01.01.2007 00:00:00', 'DD.MM.YYYY HH24:MI:SS') then
                dbms_output.put_line(c_name.v_name);
        end if;
        
        end loop;

end;
/


-- 2 �������

begin
  
        for c_name in ( select em.first_name || ' ' || em.last_name as v_name, em.hire_date
                from hr.employees em 
                where em.hire_date > TO_DATE('01.01.2007 00:00:00', 'DD.MM.YYYY HH24:MI:SS') ) loop
        dbms_output.put_line(c_name.v_name);   
        end loop;

end;
/
/*���������, ���������� �� ���� 
�������� ��������� �� �������������� ���������.*/ 

DECLARE

  V_JOB_ID VARCHAR2(50) := 'SA_MAN2';

BEGIN

  FOR CC IN (SELECT J.JOB_TITLE
             FROM JOBS J 
             WHERE J.JOB_ID = V_JOB_ID) LOOP
  
    -- ��� 2 ������ ����, ���������� ������ ���� ������ �� FOR ���-�� ������
    DBMS_OUTPUT.PUT_LINE(CC.JOB_TITLE);
    RETURN; -- � ��������� ��� pl-sql ����� ��� ��������� ����. � ������� ��� ����� ���������� � ��������� ����.
  
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE(SYSDATE);
  RAISE_APPLICATION_ERROR(-20101, '��� ����� ���������'); -- ���������� ��� � �������� ���������
  --DBMS_OUTPUT.PUT_LINE('��� ����� ���������'); -- ������ �������� ���������, ��� ���� ��� ����� ����������� ������
  DBMS_OUTPUT.PUT_LINE(SYSDATE);

END;
/
/*��������� ��������� ������� ������ � ����� ������� �����������.*/

BEGIN
  
  DELETE FROM HR.EMPLOYEES_TEST TT;

  FOR CC IN ( SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID
              FROM HR.EMPLOYEES TT ) LOOP
                
    BEGIN
    INSERT INTO 
      HR.EMPLOYEES_TEST (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
    VALUES 
      (CC.EMPLOYEE_ID, CC.FIRST_NAME, CC.LAST_NAME, CC.EMAIL, CC.PHONE_NUMBER, CC.HIRE_DATE, CC.JOB_ID, CC.SALARY, CC.COMMISSION_PCT, CC.MANAGER_ID, CC.DEPARTMENT_ID);
    EXCEPTION 
    WHEN OTHERS THEN NULL;
    END;
    
    --COMMIT; -- �������� ������� ����� ������ ����������� ������

  END LOOP; 

    COMMIT;  
  
END;
/
/*����� ��� �������� ������� �� ���������� ������ �� ������-�� ��������, 
�������� ��� �������, � ������� �������� ������ ������ �������������. 
����� ���� ������� �� � �����.*/

BEGIN
 
FOR DEL_TB IN ( SELECT TABLE_NAME
                FROM ALL_TABLES
                WHERE OWNER = 'HR'
                AND TABLE_NAME LIKE '%TST%' ) LOOP
 
DBMS_OUTPUT.PUT_LINE('DROP TABLE '||DEL_TB.TABLE_NAME||';'); -- ������� �� ����� �������
--EXECUTE IMMEDIATE 'DROP TABLE '||DEL_TB.TABLE_NAME;  -- ��������� �������            
END LOOP;
 
END;
/
/*��������� ������� ������ �� ������� ������ � ������ �������� ������� ������, 
��� ���� ������� ��������� �� ���� � ����� ������� ������� ��� ������ ��������� 
������� ������ � �������� ��������� ��������� �� 
�������� ������� � ���������� ����������� �������.*/

DECLARE
  D        NUMBER;
  V_DATE   VARCHAR2(50) := '01.02.2021';
  --V_ST_FOR NUMBER := 28;
  LV_SQL   VARCHAR2(15000);
BEGIN

  DELETE FROM HR.SALES_INICIALY;
  D := 0;

  FOR CC IN 1 .. 28 /*������� ��������� ���� ������*/
   LOOP
    LV_SQL := ' 
              INSERT INTO HR.SALES_INICIALY
              SELECT EM.FIRST_NAME,
                     EM.LAST_NAME,
                     SS.DT_OPERATIONS, 
                     SS.PRODUCT_ID, 
                     SS.COUNT_SALES, 
                     SS.SUM_SALES
              FROM HR.SALES SS
              JOIN HR.EMPLOYEES EM
              ON SS.EMPLOYEE_ID = EM.EMPLOYEE_ID
              WHERE SS.DT_OPERATIONS >= TO_DATE(''' || V_DATE || ''',''DD.MM.YYYY'')+' || D || '
              AND SS.DT_OPERATIONS < TO_DATE(''' || V_DATE || ''',''DD.MM.YYYY'')+' || D || '+1
              ORDER BY SS.DT_OPERATIONS ';
  
    DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE(LV_SQL); -- ����� �� �����
    --EXECUTE IMMEDIATE LV_SQL;     -- ��������� V_SQL
    --DBMS_OUTPUT.PUT_LINE('��������� ����� = '||SQL%ROWCOUNT);
    --COMMIT;
    D := D + 1;
  END LOOP;

END;
/
/*������� ������� � ����� ������ HR_UTIL_INICIALY!
������� ����� HR_UTIL_INICIALY � ��������� � ����:
��������� �� �������� ADD_NEW_JOBS_INICIALY
��������� �� �� DEL_JOBS_INICIALY
������� SEARCH_JOB_INICIALY
����� ���� ��� �������� � ����� 3 �������, ����� ������� �� ����� HR ������ ��������� ��������� �������:
��������� �� �������� ADD_NEW_JOBS_INICIALY
��������� �� �� DEL_JOBS_INICIALY
������� SEARCH_JOB_INICIALY*/

CREATE PACKAGE UTIL_GS AS

 PROCEDURE ADD_NEW_JOBS_GS(P_JOB_ID     IN VARCHAR2,
                           P_JOB_TITLE  IN VARCHAR2,
                           P_MIN_SALARY IN NUMBER,
                           P_MAX_SALARY IN NUMBER DEFAULT NULL);
                           
 PROCEDURE DEL_JOBS_GS(P_JOB_ID IN HR.JOBS_GS.JOB_ID%TYPE);
 
 FUNCTION SEARCH_JOB_GS(P_JOB_ID IN VARCHAR2) RETURN VARCHAR2;
 
END UTIL_GS;

CREATE PACKAGE BODY UTIL_GS AS

-- 1 ��������� ���. ���������� . 
  PROCEDURE ADD_NEW_JOBS_GS(P_JOB_ID     IN VARCHAR2,
                            P_JOB_TITLE  IN VARCHAR2,
                            P_MIN_SALARY IN NUMBER,
                            P_MAX_SALARY IN NUMBER DEFAULT NULL) IS

  SALARY_ERR EXCEPTION;
  V_MAX_SALARY JOBS.MAX_SALARY%TYPE;

BEGIN

  IF P_MAX_SALARY IS NULL THEN
    V_MAX_SALARY := P_MIN_SALARY * 1.5;
  ELSE
    V_MAX_SALARY := P_MAX_SALARY;
  END IF;

  BEGIN
    
    IF (P_MIN_SALARY < 2000 OR P_MAX_SALARY < 2000) THEN
      RAISE SALARY_ERR;
    ELSE
      INSERT INTO HR.JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY) 
      VALUES (P_JOB_ID, P_JOB_TITLE, P_MIN_SALARY, V_MAX_SALARY);
      --COMMIT;
      DBMS_OUTPUT.PUT_LINE('New position successfully added.');
    END IF;
  
  EXCEPTION
    WHEN SALARY_ERR THEN
      RAISE_APPLICATION_ERROR(-20001, 'Transferred salary less than 2000.');
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20002, 'This position already exists.');
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20003, 'An error occurred while adding a new position.');
  END;

END ADD_NEW_JOBS_GS;

-- 2 ��������� ��. ���������� . 

PROCEDURE DEL_JOBS_GS( P_JOB_ID IN HR.JOBS_GS.JOB_ID%TYPE) IS V_JOB_TITLE HR.JOBS_GS.JOB_TITLE%TYPE;

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

END DEL_JOBS_GS;

-- 3 ������� 

FUNCTION SEARCH_JOB_GS(P_JOB_ID IN VARCHAR2) RETURN VARCHAR2 IS V_INFO VARCHAR2(80) := 'No such position';

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

END SEARCH_JOB_GS;

END UTIL_GS;
/

DROP PROCEDURE HR.DEL_JOBS_GS;
DROP PROCEDURE HR.ADD_NEW_JOBS_GS;
DROP FUNCTION HR.SEARCH_JOB_GS;
/*������� ������� ������� �� ��������� ������������� ������������. 
�� ���� ���������� ��  ������������, �� ����� �������� �������� ������������ 
��� ����� ���� ������ �������������. ������������ �������� ����� FOR.
�������� �������:
GET_DEP_CHECK_INICNALY
�������� ���������:
P_DEP_ID*/

CREATE FUNCTION GET_DEP_CHECK_GS (P_DEP_ID IN NUMBER) RETURN VARCHAR2  IS
  
BEGIN

FOR CC IN (SELECT  DP.DEPARTMENT_NAME FROM HR.DEPARTMENTS DP  WHERE DP.DEPARTMENT_ID = P_DEP_ID) LOOP
RETURN (CC.DEPARTMENT_NAME);
END LOOP;
RETURN '��� ������ ������������';
END;
/
