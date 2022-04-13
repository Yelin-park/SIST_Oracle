-- [ SCOTT에 접속된 스크립트 파일 ]
---- 복습문제 중 새로운 개념 또는 못푼거 ----

1. emp , salgrade 테이블을 사용해서 아래와 같이 출력.
1-2. emp , salgrade 테이블을 사용해서 아래와 같이 출력. [JOIN] 사용

    SELECT ename, sal + NVL(comm, 0) pay, grade
    FROM emp e, salgrade s
    WHERE sal + NVL(comm, 0) BETWEEN s.losal AND s.hisal;
    
    ename   sal    grade
    ---------------------
    SMITH	800	    1
    ALLEN	1900	3
    WARD	1750	3
    JONES	2975	4
    MARTIN	2650	4
    BLAKE	2850	4
    CLARK	2450	4
    KING	5000	5
    TURNER	1500	3
    JAMES	950	    1
    FORD	3000	4
    MILLER	1300	2

1-3.  위의 결과에서 등급(grade)가 1등급인 사원만 조회하는 쿼리 작성

    SELECT t.*
    FROM
    (
        SELECT empno, ename, sal + NVL(comm, 0) pay, grade
        FROM emp e, salgrade s
        WHERE sal + NVL(comm, 0) BETWEEN s.losal AND s.hisal
    ) t
    WHERE t.grade = 1;
   

2. emp 에서 최고급여를 받는 사원의 정보 출력

DNAME          ENAME             PAY
-------------- ---------- ----------
ACCOUNTING     KING             5000

    SELECT dname, ename
        , sal + NVL(comm, 0) pay
    FROM dept d, emp e
    WHERE d.deptno = e.deptno AND sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp);
    
    SELECT dname, ename
        , sal + NVL(comm, 0) pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp);

2-2. emp 에서 각 부서별 최고급여를 받는 사원의 정보 출력

    DEPTNO DNAME          ENAME             PAY
---------- -------------- ---------- ----------
        10 ACCOUNTING     KING             5000
        20 RESEARCH       FORD             3000
        30 SALES          BLAKE            2850
    
    풀이1) 상관서브쿼리
    SELECT d.deptno, dname, ename, sal + NVL(comm, 0) pay
    FROM dept d, emp e
    WHERE d.deptno = e.deptno
        AND sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = d.deptno)
    ORDER BY d.deptno ASC;
    
    풀이2) 순위함수
    SELECT *
    FROM(
        SELECT d.deptno, dname, ename, sal + NVL(comm, 0) pay
            , RANK() OVER(PARTITION BY deptno ORDER BY sal + NVL(comm, 0) DESC) pay_rank
        FROM emp e JOIN dept d ON e.deptno = d.deptno
    ) t
    WHERE pay_rank = 1;
    
    풀이3)
    SELECT t.deptno, d.dname, t.ename, t.pay, t.pay_rank
    FROM(
        SELECT deptno, ename, sal + NVL(comm, 0) pay
            , RANK() OVER(PARTITION BY deptno ORDER BY sal + NVL(comm, 0) DESC) pay_rank
        FROM emp
    ) t JOIN dept d ON t.deptno = d.deptno
    WHERE pay_rank = 1;
    
    
3. emp 에서 각 사원의 급여가 전체급여의 몇 %가 되는 지 조회.
--       ( %   소수점 3자리에서 반올림하세요 )
--            무조건 소수점 2자리까지는 출력.. 7.00%,  3.50%     

ENAME             PAY   TOTALPAY 비율     
---------- ---------- ---------- -------
SMITH             800      27125   2.95%
ALLEN            1900      27125   7.00%
WARD             1750      27125   6.45%
JONES            2975      27125  10.97%
MARTIN           2650      27125   9.77%
BLAKE            2850      27125  10.51%
CLARK            2450      27125   9.03%
KING             5000      27125  18.43%
TURNER           1500      27125   5.53%
JAMES             950      27125   3.50%
FORD             3000      27125  11.06%
MILLER           1300      27125   4.79%

    SELECT t.ename, t.pay, t.totalpay
            , TO_CHAR(ROUND(t.pay / t.totalpay * 100, 2), '99.00') || '%' 비율
    FROM
    (
        SELECT ename, sal + NVL(comm, 0) pay
            , (SELECT SUM(sal + NVL(comm, 0)) FROM emp) totalpay
        FROM emp
    ) t;


