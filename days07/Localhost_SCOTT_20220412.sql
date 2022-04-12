-- [ SCOTT에 접속된 스크립트 파일 ]
---- 복습문제 중 새로운 개념 또는 못푼거 ----
2. 본인의 생일로부터 오늘까지 살아온 일수, 개월수, 년수를 출력하세요..
    SELECT TO_DATE('1995.12.17')
        , ABS(TO_DATE('19951217') - TRUNC(SYSDATE)) 살아온일수
        , ABS(MONTHS_BETWEEN(TO_DATE('19951217'), TRUNC(SYSDATE))) 개월수
        , ABS(MONTHS_BETWEEN(TO_DATE('19951217'), TRUNC(SYSDATE))) / 12 년수
    FROM dual;

3. emp  에서  comm 이 null 사원수 ?? 
    풀이1) IS NULL SQL 연산자 사용
    SELECT COUNT(*)
    FROM emp
    WHERE comm IS NULL;
    
    풀이2) DECODE0
    SELECT COUNT(DECODE(comm, null, 'O'))
    FROM emp;
    
    풀이3) CASE
    SELECT COUNT(
            CASE
            WHEN comm IS NULL THEN 'O'
            ELSE null
           END
           )
    FROM emp;

4. 
  4-1. 이번 달이 몇 일까지 있는 확인.
  SELECT LAST_DAY(SYSDATE)
    , TO_CHAR(LAST_DAY(SYSDATE), 'DD')
    , EXTRACT(DAY FROM LAST_DAY(SYSDATE))
  FROM dual;

  4-2. 오늘이 년중 몇 째 주, 월중 몇 째주인지 확인. 
  SELECT TO_CHAR(SYSDATE, 'W')
        , TO_CHAR(SYSDATE, 'WW')
        , TO_CHAR(SYSDATE, 'IW')
  FROM dual;

5. emp 에서  pay 를 NVL(), NVL2(), COALESCE()함수를 사용해서 출력하세요.
    SELECT COALESCE(sal + comm, sal, 0) pay
    FROM emp;

5-2. emp테이블에서 mgr이 null 인 경우 -1 로 출력하는 쿼리 작성
      ㄱ. nvl()
    SELECT e.*
        , NVL(mgr, -1)
    FROM emp e; 

      ㄴ. nvl2()
    SELECT NVL2(mgr, mgr, -1)
    FROM emp;

      ㄷ. COALESCE()

    SELECT COALESCE(mgr, -1)
    FROM emp


6. insa 에서  이름,주민번호, 성별( 남자/여자 ), 성별( 남자/여자 ) 출력 쿼리 작성-
    ㄱ. DECODE()
    SELECT name, ssn
        , DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 1, '남자', '여자')
    FROM insa;

    ㄴ. CASE 함수
    SELECT name, ssn
        , CASE MOD( SUBSTR(ssn, -7, 1), 2)
            WHEN 1 THEN '남자'
            ELSE '여자'
          END 성별
        , CASE
            WHEN MOD( SUBSTR(ssn, -7, 1), 2) = 1 THEN '남자'
            ELSE '여자'
          END 성별
    FROM insa;

7. emp 에서 평균PAY 보다 같거나 큰 사원들만의 급여 합을 출력.

풀이1)
SELECT SUM(sal+NVL(comm, 0)) totalpay
FROM emp
WHERE sal+NVL(comm, 0) >= (SELECT AVG(sal + NVL(comm, 0)) FROM emp);

풀이2) DECODE나 CASE 함수 사용해서
SELECT -- t.ename, t.pay, t.avgpay
    -- , SIGN(t.pay - t.avgpay)
    SUM(DECODE( SIGN(t.pay - t.avgpay), -1, null, t.pay)) "DECODE사용"
    , SUM(
        CASE SIGN(t.pay - t.avgpay)
            WHEN -1 THEN null
            ELSE t.pay
        END 
        ) "CASE사용"
