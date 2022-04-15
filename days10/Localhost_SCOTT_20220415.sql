-- [ SCOTT에 접속된 스크립트 파일 ]
---- 복습문제 ----

1. 오라클 각 DataType 에 대해 상세히 설명하세요
days09 자료 참고

2.  emp 테이블에서 [년도별] [월별] 입사사원수 출력.( PIVOT() 함수 사용 )

    [실행결과]
    1982	1	0	0	0	0	0	0	0	0	0	0	0
    1980	0	0	0	0	0	0	0	0	0	0	0	1
    1981	0	2	0	1	1	1	0	0	2	0	1	2

SELECT *    
FROM (SELECT TO_CHAR(hiredate, 'YYYY') 입사년도, TO_CHAR(hiredate, 'FMMM') 입사월 FROM emp )
PIVOT(COUNT(*) FOR 입사월 IN(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12));
    
2-2.   emp 테이블에서 각 JOB별 입사년도별 1월~ 12월 입사인원수 출력.  ( PIVOT() 함수 사용 ) 
    [실행결과]
    ANALYST		1981	0	0	0	0	0	0	0	0	0	0	0	1
    CLERK		1980	0	0	0	0	0	0	0	0	0	0	0	1
    CLERK		1981	0	0	0	0	0	0	0	0	0	0	0	1
    CLERK		1982	1	0	0	0	0	0	0	0	0	0	0	0
    MANAGER		1981	0	0	0	1	1	1	0	0	0	0	0	0
    PRESIDENT	1981	0	0	0	0	0	0	0	0	0	0	1	0
    SALESMAN	1981	0	2	0	0	0	0	0	0       

SELECT *
FROM (SELECT job, TO_CHAR(hiredate, 'YYYY') 입사년도, TO_CHAR(hiredate, 'FMMM') 입사월 FROM emp )
PIVOT(COUNT(*) FOR 입사월 IN(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12))
ORDER BY job;


3. emp테이블에서 입사일자가 오래된 순으로 3명 출력 ( TOP 3 )
    [실행결과]
    1	7369	SMITH	CLERK	    7902	80/12/17	800		    20
    2	7499	ALLEN	SALESMAN	7698	81/02/20	1600	300	30
    3	7521	WARD	SALESMAN	7698	81/02/22	1250	500	30    

풀이1) RANK()
SELECT *
FROM(
    SELECT RANK() OVER(ORDER BY hiredate) rn
    , emp.* 
    FROM emp
) t
WHERE rn <= 3;

풀이2) TOP-N

SELECT ROWNUM, t.*
FROM(
    SELECT *
    FROM emp
    ORDER BY hiredate
) t
WHERE ROWNUM <= 3;


4. SMS 인증번호  임의의  6자리 숫자 출력 ( dbms_random  패키지 사용 )
SELECT ROUND(dbms_random.value(0, 1000000))
    , SUBSTR(LTRIM(LTRIM(dbms_random.value, '0.'), '0'), 0, 6)
    , TRUNC(dbms_random.value(100000, 1000000))
FROM dual;

4-2. 임의의 대소문자 5글자 출력( dbms_random  패키지 사용 )
SELECT dbms_random.string('A', 5)
FROM dual;

5. 게시글을 저장하는 테이블 생성
   ㄱ.   테이블명 : tbl_test
   ㄴ.   컬럼                   자료형  크기    널허용여부    고유키
         글번호    seq          NUMBER        NOT NULL     PRIMARY KEY
         작성자    writer       VARCHAR2(20)    NOT NULL   
         비밀번호 passwd        VARCHAR2(15)    NOT NULL
         글제목    title         VARCHAR2(20) NOT NULL
         글내용    content        VARCHAR2 
         작성일    regdate     DATE
    ㄷ.  글번호, 작성자, 비밀번호, 글 제목은 필수 입력 사항으로 지정
    ㄹ.  글번호가  기본키( PK )로 지정
    ㅁ.  작성일은 현재 시스템의 날짜로 자동 설정


CREATE TABLE tbl_test(
    -- seq NUMBER NOT NULL [CONSTRAINTS PK제약조건이름] PRIMARY KEY
     seq NUMBER NOT NULL CONSTRAINTS PK_tbltest_seq PRIMARY KEY
    , writer VARCHAR2(20) NOT NULL
    , passwd VARCHAR2(20) NOT NULL
    , title VARCHAR2(100) NOT NULL
    , content LONG
    , regdate DATE DEFAULT SYSDATE
);
-- Table TBL_TEST이(가) 생성되었습니다.

5-2. 조회수    read   컬럼을 추가 ( 기본값 0 으로  설정 ) 
ALTER TABLE tbl_test
ADD read NUMBER DEFAULT 0;
-- Table TBL_TEST이(가) 변경되었습니다.

5-3. 글내용    content 컬럼의 자료형을 clob 로 수정 
ALTER TABLE tbl_test
MODIFY(content CLOB);
-- Table TBL_TEST이(가) 변경되었습니다.

5-4. 테이블 구조 확인
DESC tbl_test;

이름      널?       유형            
------- -------- ------------- 
SEQ     NOT NULL NUMBER        
WRITER  NOT NULL VARCHAR2(20)  
PASSWD  NOT NULL VARCHAR2(20)  
TITLE   NOT NULL VARCHAR2(100) 
CONTENT          CLOB          
REGDATE          DATE          
READ             NUMBER    

