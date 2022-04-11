-- [ SCOTT에 접속된 스크립트 파일 ]

1. 집계함수 == 그룹함수 == 복수행 함수
*** 주의할 점) NULL 값을 제외한 ***
SUM(n) : NULL 값을 제외한 n의 합계
AVG(n) : NULL 값을 제외한 N개 행의 평균값을 리턴한다.
COUNT(n) : NULL을 제외한 행의 갯수를 리턴한다. COUNT(*)은 NULL 값을 포함한 행(레코드)갯수.
MAX() : 최대값을 리턴한다.
MIN() : 최소값을 리턴한다.
STDDEV(n) : NULL 값을 제외한표준편차 구하는 함수
VARIANCE(n) : NULL 값을 제외한 분산값 구하는 함수

    문제1) emp 테이블에서 최고급여액을 받는 사원의 정보를 출력
    SELECT *
    FROM emp
    WHERE  sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp);
    
    문제2) emp 테이블에서 최저급여를 받는 사원의 정보를 출력
    SELECT *
    FROM emp
    WHERE sal + NVL(comm, 0) = (SELECT MIN(sal + NVL(comm, 0)) FROM emp);
    
    문제3) emp 테이블에서 최고, 최저 급여를 받는 사원의 정보를 조회
    1번 풀이-- UNION 사용
    SELECT *
    FROM emp
    WHERE  sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp)
    UNION
    SELECT *
    FROM emp
    WHERE sal + NVL(comm, 0) = (SELECT MIN(sal + NVL(comm, 0)) FROM emp);
    
    2번 풀이-- OR 사용
    SELECT *
    FROM emp
    WHERE sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp)
            OR sal + NVL(comm, 0) = (SELECT MIN(sal + NVL(comm, 0)) FROM emp);
    
    3번 풀이-- IN (LIST)
    주의할 점) 서브쿼리를 합쳐서 IN 구문에 넣으면 에러발생
    SELECT *
    FROM emp
    WHERE sal + NVL(comm, 0) IN( (SELECT MAX(sal + NVL(comm, 0)) FROM emp)
                                , (SELECT MIN(sal + NVL(comm, 0)) FROM emp));
                                
    SELECT *
    FROM emp
    WHERE sal + NVL(comm, 0) IN( (SELECT MAX(sal + NVL(comm, 0) , MIN(sal + NVL(comm, 0)) FROM emp) );
    
    --
    ALL과 EXISTS 연산자 맛보기
    <ALL 연산자>
    -- 모든 사원의 급여보다 크거나 같니? 즉, 최고급여자
    -- 모든 사원의 급여보다 작거나 낱니? 즉, 최저급여자
    -- ALL 연산자와 비교연산자를 같이 사용
    SELECT *
    FROM emp
    WHERE  sal + NVL(comm, 0) <= ALL ( SELECT sal + NVL(comm, 0) FROM emp);
    WHERE  sal + NVL(comm, 0) >= ALL ( SELECT sal + NVL(comm, 0) FROM emp);
    
    <서브쿼리의 결과>
    800
    1900
    1750
    2975
    2650
    2850
    2450
    5000
    1500
    950
    3000
    1300
    
    <EXISTS 사용> : 존재하는지 물어보는 함수
    SELECT DISTINCT mgr FROM emp WHERE mgr IS NOT NULL : 이 서브쿼리의 값이 참이면
    WHERE EXISTS() : 존재하면 true 값을 반환하기 때문에 전체 사원이 나옴
    
    SELECT *
    FROM emp
    WHERE EXISTS (SELECT DISTINCT mgr FROM emp WHERE mgr IS NOT NULL);
    
    -- WHERE EXISTS (SELECT deptno FROM dept);

복습1. EMP 테이블의 사원수를 조회하는 쿼리 작성.

SELECT COUNT(*) "총갯수" -- 12명 
    -- , comm ORA-00937: not a single-group group function -> 에러 주의~~
    , COUNT(comm) "널제외" -- 4명 (NULL 값을 제외한 갯수)
    , SUM( sal + NVL(comm, 0)) "총급여"
    , ROUND(AVG( sal + NVL(comm, 0) ), 2) "평균급여"
    , MAX(sal + NVL(comm, 0)) "최고급여"
    , MIN(sal + NVL(comm, 0)) "최저급여"
FROM emp;

복습2. 현재 시스템의   날짜를 출력하는 쿼리 작성
SELECT SYSDATE -- 현재 시스템의 날짜/시간
        , CURRENT_DATE -- 현재 세션의 날짜/시간
        , CURRENT_TIMESTAMP -- 현재 세션의 날짜/시간 + 나노초(확장)
FROM dual;

복습3. SQL 집합 연산자의 종류와 설명을 하세요
UNION 합집합
UNION ALL 중복된 것들도 모두
MINUS 차집합
INTERSECT 교집합

복습4. 함수 설명
  ㄱ. 반올림 함수를 선언형식을 적고 설명하세요
	ROUND(a, b) a를 b+1자리에서 반올림, 음수일 경우 b의 정수자리에서 반올림

  ㄴ. 절삭(내림) 함수를 선언형식을 적고 설명하세요.
	FLOOR() -> 소수점 1번째 자리에서 내림
	TRUNC(a, b) -> a를 b+1자리에서 내림, 음수일 경우 정수자리에서 내림

  ㄷ. 절상(올림) 함수를 선언형식을 적고 설명하세요.    
	CEIL() -> 소수점 1번째 자리에서 올림한다.
  
복습5. 게시판에서 총 게시글 수가 : 65 개 이고  한 페이지에 : 15개의 게시글 출력할 때
    총 페이지 수를 계산하는 쿼리 작성.
SELECT ceil(65/15)
FROM dual;
    
복습6. emp 테이블에서 사원들의 평균 급여보다 많은 급여를 받으면 1
                                     적은 급여를 받으면 -1
                                     같으면           0 
  을 출력하는 쿼리 작성.
SELECT ename , sal+NVL(comm,0) pay
    --, ROUND((SELECT SUM(sal+NVL(comm,0)) / COUNT(*) FROM emp))
    --, NVL2(NULLIF(SIGN(ROUND((SELECT SUM(sal+NVL(comm,0)) / COUNT(*) FROM emp), 2) - sal + NVL(comm, 0)), 1), '많다', '적다')
    , (SELECT ROUND(AVG(sal+NVL(comm,0)), 0) FROM emp) avg_pay
FROM emp;

<서브쿼리 사용>
SELECT t.ename, t.pay, t.avg_pay
        ,SIGN(t.pay - t.avg_pay)
FROM(
    SELECT ename, sal+NVL(comm,0) pay
         , (SELECT ROUND(AVG(sal+NVL(comm,0)), 0) FROM emp) avg_pay
         FROM emp
) t;

복습7. insa테이블에서 80년대( 80년~89년생 )에 출생한 사원들만 조회하는 쿼리를 작성
  ㄱ. LIKE 사용
    SELECT *
    FROM insa
    WHERE ssn LIKE '8%';
  
  ㄴ. REGEXP_LIKE 사용
  
  SELECT 
  FROM insa
  
  FROM insa
  WHERE REGEXP_
  ㄷ. BETWEEN ~ AND 사용   
  
복습8. insa 테이블에서 주민등록번호를 123456-1******  형식으로 출력하세요 . ( LPAD, RPAD 함수 사용  )
[실행결과]
홍길동	770423-1022432	770423-1******
이순신	800423-1544236	800423-1******
이순애	770922-2312547	770922-2******

SELECT RPAD(SUBSTR(ssn, 0, 8), 14, '*')
FROM insa;

복습8-2. emp 테이블에서 30번 부서만 PAY를 계산 후 막대그래프를 아래와 같이 그리는 쿼리 작성
   ( 필요한 부분은 결과 분석하세요~    PAY가 100 단위당 # 한개 , 반올림처리 )
[실행결과]
DEPTNO ENAME PAY BAR_LENGTH      
---------- ---------- ---------- ----------
30	BLAKE	2850	29	 #############################
30	MARTIN	2650	27	 ###########################
30	ALLEN	1900	19	 ###################
30	WARD	1750	18	 ##################
30	TURNER	1500	15	 ###############
30	JAMES	950	    10	 ##########

SELECT CEIL( (sal + NVL(comm, 0)) / 100 )
        , LPAD(' ', CEIL( (sal + NVL(comm, 0)) / 100 )+1, '#')
        , RPAD(' ', CEIL( (sal + NVL(comm, 0)) / 100 )+1, '#')
FROM emp
WHERE deptno = 30;



복습8-3. insa 테이블에서  주민번호를 아래와 같이 '-' 문자를 제거해서 출력
[실행결과]
NAME    SSN             SSN_2
홍길동	770423-1022432	7704231022432
이순신	800423-1544236	8004231544236
이순애	770922-2312547	7709222312547

SELECT ssn
    , SUBSTR(ssn, 0, 6) || SUBSTR(ssn, -7, 6)
    , REPLACE(ssn, '-', '')
FROM insa;

<날짜 함수의 종류 - 새로운 내용!!!>
복습9. emp 테이블에서 각 사원의 근무일수, 근무 개월수, 근무 년수를 출력하세요.
날짜형 - 날짜형 = 일수
날짜형 + 숫자형 = 숫자(일수)만큼 증가한 날짜
날짜형 - 숫자형 = 숫자(일수)만큼 빼진 날짜
날짜형 + 숫자/24 = 시간이 더해진 날짜형
날짜형 - 숫자/24 = 시간이 빼진 날짜형

근무일수 / 365 = 근무년수

MONTHS_BETWEEN() 함수 : 날짜, 날짜 사이의 개월수 리턴하는 함수

SELECT empno, ename, hiredate 
    , CEIL( ABS( hiredate - SYSDATE ) ) 근무일수
    , ROUND(ABS(MONTHS_BETWEEN(hiredate, SYSDATE)), 2) 근무개월수
    , ROUND( ABS(MONTHS_BETWEEN(hiredate, SYSDATE)) / 12 , 2) 근무년수
FROM emp;

복습10. 개강일로부터 오늘날짜까지의 수업일수 ? -- 토,일,공휴일 포함한 일수
( 개강일 : 2022.2.15 )

-- ORA-00932: inconsistent datatypes: expected CHAR got DATE
-- 해석 : CHAR와 DATE 데이터 타입이 맞지 않는다.
-- 오라클 '문자열' '날짜형'
-- '2022.02.15' 날짜형이 아닌 문자열로 처리
-- 문자열을 날짜형으로 형변환하는 것 -> TO_DATE(char [,'fmt' [,'nlsparam']])
-- 문자열을 숫자형으로 형변환하는 것 -> TO_NUMBER()
-- 순수 숫자로 이루어진 문자열은 묵시적으로 형변환이 됨 ex) '20' -> 20
-- 문자열 자료형 : CHAR, VARCHAR2, NCHAR, NVARCHAR2 

SELECT '2022.02.15' - SYSDATE
FROM dual;

SELECT ABS(TO_DATE('2022.02.15') - SYSDATE) 수업일수
        , ABS(TO_DATE('02/15/2022', 'MM/DD/YYYY') - SYSDATE) 수업일수2
    -- TO_DATE('02/15/2022')
    -- ORA-01841: (full) year must be between -4713 and +9999, and not be 0
    -- 날짜 형식이 맞지 않아서 발생함, fmt를 설정해주면 해결 가능!
FROM dual;

    
복습10-2.  오늘부터 수료일까지 남은 일수 ?  
( 수료일 : 2022.7.29 ) 
SELECT CEIL( ABS(TO_DATE('2022.07.29') - SYSDATE))
FROM dual;

복습10-3. emp 테이블에서 각 사원의 입사일을 기준으로 100일 후 날짜, 10일전 날짜
                        , 1시간 후 날짜, 3개월 전 날짜 출력

SMITH	80/12/17	81/03/27	80/12/07	80/12/17	81/03/17	80/09/17
ALLEN	81/02/20	81/05/31	81/02/10	81/02/20	81/05/20	80/11/20
WARD	81/02/22	81/06/02	81/02/12	81/02/22	81/05/22	80/11/22

SELECT ename, hiredate
    , hiredate + 100 "100일후"
    , hiredate - 10 "10일전"
    , hiredate + 1/24 "1시간후"
    , ADD_MONTHS(hiredate, 3) "3개월후"
    , ADD_MONTHS(hiredate, -3) "3개월전"
FROM emp;

-- MONTHS_BETWEEN() 개월차
SELECT t.first, t.second
    , MONTHS_BETWEEN( t.first, t.second) -- 31일 기준으로 나오는 자투리는 소수점
FROM(
    SELECT TO_DATE('03-01-2022', 'MM-DD-YYYY') first
            , TO_DATE('02-01-2022', 'MM-DD-YYYY') second
    FROM dual
) t;

-- ADD_MONTHS() 함수 : 개월수 더하기 빼기하는 함수
-- 달의 마지막일에서 더하면 다음달의 마지막 날짜를 가져옴
SELECT ADD_MONTHS(TO_DATE('03-01-2022', 'MM-DD-YYYY'), 1) 예시1
        ,ADD_MONTHS(TO_DATE('03-01-2022', 'MM-DD-YYYY'), -2) 예시2
        ,ADD_MONTHS(TO_DATE('02-28-2022', 'MM-DD-YYYY'), 1) 예시3 -- 22/03/31
        ,ADD_MONTHS(TO_DATE('02-27-2022', 'MM-DD-YYYY'), 1) 예시4 -- 22/03/27
FROM dual;

-- LAST_DAY() 함수는 특정날짜가 속한 달(월)의 가장 마지막 날짜를 반환한다.
SELECT LAST_DAY(SYSDATE)
        , TO_CHAR(LAST_DAY(SYSDATE), 'DD') -- 일자만 가져옴
FROM dual;

-- NEXT_DAY(date,char) 함수는 명시된 요일이 돌아오는 [가장 최근의 날짜]를 리턴하는 함수
-- ex) 돌아오는 금요일은 몇일?

