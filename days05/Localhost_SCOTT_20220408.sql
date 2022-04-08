-- [ SCOTT에 접속된 스크립트 파일 ]

1. 오류 메시지에 대해서 설명하세요 .
 ㄱ. ORA-01438: value larger than specified precision allowed for this column
	-> 컬럼에 지정된 자료형의 크기보다 더 큰 값이 들어와서 발생한 오류
 ㄴ. ORA-00001: unique constraint (SCOTT.PK_DEPT) violated
		-> 고유키 무결성 위배된다.
 ㄷ. ORA-00923: FROM keyword not found where expected 
		-> FROM 절에서 에러 발생 철자 또는 , 확인 해보기
 ㄹ. ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
		-> 부모테이블 10,20,30,40 부서번호만 있는데 자식테이블에서 60부서 사원 추가한다고 하면 발생하는 에러

6. insa 테이블에서 남자는 'X', 여자는 'O' 로 성별(gender) 출력하는 쿼리 작성 @@@@@

-- 1번 다른 사람 풀이
SELECT t.*
      , REPLACE(REPLACE(t.gender, '1', 'X'), '2', 'O') GENDER
FROM(
    SELECT name, ssn
        , SUBSTR(ssn, -7, 1) gender
    FROM insa
) t;

-- 강사님 풀이
NULLIF 함수
두개의 값을 비교하여 두개의 값이 같으면 NULL 값 반환
같지 않으면 첫번째 매개변수값을 반환해주는 함수

SELECT name, ssn
    , SUBSTR(ssn, -7, 1) gender
    , MOD(SUBSTR(ssn, -7, 1), 2) gender
    , NVL2( NULLIF( MOD(SUBSTR(ssn, -7, 1), 2), 1 ), 'O', 'X') gender
FROM insa;

-- 숫자 : 왼쪽 정렬되어져 있으면 문자열 '1'
-- 숫자 : 오른쪽 정렬되어져 있으면 숫자 1

    NAME                 SSN            GENDER
    -------------------- -------------- ------
    홍길동               771212-1022432    X
    이순신               801007-1544236    X
    이순애               770922-2312547    O
    김정훈               790304-1788896    X
    한석봉               811112-1566789    X

7. insa 테이블에서 2000년 이후 입사자 정보 조회하는 쿼리 작성

SELECT name, ibsadate
FROM insa
-- WHERE TO_CHAR(ibsadate, 'RRRR') >= 2000
WHERE EXTRACT(YEAR FROM ibsadate) >= 2000
ORDER BY ibsadate ASC;

    NAME                 IBSADATE
    -------------------- --------
    이미성               00/04/07
    심심해               00/05/05
    권영미               00/06/04
    유관순               00/07/07
    
8-1. Oracle의 날짜를 나타내는 자료형 2가지를 적으세요.
   ㄱ. TIMESTAMP
   ㄴ. DATE
   
8-2. 현재 시스템의 날짜/시간 정보를 출력하는 쿼리를 작성하세요.

SELECT SYSDATE, CURRENT_DATE, CURRENT_TIMESTAMP
FROM dual;

SYSDATE는 함수이며, 현재시스템의 날짜 + 시간, 분, 초 단위까지의 정보를 가지고 있는 함수이다.
CURRENT_DATE는 함수이며, 현재 세션(session)의 날짜 + 시간, 분, 초 반환 / 데이터 타입은 그레고리언 캘린더
CURRENT_TIMESTAMP는 함수이며, 날짜 + 시간, 분, 초, 밀리세컨드 반환

10. emp 테이블에서 사원명(ename)에 'e'문자를 포함한 사원을 검색해서 아래와 같이 출력.

SELECT ename
    -- , REPLACE(ename, UPPER('e'), UPPER('[e]')) SEARCH_ENAME
    ,REPLACE(ename, UPPER( :input ), '[' || UPPER( :input ) || ']') SEARCH_ENAME
FROM emp
WHERE REGEXP_LIKE(ename, :input, 'i');
-- WHERE ename REGEXP_LIKE(ename, :변수명, 'i');

-- 입력할 수 있도록 바인드 변수(bind variable)를 준다.
:변수명
1) 바인드 변수라고 한다.
2) 세션(session)이 유지되는 동안 사용할 수 있는 변수

-----------------------------------------------------------------------