4. emp 에서 가장 빨리 입사한 사원 과 가장 늦게(최근) 입사한 사원의 차이 일수 ? 

    SELECT MAX(hiredate) - MIN(hiredate)
    FROM emp;

[새로운 개념!! FIRST_VALUE, LAST_VALUE 분석 함수] 
    FIRST_VALUE는 분석 함수로 정렬된 값중에서 [현재 행까지의 첫 번째 값]을 반환한다.
    만약 첫번째가 NULL이라면, IGNORE NULLS를 지정하지 않았다면 NULL을 반환하게 된다.
    LAST_VALUE 함수도 분석 함수로 정렬된 값중에서 [현재 행까지의 마지막 값]을 반환하는 함수이다.

    【형식】
	FIRST_VALUE ? LAST_VALUE (expr [IGNORE NULLS] )
	 OVER (
		[PARTITION BY expr2] [,...]
		ORDER BY expr3 [collate_clause] [ASC ? DESC]
		[NULLS FIRST ? NULLS LAST])
	) 
    
    SELECT ename, hiredate
        , FIRST_VALUE(hiredate) OVER(ORDER BY hiredate DESC) F1
        , FIRST_VALUE(hiredate) OVER(ORDER BY hiredate ASC) F2
        , LAST_VALUE(hiredate) OVER(ORDER BY hiredate DESC) L1
        , LAST_VALUE(hiredate) OVER(ORDER BY hiredate ASC) L2
    FROM emp;

    SELECT FIRST_VALUE(ename) OVER(ORDER BY hiredate DESC) a
    FROM emp;
    
5. insa 에서 사원들의 만나이 계산해서 출력
  ( 만나이 = 올해년도 - 출생년도          - 1( 생일이지나지 않으면) )

    SELECT CASE t.생일확인
            WHEN -1 THEN t.now - t.byear - 1
            ELSE t.now - t.byear
           END 만나이
    FROM(  
        SELECT ssn, TO_CHAR(SYSDATE, 'YYYY') now
            , CASE
                WHEN SUBSTR(ssn, -7, 1) IN (1,2,5,6)THEN 1900 + SUBSTR(ssn, 0, 2)
                WHEN SUBSTR(ssn, -7, 1) IN (3,4,7,8)THEN 2000 + SUBSTR(ssn, 0, 2)
                ELSE 1800 + SUBSTR(ssn, 0, 2)
              END byear
            , SIGN(TRUNC(SYSDATE) - TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD')) 생일확인
        FROM insa
    ) t

  
6. insa 테이블에서 아래와 같이 결과가 나오게 ..
     [총사원수]      [남자사원수]      [여자사원수] [남사원들의 총급여합]  [여사원들의 총급여합] [남자-max(급여)] [여자-max(급여)]
---------- ---------- ---------- ---------- ---------- ---------- ----------
        60                31              29           51961200                41430400                  2650000          2550000
      
    SELECT COUNT(*) 총사원수
        , COUNT(DECODE( MOD(SUBSTR(ssn, -7, 1), 2), 1, '남' )) 남자사원수
        , COUNT(DECODE( MOD(SUBSTR(ssn, -7, 1), 2), 0, '여' )) 여자사원수
        , SUM(DECODE( MOD(SUBSTR(ssn, -7, 1), 2), 1, basicpay )) 남자사원들의총급여합
        , SUM(DECODE( MOD(SUBSTR(ssn, -7, 1), 2), 0, basicpay )) 여자사원들의총급여합
        , MAX(DECODE( MOD(SUBSTR(ssn, -7, 1), 2), 1, basicpay )) 남자사원최고급여
        , MAX(DECODE( MOD(SUBSTR(ssn, -7, 1), 2), 0, basicpay )) 여자사원최고급여
    FROM insa;


7. TOP-N 방식으로 풀기 ( ROWNUM 의사 컬럼 사용 )
   emp 에서 최고급여를 받는 사원의 정보 출력  
  
    DEPTNO ENAME             PAY   PAY_RANK
---------- ---------- ---------- ----------
        10 KING             5000          1

    SELECT t.*, ROWNUM pay_rank
    FROM(
        SELECT deptno, ename, sal + NVL(comm, 0) pay
        FROM emp
        ORDER BY pay DESC
    )t
    WHERE ROWNUM = 1;
        
        
8-1.순위(RANK) 함수 사용해서 풀기 
   emp 에서 각 부서별 최고급여를 받는 사원의 정보 출력
   
    DEPTNO ENAME             PAY DEPTNO_RANK
---------- ---------- ---------- -----------
        10 KING             5000           1
        20 FORD             3000           1
        30 BLAKE            2850           1

    1번 풀이) 순위함수
    SELECT t.*
    FROM(
        SELECT deptno, ename, sal + NVL(comm, 0) pay
                , RANK() OVER(PARTITION BY deptno ORDER BY sal + NVL(comm, 0) DESC) deptno_rank
        FROM emp
    ) t
    WHERE t.deptno_rank = 1;

    2번 풀이) JOIN 
    SELECT t.deptno, e.ename, e.sal + NVL(e.comm,0)
    FROM(
        SELECT deptno, MAX(sal + NVL(comm,0)) maxpay
        FROM emp
        GROUP BY deptno
    ) t, emp e
    WHERE t.deptno = e.deptno AND t.maxpay = e.sal + NVL(e.comm,0);