SELECT SYSDATE
    , TO_CHAR(SYSDATE, 'D') 예시1 -- 2:월요일 / 1(일) ~ 7(토)
    , TO_CHAR(SYSDATE, 'DY') 예시2 
    , TO_CHAR(SYSDATE, 'DAY') 예시3
    , NEXT_DAY(SYSDATE, '금요일') 예시4 -- 돌아오는 금요일
    , NEXT_DAY(SYSDATE, '월요일') 예시5 -- 돌아오는 월요일
    , NEXT_DAY(NEXT_DAY(SYSDATE, '금요일'), '금요일') 예시5 -- 다음주 금요일
FROM dual;


복습11. function 설명
 ㄱ. ASCII() - 문자를 ASCII 코드 값으로 반환해주는 함수
 ㄴ. CHR() - ASCII 코드를 문자로 반환해주는 함수
 ㄷ. GREATEST(args...) - 가장 큰 값을 가져오는 함수
 ㄹ. LEAST(args...) - 가장 작은 값을 가져오는 함수
 ㅁ. UPPER() - 대문자로 변환해주는 함수
 ㅂ. LOWER() - 소문자로 변환해주는 함수
 ㅅ. LENGTH() - 문자열 길이를 반환해주는 함수
 ㅇ. SUBSTR() - 문자열을 원하는 위치에서 원하는 길이만큼 잘라주는 함수
 ㅈ. INSTR() - 원하는 문자가 어디에 있는지 알려주는 함수