13. insa 테이블에서 
   ㄱ. 출신지역(city)가 인천인 사원의 정보(name,city,buseo)를 조회하고
   ㄴ. 부서(buseo)가 개발부인 사원의 정보(name,city,buseo)를 조회해서
   두 결과물의 합집합(UNION)을 출력하는 쿼리를 작성하세요. 
   ( 조건 : SET(집합) 연산자 사용 )
SELECT name, city, buseo
FROM insa
WHERE city = '인천'
UNION   
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부';

-- OR 연산자 사용하여 위와 같은 결과가 나옴
SELECT name, city, buseo
FROM insa
WHERE city = '인천' OR buseo = '개발부';

------------------------------------------------------------------------------
수업시작!!

1. SET 연산자

1) UNION ALL : 중복되더라도 모두 출력하겠다.
인천  인천 & 개발부    개발부
3명      6명          8명   UNION = 17명
                           UNION ALL = 3 + 6 + 6 + 8 = 23명

SELECT name, city, buseo
FROM insa
WHERE city = '인천'
UNION ALL  
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부';

아래와 같이 다른 테이블에 있는 것들을 UNION으로 활용하여 가져올 수 있다.
단, 가져오고자 하는 컬럼명의 자료형이 순서대로 동일해야 하고 가져올 컬럼명 갯수도 동일해야한다.
SELECT ename, sal
FROM emp
UNION
SELECT  name, ename
FROM insa;

----

2) MINUS : 차집합(교집합은 뺏기 때문에..)
-- 인천인데 개발부는 빼라

SELECT name, city, buseo
FROM insa
WHERE city = '인천'
MINUS
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부';

-- AND 연산자 사용하여 위와 같은 결과가 나옴
SELECT name, city, buseo
FROM insa
WHERE city = '인천' AND buseo != '개발부';

----

3) INTERSECT : 교집합

SELECT name, city, buseo
FROM insa
WHERE city = '인천'
INTERSECT
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부';

-- AND 연산자 사용하여 위와 같은 결과가 나옴
SELECT name, city, buseo
FROM insa
WHERE city = '인천' AND buseo = '개발부';

------------------------------------------------------------------------------

2. floating-point condition 연사자 종류-> 잘 사용할 일이 없다.
1) IS NAN : 숫자인지 아닌지 확인하는 연산자(Not A NUmber)
2) IS INFINITE : 무한대인지 아닌지 확인하는 연산자
3) IS NULL : 널의 유무를 확인하는 연산자

------------------------------------------------------------------------------

3. 함수 ------------
1) 복잡한 쿼리문 -> 간단히 처리(조작) -> 결과 반환(복잡한 쿼리문을 간단하게 해주고 데이터의 값을 조작하는데 사용되는 것을 함수라고 한다.)
   - 인자값은 데이터이고 그 결과를 처리하여 반환하는 기능을 수행한다.

--   
2) 함수 기능 --------------------------------------
    ㄱ. 데이터 계산 : 루트계산 SQRT(4)
    
    ㄴ. 데이터 항목 변경 : UPPER('a') 대문자로 변환
    
    ㄷ. 그룹의 결과를 출력 = 그룹합수(group function)
    ex) insa 테이블의 총 사원수가 몇 명인지 알고 싶을 때..
    SELECT COUNT(*) 총사원수 -- 총사원수가 된다..
    FROM insa;
    
    SELECT COUNT(*) 영업부사원수 -- 영업부 사원수..
    FROM insa
    WHERE buseo = '영업부';
    
    ㄹ. 날짜 형식을 변경 : TO_CHAR(데이터, 날짜형)
    
    ㅁ. 컬럼 데이터 타입 변경 == 형변환 함수
        날짜형 <-> 문자열 변환 
        문자열 <-> 숫자형 변환
        TO_CHAR는 중복함수(== 자바 용어로 오버로딩)
        TO_CHAR(날짜) -> 날짜형을 문자열로 형변환 해주는 함수
        TO_CHAR(숫자) -> 숫자를 문자열로..
        TO_CHAR(문자열) -> 문자열 내가 원하는 문자열로..

문제) emp 테이블에서 각 부서별 사원수와 총 사원수를 파악하고싶다 아래 출력 형식
        10번부서 : 3명
        20번부서 : 3명
        30번부서 : 6명
        40번부서 : 0명
        총사원수 : 12명

