-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]

1. �����Լ� == �׷��Լ� == ������ �Լ�
*** ������ ��) NULL ���� ������ ***
SUM(n) : NULL ���� ������ n�� �հ�
AVG(n) : NULL ���� ������ N�� ���� ��հ��� �����Ѵ�.
COUNT(n) : NULL�� ������ ���� ������ �����Ѵ�. COUNT(*)�� NULL ���� ������ ��(���ڵ�)����.
MAX() : �ִ밪�� �����Ѵ�.
MIN() : �ּҰ��� �����Ѵ�.
STDDEV(n) : NULL ���� ������ǥ������ ���ϴ� �Լ�
VARIANCE(n) : NULL ���� ������ �л갪 ���ϴ� �Լ�

    ����1) emp ���̺��� �ְ�޿����� �޴� ����� ������ ���
    SELECT *
    FROM emp
    WHERE  sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp);
    
    ����2) emp ���̺��� �����޿��� �޴� ����� ������ ���
    SELECT *
    FROM emp
    WHERE sal + NVL(comm, 0) = (SELECT MIN(sal + NVL(comm, 0)) FROM emp);
    
    ����3) emp ���̺��� �ְ�, ���� �޿��� �޴� ����� ������ ��ȸ
    1�� Ǯ��-- UNION ���
    SELECT *
    FROM emp
    WHERE  sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp)
    UNION
    SELECT *
    FROM emp
    WHERE sal + NVL(comm, 0) = (SELECT MIN(sal + NVL(comm, 0)) FROM emp);
    
    2�� Ǯ��-- OR ���
    SELECT *
    FROM emp
    WHERE sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp)
            OR sal + NVL(comm, 0) = (SELECT MIN(sal + NVL(comm, 0)) FROM emp);
    
    3�� Ǯ��-- IN (LIST)
    ������ ��) ���������� ���ļ� IN ������ ������ �����߻�
    SELECT *
    FROM emp
    WHERE sal + NVL(comm, 0) IN( (SELECT MAX(sal + NVL(comm, 0)) FROM emp)
                                , (SELECT MIN(sal + NVL(comm, 0)) FROM emp));
                                
    SELECT *
    FROM emp
    WHERE sal + NVL(comm, 0) IN( (SELECT MAX(sal + NVL(comm, 0) , MIN(sal + NVL(comm, 0)) FROM emp) );
    
    --
    ALL�� EXISTS ������ ������
    <ALL ������>
    -- ��� ����� �޿����� ũ�ų� ����? ��, �ְ�޿���
    -- ��� ����� �޿����� �۰ų� ����? ��, �����޿���
    -- ALL �����ڿ� �񱳿����ڸ� ���� ���
    SELECT *
    FROM emp
    WHERE  sal + NVL(comm, 0) <= ALL ( SELECT sal + NVL(comm, 0) FROM emp);
    WHERE  sal + NVL(comm, 0) >= ALL ( SELECT sal + NVL(comm, 0) FROM emp);
    
    <���������� ���>
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
    
    <EXISTS ���> : �����ϴ��� ����� �Լ�
    SELECT DISTINCT mgr FROM emp WHERE mgr IS NOT NULL : �� ���������� ���� ���̸�
    WHERE EXISTS() : �����ϸ� true ���� ��ȯ�ϱ� ������ ��ü ����� ����
    
    SELECT *
    FROM emp
    WHERE EXISTS (SELECT DISTINCT mgr FROM emp WHERE mgr IS NOT NULL);
    
    -- WHERE EXISTS (SELECT deptno FROM dept);

����1. EMP ���̺��� ������� ��ȸ�ϴ� ���� �ۼ�.

SELECT COUNT(*) "�Ѱ���" -- 12�� 
    -- , comm ORA-00937: not a single-group group function -> ���� ����~~
    , COUNT(comm) "������" -- 4�� (NULL ���� ������ ����)
    , SUM( sal + NVL(comm, 0)) "�ѱ޿�"
    , ROUND(AVG( sal + NVL(comm, 0) ), 2) "��ձ޿�"
    , MAX(sal + NVL(comm, 0)) "�ְ�޿�"
    , MIN(sal + NVL(comm, 0)) "�����޿�"
FROM emp;

����2. ���� �ý�����   ��¥�� ����ϴ� ���� �ۼ�
SELECT SYSDATE -- ���� �ý����� ��¥/�ð�
        , CURRENT_DATE -- ���� ������ ��¥/�ð�
        , CURRENT_TIMESTAMP -- ���� ������ ��¥/�ð� + ������(Ȯ��)
FROM dual;

����3. SQL ���� �������� ������ ������ �ϼ���
UNION ������
UNION ALL �ߺ��� �͵鵵 ���
MINUS ������
INTERSECT ������

����4. �Լ� ����
  ��. �ݿø� �Լ��� ���������� ���� �����ϼ���
	ROUND(a, b) a�� b+1�ڸ����� �ݿø�, ������ ��� b�� �����ڸ����� �ݿø�

  ��. ����(����) �Լ��� ���������� ���� �����ϼ���.
	FLOOR() -> �Ҽ��� 1��° �ڸ����� ����
	TRUNC(a, b) -> a�� b+1�ڸ����� ����, ������ ��� �����ڸ����� ����

  ��. ����(�ø�) �Լ��� ���������� ���� �����ϼ���.    
	CEIL() -> �Ҽ��� 1��° �ڸ����� �ø��Ѵ�.
  
����5. �Խ��ǿ��� �� �Խñ� ���� : 65 �� �̰�  �� �������� : 15���� �Խñ� ����� ��
    �� ������ ���� ����ϴ� ���� �ۼ�.
SELECT ceil(65/15)
FROM dual;
    
����6. emp ���̺��� ������� ��� �޿����� ���� �޿��� ������ 1
                                     ���� �޿��� ������ -1
                                     ������           0 
  �� ����ϴ� ���� �ۼ�.
SELECT ename , sal+NVL(comm,0) pay
    --, ROUND((SELECT SUM(sal+NVL(comm,0)) / COUNT(*) FROM emp))
    --, NVL2(NULLIF(SIGN(ROUND((SELECT SUM(sal+NVL(comm,0)) / COUNT(*) FROM emp), 2) - sal + NVL(comm, 0)), 1), '����', '����')
    , (SELECT ROUND(AVG(sal+NVL(comm,0)), 0) FROM emp) avg_pay
FROM emp;

<�������� ���>
SELECT t.ename, t.pay, t.avg_pay
        ,SIGN(t.pay - t.avg_pay)
FROM(
    SELECT ename, sal+NVL(comm,0) pay
         , (SELECT ROUND(AVG(sal+NVL(comm,0)), 0) FROM emp) avg_pay
         FROM emp
) t;

����7. insa���̺��� 80���( 80��~89��� )�� ����� ����鸸 ��ȸ�ϴ� ������ �ۼ�
  ��. LIKE ���
    SELECT *
    FROM insa
    WHERE ssn LIKE '8%';
  
  ��. REGEXP_LIKE ���
  
  SELECT 
  FROM insa
  
  FROM insa
  WHERE REGEXP_
  ��. BETWEEN ~ AND ���   
  
����8. insa ���̺��� �ֹε�Ϲ�ȣ�� 123456-1******  �������� ����ϼ��� . ( LPAD, RPAD �Լ� ���  )
[������]
ȫ�浿	770423-1022432	770423-1******
�̼���	800423-1544236	800423-1******
�̼���	770922-2312547	770922-2******

SELECT RPAD(SUBSTR(ssn, 0, 8), 14, '*')
FROM insa;

����8-2. emp ���̺��� 30�� �μ��� PAY�� ��� �� ����׷����� �Ʒ��� ���� �׸��� ���� �ۼ�
   ( �ʿ��� �κ��� ��� �м��ϼ���~    PAY�� 100 ������ # �Ѱ� , �ݿø�ó�� )
[������]
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



����8-3. insa ���̺���  �ֹι�ȣ�� �Ʒ��� ���� '-' ���ڸ� �����ؼ� ���
[������]
NAME    SSN             SSN_2
ȫ�浿	770423-1022432	7704231022432
�̼���	800423-1544236	8004231544236
�̼���	770922-2312547	7709222312547

SELECT ssn
    , SUBSTR(ssn, 0, 6) || SUBSTR(ssn, -7, 6)
    , REPLACE(ssn, '-', '')
FROM insa;

<��¥ �Լ��� ���� - ���ο� ����!!!>
����9. emp ���̺��� �� ����� �ٹ��ϼ�, �ٹ� ������, �ٹ� ����� ����ϼ���.
��¥�� - ��¥�� = �ϼ�
��¥�� + ������ = ����(�ϼ�)��ŭ ������ ��¥
��¥�� - ������ = ����(�ϼ�)��ŭ ���� ��¥
��¥�� + ����/24 = �ð��� ������ ��¥��
��¥�� - ����/24 = �ð��� ���� ��¥��

�ٹ��ϼ� / 365 = �ٹ����

MONTHS_BETWEEN() �Լ� : ��¥, ��¥ ������ ������ �����ϴ� �Լ�

SELECT empno, ename, hiredate 
    , CEIL( ABS( hiredate - SYSDATE ) ) �ٹ��ϼ�
    , ROUND(ABS(MONTHS_BETWEEN(hiredate, SYSDATE)), 2) �ٹ�������
    , ROUND( ABS(MONTHS_BETWEEN(hiredate, SYSDATE)) / 12 , 2) �ٹ����
FROM emp;

����10. �����Ϸκ��� ���ó�¥������ �����ϼ� ? -- ��,��,������ ������ �ϼ�
( ������ : 2022.2.15 )

-- ORA-00932: inconsistent datatypes: expected CHAR got DATE
-- �ؼ� : CHAR�� DATE ������ Ÿ���� ���� �ʴ´�.
-- ����Ŭ '���ڿ�' '��¥��'
-- '2022.02.15' ��¥���� �ƴ� ���ڿ��� ó��
-- ���ڿ��� ��¥������ ����ȯ�ϴ� �� -> TO_DATE(char [,'fmt' [,'nlsparam']])
-- ���ڿ��� ���������� ����ȯ�ϴ� �� -> TO_NUMBER()
-- ���� ���ڷ� �̷���� ���ڿ��� ���������� ����ȯ�� �� ex) '20' -> 20
-- ���ڿ� �ڷ��� : CHAR, VARCHAR2, NCHAR, NVARCHAR2 

SELECT '2022.02.15' - SYSDATE
FROM dual;

SELECT ABS(TO_DATE('2022.02.15') - SYSDATE) �����ϼ�
        , ABS(TO_DATE('02/15/2022', 'MM/DD/YYYY') - SYSDATE) �����ϼ�2
    -- TO_DATE('02/15/2022')
    -- ORA-01841: (full) year must be between -4713 and +9999, and not be 0
    -- ��¥ ������ ���� �ʾƼ� �߻���, fmt�� �������ָ� �ذ� ����!
FROM dual;

    
����10-2.  ���ú��� �����ϱ��� ���� �ϼ� ?  
( ������ : 2022.7.29 ) 
SELECT CEIL( ABS(TO_DATE('2022.07.29') - SYSDATE))
FROM dual;

����10-3. emp ���̺��� �� ����� �Ի����� �������� 100�� �� ��¥, 10���� ��¥
                        , 1�ð� �� ��¥, 3���� �� ��¥ ���

SMITH	80/12/17	81/03/27	80/12/07	80/12/17	81/03/17	80/09/17
ALLEN	81/02/20	81/05/31	81/02/10	81/02/20	81/05/20	80/11/20
WARD	81/02/22	81/06/02	81/02/12	81/02/22	81/05/22	80/11/22

SELECT ename, hiredate
    , hiredate + 100 "100����"
    , hiredate - 10 "10����"
    , hiredate + 1/24 "1�ð���"
    , ADD_MONTHS(hiredate, 3) "3������"
    , ADD_MONTHS(hiredate, -3) "3������"
FROM emp;

-- MONTHS_BETWEEN() ������
SELECT t.first, t.second
    , MONTHS_BETWEEN( t.first, t.second) -- 31�� �������� ������ �������� �Ҽ���
FROM(
    SELECT TO_DATE('03-01-2022', 'MM-DD-YYYY') first
            , TO_DATE('02-01-2022', 'MM-DD-YYYY') second
    FROM dual
) t;

-- ADD_MONTHS() �Լ� : ������ ���ϱ� �����ϴ� �Լ�
-- ���� �������Ͽ��� ���ϸ� �������� ������ ��¥�� ������
SELECT ADD_MONTHS(TO_DATE('03-01-2022', 'MM-DD-YYYY'), 1) ����1
        ,ADD_MONTHS(TO_DATE('03-01-2022', 'MM-DD-YYYY'), -2) ����2
        ,ADD_MONTHS(TO_DATE('02-28-2022', 'MM-DD-YYYY'), 1) ����3 -- 22/03/31
        ,ADD_MONTHS(TO_DATE('02-27-2022', 'MM-DD-YYYY'), 1) ����4 -- 22/03/27
FROM dual;

-- LAST_DAY() �Լ��� Ư����¥�� ���� ��(��)�� ���� ������ ��¥�� ��ȯ�Ѵ�.
SELECT LAST_DAY(SYSDATE)
        , TO_CHAR(LAST_DAY(SYSDATE), 'DD') -- ���ڸ� ������
FROM dual;

-- NEXT_DAY(date,char) �Լ��� ��õ� ������ ���ƿ��� [���� �ֱ��� ��¥]�� �����ϴ� �Լ�
-- ex) ���ƿ��� �ݿ����� ����?

