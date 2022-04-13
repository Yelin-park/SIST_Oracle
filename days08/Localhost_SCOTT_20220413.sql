-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]
---- �������� �� ���ο� ���� �Ǵ� ��Ǭ�� ----

1. emp , salgrade ���̺��� ����ؼ� �Ʒ��� ���� ���.
1-2. emp , salgrade ���̺��� ����ؼ� �Ʒ��� ���� ���. [JOIN] ���

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

1-3.  ���� ������� ���(grade)�� 1����� ����� ��ȸ�ϴ� ���� �ۼ�

    SELECT t.*
    FROM
    (
        SELECT empno, ename, sal + NVL(comm, 0) pay, grade
        FROM emp e, salgrade s
        WHERE sal + NVL(comm, 0) BETWEEN s.losal AND s.hisal
    ) t
    WHERE t.grade = 1;
   

2. emp ���� �ְ�޿��� �޴� ����� ���� ���

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

2-2. emp ���� �� �μ��� �ְ�޿��� �޴� ����� ���� ���

    DEPTNO DNAME          ENAME             PAY
---------- -------------- ---------- ----------
        10 ACCOUNTING     KING             5000
        20 RESEARCH       FORD             3000
        30 SALES          BLAKE            2850
    
    Ǯ��1) �����������
    SELECT d.deptno, dname, ename, sal + NVL(comm, 0) pay
    FROM dept d, emp e
    WHERE d.deptno = e.deptno
        AND sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = d.deptno)
    ORDER BY d.deptno ASC;
    
    Ǯ��2) �����Լ�
    SELECT *
    FROM(
        SELECT d.deptno, dname, ename, sal + NVL(comm, 0) pay
            , RANK() OVER(PARTITION BY deptno ORDER BY sal + NVL(comm, 0) DESC) pay_rank
        FROM emp e JOIN dept d ON e.deptno = d.deptno
    ) t
    WHERE pay_rank = 1;
    
    Ǯ��3)
    SELECT t.deptno, d.dname, t.ename, t.pay, t.pay_rank
    FROM(
        SELECT deptno, ename, sal + NVL(comm, 0) pay
            , RANK() OVER(PARTITION BY deptno ORDER BY sal + NVL(comm, 0) DESC) pay_rank
        FROM emp
    ) t JOIN dept d ON t.deptno = d.deptno
    WHERE pay_rank = 1;
    
    
3. emp ���� �� ����� �޿��� ��ü�޿��� �� %�� �Ǵ� �� ��ȸ.
--       ( %   �Ҽ��� 3�ڸ����� �ݿø��ϼ��� )
--            ������ �Ҽ��� 2�ڸ������� ���.. 7.00%,  3.50%     

ENAME             PAY   TOTALPAY ����     
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
            , TO_CHAR(ROUND(t.pay / t.totalpay * 100, 2), '99.00') || '%' ����
    FROM
    (
        SELECT ename, sal + NVL(comm, 0) pay
            , (SELECT SUM(sal + NVL(comm, 0)) FROM emp) totalpay
        FROM emp
    ) t;


4. emp ���� ���� ���� �Ի��� ��� �� ���� �ʰ�(�ֱ�) �Ի��� ����� ���� �ϼ� ? 

    SELECT MAX(hiredate) - MIN(hiredate)
    FROM emp;

[���ο� ����!! FIRST_VALUE, LAST_VALUE �м� �Լ�] 
    FIRST_VALUE�� �м� �Լ��� ���ĵ� ���߿��� [���� ������� ù ��° ��]�� ��ȯ�Ѵ�.
    ���� ù��°�� NULL�̶��, IGNORE NULLS�� �������� �ʾҴٸ� NULL�� ��ȯ�ϰ� �ȴ�.
    LAST_VALUE �Լ��� �м� �Լ��� ���ĵ� ���߿��� [���� ������� ������ ��]�� ��ȯ�ϴ� �Լ��̴�.

    �����ġ�
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
    
