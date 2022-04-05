-- [ SCOTT에 접속된 스크립트 파일 ]

-- scott으로 접속해서 계정을 하나 생성하겠다... 오류 발생
-- 구문은 맞지만 계정 생성할 수 있는 권한 X
-- CREATE USER admin IDENTIFIED BY a123$;

--명령의 4 행에서 시작하는 중 오류 발생 -
--CREATE USER admin IDENTIFIED BY 123$  -> 비밀번호에 a를 뺏을때..
오류 보고 -
ORA-00911: invalid character
00911. 00000 -  "invalid character"           -> 비밀번호 부여가 잘못됐다
*Cause:    The identifier name started with an ASCII character other than a
          letter or a number. After the first character of the identifier
           name, ASCII characters are allowed including "$", "#" and "_".
           Identifiers enclosed in double quotation marks may contain any
           character other than a double quotation. Alternate quotation
           marks (q'#...#') cannot use spaces, tabs, or carriage returns as
           delimiters. For all other contexts, consult the SQL Language
           Reference Manual.

CREATE USER admin IDENTIFIED BY a123$
오류 보고 -
ORA-01031: insufficient privileges        -> 권한이 충분하지 않아서 계정을 생성할 수 없다.
01031. 00000 -  "insufficient privileges"
*Cause:    An attempt was made to perform a database operation without
           the necessary privileges.

--------------------------------------------------------------------------------------------------------

-- 1. 테이블 생성
-- CREATE TABLE 이렇게 하는건데 아직 문법을 안배워서
-- C드라이브 -> oralcexe -> SCOTT.sql 검색 후 메모장으로 띄우기
REM rem -> 이것도 주석

-- 2. scott 계정이 소유하고 있는 테이블 조회(확인)
SELECT *
FROM tabs;
-- 소유하고 있는 테이블이 없다.

-- 3. DEPT 테이블(부서 테이블)을 생성하겠다.
CREATE TABLE DEPT(
    DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY, -- DEPNO 컬럼(부서번호 컬럼)
	DNAME VARCHAR2(14) ,                             --DNAME 컬럼(부서명 컬럼)
	LOC VARCHAR2(13)                                 -- LOC 컬럼(지역명 컬럼)
) ;
-- Table DEPT이(가) 생성되었습니다.

-- 오라클 자료형 :
-- number(2) -> 2자리 숫자 자료형
-- varchar2(14) -> 14바이트 크기의 문자열 자료형

SELECT *
FROM scott.dept;
FROM dept;
FROM 스키마.테이블명; -- 원칙은 이렇게 해야되는데 현재 SCOTT에 접속했기 때문에 테이블명만 적어도 가능

-- 4. 어떤 테이블의 구조를 조회(확인)
-- 1번 방법
DESC dept;
DESC 테이블명;

-- scott 계정을 생성하면 scott 계정과 동일한 스키마(SCHEMA) 생성

-- 5. dept 테이블 - 부서정보 추가 작업     DML INSERT문
--                      부서번호    '부서명'     '지역명'
--                      오라클에서 문자열일 경우 앞뒤에 ''(홑따옴표)를 붙인다.
INSERT INTO DEPT VALUES	(10,'ACCOUNTING','NEW YORK'); -- 데이터 하나를 추가하는 작업
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES	(30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES	(40,'OPERATIONS','BOSTON');
COMMIT;

-- 6. 4개의 행(레코드)가 추가(INSERT) 되었는지 확인(조회)
SELECT *
FROM dept;

-- 7. EMP (사원) 테이블 생성
CREATE TABLE EMP(
-- 사원들을 구별할 수 있는 고유한 키로 사원번호(empno) 컬럼을 설정
    EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY, -- 사원번호, PRIMARY KEY(PK) == 고유한 키, 고유키
	ENAME VARCHAR2(10),                            -- 사원명
	JOB VARCHAR2(9),        -- 잡(일)
	MGR NUMBER(4),          -- 직속상사의 사원번호
	HIREDATE DATE,          -- 입사일자
	SAL NUMBER(7,2),        -- 급여
	COMM NUMBER(7,2),       -- 커미션
	DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT -- 부서번호, REFERENCES(참조) / dept(부서) 테이블의 DEPTNO(부서번호)를 참조하겠다.
);
-- Table EMP이(가) 생성되었습니다.

-- 8. 사원(emp) 테이블 조회
SELECT *
FROM emp;

-- 9. 사원(emp) 테이블에 사원정보 추가 (SCOTT, ADAMS 제외)
INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,to_date('13-JUL-87')-85,3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,to_date('13-JUL-87')-51,1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);
COMMIT;