8-2. 상관()서브쿼리를 사용해서 풀기 
   emp 에서 각 부서별 최고급여를 받는 사원의 정보 출력
 
    SELECT deptno, ename, sal + NVL(comm, 0) pay
    FROM emp e
    WHERE sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = e.deptno)
    ORDER BY deptno;

9.  emp테이블에서 각 부서의 사원수, 부서총급여합, 부서평균을 아래와 같이 출력하는 쿼리 작성.
결과)
    DEPTNO       부서원수       총급여합    	     평균
---------- ---------- 		---------- 	----------
        10          3      	 8750    	2916.67
        20          3     	  6775    	2258.33
        30          6     	 11600    	1933.33      
        
        
    SELECT deptno, COUNT(*)
        , SUM(sal + NVL(comm, 0)) 총급여합
        , ROUND(AVG(sal + NVL(comm, 0)), 2) 평균
    FROM emp
    GROUP BY deptno
    ORDER BY deptno;
         
10-1.  emp 테이블에서 30번인 부서의 최고, 최저 SAL을 출력하는 쿼리 작성.
결과)
  MIN(SAL)   MAX(SAL)
---------- ----------
       950       2850

    SELECT MIN(sal + NVL(comm, 0)) min, MAX(sal + NVL(comm, 0)) max
    FROM emp
    WHERE deptno = 30;

[새로운 개념!!! HAVING 절]
    GROUP BY와 꼭 같이 사용해야함
    그룹으로 묶여진 결과 내에서 조건을 주는 것
    WITH
    SELECT
    FROM
    WHERE
    GROUP BY
    HAVING : GROUP BY의 조건절
    ORDER BY

SELECT deptno, MAX(sal), MIN(sal)
FROM emp
GROUP BY deptno
HAVING deptno = 30; -- 그룹으로 묶여진 결과 내에서 조건을 주는 것

10-2.  emp 테이블에서 30번인 부서의 최고, 최저 SAL를 받는 사원의 정보 출력하는 쿼리 작성.

결과)
     EMPNO ENAME      HIREDATE        SAL
