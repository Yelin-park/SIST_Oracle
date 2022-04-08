-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]

1. ���� �޽����� ���ؼ� �����ϼ��� .
 ��. ORA-01438: value larger than specified precision allowed for this column
	-> �÷��� ������ �ڷ����� ũ�⺸�� �� ū ���� ���ͼ� �߻��� ����
 ��. ORA-00001: unique constraint (SCOTT.PK_DEPT) violated
		-> ����Ű ���Ἲ ����ȴ�.
 ��. ORA-00923: FROM keyword not found where expected 
		-> FROM ������ ���� �߻� ö�� �Ǵ� , Ȯ�� �غ���
 ��. ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
		-> �θ����̺� 10,20,30,40 �μ���ȣ�� �ִµ� �ڽ����̺��� 60�μ� ��� �߰��Ѵٰ� �ϸ� �߻��ϴ� ����

6. insa ���̺��� ���ڴ� 'X', ���ڴ� 'O' �� ����(gender) ����ϴ� ���� �ۼ� @@@@@

-- 1�� �ٸ� ��� Ǯ��
SELECT t.*
      , REPLACE(REPLACE(t.gender, '1', 'X'), '2', 'O') GENDER
FROM(
    SELECT name, ssn
        , SUBSTR(ssn, -7, 1) gender
    FROM insa
) t;

-- ����� Ǯ��
NULLIF �Լ�
�ΰ��� ���� ���Ͽ� �ΰ��� ���� ������ NULL �� ��ȯ
���� ������ ù��° �Ű��������� ��ȯ���ִ� �Լ�

SELECT name, ssn
    , SUBSTR(ssn, -7, 1) gender
    , MOD(SUBSTR(ssn, -7, 1), 2) gender
    , NVL2( NULLIF( MOD(SUBSTR(ssn, -7, 1), 2), 1 ), 'O', 'X') gender
FROM insa;

-- ���� : ���� ���ĵǾ��� ������ ���ڿ� '1'
-- ���� : ������ ���ĵǾ��� ������ ���� 1

    NAME                 SSN            GENDER
    -------------------- -------------- ------
    ȫ�浿               771212-1022432    X
    �̼���               801007-1544236    X
    �̼���               770922-2312547    O
    ������               790304-1788896    X
    �Ѽ���               811112-1566789    X

7. insa ���̺��� 2000�� ���� �Ի��� ���� ��ȸ�ϴ� ���� �ۼ�

SELECT name, ibsadate
FROM insa
-- WHERE TO_CHAR(ibsadate, 'RRRR') >= 2000
WHERE EXTRACT(YEAR FROM ibsadate) >= 2000
ORDER BY ibsadate ASC;

    NAME                 IBSADATE
    -------------------- --------
    �̹̼�               00/04/07
    �ɽ���               00/05/05
    �ǿ���               00/06/04
    ������               00/07/07
    
8-1. Oracle�� ��¥�� ��Ÿ���� �ڷ��� 2������ ��������.
   ��. TIMESTAMP
   ��. DATE
   
8-2. ���� �ý����� ��¥/�ð� ������ ����ϴ� ������ �ۼ��ϼ���.

SELECT SYSDATE, CURRENT_DATE, CURRENT_TIMESTAMP
FROM dual;

SYSDATE�� �Լ��̸�, ����ý����� ��¥ + �ð�, ��, �� ���������� ������ ������ �ִ� �Լ��̴�.
CURRENT_DATE�� �Լ��̸�, ���� ����(session)�� ��¥ + �ð�, ��, �� ��ȯ / ������ Ÿ���� �׷����� Ķ����
CURRENT_TIMESTAMP�� �Լ��̸�, ��¥ + �ð�, ��, ��, �и������� ��ȯ

10. emp ���̺��� �����(ename)�� 'e'���ڸ� ������ ����� �˻��ؼ� �Ʒ��� ���� ���.

SELECT ename
    -- , REPLACE(ename, UPPER('e'), UPPER('[e]')) SEARCH_ENAME
    ,REPLACE(ename, UPPER( :input ), '[' || UPPER( :input ) || ']') SEARCH_ENAME
