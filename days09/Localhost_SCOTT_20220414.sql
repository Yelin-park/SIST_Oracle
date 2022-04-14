-- [ SCOTT에 접속된 스크립트 파일 ]
---- 복습문제 ----
1. PIVOT() 함수의 형식을 적으세요.
SELECT *
FROM (피벗대상 쿼리 - 서브쿼리)
PIVOT( 그룹함수|집계함수 FOR 컬럼대상 IN(컬럼값)  )


2. emp 테이블의   각 JOB별 사원수 (피봇)

    CLERK   SALESMAN  PRESIDENT    MANAGER    ANALYST
---------- ---------- ---------- ---------- ----------
         3          4          1          3          1

SELECT *
FROM (SELECT job FROM emp)
PIVOT( COUNT(*) FOR job in('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST' )  );

3. emp 테이블에서  [JOB별로] 각 월별 입사한 사원의 수를 조회 
  ㄱ. COUNT(), DECODE() 사용

JOB         COUNT(*)         1월         2월         3월         4월         5월         6월         7월         8월         9월        10월        11월        12월
--------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
CLERK              3          1          0          0          0          0          0          0          0          0          0          0          2
SALESMAN           4          0          2          0          0          0          0          0          0          2          0          0          0
PRESIDENT          1          0          0          0          0          0          0          0          0          0          0          1          0
MANAGER            3          0          0          0          1          1          1          0          0          0          0          0          0
ANALYST            1          0          0          0          0          0          0          0          0          0          0          0          1

SELECT job, COUNT(*)
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 1, 'o'  ) ) "1월"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 2, 'o'  ) ) "2월"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 3, 'o'  ) ) "3월"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 4, 'o'  ) ) "4월"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 5, 'o'  ) ) "5월"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 6, 'o'  ) ) "6월"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 7, 'o'  ) ) "7월"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 8, 'o'  ) ) "8월"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 9, 'o'  ) ) "9월"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 10, 'o'  ) ) "10월"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 11, 'o'  ) ) "11월"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 12, 'o'  ) ) "12월"
FROM emp
GROUP BY job;

  ㄴ. GROUP BY 절 사용

         월        인원수
---------- ----------
         1          1
         2          2
         4          1
         5          1
         6          1
         9          2
        11          1
        12          3

SELECT EXTRACT(MONTH FROM hiredate) 월 , COUNT(*) 인원수
FROM emp
GROUP BY EXTRACT(MONTH FROM hiredate)
ORDER BY EXTRACT(MONTH FROM hiredate);


  ㄷ. PIVOT() 사용
  
JOB               1월          2          3          4          5          6          7          8          9         10         11         12
--------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
CLERK              1          0          0          0          0          0          0          0          0          0          0          2
SALESMAN           0          2          0          0          0          0          0          0          2          0          0          0
PRESIDENT          0          0          0          0          0          0          0          0          0          0          1          0
MANAGER            0          0          0          1          1          1          0          0          0          0          0          0
ANALYST            0          0          0          0          0          0          0          0          0          0          0          1



SELECT *
FROM (SELECT SUBSTR(hiredate, 4, 2) 월 FROM emp )
PIVOT( COUNT(*) FOR 월 IN ( '01' AS "1월", '02' AS "2월", '03' AS "3월", '04' AS "4월", '05' AS "5월", '06' AS "6월"
                             , '07' AS "7월", '08' AS "8월", '09' AS "9월", '10' AS "10월", '11' AS "11월", '12' AS "12월"  )) mon;

SELECT *
FROM(SELECT job, EXTRACT(MONTH FROM hiredate) 월 FROM emp)
PIVOT(COUNT(*) FOR 월 IN ( 1,2,3,4,5,6,7,8,9,10,11,12));


4. emp 테이블에서 각 부서별 급여 많이 받는 사원 2명씩 출력
  실행결과)
       SEQ      EMPNO ENAME      JOB              MGR HIREDATE        SAL       COMM     DEPTNO
---------- ---------- ---------- --------- ---------- -------- ---------- ---------- ----------
         1       7839 KING       PRESIDENT            81/11/17       5000                    10
         2       7782 CLARK      MANAGER         7839 81/06/09       2450                    10
         1       7902 FORD       ANALYST         7566 81/12/03       3000                    20
         2       7566 JONES      MANAGER         7839 81/04/02       2975                    20
         1       7698 BLAKE      MANAGER         7839 81/05/01       2850                    30
         2       7654 MARTIN     SALESMAN        7698 81/09/28       1250       1400         30