5-5. 글제목     title 을   subject로 수정 
굳이 바꾸지 않아도 별칭 사용 가능!
SELECT title subject
FROM tbl_test;

ALTER TABLE tbl_test
RENAME COLUMN title TO subject;
-- Table TBL_TEST이(가) 변경되었습니다.

5-6.  tbl_test  -> tbl_board 테이블명 변경 
RENAME tbl_test TO tbl_board;
-- 테이블 이름이 변경되었습니다.

이름      널?       유형            
------- -------- ------------- 
SEQ     NOT NULL NUMBER        
WRITER  NOT NULL VARCHAR2(20)  
PASSWD  NOT NULL VARCHAR2(20)  
SUBJECT NOT NULL VARCHAR2(100) 
CONTENT          CLOB          
REGDATE          DATE          
READ             NUMBER  

5-7. CRUD  ( insert, select, update, delete ) 
   ㄱ. 임의의 게시글 5개를 추가 insert
   INSERT INTO tbl_board (seq, writer, passwd, subject, content, regdate, read)
                VALUES(1, 'admin', '1234', 'test 1', 'test 1', SYSDATE, 0);
   
   -- regdate, read 컬럼 생략 - DEFAULT 설정 되어 있어서             
   INSERT INTO tbl_board (seq, writer, passwd, subject, content)
                VALUES(2, '홍길동', '1234', '홍길동 1', '홍길동 1');             
   
   -- 글내용(content) 필수입력사항 X             
   INSERT INTO tbl_board (seq, writer, passwd, subject)
                VALUES(3, '익순이', '1234', '홍길동 1'); 
                
   COMMIT;
   
   ㄴ. 게시글 조회 select
   SELECT *
   FROM tbl_board;
   
   ㄷ. 3번 게시글의 글 제목, 내용 수정 update
   -- 게시글 삭제, 수정할 때는 검색 후에 게시글을 삭제하거나 수정한다.
   1) 검색작업
   SELECT seq, subject, content
   FROM tbl_board
   WHERE seq = 3;
   
   2) 내용수정
   UPDATE tbl_board
   SET subject = '[e]'|| subject , content = '[e]' || NVL(content, '아무내용')
   WHERE seq = 3;
   
   3) 변경내용 확인
   SELECT *
   FROM tbl_board;
   
   4) 커밋
   COMMIT;
   
   ㄹ. 4번 게시글 삭제 delete
   DELETE tbl_board
   WHERE seq = 4;
   -- 0개 행 이(가) 삭제되었습니다.
   4번째 게시글이 없기 때문에 위와 같은 메시지가 나옴 즉, 검색하는 작업을 먼저해야된다!
   
5-8. tbl_board 테이블 삭제  
DROP TABLE tbl_board PURGE;
-- PUGE 옵션 테이블을 휴지통에 넣는 것이 아니라 완전히 삭제해서 복구시키지 못하도록 하겠다.


6-1. 오늘의 날짜와 요일 출력 
 [실행결과]
오늘날짜  숫자요일  한자리요일       요일
-------- ---        ------   ------------
22/04/15  6             금      금요일      

SELECT SYSDATE 오늘날짜
    , TO_CHAR(SYSDATE, 'D') 숫자요일
    , TO_CHAR(SYSDATE, 'DY') 한자리요일
    , TO_CHAR(SYSDATE, 'DAY') 요일
FROM dual;

6-2. 이번 달의 마지막 날과 날짜만 출력 
 [실행결과]
오늘날짜  이번달마지막날짜                  마지막날짜(일)
-------- -------- -- ---------------------------------
22/04/15 22/04/30 30                                30

SELECT SYSDATE 오늘날짜
    , LAST_DAY(SYSDATE) 이번달마지막날짜
    , TO_CHAR(LAST_DAY(SYSDATE), 'DD')
FROM dual;


6-3.
 [실행결과]
오늘날짜    월의주차 년의주차 년의 주차
--------    -       --      --
22/04/15    3       15      15

SELECT SYSDATE
    , TO_CHAR(SYSDATE, 'W')
    , TO_CHAR(SYSDATE, 'IW')
    , TO_CHAR(SYSDATE, 'WW')
FROM dual;

------------------------------------------
!!새로운 개념~!!

1. [년 주차]
 - "WW"와 "IW" 모두 1년의 몇 주차(1~53)로 조회하는 포맷 이다.
 - "WW" :  1일 ~ 7일을 1주차로 시작 -> 즉, 해당년도의 1일~7일이 1주차 7일차씩 끊어서 계산되는 것
 - "IW" : 월 ~ 일요일 기준(실제 달력에 맞게 주차가 계산)

1/2/3   4
IW 13   14
WW 13  2일부터 14
SELECT TO_CHAR(TO_DATE('2022.4.4'), 'IW')
    ,TO_CHAR(TO_DATE('2022.4.4'), 'WW')
FROM dual;