5. insa ���� ������� ������ ����ؼ� ���
  ( ������ = ���س⵵ - ����⵵          - 1( ������������ ������) )

    SELECT CASE t.����Ȯ��
            WHEN -1 THEN t.now - t.byear - 1
            ELSE t.now - t.byear
           END ������
    FROM(  
        SELECT ssn, TO_CHAR(SYSDATE, 'YYYY') now
            , CASE
                WHEN SUBSTR(ssn, -7, 1) IN (1,2,5,6)THEN 1900 + SUBSTR(ssn, 0, 2)
                WHEN SUBSTR(ssn, -7, 1) IN (3,4,7,8)THEN 2000 + SUBSTR(ssn, 0, 2)
                ELSE 1800 + SUBSTR(ssn, 0, 2)
              END byear
            , SIGN(TRUNC(SYSDATE) - TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD')) ����Ȯ��
        FROM insa
    ) t

  
6. insa ���̺��� �Ʒ��� ���� ����� ������ ..
     [�ѻ����]      [���ڻ����]      [���ڻ����] [��������� �ѱ޿���]  [��������� �ѱ޿���] [����-max(�޿�)] [����-max(�޿�)]
---------- ---------- ---------- ---------- ---------- ---------- ----------
        60                31              29           51961200                41430400                  2650000          2550000
      
    SELECT COUNT(*) �ѻ����
        , COUNT(DECODE( MOD(SUBSTR(ssn, -7, 1), 2), 1, '��' )) ���ڻ����
        , COUNT(DECODE( MOD(SUBSTR(ssn, -7, 1), 2), 0, '��' )) ���ڻ����
        , SUM(DECODE( MOD(SUBSTR(ssn, -7, 1), 2), 1, basicpay )) ���ڻ�������ѱ޿���
        , SUM(DECODE( MOD(SUBSTR(ssn, -7, 1), 2), 0, basicpay )) ���ڻ�������ѱ޿���
        , MAX(DECODE( MOD(SUBSTR(ssn, -7, 1), 2), 1, basicpay )) ���ڻ���ְ�޿�
        , MAX(DECODE( MOD(SUBSTR(ssn, -7, 1), 2), 0, basicpay )) ���ڻ���ְ�޿�
    FROM insa;


7. TOP-N ������� Ǯ�� ( ROWNUM �ǻ� �÷� ��� )
   emp ���� �ְ�޿��� �޴� ����� ���� ���  
  
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
        
        
8-1.����(RANK) �Լ� ����ؼ� Ǯ�� 
   emp ���� �� �μ��� �ְ�޿��� �޴� ����� ���� ���
   
    DEPTNO ENAME             PAY DEPTNO_RANK
---------- ---------- ---------- -----------
        10 KING             5000           1
        20 FORD             3000           1
        30 BLAKE            2850           1

    1�� Ǯ��) �����Լ�
    SELECT t.*
    FROM(
        SELECT deptno, ename, sal + NVL(comm, 0) pay
                , RANK() OVER(PARTITION BY deptno ORDER BY sal + NVL(comm, 0) DESC) deptno_rank
        FROM emp
    ) t
    WHERE t.deptno_rank = 1;

    2�� Ǯ��) JOIN 
    SELECT t.deptno, e.ename, e.sal + NVL(e.comm,0)
    FROM(
        SELECT deptno, MAX(sal + NVL(comm,0)) maxpay
        FROM emp
        GROUP BY deptno
    ) t, emp e
    WHERE t.deptno = e.deptno AND t.maxpay = e.sal + NVL(e.comm,0);


8-2. ���()���������� ����ؼ� Ǯ�� 
   emp ���� �� �μ��� �ְ�޿��� �޴� ����� ���� ���
 
    SELECT deptno, ename, sal + NVL(comm, 0) pay
    FROM emp e
    WHERE sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = e.deptno)
    ORDER BY deptno;

9.  emp���̺��� �� �μ��� �����, �μ��ѱ޿���, �μ������ �Ʒ��� ���� ����ϴ� ���� �ۼ�.
���)
    DEPTNO       �μ�����       �ѱ޿���    	     ���
---------- ---------- 		---------- 	----------
        10          3      	 8750    	2916.67
        20          3     	  6775    	2258.33
        30          6     	 11600    	1933.33      
        
        
    SELECT deptno, COUNT(*)
        , SUM(sal + NVL(comm, 0)) �ѱ޿���
        , ROUND(AVG(sal + NVL(comm, 0)), 2) ���
    FROM emp
    GROUP BY deptno
    ORDER BY deptno;
         
10-1.  emp ���̺��� 30���� �μ��� �ְ�, ���� SAL�� ����ϴ� ���� �ۼ�.
���)
  MIN(SAL)   MAX(SAL)
