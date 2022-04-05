-- SELECT 예제 중.. 5) HR 계정 접속 -- 

-- 문제1) HR 계정이 소유한 테이블 정보를 조회하는 쿼리(SQL)를 작성하세요.
SELECT *
FROM tabs;

-- 문제2) EMPLOYEES 테이블의 구조 확인하는 쿼리(SQL)를 작성하세요
DESC employees;
DESCRIBE employees; -- 위의 코딩과 동일함
컬럼명           널허용여부  자료형(크기)
이름             널?       유형           
-------------- -------- ------------ 
EMPLOYEE_ID    NOT NULL NUMBER(6)               사원ID 숫자(6자리)
FIRST_NAME              VARCHAR2(20)            이름
LAST_NAME      NOT NULL VARCHAR2(25)            이름
EMAIL          NOT NULL VARCHAR2(25)            이메일
PHONE_NUMBER            VARCHAR2(20)            연락처
HIRE_DATE      NOT NULL DATE                    입사일자
JOB_ID         NOT NULL VARCHAR2(10)            잡ID
SALARY                  NUMBER(8,2)             숫자(숫자, 실수) -> 실수값
COMMISSION_PCT          NUMBER(2,2)             커미션
MANAGER_ID              NUMBER(6)               직속상사ID
DEPARTMENT_ID           NUMBER(4)               부서ID

-- 문제3) employees 테이블에서 first_name과 last_name 컬럼을 조회하는 쿼리(SQL) 작성하세요
-- 조건1) first_name과 last_name 문자열을 합쳐서 full_name 컬럼명으로 출력
SELECT first_name, last_name
     -- , 'full_name'
     -- ,first_name + last_name -- 문자열 + 문자열 이므로 숫자가 아니라서 에러 발생
     -- , first_name || ' ' || last_name AS "name"
     ,  CONCAT( CONCAT( first_name, ' '), last_name) "full name"
FROM employees;

-- 별칭에 공백을 줄 경우 "" 필수
ORA-00923: FROM keyword not found where expected
00923. 00000 -  "FROM keyword not found where expected"
*Cause:    
*Action:
27행, 243열에서 오류 발생

-- 오라클 연산자  +   덧셈 연산자
-- 자바 연산자 + 숫자 덧셈, 문자열 연결 연산자
ORA-01722: invalid number
01722. 00000 -  "invalid number"
*Cause:    The specified number was invalid.
*Action:   Specify a valid number.

