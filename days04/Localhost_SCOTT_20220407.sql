-- [ SCOTT에 접속된 스크립트 파일 ]

1. subquery 에 대해 설명하세요 ? 
	1) 하나의 SQL 문장의 절에 부속된 또 다른 SELECT 문장으로,
        두 번의 질의를 수행해야 얻을 수 있는 결과를 한 번의 질의로 해결할 수 있는 문장이다.
    2) subquery에는 두 종류의 연산자가 사용되며, 연산자의 오른쪽에 서브쿼리가 () 묶여져 있다. -> 연산자 + (서브쿼리) -> 사용한 적 X
        결과로 하나의 행을 반환하는 연산자  >, <, >=, <=, < > 
        결과로 여러 행을 반환하는 SQL 연산자  IN, ANY, ALL 
    3) 질의가 미지정된 값을 근거로 할 때 유용하다 -> 나중 설명
    4) 서브쿼리는 메인쿼리의 조건으로도 사용된다.
        WHERE 조건절 안에 (서브쿼리)                   -> 사용한 적 X
    5) 서브쿼리의 결과는 main out query에 의해 사용된다. -> 사용한 적 X
    6) 실행 순서 : 서브쿼리 먼저 실행 -> 그 결과를 main query에 전달하여 실행
    7) WHERE, HAVING, INSERT INTO 절, UPDATE SET 절, SELECT, DELETE FROM 절에 서브쿼리를 사용할 수 있다.
    8) 서브쿼리는 ORDER BY 절을 포함할 수 없다. 인라인 뷰에서는 사용할 수 있다.
    9) 서브쿼리를 사용하면 성능은 저하되지만(단점), 코딩은 간결하고 쉽게할 수 있다.(장점)

2. Inline View 에 대해 설명하세요 ?
	1) FROM 절 뒤에 사용되는 서브쿼리
    2) FROM 테이블명 또는 뷰명
            (서브쿼리) -> 이렇게 와서 마치 테이블처럼 사용되어짐

3. WITH 절에 대해 설명하세요 ?
    1) 사용될 서브쿼리 블록을 미리 선언하여 반복하여 사용할 수 있도록 함
    2) 형식 -> 여러 개의 서브쿼리를 선언해서 사용할 수 있음
        WITH 쿼리이름1 AS (SELECT문 서브쿼리), -> WITH절 속에는 SELECT문이 반드시 있어야 함
             쿼리이름2 AS (SELECT문 서브쿼리),
             쿼리이름3 AS (SELECT문 서브쿼리)
    3) with절을 불러서 사용하는 body 영역에서는 block명이 우선되므로 테이블명은 사용할 수 없다.
    4) with절 내에 또 다른 with절을 포함할 수 없다.
    5) set operator를 사용한 쿼리에서는 사용할 수 없다
    6) WITH절을 사용하면 서브쿼리의 성능저하를 방지할 수 있다.
    7) 테이블 별칭..
    WITH 
     person_maxpay AS (select p.deptno, max(sal) as maxpay
                       from emp p, dept d
                       where p.deptno=d.deptno
                       group by p.deptno)

    SELECT m.deptno,m.maxpay
    FROM person_maxpay m;   ☜ 여기에는 with 절에서 사용된 emp,dept 테이블 이름을 사용하면 X
                                이름을 짧게해서 사용하기 위해서 별칭을 준다.

9. 어제까지 배운 Oracle 함수를 적고 설명하세요 .
   ㄱ. NVL(1, 2) -> 1번 값이 null이면 0또는 다른 값으로 반환해주는 함수
   ㄴ. NVL2(1, 2, 3) -> 1번 값이 null이 아니면 2번 값으로, null이면 3번 값으로 반환해주는 함수
   ㄷ. UPPER(문자열) -> 소문자를 대문자로 바꿔주는 함수
   ㄹ. TO_CHAR(컬럼명, 날짜표현식) -> 날짜형을 문자열로 반환해주는 함수
   ㅁ. EXTRACT(날짜표현식 FROM 컬럼명) -> 날짜형을 숫자형으로 반환해주는 함수
   ㅅ. CONCAT(1번 문자열, 2번 문자열) -> 문자열 연결해주는 함수
   ㅇ. SUBSTR(문자열, 위치(음수값 : 뒤에서부터), [길이]) -> 문자열을 원하는 위치에서 길이만큼 잘라주는 함수
   ㅈ. LIKE()와 REGEXP_LIKE()
   등등