FROM (
        SELECT ename, sal + NVL(comm, 0) pay
            , (SELECT AVG(sal + NVL(comm, 0)) FROM emp) avgpay
        FROM emp
) t;

8. emp 에서  사원이 존재하는 부서의 부서번호만 출력
SELECT deptno
FROM emp
GROUP BY deptno;

SELECT DISTINCT deptno
FROM emp;

8-2. emp에서 사원이 존재하지 않는 부서의 부서번호만 출력
차집합 사용 또 다른 쿼리 작성

10. emp 테이블의 ename, pay , 최대pay값 5000을 100%로 계산해서
   각 사원의 pay를 백분률로 계산해서 10% 당 별하나(*)로 처리해서 출력
   ( 소숫점 첫 째 자리에서 반올림해서 출력 )
   
SELECT MAX(sal + NVL(comm, 0)) max_pay
FROM emp;

SELECT t.*
        , t.pay*100 / t.max_pay || '%' 퍼센트
        , ROUND((t.pay*100 / t.max_pay) / 10) 별갯수
        , RPAD( ' ', ROUND((t.pay*100 / t.max_pay) / 10)+1, '*') 그래프
FROM (
    SELECT ename, sal + NVL(comm, 0) pay
            , (SELECT MAX(sal + NVL(comm, 0)) FROM emp) max_pay
    FROM emp
) t;
        
12. insa테이블에서 1001, 1002 사원의 주민번호의 월/일 만 10월10일로 수정하는 쿼리를 작성 
SELECT name, ssn
FROM insa;

UPDATE insa
SET ssn = SUBSTR(ssn, 0, 2) || '1010' ||  SUBSTR(ssn, 7)
WHERE num IN(1001, 1002);

COMMIT;

12-2. insa테이블에서 '2022.10.10'을 기준으로 아래와 같이 출력하는 쿼리 작성.  
결과)
장인철	780506-1625148	생일 후
김영년	821011-2362514	생일 전
나윤균	810810-1552147	생일 후
김종서	751010-1122233	오늘 생일
유관순	801010-2987897	오늘 생일
정한국	760909-1333333	생일 후


풀이1) CASE
SELECT name, ssn 
    --, TO_CHAR(TO_DATE('2022.10.10'), 'HH24:MI:SS') 
    --, TO_CHAR(TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD'), 'HH24:MI:SS')
    , CASE SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD'))
        WHEN 1 THEN '생일 지남'
        WHEN -1 THEN '생일 안지남'
        ELSE '오늘 생일'
      END
FROM insa;

풀이2) DECODE
SELECT name, ssn
    , DECODE( SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD')) , 1, '생일지남', -1, '생일 안지남', '오늘생일')
FROM insa;

결과)
장인철	780506-1625148	생일 후
김영년	821011-2362514	생일 전
나윤균	810810-1552147	생일 후
김종서	751010-1122233	오늘 생일
유관순	801010-2987897	오늘 생일
정한국	760909-1333333	생일 후