SELECT *
FROM(
    SELECT RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) seq, emp.*
    FROM emp 
) t
WHERE seq <= 2;

--------------------------------------------
1. [PIVOT 함수 사용하는 문제]
문제1) emp 테이블에서 grade 등급별 사원수 조회

SELECT *
FROM salgrade;
1	700	    1200
2	1201	1400
3	1401	2000
4	2001	3000
5	3001	9999

풀이1) COUNT(), DECODE()
--  ename, sal, losal || '~' || hisal, grade
SELECT COUNT(*)
        , COUNT(DECODE(grade, 1, 'o')) "1등급"
        , COUNT(DECODE(grade, 2, 'o')) "2등급"
        , COUNT(DECODE(grade, 3, 'o')) "3등급"
        , COUNT(DECODE(grade, 4, 'o')) "4등급"
        , COUNT(DECODE(grade, 5, 'o')) "5등급"
FROM emp e, salgrade s
WHERE sal BETWEEN losal AND hisal;

풀이2) GROUP BY 절
SELECT grade || '등급' 등급, COUNT(*) 사원수
FROM emp e, salgrade s
WHERE sal BETWEEN losal AND hisal
GROUP BY grade
ORDER BY grade;

풀이3) PIVOT() 
-- 피컷컬럼(목록)에 서브쿼리 넣을 수 없음
-- PIVOT(FOR IN (SELECT grade FROM salgrade))

SELECT *
FROM(SELECT deptno, grade FROM emp, salgrade WHERE sal BETWEEN losal AND hisal  )
PIVOT( COUNT(*) FOR grade IN(1, 2, 3, 4, 5));

--deptno 컬럼을 하나 추가하니 아래와 같이 축이 생성됨
    DEPTNO          1          2          3          4          5
---------- ---------- ---------- ---------- ---------- ----------
        30          1          2          2          1          0
        20          1          0          0          2          0
        10          0          1          0          1          1


----------------------
문제2) emp 테이블에서 년도별 입사사원수를 조회

SELECT DISTINCT TO_CHAR(hiredate, 'YYYY') hire_year
FROM emp;

1) COUNT(), DECODE()
SELECT COUNT(DECODE(TO_CHAR(hiredate, 'YYYY'), 1980, 'o')) "1980"
    , COUNT(DECODE(TO_CHAR(hiredate, 'YYYY'), 1981, 'o')) "1981"
    , COUNT(DECODE(TO_CHAR(hiredate, 'YYYY'), 1982, 'o')) "1982"
FROM emp;


2) GROUP BY
SELECT TO_CHAR(hiredate, 'YYYY') 입사년도, COUNT(*) 사원수
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY') ;


3) PIVOT
SELECT *
FROM(SELECT TO_CHAR(hiredate, 'YYYY') hire_year FROM emp)
PIVOT( COUNT(*) FOR hire_year IN(1980, 1981, 1982));

----------------------
문제3) 지난기수 중 프로젝트 진행시 질문한 것

1. 테이블 생성 : TBL_PIVOT
         컬럼 : no(학생번호), name, jumsu
         
CREATE TABLE TBL_PIVOT(
    no NUMBER NOT NULL PRIMARY KEY -- 크기를 안주면 최대 크기로 잡힘, 필수입력, 고유키
    , name VARCHAR2(20) NOT NULL -- NOT NULL을 주면 필수로 입력해야된다.
    , jumsu NUMBER(3) 
-- 수정작업은 다음에! 다른 방법으로 해결!    
--    , engjumsu NUMBER(3)
--    , engjumsu NUMBER(3) 
--    , matjumsu NUMBER(3) 
);
-- Table TBL_PIVOT이(가) 생성되었습니다.

2. 학생의 성적 정보 추가
3. 국어, 영어, 수학 3개의 과목의 점수를 저장해야되는데 점수를 하나만 저장하게 되는 문제점 발생
    테이블 수정은 안하고 아래와 같이 한사람당 3번씩 행(레코드) 추가
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (1, '박예린' , 90); -- kor
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (2, '박예린' , 89); -- eng
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (3, '박예린' , 99); -- mat

INSERT INTO tbl_pivot (no, name, jumsu) VALUES (4, '안시은' , 56); -- kor
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (5, '안시은' , 45); -- eng
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (6, '안시은' , 12); -- mat

INSERT INTO tbl_pivot (no, name, jumsu) VALUES (7, '김민' , 99); -- kor
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (8, '김민' , 85); -- eng
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (9, '김민' , 100); -- mat

COMMIT;

4. 조회
SELECT *
FROM tbl_pivot;

