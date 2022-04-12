-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]
---- �������� �� ���ο� ���� �Ǵ� ��Ǭ�� ----
2. ������ ���Ϸκ��� ���ñ��� ��ƿ� �ϼ�, ������, ����� ����ϼ���..
    SELECT TO_DATE('1995.12.17')
        , ABS(TO_DATE('19951217') - TRUNC(SYSDATE)) ��ƿ��ϼ�
        , ABS(MONTHS_BETWEEN(TO_DATE('19951217'), TRUNC(SYSDATE))) ������
        , ABS(MONTHS_BETWEEN(TO_DATE('19951217'), TRUNC(SYSDATE))) / 12 ���
    FROM dual;

3. emp  ����  comm �� null ����� ?? 
    Ǯ��1) IS NULL SQL ������ ���
    SELECT COUNT(*)
    FROM emp
    WHERE comm IS NULL;
    
    Ǯ��2) DECODE0
    SELECT COUNT(DECODE(comm, null, 'O'))
    FROM emp;
    
    Ǯ��3) CASE
    SELECT COUNT(
            CASE
            WHEN comm IS NULL THEN 'O'
            ELSE null
           END
           )
    FROM emp;

4. 
  4-1. �̹� ���� �� �ϱ��� �ִ� Ȯ��.
  SELECT LAST_DAY(SYSDATE)
    , TO_CHAR(LAST_DAY(SYSDATE), 'DD')
    , EXTRACT(DAY FROM LAST_DAY(SYSDATE))
  FROM dual;

  4-2. ������ ���� �� ° ��, ���� �� °������ Ȯ��. 
  SELECT TO_CHAR(SYSDATE, 'W')
        , TO_CHAR(SYSDATE, 'WW')
        , TO_CHAR(SYSDATE, 'IW')
  FROM dual;

5. emp ����  pay �� NVL(), NVL2(), COALESCE()�Լ��� ����ؼ� ����ϼ���.
    SELECT COALESCE(sal + comm, sal, 0) pay
    FROM emp;

5-2. emp���̺��� mgr�� null �� ��� -1 �� ����ϴ� ���� �ۼ�
      ��. nvl()
    SELECT e.*
        , NVL(mgr, -1)
    FROM emp e; 

      ��. nvl2()
    SELECT NVL2(mgr, mgr, -1)
    FROM emp;

      ��. COALESCE()

    SELECT COALESCE(mgr, -1)
    FROM emp


6. insa ����  �̸�,�ֹι�ȣ, ����( ����/���� ), ����( ����/���� ) ��� ���� �ۼ�-
    ��. DECODE()
    SELECT name, ssn
        , DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 1, '����', '����')
    FROM insa;

    ��. CASE �Լ�
    SELECT name, ssn
        , CASE MOD( SUBSTR(ssn, -7, 1), 2)
            WHEN 1 THEN '����'
            ELSE '����'
          END ����
        , CASE
            WHEN MOD( SUBSTR(ssn, -7, 1), 2) = 1 THEN '����'
            ELSE '����'
          END ����
    FROM insa;

7. emp ���� ���PAY ���� ���ų� ū ����鸸�� �޿� ���� ���.

Ǯ��1)
SELECT SUM(sal+NVL(comm, 0)) totalpay
FROM emp
WHERE sal+NVL(comm, 0) >= (SELECT AVG(sal + NVL(comm, 0)) FROM emp);

Ǯ��2) DECODE�� CASE �Լ� ����ؼ�
SELECT -- t.ename, t.pay, t.avgpay
    -- , SIGN(t.pay - t.avgpay)
    SUM(DECODE( SIGN(t.pay - t.avgpay), -1, null, t.pay)) "DECODE���"
    , SUM(
        CASE SIGN(t.pay - t.avgpay)
            WHEN -1 THEN null
            ELSE t.pay
        END 
        ) "CASE���"
FROM (
        SELECT ename, sal + NVL(comm, 0) pay
            , (SELECT AVG(sal + NVL(comm, 0)) FROM emp) avgpay
        FROM emp
) t;

8. emp ����  ����� �����ϴ� �μ��� �μ���ȣ�� ���
SELECT deptno
FROM emp
GROUP BY deptno;

SELECT DISTINCT deptno
FROM emp;

8-2. emp���� ����� �������� �ʴ� �μ��� �μ���ȣ�� ���
������ ��� �� �ٸ� ���� �ۼ�

10. emp ���̺��� ename, pay , �ִ�pay�� 5000�� 100%�� ����ؼ�
   �� ����� pay�� ��з��� ����ؼ� 10% �� ���ϳ�(*)�� ó���ؼ� ���
   ( �Ҽ��� ù ° �ڸ����� �ݿø��ؼ� ��� )
   
SELECT MAX(sal + NVL(comm, 0)) max_pay
FROM emp;

SELECT t.*
        , t.pay*100 / t.max_pay || '%' �ۼ�Ʈ
        , ROUND((t.pay*100 / t.max_pay) / 10) ������
        , RPAD( ' ', ROUND((t.pay*100 / t.max_pay) / 10)+1, '*') �׷���
FROM (
    SELECT ename, sal + NVL(comm, 0) pay
            , (SELECT MAX(sal + NVL(comm, 0)) FROM emp) max_pay
    FROM emp
) t;
        
12. insa���̺��� 1001, 1002 ����� �ֹι�ȣ�� ��/�� �� 10��10�Ϸ� �����ϴ� ������ �ۼ� 
SELECT name, ssn
FROM insa;

UPDATE insa
SET ssn = SUBSTR(ssn, 0, 2) || '1010' ||  SUBSTR(ssn, 7)
WHERE num IN(1001, 1002);

COMMIT;

12-2. insa���̺��� '2022.10.10'�� �������� �Ʒ��� ���� ����ϴ� ���� �ۼ�.  
���)
����ö	780506-1625148	���� ��
�迵��	821011-2362514	���� ��
������	810810-1552147	���� ��
������	751010-1122233	���� ����
������	801010-2987897	���� ����
���ѱ�	760909-1333333	���� ��


Ǯ��1) CASE
SELECT name, ssn 
    --, TO_CHAR(TO_DATE('2022.10.10'), 'HH24:MI:SS') 
    --, TO_CHAR(TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD'), 'HH24:MI:SS')
    , CASE SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD'))
        WHEN 1 THEN '���� ����'
        WHEN -1 THEN '���� ������'
        ELSE '���� ����'
      END
FROM insa;

Ǯ��2) DECODE
SELECT name, ssn
    , DECODE( SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD')) , 1, '��������', -1, '���� ������', '���û���')
FROM insa;

���)
����ö	780506-1625148	���� ��
�迵��	821011-2362514	���� ��
������	810810-1552147	���� ��
������	751010-1122233	���� ����
������	801010-2987897	���� ����
���ѱ�	760909-1333333	���� ��


12-3. insa���̺��� '2022.10.10'�������� �� ���� ������ �����,���� �����, �� ���� ������� ����ϴ� ���� �ۼ�. 
SELECT COUNT(DECODE( SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD')) , 1, '��������')) �������������
    , COUNT(DECODE( SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD')) , -1, '���Ͼ�����')) ���Ͼ����������
    , COUNT(DECODE( SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD')) , 0, '���û���')) ���û��ϻ����
FROM insa;

Ǯ��1)
SELECT COUNT( DECODE(s, 0, 'O')) ���û��ϻ����
    , COUNT( CASE WHEN s = -1 THEN 'o' ELSE null END) "�����������"
    , COUNT( CASE WHEN s = 1 THEN 'o' ELSE null END) "�������������"
FROM
(
    SELECT name, ssn
        , SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD')) s
    FROM insa
) t;

Ǯ��2)
SELECT COUNT(*)
FROM insa
GROUP BY SIGN(TO_DATE('2022.10.10') - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD'));

SELECT DECODE(t.s, 1, '�������������', -1, '���Ͼ����������', '���û��ϻ����') ����
    , COUNT(*) ��
FROM
(
    SELECT name, ssn
        , SIGN( TO_DATE('2022.10.10') - TO_DATE(SUBSTR(ssn, 3, 4 ), 'MMDD') ) s
        FROM insa
) t
GROUP BY t.s;



13.  emp ���̺��� 10�� �μ�������  �޿� 15% �λ�
                20�� �μ������� �޿� 10% �λ�
                30�� �μ������� �޿� 5% �λ�
                40�� �μ������� �޿� 20% �λ�
  �ϴ� ���� �ۼ�.     

    SELECT deptno, ename, sal+NVL(comm, 0) pay
        , DECODE(deptno, 10, (sal+NVL(comm, 0)) * 1.15, 20, (sal+NVL(comm, 0)) * 1.10 , 30, (sal+NVL(comm, 0)) * 1.05, (sal+NVL(comm, 0)) * 1.20) �޿��λ�
    FROM emp;       
    
    SELECT deptno, ename, sal+NVL(comm, 0) pay
        , CASE deptno
            WHEN 10 THEN (sal+NVL(comm, 0)) * 1.15
            WHEN 20 THEN (sal+NVL(comm, 0)) * 1.10
            WHEN 30 THEN (sal+NVL(comm, 0)) * 1.05
            ELSE (sal+NVL(comm, 0)) * 1.20
          END �λ�ݾ�
    FROM emp; 

14. emp ���̺��� �� �μ��� ������� ��ȸ�ϴ� ����
    Ǯ��1)
    SELECT COUNT(DECODE(deptno, 10, 'o')) "10�������"
        , COUNT(DECODE(deptno, 20, 'o')) "20�������"
        , COUNT(DECODE(deptno, 30, 'o')) "30�������"
        , COUNT(CASE WHEN deptno = 40 THEN 'o' ELSE null END) "40�������"
        , COUNT(*) �ѻ����
    FROM emp;
    
    Ǯ��2)
    SELECT COUNT(*)
    FROM emp
    GROUP BY deptno;

15. emp, salgrade �� ���̺��� �����ؼ� �Ʒ� ��� ��� ���� �ۼ�.

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
    
    
���� �ڵ��� JOIN�� ����ؼ� �ۼ��ϱ�
SELECT e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;
    

[ JOIUN(����) ��� ] ������
    -- ����) deptno, dname, empno, ename, hiredate, job �÷� ���
    -- emp ���̺�(�ڽ�) : deptno[FK], empno, ename, hiredate, job
    -- dept ���̺�(�θ�) : deptno[PK], dname
    
    [����] FROM A JOIN B ON ��������;  --> JOIN ~ ON
    �������� : A�� B���̺��� ����
    -- emp�� dept ���̺��� ���� ���̺��� deptno �÷����� ����(����)�ǰ� �ִ�.
    
    SELECT dept.deptno, dname, empno, ename, hiredate, job
    FROM dept JOIN emp ON dept.deptno = emp.deptno;
    
    ���� �޼��� : ORA-00918: column ambiguously defined
    �ؼ� : �÷��� �ָŸ�ȣ�ϰ� ����(����)�Ǿ���.
    �ذ� : �ߺ��� �÷��� ���̺��.�÷������� ���� -> dept.deptno
    
    + ��Ī���� ���� ���� �ִ�.
    SELECT d.deptno, dname, empno, ename, hiredate, job
    FROM dept d JOIN emp e ON d.deptno = e.deptno;
    
    + JOIN ~ ON Ű���� ��������ʰ� ,(�޸�)�� WHERE�ε� ����� �� �ִ�.
    SELECT d.deptno, dname, empno, ename, hiredate, job
    FROM dept d, emp e
    WHERE d.deptno = e.deptno; -- �̰� ���� ���ǽ�
    -- JOIN~ON Ű���� �����ϰ� ,(�޸�)�� WHERE



16. emp ���̺��� �޿��� ���� ���� �޴� ����� empno, ename, pay �� ���.

SELECT empno, ename, sal + NVL(comm, 0)
FROM emp
-- �񱳿����� + SOME, ANY, ALL ���� ���
-- EXISTS �ܵ� ���
WHERE sal + NVL(comm, 0) >= ALL (SELECT sal + NVL(comm, 0) FROM emp);
WHERE sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp);

16-2. emp ���̺��� �� �μ��� �޿��� ���� ���� �޴� ����� pay�� ��� 

�����Ǯ��)
SELECT deptno
    , MAX(sal + NVL(comm, 0))
    , MIN(sal + NVL(comm, 0))
FROM emp
GROUP BY deptno;

����Ǭ��)
SELECT 
    DISTINCT CASE deptno
        WHEN 10 THEN (SELECT '10���μ� : ' || MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = 10) 
        WHEN 20 THEN (SELECT '20���μ� : ' || MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = 20) 
        WHEN 30 THEN (SELECT '30���μ� : ' || MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = 30) 
        WHEN 40 THEN (SELECT '40���μ� : ' || MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = 40) 
     END ���μ��ְ�޿�
FROM emp;


����-�亯
���� �޽��� : ORA-00979: not a GROUP BY expression
empno�� �����Ϸ��� �ϴ� ����� �ƴ϶�.. �Ұ�
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
    
