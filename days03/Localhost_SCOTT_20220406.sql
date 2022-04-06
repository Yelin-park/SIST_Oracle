-- [ SCOTT에 접속된 스크립트 파일 ]

--1. 용어정리
--  ㄱ. Data : 의미가 있는 정보(자료)
--  ㄴ. DataBase : 의미가 있는 정보의 저장소, 데이터의 집합
--  ㄷ. DBMS : 데이터 베이스 관리 시스템, 소프트웨어
--  ㄹ. DBA : 데이터 베이스 관리자, SYS와 SYSTEM 계정 자동 생성 모든 권한은 SYS가 깆고, SYSTEM은 DB 생성 권한 제외
--  ㅁ. 롤(ROLE) :
        다수의 사용자와 다양한 권한(privilege)을 효과적(권한 부여, 제거)으로 관리하기 위하여 서로 관련된 권한을 한 곳에 묶은 그룹
        롤이란, 사용자나 사용자 그룹이 필요로 하는 여러 관련된 권한들을 한데 묶어서 이름을 붙여 놓은 권한의 집합을 의미
        1) 롤 생성 -> 2) 롤에 권한 부여 -> 3) 사용자에게 롤 부여
        
        【형식】
        CREATE ROLE 롤이름
        [NOT IDENTFIED 또는 IDENTIFIED
        {BY PASSWORD 또는 EXTERNALLY 또는 GLOBALLY 또는 USING 패키지}];
        [테이블]
        CREATE TABLE 테이블명
        ALTER TABLE 테이블명~
        DROP TABLE 테이블명
        
        [계정]
        CREATE USER 계정명
        ALTER USER 계정명 IDENTIFIED BY 비밀번호 ACCOUNT UNLOCK;
        DROP USER 계정명
        
        [롤]
        CREATE ROLE 롤명
        ALTER ROLE 롤명 ~
        DROP ROLE 롤명
        
        영업부역할(ROLE) <- 50개의 권한 부여
         > CREATE ROLE 영업부 역할
        생산부역할(ROLE) <- 100개의 권한 부여
        신인사원역할(ROLE) <- 권한1... 권한30
        GRANT 50개의 권한 TO 롤명
        
        예) 신입사원 50명 <- 신입사원 30개의 권한
            A      <- 권한1...권한30        -> 이렇게 하나씩 주는 것보다 위처럼 롤을 만들어서 주는 것이 편리
            B      <- 권한1...권한30, 영업부역할 50개 권한
            C      <- 신입사원역할(ROLE), 생산부역할(ROLE)

select *
FROM dba_roles; -- 관리자 권한을 가진 계정만 조회가능, SYS에서만 조회 가능
00942. 00000 -  "table or view does not exist" - 오류 발생

select *
FROM user_role_privs; -- 계정에게 부여된 롤이 무엇이 있는지 조회
<실행결과>
SCOTT	CONNECT	NO	YES	NO
SCOTT	RESOURCE	NO	YES	NO

SELECT *
FROM role_sys_privs -- 롤에 부여된 시스템 권한이 무엇이 있는지 조회
WHERE role = 'RESOURCE';
<실행결과>
CREATE SEQUENCE
CREATE TRIGGER
CREATE CLUSTER
CREATE PROCEDURE
CREATE TYPE
CREATE OPERATOR
CREATE TABLE
CREATE INDEXTYPE

where role='STUDENT_ROLE';

롤 회수(제거)
REVOKE 롤이름
FROM 계정명 또는 롤이름 또는 PUBLIC;

문제1) scott 계정이 소유하고 있는 롤을 확인하고
      CONNECT 롤 제거하고
      CONNECT 롤 부여(생성)
      
SELECT *
FROM role_sys_privs;