SELECT SYSDATE
    , TO_CHAR(SYSDATE, 'D') ����1 -- 2:������ / 1(��) ~ 7(��)
    , TO_CHAR(SYSDATE, 'DY') ����2 
    , TO_CHAR(SYSDATE, 'DAY') ����3
    , NEXT_DAY(SYSDATE, '�ݿ���') ����4 -- ���ƿ��� �ݿ���
    , NEXT_DAY(SYSDATE, '������') ����5 -- ���ƿ��� ������
    , NEXT_DAY(NEXT_DAY(SYSDATE, '�ݿ���'), '�ݿ���') ����5 -- ������ �ݿ���
FROM dual;


����11. function ����
 ��. ASCII() - ���ڸ� ASCII �ڵ� ������ ��ȯ���ִ� �Լ�
 ��. CHR() - ASCII �ڵ带 ���ڷ� ��ȯ���ִ� �Լ�
 ��. GREATEST(args...) - ���� ū ���� �������� �Լ�
 ��. LEAST(args...) - ���� ���� ���� �������� �Լ�
 ��. UPPER() - �빮�ڷ� ��ȯ���ִ� �Լ�
 ��. LOWER() - �ҹ��ڷ� ��ȯ���ִ� �Լ�
 ��. LENGTH() - ���ڿ� ���̸� ��ȯ���ִ� �Լ�
 ��. SUBSTR() - ���ڿ��� ���ϴ� ��ġ���� ���ϴ� ���̸�ŭ �߶��ִ� �Լ�
 ��. INSTR() - ���ϴ� ���ڰ� ��� �ִ��� �˷��ִ� �Լ�


***** ��¥ �����ϴ� �� �����ϱ�
����12.
SELECT TRUNC( SYSDATE, 'YEAR' ) -- 2022/01/01
     , TRUNC( SYSDATE, 'MONTH' )     -- 2022/04/01 
     , TRUNC( SYSDATE  ) -- 2022/04/11 (00:00:00)
FROM dual;
    ���� ������ ����� �������� . 

SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS')
 -- 2022/04/11 12:01:10 -> SYSDATE�� �ð����� ������ ����
FROM dual;

---------------------------------------------------------------
��������!!
--
����) �̹� �� ���� ���ҳ���?
SELECT SYSDATE
    , LAST_DAY(SYSDATE)
    , LAST_DAY(SYSDATE) - SYSDATE 
FROM dual;

1. ��ȯ�Լ�(����ȯ �Լ�)
1) TO_NUMBER() : ���� -> ���� : �ڵ�����(������) ���ڸ� ���ڷ� ��ȯ�� �Ǿ �� ���X
2) TO_DATE() : ���� -> ��¥
3) TO_CHAR : ����,��¥ -> ����

<TO_NUMBER() �Լ�~!>
    SELECT '10' -- ���� ��������
            , 10 -- ���� ����������
            , TO_NUMBER('10')
            , '10' + 10 -- ���ڷ� ��ȯ�� ��
    FROM dual;
    
    -- insa ���̺��� ���� ���
    SELECT *
    FROM insa
    WHERE MOD( SUBSTR(ssn, -7, 1), 2) = 1;
    -- SUBSTR�� ���ڷ� ��ȯ�� �ִµ� ���ڿ� ���ص� ���� ������.
    -- MOD ������ ���ϴ� �Լ��ε� ���ڿ��ε� �����ߴ�.
    -- ��, ���������� ���ڸ� ���ڷ� ��ȯ���ְ� �־��� ->  �ڵ�����ȯ