1	박xx 	90
2	박xx 	89
3	박xx	    99
4	안xx 	56
5	안xx 	45
6	안xx 	12
7	김xx  	99
8	김xx  	85
9	김xx	    100

5. 피벗사용해서 아래와 같이 출력하기
번호  이름   국 영 수
1   박xx   90 89 99
2   안xx   56 45 12
3   김xx   99 85 100

SELECT *
FROM(
    SELECT
    TRUNC((no-1) / 3) + 1 no
    , name, jumsu
    , DECODE(MOD(no, 3), 1, '국어', 2, '영어', 0, '수학') 과목
    FROM tbl_pivot
)
PIVOT( SUM(jumsu) FOR 과목 IN( '국어', '영어', '수학' ) )
ORDER BY no ASC;

--------------------------------------------------------------
2. 
Java : 난수(임의의수) 0.0 <= Math.random() < 1.0
Oracle : dbms_random 패키지(package) != 자바의 패키지 개념과 다르다. 
PL/SQL = 확장된 SQL + PL(절차적 언어)
PL/SQL 5가지 종류 중에 하나가 package 이다.

1) dbms_random.value와 dbms_random.string
n <= values < m 실수를 돌려준다
기본값은 0과 1.0

SELECT dbms_random.value
    , dbms_random.value(0, 100) 실수 -- 0 <= 실수 < 100 
    , TRUNC(dbms_random.value(1, 46), -1) 정수
    , FLOOR(dbms_random.value(0, 45)) + 1 정수
    , dbms_random.string('U', 5) 대문자-- UPPER, 즉 임의의 대문자 5개 출력
    , dbms_random.string('L', 5) 소문자 -- 임의의 소문자 5개
    , dbms_random.string('A', 5) 대소문자 -- 알파벳 대,소문자 5개
    , dbms_random.string('X', 5) 대문자숫자-- 대문자 + 숫자 5개
    , dbms_random.string('P', 5) 대문자특수-- 대문자 + 특수문자 5개
FROM dual;

SELECT TRUNC(dbms_random.value(0, 51)) + 150 -- 0.0 <= 실수 < 51
    , TRUNC(dbms_random.value * 51) + 150 -- 0 <= 실수 < 51 -> 150 <= 정수 < 201
    , TRUNC(dbms_random.value(150, 201))
FROM dual;

----------------------------
3. 오라클 자료형(Data Type)
숫자(정수, 실수) - NUMBER
날짜 - DATE(초까지만), TIMESTAMP( ns까지)
문자열 - VARCHAR2

문자 자료형 - CHAR, NCHAR
            VARCHAR2, NVARCHAR2
            [var]
            [n]
----------           
1) CHAR
     ㄱ. [고정 길이] 문자 자료형
        char(10) 선언후 'abc' 저장
        10byte = ['a']['b']['c'][][][][][][][] -> 남은 7바이트 메모리를 확보하고 있는것 즉, 10바이트는 고정 메모리
        
     ㄴ. 1byte ~ 2000 byte를 저장할 수 있다.(알파벳 1문자 1바이트, 한글 1문자 3바이트)
         SELECT VSIZE('a')
            , VSIZE('ㄱ')
         FROM dual;
         
     ㄷ. 형식
         CHAR(size [BYTE|CHAR])
         char(3) -- size만 줬다면.. == char(3 byte) 라고 쓰는 것과 동일
         char(3 char) -- 이렇게 선언했다면 3문자를 저장하겠다.(바이트 상관없이)
         char -- 이렇게 선언하면, char(1) == char(1 byte)를 준것과 동일
         
     ㄹ. 테스트
     
        (1) 테이블 생성
         CREATE TABLE tbl_char(
            aa char
            , bb char(3)
            , cc char(3 char)
         );
         -- Table TBL_CHAR이(가) 생성되었습니다.
         
         (2) 조회
         SELECT *
         FROM tbl_char;
         
         (3) 데이터 추가
         INSERT INTO tbl_char (aa, bb, cc) VALUES ('a', 'kbs', 'kbs');
         -- 1 행 이(가) 삽입되었습니다.
         
         INSERT INTO tbl_char VALUES ('가', 'kbs', 'kbs'); -- 컬럼 순서대로 값을 추가할 때는 (컬럼명) 생략 가능
         -- ORA-12899: value too large for column "SCOTT"."TBL_CHAR"."AA" (actual: 3, maximum: 1)
         -- 해석 : 지정한 데이터 크기보다 큰 값이 들어왔다.
         
         INSERT INTO tbl_char VALUES ('b', 'k', '케비에');
         -- 1 행 이(가) 삽입되었습니다.
         
         COMMIT;