-----------------------------------------------------
2. [CREATE TABLE 문에 의한 테이블 생성]
    ? *** 테이블을 만드는 가장 단순하면서도 일반적인 명령 형식으로 만드는 방법  -> 우리가 계속 사용했던 방법
    
    ? Extend table 생성 -> 사용할일 없을듯~
        【형식】
        CREATE TABLE table
        ( 컬럼1  	데이터타입,
          컬럼2  	데이터타입,...)
        STORAGE    (INITIAL  	크기
                NEXT	크기
                MINEXTENTS	크기
                MAXEXTENTS	크기
                PCTINCREASE	n);

        캐싱 테이블은 빈번하게 사용되는 테이블 데이터를 데이터버퍼 캐시영역에 상주시켜 
        검색시 성능을 향상시킴.
        
    ? *** Subquery를 이용한 table 생성 -> 오늘 배울 방법!
    
    ? External table 생성 -> 사용할일 없을듯~
     - external 테이블은 DB 외부에 저장된 data source를 조작하기 위한 접근 방법의 하나로 읽기 전용 테이블이다.

    ? NESTED TABLE 생성 -> 사용할일 없을듯~
    테이블의 어느 컬럼이 하나의 데이터만 넣는 것이 아니라 그 컬럼은 여러 개의 속성을 가진 데이터를 넣을 수 있는 형식의 데이터타입이다.
    즉, 테이블 속의 어느 컬럼이 또 다른 테이블 형식을 가진다.
    
    ? Partitioned Tables & Indexes 생성 

-----
[Subquery를 이용한 table 생성]
--  기존 테이블에 원하는 데이터가 이미 존재할 경우 subquery를 이용하여 테이블을 생성한다면
-- 테이블 생성과 데이터 입력을 동시에 할 수 있다.

1) 이미 존재하는 테이블이 있고
2) SELECT ~ 서브쿼리를 이용해서
3) 새로운 테이블을 생성 + 데이터 추가(INSERT) 할 수 있다.

4)【형식】
	CREATE TABLE 테이블명 [컬럼명 (,컬럼명),...] -- 컬럼명을 명시해주면 컬럼명을 바꿀 수 있다.
	AS subquery;
    
    ? 다른 테이블에 존재하는 특정 컬럼과 행을 이용한 테이블을 생성하고 싶을 때 사용
    ? Subquery의 결과값으로 table이 생성됨
    ? 컬럼명을 명시할 경우 subquery의 컬럼수와 테이블의 컬럼수를 같게해야 한다.
        -> 컬럼명을 명시해주면 컬럼명을 바꿀 수 있다. 단, 갯수가 같아야한다.
    ? 컬럼을 명시하지 않을 경우, 컬럼명은 subquery의 컬럼명과 같게 된다.
        -> [컬럼명 (,컬럼명),...] 명시하지 않으면 똑같이 가져간다.
    ? subquery를 이용해 테이블을 생성할 때 CREATE TABLE 테이블명 뒤에 컬럼명을 명시해 주는 것이 좋다.
    
5) 예)
    ㄱ. emp 테이블에서 10번 부서원들만 검색 -> empno, ename, hiredate, sal + NVL(comm, 0) pay 이런 데이터만 가지는
        새로운 테이블을 생성
        
    CREATE TABLE tbl_emp10 -- (no, name, ibsadate, pay) 
    AS (
        SELECT empno, ename, hiredate, sal + NVL(comm, 0) pay
        FROM emp
        WHERE deptno = 10
    );
    -- Table TBL_EMP10이(가) 생성되었습니다.
    
6) 테이블의 구조확인
    DESC tbl_emp10;
    
    이름       널? 유형           
    -------- -- ------------ 
    EMPNO       NUMBER(4)       emp 테이블의 자료형
    ENAME       VARCHAR2(10)    emp 테이블의 자료형
    HIREDATE    DATE            emp 테이블의 자료형
    PAY         NUMBER          시스템이 자동으로 자료형 설정

7) 원래 테이블은 그대로 두고, 테이블을 복사해서 사용하고 싶을 때
    즉, 원본은 두고 복사해서 사용
    CREATE TABLE tbl_empcopy
    AS( SELECT * FROM emp );
    -- Table TBL_EMPCOPY이(가) 생성되었습니다.
    -- emp 테이블의 구조 + 12명의 사원(데이터) 그대로 복사 -> 새로운 테이블 생성
    
    DESC tbl_empcopy;
    
    SELECT *
    FROM tbl_empcopy;
    
8) 제약조건은 복사되지 않는다. (NOT NULL 제약조건은 예외! 복사된다)
    ㄱ. emp 제약조건 확인
    SELECT *
    FROM user_constraints -- 제약조건 확인
    WHERE table_name = UPPER('emp');
    
    OWNER   CONSTRAINT_NAME   CONSTRAINT_TYPE  
    소유자     제약조건이름      제약조건타입
    SCOTT	PK_EMP	            P           -> PK
    SCOTT	FK_DEPTNO	        R           -> FK
    
    ㄴ. 복사한 tbl_empcopy 제약조건 확인 -- 제약조건은 아무것도 복사가 되지 안았음
    SELECT *
    FROM user_constraints -- 제약조건 확인
    WHERE table_name = UPPER('tbl_empcopy');

9) 테이블 삭제
    DROP TABLE tbl_emp10 PURGE;
    DROP TABLE tbl_empcopy PURGE;
    
    COMMIT;
    
10) 문제 - 테이블은 기존테이블 서브쿼리를 사용해서 생성 + 데이터는 추가 X

풀이1)
    ㄱ. 테이블 복사
    CREATE TABLE tbl_empcopy
    AS (
        SELECT *
        FROM emp
    );
    
    ㄴ. 확인
    SELECT *
    FROM tbl_empcopy;
    
    ㄷ. 데이터 삭제
    DELETE FROM tbl_empcopy; -- WHERE 조건을 안주면 구조는 두고 데이터만 삭제함
    
    ㄹ. 커밋
    COMMIT;
    
    ㅁ. 확인
    SELECT *
    FROM tbl_empcopy;