12-3. insa테이블에서 '2022.10.10'기준으로 이 날이 생일인 사원수,지난 사원수, 안 지난 사원수를 출력하는 쿼리 작성. 
SELECT COUNT(DECODE( SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD')) , 1, '생일지남')) 생일지난사원수
    , COUNT(DECODE( SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD')) , -1, '생일안지남')) 생일안지난사원수
    , COUNT(DECODE( SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD')) , 0, '오늘생일')) 오늘생일사원수
FROM insa;

풀이1)
SELECT COUNT( DECODE(s, 0, 'O')) 오늘생일사원수
    , COUNT( CASE WHEN s = -1 THEN 'o' ELSE null END) "생일전사원수"
    , COUNT( CASE WHEN s = 1 THEN 'o' ELSE null END) "생일지난사원수"
FROM
(
    SELECT name, ssn
        , SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD')) s
    FROM insa
) t;

풀이2)
SELECT COUNT(*)
FROM insa
GROUP BY SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD'));

SELECT DECODE(t.s, 1, '생일지난사원수', -1, '생일안지난사원수', '오늘생일사원수') 구분
    , COUNT(*) 명
FROM
(
    SELECT name, ssn
        , SIGN( TO_DATE('2022.10.10') - TO_DATE(SUBSTR(ssn, 3, 4 ), 'MMDD') ) s
        FROM insa
) t
GROUP BY t.s;



13.  emp 테이블에서 10번 부서원들은  급여 15% 인상
                20번 부서원들은 급여 10% 인상
                30번 부서원들은 급여 5% 인상
                40번 부서원들은 급여 20% 인상
  하는 쿼리 작성.     

    SELECT deptno, ename, sal+NVL(comm, 0) pay
        , DECODE(deptno, 10, (sal+NVL(comm, 0)) * 1.15, 20, (sal+NVL(comm, 0)) * 1.10 , 30, (sal+NVL(comm, 0)) * 1.05, (sal+NVL(comm, 0)) * 1.20) 급여인상
    FROM emp;       
    
    SELECT deptno, ename, sal+NVL(comm, 0) pay
        , CASE deptno
            WHEN 10 THEN (sal+NVL(comm, 0)) * 1.15
            WHEN 20 THEN (sal+NVL(comm, 0)) * 1.10
            WHEN 30 THEN (sal+NVL(comm, 0)) * 1.05
            ELSE (sal+NVL(comm, 0)) * 1.20
          END 인상금액
    FROM emp; 

14. emp 테이블에서 각 부서의 사원수를 조회하는 쿼리
    풀이1)
    SELECT COUNT(DECODE(deptno, 10, 'o')) "10번사원수"
        , COUNT(DECODE(deptno, 20, 'o')) "20번사원수"
        , COUNT(DECODE(deptno, 30, 'o')) "30번사원수"
        , COUNT(CASE WHEN deptno = 40 THEN 'o' ELSE null END) "40번사원수"
        , COUNT(*) 총사원수
    FROM emp;
    
    풀이2)
    SELECT COUNT(*)
    FROM emp
    GROUP BY deptno;

15. emp, salgrade 두 테이블을 참조해서 아래 결과 출력 쿼리 작성.

ENAME   SAL     GRADE
----- ----- ---------
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

    SELECT ename, sal
        , CASE
            WHEN sal BETWEEN 700 AND 1200 THEN 1
            WHEN sal BETWEEN 1201 AND 1400 THEN 2
            WHEN sal BETWEEN 1401 AND 2000 THEN 3
            WHEN sal BETWEEN 2001 AND 3000 THEN 4
            WHEN sal BETWEEN 3001 AND 9999 THEN 5
          END grade
    FROM emp;
    
    SELECT *
    FROM salgrade;
    
    
위의 코딩을 JOIN을 사용해서 작성하기
SELECT e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;
    

[ JOIUN(조인) 사용 ] 맛보기
    -- 문제) deptno, dname, empno, ename, hiredate, job 컬럼 출력
    -- emp 테이블(자식) : deptno[FK], empno, ename, hiredate, job
    -- dept 테이블(부모) : deptno[PK], dname
    
    [형식] FROM A JOIN B ON 조인조건;  --> JOIN ~ ON
    조인조건 : A와 B테이블의 관계
    -- emp와 dept 테이블은 각각 테이블의 deptno 컬럼으로 참조(관계)되고 있다.
    
    SELECT dept.deptno, dname, empno, ename, hiredate, job
    FROM dept JOIN emp ON dept.deptno = emp.deptno;
    
    에러 메세지 : ORA-00918: column ambiguously defined
    해석 : 컬럼이 애매모호하게 선언(정의)되었다.
    해결 : 중복된 컬럼은 테이블명.컬럼명으로 선언 -> dept.deptno
    
    + 별칭으로 줄일 수도 있다.
    SELECT d.deptno, dname, empno, ename, hiredate, job
    FROM dept d JOIN emp e ON d.deptno = e.deptno;
    
    + JOIN ~ ON 키워드 사용하지않고 ,(콤마)와 WHERE로도 사용할 수 있다.
    SELECT d.deptno, dname, empno, ename, hiredate, job
    FROM dept d, emp e
    WHERE d.deptno = e.deptno; -- 이건 조인 조건식
    -- JOIN~ON 키워드 사용안하고 ,(콤마)와 WHERE



16. emp 테이블에서 급여를 가장 많이 받는 사원의 empno, ename, pay 를 출력.

SELECT empno, ename, sal + NVL(comm, 0)
FROM emp
-- 비교연산자 + SOME, ANY, ALL 같이 사용
-- EXISTS 단독 사용
WHERE sal + NVL(comm, 0) >= ALL (SELECT sal + NVL(comm, 0) FROM emp);
WHERE sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp);