REVOKE CONNECT FROM scott; -- SYS에 가서 실행해야 됨 (권한이 없기 때문에 오류발생)
REVOKE CONNECT FROM scott
오류 보고 -
ORA-01932: [ADMIN option] not granted for role 'CONNECT' -- ADMIN 옵션이 없다.
01932. 00000 -  "ADMIN option not granted for role '%s'"
*Cause:    The operation requires the admin option on the role.
*Action:   Obtain the grant option and re-try.

GRANT CONNECT TO scott; -- SYS에 가서 실행해야 됨 (권한이 없기 때문에 오류발생)

            
--  ㅂ. SID( 전역 데이터베이스 이름 )
    -- 설치된 오라클 DB의 고유한 이름
    -- 오라클 무료 버전을 설치하면 자동으로 SID는 XE로 잡힘
    -- 오라클 무료 버전은 1개만 설치 가능
    
--  ㅅ. 데이터 모델
--  ㅈ. R+DBMS
    -- 컴퓨터에 데이터를 저장하는 방식을 정의해 놓은 개념 모델
    -- 관계형 데이터 모델 사용 중 
    -- 관계형 데이터 모델 + DBMS = RDBMS
    
--  ㅇ. 스키마(Schema)
    -- 1) DB에서 어떤 목적을 위하여 필요한 여러 개로 구성된 테이블들의 집합을 Schema라 한다
    
    -- 2) DATABASE SCHEMA(DB 스키마) ?
        -- USER A가 생성되면 자동적으로 동일한 이름의 SCHEMA A가 생성된다.
        -- USER A는 SCHEMA A와 관련되어 DATABASE를 ACCESS한다.
        -- 그러므로 USER의 이름과 SCHEM A는 서로 바뀌어 쓰일 수 있다.

        -- 특정 USER와 관련된 모든 OBJECT의 모음
        -- scott 계정 생성 -> scott 계정이 사용할 수 있는 모든 OBJECT 만들어지고 이 모음을 '스키마'라고 한다.
        -- emp 테이블(객체) 생성
        FROM 스키마.테이블명
        FROM scott.emp;
        
    -- 3) 용어 정리
    -- 인스턴스(instance) : 오라클 서버 -> 시작(startup)해서 종료(shutdown)할 때 까지
    -- 세션(session) : 어떤 특정 사용자가 로그인해서 로그아웃 할 때 까지
    -- 스키마(schema) : 특정 USER와 관련된 OBJECT(테이블 등..)의 모음


--2. 설치된 [오라클을 삭제]하는 절차를 [검색]해서 상세히 적으세요.  ***
  ㄱ. 서비스앱 -> 오라클 관련 서비스 중지
  ㄴ. uninstall.exe / 프로그램 추가 및 삭제 - 제거
  ㄷ. 탐색기 - 오라클 관련된 폴더 삭제
  ㄹ. 레지스트리편집기(regedit.exe) -> 오라클과 관련된 레지스트리 삭제(구글링 검색해서 4가지 정도..) 

--3. SYS 계정으로 접속하여 모든 사용자 정보를 조회하는 쿼리(SQL)을 작성하세요.
SELECT *
FROM all_tables; -- SCOTT 계정이 소유하고 있는 테이블 + 권한 부여 받아서 사용할 수 있는 테이블 View
FROM tabs; -- 밑에 거와 동일함
FROM user_tables; -- SCOTT 계정이 소유하고 있는 테이블 View

예) 회사
    홍길동 - K9  user_cars; - 홍길동이 직접 소유하고 있는 자동차
            BMW all_cars; - 홍길동이 사용할 수 있는 자동차
    
    SM6
    NIRO
    회사 안에 있는 모든 차들을 가져올 때 dba_cars;

[SYS  접속해서 함]
SELECT *
FROM dba_users; -- dba_ 접두사 : 오라클 관리자가 데이터베이스 내의 모든 사용자의 데이터를 볼 수 있다.
오류메시지 : 권한 문제 또는 철자 틀린 것
ORA-00942: table or view does not exist
00942. 00000 -  "table or view does not exist" 