<TO_DATE() �Լ�~!>
    SELECT TO_DATE('2022-02-15')
        , TO_DATE('02-15-2022', 'MM-DD-YYYY')
            -- ��¥ ���� ������� �ƴϸ� ���������� �����������
        , TO_DATE('2022', 'YYYY')
            -- �⵵�� �ִ� ���ڿ��� ��¥�� ��ȯ�ϸ� ���� �ش��, ���� 1�Ϸ� ����
        , TO_DATE('2022.03', 'YYYY.MM')
            -- �⵵, ���� ������ ���� �ڵ����� 1�� ����
        , TO_DATE('20', 'DD')
            -- �ش�⵵�� �ش���� �ڵ� ��������
    FROM dual;
 
<TO_CHAR() �Լ�~!>
    SELECT SYSDATE ��¥
        , TO_CHAR(SYSDATE, 'YYYY') �⵵ -- ��¥�κ��� �⵵�� ������ ���ڿ��� ��ȯ : 2022
        , TO_CHAR(SYSDATE, 'MM') �� -- ��¥�κ��� �⵵�� ������ ���ڿ��� ��ȯ : 2022
        , TO_CHAR(SYSDATE, 'DD') �� -- ��¥�κ��� �⵵�� ������ ���ڿ��� ��ȯ : 2022
        , TO_CHAR(SYSDATE, 'HH') �ð�
        , TO_CHAR(SYSDATE, 'HH24') �ð�
        , TO_CHAR(SYSDATE, 'MI') ��
        , TO_CHAR(SYSDATE, 'SS') ��
        , TO_CHAR(SYSDATE, 'D') ���� -- 1(��) ~ 7(��)
        , TO_CHAR(SYSDATE, 'DY') ���� -- ��
        , TO_CHAR(SYSDATE, 'DAY') ���� -- ������
        , TO_CHAR(SYSDATE, 'CC') ����
        , TO_CHAR(SYSDATE, 'Q') �б�
        , TO_CHAR(SYSDATE, 'WW') ���߸��°�� -- 15��
        , TO_CHAR(SYSDATE, 'W') ���߸��°�� -- 2��
        , TO_CHAR(SYSDATE, 'IW') ���߸��°�� -- 15��
        , TO_CHAR(SYSDATE, 'TS') �ð�ǥ�� -- ���� 12:39:22
    FROM dual;
    
    -- ������� 2022�� 4�� 11�� ���� 12:40:12
    SELECT TO_CHAR(SYSDATE, 'YYYY') || '�� '
            || TO_CHAR(SYSDATE, 'MM') || '�� '
            || TO_CHAR(SYSDATE, 'DD') || '�� '
            || TO_CHAR(SYSDATE, 'TS') ��¥�ð�
    FROM dual;
    
    SELECT TO_CHAR(SYSDATE, 'YYYY"�� "MM"�� "DD"�� "TS')
    FROM dual;
    
    --
    
    SELECT 1234567
         -- ���ڸ����� �޸��� ���� ���ڿ��� ��ȯ
        , TO_CHAR(1234567, '9,999') -- ###### : �ڸ����� ������
        , TO_CHAR(1234567, 'L9,999,999.99')
        , TO_CHAR(12, '0999')
    FROM dual;