풀이2) *** 거짓 조건을 줘서 구조만 복사하기
    CREATE TABLE tbl_empcopy
    AS (
        SELECT *
        FROM emp
        WHERE 1 = 0 -- 거짓 조건을 준다.
    );
    
    SELECT *
    FROM tbl_empcopy;

-------------------------------------------------------------------------------------
3. [DML 사용하기]

1) tbl_member 테이블 있는지 확인
    SELECT *
    FROM user_tables
    WHERE REGEXP_LIKE (table_name, 'member', 'i');
    
2) tbl_member 삭제 및 확인
    DROP TABLE tbl_member;
    COMMIT;
    
3) 테이블 생성
rrn 주민등록번호를 컬럼(속성)으로 추가하면 나이, 생일, 성별을 추출할 수 있음 -> 나이, 생일, 성별은 추출 속성이라고 한다.
그래서 아래와 같이 컬럼을 넣는게 아니라 rrn으로 넣는 것이 좋다! 모델링 배울 때 다시 설명~
    
    -- PRIMARY KEY를 회수해서 다른 컬럼으로 바꿔버리면 NOT NULL 제약조건을 안주면 사라지기 때문에 NOT NULL을 넣어주는게 좋음
    CREATE TABLE tbl_member(
        id VARCHAR2(10) NOT NULL CONSTRAINTS PK_TBLMEMBER_ID PRIMARY KEY -- 회원ID / 고유키(PK) == UK(유일성) + NN(NOT NULL) 포함
        , name VARCHAR2(20) NOT NULL-- 회원이름
        , age NUMBER(3) -- 회원나이
        , birth DATE -- 회원생일
        , regdate DATE DEFAULT SYSDATE -- 회원가입일
        , point NUMBER DEFAULT 100 -- 회원포인트        
    );
    -- Table TBL_MEMBER이(가) 생성되었습니다.
    
4) 제약조건 확인
    SELECT *
    FROM user_constraints
    WHERE table_name = UPPER('tbl_member');
    제약조건      타입
    PK           P
    NN           C
    FK           R
    -- 제약조건 명을 지정하지 않으면 자동으로 SYS_~~~ 설정
    -- ex) SYS_C007078

5) 멤버 추가
INSERT INTO tbl_member (id, name, age, birth, regdate, point)
            VALUES('admin', '관리자', 32, TO_DATE('03/04/1991', 'MM/DD/YYYY'), SYSDATE, 100);
-- ORA-01830: date format picture ends before converting entire input string
-- 날짜 형식 안맞아서 발생.. TO_DATE로 날짜 형식 바꿔주기

INSERT INTO tbl_member (id, name, age, birth, regdate, point)
            VALUES('admin', '홍길동', 22, '2001.01.01', SYSDATE, 100);
-- ORA-00001: unique constraint (SCOTT.PK_TBLMEMBER_ID) violated
-- PK 제약조건을 주면 UK(유일성) + NN(NOT NULL) 포함

INSERT INTO tbl_member -- (id, name, age, birth, regdate, point) -> 순서대로 입력할 것이라 컬럼명 생략 가능
            VALUES('hong', '홍길동', 22, '2001.01.01', SYSDATE, 100);

INSERT INTO tbl_member VALUES('park', '박지성', 25, '1998.5.9');
-- SQL 오류: ORA-00947: not enough values
-- VALUES 값이 충분하지 않음 -> 컬럼명을 넣어줘야 가능

INSERT INTO tbl_member (id, name, age, birth) VALUES('park', '박지성', 25, '1998.5.9');

INSERT INTO tbl_member (name, birth, id, age) VALUES('야리니', null, 'yaliny', 25);
-- 컬럼명은 꼭 순서대로 주지 않아도 된다. 입력하는 값과 순서가 동일하면 됨
-- NULL을 허용하는 컬럼은 NULL로 데이터를 주어도 된다.

COMMIT; 

SELECT *
FROM tbl_member;

-----------
4. [서브쿼리를 사용해서 INSERT 할 수 있다.]
[형식]
    INSERT INTO 테이블명 (서브쿼리);

예제)
1) tbl_emp10 테이블 유무 확인후 있다면 테이블 삭제
2) emp 테이블을 구조 복사, 데이터 복사 X -> tbl_emp10 테이블 생성 

    CREATE TABLE tbl_emp10 -- 컬럼명...
    AS(
        SELECT *
        FROM emp
        WHERE 1 = 0
    );
-- Table TBL_EMP10이(가) 생성되었습니다.

    SELECT *
    FROM tbl_emp10;

3) emp 테이블의 10번부서원들을 SELECT해서 tbl_emp10 테이블에 추가
    INSERT INTO tbl_emp10(SELECT * FROM emp WHERE deptno = 10);
    -- 3개 행 이(가) 삽입되었습니다.
    COMMIT;
    
    DROP TABLE tbl_emp10 PURGE;

--------------------
5. [MULTITABLE INSERT 문]
- 하나의 insert 문으로 여러 개의 테이블에 동시에 하나의 행을 입력하는 것이다.
- 4가지 종류
- conditional / unconditional : 조건의 유무
- all / first : 전부 / 첫번째한테만
- pivoting : 피벗
    ㄱ. unconditional insert all
    ㄴ. conditional insert all
    ㄷ. conditional first insert
    ㄹ. pivoting insert 