-- 10. 12명의 사원 등록(추가)된 것을 확인(조회)
SELECT *
FROM emp;

-- 11. 보너스 테이블 생성
CREATE TABLE BONUS
	(
	ENAME VARCHAR2(10)	,
	JOB VARCHAR2(9)  ,
	SAL NUMBER,
	COMM NUMBER
	) ;

-- 12. 급여 등급 테이블 생성
CREATE TABLE SALGRADE
      ( GRADE NUMBER,
	LOSAL NUMBER,
	HISAL NUMBER );
INSERT INTO SALGRADE VALUES (1,700,1200); -- 700~1200 급여를 받으면 1등급
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999); -- 3001~9999 급여를 받으면 5등급
COMMIT;

-- 13. SCOTT이 소유한 테이블 정보 조회
SELECT *
FROM tabs;

-- salgrade(급여등급) 테이블 조회
SELECT *
FROM salgrade;

-- 여기까지 한 작업은 SCOTT.sql 파일로(메모장열어서) 샘플로 사용할 테이블 4개 생성 + 데이터 추가 작업

-- 14. DQL - [ SELECT문 ]
-- 1) SELECT 또는 subquery를 이용하여
-- 2) 대상 : '하나 이상'의 테이블, 뷰 로부터
-- 3) 데이터를 가져오는 데 사용하는 문 ***

-- 15. 어떤 테이블 또는 뷰로부터 데이터를 가지고 오려면 소유자(자신 소유의 스키마) 또는 SELECT 권한이 있어야 한다.

-- 16.【형식】-> 암기 못함 ^^
    [subquery_factoring_clause] subquery [for_update_clause];

【subquery 형식】- 형식 안에 있는 subquery
   {query_block ?
    subquery {UNION [ALL] ? INTERSECT ? MINUS }... ? (subquery)} 
   [order_by_clause] 

【query_block 형식】- subquery 안에 있는 query_block
   SELECT [hint] [DISTINCT ? UNIQUE ? ALL] select_list
   FROM {table_reference ? join_clause ? (join_clause)},...
     [where_clause] 
     [hierarchical_query_clause] 
     [group_by_clause]
     [HAVING condition]
     [model_clause]

【subquery factoring_clause형식】
   WITH {query AS (subquery),...}
   
-- 17. ***** SELECT 문의 절(clause, 각 부분을 나타내는 절) ***** 과 처리 순서 ***
각각의 절마다 줄 바꿈을 한다. (아래와 같이..)
호는 처리 순서이지만 코딩은 아래와 같은 순서로 한다.
[ WITH 절      --- 1 ]
SELECT 절    --- 6
FROM 절      --- 2
[ WHERE 절     --- 3 ]
[ GROUP BY 절  --- 4 ]
[ HAVING 절    --- 5 ]
[ ORDER BY 절  --- 7 ]

-- 18. SELECT 절에서 사용할 수 있는 키워드(예약어) : DISTINCT, ALL, [AS]

-- 19. SELECT 예제..
-- 1) 모든 사원 정보를 조회(확인, 검색) 하는 SQL(쿼리==Query)로 작성하세요.
SELECT * -- 모든 컬럼을 조회하겠다
FROM emp; -- 테이블명 또는 뷰 대상

-- 2) 모든 사원 정보를 조회하는 SQL(쿼리==Query)로 작성할건데.. 조건이 있다.
(조건 : 사원번호, 사원명, 입사일자만 조회)
SELECT empno, ename, hiredate
FROM emp;