11. insa 테이블에서 70년대생 남자사원만 아래와 같이 주민등록번호로 정렬해서 출력하세요.
SELECT name, CONCAT(SUBSTR(ssn, 0, 8), '******') RRN
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d{5}-[13579]\d{6}')
WHERE REGEXP_LIKE(ssn, '^7.{6}[13579]')
 . -> 모든 문자 1문자
 \. -> 문자 .
ORDER BY RRN ASC;

SELECT name, CONCAT(SUBSTR(ssn, 0, 8), '******') RRN
FROM insa
WHERE REGEXP_LIKE(ssn, '^7') AND MOD(SUBSTR(ssn, -7, 1), 2) = '1'
ORDER BY RRN ASC;

WHERE LIKE '7%'

NAME                 RRN           
-------------------- --------------
문길수               721217-1******
김인수               731211-1******
김종서               751010-1******
허경운               760105-1******
정한국               760909-1******
최석규               770129-1******
지재환               771115-1******
홍길동               771212-1******
산마루               780505-1******
장인철               780506-1******
박문수               780710-1******
이상헌               781010-1******
김정훈               790304-1******
박세열               790509-1******
이기상               790604-1******

15개 행이 선택되었습니다. 




12. insa 테이블에서 70년대 12월생 모든 사원 아래와 같이 주민등록번호로 정렬해서 출력하세요.
SELECT name, ssn
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d12')
ORDER BY ssn ASC;

SELECT name, ssn
FROM insa
WHERE ssn LIKE '7_12%'
ORDER BY ssn ASC;

<실행결과>
NAME                 SSN           
-------------------- --------------
문길수               721217-1951357
김인수               731211-1214576
홍길동               771212-1022432


13. LIKE 연산자의 ESCAPE 에 대해서 설명하세요. + DML문 다루기
- whildcard(% _)를 일반 문자처럼 쓰고 싶은 경우에 ESCAPE 옵션을 사용 -> o. 에서 확인 가능

ㄱ. dept 테이블 조회
SELECT *
FROM dept;

ㄴ. dept 테이블의 구조 확인
DESC dept;
이름     널?       유형           
------ -------- ------------ 
DEPTNO NOT NULL NUMBER(2)    null값 X 필수로 입력되어져야 한다. 2자리 숫자
DNAME           VARCHAR2(14) 14바이트 문자열
LOC             VARCHAR2(13) 13바이트 문자열

ㄷ. 새로운 부서를 추가 : DML - INSERT문 + COMMIT
[INSERT문 형식]
INSERT INTO 테이블명 (컬럼명..) VALUES (컬럼값..);
COMMIT;

INSERT INTO dept (deptno, dname, loc) VALUES (50, 'QC100%T', 'SEOUL');
COMMIT;
-- 1 행 이(가) 삽입되었습니다.

INSERT INTO dept (deptno, dname, loc) VALUES (40, 'QC100%T', 'SEOUL');
<오류 메시지>
ORA-00001: unique constraint (SCOTT.PK_DEPT) violated
해석 :      유일성  제약조건     PK = Primary Key(고유한 키값)    위배  -> 이미 고유한 키값인 부서번호 40이 존재한다.
해결 : 고유한 키값과 중복되지 않는 값으로 추가하기

INSERT INTO dept (deptno, dname, loc) VALUES (100, 'QC100%T', 'SEOUL');
<오류 메시지>
ORA-01438: value larger than specified precision allowed for this column
해석 : 컬럼값에 지정된 정밀도 값보다 더 큰 값이 들어왔다.
해결 : 지정된 정밀도 값을 변경 또는 값을 지정된 정밀도 값에 맞게 집어넣기
precision : 정밀도(p)

ㄹ. 추가 되었는지 확인
SELECT *
FROM dept;