1) ㄱ. unconditional insert all
- 조건과 상관없이 여러 개의 테이블에 데이터를 입력한다.
? 서브쿼리로부터 한번에 하나의 행을 반환받아 각각 insert 절을 수행한다.
? into 절과 values 절에 기술한 컬럼의 개수와 데이터 타입은 동일해야 한다.

【형식】
	INSERT ALL | FIRST
	  [INTO 테이블1 VALUES (컬럼1,컬럼2,...)]
	  [INTO 테이블2 VALUES (컬럼1,컬럼2,...)]
	  .......
	서브쿼리;

---
    <생성>
    CREATE TABLE dept_10 AS SELECT * FROM dept WHERE 1=0;
    CREATE TABLE dept_20 AS SELECT * FROM dept WHERE 1=0;
    CREATE TABLE dept_30 AS SELECT * FROM dept WHERE 1=0;
    CREATE TABLE dept_40 AS SELECT * FROM dept WHERE 1=0;
    
    <확인>
    SELECT * FROM dept_10;
    SELECT * FROM dept_20;
    SELECT * FROM dept_30;
    SELECT * FROM dept_40;
    
    INSERT ALL
            INTO dept_10 VALUES(deptno, dname, loc)
            INTO dept_20 VALUES(deptno, dname, loc)
            INTO dept_30 VALUES(deptno, dname, loc)
            INTO dept_40 VALUES(deptno, dname, loc)
    SELECT deptno, dname, loc
    FROM dept; 
    -- 16개 행 이(가) 삽입되었습니다.
        
    ROLLBACK;

DROP TABLE dept_10;
DROP TABLE dept_20;
DROP TABLE dept_30;
DROP TABLE dept_40;
COMMIT;
---------------
2) ㄴ. conditional insert all
특정 조건들을 기술하여 그 조건에 맞는 행들을 원하는 테이블에 나누어 삽입한다.
서브쿼리로부터 한번에 하나의 행을 반환받아 when ... then 절에서 조건을 체크한 후
조건에 맞는 절에 기술된 테이블에 insert 절을 수행한다.

【형식】
	INSERT ALL
	WHEN 조건절1 THEN
	  INTO [테이블1] VALUES (컬럼1,컬럼2,...)
	WHEN 조건절2 THEN
	  INTO [테이블2] VALUES (컬럼1,컬럼2,...)
	........
	ELSE
	  INTO [테이블3] VALUES (컬럼1,컬럼2,...)
	Subquery;
    
? subquery로부터 한번에 하나씩 행을 리턴받아 WHEN...THEN절에서 체크한 후,
    조건에 맞는 절에 기술된 테이블에 insert 절을 수행한다.
? VALUES 절에 지정한 DEFAULT 값을 사용할 수 있다. 만약 default값이 지정되어 있지 않다면, NULL 값이 삽입된다.

문제) emp_10, emp_20, emp_30, emp_40 테이블 생성
    emp 사원테이블 -> 10 부서원 -> 10_emp INSERT
    emp 사원테이블 -> 20 부서원 -> 20_emp INSERT
    emp 사원테이블 -> 30 부서원 -> 30_emp INSERT
    emp 사원테이블 -> 40 부서원 -> 40_emp INSERT
    
위의 작업을 한 번에 다 처리하겠다.

    1) emp 테이블의 구조만 복사해서 테이블 4개 생성
    CREATE TABLE emp_10 AS SELECT * FROM emp WHERE 1=0;
    CREATE TABLE emp_20 AS SELECT * FROM emp WHERE 1=0;
    CREATE TABLE emp_30 AS SELECT * FROM emp WHERE 1=0;
    CREATE TABLE emp_40 AS SELECT * FROM emp WHERE 1=0;

    2) conditional insert all 사용하여 데이터 추가하기
    INSERT ALL
     WHEN deptno = 10 THEN
        INTO emp_10 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
     WHEN deptno = 20 THEN
        INTO emp_20 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
     WHEN deptno = 30 THEN
        INTO emp_30 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
     ELSE
        INTO emp_40 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    SELECT * FROM emp;
    
    3) 확인
    SELECT * FROM emp_10;
    SELECT * FROM emp_20;
    SELECT * FROM emp_30;
    SELECT * FROM emp_40;    

    3) 레코드 삭제
+ 레코드 삭제 방법 2가지(DML의 DELETE와 TRUNCATE)
-- emp_10 레코드 모두 삭제
    DELETE FROM emp_10; -- WHERE 조건이 없으면 그 안에 데이터를 모두 삭제
    ROLLBACK;
    
    TRUNCATE TABLE emp_10; -- 모든 레코드 삭제 + 자동 COMMIT / 단, 롤백 할 수 없음
    TRUNCATE TABLE emp_20;
    TRUNCATE TABLE emp_30;
    TRUNCATE TABLE emp_40;
    
-------------
3) ㄷ. conditional first insert 
특정 조건들을 기술하여 그 조건에 맞는 행(row)들을 원하는 테이블에 나누어 삽입하고자 할 때 사용하지만,
conditional insert all 문과 달리 첫 번째 when 절에서 조건을 만족할 경우 다음의 when 절은 수행하지 않는다.

서브쿼리로부터 한번에 하나의 행을 반환받아 when ... then 절에서 조건을 체크한 후
조건에 맞는 절에 기술된 테이블에 insert 절을 수행한다.