-- 3) 모든 사원들을 조회 (사원번호, 사원명, 입사일자, 급여, 커미션)
조건 1) 급여(sal) 많이 받는 사람 순으로 정렬해서 조회
        sal 내림차순(descending) 정렬
SELECT empno, ename, hiredate, sal, comm
FROM emp
ORDER BY sal DESC; -- 내림차순 정렬
ORDER BY sal [ASC]; -- 기본 정렬 : 오름차순(ascending) 정렬

-- 4) 모든 사원들을 조회
조건 1) 부서번호, 사원번호, 사원명, 입사일자
조건 2) 입사일자 순으로 정렬(최근에 입사한 사원을 먼저 출력)
SELECT deptno, empno, ename, hiredate
FROM emp
ORDER BY deptno, hiredate;
ORDER BY deptno ASC, hiredate ASC;
-- 1차로 정렬 : deptno(부서별) 오름차순 정렬
-- 2차로 정렬 : 부서별로 정렬된 상태에서 2차로 hiredate(입사일자)기준으로 내림차순 정렬
ORDER BY 1 ASC, 4 DESC; -- 1은 deptno으로 인식, 4는 hiredate로 인식
ORDER BY deptno ASC, hiredate DESC;
ORDER BY hiredate DESC; -- 입사일자 내림차순 정렬

-- 5) HR 계정으로 접속 Localhost_HR

-- 문자열 연결하는 방법
-- 방법1) ||
SELECT ename || ' has $' || sal
FROM emp;

-- 방법2) CONCAT
SELECT CONCAT( CONCAT( ename, ' has $' ), sal)
FROM emp;

-- 6) 사원번호, 사원명, 입사일자, sal, comm 출력
-- 조건1) sal + comm == pay로 출력

-- 이름 == 별명 == 별칭 
[AS 키워드]는 SELECT절에 컬럼의 별칭을 부여할 때 사용하는 키워드(예약어)
"" 쌍따옴표를 생략해도 가능하다.
AS를 생략해도 별칭을 줄 수 있다.
SELECT empno AS "사원번호"
       , ename AS 사원명
       , hiredate 입사일자
       , sal, comm
       , sal + comm AS "월급"
       , nvl2(sal + comm, sal + comm, sal) AS pay
       , nvl2(comm, sal + comm, sal)
       , sal + nvl(comm, 0) -- 위의 nvl2() 코딩과 동일한 결과
FROM emp;
    (1) 어떤 값 + null ==> 무조건 null이 나온다.
    (2) 오라클 null 의미? 미확인 값, 아직 적용되지 않은 값   
    예) 이름 / 몸무게
         홍길동 / 65.93
         김철수 / null      -> 김철수의 몸무게를 측정 X -> 확인 되지 않은 값
    (3) comm 컬럼의 값 중 null 처리 필요
       결정) null을 0으로 처리하겠다.
    (4) 오라클에서 null 처리하는 함수 : nvl2(), nvl()
    【형식】
        NVL2(expr1, expr2, expr3)
        expr1 값이 null 아니면 expr2
                  null 이면 expr3
        첫번째 값은 어떤 데이터 타입도 가능, 두 번째와 세 번째 값에는 LONG 데이터 타입 사용 X
    
    【형식】
	 NVL(expr1,expr2)
     null을 0 또는 다른 값으로 변환하기 위한 함수
SELECT comm
        , nvl(comm, 0)
        , sal + nvl(comm, 0)
FROM emp;

-- 7) emp 사원테이블에서 job 출력(조회)
-- 조건1) 중복된 결과물은 배제 후 출력..  -> DISTINCT 키워드 사용
SELECT DISTINCT job -- 원래는 SELECT ALL job ALL이 생략되어져 있는것
FROM emp
ORDER BY job ASC;

-- 8) SCOTT 계정이 소유하는 모든 테이블 조회
FROM 테이블명 또는 뷰명
-- user_tables와 tabs 같은 말이다.
-- 오라클 '데이터 사전(dictionary)'에 포함된 뷰(view) - user_tables == 뷰명
SELECT *
FROM user_tables; -- 뷰명
FROM tabs;