---------- ----------
       950       2850

    SELECT MIN(sal + NVL(comm, 0)) min, MAX(sal + NVL(comm, 0)) max
    FROM emp
    WHERE deptno = 30;

[���ο� ����!!! HAVING ��]
    GROUP BY�� �� ���� ����ؾ���
    �׷����� ������ ��� ������ ������ �ִ� ��
    WITH
    SELECT
    FROM
    WHERE
    GROUP BY
    HAVING : GROUP BY�� ������
    ORDER BY

SELECT deptno, MAX(sal), MIN(sal)
FROM emp
GROUP BY deptno
HAVING deptno = 30; -- �׷����� ������ ��� ������ ������ �ִ� ��

10-2.  emp ���̺��� 30���� �μ��� �ְ�, ���� SAL�� �޴� ����� ���� ����ϴ� ���� �ۼ�.

���)
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
    --���������� ���� ���� ����ϸ� ���� �߻�
    
    SELECT empno, ename, hiredate, sal
    FROM(
        SELECT MAX(sal) maxsal, MIN(sal) minsal
        FROM emp
        WHERE deptno = 30
    )t, emp e
    WHERE e.deptno = 30 AND t.maxsal = e.sal OR t.minsal = e.sal;



11.  insa ���̺��� 
[������]                                   �μ�/��ü �μ�����/��ü   �ش缺��/�μ��ο�
�μ���     �ѻ���� �μ������ ����  ���������    ��/��%   �μ�/��%        ��/��%
���ߺ�	    60	    14	      F	    8	    23.3%	13.3%	    57.1%
���ߺ�	    60	    14	      M	    6	    23.3%	10%	    42.9%
��ȹ��	    60	    7	      F	    3	    11.7%	5%	4       2.9%
��ȹ��	    60	    7	      M	    4	    11.7%	6.7%	    57.1%
������	    60	    16	      F	    8	    26.7%	13.3%	    50%
������	    60	    16	      M	    8	    26.7%	13.3%	    50%
�λ��	    60	    4	      M	    4	    6.7%	6.7%	    100%
�����	    60	    6	      F	    4	    10%	    6.7%	    66.7%
�����	    60	    6	      M	    2	    10%	    3.3%	    33.3%
�ѹ���	    60	    7	      F	    3	    11.7%	5%	        42.9%
�ѹ���	    60	    7	      M 	4	    11.7%	6.7%	    57.1%
ȫ����	    60	    6	      F	    3	    10%	    5%	        50%
ȫ����	    60	    6	      M	    3	    10%	    5%	        50%             


    WITH temp AS(
        SELECT t.buseo
            , (SELECT COUNT(*) FROM insa ) �ѻ���� -- ��������
            , (SELECT COUNT(*) FROM insa WHERE buseo = t.buseo) �μ������ -- �����������
            , ����
            , COUNT(*) ��������� -- 2�������� �׷������ ������ �����
        FROM(   -- �ζ��κ�
            SELECT buseo, name, ssn
                , DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 1, 'M', 'F') ����
            FROM insa
        ) t
        GROUP BY buseo, ���� -- �μ����� ���̰� �� �μ� �ȿ��� ������ �𿩶�
        ORDER BY buseo, ����
    )
    SELECT temp.*
        , ROUND(�μ������/�ѻ���� * 100, 2) || '%' "�μ��ο�/��ü�ο�%"
        , ROUND(���������/�ѻ���� * 100, 2) || '%' "�μ��ο�/��ü�ο�%"
        , ROUND(���������/�μ������ * 100, 2) || '%' "�μ��ο�/�μ��ο�%"
    FROM temp
    ;

----
�ٸ��л���Ǯ��)
SELECT t1.buseo,
    (SELECT COUNT(*) FROM insa) �ѻ��,
    t2.�μ���,
    DECODE(t1.gender,1,'M','F') gender,
    t1.����,
    ROUND(t2.�μ���/(SELECT COUNT(*) FROM insa)*100,1) || '%' "��/��",
    ROUND(t1.����/(SELECT COUNT(*) FROM insa)*100,1) || '%' "��/��",
    ROUND(t1.����/t2.�μ���*100,1) || '%' "��/��"