SELECT *
FROM user_users;

SELECT *
FROM all_users; -- all_ 접두사 : 현재 접속중인 USER(여기서는 SYS)가 모든 사용자 정보를 가져오는 view

--7-1. SCOTT 계정에게  scott.sql 파일을 찾아서 emp, dept, bonus, salgrade 테이블을 생성 및 데이터 추가한 과정을 작성하세요.
--7-2. 각 테이블에 어떤 정보를 저장하는지 컬럼에 대해 정보( 컬럼명, 자료형 )를 설명하세요.
--  ㄱ. emp
--  ㄴ. dept
--  ㄷ. bonus
--  ㄹ. salgrade

SELECT *
FROM tabs;

DESC emp;

--8. SCOTT 계정이 소유하고 잇는 모든 테이블을 조회하는 쿼리(SQL)을 작성하세요.
SELECT *
FROM user_users;
FROM all_users;

--9. SQL*Plus 를 사용하여 SYS로 접속하여 접속한 사용자 확인하고, 모든 사용자 정보를 조회하고
--   종료하는 명령문을 작성하세요.  

--10. 관계형 데이터 모델의 핵심 구성 요소
   ㄱ.  
   ㄴ.  
   ㄷ.  

--11. Oracle SQL Developer 에서 쿼리(SQL)을 실행하는 방법을 모두 적으세요.
   ㄱ. F9
   ㄴ. F5
   ㄷ. Ctrl + Enter

--12. 오라클 주석처리 방법  3가지를 적으세요.
    ㄱ. -- 한줄 주석처리
    ㄴ. rem REM 한줄 주석처리
    ㄷ. /* */ 블럭 주석처리

--13. 자료 사전( Data [Dictionary] ) 이란? 
    메타 데이터(META DATA) == Data Dictionary의 정보
    1) Data Dictionary = TABLE과 View들의 집합  -> View는 나중에 배울 예정..
    2) 역할 : DB의 정보를 제공하는 역할
        예) soctt 계정이 소유하고 있는 테이블 정보
            FROM user_users; -- Data Dictionary 안에 있는 View 중에 하나...
    3) DB 생성시 자동으로 SYS 계정 생성 -> SYS Schema 생성 -> 내부에 자료 사전(Data Dictionary) 생성
    4) 새로 추가가 되어더라도 백업이 되어있다.
    5) 자료사전은 DB 생성 후에 기본 테이블만 생성되어 있음. 따라서 DBA_, ALL_, USER_로 시작하는 자료사전 View는 확인 X
    6) 자료사전은 다음과 같이 시작되는 대표적인 4가지
    FROM user_tables; // 자료사전 안에 있는 '뷰'  -> 어떤 정보를 제공하는 역할
    dba_
    all_
    user_ 
    v$_ DB의 성능분석 / 통계 정보를 제공하는 뷰
    
SCOTT 계정 emp 테이블 생성
테이블이 생성되었다고 기록되어지는 곳이 자료 사전
그 안에 테이블의 생성시기, 소유자 등등이 나옴
    
--14. SQL 이란 ? 
서버 <- 질의/응답 -> 클라이언트
        언어 필요 -> 사용하는 언어 -> 구조화된 질의 언어 == SQL

--15. SQL의 종류에 대해 상세히 적으세요.
    ㄱ. DQL  SELECT
    ㄴ. DDL  CREATE ALTER DROP
    ㄷ. DML  INSERT UPDATE DELETE RENAME TRUNCATE  + 반드시 COMMIT 또는 ROLLBACK
    ㄹ. DCL  GRANT REVOKE
    ㅁ. TCL  COMMIT ROLLBACK SAVE POINT

--16. select 문의 7 개의 절과 처리 순서에 대해서 적으세요.
WITH 1
SELECT 6
FROM 2
WHERE 3
GROUP BY 4
HAVING 5
ORDER BY 7