--
    
    SELECT ename, TO_CHAR(sal + NVL(comm, 0), 'L9,999.00') pay
    FROM emp;
    
    SELECT name, TO_CHAR(basicpay + sudang, 'L9,999,999') pay
    FROM insa;
    
    ����1) emp ���̺��� �� ����� �Ի����ڸ� �������� 10�� 5���� 20��° �Ǵ� ����??
    
    SELECT ename, hiredate
        , ADD_MONTHS(hiredate + 20, 10 * 12 + 5)
    FROM emp;
    
    ����2) ���ڿ� '2021�� 12�� 23��' -> ��¥��
    SELECT TO_DATE('2021�� 12�� 23��', 'YYYY"��" MM"��" DD"��"')
    FROM dual;
    
    ����3) insa ���̺��� ssn(�ֹι�ȣ)�� ���ؼ� ���� ������
        ������ �������� ���� �����ٸ� -1
        ������ �����̶�� 0
        ������ �������� ������ �������ٸ� 1
        + �ð��� ��������ߵ�! �ð������� ���� ������ ����� ������ �����ٰ� ����
        
    SELECT name, ssn
        , TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD' ) ����
        , SIGN( TO_DATE( SUBSTR( ssn, 3, 4 ), 'MMDD' ) - TRUNC( SYSDATE ) ) ��������Ȯ��
    FROM insa;