***** 날짜 절삭하는 것 이해하기
복습12.
SELECT TRUNC( SYSDATE, 'YEAR' ) -- 2022/01/01
     , TRUNC( SYSDATE, 'MONTH' )     -- 2022/04/01 
     , TRUNC( SYSDATE  ) -- 2022/04/11 (00:00:00)
FROM dual;
    위의 쿼리의 결과를 적으세요 . 

SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS')
 -- 2022/04/11 12:01:10 -> SYSDATE는 시간까지 가지고 있음
FROM dual;

---------------------------------------------------------------
수업시작!!
--
문제) 이번 달 몇일 남았나요?
SELECT SYSDATE
    , LAST_DAY(SYSDATE)
    , LAST_DAY(SYSDATE) - SYSDATE 
FROM dual;

1. 변환함수(형변환 함수)
1) TO_NUMBER() : 문자 -> 숫자 : 자동으로(묵시적) 문자를 숫자로 변환이 되어서 잘 사용X
2) TO_DATE() : 문자 -> 날짜
3) TO_CHAR : 숫자,날짜 -> 문자

<TO_NUMBER() 함수~!>
    SELECT '10' -- 문자 왼쪽정렬
            , 10 -- 숫자 오른쪽정렬
            , TO_NUMBER('10')
            , '10' + 10 -- 숫자로 변환이 됨
    FROM dual;
    
    -- insa 테이블에서 남자 출력
    SELECT *
    FROM insa
    WHERE MOD( SUBSTR(ssn, -7, 1), 2) = 1;
    -- SUBSTR은 문자로 반환해 주는데 숫자와 비교해도 문제 없었다.
    -- MOD 나머지 구하는 함수인데 문자열로도 가능했다.
    -- 즉, 묵시적으로 문자를 숫자로 변환해주고 있었음 ->  자동형변환