--17. emp 테이블의 테이블 구조(컬럼정보)를 확인하는  쿼리를 작성하세요.
DESC emp;

NLS
날짜 형식 : RR/MM/DD
           YY/MM/DD
           RR년도와 YY년도 기호 차이점 중요 ***

--18. employees 테이블에서  아래와 같이 출력되도록 쿼리 작성하세요. 
SELECT first_name, last_name
FROM employees;

오류 메시지 : 철자 틀리거나 인식을 못하거나
ORA-00942: table or view does not exist
00942. 00000 -  "table or view does not exist" 

[HR 계정에 가서..]
FIRST_NAME          LAST_NAME                   NAME                                           
-------------------- ------------------------- ---------------------------------------------- 
Samuel               McCain                    Samuel McCain                                  
Allan                McEwen                    Allan McEwen                                   
Irene                Mikkilineni               Irene Mikkilineni                              
Kevin                Mourgos                   Kevin Mourgos                                  
Julia                Nayer                     Julia Nayer     

--20. HR 계정의 생성 시기와 [잠금상태]를 확인하는 쿼리를 작성하세요.
[SYS 계정에서..]
SELECT *
FROM dba_users;

--21. emp 테이블에서 잡,  사원번호, 이름, 입사일자를 조회하는 쿼리를 작성하세요.
SELECT job, num, name, ibsadate
FROM emp;

--22.  emp 테이블에서  아래와 같은 조회 결과가 나오도록 쿼리를 작성하세요.
    (  sal + comm = pay  )
SELECT empno, ename, sal, comm
        , NVL(comm, 0) + sal PAY
        , NVL2(comm, sal + comm, sal) PAY
FROM emp;
     EMPNO ENAME             SAL       COMM        PAY
---------- ---------- ---------- ---------- ----------
      7369 SMITH             800          0        800
      7499 ALLEN            1600        300       1900
      7521 WARD             1250        500       1750
      7566 JONES            2975          0       2975
      7654 MARTIN           1250       1400       2650
      7698 BLAKE            2850          0       2850
      7782 CLARK            2450          0       2450
      7839 KING             5000          0       5000
      7844 TURNER           1500          0       1500
      7900 JAMES             950          0        950
      7902 FORD             3000          0       3000

     EMPNO ENAME             SAL       COMM        PAY
---------- ---------- ---------- ---------- ----------
      7934 MILLER           1300          0       1300

	12개 행이 선택되었습니다.  

--23.  emp테이블에서
--    각 부서별로 오름차순 1차 정렬하고 급여(PAY)별로 2차 내림차순 정렬해서 조회하는 쿼리를 작성하세요.    
SELECT deptno, name, sal + NVL(comm, 0) PAY
FROM emp
ORDER BY deptno ASC, PAY DESC;

--29. SQL의 작성방법 @@@
SQL 문장 작성법
? SQL 문장은 대소문자를 구별하지 않는다.
? SQL*Plus에서 SQL 문장은 SQL 프롬프트에 입력되며, 이후의 Line은 줄번호가 붙는다.
? SQL 명령을 종료할 때는 세미콜론(;)을 반드시 붙여야 한다.
? 맨 마지막 명령어 1개가 SQL buffer에 저장된다.
? SQL 문장은 한 줄 이상일 수 있다.
? SQL 명령어를 구성하고 있는 단어중 어디에서나 분리해도 된다.
? 한 개의 line에 한 개의 절(select, from, where) 형태로 나누어 입력하는 것을 권한다.그러나 한 개의 단어를 두 줄로 나누어 입력해서는 안된다.
? keyword는 대문자로 입력하도록 권한다.
? 다른 모든 단어 즉, table 이름, column 이름은 소문자로 입력을 권한다.
? keyword는 단축하거나 줄로 나누어 쓸 수 없다.
? 절은 대개 줄을 나누어 쓰도고 권한다.
? 탭과 줄 넣기는 읽기 쉽게 하기 위해 사용을 권한다.