*** ��� ���� ����(Correlated) ***
(1) ���������� ��(e.deptno)�� ������������ ����� �� �� ������� �ٽ� ������������ ���
    ��, ���������� ���� ���������� �ְ� ������������ ����Ͽ� ���� ����� �ٽ� ������������ ����ϴ� ��
(2) correlated subquery�� �Ѱ��� ���� ���� ������ ����� main���� ���ϵȴ�.
(3) ���������� ������ ���ϵȴ�.
(4) ���������� ������������ ����� ��ȯ�ϱ� ���Ͽ� ���������� WHERE ���������� ���������� ���̺�� �����Ѵ�.

SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp e
WHERE sal + NVL(comm, 0) = ( SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = e.deptno );


SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = e.deptno
���������� ����� �Ʒ� ���� �߻�
�����޽��� : ORA-00904: "E"."DEPTNO": invalid identifier
�ؼ� : e.deptno�� ã�� �� ����. �ۿ� ���������� �ֱ� ������


����) �� �μ����� �� �μ��� ��� �޿����� ũ�� ��������� ����ϴ� ����
SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp e
WHERE sal + NVL(comm, 0) >= ( SELECT AVG(sal + NVL(comm, 0)) FROM emp WHERE deptno = e.deptno )
ORDER BY deptno ASC;

����) insa ���̺�
�����̴� ���س⵵ - ���ϳ⵵ �������������ο� ���� ������ ������������ -1
���³��� ���س⵵ - ���ϳ⵵ + 1

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

���� Ǭ ����)
SELECT name, ssn
    , EXTRACT(YEAR FROM SYSDATE) - (SUBSTR(ssn, 0, 2) + 1900) + 1 ���³���
    , DECODE(  SIGN(TO_DATE(SYSDATE) - TO_DATE(SUBSTR(ssn,3, 4), 'MMDD')), -1, EXTRACT(YEAR FROM SYSDATE) - (SUBSTR(ssn, 0, 2) + 1900) - 1, EXTRACT(YEAR FROM SYSDATE) - (SUBSTR(ssn, 0, 2) + 1900)) ������
FROM insa;

����) emp ���̺��� pay�� ���� �޴� 3�� ���(TOP-N ���)
[TOP_N ���]
(1) �ִ밪�̳� �ּҰ��� ���� �÷��� ������ �� �����ϰ� ���Ǵ� �м�����̴�.
(2) inline view���� ORDER BY ���� ����� �� �����Ƿ� �����͸� ���ϴ� ������ ���ĵ� �����ϴ�.
(3) ROWNUM �÷��� subquery���� ��ȯ�Ǵ� �� �࿡ �������� ��ȣ�� �ο��ϴ� pseudo(����, �ǻ�=��¥) �÷��̴�.
    ��, ������ �ڵ����� �ο����ִ� ��¥ �÷��̴�.
(4) n���� < �Ǵ� >=�� ����Ͽ� �����ϸ�, ��ȯ�� ���� ������ �����Ѵ�.

�����ġ�
	SELECT �÷���,..., ROWNUM
	FROM (SELECT �÷���,... from ���̺��
	      ORDER BY top_n_�÷���)
        WHERE ROWNUM <= n;

SELECT ROWNUM, t.*
FROM (
    SELECT deptno, ename, sal + NVL(comm, 0) pay
    FROM emp
    ORDER BY pay DESC
) t
WHERE ROWNUM <= 3; 
WHERE ROWNUM BETWEEN 3 AND 5; -- �߰����� �������� ���� �Ұ���, ó������ �����;���

[ ���� �ű�� �Լ�]
1. DENSE_RANK()
    1) �׷� ������ ���ʷ� �� ���� rank�� ����Ͽ� NUMBER ������Ÿ������ ������ ��ȯ�Ѵ�.
    2) �ش� ���� ���� �켱������ ����(�ߺ� ���� ��� ����) ex) 9�� 9�� 10��
    
    ��Aggregate ���ġ�
          DENSE_RANK ( expr[,expr,...] ) WITHIN GROUP
            (ORDER BY expr [[DESC ? ASC] [NULLS {FIRST ? LAST} , expr,...] )
    
    ��Analytic ���ġ�
          DENSE_RANK ( ) OVER ([query_partion_clause] order_by_clause )
                                                        ���ı���

    ����) emp ���̺��� pay�� ���� �޴� 3�� ���(DENSE_RANK() �Լ� ���)
    WITH pay_rank_emp AS(
        SELECT ename, sal + NVL(comm, 0) pay
                , DENSE_RANK() OVER( ORDER BY sal + NVL(comm, 0) DESC ) seq
        FROM emp
    )
    SELECT e.*
    FROM pay_rank_emp e
    WHERE e.seq <= 3;
    
    WHERE e.seq BETWEEN 3 AND 5;  -- TOP-N ��İ��� �ٸ��� BETWEEN ��� ����
    WHERE e.seq <= 5;
    WHERE e.seq = 1;