-- 9) emp 사원 테이블에서 모든 사원 정보를 조회(확인, 검색)
-- 조건1) 10번 부서 사원 정보만 조회 - [WHERE 사용]
-- 조건2) sal+comm 급여 기준으로 오름차순 정렬
-- 부서번호, 사원명, pay(sal+comm)
SELECT deptno, ename, sal+nvl(comm, 0) pay
FROM emp
WHERE deptno = 10
ORDER BY sal + nvl(comm, 0) ASC;

WHERE deptno == 10
ORA-00936: missing expression
00936. 00000 -  "missing expression" -- '==' 수식이 잘못되었다. 오라클에서 같다라는 연산자는 = 1개
*Cause:    
*Action:
299행, 15열에서 오류 발생

-- 10) insa.spl 스크립트 파일 코드(강사님이 주심)
CREATE TABLE insa(
        num NUMBER(5) NOT NULL CONSTRAINT insa_pk PRIMARY KEY
       ,name VARCHAR2(20) NOT NULL
       ,ssn  VARCHAR2(14) NOT NULL
       ,ibsaDate DATE     NOT NULL
       ,city  VARCHAR2(10)
       ,tel   VARCHAR2(15)
       ,buseo VARCHAR2(15) NOT NULL
       ,jikwi VARCHAR2(15) NOT NULL
       ,basicPay NUMBER(10) NOT NULL
       ,sudang NUMBER(10) NOT NULL
);
-- Table INSA이(가) 생성되었습니다.

INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1001, '홍길동', '771212-1022432', '1998-10-11', '서울', '011-2356-4528', '기획부', 
   '부장', 2610000, 200000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1002, '이순신', '801007-1544236', '2000-11-29', '경기', '010-4758-6532', '총무부', 
   '사원', 1320000, 200000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1003, '이순애', '770922-2312547', '1999-02-25', '인천', '010-4231-1236', '개발부', 
   '부장', 2550000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1004, '김정훈', '790304-1788896', '2000-10-01', '전북', '019-5236-4221', '영업부', 
   '대리', 1954200, 170000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1005, '한석봉', '811112-1566789', '2004-08-13', '서울', '018-5211-3542', '총무부', 
   '사원', 1420000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1006, '이기자', '780505-2978541', '2002-02-11', '인천', '010-3214-5357', '개발부', 
   '과장', 2265000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1007, '장인철', '780506-1625148', '1998-03-16', '제주', '011-2345-2525', '개발부', 
   '대리', 1250000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1008, '김영년', '821011-2362514', '2002-04-30', '서울', '016-2222-4444', '홍보부',    