SQL? 구조화된 질의 언어
PL/SQL = SQL + 절차적 언어 문법 -> SQL에 절차적 언어(Procedural Language)가 확장된 것

절차적 언어 문법
if
for
위와 같은 제어문
변수

--30. 아래 에러 메시지의 의미를 적으세요.
  ㄱ. ORA-00942: table or view does not exist  -> 테이블명 / 뷰명 오타 또는 접근 권한이 없거나
  ㄴ. ORA-00904: "SCOTT": invalid identifier  -> 비밀번호 잘못되었다
                                    식별자
  ㄷ. ORA-00936: missing expression   -> 표현식(수식)이 잘못되었다.
  ㄹ. ORA-00933: SQL command not properly ended -> 명령 구문 끝이 잘못되었다.
  WHERE score >= 40 ||  -> 이런 경우 발생...

-- 31. emp 테이블에서 부서번호가 10번이고, 잡이 CLERK  인 사원의 정보를 조회하는 쿼리 작성.
-- 31-2. emp 테이블에서 잡이 CLERK 이고, 부서번호가 10번이 아닌 사원의 정보를 조회하는 쿼리 작성.
SELECT *
FROM emp
WHERE NOT(deptno = 10) AND job = 'CLERK';
WHERE deptno <> 10 AND job = 'CLERK';
WHERE deptno ^= 10 AND job = 'CLERK';
WHERE deptno != 10 AND job = 'CLERK';
WHERE deptno = 10 AND job = 'CLERK';

-- 32. 오라클의 null의 의미 와 null 처리 함수에 대해서 설명하세요 .
      ㄱ. null 의미? 
       ㄴ. null 처리 함수 2가지 종류와 형식을 적고 설명하세요 .

-- 33.  emp 테이블에서 부서번호가 30번이고, 커미션이 null인 사원의 정보를 조회하는 쿼리 작성.
  ( ㄱ.  deptno, ename, sal, comm,  pay 컬럼 출력,  pay= sal+comm )
  ( ㄴ. comm이 null 인 경우는 0으로 대체해서 처리 )
  ( ㄷ. pay 가 많은 순으로 정렬 )

SELECT deptno, ename, sal, comm, sal + NVL(comm, 0) PAY
FROM emp
WHERE deptno = 30 AND comm IS NULL;
WHERE deptno = 30 AND comm IS NOT NULL;

[NOT] IN(list)
[NOT] BETWEEN a AND b
IS [NOT] NULL

-- 34. insa 테이블에서 수도권 출신의 사원 정보를 모두 조회하는 쿼리 작성 ( 오름차순 정렬 )
  ㄱ. OR 연산자 사용해서 풀기
SELECT *
FROM insa
WHERE city = '서울' OR city = '경기' OR city = '인천'
ORDER BY city ASC;

  ㄴ. IN ( LIST ) SQL 연산자 사용해서 풀기 
SELECT *
FROM insa
WHERE city IN( '서울', '경기', '인천')
ORDER BY city ASC;
  
-- 35. insa 테이블에서 수도권 출신이 아닌 사원 정보를 모두 조회하는 쿼리 작성 ( 오름차순 정렬 )
  ㄱ. AND 연산자 사용해서 풀기
SELECT *
FROM insa
WHERE city != '서울' AND city != '경기' AND city != '인천'
ORDER BY city ASC;

  ㄴ. NOT IN ( LIST ) SQL 연산자 사용해서 풀기
SELECT *
FROM insa
WHERE city NOT IN ('서울', '경기', '인천')
ORDER BY city ASC;

  ㄷ. OR, NOT 논리 연산자 사용해서 풀기
SELECT *
FROM insa
WHERE NOT(city = '서울' OR city = '경기' OR city = '인천')
ORDER BY city ASC;
       
-- 36. 오라클 비교 연산자를 적으세요.
  ㄱ. 같다   :   =
  ㄴ. 다르다  :   != <> ^=
  