FROM emp
WHERE REGEXP_LIKE(ename, :input, 'i');
-- WHERE ename REGEXP_LIKE(ename, :������, 'i');

-- �Է��� �� �ֵ��� ���ε� ����(bind variable)�� �ش�.
:������
1) ���ε� ������� �Ѵ�.
2) ����(session)�� �����Ǵ� ���� ����� �� �ִ� ����

-----------------------------------------------------------------------

13. insa ���̺��� 
   ��. �������(city)�� ��õ�� ����� ����(name,city,buseo)�� ��ȸ�ϰ�
   ��. �μ�(buseo)�� ���ߺ��� ����� ����(name,city,buseo)�� ��ȸ�ؼ�
   �� ������� ������(UNION)�� ����ϴ� ������ �ۼ��ϼ���. 
   ( ���� : SET(����) ������ ��� )
SELECT name, city, buseo
FROM insa
WHERE city = '��õ'
UNION   
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�';

-- OR ������ ����Ͽ� ���� ���� ����� ����
SELECT name, city, buseo
FROM insa
WHERE city = '��õ' OR buseo = '���ߺ�';

------------------------------------------------------------------------------
��������!!

1. SET ������

1) UNION ALL : �ߺ��Ǵ��� ��� ����ϰڴ�.
��õ  ��õ & ���ߺ�    ���ߺ�
3��      6��          8��   UNION = 17��
                           UNION ALL = 3 + 6 + 6 + 8 = 23��

SELECT name, city, buseo
FROM insa
WHERE city = '��õ'
UNION ALL  
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�';

�Ʒ��� ���� �ٸ� ���̺� �ִ� �͵��� UNION���� Ȱ���Ͽ� ������ �� �ִ�.
��, ���������� �ϴ� �÷����� �ڷ����� ������� �����ؾ� �ϰ� ������ �÷��� ������ �����ؾ��Ѵ�.
SELECT ename, sal
FROM emp
UNION
SELECT  name, ename
FROM insa;

----

2) MINUS : ������(�������� ���� ������..)
-- ��õ�ε� ���ߺδ� ����

SELECT name, city, buseo
FROM insa
WHERE city = '��õ'
MINUS
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�';

-- AND ������ ����Ͽ� ���� ���� ����� ����
SELECT name, city, buseo
FROM insa
WHERE city = '��õ' AND buseo != '���ߺ�';

----

3) INTERSECT : ������

SELECT name, city, buseo
FROM insa
WHERE city = '��õ'
INTERSECT
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�';

-- AND ������ ����Ͽ� ���� ���� ����� ����
SELECT name, city, buseo
FROM insa
WHERE city = '��õ' AND buseo = '���ߺ�';

------------------------------------------------------------------------------

2. floating-point condition ������ ����-> �� ����� ���� ����.
1) IS NAN : �������� �ƴ��� Ȯ���ϴ� ������(Not A NUmber)
2) IS INFINITE : ���Ѵ����� �ƴ��� Ȯ���ϴ� ������
3) IS NULL : ���� ������ Ȯ���ϴ� ������

------------------------------------------------------------------------------

3. �Լ� ------------
1) ������ ������ -> ������ ó��(����) -> ��� ��ȯ(������ �������� �����ϰ� ���ְ� �������� ���� �����ϴµ� ���Ǵ� ���� �Լ���� �Ѵ�.)
   - ���ڰ��� �������̰� �� ����� ó���Ͽ� ��ȯ�ϴ� ����� �����Ѵ�.