'사원', 950000 , 145000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1009, '나윤균', '810810-1552147', '2003-10-10', '경기', '019-1111-2222', '인사부', 
   '사원', 840000 , 220400);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1010, '김종서', '751010-1122233', '1997-08-08', '부산', '011-3214-5555', '영업부', 
   '부장', 2540000, 130000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1011, '유관순', '801010-2987897', '2000-07-07', '서울', '010-8888-4422', '영업부', 
   '사원', 1020000, 140000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1012, '정한국', '760909-1333333', '1999-10-16', '강원', '018-2222-4242', '홍보부', 
   '사원', 880000 , 114000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1013, '조미숙', '790102-2777777', '1998-06-07', '경기', '019-6666-4444', '홍보부', 
   '대리', 1601000, 103000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1014, '황진이', '810707-2574812', '2002-02-15', '인천', '010-3214-5467', '개발부', 
   '사원', 1100000, 130000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1015, '이현숙', '800606-2954687', '1999-07-26', '경기', '016-2548-3365', '총무부', 
   '사원', 1050000, 104000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1016, '이상헌', '781010-1666678', '2001-11-29', '경기', '010-4526-1234', '개발부', 
   '과장', 2350000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1017, '엄용수', '820507-1452365', '2000-08-28', '인천', '010-3254-2542', '개발부', 
   '사원', 950000 , 210000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1018, '이성길', '801028-1849534', '2004-08-08', '전북', '018-1333-3333', '개발부', 
   '사원', 880000 , 123000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1019, '박문수', '780710-1985632', '1999-12-10', '서울', '017-4747-4848', '인사부', 
   '과장', 2300000, 165000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1020, '유영희', '800304-2741258', '2003-10-10', '전남', '011-9595-8585', '자재부', 
   '사원', 880000 , 140000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1021, '홍길남', '801010-1111111', '2001-09-07', '경기', '011-9999-7575', '개발부', 
   '사원', 875000 , 120000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1022, '이영숙', '800501-2312456', '2003-02-25', '전남', '017-5214-5282', '기획부', 
   '대리', 1960000, 180000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1023, '김인수', '731211-1214576', '1995-02-23', '서울', NULL           , '영업부', 
   '부장', 2500000, 170000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1024, '김말자', '830225-2633334', '1999-08-28', '서울', '011-5248-7789', '기획부', 
   '대리', 1900000, 170000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1025, '우재옥', '801103-1654442', '2000-10-01', '서울', '010-4563-2587', '영업부', 
   '사원', 1100000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1026, '김숙남', '810907-2015457', '2002-08-28', '경기', '010-2112-5225', '영업부', 
   '사원', 1050000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1027, '김영길', '801216-1898752', '2000-10-18', '서울', '019-8523-1478', '총무부', 
   '과장', 2340000, 170000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1028, '이남신', '810101-1010101', '2001-09-07', '제주', '016-1818-4848', '인사부', 
   '사원', 892000 , 110000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1029, '김말숙', '800301-2020202', '2000-09-08', '서울', '016-3535-3636', '총무부', 
   '사원', 920000 , 124000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1030, '정정해', '790210-2101010', '1999-10-17', '부산', '019-6564-6752', '총무부', 
   '과장', 2304000, 124000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1031, '지재환', '771115-1687988', '2001-01-21', '서울', '019-5552-7511', '기획부', 
   '부장', 2450000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1032, '심심해', '810206-2222222', '2000-05-05', '전북', '016-8888-7474', '자재부', 
   '사원', 880000 , 108000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1033, '김미나', '780505-2999999', '1998-06-07', '서울', '011-2444-4444', '영업부', 
   '사원', 1020000, 104000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1034, '이정석', '820505-1325468', '2005-09-26', '경기', '011-3697-7412', '기획부', 
   '사원', 1100000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1035, '정영희', '831010-2153252', '2002-05-16', '인천', NULL           , '개발부', 
   '사원', 1050000, 140000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1036, '이재영', '701126-2852147', '2003-08-10', '서울', '011-9999-9999', '자재부', 
   '사원', 960400 , 190000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1037, '최석규', '770129-1456987', '1998-10-15', '인천', '011-7777-7777', '홍보부', 
   '과장', 2350000, 187000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1038, '손인수', '791009-2321456', '1999-11-15', '부산', '010-6542-7412', '영업부', 
   '대리', 2000000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1039, '고순정', '800504-2000032', '2003-12-28', '경기', '010-2587-7895', '영업부', 
   '대리', 2010000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1040, '박세열', '790509-1635214', '2000-09-10', '경북', '016-4444-7777', '인사부', 
   '대리', 2100000, 130000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1041, '문길수', '721217-1951357', '2001-12-10', '충남', '016-4444-5555', '자재부', 
   '과장', 2300000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1042, '채정희', '810709-2000054', '2003-10-17', '경기', '011-5125-5511', '개발부', 
   '사원', 1020000, 200000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1043, '양미옥', '830504-2471523', '2003-09-24', '서울', '016-8548-6547', '영업부', 
   '사원', 1100000, 210000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1044, '지수환', '820305-1475286', '2004-01-21', '서울', '011-5555-7548', '영업부', 
   '사원', 1060000, 220000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1045, '홍원신', '690906-1985214', '2003-03-16', '전북', '011-7777-7777', '영업부', 
   '사원', 960000 , 152000);         
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1046, '허경운', '760105-1458752', '1999-05-04', '경남', '017-3333-3333', '총무부', 
   '부장', 2650000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1047, '산마루', '780505-1234567', '2001-07-15', '서울', '018-0505-0505', '영업부', 
   '대리', 2100000, 112000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1048, '이기상', '790604-1415141', '2001-06-07', '전남', NULL           , '개발부', 
   '대리', 2050000, 106000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1049, '이미성', '830908-2456548', '2000-04-07', '인천', '010-6654-8854', '개발부', 
   '사원', 1300000, 130000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1050, '이미인', '810403-2828287', '2003-06-07', '경기', '011-8585-5252', '홍보부', 
   '대리', 1950000, 103000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1051, '권영미', '790303-2155554', '2000-06-04', '서울', '011-5555-7548', '영업부', 
   '과장', 2260000, 104000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1052, '권옥경', '820406-2000456', '2000-10-10', '경기', '010-3644-5577', '기획부', 
   '사원', 1020000, 105000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1053, '김싱식', '800715-1313131', '1999-12-12', '전북', '011-7585-7474', '자재부', 
   '사원', 960000 , 108000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1054, '정상호', '810705-1212141', '1999-10-16', '강원', '016-1919-4242', '홍보부', 
   '사원', 980000 , 114000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1055, '정한나', '820506-2425153', '2004-06-07', '서울', '016-2424-4242', '영업부', 
   '사원', 1000000, 104000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1056, '전용재', '800605-1456987', '2004-08-13', '인천', '010-7549-8654', '영업부', 
   '대리', 1950000, 200000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1057, '이미경', '780406-2003214', '1998-02-11', '경기', '016-6542-7546', '자재부', 
   '부장', 2520000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1058, '김신제', '800709-1321456', '2003-08-08', '인천', '010-2415-5444', '기획부', 
   '대리', 1950000, 180000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1059, '임수봉', '810809-2121244', '2001-10-10', '서울', '011-4151-4154', '개발부', 
   '사원', 890000 , 102000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1060, '김신애', '810809-2111111', '2001-10-10', '서울', '011-4151-4444', '개발부', 
   '사원', 900000 , 102000);
   