SELECT '10번부서 : ' || COUNT(*) || '명'
FROM emp
WHERE deptno = 10
UNION ALL
SELECT '20번부서 : ' || COUNT(*) || '명'
FROM emp
WHERE deptno = 20
UNION ALL
SELECT '30번부서 : ' || COUNT(*) || '명'
FROM emp
WHERE deptno = 30
UNION ALL
SELECT '40번부서 : ' || COUNT(*) || '명'
FROM emp
WHERE deptno = 40
UNION ALL
SELECT '총사원수 : ' || COUNT(*) || '명'
FROM emp;

--
3) 함수의 유형(종류) --------------------------------------
    ㄱ. 단일행 함수(Single_row) : 행(레코드)이 각각 실행되어 각각 보여주는 함수
    SELECT ename
        , UPPER(ename)
        , LOWER(ename)
    FROM emp;
    
    ㄴ. 복수행 함수(Group) == 그룹함수(집계함수) : 행(레코드)을 그룹화하여 결과를 보여줌
    
    SELECT COUNT(*)
    FROM emp;
    
----    
4) 단일행 함수 중에 '숫자 함수' --------------------------------------

    SELECT SQRT(4) -- 제곱근, 루트 값 가져오는 함수
            -- , SIN() , COS() , TAN() 사인, 코사인, 탄젠트 구하는 함수
            -- , LOG() -- 로그 구하는 함수
            -- , LN() -- 자연로그값 구하는 함수
            , POWER(2, 3) -- 누승(계승) 값 구하는 함수
            , MOD(5, 2) -- 나머지 구하는 함수
            , ABS(100) , ABS(-100) -- 절대값을 구하는 함수
    FROM dual;
    -- 오라클 숫자 자료형 : NUMBER
    
    ㄱ. ROUND(NUMBER , [+- 위치] ) -> number가 0이면 0을 반환
            - '특정 위치'에서 반올림하는 함수
            - 지정한 자리 이하(특정 위치)에서 반올림한 결과 값을 반환
            - ROUND(a, b)는 a를 소수점 이하 b+1자리에서 반올림하여 b자리까지 출력
                                         b값이 음수이면 소수점 왼쪽 b자리에서 반올림하여 출력
    
            SELECT 3.141592 PI
                , ROUND(3.141592) -- 3 : b가 없으면 소수점 첫번째 자리(b+1)에서 반올림 한다.
                , ROUND(3.641592) -- 4 : b가 없으면 소수점 첫번째 자리(b+1)에서 반올림 한다.
                , ROUND(3.141592, 0) -- 3 : 위의 쿼리가 b에 0을 줬다와 같은 의미
                , ROUND(3.641592, 0) -- 4
                , ROUND(3.141592, 2) -- 3.14 : 소수점 세번째 자리(b+1 = 2 + 1)에서 반올림
                , ROUND(123.141592, -1) -- 120 : b값이 음수이면 소수점 왼쪽의 b자리에서 반올림
                , ROUND(123.141592, -2) -- 100 : b값이 음수이면 소수점 왼쪽의 b자리에서 반올림
                -- -2를 주면 10의 자리에서 반올림
            FROM dual;
        
            문제) emp 테이블의 pay(sal+comm) 총급여합 / 총사원수 = 회사 평균 급여
                소수점 3번째 자리에서 반올림
            
            SELECT ROUND(SUM(sal + NVL(comm, 0)) / COUNT(*), 2)
            FROM emp;
            
            SELECT COUNT(*)
            FROM emp;
            
            -- SUM() 집계함수 == 그룹함수 == 복수행함수
            SELECT SUM(sal + NVL(comm, 0)) PAY
            FROM emp;
            
            -- 강사님이 풀어주신 것..
            SELECT ROUND( (SELECT  SUM( sal + NVL(comm, 0))  FROM emp ) / (SELECT COUNT(*) FROM emp) , 2 )  avg_pay
            FROM dual;

            
     ㄴ. 절삭(내림) 함수
        1) TRUNC(a, [+-위치]): 숫자값을 특정 위치(지정한 소수점 자리수 이하)에서 절삭하여 정수 또는 실수값 리턴
                              TRUNC(n) == FLOOR(n) == TRUNC(n, 0)
           TRUNC(a, b) -> a를 b+1 자리에서 절삭하여 출력, 음수이면 왼쪽 b자리에서 절삭
        2) FLOOR(n) : 숫자값을 소숫점 1번째 자리에서 절삭하여 정수값을 리턴 -> 실수값을 리턴 X
        
           SELECT 123.141592
                , FLOOR(123.141592) -- 123 : 소숫점 1번째 자리에서 절삭
                , FLOOR(123.941592) -- 123 : 소숫점 1번째 자리에서 절삭
                , TRUNC(123.941592) -- 123
                , TRUNC(123.941592, 0) -- 123
                , TRUNC(123.941592, 1) -- 123.9 : 소숫점 2번째 자리에서 절삭 (b+1)
                , TRUNC(123.941592, -1) -- 120 : 일의 자리에서 절삭
           FROM dual;
           
    ㄷ. CEIL() : 소숫점 첫 번째 자리에서 올림하는 함수
                특정 위치에서 올림하는 함수는 X
        SELECT CEIL(3.141592) -- 4
              , CEIL(3.941592) -- 4
        FROM dual;

        문제) 게시판에서
             총 게시글 수 : 652
             한 페이지에 출력할 게시글 수 : 15
             총 페이지 수는 ?
             652 / 15 = 43.4666 나오기 때문에 올림 함수 사용하여 페이지는 44페이지!
             SELECT CEIL(652 / 15)
             FROM dual;
             
        문제) 소수점 3자리에서 올림(절상) 1234.57 -> 절상하고자 하는 위치를 소수점 1째 자리로 만들자
        SELECT 1234.5678
            , 1234.5678 * 100
            , CEIL(1234.5678 * 100 )
            , CEIL(1234.5678 * 100 ) / 100
        FROM dual;
        
        문제) 1234.5678를 십의 자리에서 절상(올림) 1300
        SELECT CEIL(1234.5678 / 100) * 100
        FROM dual;
        
    ㄹ. SIGN : 숫자의 값에 따라 1, 0, -1의 값을 반환하는 함수
        [형식] SIGN(number)
            number값   반환되는 값 
            양수          +1 
            음수          -1 
             0            0 
             
        SELECT SIGN(100), SIGN(0), SIGN(-100)
        FROM dual;
        
        문제) emp 테이블에 평균 급여보다 많이 받으면 1 적게 받으면 -1 같으면 0이 출력되도록 하자
                                             많다           적다        같다
        
        SELECT ename, sal + NVL(comm, 0) PAY
            , ROUND(AVG(sal + NVL(comm, 0)) , 2) AVG_PAY
        FROM emp;
        
        ***** 에러 메시지 : ORA-00937: not a single-group group function
                해석 : 단일 그룹, 그룹 함수가 아니다.
                이유 : 복수행 함수하고 일반행 칼럼은 같이 사용할 수 없음
                      ename과 sal + NVL(comm, 0)은 각각 행이 출력이 되고
                      AVG 집계 함수로 그룹을 묶어서 하나의 행만 출력 되기 때문에
                해결 :             
                   SELECT ename, sal + NVL(comm, 0) PAY
                        , (SELECT ROUND(AVG(sal + NVL(comm, 0)) , 2) FROM emp ) AVG_PAY
                   FROM emp;  

       SELECT t.*
            , ABS(t.pay - t.avg_pay) 급여차이
            , SIGN(t.pay - t.avg_pay)
            , NVL2( NULLIF(SIGN(t.pay - t.avg_pay), 1), '평균 급여보다 적다', '평균 급여보다 많다')
       FROM(
            SELECT ename, sal + NVL(comm, 0) PAY
            , (SELECT ROUND(AVG(sal + NVL(comm, 0)) , 2) FROM emp ) AVG_PAY
            FROM emp
       ) t;
       
        
       SELECT ROUND(AVG(sal + NVL(comm, 0)) , 2) AVG_PAY
       FROM emp;