-- 37. emp 테이블에서 pay(sal+comm)가  1000 이상~ 2000 이하 받는 30부서원들만 조회하는 쿼리 작성
  조건 : ㄱ.  pay 기준으로 오름차순 정렬 --ename을 기준으로 오름차순 정렬해서 출력(조회)
           ㄴ. comm 이 null은 0으로 처리 ( nvl () )
1번째 풀이 방법)
SELECT deptno, ename, sal + NVL(comm, 0) PAY
FROM emp
WHERE sal + NVL(comm, 0) BETWEEN 1000 AND 2000 AND deptno = 30
ORDER BY pay ASC;

오류 메시지:
ORA-00904: "PAY": invalid identifier -> WHERE은 별칭을 인식하지 못한다.
00904. 00000 -  "%s: invalid identifier"

2번째 풀이 방법) WITH 절 사용
SELECT deptno, ename, sal + NVL(comm, 0) PAY
FROM emp
WHERE deptno = 30;
<실행결과>
30	ALLEN	1900
30	WARD	1750
30	MARTIN	2650
30	BLAKE	2850
30	TURNER	1500
30	JAMES	950

위의 결과물을 가지고 아래 코딩 하겠다 -> WITH 절 사용
WHERE pay BETWEEN 1000 AND 2000;

WITH temp AS(
    -- 쿼리 안에 쿼리가 들어가져 있는 것을 서브쿼리(subquery)라고 한다.
    SELECT deptno, ename, sal + NVL(comm, 0) PAY
    FROM emp
    WHERE deptno = 30
)
SELECT t.* -- t를 붙여도 되지만 안줘도 됨
FROM temp t -- 테이블의 별칭
WHERE t.pay BETWEEN 1000 AND 2000; -- t를 붙여도 되지만 안줘도 됨

3번째 풀이 방법) 인라인뷰(inline view) 사용
인라인뷰(inline view) ? FROM 절 안에 있는 서브쿼리를 인라인뷰 라고 한다.

SELECT t.*
FROM(
    -- 서브쿼리 == 인라인뷰(inline view)
    SELECT deptno, ename, sal + NVL(comm, 0) PAY
    FROM emp
    WHERE deptno = 30
) t -- 별칭을 t라고 주었다.
WHERE t.pay BETWEEN 1000 AND 2000;

-- 38. emp 테이블에서 1981년도에 입사한 사원들만 조회하는 쿼리 작성.
DESC emp; -- 구조 확인

SELECT hiredate, ename
FROM emp
WHERE hiredate BETWEEN '1981-01-01' AND '1981-12-31'
-- 1981.01.01
ORDER BY hiredate ASC;

SELECT hiredate
        ,SUBSTR(hiredate, 1, [length]) -- length를 안주면 끝까지 읽어온다.
        ,SUBSTR(hiredate, 0, 2)
        ,SUBSTR(hiredate, 1, 2) YY -- 처음부터 읽어오는 거라면 1이라고 줘도 되고 0을 줘도 되고
FROM emp
WHERE SUBSTR(hiredate, 0, 2) = '81'
ORDER BY hiredate ASC;

-- 오라클 날짜에서 년도만 가져오기
TO_CHAR(날짜형) 함수는 날짜형 인자값(매개변수)을 받아 내가 원하는 값(년도, 월, 일, 요일 등)을 문자열(VARCHAR2)로 반환하는 함수
오라클 날짜형 자료형 : DATE, TIMESTAMP, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH LOCAL TIME ZONE

【형식】
 	TO_CHAR( date [,'fmt' [,'nlsparam']])
    nlsparam
날짜 출력 형식의 종류 : Y, YYY