FROM (
    SELECT buseo, 
        MOD(SUBSTR(ssn, -7, 1),2) gender,
        COUNT(*) ����
    FROM insa
    GROUP BY buseo, MOD(SUBSTR(ssn, -7, 1),2)
) t1 JOIN (
    SELECT buseo,
        COUNT(*) �μ���
    FROM insa
    GROUP BY buseo
) t2
ON t1.buseo = t2.buseo
ORDER BY t1.buseo;


[���ο��!! GROUP BY�� HAVING �� ���]
12. insa���̺��� �����ο����� 5�� �̻��� �μ��� ���.
    
    Ǯ��1) GROUP BY�� HAVING �� ���
    SELECT buseo, COUNT(*)
    FROM insa
    WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 0
    GROUP BY buseo
    HAVING COUNT(*) >= 5;
    
    Ǯ��2) ��������
    SELECT *
    FROM(
        SELECT buseo, COUNT(*) ���ڻ����
        FROM insa
        WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 0
        GROUP BY buseo
    ) t
    WHERE ���ڻ���� >= 5;

13. insa ���̺��� �޿�(pay= basicpay+sudang)�� ���� 15%�� �ش�Ǵ� ����� ���� ��� 

    SELECT buseo, name, pay, pay_rank
    FROM(
        SELECT buseo, name, basicpay + sudang pay
            , (SELECT COUNT(*) * 0.15 FROM insa) toppay
            , RANK() OVER(ORDER BY basicpay + sudang DESC) pay_rank
        FROM insa
    ) t
    WHERE pay_rank <= toppay;


14. emp ���̺��� sal�� ��ü��������� ��� , �μ��������� ����� ����ϴ� ���� �ۼ�
    
    Ǯ��1) �����Լ� ���
    SELECT deptno, ename, sal
        , RANK() OVER(ORDER BY sal DESC) ��ü���
        , RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) �μ����
    FROM emp
    ORDER BY deptno;
    
    Ǯ��2) ����������� ��� 
    SELECT deptno, ename, sal
        , (SELECT COUNT(*) FROM emp WHERE sal > e.sal ) + 1 ��ü��� -- �ۿ� �ִ� sal���� ���ο� �ִ� sal�� �� ū ����
        , (SELECT COUNT(*) + 1 FROM emp WHERE sal > e.sal AND deptno = e.deptno) �μ������
    FROM emp e
    ORDER BY deptno, �μ������;
    
----------------------------------------------------------------------------------------------
���ο� ����!!
1. [TRIM('Ư������' FROM ���ڿ�) �Լ�]
    ����) �� �ڿ� �ִ� Ư�����ڸ� �����ϰ�ʹ�.
        SELECT '***AD**MIN***'
       -- , REPLACE('***ADMIN***', '*', '') -- �߰��� �ִ� ���� ���Ű� ��
        , TRIM('*' FROM '***AD**MIN***')
        , TRIM(' ' FROM ' ADMIN')
    FROM dual;

-----
2. [NLS??]
    TO_CHAR(���ڳ�¥, 'fmt' [,nls param])
    nls param == nls param(�Ű�����, ����)
    --
    NLS? National Language Support
    NLS parameter�� SESSION, CLIENT, SERVER�� �� ������ �з��ȴ�.
    �� �� ���� �з��� �켱 ������ ������ ����.
    SESSION > CLIENT > SERVER
    server, client, session�� ȯ���� ���� �ٸ��ٸ�, session���� ������ ȯ���� ���� ���� �ȴ�.
     ��) ����Ŭ ������ �̱��� �ְ�(����) ���� �ѱ����� ����(Ŭ���̾�Ʈ)�ؼ� ��¥�� ���� �ѱ��� ��¥�� ������(Ŭ���̾�Ʈ)
        ���� �α����ϰ� �α׾ƿ��� �� ���� ��¥������ �Ϻ���¥�� ������ ���ǵ��� �Ϻ���¥�� ������.
        
    SELECT ename, sal, TO_CHAR(hiredate, 'YY/MON/DAY', 'NLS_DATE_LANGUAGE = JAPANESE')
    FROM emp;
    
    SELECT * FROM nls_session_parameters;
    