-------
2) NCHAR == N + CHAR == U[N]ICODE CHAR
    ㄱ. 유니코드(unicode) : 전세계 모든 언어의 1문자를 2 바이트로 처리하겠다.
    
    ㄴ. 형식
        NCHAR( [size] )
        nchar == nchar() 1문자
        nchar(5) 문자 종류 상관없이 5문자 저장
        
    ㄷ. [고정길이] 문자열 + 최대 2000 바이트 저장
    
    ㄹ. 테스트
         CREATE TABLE tbl_nchar(
            aa char
            , bb char(3 char)
            , cc nchar(3)
        );
        -- Table TBL_NCHAR이(가) 생성되었습니다.
        
        INSERT INTO tbl_nchar VALUES('a', '홍길X', '홍길동');
        -- 1 행 이(가) 삽입되었습니다.
        
        SELECT *
        FROM tbl_nchar;

---------
3) VARCHAR2 == VAR(가변길이) + CHAR
    ㄱ. [가변길이] 문자 자료형, 최대 4000 바이트 저장 가능
    
    ㄴ. 형식
        VARCHAR2(size [byte|char]) 의 시노님 == VARCHAR 즉, 뒤에 2를 안붙여도 사용 가능
    ㄷ. 
    
        char = char(1 byte)
        varchar2 = varchar2(4000 byte) 크기를 지정해주지않으면 최대값으로 크기가 잡힌다.
        varchar2(10) = varchar2(10 byte)
        varchar2(10 char) = 문자 10개 저장 가능
        
    ㄹ. 고정길이 / 가변길이 차이점 설명
        char(10) == char(10 byte)
        varchar2(10) == varchar2(10 byte)
        
        'kbs' 저장
        char [k][b][s][''][''][''][''][''][''][''] 나머지는 빈문자로 다 채워져 있음
    varchar2 [k][b][s]                          [][][][][][][] 나머지 버림
    
    ㅁ. 어떤 경우에 고정길이/가변길이를 사용하는가?
        char / nchar -> 고정길이 : 주민등록번호 14자리, 우편번호
        varchar2 / nvarchar2 -> 가변길이 : 제목

-----------
4) NVARCHAR2
    ㄱ. N( 유니코드) + VAR(가변길이) + CHAR(문자열)
    
    ㄴ. 최대 4000바이트 저장
    
    ㄷ. 형식
        NVARCHAR2( [size] )
        nvarchar2 == nvarchar2(최대값)
        
----------------------

5) LONG 가변길이의 문자를 저장하는 자료형 + 최대 2GB 저장 -> 쓸일 거의 X