--   
2) �Լ� ��� --------------------------------------
    ��. ������ ��� : ��Ʈ��� SQRT(4)
    
    ��. ������ �׸� ���� : UPPER('a') �빮�ڷ� ��ȯ
    
    ��. �׷��� ����� ��� = �׷��ռ�(group function)
    ex) insa ���̺��� �� ������� �� ������ �˰� ���� ��..
    SELECT COUNT(*) �ѻ���� -- �ѻ������ �ȴ�..
    FROM insa;
    
    SELECT COUNT(*) �����λ���� -- ������ �����..
    FROM insa
    WHERE buseo = '������';
    
    ��. ��¥ ������ ���� : TO_CHAR(������, ��¥��)
    
    ��. �÷� ������ Ÿ�� ���� == ����ȯ �Լ�
        ��¥�� <-> ���ڿ� ��ȯ 
        ���ڿ� <-> ������ ��ȯ
        TO_CHAR�� �ߺ��Լ�(== �ڹ� ���� �����ε�)
        TO_CHAR(��¥) -> ��¥���� ���ڿ��� ����ȯ ���ִ� �Լ�
        TO_CHAR(����) -> ���ڸ� ���ڿ���..
        TO_CHAR(���ڿ�) -> ���ڿ� ���� ���ϴ� ���ڿ���..

����) emp ���̺��� �� �μ��� ������� �� ������� �ľ��ϰ�ʹ� �Ʒ� ��� ����
        10���μ� : 3��
        20���μ� : 3��
        30���μ� : 6��
        40���μ� : 0��
        �ѻ���� : 12��

SELECT '10���μ� : ' || COUNT(*) || '��'
FROM emp
WHERE deptno = 10
UNION ALL
SELECT '20���μ� : ' || COUNT(*) || '��'
FROM emp
WHERE deptno = 20
UNION ALL
SELECT '30���μ� : ' || COUNT(*) || '��'
FROM emp
WHERE deptno = 30
UNION ALL
SELECT '40���μ� : ' || COUNT(*) || '��'
FROM emp
WHERE deptno = 40
UNION ALL
SELECT '�ѻ���� : ' || COUNT(*) || '��'
FROM emp;

--
3) �Լ��� ����(����) --------------------------------------
    ��. ������ �Լ�(Single_row) : ��(���ڵ�)�� ���� ����Ǿ� ���� �����ִ� �Լ�
    SELECT ename
        , UPPER(ename)
        , LOWER(ename)
    FROM emp;
    
    ��. ������ �Լ�(Group) == �׷��Լ�(�����Լ�) : ��(���ڵ�)�� �׷�ȭ�Ͽ� ����� ������
    
    SELECT COUNT(*)
    FROM emp;
    