ㅁ. 데이터 수정 : DML - UPDATE문 + COMMIT
30번 부서의 부서명을 SALES -> SA%LES로 수정

UPDATE dept
SET dname = 'SA%LES'
WHERE deptno = 30; -- WHERE 조건절이 없으면 모든 행(레코드)가 수정이 된다.
--> WHERE 절을 안주면 dname이 다 SA%LES로 바뀜 WHERE 안줘서 다 바뀌었을 때 ROLLBACK; 하면 되돌아갈 수 있음
COMMIT;
-- 1 행 이(가) 업데이트되었습니다.

[UPDATE 형식]
UPDATE 테이블명
SET 수정할 컬럼명 = 새로운 컬럼명, 수정할 컬럼명 = 새로운 컬럼명, 수정할 컬럼명 = 새로운 컬럼명.. -> 여러개 줘도 됨
[WHERE]

ㅂ. 변경 되었는지 확인
SELECT *
FROM dept;

ㅅ. 40 부서를 삭제 :DML - DELETE문 + COMMIT / TRUNCATE문 -> 이건 나중에 
40	OPERATIONS	BOSTON

DELETE dept
WHERE deptno = 40;
-- 1 행 이(가) 삭제되었습니다.
COMMIT;

!!주의!! COMMIT을 해버리면 ROLLBACK이 되지 않는다.

ROLLBACK;

INSERT INTO dept (deptno, dname, loc) VALUES (40, 'OPERATIONS', 'BOSTON');
INSERT INTO dept VALUES (40, 'OPERATIONS', 'BOSTON'); -- (deptno, dname, loc) 이 부분 생략할 수 있음
COMMIT;

[DELETE 형식]
DELETE FROM 테이블명; -- WHERE 조건 절이 없으면 모든 행(레코드) 삭제
[WHERE]  -- 조건식은 고유한키로 주어야 좋음 loc를 주었을 때 다른 부서도 BOSTON에 있을 수 있기 때문에...

ㅇ. 문제1) dept 테이블에서 부서명(dname)에 '%' 문자를 포함하는 부서정보 출력
    ㄱ. LIKE 연산자 사용
SELECT *
FROM dept
WHERE dname LIKE '%\%%' ESCAPE '\';  --> \가 붙은 와일드 카드는 일반 문자로 인식해라 라는 뜻
                                     --> ESCAPE로 주는 기호는 아무거나 줘도 된다. 하지만, 문자열 안에 없는 기호로 사용!
                                     
    문제2) 50번 부서 삭제
DELETE FROM dept
WHERE deptno = 50;

    문제3) 30번 부서명은 SALES로 수정
UPDATE dept
SET dname = 'SALES'
SET danme = REPLACE(dname, '%', '') --> %를 없애겠다.
WHERE deptno = 30;
COMMIT; -- 커밋은 마지막에 한 번만 하자~

-- JAVA "SA%LES".replace("%", "")
- 오라클에도 REPLACE('SA%LES', '%' , '') 함수가 있다.

SELECT *, REPLACE('SA%LES', '%' , '')
에러 메시지 : ORA-00923: FROM keyword not found where expected -> * 다음 ,가 와서..

SELECT dept.*, REPLACE('SA%LES', '%' , '')
FROM dept d -- dept 테이블의 별칭을 d로 주겠다. why? 테이블 명이 길면 코딩하기 힘들기 때문에 별칭을 줌
WHERE dname LIKE '%\%%' ESCAPE '\';

    문제4) dept 테이블에서 부서명에 'r' 문자열을 포함하면 부서번호를 1증가 시키는 쿼리 작성하세요.
       
    UPDATE dept
    SET deptno = deptno + 1
    WHERE dname LIKE UPPER('%r%');
    오류메시지 : ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
    해석 :                 무결성      제약조건      FK(외래키)       위배된다.    자식 레코드행 찾았다.
                          자식 레코드행 에서 무결성 제약 조건 FK(외래키)에 위배되는 것을 찾았다.
    
    parent           deptno(참조)         child
    dept 테이블이 먼저 만들어지고 난 후에 emp 테이블 생성
    부모테이블의 deptno                자식테이블의 deptno(FK, 외래키)에서 참조
    
    관계형 데이터 모델
    개체 - 관계(연관성) - 개체
    릴레이션 또는 테이블
    부모테이블              자식테이블
    dept                  emp
    deptno 고유키(PK)      deptno 참조키, 외래키(FK)               
                          empno 고유키(PK)