여러 개의 when ... then 절을 사용하여 여러 조건을 사용할 수 있다.
단, 첫 번째 when 절에서 조건을 만족하면 into 절을 수행한 후 다음의 when 절은 수행하지 않는다. 

【형식】
    INSERT FIRST
    WHEN 조건절1 THEN
      INTO [테이블1] VALUES (컬럼1,컬럼2,...)
    WHEN 조건절2 THEN
      INTO [테이블2] VALUES (컬럼1,컬럼2,...)
    ........
    ELSE
      INTO [테이블3] VALUES (컬럼1,컬럼2,...)
    Subquery;

? conditional INSERT FIRST는 조건절을 기술하여 조건에 맞는 값들을 원하는 테이블에 삽입할 수 있다.
? 여러 개의 WHEN...THEN절을 사용하여 여러 조건 사용이 가능하다. 단, 첫 번째 WHEN 절에서 조건을 만족한다면, INTO 절을 수행한 후 다음의 WHEN 절들은 더 이상 수행하지 않는다.
? subquery로부터 한 번에 하나씩 행을 리턴 받아 when...then절에서 조건을 체크한 후 조건에 맞는 절에 기술된 테이블에 insert를 수행한다.
? 조건을 기술한 when 절들을 만족하는 행이 없을 경우 else절을 사용하여 into 절을 수행할 수 있다. else절이 없을 경우 리턴된 그행에 대해서는 아무런 작업도 발생하지 않는다.

SELECT *
FROM emp
WHERE deptno = 10;
<결과>
7782	CLARK	MANAGER	7839	81/06/09	2450		10
7839	KING	PRESIDENT		81/11/17	5000		10
[7934	MILLER	CLERK	7782	82/01/23	1300		10]

SELECT *
FROM emp
WHERE job = 'CLERK';
<결과>
7369	SMITH	CLERK	7902	80/12/17	800		20
7900	JAMES	CLERK	7698	81/12/03	950		30
[7934	MILLER	CLERK	7782	82/01/23	1300	10]

-- MILLER는 부서 10 AND job CLERK

WHEN 조건절 만족하면 THEN을 실행시키고 아래에 있는 쿼리는 실행 X
MILLER는 부서번호와 job 조건이 모두 동일하지만, emp_10에 들어가고 emp_20에는 들어가지 않음
    
    1) 데이터 추가
    INSERT FIRST
        WHEN deptno = 10 THEN
            INTO emp_10 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
        WHEN job = 'CLERK' THEN
            INTO emp_20 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
        ELSE
            INTO emp_40 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    SELECT * FROM emp;

    2) 확인
    SELECT * FROM emp_10;
    SELECT * FROM emp_20;
    SELECT * FROM emp_30;
    SELECT * FROM emp_40;

    3) 테이블 삭제
    DROP TABLE emp_10 PURGE;
    DROP TABLE emp_20 PURGE;
    DROP TABLE emp_30 PURGE;
    DROP TABLE emp_40 PURGE;

-----------------------
4) ㄹ. pivoting insert
- 여러 개의 into 절을 사용할 수 있지만, into 절 뒤에 오는 테이블은 모두 동일해야 한다. 
【형식】
    INSERT ALL
    WHEN 조건절1 THEN
      INTO [테이블1] VALUES (컬럼1,컬럼2,...)
      INTO [테이블1] VALUES (컬럼1,컬럼2,...)
      ..........
    Subquery;

? 여러 개의 INTO 절을 사용할 수 있지만, INTO 절 뒤에 오는 테이블은 모두 동일하여야 한다.
? 주로 여러 곳의 시스템으로부터 데이터를 받아 작업하는 dataware house에 적합하다. 정규화 되지 않은 data source들이나 다른 format으로 저장된 data source들을 Oracle의 관계형 DB에서 사용하기에 적합한 형태로 변환한다.
? 정규화 되지 않은 데이터를 oracle이 제공하는 relational한 형태로 테이블을 변경하는 작업을 pivoting이라고 한다.

    1) 테이블 생성
    CREATE TABLE tbl_sales(
        employee_id       NUMBER(6),
        week_id            NUMBER(2),
        sales_mon          NUMBER(8, 2),
        sales_tue          NUMBER(8, 2),
        sales_wed          NUMBER(8, 2),
        sales_thu          NUMBER(8, 2),
        sales_fri          NUMBER(8, 2)
    );
    -- Table TBL_SALES이(가) 생성되었습니다.
    
    2) 데이터 추가
    INSERT INTO tbl_sales VALUES(1101,4,100,150,80,60,120);
    INSERT INTO tbl_sales VALUES(1102,5,300,300,230,120,150);
    COMMIT;
    
    3) 확인
    SELECT *
    FROM tbl_sales;
    
    EMPLOYEE_ID    WEEK_ID  SALES_MON  SALES_TUE  SALES_WED  SALES_THU  SALES_FRI
    ----------- ---------- ---------- ---------- ---------- ---------- ----------
       1101          4        100        150         80         60        120
       1102          5        300        300        230        120        150

    
    4) 또 다른 테이블 생성
    CREATE TABLE tbl_sales_data(
    employee_id        NUMBER(6),
    week_id            NUMBER(2),
    sales              NUMBER(8, 2)
    );
    -- Table TBL_SALES_DATA이(가) 생성되었습니다.

    5) 아래와 같은 형식으로 데이터 추가 -> 피벗
    
    EMPLOYEE_ID    WEEK_ID      SALES
    ----------- ---------- ----------
       1101          4        100
       1102          5        300
       1101          4        150
       1102          5        300
       1101          4         80
       1102          5        230
       1101          4         60
       1102          5        120
       1101          4        120
       1102          5        150
    
     -- EMPLOYEE_ID    WEEK_ID  SALES_MON  SALES_TUE  SALES_WED  SALES_THU  SALES_FRI
     -- 1101          4        100        150         80         60        120
    INSERT ALL
      INTO tbl_sales_data VALUES(employee_id, week_id, sales_mon) -- 월
      INTO tbl_sales_data VALUES(employee_id, week_id, sales_tue) -- 화
      INTO tbl_sales_data VALUES(employee_id, week_id, sales_wed) -- 수
      INTO tbl_sales_data VALUES(employee_id, week_id, sales_thu) -- 목
      INTO tbl_sales_data VALUES(employee_id, week_id, sales_fri) -- 금
    SELECT employee_id, week_id, sales_mon, sales_tue, sales_wed, sales_thu, sales_fri
    FROM tbl_sales;

    확인)
    SELECT *
    FROM tbl_sales_data;