16-2. emp 테이블에서 각 부서별 급여를 가장 많이 받는 사원의 pay를 출력 

강사님풀이)
SELECT deptno
    , MAX(sal + NVL(comm, 0))
    , MIN(sal + NVL(comm, 0))
FROM emp
GROUP BY deptno;

내가푼거)
SELECT 
    DISTINCT CASE deptno
        WHEN 10 THEN (SELECT '10번부서 : ' || MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = 10) 
        WHEN 20 THEN (SELECT '20번부서 : ' || MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = 20) 
        WHEN 30 THEN (SELECT '30번부서 : ' || MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = 30) 
        WHEN 40 THEN (SELECT '40번부서 : ' || MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = 40) 
     END 각부서최고급여
FROM emp;


질문-답변
에러 메시지 : ORA-00979: not a GROUP BY expression
empno는 집계하려고 하는 대상이 아니라.. 불가
SELECT empno, deptno, MAX(sal + NVL(comm, 0))
FROM emp
GROUP BY deptno;

SELECT *
FROM emp;

SELECT *
FROM dept;

--

SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp
WHERE deptno = 10 AND sal + NVL(comm, 0) = 5000
    OR deptno 20 = AND sal + NVL(comm, 0) = 3000
    OR deptno 30 = AND sal + NVL(comm, 0) = 2850;
    
*** 상관 서브 쿼리(Correlated) ***
(1) 메인쿼리의 값(e.deptno)을 서브쿼리에서 사용한 후 그 결과값을 다시 메인쿼리에서 사용
    즉, 메인쿼리의 값을 서브쿼리에 주고 서브쿼리에서 사용하여 나온 결과를 다시 메인쿼리에서 사용하는 것
(2) correlated subquery는 한개의 행을 비교할 때마다 결과가 main으로 리턴된다.
(3) 내부적으로 성능이 저하된다.
(4) 메인쿼리와 서브쿼리간에 결과를 교환하기 위하여 서브쿼리의 WHERE 조건절에서 메인쿼리의 테이블과 연결한다.

SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp e
WHERE sal + NVL(comm, 0) = ( SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = e.deptno );


SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = e.deptno
서브쿼리만 실행시 아래 에러 발생
에러메시지 : ORA-00904: "E"."DEPTNO": invalid identifier
해석 : e.deptno를 찾을 수 없음. 밖에 메인쿼리에 있기 때문에


문제) 각 부서별로 각 부서의 평균 급여보다 크면 사원정보를 출력하는 쿼리
SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp e
WHERE sal + NVL(comm, 0) >= ( SELECT AVG(sal + NVL(comm, 0)) FROM emp WHERE deptno = e.deptno )
ORDER BY deptno ASC;

문제) insa 테이블
만나이는 올해년도 - 생일년도 생일이지남여부에 따라 생일이 지나지않으면 -1
세는나이 올해년도 - 생일년도 + 1

SELECT t.name, t.ssn
    , DECODE( t.isBCheck, -1, t.now_year - t.birth_year - 1, t.now_year - t.birth_year ) americanAge1
    , CASE t.isBCheck
        WHEN -1 THEN t.now_year - t.birth_year - 1
        ELSE t.now_year - t.birth_year
      END americanAge2
    , t.now_year - t.birth_year + 1 countingAge