----    
5) 단일행 함수 중에 '문자 함수' --------------------------------------

SELECT 'kBs'
    , UPPER('kBs') -- 대문자 변환하는 함수
    , LOWER('kBs') -- 소문자 변환하는 함수
    , INITCAP('admin') -- 첫문자만 대문자로 변환하는 함수
FROM dual;

SELECT job
       , LENGTH(job) -- 문자열 길이를 가져오는 함수
       , CONCAT(empno, ename) -- 문자열 연결하는 함수
       --  SUBSTR() -- 지정한 위치부터 원하는 길이만큼 잘라오는 함수
FROM emp;


    ㄱ. INSTR(string, substring [, position [,occurrence] ]) 함수
        - 문자열 중에서 찾고자 하는 문자가 우측/좌측으로부터 처음 나타나는 위치를 숫자 반환
        - 찾는 문자가 없으면 0을 반환
        - position : 문자열을 찾기 시작할 위치
        - occurrence : 문자열이 n번째에 나타나는 위치(발생 순서)
    
    예시1)
    SELECT ename
        , INSTR(ename, 'I') -- I가 있는 문자열의 위치를 찾음
        , INSTR(ename, 'IN')
    FROM emp;
    
    예시2)
    SELECT INSTR('corporate floor','or') -- 2 : or이 처음 나타나는 위치값
            , INSTR('corporate floor','or', 3) -- 5 : 찾기 시작하는 위치(r 부터)부터 처음 나타나는 위치값
            , INSTR('corporate floor','or', 3, 2) -- 14 : 찾기 시작하는 위치(r부터)부터 2번째에 나타나는 위치값
            , INSTR('corporate floor','or', -3, 2) -- 뒤에서 3번째 부터 찾기 시작
    FROM dual;
    
    문제) 전화번호를 가지고 있는 테이블 선언(우리가 만든 테이블에는 TBL_ 이라는 접두사 붙이자!)
         테이블 이름 : TBL_TEL
         번호(순번) NUMBER
         전화번호   02)123-1234
                  054)7233-2323
                  031)9837-2933
        
     -- CREATE TABLE 테이블명 이렇게 안하고 메뉴로 추가
     
     SELECT *
     FROM tbl_tel;
     
     문제) 오라클 숫자, 문자 함수를 사용해서
     전화번호의 지역번호만 출력, 가운데 4자리만 출력, 뒤 4자리 출력
         
     SELECT no, tel
            , INSTR(tel, ')' ) AS ")위치값"
            , INSTR(tel, '-' ) AS "-위치값"
            , SUBSTR(tel, 0, INSTR(tel, ')' ) - 1) 지역번호
            , SUBSTR(tel, INSTR(tel, ')' ) + 1, INSTR(tel, '-' ) - INSTR(tel, ')' ) - 1) 전번1
            , SUBSTR(tel, INSTR(tel, '-' ) + 1 ) 전번2
     FROM tbl_tel;  
     
     [출력 양식]
     번호(no) 지역번호 전번1 전번2
     
     -- 
     ㄴ. RPAD / LPAD : 지정된 길이에서 문자값을 채우고 남은 공간을 우(좌)측부터 특정값으로 채워 반환하는 함수
     【형식】
      RPAD (expr1, n [, expr2] )

     SELECT ename, sal + NVL(comm, 0) PAY
            -- expr2를 안주면 공백으로 채워짐
            , LPAD('\' || (sal + NVL(comm, 0)), 10, '*' ) -- 총 자리수를 10자리 확보하고 왼쪽으로부터 남는 자리를 *을 준다.
            , RPAD(sal + NVL(comm, 0), 10, '*' ) -- 오른쪽으로부터 공백을 * 채움
     FROM emp;
    
    --  LPAD('\' || sal + NVL(comm, 0), 10, '*' ) -> \ 통화단위를 넣으니까 에러 발생
    -- 에러메시지 : ORA-01722: invalid number
    -- 해결 : ( sal + NVL(comm, 0) ) -> () 묶어서 처리
    
    문제) 그래프 그리기
    
    SELECT ename, sal + NVL(comm, 0) PAY
            , ROUND( (sal + NVL(comm, 0)) / 100) "#갯수"
            , RPAD(' ', ROUND( (sal + NVL(comm, 0)) / 100)+1, '#')
    FROM emp;
    
    SMITH	800 ########
    ALLEN	1900 ###################
    WARD	1750 ##################
    JONES	2975 ################################# 30개
    MARTIN	2650
    BLAKE	2850
    CLARK	2450
    KING	5000
    TURNER	1500
    JAMES	950
    FORD	3000
    MILLER	1300
    
    문제2)
    SELECT name, ssn
        , RPAD( SUBSTR(ssn, 0, 8), 14, '*')
    FROM insa;
    
    --
    ㄷ. ASCII(char) -> char 문자를 ASCII 코드 값으로 반환 오라클 문자 자료형 : char
    ㄹ. CHR(ASCII 코드값) -> ASCII 코드 값을 문자로 반환
    SELECT ename
            , SUBSTR(ename, 0 ,1)
            , ASCII( SUBSTR(ename, 0 ,1) )
            , ASCII( '가' ) -- 3바이트
            , CHR(83)
            , CHR( ASCII( SUBSTR(ename, 0 ,1) ) )
    FROM emp;
    
    --
    ㅁ. GREATEST( ?, ?, ? ...)
    ㅂ. LEAST( ?, ?, ?)
    
    SELECT
        GREATEST(500, 10, 200, 800) -- 가장 큰 값 가져옴 : 800
        , LEAST(500, 10, 200) -- 가장 작은 값 가져옴 : 10
        , GREATEST('KBS', 'ABC', 'XYZ') -- 가장 큰 값 : X가 제일 크다고 판단해서 XYZ를 가져옴
    FROM dual;
    
    ㅅ. REPLACET() ㅇ. VSIZE() -> 이전에 다뤘던 함수들