[YY와 RR의 차이점] - Ora_Help에서 to_char 검색 후 읽어보기
RR과 YY는 둘다 년도의 마지막 두자리를 출력해 주지만, 현재 system상의 세기와 나타내고자 하는 년도의 세기를 비교했을 때 출력되는 값이 다르다.
RR은 시스템상(1900년대)의 년도를 기준으로 하여 이전 50년도에서 이후 49년까지는 기준년도와 가까운 1850년도에서 1949년도까지의 값으로 표현하고, 
이 범위를 벗아날 경우 다시 2100년을 기준으로 이전 50년도에서 이후 49년까지의 값을 출력한다.
YY는 무조건 system상의 년도를 따른다.

SELECT hiredate
        , TO_CHAR(hiredate, 'RR') as RR
        , TO_CHAR(hiredate, 'YY') as YY
        , TO_CHAR(hiredate, 'YYYY') as YYYY
        , TO_CHAR(hiredate, 'RRRR') as RRRR
        , TO_CHAR(hiredate, 'YEAR') as YEAR
        , TO_CHAR(hiredate, 'SYYYY') as SYYYY
FROM emp;

SELECT hiredate
FROM emp
WHERE TO_CHAR(hiredate, 'YYYY') = '1981';

-- 내가 찾아본 것 EXTRACT()
SELECT EXTRACT(YEAR FROM hiredate) as year
FROM emp;

아래 두가지로도 38번 문제를 풀 수도 있음 나중에 다시 다뤄볼 예정~
LIKE SQL 연산자
REGEXP_LIKE() 함수

문제) insa 테이블에서 주민등록번호로 부터
     앞자리 6자리 출력, 뒷자리 7자리 출력, 년도 2자리 출력, 월 2자리, 일 2자리 출력,
     주민번호 마지막 검증 1자리 출력

SELECT ssn
        , SUBSTR(ssn, 0, 8) || '******' as RRN
        , CONCAT(SUBSTR(ssn, 0, 8), '******') as RRN
--        , SUBSTR(ssn, 0, 6) as 앞자리
--        , SUBSTR(ssn, 8) as 뒷자리
--        , SUBSTR(ssn, -7) as 뒷자리2 -- 두번째 인자값을 마이너스로 주어서 뒤에서부터 가져올 수 있음
--        , SUBSTR(ssn, 0, 2) as 년도
--        , SUBSTR(ssn, 3, 2) as 월
--        , SUBSTR(ssn, 5, 2) as 일
--        , SUBSTR(ssn, 14 ) as 검증번호
--        , SUBSTR(ssn, -1, 1 ) as 검증번호2 -- 뒤에서부터 가져올 수 있음
FROM insa;

DESC insa;
-- 39. emp 테이블에서 직속상사(mgr)가 없는  사원의 정보를 조회
SELECT empno, ename, mgr
FROM emp
WHERE mgr IS NULL;

-- 41. Alias 를 작성하는 3가지 방법을 적으세요.
   SELECT deptno, ename 
     , sal + comm   (ㄱ)  AS "PAY"
     , sal + comm   (ㄴ)  "PAY"
     , sal + comm   (ㄷ)  PAY
    FROM emp;

--42. 오라클의 논리 연산자를 적으세요.
  ㄱ.  & AND
  ㄴ.  | OR
  ㄷ.  ! NOT

-- 43. 어제 배운 오라클의 SQL 연산자를 적으세요.
  ㄱ. [NOT] IN()
  ㄴ. [NOT] BETWEEN a AND B
  ㄷ. IS [NOT] NULL
  
  ANY, SOME, ALL -> WHERE 조건절의 서브쿼리를 사용할 때 쓰이는 SQL 연산자이다.
------------------------------------------------------------------------------------

오늘 수업 시작.
1. LIKE SQL 연산자 설명

문제1) insa 테이블에서 성이 "김"씨 인 사원의 정보 조회

1) SUBSTR() 사용
SELECT name
    -- ,SUBSTR(name, 0, 1), ibsadate
FROM insa
WHERE SUBSTR(name, 0, 1) = '김';