15. insa테이블에서 ssn 컬럼을 통해서 year, month, date, gender 출력

SELECT ssn
       , SUBSTR(ssn, 0, 2) year
       , SUBSTR(ssn, 3, 2) MONTH
       , SUBSTR(ssn, 5, 2) "DATE" -- date는 날짜자료형 즉, 키워드(예약어)이다.
       , SUBSTR(ssn, -7, 1) GENDER
FROM insa;

16. emp 테이블에서 입사년도 컬럼에서 년,월,일 찾아서 출력
    ㄱ. 년도 찾을 때는 TO_CHAR() 함수 사용
    ㄴ. 월 찾을 때는 SUBSTR() 함수 사용
    ㄷ. 일 찾을 때는 EXTRACT() 함수 사용

SELECT hiredate
        , TO_CHAR(hiredate, 'YYYY') "YEAR"
        , SUBSTR(hiredate, 4, 2) "MONTH"
        , EXTRACT(DAY FROM hiredate) "DATE"
FROM emp
ORDER BY hiredate ASC;

<RR과 YY 기호의 차이점>
    '97/01/12'           '03/12/21'
RR  1997/01/12          2003/12/21 -> RR은 현재가 21세기 2000년대이면 이전 50년~이후49년에는 1900년을 더하고 
YY  2097/01/12          2003/12/21  -> YY는 현재 21세기 2000년대를 더해줘서 출력하는 것이고

문제) 현재 시스템의 날짜/시간 정보를 얻어오기
오라클 : SYSDATE 함수

- 2000년대 / 21세기
SELECT SYSDATE, TO_CHAR(SYSDATE, 'CC') -- CC는 세기
FROM dept;
      
23. hr 계정으로 접속
employees 테이블에서 first_name, last_name 이름 속에 'ev' 문자열 포함하는 사원 정보 출력
    
FIRST_NAME           LAST_NAME                 NAME                                           NAME                                                                                                                                                                                    
-------------------- ------------------------- ---------------------------------------------- ------------------
Kevin                Feeney                    Kevin Feeney                                   K[ev]in Feeney                                                                                                                                                                          
Steven               King                      Steven King                                    St[ev]en King                                                                                                                                                                           
Steven               Markle                    Steven Markle                                  St[ev]en Markle                                                                                                                                                                         
Kevin                Mourgos                   Kevin Mourgos                                  K[ev]in Mourgos     
                                                                                                                                                  
 
 -----------------------------------------------------------------------------------------
수업시작! - 복습 및 새로운 개념

SELECT *
FROM dept;

DESC dept;
 
문제1) 50번 부서에 아름다운 부서, 서울 추가
 
INSERT INTO dept(deptno, dname, loc) VALUES (50, '아름다운부서', '서울');
오류 보고 -
에러 메시지 : ORA-12899: value too large for column "SCOTT"."DEPT"."DNAME" (actual: 18, maximum: 14)
원인 : dname에 들어가는 값이 너무 크다. 
한글은 1문자에 3바이트라서 6글자는 18바이트

VSIZE() 함수 - 문자의 바이트를 알려주는 함수
SELECT VSIZE('아') -- 3바이트
       , VSIZE('아름다운부서') -- 18바이트
       , VSIZE('a') -- 알파벳대소문자는 1바이트
FROM dual;

문제2) dept 테이블 40,50,60,70 부서를 삭제
DELETE FROM dept WHERE deptno = 40;
DELETE FROM dept WHERE deptno = 50;
DELETE FROM dept WHERE deptno = 60;
DELETE FROM dept WHERE deptno = 70;
COMMIT;
--
DELETE FROM dept
WHERE deptno = 40 OR deptno = 50 OR deptno = 60 OR deptno = 70;
COMMIT;
--
DELETE FROM dept
WHERE deptno IN (40, 50, 60, 70);
--
DELETE FROM dept
WHERE deptno BETWEEN 40 AND 70;