FROM (
    SELECT name, ssn
        , TO_CHAR(SYSDATE, 'YYYY') now_year
        , CASE 
            WHEN SUBSTR(ssn, -7, 1) IN ( 1,2,5,6) THEN SUBSTR(ssn, 0, 2) + 1900
            WHEN SUBSTR(ssn, -7, 1) IN ( 3,4,7,8) THEN SUBSTR(ssn, 0, 2) + 2000
            ELSE SUBSTR(ssn, 0, 2) + 1800
          END birth_year
        , SIGN(TRUNC(SYSDATE) - TO_DATE(SUBSTR(ssn,3, 4), 'MMDD')) isBCheck
    FROM insa
) t;

내가 푼 쿼리)
SELECT name, ssn
    , EXTRACT(YEAR FROM SYSDATE) - (SUBSTR(ssn, 0, 2) + 1900) + 1 세는나이
    , DECODE(  SIGN(TO_DATE(SYSDATE) - TO_DATE(SUBSTR(ssn,3, 4), 'MMDD')), -1, EXTRACT(YEAR FROM SYSDATE) - (SUBSTR(ssn, 0, 2) + 1900) - 1, EXTRACT(YEAR FROM SYSDATE) - (SUBSTR(ssn, 0, 2) + 1900)) 만나이
FROM insa;

문제) emp 테이블에서 pay를 많이 받는 3명 출력(TOP-N 방식)
[TOP_N 방식]
(1) 최대값이나 최소값을 가진 컬럼을 질의할 때 유용하게 사용되는 분석방법이다.
(2) inline view에서 ORDER BY 절을 사용할 수 있으므로 데이터를 원하는 순서로 정렬도 가능하다.
(3) ROWNUM 컬럼은 subquery에서 반환되는 각 행에 순차적인 번호를 부여하는 pseudo(수도, 의사=가짜) 컬럼이다.
    즉, 순번을 자동으로 부여해주는 가짜 컬럼이다.
(4) n값은 < 또는 >=를 사용하여 정의하며, 반환될 행의 개수를 지정한다.

【형식】
	SELECT 컬럼명,..., ROWNUM
	FROM (SELECT 컬럼명,... from 테이블명
	      ORDER BY top_n_컬럼명)
        WHERE ROWNUM <= n;

SELECT ROWNUM, t.*
FROM (
    SELECT deptno, ename, sal + NVL(comm, 0) pay
    FROM emp
    ORDER BY pay DESC
) t
WHERE ROWNUM <= 3; 
WHERE ROWNUM BETWEEN 3 AND 5; -- 중간에서 가져오는 것은 불가능, 처음부터 가져와야함

[ 순위 매기는 함수]
1. DENSE_RANK()
    1) 그룹 내에서 차례로 된 행의 rank를 계산하여 NUMBER 데이터타입으로 순위를 반환한다.
    2) 해당 값에 대한 우선순위를 결정(중복 순위 계산 안함) ex) 9등 9등 10등
    
    【Aggregate 형식】
          DENSE_RANK ( expr[,expr,...] ) WITHIN GROUP
            (ORDER BY expr [[DESC ? ASC] [NULLS {FIRST ? LAST} , expr,...] )
    
    【Analytic 형식】
          DENSE_RANK ( ) OVER ([query_partion_clause] order_by_clause )
                                                        정렬기준

    문제) emp 테이블에서 pay를 많이 받는 3명 출력(DENSE_RANK() 함수 사용)
    WITH pay_rank_emp AS(
        SELECT ename, sal + NVL(comm, 0) pay
                , DENSE_RANK() OVER( ORDER BY sal + NVL(comm, 0) DESC ) seq
        FROM emp
    )
    SELECT e.*
    FROM pay_rank_emp e
    WHERE e.seq <= 3;
    
    WHERE e.seq BETWEEN 3 AND 5;  -- TOP-N 방식과는 다르게 BETWEEN 사용 가능
    WHERE e.seq <= 5;
    WHERE e.seq = 1;