2) LIKE 사용
LIKE 연산자 기호 = 와일드카드(wildcard) : % 와                    _               -> 2개 밖에 없음
자바 정규표현식 :                       * 반복횟수 0 ~ 여러번     1번 와야한다. 
[ wildcard를 일반 문자처럼 쓰고 싶은 경우에는 ESCAPE 옵션을 사용 -> 나중 설명]

SELECT name
FROM insa
WHERE name LIKE '_김_'; -- 무조건 3글자 문자인데 가운데가 '김'인 것
WHERE name LIKE '_김%'; -- 첫번째 문자 1개 있고 그 뒤에 '김'이 오고 뒤에는 문자가 있던 없던 상관X
WHERE name LIKE '%김'; -- 앞에 문자가 있던 없던 마지막 문자는 '김'으로 끝나는 것
WHERE name LIKE '%김%'; -- 문자열 속에 '김'이 포함되어 있는 것
WHERE name LIKE '김_'; -- 첫번째 문자는 '김'이 오고 1문자는 꼭 와야한다.
WHERE name LIKE '김%'; -- 첫번째 문자는 '김'이 오고 뒤에 문자가 와도 안와도 상관 없다.

emp테이블에서 1981년도에 입사한 사원들만 조회하는 쿼리 -LIKE 사용
SELECT hiredate, ename
FROM emp
WHERE hiredate LIKE '81%';

2. REGEXP_LIKE() 함수 : 와일드카드 대신 정규표현식을 사용하는 LIKE 함수
【형식】
    regexp_like (search_string, pattern [,match_option])
[match_option]의 값은 다음과 같은 의미로 작동한다.
    i  대소문자 구분 없음
    c  대소문자 구분 있음
    n  period(.)를 허용함
    m  source string이 여러 줄인 경우(multiple lines)
    x  whitespace character(공백문자) 무시 

문제1) 김씨로 시작하는 사원 출력
SELECT name, ssn
FROM insa
WHERE REGEXP_LIKE(name, '남$'); -- 남으로 끝나는 것
WHERE REGEXP_LIKE(name, '^김'); -- 김으로 시작하는 것

문제2) 김씨 또는 이씨 사원 출력
1) LIKE 연산자 사용
SELECT name
FROM insa
WHERE name LIKE '이%' OR name LIKE '김%'
ORDER BY name ASC;

2) REGEXP_LIKE 연산자 사용
SELECT name
FROM insa
WHERE REGEXP_LIKE(name, '^[김이]')
ORDER BY name ASC;

SELECT name
FROM insa
WHERE REGEXP_LIKE(name, '^(김|이)')
ORDER BY name ASC;

문제3) 이름 속에 'la' 문자열을 포함하는 사원 정보를 출력
1) LIKE 연산자 사용
SELECT ename
FROM emp
WHERE ename LIKE '%LA%';
WHERE ename LIKE '%' || 'LA' || '%';
WHERE ename LIKE '%' || UPPER('la') || '%'; -- 대문자로 변환하는 함수 UPPER()

2) REGEXP_LIKE 연산자 사용
SELECT ename
FROM emp
WHERE REGEXP_LIKE(ename, 'la', 'i');
WHERE REGEXP_LIKE(ename, UPPER('la'));
WHERE REGEXP_LIKE(ename, 'LA');

문제4) insa 테이블에서 성이 김씨, 이씨는 제외한 모든 사원 정보 조회
1) [NOT] LIKE 연산자 사용
SELECT name
FROM insa
WHERE NOT (name LIKE '김%' OR name LIKE '이%');
WHERE name NOT LIKE '김%' AND name NOT LIKE '이%';

2) [NOT] REGEXP_LIKE 연산자 사용
SELECT name
FROM insa
--WHERE NOT REGEXP_LIKE(name, '^(김|이)');
--WHERE NOT REGEXP_LIKE(name, '^[김이]');
WHERE REGEXP_LIKE(name, '^[^김이]');