6) NUMBER( [p], [s] )
    ㄱ. 숫자(정수, 실수)
    
    ㄴ. p(precision) 정확 == 전체 자릿수인데 실제 값의 자리   범위 : 1 ~ 38
        s(scale)    규모(정밀) == 소수점 이하 자릿수         범위 : -84 ~ 127
        
        NUMBER(p) 정수
        NUMBER(p, s) 실수
        
        NUMBER(3, 7) -> 0.0000[][][] 실제 숫자 3개와 소수점 자리수는 7개 자리에 없는 것은 0으로 채운다.
    
    ㄷ. NUMBER == NUMBER(38, 127) 자릿수 지정안해주면 최대 크기로 잡힌다.
    
    ㄹ. 테스트
    CREATE TABLE tbl_number(
        kor NUMBER(3) -- 숫자3자리 즉, -999 ~ 999 3 자리 정수
        , eng NUMBER(3)
        , mat NUMBER(3)
        , tot NUMBER(3)
        , avgs NUMBER(5, 2)
    );
    
    INSERT INTO tbl_number(kor, eng, mat) VALUES (90.89, 85, 100); -- 90.89는 91로 저장되어짐
    INSERT INTO tbl_number(kor, eng, mat) VALUES (90, 85, 101);
    INSERT INTO tbl_number(kor, eng, mat) VALUES (90, 85, -1);
    
    INSERT INTO tbl_number(kor, eng, mat) VALUES (90, 85, 1001);
    -- ORA-01438: value larger than specified precision allowed for this column
    -- 해석 : 저징된 precision보다 크기때문에 넣을 수 없다.
    
    INSERT INTO tbl_number(kor, eng, mat) VALUES (90, 85, 999);
    
    INSERT INTO tbl_number(kor, eng, mat) VALUES (90, 85, -1001);
    -- ORA-01438: value larger than specified precision allowed for this column
    
    COMMIT;
    
    SELECT *
    FROM tbl_number;
    
    -- 모든 학생의 국어, 영어, 수학 점수를 0 ~ 100 임의의 값으로 수정
    UPDATE tbl_number
    SET kor = TRUNC(dbms_random.value(0, 101))
        , eng = TRUNC(dbms_random.value(0, 101))
        , mat = TRUNC(dbms_random.value(0, 101));
    
    -- 모든 학생의 총점과 평균 계산하여 수정
    UPDATE tbl_number
    SET tot = kor + mat + eng
        , avgs = (kor + mat + eng) / 3;
        
    
    -- avgs 컬럼 자료형 NUMBER(5, 2) -> 숫자 5자리 중 3자리는 정수, 2자리는 실수
    UPDATE tbl_number
    SET avgs = 999.87123; -- 999.87로 들어가짐
    SET avgs = 89.12945678; -- 89.13으로 들어가짐, 소수점 3번째 자리에서 반올림이 일어나서 들어가진다.
    SET avgs = 89.12345678; -- 89.12로 들어가짐
    SET avgs = 100.00;
    SET avgs = 9999; -- ORA-01438: value larger than specified precision allowed for this column
    SET avgs = 999;
    SET avgs = 89.23;
    
    
    ㅁ. 만약 NUMBER(4,5)처럼 scale이 precision보다 크다면, 이는 첫자리에 0이 놓이게 된다.
    NUMBER(p) == NUMBER(p, 0) -- 소수점이 없다. 즉, 정수
    
    
    실제 데이터   NUMBER         선언 저장되는 값
    [p > s]
    123.89      NUMBER          123.89 
    123.89      NUMBER(3)       124 
    123.89      NUMBER(3,2)     precision을 초과 
    123.89      NUMBER(4,2)     precision을 초과 
    123.89      NUMBER(5,2)     123.89 
    123.89      NUMBER(6,1)     123.9 
    123.89      NUMBER(6,-2)    100  (기억하기)
    
    [p < s] -- 만약 NUMBER(4,5)처럼 scale이 precision보다 크다면, 이는 첫자리에 0이 놓이게 된다.
    .01234      NUMBER(4,5)     .01234 
    .00012      NUMBER(4,5)     .00012 
    .000127     NUMBER(4,5)     .00013 
    .0000012    NUMBER(2,7)     .0000012   -> .0000123 오류 발생 / .0000100 오류발생
    .00000123   NUMBER(2,7)     .0000012 
    1.2e-4      NUMBER(2,5)     0.00012 
    1.2e-5      NUMBER(2,5)     0.00001 
    
    0.000012 p == 2, s == 5 -> 0.00001 로 나온다.
    0.000012 p == 1, s == 5 -> 에러 발생
    p는 전체 자리수가 아니라 실제 값의 자릿수이다.

테스트용 테이블 생성 - 개인공부
        CREATE TABLE tbl_test(
         a1 NUMBER(2, 7)
         , a2 NUMBER(2, 5)
         , a3 NUMBER(5, 2)
         , a4 NUMBER(4,2)
         , a5 NUMBER(4,5)
        );
        
        DESC
-------------------
7) FLOAT( [p] ) == FLOAT는 내부적으로 NUMBER처럼 나타냄, 숫자 자료형 -> 사용 X 잊어도 된다.
정밀도는 p 1∼126 binary digits로, 1∼22bytes가 필요함

---------------
8) DATE
세기, 년, 월, 일 + 시, 분, 초를 저장하는 자료형(고정길이 7바이트 저장)
컬럼 :
학번 NUMBER(7) -1111111 ~ 1111111
이름 VARCHAR2(20)
    CHAR, NCHAR - 고정길이 : 이름이라 고정길이는 X
    , VARCHAR2, NVARCHAR2 - 가변길이 : 영어권만 쓴다면 NVARCHAR2 필요 X 한글만 쓴다면 NVARCHAR2 굳
                            상황에 따라서 결정하기~
국어 NUMBER(3) -999 ~ 999 -> 0<= n <= 100 체크 제약조건필요, 이건 다음에 배울 예정!
영어 NUMBER(3)
수학 NUMBER(3)
총점 NUMBER(3)
평균 NUMBER(5, 2)
등수 NUMBER(3)
생일 DATE
주민번호 CHAR(14)
기타 VARCHAR2 -- 최대크기 