---------- ---------- -------- ----------
      7698 BLAKE      81/05/01       2850
      7900 JAMES      81/12/03        950

    SELECT empno, ename, hiredate, sal
    FROM emp
    WHERE deptno = 30 AND sal IN( (SELECT MAX(sal) FROM emp WHERE deptno = 30)
                                    , (SELECT MIN(sal) FROM emp WHERE deptno = 30));
    
    --WHERE deptno = 30 AND sal IN( (SELECT MAX(sal), MIN(sal) FROM emp WHERE deptno = 30) )
    --ORA--0913: too many values
    --서브쿼리를 위와 같이 사용하면 에러 발생
    
    SELECT empno, ename, hiredate, sal
    FROM(
        SELECT MAX(sal) maxsal, MIN(sal) minsal
        FROM emp
        WHERE deptno = 30
    )t, emp e
    WHERE e.deptno = 30 AND t.maxsal = e.sal OR t.minsal = e.sal;



11.  insa 테이블에서 
[실행결과]                                   부서/전체 부서성별/전체   해당성별/부서인원
부서명     총사원수 부서사원수 성별  성별사원수    부/전%   부성/전%        성/부%
개발부	    60	    14	      F	    8	    23.3%	13.3%	    57.1%
개발부	    60	    14	      M	    6	    23.3%	10%	    42.9%
기획부	    60	    7	      F	    3	    11.7%	5%	4       2.9%
기획부	    60	    7	      M	    4	    11.7%	6.7%	    57.1%
영업부	    60	    16	      F	    8	    26.7%	13.3%	    50%
영업부	    60	    16	      M	    8	    26.7%	13.3%	    50%
인사부	    60	    4	      M	    4	    6.7%	6.7%	    100%
자재부	    60	    6	      F	    4	    10%	    6.7%	    66.7%
자재부	    60	    6	      M	    2	    10%	    3.3%	    33.3%
총무부	    60	    7	      F	    3	    11.7%	5%	        42.9%
총무부	    60	    7	      M 	4	    11.7%	6.7%	    57.1%
홍보부	    60	    6	      F	    3	    10%	    5%	        50%
홍보부	    60	    6	      M	    3	    10%	    5%	        50%             


    WITH temp AS(
        SELECT t.buseo
            , (SELECT COUNT(*) FROM insa ) 총사원수 -- 서브쿼리
            , (SELECT COUNT(*) FROM insa WHERE buseo = t.buseo) 부서사원수 -- 상관서브쿼리
            , 성별
            , COUNT(*) 성별사원수 -- 2차적으로 그룹바이한 것으로 집계됨
        FROM(   -- 인라인뷰
            SELECT buseo, name, ssn
                , DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 1, 'M', 'F') 성별
            FROM insa
        ) t
        GROUP BY buseo, 성별 -- 부서별로 모이고 그 부서 안에서 성별로 모여라
        ORDER BY buseo, 성별
    )
    SELECT temp.*
        , ROUND(부서사원수/총사원수 * 100, 2) || '%' "부서인원/전체인원%"
        , ROUND(성별사원수/총사원수 * 100, 2) || '%' "부성인원/전체인원%"
        , ROUND(성별사원수/부서사원수 * 100, 2) || '%' "부성인원/부서인원%"
    FROM temp
    ;

----
다른학생의풀이)
SELECT t1.buseo,
    (SELECT COUNT(*) FROM insa) 총사원,
    t2.부서별,
    DECODE(t1.gender,1,'M','F') gender,
    t1.성별,
    ROUND(t2.부서별/(SELECT COUNT(*) FROM insa)*100,1) || '%' "부/전",
    ROUND(t1.성별/(SELECT COUNT(*) FROM insa)*100,1) || '%' "성/전",
    ROUND(t1.성별/t2.부서별*100,1) || '%' "성/부"
FROM (
    SELECT buseo, 
        MOD(SUBSTR(ssn, -7, 1),2) gender,
        COUNT(*) 성별
    FROM insa
    GROUP BY buseo, MOD(SUBSTR(ssn, -7, 1),2)
) t1 JOIN (
    SELECT buseo,
        COUNT(*) 부서별
    FROM insa
    GROUP BY buseo
) t2
ON t1.buseo = t2.buseo
ORDER BY t1.buseo;


