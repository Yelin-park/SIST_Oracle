-- [ HR에 접속된 스크립트 파일 ]
23. hr 계정으로 접속
    employees 테이블에서 first_name, last_name 이름 속에 'ev' 문자열 포함하는 사원 정보 출력
    
FIRST_NAME           LAST_NAME                 NAME                                           NAME                                                                                                                                                                                    
-------------------- ------------------------- ---------------------------------------------- -------------------------
Kevin                Feeney                    Kevin Feeney                                   K[ev]in Feeney                                                                                                                                                                          
Steven               King                      Steven King                                    St[ev]en King                                                                                                                                                                           
Steven               Markle                    Steven Markle                                  St[ev]en Markle                                                                                                                                                                         
Kevin                Mourgos                   Kevin Mourgos                                  K[ev]in Mourgos    

SELECT first_name, last_name
        , first_name || ' ' || last_name NAME
FROM employees
WHERE CONCAT(first_name, last_name) LIKE '%ev%';

SELECT t.*, REPLACE(t.name, 'ev', '<sapn color = blue>ev</span>')
SELECT t.*, REPLACE(t.name, 'ev', '[ev]')
FROM(
    SELECT first_name, last_name
            , first_name || ' ' || last_name NAME
    FROM employees
) t
WHERE t.name LIKE '%ev%';

------------------------------------------------------
시노님(synonym) 설명

SELECT *
FROM emp;
-- 에러 메시지 : ORA-00942: table or view does not exist
-- 원인 : emp 테이블은 scott 계정

SELECT *
FROM scott.emp;
-- 에러 메시지 : ORA-00942: table or view does not exist

-- SYS로 계정 접속

scott 계정이 생성한 emp 테이블이 있다면
emp 테이블의 소유자는 scott이다. -> 즉, 소유자만 사용할 수 있다. -> 권한 부여가 필요
권한을 부여하면 스키마.테이블명으로 사용 가능 -> 시노님(SYNONYM)을 설정하면 편하게 사용 가능

SELECT *
FROM arirang;

DELETE FROM arirang
WHERE empno = 7369;
-- 에러 메시지 : SQL 오류: ORA-01031: insufficient privileges
-- 해석 : 권한이 충분하지 않다.