COMMIT;

----------------------------------------------------------------------------------
SELECT *
FROM insa;

-- 문제1) insa 테이블에서 사원의 출신지역이 '서울'인 사원의 정보 조회(출력)
--      조건1) 사원번호, 이름, 입사일자, 출신지역 출력
SELECT num, name, ibsadate, city
FROM insa
WHERE city = '서울';

-- 문제2) insa 테이블에서 사원의 출신지역이 수도권인 사원의 정보 조회(출력)
--      조건1) 사원번호, 이름, 입사일자, 출신지역 출력
-- 수도권 ?
-- 방법1) OR 연산자 사용
SELECT num, name, ibsadate, city
FROM insa
WHERE city = '서울' OR city = '인천' OR city = '경기' -- OR 연산자 == OR
ORDER BY city ASC;

-- 방법2) SQL 연산자 중 IN 사용
SELECT num, name, ibsadate, city
FROM insa
WHERE city IN('서울', '경기', '인천')
ORDER BY city ASC;

-- 문제3) insa 테이블에서 사원의 출신지역이 '서울'이 아닌 사원의 정보 조회(출력)
--      조건1) 사원번호, 이름, 입사일자, 출신지역 출력
-- 비교 연산자 중 같지 않다 : !=  <>   ^=
-- 논리 연산자 : NOT
-- SQL 연산자 : NOT IN -- 목록일 경우 사용 권장, 하나만 제외할 때는 비교연산자 사용하기
SELECT num, name, ibsadate, city
FROM insa

WHERE city != '서울'
WHERE city <> '서울'
WHERE city ^= '서울'

WHERE NOT city = '서울'

WHERE city NOT IN('서울') -- 목록일 경우 사용 권장, 하나만 제외할 때는 비교연산자 사용하기

WHERE NOT city IN('서울') -- 이때의 NOT은 부정연산자 city IN ('서울')을 부정하겠다.