-- NVL(), NVL2() 사용하는 문제
문제3) insa 테이블에서 연락처(tel)가 없는 사원은 '연락처 등록 안됨' 출력
SELECT num, name, tel
        , NVL(tel, '연락처 등록 안됨') 연락처
FROM insa
WHERE tel IS NULL;

문제4) insa 테이블에서 num, name, tel 컬럼 출력할 때 연락처(tel) 없는 사원은 X로 출력하고, 있는 사람은 O 출력
    조건) 개발부만 출력

SELECT num, name, tel, buseo
        ,NVL2(tel, 'O', 'X')
FROM insa
WHERE buseo = '개발부';

----------------------------------------------------
새로 배우는 부분~

[오라클 연산자]
[오라클 자료형]
[오라클 함수]


[오라클 연산자]
1. 비교 연산자
    1) WHERE절에서 사용! 숫자, 문자, 날짜의 크기나 순서를 비교하는 연산자 - true, false, null을 반환
    2) 종류 : > >= < <= != <> ^= =  (ANY, SOME, ALL은 서브쿼리 자세하게 배울때 다시!)
    -- SELECT 3 > 5 -- MS SQL은 오류 안나는데 오라클은 오류남 FROM절 까지 있어야 해!
    3) LOB 자료형은 비교연산자를 사용할 수 없지만, PL/SQL에서는 CLOB 자료형은 데이터를 비교할 수 있다. -> 자료형 설명할 때 다시!

2. 논리 연산자
    1) WHERE절에서 사용! true, false, null을 반환
    2) 종류 : AND OR NOT 
    
3. SQL 연산자
    1) [NOT] IN (list)
    2) [NOT] BETWEEN a AND b
    3) [NOT] LIKE
    4) IS [NOT] NULL
    5) ANY, SOME, ALL은 SQL 연산자 + 비교 연산자 -> 나중에 다시 자세히 설명
    6) EXISTS SQL 연산자  - WHERE (상관(상호연관, Correlated) 서브쿼리 값이 존재하면 true 반환) -> 나중에 다시 자세히 설명
        ex) where EXISTS (select 'x' from dept 
                         where deptno=p.deptno);
       [NOT] EXISTS == [NOT] IN -> EXISTS 조건 대신 IN 조건을 사용해서 표현할 수도 있다.

4. NULL 연산자
    1) 종류 : IS NULL, IS NOT NULL
    
5. 연결 연산자
    1) 종류 : ||    - 함수로는 CONCAT()
    
6. 산술 연산자
    1) 종류 : + - * /   ->  나머지 구하는 것은 함수 - MOD()


SELECT 5 + 3
       , 5 - 3
       , 5 * 3
       , 5 / 3
       , MOD(5, 3)
FROM dual;

SELECT 5 / 0
FROM dual;
에러 메시지 : ORA-01476: divisor is equal to zero
해석 : 0으로 나눠서 오류 발생

SELECT 5.0 / 0
FROM dual;
에러 메시지 : ORA-01476: divisor is equal to zero
해석 : 0으로 나눠서 오류 발생

SELECT MOD(5, 0) -- 5
      , MOD(5.0, 0) -- 5
FROM dual;

- 나머지 구하는 함수는 앞으로 MOD 밖에 없다고 생각하자
SELECT MOD(5,2)
       , REMAINDER(5, 2)
FROM dual;

- FLOOR() 함수와 ROUND() 함수의 차이점
-- MOD : n2 - n1 * FLOOR (n2 / n1)  -> 절삭함수
-- REMAINDER : n2 - n1 * ROUND (n2 / n1) -> 반올림함수

7. SET(집합) 연산자
    1) UNION 연산자     - 합집합
SELECT deptno, empno, ename, job
FROM emp
WHERE deptno = 20
UNION
SELECT deptno, empno, ename, job
FROM emp
WHERE job = 'MANAGER';
-- 3명 : deptno = 20
20	7369	SMITH	CLERK
20	7566	JONES	MANAGER
20	7902	FORD	ANALYST

-- 3명 : job = MANAGER
20	7566	JONES	MANAGER
30	7698	BLAKE	MANAGER
10	7782	CLARK	MANAGER