[새로운개념!! GROUP BY와 HAVING 절 사용]
12. insa테이블에서 여자인원수가 5명 이상인 부서만 출력.
    
    풀이1) GROUP BY와 HAVING 절 사용
    SELECT buseo, COUNT(*)
    FROM insa
    WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 0
    GROUP BY buseo
    HAVING COUNT(*) >= 5;
    
    풀이2) 서브쿼리
    SELECT *
    FROM(
        SELECT buseo, COUNT(*) 여자사원수
        FROM insa
        WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 0
        GROUP BY buseo
    ) t
    WHERE 여자사원수 >= 5;

13. insa 테이블에서 급여(pay= basicpay+sudang)가 상위 15%에 해당되는 사원들 정보 출력 

    SELECT buseo, name, pay, pay_rank
    FROM(
        SELECT buseo, name, basicpay + sudang pay
            , (SELECT COUNT(*) * 0.15 FROM insa) toppay
            , RANK() OVER(ORDER BY basicpay + sudang DESC) pay_rank
        FROM insa
    ) t
    WHERE pay_rank <= toppay;


14. emp 테이블에서 sal의 전체사원에서의 등수 , 부서내에서의 등수를 출력하는 쿼리 작성
    
    풀이1) 순위함수 사용
    SELECT deptno, ename, sal
        , RANK() OVER(ORDER BY sal DESC) 전체등수
        , RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) 부서등수
    FROM emp
    ORDER BY deptno;
    
    풀이2) 상관서브쿼리 사용 
    SELECT deptno, ename, sal
        , (SELECT COUNT(*) FROM emp WHERE sal > e.sal ) + 1 전체등수 -- 밖에 있는 sal보다 내부에 있는 sal이 더 큰 갯수
        , (SELECT COUNT(*) + 1 FROM emp WHERE sal > e.sal AND deptno = e.deptno) 부서내등수
    FROM emp e
    ORDER BY deptno, 부서내등수;
    
----------------------------------------------------------------------------------------------
새로운 개념!!
1. [TRIM('특정문자' FROM 문자열) 함수]
    문제) 앞 뒤에 있는 특정문자를 제거하고싶다.
        SELECT '***AD**MIN***'
       -- , REPLACE('***ADMIN***', '*', '') -- 중간에 있는 별도 제거가 됨
        , TRIM('*' FROM '***AD**MIN***')
        , TRIM(' ' FROM ' ADMIN')
    FROM dual;

-----
2. [NLS??]
    TO_CHAR(숫자날짜, 'fmt' [,nls param])
    nls param == nls param(매개변수, 인자)
    --
    NLS? National Language Support
    NLS parameter는 SESSION, CLIENT, SERVER의 세 가지로 분류된다.
    이 세 가지 분류의 우선 순위는 다음과 같다.
    SESSION > CLIENT > SERVER
    server, client, session의 환경이 서로 다르다면, session에서 설정한 환경을 따라 가게 된다.
     예) 오라클 서버가 미국에 있고(서버) 나는 한국에서 접속(클라이언트)해서 날짜를 찍어보면 한국형 날짜가 찍힌다(클라이언트)
        만약 로그인하고 로그아웃할 때 까지 날짜형식을 일본날짜로 했으면 세션동안 일본날짜가 찍힌다.
        
    SELECT ename, sal, TO_CHAR(hiredate, 'YY/MON/DAY', 'NLS_DATE_LANGUAGE = JAPANESE')
    FROM emp;
    
    SELECT * FROM nls_session_parameters;
    
----------
3. [GROUP BY절, HAVING 절]

    SELECT
        COUNT(*) 전체사원수
        , COUNT(DECODE(deptno, 10, 'o')) "10번부서사원수"
        , COUNT(DECODE(deptno, 20, 'o')) "20번부서사원수"
        , COUNT(DECODE(deptno, 30, 'o')) "30번부서사원수"
        , COUNT(DECODE(deptno, 40, 'o')) "40번부서사원수"
    FROM emp;


    -- 각 부서별 사원수 파악 -> 40번 사원 X
    UNION은 컬럼 갯수와 형식이 일치해야 된다.
    SELECT 0 deptno, COUNT(*)
    FROM emp
    UNION
    SELECT deptno, COUNT(*)
    FROM emp
    GROUP BY deptno
    ORDER BY deptno