----------
3. [GROUP BY��, HAVING ��]

    SELECT
        COUNT(*) ��ü�����
        , COUNT(DECODE(deptno, 10, 'o')) "10���μ������"
        , COUNT(DECODE(deptno, 20, 'o')) "20���μ������"
        , COUNT(DECODE(deptno, 30, 'o')) "30���μ������"
        , COUNT(DECODE(deptno, 40, 'o')) "40���μ������"
    FROM emp;


    -- �� �μ��� ����� �ľ� -> 40�� ��� X
    UNION�� �÷� ������ ������ ��ġ�ؾ� �ȴ�.
    SELECT 0 deptno, COUNT(*)
    FROM emp
    UNION
    SELECT deptno, COUNT(*)
    FROM emp
    GROUP BY deptno
    ORDER BY deptno

����1) emp ���̺���
    ù��° 20��, 40�� �μ��� �����ϰ�
    �ι�° �� �� �μ��� ������� ����ϰ�
    ����° �� ������� 4�� �̻��� �μ������� ��ȸ
    �μ���ȣ, �μ���, ����� ���

    SELECT DISTINCT t.deptno, t.dname, t.�����
    FROM(
         SELECT e.deptno, dname 
             , (SELECT COUNT(*) FROM emp WHERE deptno = e.deptno) �����
         FROM emp e JOIN dept d ON e.deptno = d.deptno
         WHERE e.deptno NOT IN(20, 40)
    ) t
    WHERE ����� >= 4;
    
    ����� Ǯ��)
    SELECT t.*, dname
    FROM (
        SELECT deptno, COUNT(*) �����
        FROM emp
        WHERE deptno NOT IN(20, 40)
        GROUP BY deptno
    ) t JOIN dept d ON t.deptno = d.deptno
    WHERE ����� >= 4;
    
    
    �׷�ȭ ���� + ����(HAVING) ���)
    *** �����Լ� �ܿ� ��� �͵��� GROUP BY ���� �־�� ��. ***
    -- ORA-00918: column ambiguously defined   -> ���� �ſ� ���� �߻���..
    SELECT e.deptno, dname, COUNT(*)
    FROM emp e JOIN dept d ON e.deptno = d.deptno
    WHERE e.deptno NOT IN(20, 40)
    GROUP BY e.deptno, dname -- �����Լ� �ܿ� ��� �͵��� GROUP BY ���� �־�� ��.
    HAVING COUNT(*) >= 4;
    

����2) insa ���̺��� �� �μ��� �ȿ� �ִ� ���޺� ����� ���
    SELECT buseo, jikwi, COUNT(*) �����
    FROM insa
    GROUP BY buseo, jikwi
    ORDER BY buseo, jikwi;

����3) insa ���̺��� ���ڻ���鸸 �μ����� ������� ���ؼ� 6�� �̻��� �μ��� ���
    SELECT buseo, COUNT(*)
    FROM insa
    WHERE MOD(SUBSTR(ssn, -7, 2), 2) = 1
    GROUP BY buseo
    HAVING COUNT(*) >= 6;

-----
4. [GROUP BY ������ ROLLUP�� CUBE ����]
    1) ROLLUP ������
        (1) ROLLUP�� GROUP BY ���� �׷� ���ǿ� ���� ��ü ���� �׷�ȭ �ϰ�
        (2) �� �׷쿡 ���� �κ����� ���ϴ� �������̴�.
    2) CUBE ������
     (1) ROLLUP �����ڸ� ������ ����� ���� GROUP BY ���� ����� ���ǿ� ���� ��� ������ �׷��� ���տ� ���� ����� ����Ѵ�.
     
     GROUP BY ������ 1���� �ٸ��� ������ ������ ���� ���̸� ��� ���� �޶�����.
     GROUP BY �ڿ� ����� �÷��� 2���� ���
        ROLLUP�� n+1���� 3���� �׷캰 ����� ��µǰ�,
        CUBE�� 2*n���� 2*2=4���� ��� ���� ��µȴ�.
        ��) buseo, jikwi ���� 2��
            ROLLUP = 2+1 (�μ��� �����, ������ �����, �ѻ����)
            CUBE = 2*2 (�μ�+���� �����, �μ��� �����, ������ �����, �ѻ����)

����1) insa ���̺��� ���ڻ����, ���ڻ������ ��� - GROUP BY �� ���
    SELECT DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 1, '����', '����') ����, COUNT(*) �����
    FROM insa
    GROUP BY MOD(SUBSTR(ssn, -7, 1), 2)
    UNION ALL
    SELECT '��', COUNT(*) FROM insa;
 