----    
4) ������ �Լ� �߿� '���� �Լ�' --------------------------------------

    SELECT SQRT(4) -- ������, ��Ʈ �� �������� �Լ�
            -- , SIN() , COS() , TAN() ����, �ڻ���, ź��Ʈ ���ϴ� �Լ�
            -- , LOG() -- �α� ���ϴ� �Լ�
            -- , LN() -- �ڿ��αװ� ���ϴ� �Լ�
            , POWER(2, 3) -- ����(���) �� ���ϴ� �Լ�
            , MOD(5, 2) -- ������ ���ϴ� �Լ�
            , ABS(100) , ABS(-100) -- ���밪�� ���ϴ� �Լ�
    FROM dual;
    -- ����Ŭ ���� �ڷ��� : NUMBER
    
    ��. ROUND(NUMBER , [+- ��ġ] ) -> number�� 0�̸� 0�� ��ȯ
            - 'Ư�� ��ġ'���� �ݿø��ϴ� �Լ�
            - ������ �ڸ� ����(Ư�� ��ġ)���� �ݿø��� ��� ���� ��ȯ
            - ROUND(a, b)�� a�� �Ҽ��� ���� b+1�ڸ����� �ݿø��Ͽ� b�ڸ����� ���
                                         b���� �����̸� �Ҽ��� ���� b�ڸ����� �ݿø��Ͽ� ���
    
            SELECT 3.141592 PI
                , ROUND(3.141592) -- 3 : b�� ������ �Ҽ��� ù��° �ڸ�(b+1)���� �ݿø� �Ѵ�.
                , ROUND(3.641592) -- 4 : b�� ������ �Ҽ��� ù��° �ڸ�(b+1)���� �ݿø� �Ѵ�.
                , ROUND(3.141592, 0) -- 3 : ���� ������ b�� 0�� ��ٿ� ���� �ǹ�
                , ROUND(3.641592, 0) -- 4
                , ROUND(3.141592, 2) -- 3.14 : �Ҽ��� ����° �ڸ�(b+1 = 2 + 1)���� �ݿø�
                , ROUND(123.141592, -1) -- 120 : b���� �����̸� �Ҽ��� ������ b�ڸ����� �ݿø�
                , ROUND(123.141592, -2) -- 100 : b���� �����̸� �Ҽ��� ������ b�ڸ����� �ݿø�
                -- -2�� �ָ� 10�� �ڸ����� �ݿø�
            FROM dual;
        
            ����) emp ���̺��� pay(sal+comm) �ѱ޿��� / �ѻ���� = ȸ�� ��� �޿�
                �Ҽ��� 3��° �ڸ����� �ݿø�
            
            SELECT ROUND(SUM(sal + NVL(comm, 0)) / COUNT(*), 2)
            FROM emp;
            
            SELECT COUNT(*)
            FROM emp;
            
            -- SUM() �����Լ� == �׷��Լ� == �������Լ�
            SELECT SUM(sal + NVL(comm, 0)) PAY
            FROM emp;
            
            -- ������� Ǯ���ֽ� ��..
            SELECT ROUND( (SELECT  SUM( sal + NVL(comm, 0))  FROM emp ) / (SELECT COUNT(*) FROM emp) , 2 )  avg_pay
            FROM dual;

            
     ��. ����(����) �Լ�
        1) TRUNC(a, [+-��ġ]): ���ڰ��� Ư�� ��ġ(������ �Ҽ��� �ڸ��� ����)���� �����Ͽ� ���� �Ǵ� �Ǽ��� ����
                              TRUNC(n) == FLOOR(n) == TRUNC(n, 0)
           TRUNC(a, b) -> a�� b+1 �ڸ����� �����Ͽ� ���, �����̸� ���� b�ڸ����� ����
        2) FLOOR(n) : ���ڰ��� �Ҽ��� 1��° �ڸ����� �����Ͽ� �������� ���� -> �Ǽ����� ���� X
        
           SELECT 123.141592
                , FLOOR(123.141592) -- 123 : �Ҽ��� 1��° �ڸ����� ����
                , FLOOR(123.941592) -- 123 : �Ҽ��� 1��° �ڸ����� ����
                , TRUNC(123.941592) -- 123
                , TRUNC(123.941592, 0) -- 123
                , TRUNC(123.941592, 1) -- 123.9 : �Ҽ��� 2��° �ڸ����� ���� (b+1)
                , TRUNC(123.941592, -1) -- 120 : ���� �ڸ����� ����
           FROM dual;
           
    ��. CEIL() : �Ҽ��� ù ��° �ڸ����� �ø��ϴ� �Լ�
                Ư�� ��ġ���� �ø��ϴ� �Լ��� X
        SELECT CEIL(3.141592) -- 4
              , CEIL(3.941592) -- 4
        FROM dual;

        ����) �Խ��ǿ���
             �� �Խñ� �� : 652
             �� �������� ����� �Խñ� �� : 15
             �� ������ ���� ?
             652 / 15 = 43.4666 ������ ������ �ø� �Լ� ����Ͽ� �������� 44������!
             SELECT CEIL(652 / 15)
             FROM dual;
             
        ����) �Ҽ��� 3�ڸ����� �ø�(����) 1234.57 -> �����ϰ��� �ϴ� ��ġ�� �Ҽ��� 1° �ڸ��� ������
        SELECT 1234.5678
            , 1234.5678 * 100
            , CEIL(1234.5678 * 100 )
            , CEIL(1234.5678 * 100 ) / 100
        FROM dual;
        
        ����) 1234.5678�� ���� �ڸ����� ����(�ø�) 1300
        SELECT CEIL(1234.5678 / 100) * 100
        FROM dual;
        
    ��. SIGN : ������ ���� ���� 1, 0, -1�� ���� ��ȯ�ϴ� �Լ�
        [����] SIGN(number)
            number��   ��ȯ�Ǵ� �� 
            ���          +1 
            ����          -1 
             0            0 
             
        SELECT SIGN(100), SIGN(0), SIGN(-100)
        FROM dual;
        
        ����) emp ���̺� ��� �޿����� ���� ������ 1 ���� ������ -1 ������ 0�� ��µǵ��� ����
                                             ����           ����        ����
        
        SELECT ename, sal + NVL(comm, 0) PAY
            , ROUND(AVG(sal + NVL(comm, 0)) , 2) AVG_PAY
        FROM emp;
        
        ***** ���� �޽��� : ORA-00937: not a single-group group function
                �ؼ� : ���� �׷�, �׷� �Լ��� �ƴϴ�.
                ���� : ������ �Լ��ϰ� �Ϲ��� Į���� ���� ����� �� ����
                      ename�� sal + NVL(comm, 0)�� ���� ���� ����� �ǰ�
                      AVG ���� �Լ��� �׷��� ��� �ϳ��� �ุ ��� �Ǳ� ������
                �ذ� :             
                   SELECT ename, sal + NVL(comm, 0) PAY
                        , (SELECT ROUND(AVG(sal + NVL(comm, 0)) , 2) FROM emp ) AVG_PAY
                   FROM emp;  

       SELECT t.*
            , ABS(t.pay - t.avg_pay) �޿�����
            , SIGN(t.pay - t.avg_pay)
            , NVL2( NULLIF(SIGN(t.pay - t.avg_pay), 1), '��� �޿����� ����', '��� �޿����� ����')
       FROM(
            SELECT ename, sal + NVL(comm, 0) PAY
            , (SELECT ROUND(AVG(sal + NVL(comm, 0)) , 2) FROM emp ) AVG_PAY
            FROM emp
       ) t;
       
        
       SELECT ROUND(AVG(sal + NVL(comm, 0)) , 2) AVG_PAY
       FROM emp;