2. RANK() �Լ�
    (1) �ش� ���� ���� �켱������ ����(�ߺ� ���� ��� ��) ex) 9�� 9�� 11��
    
    ����) emp ���̺��� pay�� ���� �޴� 3�� ���(DENSE_RANK() �Լ� ���)
    WITH pay_rank_emp AS(
        SELECT ename, sal + NVL(comm, 0) pay
                , DENSE_RANK() OVER( ORDER BY sal DESC ) dr_seq
                , RANK() OVER( ORDER BY sal DESC ) r_seq
        FROM emp
    )
    SELECT e.*
    FROM pay_rank_emp e;


3. ROW_NUMBER() �Լ�
    �� �Լ��� �м�(analytic) �Լ��μ�, ���Һ��� ���ĵ� ����� ���� ������ �ο��ϴ� ����̴�.
    ������ ��ü ���� Ư�� �÷��� �������� �и��ϴ� ������� GROUP BY ������ �׷�ȭ�ϴ� ����� ���� �����̴�.

�����ġ�
      ROW_NUMBER () 
                   OVER ([query_partition_clause] order_by_clause )
                   
    ����1) emp ���̺��� pay�� ���� �޴� 3�� ���(DENSE_RANK() �Լ� ���)
    WITH pay_rank_emp AS(
        SELECT ename, sal + NVL(comm, 0) pay
                , DENSE_RANK() OVER( ORDER BY sal DESC ) dr_seq
                , RANK() OVER( ORDER BY sal DESC ) r_seq
                , ROW_NUMBER() OVER ( ORDER BY sal DESC ) rn_seq
        FROM emp
    )
    SELECT e.*
    FROM pay_rank_emp e
    WHERE dr_seq <= 3; -- ����ϰ��� �ϴ� �Լ��� ��Ī���� �ٲٸ� �ȴ�.


    ����2) emp ���̺��� �� �μ����� �޿�(pay)�� ���� ���� �޴� ��� 1�� ���
    Ǯ��1) UNION ���
    SELECT MAX(sal + NVL(comm, 0))
    FROM emp
    WHERE deptno = 40;
    
    Ǯ��2) �����������   
    SELECT deptno, sal + NVL(comm, 0) max_pay
    FROM emp e
    WHERE sal = (SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = e.deptno);
   
    Ǯ��3) �����Լ�
    -- PARTITION BY deptno : �μ����� ��Ƽ���� ������ ������ �ű�ڴ�.
    SELECT t.*
    FROM(
        SELECT deptno, sal + NVL(comm, 0) pay
            , RANK() OVER( PARTITION BY deptno ORDER BY sal + NVL(comm, 0) DESC ) r_seq
            , DENSE_RANK() OVER( PARTITION BY deptno ORDER BY sal + NVL(comm, 0) DESC ) dr_seq
            , ROW_NUMBER() OVER( PARTITION BY deptno ORDER BY sal + NVL(comm, 0) DESC ) rn_seq
        FROM emp
    ) t
    WHERE t.r_seq = 1;
    
    ����3) emp���� pay�� ���� 20%�� ��� ��� ������ ��ȸ
    ������� Ǫ�Ű�) PERCENT_RANK() �Լ� ���
    ��Analytic ���ġ�
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
    WHERE t.p_rank <= 0.2; -- ��Ȯ�� 20%�� �ƴ� ������ ��¦ �ٸ�
    
    
    ���� Ǭ ��)
    SELECT t.*
    FROM (
        SELECT emp.*
            , (SELECT COUNT(*) FROM emp) * 0.2 "����20"
            , RANK() OVER( ORDER BY sal + NVL(comm, 0) DESC ) r_seq
        FROM emp
    ) t
    WHERE t.r_seq <= t.����20;

    