[ROLLUP ���]
�׷�ȭ�� �κ����� ���� ���ؼ� UNION �� �ʿ䰡 ���� ROLLUP �����ڸ� ����ϸ� �ȴ�.
    SELECT DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 1, '����', 0, '����', '�ѻ����') ����, COUNT(*) �����
    FROM insa
    GROUP BY ROLLUP(MOD(SUBSTR(ssn, -7, 1), 2));
    
[CUBE ���]
    SELECT DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 1, '����', 0, '����', '�ѻ����') ����, COUNT(*) �����
    FROM insa
    GROUP BY CUBE(MOD(SUBSTR(ssn, -7, 1), 2));

---    
����2) insa ���̺��� �Ʒ��� ���� �μ��� ������� ���ϰ� ��ü ������� ���ϰ�ʹ�.
���ߺ�	����	2
���ߺ�	�븮	2
���ߺ�	����	1
���ߺ�	���	9
            14 (�κ���)
��ȹ��	�븮	3
��ȹ��	����	2
��ȹ��	���	2
            7 (�κ���)
            :
            6(�κ���)
            60(��ü�κ���)

    Ǯ��1) UNION ALL ���
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
    
    Ǯ��2) ROLLUP, CUBE ������ ���
    SELECT buseo, jikwi, COUNT(*) �����
    FROM insa
    GROUP BY CUBE(buseo, jikwi) -- �������� �յ� ���´�. ��, ��� �������� �հ谡 ���´�.
    ORDER BY buseo, jikwi;
    
    SELECT buseo, jikwi, COUNT(*) �����
    FROM insa
    GROUP BY ROLLUP(buseo, jikwi) -- �������� ���� ������ ����
    ORDER BY buseo, jikwi;

---
����3) emp ���̺��� job ���� ����� �� ������ ��ȸ

Ǯ��1) GROUP BY �� ���
SELECT job, COUNT(*)
FROM emp
GROUP BY job;

Ǯ��2) DECODE() �Լ�
SELECT COUNT(DECODE(job, 'CLERK', 'o')) CLERK
    , COUNT(DECODE(job, 'SALESMAN', 'o')) SALESMAN
    , COUNT(DECODE(job, 'PRESIDENT', 'o')) PRESIDENT
    , COUNT(DECODE(job, 'MANAGER', 'o')) MANAGER
    , COUNT(DECODE(job, 'ANALYST', 'o')) ANALYST
FROM emp;


5. [PIVOT(�ǹ�)]
 1) Oracle 11g �������� �����ϴ� �Լ�
 2) ��� ���� ������ �Լ�
 3) �ݴ�� ������ �� ���ǹ��̶�� �Ѵ�.
 
    [PIVOT ����]
    SELECT * 
    FROM (�ǹ� ��� ������) -- ��������
    PIVOT (�׷��Լ�(�����÷�) FOR �ǹ��÷� IN(�ǹ��÷� �� AS ��Ī...))

    SELECT * 
    FROM (SELECT job FROM emp)
    PIVOT (COUNT(job) FOR job IN('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST'));
    
    -- emp ���̺��� job �� 1��~12���� �Ի��� ����� ��
    SELECT * 
    FROM (SELECT job , TO_CHAR(hiredate, 'FMMM') || '��' hire_month FROM emp)
    PIVOT( COUNT(*) FOR hire_month IN ('1��', '2��', '3��', '4��', '5��', '6��'
                                        , '7��', '8��', '9��', '10��', '11��', '12��')  );


����1) insa ���̺��� ������ ������� ��ȸ�ϰ�ʹ�.
1��) GROUP BY
SELECT MOD(SUBSTR(ssn, -7, 1), 2), COUNT(*)
FROM insa
GROUP BY MOD(SUBSTR(ssn, -7, 1), 2);

2��) DECODE �Լ�
SELECT COUNT(DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 1, '��')) "����"
    ,COUNT(DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 0, '��')) "����"
FROM insa;

3��) PIVOT �Լ�
SELECT *
FROM (SELECT MOD(SUBSTR(ssn, -7, 1), 2) ���� FROM insa)
PIVOT( COUNT(*) FOR ���� IN (1 AS "����" , 0 AS "����") );