<TO_DATE() 함수~!>
    SELECT TO_DATE('2022-02-15')
        , TO_DATE('02-15-2022', 'MM-DD-YYYY')
            -- 날짜 값이 년월일이 아니면 포맷형식을 지정해줘야함
        , TO_DATE('2022', 'YYYY')
            -- 년도만 있는 문자열을 날짜로 변환하면 월은 해당월, 일은 1일로 설정
        , TO_DATE('2022.03', 'YYYY.MM')
            -- 년도, 월만 있으면 일을 자동으로 1일 설정
        , TO_DATE('20', 'DD')
            -- 해당년도와 해당월로 자동 설정해줌
    FROM dual;
 
<TO_CHAR() 함수~!>
    SELECT SYSDATE 날짜
        , TO_CHAR(SYSDATE, 'YYYY') 년도 -- 날짜로부터 년도를 가져와 문자열로 변환 : 2022
        , TO_CHAR(SYSDATE, 'MM') 월 -- 날짜로부터 년도를 가져와 문자열로 변환 : 2022
        , TO_CHAR(SYSDATE, 'DD') 일 -- 날짜로부터 년도를 가져와 문자열로 변환 : 2022
        , TO_CHAR(SYSDATE, 'HH') 시간
        , TO_CHAR(SYSDATE, 'HH24') 시간
        , TO_CHAR(SYSDATE, 'MI') 분
        , TO_CHAR(SYSDATE, 'SS') 초
        , TO_CHAR(SYSDATE, 'D') 요일 -- 1(일) ~ 7(토)
        , TO_CHAR(SYSDATE, 'DY') 요일 -- 월
        , TO_CHAR(SYSDATE, 'DAY') 요일 -- 월요일
        , TO_CHAR(SYSDATE, 'CC') 세기
        , TO_CHAR(SYSDATE, 'Q') 분기
        , TO_CHAR(SYSDATE, 'WW') 년중몇번째주 -- 15주
        , TO_CHAR(SYSDATE, 'W') 월중몇번째주 -- 2주
        , TO_CHAR(SYSDATE, 'IW') 년중몇번째주 -- 15주
        , TO_CHAR(SYSDATE, 'TS') 시간표기 -- 오후 12:39:22
    FROM dual;
    
    -- 출력형식 2022년 4월 11일 오후 12:40:12
    SELECT TO_CHAR(SYSDATE, 'YYYY') || '년 '
            || TO_CHAR(SYSDATE, 'MM') || '월 '
            || TO_CHAR(SYSDATE, 'DD') || '일 '
            || TO_CHAR(SYSDATE, 'TS') 날짜시간
    FROM dual;
    
    SELECT TO_CHAR(SYSDATE, 'YYYY"년 "MM"월 "DD"일 "TS')
    FROM dual;
    
    --
    
    SELECT 1234567
         -- 세자리마다 콤마를 찍은 문자열로 변환
        , TO_CHAR(1234567, '9,999') -- ###### : 자리수가 부족함
        , TO_CHAR(1234567, 'L9,999,999.99')
        , TO_CHAR(12, '0999')
    FROM dual;