---------
9) TIMESTAMP( [n] )
    TIMESTAMP == TIMESTAMP(6) -> 00.000000
    TIMESTAMP(9) -> 95/08/08 00:00:[00.000000000]
    DATE의 확장 형태로, 최대 9자리의 년,월,일,시,분,초,밀리초까지 보여줌
    n은 0 ~ 9까지 들어갈 수 있고, n은 초단위 다음에 이어서 나타낼 milli second의 자릿수로 기본값은 6이다

------------
10) 아래 두가지는 그냥 넘어가심...
    INTERVAL YEAR[(n)] TO MONTH
    INTERVAL DAY[(n1)] TO SECOND[(n2)]

--------
11) RAW(size)
    LONG RAW
    - 2진 데이터 저장하는 자료형
    - RAW의 최대값은 2000바이트로 반드시 size를 기술해야 하며, LONG RAW는 2GB까지 지원
    
    이미지 파일을 테이블의 어떤 컬럼을 넣기 위해서는 010101 2진데이터로 변환해야되는데 
    이때 img RAW/LONG RAW를 사용

----------
12) BFILE == B(binary, 2진데이터) + FILE(외부 파일 형식으로 저장)
    2GB 이상의 2진데이터를 저장하고자 한다면 BFILE 자료형을 사용한다.
    2진데이터를 외부에 file형태로 (264 -1바이트)까지 저장

----------
13) LOB([L]arge [O][B]ject)
    - 2GB 이상의 자료를 저장할 때 사용
    -  4000바이트까지는 LOB컬럼에 저장되지만, 그 이상이면 외부에 저장된다
    ㄱ. B + LOB = BLOB (2진데이터 저장)
    ㄴ. C + LOB = CLOB (텍스트 데이터 저장)
    ㄷ. N + C + LOB = NCLOB (유니코드형태의 텍스트 데이터 저장)
     
    텍스트(LONG), 이미지, 이진데이터(LONG RAW) 저장시 2GB까지 저장
    2GB 이상 대용량 저장시 LOB가 붙어있는 자료형 필요

---------
14) ROWID pseudo(의사) 컬럼 -- 부서의 행을 구별하는 고유한(유일한) 값(식별자)

SELECT ROWID, dept.*
FROM dept;

-- 위의 배운 자료형 간단하게 정리 --
날짜 - DATE, TIMESTAMP(n)
숫자 - NUMBER(p, s), FLOAT(p)
문자 - CHAR, NCHAR
        VARCHAR2, NVARCHAR2
        LONG (2GB)
2진데이터 - RAW, LONG RAW

LOB - BLOB, CLOB, NCLOB, BFILE

-------------------------
4. [COUNT 함수]
    【형식】
	COUNT([* ? DISTINCT ? ALL] 컬럼명) [ [OVER] (analytic 절)]

-- ORA-00937: not a single-group group function
SELECT name, basicpay, COUNT(*)
FROM insa;

-- COUNT(*) OVER(ORDER BY basicpay) : 질의한 행의 누적된 결과값을 반환
SELECT name, basicpay, COUNT(*) OVER(ORDER BY basicpay)
FROM insa;

-- 부서별로 누적된 합계를 구할 수 있다.
SELECT buseo, name, basicpay
    , COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay DESC) -- 부서로 파티션을 나누고 나서 카운트 하겠다.
FROM insa;

--------------------
5. SUM 함수
【형식】
	SUM ([DISTINCT ? ALL] expr)
         [OVER (analytic_clause)]

SELECT buseo, name, SUM(basicpay) OVER(ORDER BY buseo) -- 각 부서별의 누적된 합이 나온다.
FROM insa;
개발부	이상헌	19430000
개발부	장인철	19430000
기획부	김신제	32420000 -- 개발부의 합계 + 기획부의 합계 
기획부	권옥경	32420000
영업부	산마루	58044200 -- 개발부의 합계 + 기획부의 합계 + 영업부의 합계
영업부	김인수	58044200

SELECT DISTINCT buseo, SUM(basicpay) OVER(ORDER BY buseo) ps -- 각 부서별의 누적된 합이 나온다.
FROM insa
ORDER BY ps;

개발부	19430000
기획부	32420000
영업부	58044200
인사부	64176200
자재부	72676600
총무부	84680600
홍보부	93391600 개+기+영+인+자+총+홍 합계

SELECT DISTINCT buseo, SUM(basicpay) OVER(PARTITION BY buseo ORDER BY buseo) -- 각 부서별의 누적된 합이 나온다.
FROM insa;

---------------------
6. AVG 함수
【형식】
	AVG ([DISTINCT ? ALL] expr)
         [OVER (analytic_clause)]