ORDER BY city ASC;


-- 문제4) insa 테이블에서 사원의 출신지역이 수도권이 아닌 사원의 정보 조회(출력)
--      조건1) 사원번호, 이름, 입사일자, 출신지역 출력
SELECT num, name, ibsadate, city
FROM insa
WHERE city != '서울' AND city != '인천' AND city != '경기' -- 비교연산자
WHERE city NOT IN ('서울', '인천', '경기') -- NOT IN() SQL 연산자
WHERE NOT city IN ('서울', '인천', '경기') -- NOT 부정 연산자
ORDER BY city ASC;

-- 문제5) insa 테이블에서 기본급이 150만원 이상인 사원 정보를 출력
-- 조건1) name, basicpay
-- 조건2) 부서별로 1차 정렬, 2차 정렬로 basicpay 오름차순 정렬
SELECT buseo, name, basicpay
FROM insa
WHERE basicpay >= 1500000
ORDER BY buseo ASC, basicpay ASC; -- ASC 지워도 기본값이 오름차순 정렬!

-- 문제6) insa 테이블에서 기본급이 150만원 이상 250만원 이하의 사원 정보를 출력
-- 조건1) 영업부 사원만 조회
-- 조건2) 기본급 오름차순 정렬
SELECT buseo, name, basicpay
FROM insa
-- WHERE buseo = '영업부' AND (basicpay >= 1500000 AND basicpay <= 2500000)
-- BETWEEN은 자기 자신의 값도 포함, a AND b 중 b의 값이 a보다 커야함
WHERE buseo = '영업부' AND basicpay BETWEEN 1500000 AND 2500000  -- 이걸 더 많이 사용함
ORDER BY basicpay;

[실행결과]
영업부	전용재	1950000
영업부	김정훈	1954200
영업부	손인수	2000000
영업부	고순정	2010000
영업부	산마루	2100000
영업부	권영미	2260000
영업부	김인수	2500000

-- 문제7) insa 테이블에서 기본급이 150만원 미만이고 250만원 초과해서 받는 사원의 정보 출력
-- 조건1) 영업부 사원만 조회
-- 조건2) 기본급 오름차순 정렬
SELECT buseo, name, basicpay
FROM insa
WHERE buseo = '영업부' AND basicpay < 1500000 OR basicpay > 2500000
WHERE buseo = '영업부' AND NOT(basicpay BETWEEN 1500000 AND 2500000)
WHERE buseo = '영업부' AND basicpay NOT BETWEEN 1500000 AND 2500000
ORDER BY basicpay;

-- 문제8) insa 테이블에서 입사년도가 1998년도인 사원의 정보를 출력
-- 조건1) name, ibsadate 컬럼 출력
-- 테이블 구조 확인..
DESC insa;  -- IBSADATE 오라클 자료형 : 날짜형(DATE)
-- '98/01/01' 오라클에서 문자열, 날짜형은 ''이 붙는다.

-- WHERE ibsadate 정규표현식 98 시작(검색해보기)
-- ibsadate Java의 substring()과 같은.. SUBSTR() 함수
-- 오라클 날짜 년도 반환 함수 ? LIKE 연산자, REGEX_LIKE()
SELECT name, ibsadate
       -- , SUBSTR(ibsadate, 1, 2)
       -- , SUBSTR(ibsadate, 0, 2)
FROM insa
-- WHERE ibsadate >= '1998.1.1' AND ibsadate <= '1998.12.31'
-- WHERE ibsadate >= '98/01/01' AND ibsadate <= '98/12/31'
-- WHERE ibsadate BETWEEN '1998-01-01' AND '1998-12-31'
WHERE SUBSTR(ibsadate, 0, 2) = '98'
ORDER BY ibsadate ASC;

-- 내일 오라클 연산자, 자료형, 함수...
-- 문제) emp 테이블에서 comm이 null인 모든 사원 정보를 조회(출력)하는 쿼리(SQL) 작성하세요.
SELECT *
FROM emp
WHERE comm IS NULL;