--
    
    SELECT ename, TO_CHAR(sal + NVL(comm, 0), 'L9,999.00') pay
    FROM emp;
    
    SELECT name, TO_CHAR(basicpay + sudang, 'L9,999,999') pay
    FROM insa;
    
    문제1) emp 테이블에서 각 사원의 입사일자를 기준으로 10년 5개월 20일째 되는 날은??
    
    SELECT ename, hiredate
        , ADD_MONTHS(hiredate + 20, 10 * 12 + 5)
    FROM emp;
    
    문제2) 문자열 '2021년 12월 23일' -> 날짜형
    SELECT TO_DATE('2021년 12월 23일', 'YYYY"년" MM"월" DD"일"')
    FROM dual;
    
    문제3) insa 테이블에서 ssn(주민번호)을 통해서 생일 얻어오고
        오늘을 기준으로 생일 지났다면 -1
        오늘이 생일이라면 0
        오늘을 기준으로 생일이 안지났다면 1
        + 시간을 절삭해줘야됨! 시간때문에 오늘 생일인 사람이 생일이 지났다고 나옴
        
    SELECT name, ssn
        , TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD' ) 생일
        , SIGN( TO_DATE( SUBSTR( ssn, 3, 4 ), 'MMDD' ) - TRUNC( SYSDATE ) ) 생일지남확인
    FROM insa;