SELECT city, name, basicpay
    , AVG(basicpay) OVER(ORDER BY city) 누적평균 -- 누적된 평균 반환
    , AVG(basicpay) OVER(PARTITION BY city ORDER BY city) 해당지역평균 -- 해당 지역의 평균 반환
    , basicpay - AVG(basicpay) OVER(PARTITION BY city ORDER BY city) 지역평균과내급여차이
FROM insa;

강원	정한국	880000	930000
경기	권옥경	1020000	1371066.66666666666666666666666666666667 -- 강원과 경기의 누적된 평균

----------------------------
7. 테이블 생성, 수정, 삭제 - 추가, 수정, 삭제 등등

*** DB 모델링 *** -> 다음 주에 배울 예정!
테이블(table) : 어떤 데이터를 저장하기 위한 장소

1)
테이블 - tbl_member
컬럼(열) : 컬럼명      자료형과 크기                            널허용             고유키(PK)
아이디     id          문자/가변길이 VARCHAR2(10)              NOT NULL          PRIMARY KEY
이름      name        문자/가변길이 VARCHAR2(20)               NOT NULL
나이      age         숫자/정수 NUMBER(3)                     
전화번호   tel         문자/고정길이(휴대폰) CHAR(13) 3-4-4      NOT NULL
생일      birth       날짜/초 DATE
기타      etc         문자 VARCHAR(200)

-- 
【간단한 테이블 생성 형식】
    CREATE [GLOBAL TEMPORARY] TABLE [schema.] table명
      ( 
        열이름  데이터타입 [DEFAULT 표현식] [제약조건] 
       [,열이름  데이터타입 [DEFAULT 표현식] [제약조건] ] 
       [,...]  
      ); 

- GLOBAL TEMPORARY : 임시 테이블을 생성하겠다는 의미
    왜 사용? 로그인하고 로그아웃하기 전까지만 동안만 장바구니를 유지하고 로그아웃하면 장바구니 비우기 위해서! 임시테이블 사용
- schema : 접속한 계정명
- 제약조건 : 널허용, 고유키 등등

--
2) 테이블 생성
    CREATE TABLE scott.tbl_member
      ( 
        id VARCHAR2(10) NOT NULL PRIMARY KEY
        , name VARCHAR(2) NOT NULL
        , age NUMBER(3) 
        , tel CHAR(13)
        , birth DATE
        , etc VARCHAR2(200) 
      );
    -- Table SCOTT.TBL_MEMBER이(가) 생성되었습니다.
    
    SELECT *
    FROM tbl_member;
    
    SELECT *
    FROM tabs
    WHERE table_name LIKE '%MEMBER%';
    
3) 생성된 테이블 삭제
DROP TABLE tbl_member;
--Table TBL_MEMBER이(가) 삭제되었습니다.

4) 다시 생성..
    CREATE TABLE scott.tbl_member
      ( 
        id VARCHAR2(10) NOT NULL PRIMARY KEY
        , name VARCHAR(2) NOT NULL
        , age NUMBER(3) 
        , birth DATE
      );
    -- Table SCOTT.TBL_MEMBER이(가) 생성되었습니다.

5) 테이블 구조 확인   
    DESC tbl_member;
    이름    널?       유형           
    ----- -------- ------------ 
    ID    NOT NULL VARCHAR2(10) 
    NAME  NOT NULL VARCHAR2(2)  
    AGE            NUMBER(3)    
    BIRTH          DATE

--------------------------------------------
6) 기존 tbl_member 테이블에 새로운 컬럼인 전화번호, 기타 컬럼 추가 - (1) 관련
	ALTER TABLE tbl_member
	ADD(
        tel CHAR(13) NOT NULL
        , etc VARCHAR2(200)
	    );
-- Table TBL_MEMBER이(가) 변경되었습니다.

DESC tbl_member; -- 새로 추가된 컬럼은 마지막에 들어가진다
이름    널?       유형            
----- -------- ------------- 
ID    NOT NULL VARCHAR2(10)  
NAME  NOT NULL VARCHAR2(2)   
AGE            NUMBER(3)     
BIRTH          DATE          
TEL   NOT NULL CHAR(13)      
ETC            VARCHAR2(200) 

-- ALTER 설명
[DDL의 ALTER..]

ALTER TABLE

(1) 새로운 컬럼 추가 ...ADD
    【형식】컬럼추가
	ALTER TABLE 테이블명
	ADD (컬럼명 datatype [DEFAULT 값]
	    [,컬럼명 datatype]...);