문제1) emp 테이블에서
    첫번째 20번, 40번 부서는 제외하고
    두번째 그 외 부서의 사원수를 계산하고
    세번째 그 사원수가 4명 이상인 부서정보를 조회
    부서번호, 부서명, 사원수 출력

    SELECT DISTINCT t.deptno, t.dname, t.사원수
    FROM(
         SELECT e.deptno, dname 
             , (SELECT COUNT(*) FROM emp WHERE deptno = e.deptno) 사원수
         FROM emp e JOIN dept d ON e.deptno = d.deptno
         WHERE e.deptno NOT IN(20, 40)
    ) t
    WHERE 사원수 >= 4;
    
    강사님 풀이)
    SELECT t.*, dname
    FROM (
        SELECT deptno, COUNT(*) 사원수
        FROM emp
        WHERE deptno NOT IN(20, 40)
        GROUP BY deptno
    ) t JOIN dept d ON t.deptno = d.deptno
    WHERE 사원수 >= 4;
    
    
    그룹화 집계 + 조건(HAVING) 사용)
    *** 집계함수 외에 모든 것들은 GROUP BY 절에 넣어야 함. ***
    -- ORA-00918: column ambiguously defined   -> 에러 매우 많이 발생함..
    SELECT e.deptno, dname, COUNT(*)
    FROM emp e JOIN dept d ON e.deptno = d.deptno
    WHERE e.deptno NOT IN(20, 40)
    GROUP BY e.deptno, dname -- 집계함수 외에 모든 것들은 GROUP BY 절에 넣어야 함.
    HAVING COUNT(*) >= 4;
    

문제2) insa 테이블에서 각 부서별 안에 있는 직급별 사원수 출력
    SELECT buseo, jikwi, COUNT(*) 사원수
    FROM insa
    GROUP BY buseo, jikwi
    ORDER BY buseo, jikwi;

문제3) insa 테이블에서 남자사원들만 부서별로 사원수를 구해서 6명 이상인 부서만 출력
    SELECT buseo, COUNT(*)
    FROM insa
    WHERE MOD(SUBSTR(ssn, -7, 2), 2) = 1
    GROUP BY buseo
    HAVING COUNT(*) >= 6;

-----
4. [GROUP BY 절에서 ROLLUP과 CUBE 조건]
    1) ROLLUP 연산자
        (1) ROLLUP은 GROUP BY 절의 그룹 조건에 따라 전체 행을 그룹화 하고
        (2) 각 그룹에 대해 부분합을 구하는 연산자이다.
    2) CUBE 연산자
     (1) ROLLUP 연산자를 수행한 결과에 더해 GROUP BY 절에 기술된 조건에 따라 모든 가능한 그룹핑 조합에 대한 결과를 출력한다.
     
     GROUP BY 조건이 1개면 다를게 없지만 조건이 여러 개이면 결과 값이 달라진다.
     GROUP BY 뒤에 기술한 컬럼이 2개일 경우
        ROLLUP은 n+1에서 3개의 그룹별 결과가 출력되고,
        CUBE는 2*n에서 2*2=4개의 결과 셋이 출력된다.
        예) buseo, jikwi 조건 2개
            ROLLUP = 2+1 (부서별 사원수, 직위별 사원수, 총사원수)
            CUBE = 2*2 (부서+직위 사원수, 부서별 사원수, 직위별 사원수, 총사원수)

문제1) insa 테이블에서 남자사원수, 여자사원수를 출력 - GROUP BY 절 사용
    SELECT DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 1, '남자', '여자') 성별, COUNT(*) 사원수
    FROM insa
    GROUP BY MOD(SUBSTR(ssn, -7, 1), 2)
    UNION ALL
    SELECT '합', COUNT(*) FROM insa;
 
[ROLLUP 사용]
그룹화한 부분합을 따로 구해서 UNION 할 필요가 없이 ROLLUP 연산자를 사용하면 된다.
    SELECT DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 1, '남자', 0, '여자', '총사원수') 성별, COUNT(*) 사원수
    FROM insa
    GROUP BY ROLLUP(MOD(SUBSTR(ssn, -7, 1), 2));
    