------------------------

2. 일반 함수 3가지!!!!!
1) COALESCE(expr1 [,expr2,...]) : 값을 순차적으로 체크해서 NULL이 아닌 값을 반환하는 함수
즉, NULL이 아닌 값을 찾아가는 함수
    
    SELECT ename, sal, comm
            , sal + NVL(comm, 0) pay
            , sal + NVL2(comm, comm, 0) pay
            , sal + COALESCE(comm, 0) pay
            , COALESCE(sal + comm, sal, 0) pay
    FROM emp;

***** 2) DECODE() : 여러 개의 조건을 주어 조건에 맞을 경우에 해당 값을 리턴하는 함수 *****
    (1) 프로그램 언어(자바)의 if문과 비슷하다.
        (3) 조건식에 == 이거 하나밖에 없다. if( == )
    (2) FROM 절에서만 사용할 수 없다.
    (3) PL/SQL 안으로 끌어들여 사용하기 위하여 만들어진 오라클 함수이다.
    (4) DECODER() 함수의 확장 함수는 CASE() 함수
    
    -- 자바식을 DECODE 함수로..--
    int x = 10;
    if( x == 11) {
        return C;
    }
    
    --> DECODE 함수로 변형
    DECODE(x, 11, C);
    x가 11하고 같니? 같으면 C를 리턴해라
    
    if(x == 10){
        return A
    } else{
        return B
    }
    
    --> DECODE 함수로 변형
    DECODE(x, 10, A, B);
    x가 10하고 같니? 같으면 A를 같지 않으면 B를 리턴해라
    
    if(x == 1) {
        return A
    } else if( x == 10) {
        return B
    } else if( x == 12) {
        return C
    } else if( x == 14) {
        return D
    } else {
        return E
    }
    
    --> DECODE 함수로 변형
    DECODE(x, 1, A, 10, B, 12, C, 14, D, E);
    x가 1이면 A, 10 이면 B, 12이면 C, 14이면 D, 다 아니면 E를 리턴
    
    --
    문제1) insa 테이블에서 ssn(주민번호) 생일을 얻어와서
        생일 지났으면 '생일 후', 오늘 생일이면 '오늘 생일', 생일 안지났으면 '생일 전'
    SELECT name, ssn
        , TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD' ) 생일
        , DECODE(SIGN( TO_DATE( SUBSTR( ssn, 3, 4 ), 'MMDD' ) - TRUNC( SYSDATE ) )
        , -1, '생일 후'
        , 0, '오늘 생일'
        , 1, '생일 전') 생일지남확인
    FROM insa;
    
    --
    문제2) insa 테이블에서 ssn을 가지고 남자/여자라고 성별을 출력
    SELECT name, ssn
        , DECODE( MOD( SUBSTR(ssn, -7, 1), 2), 1, '남자', '여자')
    FROM insa;


    문제3) insa 테이블에서 남자 사원수, 여자 사원수 출력
    SELECT COUNT(*) 총사원수
        , COUNT( DECODE( MOD( SUBSTR(ssn, -7, 1), 2), 1, '남자') ) 남자사원수
        , COUNT( DECODE( MOD( SUBSTR(ssn, -7, 1), 2), 0, '여자') ) 여자사원수
    FROM insa;
    
    -- 추가 설명 --
    SELECT ssn 
        , DECODE( MOD( SUBSTR(ssn, -7, 1), 2), 1, '남자') 남자사원수 -- 여자 사원은 null이 들어가짐
    FROM insa;
   
    
    문제4) emp 테이블에서 총사원수, 10번, 20번, 30번, 40번 부서사원수 출력
    SELECT COUNT(*) 총사원수
        , COUNT(DECODE( deptno, 10, 10)) "10번부서사원수"
        , COUNT(DECODE( deptno, 20, 20)) "20번부서사원수"
        , COUNT(DECODE( deptno, 30, 30)) "30번부서사원수"
        , COUNT(DECODE( deptno, 40, 40)) "40번부서사원수"
    FROM emp;
       
    
    문제5) emp 테이블에서 각 부서별 급여합 조회
    deptno, sal + NVL(comm, 0)
    SELECT SUM(sal + NVL(comm, 0)) total_pay
            , SUM( DECODE( deptno, 10, sal + NVL(comm, 0) )) pay_10
            , SUM( DECODE( deptno, 20, sal + NVL(comm, 0) )) pay_20
            , SUM( DECODE( deptno, 30, sal + NVL(comm, 0) )) pay_30
            , SUM( DECODE( deptno, 40, sal + NVL(comm, 0), 0 )) pay_40
    FROM emp;
    
    
    문제6) emp 테이블에서 각 사원들의 번호, 이름, 급여(pay) 출력
            10번 부서원이라면 급여 15% 인상
            20번 부서원이라면 급여 5% 인상
            나머지 부서원이라면 급여 10% 인상
        
    SELECT deptno, empno, ename, sal + NVL(comm, 0) pay
            , DECODE( deptno, 10, (sal + NVL(comm, 0)) * 1.15
                    , 20, (sal + NVL(comm, 0)) * 1.05
                    , (sal + NVL(comm, 0)) * 1.10 ) 인상된급여
    FROM emp;
    
    
    문제7) insa 테이블에서 각 사원이 소속된 부서의 갯수는 몇개?
    SELECT COUNT(DISTINCT buseo)
    FROM insa;