? 한번의 add 명령으로 여러 개의 컬럼 추가가 가능하고, 하나의 컬럼만 추가하는 경우에는 괄호를 생략해도 된다.
? 추가된 컬럼은 테이블의 마지막 부분에 생성되며 사용자가 컬럼의 위치를 지정할 수 없다
? 추가된 컬럼에도 기본 값을 지정할 수 있다.
? 기존 데이터가 존재하면 추가된 컬럼 값은 NULL로 입력 되고, 새로 입력되는 데이터에 대해서만 기본 값이 적용된다.

(2) 기존 컬럼 수정
【형식】기존 컬럼 수정
 ALTER TABLE 테이블명
 MODIFY (컬럼명 datatype [DEFAULT 값]
 [,컬럼명 datatype]...);
 
? 데이터의 type, size, default 값을 변경할 수 있다.
? 변경 대상 컬럼에 데이터가 없거나 null 값만 존재할 경우에는 size를 줄일 수 있다.
    -> 데이터가 있는 경우 size를 줄일 수 없다! ***
? 데이터 타입의 변경은 CHAR와 VARCHAR2 상호간의 변경만 가능하다.
    -> 같은 자료형 유형으로 변경 가능
? 컬럼 크기의 변경은 저장된 데이터의 크기보다 같거나 클 경우에만 가능하다.
    -> 데이터가 있는 경우에는 size 증가만 가능
? NOT NULL 컬럼인 경우에는 size의 확대만 가능하다.
    -> 제약조건이 NOT NULL이면 size 확대만 가능
? 컬럼의 기본값 변경은 그 이후에 삽입되는 행부터 영향을 준다.
? 컬럼이름의 [직접적인 변경]은 불가능하다.
? 컬럼이름의 변경은 서브쿼리를 통한 테이블 생성시 alias를 이용하여 변경이 가능하다.
? alter table ... modify를 이용하여 constraint(제약조건)를 수정할 수 없다.

(3) 기존 컬럼 삭제
【형식】
   ALTER TABLE 테이블명
   DROP COLUMN 컬럼명; 

? 컬럼을 삭제하면 해당 컬럼에 저장된 데이터도 함께 삭제된다.
? 한번에 하나의 컬럼만 삭제할 수 있다.
? 삭제 후 테이블에는 적어도 하나의 컬럼은 존재해야 한다.
? DDL문으로 삭제된 컬러은 복구할 수 없다.

(4) 제약조건 추가
(5) 제약조건 삭제

------
7) ETC 컬럼 자료형의 크기를 VARCHAR2(200) -> VARCHAR2(255) 수정하고싶다. - (2) 관련

 ALTER TABLE tbl_member
 MODIFY ( etc VARCHAR2(255) );
 -- Table TBL_MEMBER이(가) 변경되었습니다.
 
 DESC tbl_member;
     이름    널?       유형            
    ----- -------- ------------- 
    ID    NOT NULL VARCHAR2(10)  
    NAME  NOT NULL VARCHAR2(2)   
    AGE            NUMBER(3)     
    BIRTH          DATE          
    TEL   NOT NULL CHAR(13)      
    ETC            VARCHAR2(255)
    
------
8) etc 컬럼명을 bigo 컬럼명으로 수정하고싶다.

방법1) 별칭(alias) 사용
    SELECT etc bigo FROM tbl_member;

방법2) 필드명을 수정
    ALTER TABLE tbl_member
    RENAME COLUMN etc TO bigo;
    -- Table TBL_MEMBER이(가) 변경되었습니다.
    
    DESC tbl_member;
           이름    널?       유형           
    ----- -------- ------------ 
    ID    NOT NULL VARCHAR2(10) 
    NAME  NOT NULL VARCHAR2(2)  
    AGE            NUMBER(3)    
    BIRTH          DATE         
    TEL   NOT NULL CHAR(13)
    BIGO           VARCHAR2(255)

------  
9) bigo 컬럼을 삭제하고싶다
   ALTER TABLE tbl_member
   DROP COLUMN bigo;
   -- Table TBL_MEMBER이(가) 변경되었습니다.
   
   DESC tbl_member;
       이름    널?       유형           
    ----- -------- ------------ 
    ID    NOT NULL VARCHAR2(10) 
    NAME  NOT NULL VARCHAR2(2)  
    AGE            NUMBER(3)    
    BIRTH          DATE         
    TEL   NOT NULL CHAR(13)     

-----
10) tbl_member 테이블의 이름 수정

RENAME tbl_member TO tbl_customer;