[CUBE 사용]
    SELECT DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 1, '남자', 0, '여자', '총사원수') 성별, COUNT(*) 사원수
    FROM insa
    GROUP BY CUBE(MOD(SUBSTR(ssn, -7, 1), 2));

---    
문제2) insa 테이블에서 아래와 같이 부서별 사원수를 구하고 전체 사원수도 구하고싶다.
개발부	과장	2
개발부	대리	2
개발부	부장	1
개발부	사원	9
            14 (부분합)
기획부	대리	3
기획부	부장	2
기획부	사원	2
            7 (부분합)
            :
            6(부분합)
            60(전체부분합)

    풀이1) UNION ALL 사용
    SELECT buseo, jikwi, COUNT(*)
    FROM insa
    GROUP BY buseo, jikwi
    -- ORDER BY buseo, jikwi
    UNION ALL
    SELECT buseo, '', COUNT(*)
    FROM insa
    GROUP BY buseo
    -- ORDER BY buseo
    UNION ALL
    SELECT '', '', COUNT(*)
    FROM insa;
    
    풀이2) ROLLUP, CUBE 연산자 사용
    SELECT buseo, jikwi, COUNT(*) 사원수
    FROM insa
    GROUP BY CUBE(buseo, jikwi) -- 직위별의 합도 나온다. 즉, 모든 가지수의 합계가 나온다.
    ORDER BY buseo, jikwi;
    
    SELECT buseo, jikwi, COUNT(*) 사원수
    FROM insa
    GROUP BY ROLLUP(buseo, jikwi) -- 직위별의 합은 나오지 않음
    ORDER BY buseo, jikwi;

---
문제3) emp 테이블에서 job 별로 사원수 몇 명인지 조회

풀이1) GROUP BY 절 사용
SELECT job, COUNT(*)
FROM emp
GROUP BY job;

풀이2) DECODE() 함수
SELECT COUNT(DECODE(job, 'CLERK', 'o')) CLERK
    , COUNT(DECODE(job, 'SALESMAN', 'o')) SALESMAN
    , COUNT(DECODE(job, 'PRESIDENT', 'o')) PRESIDENT
    , COUNT(DECODE(job, 'MANAGER', 'o')) MANAGER
    , COUNT(DECODE(job, 'ANALYST', 'o')) ANALYST
FROM emp;


5. [PIVOT(피벗)]
 1) Oracle 11g 버전부터 제공하는 함수
 2) 행과 열을 뒤집는 함수
 3) 반대로 뒤집는 건 언피벗이라고 한다.
 
    [PIVOT 형식]
    SELECT * 
    FROM (피벗 대상 쿼리문) -- 서브쿼리
    PIVOT (그룹함수(집계컬럼) FOR 피벗컬럼 IN(피벗컬럼 값 AS 별칭...))

    SELECT * 
    FROM (SELECT job FROM emp)
    PIVOT (COUNT(job) FOR job IN('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST'));
    
    -- emp 테이블에서 job 별 1월~12월에 입사한 사원의 수
    SELECT * 
    FROM (SELECT job , TO_CHAR(hiredate, 'FMMM') || '월' hire_month FROM emp)
    PIVOT( COUNT(*) FOR hire_month IN ('1월', '2월', '3월', '4월', '5월', '6월'
                                        , '7월', '8월', '9월', '10월', '11월', '12월')  );


문제1) insa 테이블에서 성별로 사원수를 조회하고싶다.
1번) GROUP BY
SELECT MOD(SUBSTR(ssn, -7, 1), 2), COUNT(*)
FROM insa
GROUP BY MOD(SUBSTR(ssn, -7, 1), 2);

2번) DECODE 함수
SELECT COUNT(DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 1, '남')) "남자"
    ,COUNT(DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 0, '여')) "여자"
FROM insa;

3번) PIVOT 함수
SELECT *
FROM (SELECT MOD(SUBSTR(ssn, -7, 1), 2) 성별 FROM insa)
PIVOT( COUNT(*) FOR 성별 IN (1 AS "남자" , 0 AS "여자") );