------------------------

2. �Ϲ� �Լ� 3����!!!!!
1) COALESCE(expr1 [,expr2,...]) : ���� ���������� üũ�ؼ� NULL�� �ƴ� ���� ��ȯ�ϴ� �Լ�
��, NULL�� �ƴ� ���� ã�ư��� �Լ�
    
    SELECT ename, sal, comm
            , sal + NVL(comm, 0) pay
            , sal + NVL2(comm, comm, 0) pay
            , sal + COALESCE(comm, 0) pay
            , COALESCE(sal + comm, sal, 0) pay
    FROM emp;

***** 2) DECODE() : ���� ���� ������ �־� ���ǿ� ���� ��쿡 �ش� ���� �����ϴ� �Լ� *****
    (1) ���α׷� ���(�ڹ�)�� if���� ����ϴ�.
        (3) ���ǽĿ� == �̰� �ϳ��ۿ� ����. if( == )
    (2) FROM �������� ����� �� ����.
    (3) PL/SQL ������ ����鿩 ����ϱ� ���Ͽ� ������� ����Ŭ �Լ��̴�.
    (4) DECODER() �Լ��� Ȯ�� �Լ��� CASE() �Լ�
    
    -- �ڹٽ��� DECODE �Լ���..--
    int x = 10;
    if( x == 11) {
        return C;
    }
    
    --> DECODE �Լ��� ����
    DECODE(x, 11, C);
    x�� 11�ϰ� ����? ������ C�� �����ض�
    
    if(x == 10){
        return A
    } else{
        return B
    }
    
    --> DECODE �Լ��� ����
    DECODE(x, 10, A, B);
    x�� 10�ϰ� ����? ������ A�� ���� ������ B�� �����ض�
    
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
    
    --> DECODE �Լ��� ����
    DECODE(x, 1, A, 10, B, 12, C, 14, D, E);
    x�� 1�̸� A, 10 �̸� B, 12�̸� C, 14�̸� D, �� �ƴϸ� E�� ����
    
    --
    ����1) insa ���̺��� ssn(�ֹι�ȣ) ������ ���ͼ�
        ���� �������� '���� ��', ���� �����̸� '���� ����', ���� ���������� '���� ��'
    SELECT name, ssn
        , TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD' ) ����
        , DECODE(SIGN( TO_DATE( SUBSTR( ssn, 3, 4 ), 'MMDD' ) - TRUNC( SYSDATE ) )
        , -1, '���� ��'
        , 0, '���� ����'
        , 1, '���� ��') ��������Ȯ��
    FROM insa;
    
    --
    ����2) insa ���̺��� ssn�� ������ ����/���ڶ�� ������ ���
    SELECT name, ssn
        , DECODE( MOD( SUBSTR(ssn, -7, 1), 2), 1, '����', '����')
    FROM insa;


    ����3) insa ���̺��� ���� �����, ���� ����� ���
    SELECT COUNT(*) �ѻ����
        , COUNT( DECODE( MOD( SUBSTR(ssn, -7, 1), 2), 1, '����') ) ���ڻ����
        , COUNT( DECODE( MOD( SUBSTR(ssn, -7, 1), 2), 0, '����') ) ���ڻ����
    FROM insa;
    
    -- �߰� ���� --
    SELECT ssn 
        , DECODE( MOD( SUBSTR(ssn, -7, 1), 2), 1, '����') ���ڻ���� -- ���� ����� null�� ����
    FROM insa;
   
    
    ����4) emp ���̺��� �ѻ����, 10��, 20��, 30��, 40�� �μ������ ���
    SELECT COUNT(*) �ѻ����
        , COUNT(DECODE( deptno, 10, 10)) "10���μ������"
        , COUNT(DECODE( deptno, 20, 20)) "20���μ������"
        , COUNT(DECODE( deptno, 30, 30)) "30���μ������"
        , COUNT(DECODE( deptno, 40, 40)) "40���μ������"
    FROM emp;
       
    
    ����5) emp ���̺��� �� �μ��� �޿��� ��ȸ
    deptno, sal + NVL(comm, 0)
    SELECT SUM(sal + NVL(comm, 0)) total_pay
            , SUM( DECODE( deptno, 10, sal + NVL(comm, 0) )) pay_10
            , SUM( DECODE( deptno, 20, sal + NVL(comm, 0) )) pay_20
            , SUM( DECODE( deptno, 30, sal + NVL(comm, 0) )) pay_30
            , SUM( DECODE( deptno, 40, sal + NVL(comm, 0), 0 )) pay_40
    FROM emp;
    
    
    ����6) emp ���̺��� �� ������� ��ȣ, �̸�, �޿�(pay) ���
            10�� �μ����̶�� �޿� 15% �λ�
            20�� �μ����̶�� �޿� 5% �λ�
            ������ �μ����̶�� �޿� 10% �λ�
        
    SELECT deptno, empno, ename, sal + NVL(comm, 0) pay
            , DECODE( deptno, 10, (sal + NVL(comm, 0)) * 1.15
                    , 20, (sal + NVL(comm, 0)) * 1.05
                    , (sal + NVL(comm, 0)) * 1.10 ) �λ�ȱ޿�
    FROM emp;
    
    
    ����7) insa ���̺��� �� ����� �Ҽӵ� �μ��� ������ �?
    SELECT COUNT(DISTINCT buseo)
    FROM insa;