-- 위의 2개의 결과를 합친 결과(합집합)
-- 5명 : UNION 사용
10	7782	CLARK	MANAGER
20	7369	SMITH	CLERK
20	7566	JONES	MANAGER
20	7902	FORD	ANALYST
30	7698	BLAKE	MANAGER



    2) UNION ALL 연산자 - 합집합 + ALL
    3) INTERSECT 연산자 - 교집합
    4) MINUS 연산자     - 차집합

-------------------------------------------
(6. 산술연산자 다룰 때 나온 내용들...)
[***** dual 이란? *****]
1) SYS 관리자 계정이 소유하고 있는 테이블(table)이다. = 오라클 표준 테이블
2) 행(레코드) 1개, 열(컬럼) 1개인 dummy 테이블
DESC dual;
DUMMY    VARCHAR2(1)   - DUMMY 컬럼 문자1바이트

3) 일시적으로 날짜연산, 산술연산을 할 때 자주 사용
SELECT CURRENT_DATE
FROM dual;
-- 22/04/07

SELECT CURRENT_TIMESTAMP
FROM dual; -- timestamp가 더 많은 정보를 가지고 있다.
-- 22/04/07 16:16:31.337000000 ASIA/SEOUL

4) 스키마.테이블명(sys.dual) -> PUBLIC 시노님(synonym) 설정했기 때문에 테이블명만 바로 써서 사용할 수 있다.
SELECT SYSDATE, CURRENT_DATE -- 현재 시스템의 날짜 정보 : 22/04/07	22/04/07
FROM sys.dual; -- 원래는 이렇게(스키마.테이블명) 써야하는데 SYS 계정(사용자)이 모든 사용자들에게 사용할 수 있도록 이 테이블에 PUBLIC.synonym을 주었다..

5) dual 테이블은 오라클 설치하면 자동으로 만들어지는 테이블이다.

오라클 함수 : SQRT() 루트 구하는 함수
SELECT SQRT(4)
FROM dual;

-------------------------------------------
[시노님(synonym) 이란?]
1. HR 접속, SYS 접속해서 아래 코딩...
SELECT *
FROM emp;

- HR은 emp 테이블 사용할 수 있는 권한을 부여 받고 scott이나 sys한테 부여받으면 된다. 궁극적으로 소유자인 scott한테 받는게 좋다.
- 스키마.테이블명(scott.emp)로 코딩해야 사용할 수 있다.

1) 객체를 조회할 때 마다 2)번 처럼 코딩하는 것은 번거로운 일이다. 그래서 시노님(synonym)이 나왔다~

2) '시노님은 하나의 객체에 대해 다른 이름을 정의하는 방법'
    -> 스키마.테이블명 이것을 다른 이름으로 간단하게 지정하는 것이 시노님

3) 시노님은 DB 전체에서 사용할 수 있는 객체

4) 시노님의 종류
- PRIVATE 시노님 - 소유자만 접근
- PUBLIC 시노님 - 모든 사용자가 접근

5) 시노님의 생성
    [형식]
    - PUBLIC을 생략하면 PRIVATE 시노님이 됨
	CREATE [PUBLIC] SYNONYM [schema.]synonym명
  	FOR [schema.]object명;
    
- PUBLIC 시노님은 모든 사용자가 접근 가능하기 때문에 생성 및 삭제는 오직 DBA만이 할 수 있다.

- PUBLIC 시노님의 생성 순서
(1) SYSTEM / SYS 권한으로 접속한다. - SYS 접속
(2) PUBLIC 옵션을 사용하여 시노님을 생성한다. - SYS 접속
(3) 생성된 시노님에 대해 객체 소유자로 접속한다. - SCOTT 접속(소유자)
(4) 시노님에 권한을 부여한다. - SCOTT 접속(소유자)

GRANT SELECT ON emp TO HR; -- emp 테이블을 HR 계정이 SELECT 할 수 있도록 권한 부여
-- Grant을(를) 성공했습니다.

6) 시노님 삭제는 DBA만 가능 -> SYS 계정 접속

--------------------------------------------------------------------------------