-----
문제1) insa 테이블의 num, name 컬럼만 복사해서 tbl_score 테이블 생성
    이미 존재하는 테이블을 사용해서 새로운 테이블을 생성
    조건1) num <= 1005 자료(레코드)만 복사
    
    CREATE TABLE tbl_score
    AS(
        SELECT num, name
        FROM insa
        WHERE num <= 1005
    );
    
    SELECT *
    FROM tbl_score;
    
--    
문제2) tbl_score 테이블에 kor, eng, mat, tot, avg, grade, rank 컬럼 추가
                        k,e,m은 기본값 0, grade 한문자
    ALTER TABLE tbl_score
    ADD(kor NUMBER(3) DEFAULT 0
        , eng NUMBER(3) DEFAULT 0
        , mat NUMBER(3) DEFAULT 0
        , tot NUMBER(3)
        , avg NUMBER(5, 2)
        , grade CHAR(1 char)
        , rank NUMBER(3)
    ); 
    -- Table TBL_SCORE이(가) 변경되었습니다
    
    DESC tbl_score;

이름    널?       유형           
----- -------- ------------ 
NUM   NOT NULL NUMBER(5)    
NAME  NOT NULL VARCHAR2(20) 
KOR            NUMBER(3)    
ENG            NUMBER(3)    
MAT            NUMBER(3)    
TOT            NUMBER(3)    
AVG            NUMBER(5,2)  
GRADE          CHAR(1 CHAR) 
RANK           NUMBER(3) 

--
문제3) 1001 ~ 1005, num, name 
    kor, eng, mat 점수를 임의의 점수(0~100)를 발생시켜서 수정

    UPDATE tbl_score
    SET kor = TRUNC(dbms_random.value(0, 101))
        , eng = TRUNC(dbms_random.value(0, 101))
        , mat = TRUNC(dbms_random.value(0, 101));
        
    COMMIT;

--
문제4) tbl_score 테이블에 tot, avg 계산해서 수정
    UPDATE tbl_score
    SET tot = kor + eng + mat
        , avg = (kor + eng + mat) / 3;
    
    COMMIT;

--
문제5) 아래와 같이 grade 수정하기
평균이 90 이상 A
        80  B
        70  C
        60  D
            F

내가 작성한 쿼리)
    UPDATE tbl_score
    SET grade = 'A'
    WHERE avg BETWEEN 90 AND 100;
    
    UPDATE tbl_score
    SET grade = 'B'
    WHERE avg BETWEEN 80 AND 89;
    
    UPDATE tbl_score
    SET grade = 'C'
    WHERE avg BETWEEN 70 AND 79;
    
    UPDATE tbl_score
    SET grade = 'D'
    WHERE avg BETWEEN 60 AND 69;
    
    UPDATE tbl_score
    SET grade = 'F'
    WHERE avg BETWEEN 0 AND 59;

--
다른 사람 쿼리)
    UPDATE tbl_score
    SET grade = CASE
                    WHEN avg BETWEEN 90 AND 100 THEN 'A' -- avg >= 90 이렇게 줘도 됨
                    WHEN avg BETWEEN 80 AND 89 THEN 'B' -- avg >= 80
                    WHEN avg BETWEEN 70 AND 79 THEN 'C' -- avg >= 70
                    WHEN avg BETWEEN 60 AND 69 THEN 'D' -- avg >= 60
                    ELSE 'F'
                END;
            
--
강사님 풀이)
    UPDATE tbl_score
    SET grade - DECODE(TRUNC(avg/10), 10, 'A', 9, 'A', 8, 'B', 7, 'C', 6, 'D', 'F');
    
    SELECT *
    FROM tbl_score;
    
    COMMIT;

---
문제6) rank 처리하기

    풀이1)
    UPDATE tbl_score ts
    SET rank = (SELECT rn
                FROM(
                    SELECT avg, RANK() OVER(ORDER BY avg DESC) rn
                    FROM tbl_score
                )t
                WHERE ts.avg = t. avg);

    풀이2)
    UPDATE tbl_score ts
    SET rank = (SELECT COUNT(*) + 1 FROM tbl_score WHERE tot > ts.tot);