3) CASE() : DECODE �Լ��� Ȯ���Լ�
    (1) ���� �񱳰� �����ϴ�.
    (2) IF~THEN~ELSE����� �Ȱ��� ����� ����� �� �ִ�.
    (3) �������, ���迬��, ������� ���� �پ��� �񱳰� �����ϴ�.
    (4) WHEN ������ ǥ������ �پ��ϰ� ������ �� �ִ�.
    
    ������1��
        CASE �÷���|ǥ���� WHEN ����1 THEN ���1
                  [WHEN ����2 THEN ���2
                                    ......
                   WHEN ����n THEN ���n
                  ELSE ���4]
        END [ALIAS ��Ī]-- if���� ��ȣ �ݴ� �Ͱ� ����
        
    ������2��
        CASE �÷���|ǥ���� WHEN ����1 THEN ���1
                  [WHEN ����2 THEN ���2
                                    ......
                   WHEN ����n THEN ���n
                  ELSE ���4]
        END [ALIAS ��Ī]-- if���� ��ȣ �ݴ� �Ͱ� ����       

------  
     ����1) emp ���̺��� �� ������� ��ȣ, �̸�, �޿�(pay) ���
            10�� �μ����̶�� �޿� 15% �λ�
            20�� �μ����̶�� �޿� 5% �λ�
            ������ �μ����̶�� �޿� 10% �λ�
        
    SELECT deptno, empno, ename, sal + NVL(comm, 0) pay
        , CASE deptno
                WHEN 10 THEN (sal + NVL(comm, 0)) * 1.15
                WHEN 20 THEN (sal + NVL(comm, 0)) * 1.05
                ELSE (sal + NVL(comm, 0)) * 1.1
          END pay2
    FROM emp
    ORDER BY deptno ASC;
    
------  
    ����2) insa ���̺��� ssn�� ������ ��/�� ���� ���
    SELECT name, ssn
        , CASE MOD(SUBSTR(ssn, -7, 1), 2)
            WHEN 1 THEN '����'
            ELSE '����'
          END ����
        , CASE
            WHEN MOD(SUBSTR(ssn, -7, 1), 2) = 1 THEN '����'
            ELSE '����'
          END ����2
        , CASE
            WHEN SUBSTR(ssn, -7, 1) IN(1,3,5,7,9) THEN '����'
            ELSE '����'
          END ����3        
    FROM insa;
    
----------------------------------
3. SELECT �� 7���� �� �߿� GROUP BY �� ����
        WITH
        SELECT
        FROM
        WHERE
        GROUP BY �� ����
        HAVING
        ORDER BY
    
    ����1) insa ���̺��� ����/���� ����� ����ϴ� ���� �ۼ�  
    SELECT MOD(SUBSTR(ssn, -7, 1) , 2), COUNT(*) "�ο���"
    FROM insa
    GROUP BY MOD(SUBSTR(ssn, -7, 1) , 2);
    
    ----
    ����2) emp ���̺� �� �μ��� ��� �� ���
        ������ : ����� ���� �μ��� �ƿ� ����� �ȵȴ�.
    SELECT deptno, COUNT(*)
    FROM emp
    GROUP BY deptno
    ORDER BY deptno;