----    
6) 단일행 함수 중에 '날짜 함수' --------------------------------------

SELECT SYSDATE, CURRENT_DATE, CURRENT_TIMESTAMP
FROM dual;

    ㄱ. 날짜형 반올림, 절삭 가능한 함수 (숫자 함수에 있는 것과 동일..)
    TRUNC(date) 날짜 절삭(내림) -> 자주 사용
    ROUND(date [,format]) 날짜 반올림, 정오(오후 12시)를 기준으로 반올림 -> 자주 사용하지는 않음
    
    SELECT SYSDATE -- 22/04/08
            , ROUND(SYSDATE) -- 22/04/09
            , ROUND(SYSDATE, 'DD') -- 날짜 기준으로 15가 지나면 반올림
            , ROUND(SYSDATE, 'MM') -- 15일이 안지나서 1일로 만들어 버림
            , ROUND(SYSDATE, 'YY') -- 월의 반이 안지나서 1월로 만들어 버림
            , ROUND(SYSDATE, 'DAY') -- 요일의 반이 지나서 일자를 반올림
    FROM dual;
    
    
    SELECT CURRENT_TIMESTAMP
        , TRUNC(CURRENT_TIMESTAMP) -- 시간, 분, 초, ms 다 절삭해서 날짜만 보여짐
    FROM dual;
    
    SELECT SYSDATE -- 22/04/08 16:46:50
        , TRUNC(SYSDATE) -- 22/04/08 00:00:00
        , TRUNC(SYSDATE, 'DD') -- 22/04/08
        , TRUNC(SYSDATE, 'MM') -- 22/04/01
        , TRUNC(SYSDATE, 'YY') -- 22/01/01
    FROM dual;
    
    설문조사를 할 때 사용한다.
    날짜는 안지났는데 시간이 지나서 투표를 못하게 되는 경우 TRUNC() 사용하여 시간 절삭
    
    --
    ㄴ. 날짜에 산술 연산을 사용하는 경우 반환되는 데이터 타입
    날짜형 + 숫자 = 날짜형
    날짜형 - 숫자 = 날짜형
    날짜형 - 날짜 = 일수차(숫자)
    날짜형 + 숫자/24(시간) = 날짜형
    
    SELECT SYSDATE -- 22/04/08
        , SYSDATE + 3 -- 22/04/11 : 3일이 더해진 날짜
        , SYSDATE - 3 -- 22/04/05 : 3일이 빠진 날짜
    FROM dual;
    
    SELECT CURRENT_TIMESTAMP -- 22/04/08 16:40:37.263000000 ASIA/SEOUL
        , CURRENT_TIMESTAMP + 3 -- 22/04/11 : 3일이 더해진 날짜
    FROM dual;
    
    문제) emp 테이블에서 사원들의 근무일수 조회
    
    SELECT ename, hiredate -- DATE 날짜자료형
            , SYSDATE -- DATE 날짜자료형
            , CEIL( ABS( hiredate - SYSDATE ) ) "근무일수" -- 날짜-날짜 = 근무일수 : 소수점은 시간 
            -- 지금부터 2시간 후에 만나
            , TO_CHAR(SYSDATE + 2/24, 'YYYY/MM/DD HH24:MI:SS')
    FROM emp;
    
    --
    ㄷ. MONTHS_BETWEEN  월요일~~
    
    
    