3) CASE() : DECODE 함수의 확장함수
    (1) 범위 비교가 가능하다.
    (2) IF~THEN~ELSE문장과 똑같은 결과를 출력할 수 있다.
    (3) 산술연산, 관계연산, 논리연산과 같은 다양한 비교가 가능하다.
    (4) WHEN 절에서 표현식을 다양하게 정의할 수 있다.
    
    【형식1】
        CASE 컬럼명|표현식 WHEN 조건1 THEN 결과1
                  [WHEN 조건2 THEN 결과2
                                    ......
                   WHEN 조건n THEN 결과n
                  ELSE 결과4]
        END [ALIAS 별칭]-- if문의 괄호 닫는 것과 같음
        
    【형식2】
        CASE 컬럼명|표현식 WHEN 조건1 THEN 결과1
                  [WHEN 조건2 THEN 결과2
                                    ......
                   WHEN 조건n THEN 결과n
                  ELSE 결과4]
        END [ALIAS 별칭]-- if문의 괄호 닫는 것과 같음       

------  
     문제1) emp 테이블에서 각 사원들의 번호, 이름, 급여(pay) 출력
            10번 부서원이라면 급여 15% 인상
            20번 부서원이라면 급여 5% 인상
            나머지 부서원이라면 급여 10% 인상
        
    SELECT deptno, empno, ename, sal + NVL(comm, 0) pay
        , CASE deptno
                WHEN 10 THEN (sal + NVL(comm, 0)) * 1.15
                WHEN 20 THEN (sal + NVL(comm, 0)) * 1.05
                ELSE (sal + NVL(comm, 0)) * 1.1
          END pay2
    FROM emp
    ORDER BY deptno ASC;
    
------  
    문제2) insa 테이블에서 ssn을 가지고 남/여 성별 출력
    SELECT name, ssn
        , CASE MOD(SUBSTR(ssn, -7, 1), 2)
            WHEN 1 THEN '남자'
            ELSE '여자'
          END 성별
        , CASE
            WHEN MOD(SUBSTR(ssn, -7, 1), 2) = 1 THEN '남자'
            ELSE '여자'
          END 성별2
        , CASE
            WHEN SUBSTR(ssn, -7, 1) IN(1,3,5,7,9) THEN '남자'
            ELSE '여자'
          END 성별3        
    FROM insa;
    
----------------------------------
3. SELECT 문 7개의 절 중에 GROUP BY 절 설명
        WITH
        SELECT
        FROM
        WHERE
        GROUP BY 절 설명
        HAVING
        ORDER BY
    
    문제1) insa 테이블에서 남자/여자 사원수 출력하는 쿼리 작성  
    SELECT MOD(SUBSTR(ssn, -7, 1) , 2), COUNT(*) "인원수"
    FROM insa
    GROUP BY MOD(SUBSTR(ssn, -7, 1) , 2);
    
    ----
    문제2) emp 테이블 각 부서의 사원 수 출력
        문제점 : 사원이 없는 부서는 아예 출력이 안된다.
    SELECT deptno, COUNT(*)
    FROM emp
    GROUP BY deptno
    ORDER BY deptno;