COMMIT;

ROLLBACK;

--
문제7) 모든 학생의 국어 점수를 5점 증가  -> PL/SQL 사용 가능
UPDATE tbl_score
SET kor = CASE
             WHEN avg BETWEEN 0 AND 95 THEN kor + 5
             ELSE 100
          END;

    SELECT *
    FROM tbl_score;
    1001	홍길동	37	62	72	171	57	    F	2
    1002	이순신	69	29	33	131	43.67	F	4
    1003	이순애	86	2	40	128	42.67	F	5
    1004	김정훈	61	17	88	166	55.33	F	3
    1005	한석봉	95	100	63	258	86	    B	1

-- 
문제8) 1001번 학생의 국어, 영어 점수를 1005번 학생의 국어, 영어 점수로 수정
UPDATE tbl_score
SET kor = ( SELECT kor FROM tbl_score WHERE num = 1005 )
    , eng = ( SELECT eng FROM tbl_score WHERE num = 1005)
WHERE num = 1001;

COMMIT;

-- 아래 쿼리 외우기~
UPDATE tbl_score
SET (kor, eng) = (SELECT kor, eng FROM tbl_score WHERE num = 1005)
WHERE num = 1001;

--
문제9) tbl_score 테이블에서 여학생들만 영어 점수 -- 주말에 해보기
        (JOIN 해야 가능)
SELECT *
FROM tbl_scroe;

SELECT *
FROM insa;

--
[만년달력]
SELECT   
        -- TO_CHAR(dates, 'D') 이 값이 일(1) ~ 토(7)에 따라서 해당하는 컬럼에 값을 넣기
          NVL( MIN( DECODE( TO_CHAR(dates, 'D'), 1, TO_CHAR(dates, 'DD') ) ), ' ') 일
         , NVL( MIN(  DECODE( TO_CHAR(dates, 'D'), 2, TO_CHAR(dates, 'DD') ) ), ' ') 월
         , NVL( MIN(  DECODE( TO_CHAR(dates, 'D'), 3, TO_CHAR(dates, 'DD') ) ), ' ') 화
         , NVL( MIN(  DECODE( TO_CHAR(dates, 'D'), 4, TO_CHAR(dates, 'DD') ) ), ' ') 수
         , NVL( MIN(  DECODE( TO_CHAR(dates, 'D'), 5, TO_CHAR(dates, 'DD') ) ), ' ') 목
         , NVL( MIN(  DECODE( TO_CHAR(dates, 'D'), 6, TO_CHAR(dates, 'DD') ) ), ' ') 금
         , NVL( MIN(  DECODE( TO_CHAR(dates, 'D'), 7, TO_CHAR(dates, 'DD') ) ), ' ') 토         
FROM (
        SELECT TO_DATE( :yyyymm, 'YYYYMM') + (LEVEL -1) dates -- 4월 1일 + 30-1(29) 이니까 4월 30일이 된다.
        FROM dual
        CONNECT BY LEVEL <= EXTRACT( DAY FROM LAST_DAY( TO_DATE( :yyyymm , 'YYYYMM') ) )
      ) t      
GROUP BY  DECODE( TO_CHAR(dates, 'D'), 1, TO_CHAR( dates, 'IW') +1,  TO_CHAR( dates, 'IW')   )  -- 일요일(1)이면 주차를 표시.
ORDER BY  DECODE( TO_CHAR(dates, 'D'), 1, TO_CHAR( dates, 'IW') +1,  TO_CHAR( dates, 'IW')   );


-- ORA-01788: CONNECT BY clause required in this query block
-- 해석:  CONNECT BY 절이 필요하다.


SELECT TO_DATE( :yyyymm, 'YYYYMM') + (LEVEL -1) dates -- 4월 1일 + 30-1(29) 이니까 4월 30일이 된다.
FROM dual
CONNECT BY LEVEL <= EXTRACT( DAY FROM LAST_DAY( TO_DATE( :yyyymm , 'YYYYMM') ) );

SELECT TO_DATE( '202203', 'YYYYMM') + (LEVEL -1) -- 4월 1일 + 30-1(29) 이니까 4월 30일이 된다.
FROM dual
CONNECT BY LEVEL <= 31;
-- CONNECT BY LEVEL <= EXTRACT( DAY FROM LAST_DAY( TO_DATE( :yyyymm , 'YYYYMM') ) );


SELECT TO_DATE( :yyyymm, 'YYYYMM') + 29 dates -- 4월 1일 + 30-1(29) 이니까 4월 30일이 된다.
    , TO_CHAR(TO_DATE( :yyyymm, 'YYYYMM') + 29, 'DD') -- 토요일
    , DECODE( TO_CHAR(TO_DATE( :yyyymm, 'YYYYMM') + 29, 'D'), 1, TO_CHAR( TO_DATE( :yyyymm, 'YYYYMM') + 29, 'IW') +1,  TO_CHAR( TO_DATE( :yyyymm, 'YYYYMM') + 29, 'IW')   ) 
    DECODE( TO_CHAR(dates, 'D'), 1, TO_CHAR( dates, 'IW') +1,  TO_CHAR( dates, 'IW')
FROM dual;

SELECT *
    FROM (
        SELECT EXTRACT (MONTH FROM hiredate) mm
        FROM emp
    )
    PIVOT( COUNT(*) FOR mm IN(1,2,3,4,5,6,7,8,9,10,11,12) );