----    
5) ������ �Լ� �߿� '���� �Լ�' --------------------------------------

SELECT 'kBs'
    , UPPER('kBs') -- �빮�� ��ȯ�ϴ� �Լ�
    , LOWER('kBs') -- �ҹ��� ��ȯ�ϴ� �Լ�
    , INITCAP('admin') -- ù���ڸ� �빮�ڷ� ��ȯ�ϴ� �Լ�
FROM dual;

SELECT job
       , LENGTH(job) -- ���ڿ� ���̸� �������� �Լ�
       , CONCAT(empno, ename) -- ���ڿ� �����ϴ� �Լ�
       --  SUBSTR() -- ������ ��ġ���� ���ϴ� ���̸�ŭ �߶���� �Լ�
FROM emp;


    ��. INSTR(string, substring [, position [,occurrence] ]) �Լ�
        - ���ڿ� �߿��� ã���� �ϴ� ���ڰ� ����/�������κ��� ó�� ��Ÿ���� ��ġ�� ���� ��ȯ
        - ã�� ���ڰ� ������ 0�� ��ȯ
        - position : ���ڿ��� ã�� ������ ��ġ
        - occurrence : ���ڿ��� n��°�� ��Ÿ���� ��ġ(�߻� ����)
    
    ����1)
    SELECT ename
        , INSTR(ename, 'I') -- I�� �ִ� ���ڿ��� ��ġ�� ã��
        , INSTR(ename, 'IN')
    FROM emp;
    
    ����2)
    SELECT INSTR('corporate floor','or') -- 2 : or�� ó�� ��Ÿ���� ��ġ��
            , INSTR('corporate floor','or', 3) -- 5 : ã�� �����ϴ� ��ġ(r ����)���� ó�� ��Ÿ���� ��ġ��
            , INSTR('corporate floor','or', 3, 2) -- 14 : ã�� �����ϴ� ��ġ(r����)���� 2��°�� ��Ÿ���� ��ġ��
            , INSTR('corporate floor','or', -3, 2) -- �ڿ��� 3��° ���� ã�� ����
    FROM dual;
    
    ����) ��ȭ��ȣ�� ������ �ִ� ���̺� ����(�츮�� ���� ���̺��� TBL_ �̶�� ���λ� ������!)
         ���̺� �̸� : TBL_TEL
         ��ȣ(����) NUMBER
         ��ȭ��ȣ   02)123-1234
                  054)7233-2323
                  031)9837-2933
        
     -- CREATE TABLE ���̺�� �̷��� ���ϰ� �޴��� �߰�
     
     SELECT *
     FROM tbl_tel;
     
     ����) ����Ŭ ����, ���� �Լ��� ����ؼ�
     ��ȭ��ȣ�� ������ȣ�� ���, ��� 4�ڸ��� ���, �� 4�ڸ� ���
         
     SELECT no, tel
            , INSTR(tel, ')' ) AS ")��ġ��"
            , INSTR(tel, '-' ) AS "-��ġ��"
            , SUBSTR(tel, 0, INSTR(tel, ')' ) - 1) ������ȣ
            , SUBSTR(tel, INSTR(tel, ')' ) + 1, INSTR(tel, '-' ) - INSTR(tel, ')' ) - 1) ����1
            , SUBSTR(tel, INSTR(tel, '-' ) + 1 ) ����2
     FROM tbl_tel;  
     
     [��� ���]
     ��ȣ(no) ������ȣ ����1 ����2
     
     -- 
     ��. RPAD / LPAD : ������ ���̿��� ���ڰ��� ä��� ���� ������ ��(��)������ Ư�������� ä�� ��ȯ�ϴ� �Լ�
     �����ġ�
      RPAD (expr1, n [, expr2] )

     SELECT ename, sal + NVL(comm, 0) PAY
            -- expr2�� ���ָ� �������� ä����
            , LPAD('\' || (sal + NVL(comm, 0)), 10, '*' ) -- �� �ڸ����� 10�ڸ� Ȯ���ϰ� �������κ��� ���� �ڸ��� *�� �ش�.
            , RPAD(sal + NVL(comm, 0), 10, '*' ) -- ���������κ��� ������ * ä��
     FROM emp;
    
    --  LPAD('\' || sal + NVL(comm, 0), 10, '*' ) -> \ ��ȭ������ �����ϱ� ���� �߻�
    -- �����޽��� : ORA-01722: invalid number
    -- �ذ� : ( sal + NVL(comm, 0) ) -> () ��� ó��
    
    ����) �׷��� �׸���
    
    SELECT ename, sal + NVL(comm, 0) PAY
            , ROUND( (sal + NVL(comm, 0)) / 100) "#����"
            , RPAD(' ', ROUND( (sal + NVL(comm, 0)) / 100)+1, '#')
    FROM emp;
    
    SMITH	800 ########
    ALLEN	1900 ###################
    WARD	1750 ##################
    JONES	2975 ################################# 30��
    MARTIN	2650
    BLAKE	2850
    CLARK	2450
    KING	5000
    TURNER	1500
    JAMES	950
    FORD	3000
    MILLER	1300
    
    ����2)
    SELECT name, ssn
        , RPAD( SUBSTR(ssn, 0, 8), 14, '*')
    FROM insa;
    
    --
    ��. ASCII(char) -> char ���ڸ� ASCII �ڵ� ������ ��ȯ ����Ŭ ���� �ڷ��� : char
    ��. CHR(ASCII �ڵ尪) -> ASCII �ڵ� ���� ���ڷ� ��ȯ
    SELECT ename
            , SUBSTR(ename, 0 ,1)
            , ASCII( SUBSTR(ename, 0 ,1) )
            , ASCII( '��' ) -- 3����Ʈ
            , CHR(83)
            , CHR( ASCII( SUBSTR(ename, 0 ,1) ) )
    FROM emp;
    
    --
    ��. GREATEST( ?, ?, ? ...)
    ��. LEAST( ?, ?, ?)
    
    SELECT
        GREATEST(500, 10, 200, 800) -- ���� ū �� ������ : 800
        , LEAST(500, 10, 200) -- ���� ���� �� ������ : 10
        , GREATEST('KBS', 'ABC', 'XYZ') -- ���� ū �� : X�� ���� ũ�ٰ� �Ǵ��ؼ� XYZ�� ������
    FROM dual;
    
    ��. REPLACET() ��. VSIZE() -> ������ �ٷ�� �Լ���

----    
6) ������ �Լ� �߿� '��¥ �Լ�' --------------------------------------

SELECT SYSDATE, CURRENT_DATE, CURRENT_TIMESTAMP
FROM dual;

    ��. ��¥�� �ݿø�, ���� ������ �Լ� (���� �Լ��� �ִ� �Ͱ� ����..)
    TRUNC(date) ��¥ ����(����) -> ���� ���
    ROUND(date [,format]) ��¥ �ݿø�, ����(���� 12��)�� �������� �ݿø� -> ���� ��������� ����
    
    SELECT SYSDATE -- 22/04/08
            , ROUND(SYSDATE) -- 22/04/09
            , ROUND(SYSDATE, 'DD') -- ��¥ �������� 15�� ������ �ݿø�
            , ROUND(SYSDATE, 'MM') -- 15���� �������� 1�Ϸ� ����� ����
            , ROUND(SYSDATE, 'YY') -- ���� ���� �������� 1���� ����� ����
            , ROUND(SYSDATE, 'DAY') -- ������ ���� ������ ���ڸ� �ݿø�
    FROM dual;
    
    
    SELECT CURRENT_TIMESTAMP
        , TRUNC(CURRENT_TIMESTAMP) -- �ð�, ��, ��, ms �� �����ؼ� ��¥�� ������
    FROM dual;
    
    SELECT SYSDATE -- 22/04/08 16:46:50
        , TRUNC(SYSDATE) -- 22/04/08 00:00:00
        , TRUNC(SYSDATE, 'DD') -- 22/04/08
        , TRUNC(SYSDATE, 'MM') -- 22/04/01
        , TRUNC(SYSDATE, 'YY') -- 22/01/01
    FROM dual;
    
    �������縦 �� �� ����Ѵ�.
    ��¥�� �������µ� �ð��� ������ ��ǥ�� ���ϰ� �Ǵ� ��� TRUNC() ����Ͽ� �ð� ����
    
    --
    ��. ��¥�� ��� ������ ����ϴ� ��� ��ȯ�Ǵ� ������ Ÿ��
    ��¥�� + ���� = ��¥��
    ��¥�� - ���� = ��¥��
    ��¥�� - ��¥ = �ϼ���(����)
    ��¥�� + ����/24(�ð�) = ��¥��
    
    SELECT SYSDATE -- 22/04/08
        , SYSDATE + 3 -- 22/04/11 : 3���� ������ ��¥
        , SYSDATE - 3 -- 22/04/05 : 3���� ���� ��¥
    FROM dual;
    
    SELECT CURRENT_TIMESTAMP -- 22/04/08 16:40:37.263000000 ASIA/SEOUL
        , CURRENT_TIMESTAMP + 3 -- 22/04/11 : 3���� ������ ��¥
    FROM dual;
    
    ����) emp ���̺��� ������� �ٹ��ϼ� ��ȸ
    
    SELECT ename, hiredate -- DATE ��¥�ڷ���
            , SYSDATE -- DATE ��¥�ڷ���
            , CEIL( ABS( hiredate - SYSDATE ) ) "�ٹ��ϼ�" -- ��¥-��¥ = �ٹ��ϼ� : �Ҽ����� �ð� 
            -- ���ݺ��� 2�ð� �Ŀ� ����
            , TO_CHAR(SYSDATE + 2/24, 'YYYY/MM/DD HH24:MI:SS')
    FROM emp;
    
    --
    ��. MONTHS_BETWEEN  ������~~
    
    
    