2. RANK() 함수
    (1) 해당 값에 대한 우선순위를 결정(중복 순위 계산 함) ex) 9등 9등 11등
    
    문제) emp 테이블에서 pay를 많이 받는 3명 출력(DENSE_RANK() 함수 사용)
    WITH pay_rank_emp AS(
        SELECT ename, sal + NVL(comm, 0) pay
                , DENSE_RANK() OVER( ORDER BY sal DESC ) dr_seq
                , RANK() OVER( ORDER BY sal DESC ) r_seq
        FROM emp
    )
    SELECT e.*
    FROM pay_rank_emp e;


3. ROW_NUMBER() 함수
    이 함수는 분석(analytic) 함수로서, 분할별로 정렬된 결과에 대해 순위를 부여하는 기능이다.
    분할은 전체 행을 특정 컬럼을 기준으로 분리하는 기능으로 GROUP BY 절에서 그룹화하는 방법과 같은 개념이다.

【형식】
      ROW_NUMBER () 
                   OVER ([query_partition_clause] order_by_clause )
                   
    문제1) emp 테이블에서 pay를 많이 받는 3명 출력(DENSE_RANK() 함수 사용)
    WITH pay_rank_emp AS(
        SELECT ename, sal + NVL(comm, 0) pay
                , DENSE_RANK() OVER( ORDER BY sal DESC ) dr_seq
                , RANK() OVER( ORDER BY sal DESC ) r_seq
                , ROW_NUMBER() OVER ( ORDER BY sal DESC ) rn_seq
        FROM emp
    )
    SELECT e.*
    FROM pay_rank_emp e
    WHERE dr_seq <= 3; -- 사용하고자 하는 함수의 별칭으로 바꾸면 된다.


    문제2) emp 테이블에서 각 부서별로 급여(pay)를 가장 많이 받는 사원 1명 출력
    풀이1) UNION 사용
    SELECT MAX(sal + NVL(comm, 0))
    FROM emp
    WHERE deptno = 40;
    
    풀이2) 상관서브쿼리   
    SELECT deptno, sal + NVL(comm, 0) max_pay
    FROM emp e
    WHERE sal = (SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = e.deptno);
   
    풀이3) 순위함수
    -- PARTITION BY deptno : 부서별로 파티션을 나누고 순위를 매기겠다.
    SELECT t.*
    FROM(
        SELECT deptno, sal + NVL(comm, 0) pay
            , RANK() OVER( PARTITION BY deptno ORDER BY sal + NVL(comm, 0) DESC ) r_seq
            , DENSE_RANK() OVER( PARTITION BY deptno ORDER BY sal + NVL(comm, 0) DESC ) dr_seq
            , ROW_NUMBER() OVER( PARTITION BY deptno ORDER BY sal + NVL(comm, 0) DESC ) rn_seq
        FROM emp
    ) t
    WHERE t.r_seq = 1;
    
    문제3) emp에서 pay가 상위 20%에 드는 사원 정보를 조회
    강사님이 푸신거) PERCENT_RANK() 함수 사용
    【Analytic 형식】
       PERCENT_RANK() OVER ( 
                             [query_partition_clause]
                              order_by_clause
                            )
                            
                            
    SELECT t.*
    FROM(
        SELECT deptno, ename, sal + NVL(comm, 0) pay
            , PERCENT_RANK() OVER (ORDER BY sal + NVL(comm, 0) DESC ) p_rank
        FROM emp
    ) t
    WHERE t.p_rank <= 0.2; -- 정확히 20%는 아님 개념이 살짝 다름
    
    
    내가 푼 거)
    SELECT t.*
    FROM (
        SELECT emp.*
            , (SELECT COUNT(*) FROM emp) * 0.2 "상위20"
            , RANK() OVER( ORDER BY sal + NVL(comm, 0) DESC ) r_seq
        FROM emp
    ) t
    WHERE t.r_seq <= t.상위20;

    
