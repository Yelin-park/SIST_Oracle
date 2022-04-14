-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]
---- �������� ----
1. PIVOT() �Լ��� ������ ��������.
SELECT *
FROM (�ǹ���� ���� - ��������)
PIVOT( �׷��Լ�|�����Լ� FOR �÷���� IN(�÷���)  )


2. emp ���̺���   �� JOB�� ����� (�Ǻ�)

    CLERK   SALESMAN  PRESIDENT    MANAGER    ANALYST
---------- ---------- ---------- ---------- ----------
         3          4          1          3          1

SELECT *
FROM (SELECT job FROM emp)
PIVOT( COUNT(*) FOR job in('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST' )  );

3. emp ���̺���  [JOB����] �� ���� �Ի��� ����� ���� ��ȸ 
  ��. COUNT(), DECODE() ���

JOB         COUNT(*)         1��         2��         3��         4��         5��         6��         7��         8��         9��        10��        11��        12��
--------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
CLERK              3          1          0          0          0          0          0          0          0          0          0          0          2
SALESMAN           4          0          2          0          0          0          0          0          0          2          0          0          0
PRESIDENT          1          0          0          0          0          0          0          0          0          0          0          1          0
MANAGER            3          0          0          0          1          1          1          0          0          0          0          0          0
ANALYST            1          0          0          0          0          0          0          0          0          0          0          0          1

SELECT job, COUNT(*)
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 1, 'o'  ) ) "1��"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 2, 'o'  ) ) "2��"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 3, 'o'  ) ) "3��"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 4, 'o'  ) ) "4��"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 5, 'o'  ) ) "5��"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 6, 'o'  ) ) "6��"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 7, 'o'  ) ) "7��"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 8, 'o'  ) ) "8��"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 9, 'o'  ) ) "9��"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 10, 'o'  ) ) "10��"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 11, 'o'  ) ) "11��"
        , COUNT( DECODE( EXTRACT(MONTH FROM hiredate), 12, 'o'  ) ) "12��"
FROM emp
GROUP BY job;

  ��. GROUP BY �� ���

         ��        �ο���
---------- ----------
         1          1
         2          2
         4          1
         5          1
         6          1
         9          2
        11          1
        12          3

SELECT EXTRACT(MONTH FROM hiredate) �� , COUNT(*) �ο���
FROM emp
GROUP BY EXTRACT(MONTH FROM hiredate)
ORDER BY EXTRACT(MONTH FROM hiredate);


  ��. PIVOT() ���
  
JOB               1��          2          3          4          5          6          7          8          9         10         11         12
--------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
CLERK              1          0          0          0          0          0          0          0          0          0          0          2
SALESMAN           0          2          0          0          0          0          0          0          2          0          0          0
PRESIDENT          0          0          0          0          0          0          0          0          0          0          1          0
MANAGER            0          0          0          1          1          1          0          0          0          0          0          0
ANALYST            0          0          0          0          0          0          0          0          0          0          0          1



SELECT *
FROM (SELECT SUBSTR(hiredate, 4, 2) �� FROM emp )
PIVOT( COUNT(*) FOR �� IN ( '01' AS "1��", '02' AS "2��", '03' AS "3��", '04' AS "4��", '05' AS "5��", '06' AS "6��"
                             , '07' AS "7��", '08' AS "8��", '09' AS "9��", '10' AS "10��", '11' AS "11��", '12' AS "12��"  )) mon;

SELECT *
FROM(SELECT job, EXTRACT(MONTH FROM hiredate) �� FROM emp)
PIVOT(COUNT(*) FOR �� IN ( 1,2,3,4,5,6,7,8,9,10,11,12));


4. emp ���̺��� �� �μ��� �޿� ���� �޴� ��� 2�� ���
  ������)
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
1. [PIVOT �Լ� ����ϴ� ����]
����1) emp ���̺��� grade ��޺� ����� ��ȸ

SELECT *
FROM salgrade;
1	700	    1200
2	1201	1400
3	1401	2000
4	2001	3000
5	3001	9999

Ǯ��1) COUNT(), DECODE()
--  ename, sal, losal || '~' || hisal, grade
SELECT COUNT(*)
        , COUNT(DECODE(grade, 1, 'o')) "1���"
        , COUNT(DECODE(grade, 2, 'o')) "2���"
        , COUNT(DECODE(grade, 3, 'o')) "3���"
        , COUNT(DECODE(grade, 4, 'o')) "4���"
        , COUNT(DECODE(grade, 5, 'o')) "5���"
FROM emp e, salgrade s
WHERE sal BETWEEN losal AND hisal;

Ǯ��2) GROUP BY ��
SELECT grade || '���' ���, COUNT(*) �����
FROM emp e, salgrade s
WHERE sal BETWEEN losal AND hisal
GROUP BY grade
ORDER BY grade;

Ǯ��3) PIVOT() 
-- �����÷�(���)�� �������� ���� �� ����
-- PIVOT(FOR IN (SELECT grade FROM salgrade))

SELECT *
FROM(SELECT deptno, grade FROM emp, salgrade WHERE sal BETWEEN losal AND hisal  )
PIVOT( COUNT(*) FOR grade IN(1, 2, 3, 4, 5));

--deptno �÷��� �ϳ� �߰��ϴ� �Ʒ��� ���� ���� ������
    DEPTNO          1          2          3          4          5
---------- ---------- ---------- ---------- ---------- ----------
        30          1          2          2          1          0
        20          1          0          0          2          0
        10          0          1          0          1          1


----------------------
����2) emp ���̺��� �⵵�� �Ի������� ��ȸ

SELECT DISTINCT TO_CHAR(hiredate, 'YYYY') hire_year
FROM emp;

1) COUNT(), DECODE()
SELECT COUNT(DECODE(TO_CHAR(hiredate, 'YYYY'), 1980, 'o')) "1980"
    , COUNT(DECODE(TO_CHAR(hiredate, 'YYYY'), 1981, 'o')) "1981"
    , COUNT(DECODE(TO_CHAR(hiredate, 'YYYY'), 1982, 'o')) "1982"
FROM emp;


2) GROUP BY
SELECT TO_CHAR(hiredate, 'YYYY') �Ի�⵵, COUNT(*) �����
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY') ;


3) PIVOT
SELECT *
FROM(SELECT TO_CHAR(hiredate, 'YYYY') hire_year FROM emp)
PIVOT( COUNT(*) FOR hire_year IN(1980, 1981, 1982));

----------------------
����3) ������� �� ������Ʈ ����� ������ ��

1. ���̺� ���� : TBL_PIVOT
         �÷� : no(�л���ȣ), name, jumsu
         
CREATE TABLE TBL_PIVOT(
    no NUMBER NOT NULL PRIMARY KEY -- ũ�⸦ ���ָ� �ִ� ũ��� ����, �ʼ��Է�, ����Ű
    , name VARCHAR2(20) NOT NULL -- NOT NULL�� �ָ� �ʼ��� �Է��ؾߵȴ�.
    , jumsu NUMBER(3) 
-- �����۾��� ������! �ٸ� ������� �ذ�!    
--    , engjumsu NUMBER(3)
--    , engjumsu NUMBER(3) 
--    , matjumsu NUMBER(3) 
);
-- Table TBL_PIVOT��(��) �����Ǿ����ϴ�.

2. �л��� ���� ���� �߰�
3. ����, ����, ���� 3���� ������ ������ �����ؾߵǴµ� ������ �ϳ��� �����ϰ� �Ǵ� ������ �߻�
    ���̺� ������ ���ϰ� �Ʒ��� ���� �ѻ���� 3���� ��(���ڵ�) �߰�
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (1, '�ڿ���' , 90); -- kor
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (2, '�ڿ���' , 89); -- eng
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (3, '�ڿ���' , 99); -- mat

INSERT INTO tbl_pivot (no, name, jumsu) VALUES (4, '�Ƚ���' , 56); -- kor
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (5, '�Ƚ���' , 45); -- eng
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (6, '�Ƚ���' , 12); -- mat

INSERT INTO tbl_pivot (no, name, jumsu) VALUES (7, '���' , 99); -- kor
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (8, '���' , 85); -- eng
INSERT INTO tbl_pivot (no, name, jumsu) VALUES (9, '���' , 100); -- mat

COMMIT;

4. ��ȸ
SELECT *
FROM tbl_pivot;

1	��xx 	90
2	��xx 	89
3	��xx	    99
4	��xx 	56
5	��xx 	45
6	��xx 	12
7	��xx  	99
8	��xx  	85
9	��xx	    100

5. �ǹ�����ؼ� �Ʒ��� ���� ����ϱ�
��ȣ  �̸�   �� �� ��
1   ��xx   90 89 99
2   ��xx   56 45 12
3   ��xx   99 85 100

SELECT *
FROM(
    SELECT
    TRUNC((no-1) / 3) + 1 no
    , name, jumsu
    , DECODE(MOD(no, 3), 1, '����', 2, '����', 0, '����') ����
    FROM tbl_pivot
)
PIVOT( SUM(jumsu) FOR ���� IN( '����', '����', '����' ) )
ORDER BY no ASC;

--------------------------------------------------------------
2. 
Java : ����(�����Ǽ�) 0.0 <= Math.random() < 1.0
Oracle : dbms_random ��Ű��(package) != �ڹ��� ��Ű�� ����� �ٸ���. 
PL/SQL = Ȯ��� SQL + PL(������ ���)
PL/SQL 5���� ���� �߿� �ϳ��� package �̴�.

1) dbms_random.value�� dbms_random.string
n <= values < m �Ǽ��� �����ش�
�⺻���� 0�� 1.0

SELECT dbms_random.value
    , dbms_random.value(0, 100) �Ǽ� -- 0 <= �Ǽ� < 100 
    , TRUNC(dbms_random.value(1, 46), -1) ����
    , FLOOR(dbms_random.value(0, 45)) + 1 ����
    , dbms_random.string('U', 5) �빮��-- UPPER, �� ������ �빮�� 5�� ���
    , dbms_random.string('L', 5) �ҹ��� -- ������ �ҹ��� 5��
    , dbms_random.string('A', 5) ��ҹ��� -- ���ĺ� ��,�ҹ��� 5��
    , dbms_random.string('X', 5) �빮�ڼ���-- �빮�� + ���� 5��
    , dbms_random.string('P', 5) �빮��Ư��-- �빮�� + Ư������ 5��
FROM dual;

SELECT TRUNC(dbms_random.value(0, 51)) + 150 -- 0.0 <= �Ǽ� < 51
    , TRUNC(dbms_random.value * 51) + 150 -- 0 <= �Ǽ� < 51 -> 150 <= ���� < 201
    , TRUNC(dbms_random.value(150, 201))
FROM dual;

----------------------------
3. ����Ŭ �ڷ���(Data Type)
����(����, �Ǽ�) - NUMBER
��¥ - DATE(�ʱ�����), TIMESTAMP( ns����)
���ڿ� - VARCHAR2

���� �ڷ��� - CHAR, NCHAR
            VARCHAR2, NVARCHAR2
            [var]
            [n]
----------           
1) CHAR
     ��. [���� ����] ���� �ڷ���
        char(10) ������ 'abc' ����
        10byte = ['a']['b']['c'][][][][][][][] -> ���� 7����Ʈ �޸𸮸� Ȯ���ϰ� �ִ°� ��, 10����Ʈ�� ���� �޸�
        
     ��. 1byte ~ 2000 byte�� ������ �� �ִ�.(���ĺ� 1���� 1����Ʈ, �ѱ� 1���� 3����Ʈ)
         SELECT VSIZE('a')
            , VSIZE('��')
         FROM dual;
         
     ��. ����
         CHAR(size [BYTE|CHAR])
         char(3) -- size�� ��ٸ�.. == char(3 byte) ��� ���� �Ͱ� ����
         char(3 char) -- �̷��� �����ߴٸ� 3���ڸ� �����ϰڴ�.(����Ʈ �������)
         char -- �̷��� �����ϸ�, char(1) == char(1 byte)�� �ذͰ� ����
         
     ��. �׽�Ʈ
     
        (1) ���̺� ����
         CREATE TABLE tbl_char(
            aa char
            , bb char(3)
            , cc char(3 char)
         );
         -- Table TBL_CHAR��(��) �����Ǿ����ϴ�.
         
         (2) ��ȸ
         SELECT *
         FROM tbl_char;
         
         (3) ������ �߰�
         INSERT INTO tbl_char (aa, bb, cc) VALUES ('a', 'kbs', 'kbs');
         -- 1 �� ��(��) ���ԵǾ����ϴ�.
         
         INSERT INTO tbl_char VALUES ('��', 'kbs', 'kbs'); -- �÷� ������� ���� �߰��� ���� (�÷���) ���� ����
         -- ORA-12899: value too large for column "SCOTT"."TBL_CHAR"."AA" (actual: 3, maximum: 1)
         -- �ؼ� : ������ ������ ũ�⺸�� ū ���� ���Դ�.
         
         INSERT INTO tbl_char VALUES ('b', 'k', '�ɺ�');
         -- 1 �� ��(��) ���ԵǾ����ϴ�.
         
         COMMIT;

-------
2) NCHAR == N + CHAR == U[N]ICODE CHAR
    ��. �����ڵ�(unicode) : ������ ��� ����� 1���ڸ� 2 ����Ʈ�� ó���ϰڴ�.
    
    ��. ����
        NCHAR( [size] )
        nchar == nchar() 1����
        nchar(5) ���� ���� ������� 5���� ����
        
    ��. [��������] ���ڿ� + �ִ� 2000 ����Ʈ ����
    
    ��. �׽�Ʈ
         CREATE TABLE tbl_nchar(
            aa char
            , bb char(3 char)
            , cc nchar(3)
        );
        -- Table TBL_NCHAR��(��) �����Ǿ����ϴ�.
        
        INSERT INTO tbl_nchar VALUES('a', 'ȫ��X', 'ȫ�浿');
        -- 1 �� ��(��) ���ԵǾ����ϴ�.
        
        SELECT *
        FROM tbl_nchar;

---------
3) VARCHAR2 == VAR(��������) + CHAR
    ��. [��������] ���� �ڷ���, �ִ� 4000 ����Ʈ ���� ����
    
    ��. ����
        VARCHAR2(size [byte|char]) �� �ó�� == VARCHAR ��, �ڿ� 2�� �Ⱥٿ��� ��� ����
    ��. 
    
        char = char(1 byte)
        varchar2 = varchar2(4000 byte) ũ�⸦ ���������������� �ִ밪���� ũ�Ⱑ ������.
        varchar2(10) = varchar2(10 byte)
        varchar2(10 char) = ���� 10�� ���� ����
        
    ��. �������� / �������� ������ ����
        char(10) == char(10 byte)
        varchar2(10) == varchar2(10 byte)
        
        'kbs' ����
        char [k][b][s][''][''][''][''][''][''][''] �������� ���ڷ� �� ä���� ����
    varchar2 [k][b][s]                          [][][][][][][] ������ ����
    
    ��. � ��쿡 ��������/�������̸� ����ϴ°�?
        char / nchar -> �������� : �ֹε�Ϲ�ȣ 14�ڸ�, �����ȣ
        varchar2 / nvarchar2 -> �������� : ����

-----------
4) NVARCHAR2
    ��. N( �����ڵ�) + VAR(��������) + CHAR(���ڿ�)
    
    ��. �ִ� 4000����Ʈ ����
    
    ��. ����
        NVARCHAR2( [size] )
        nvarchar2 == nvarchar2(�ִ밪)
        
----------------------

5) LONG ���������� ���ڸ� �����ϴ� �ڷ��� + �ִ� 2GB ���� -> ���� ���� X

6) NUMBER( [p], [s] )
    ��. ����(����, �Ǽ�)
    
    ��. p(precision) ��Ȯ == ��ü �ڸ����ε� ���� ���� �ڸ�   ���� : 1 ~ 38
        s(scale)    �Ը�(����) == �Ҽ��� ���� �ڸ���         ���� : -84 ~ 127
        
        NUMBER(p) ����
        NUMBER(p, s) �Ǽ�
        
        NUMBER(3, 7) -> 0.0000[][][] ���� ���� 3���� �Ҽ��� �ڸ����� 7�� �ڸ��� ���� ���� 0���� ä���.
    
    ��. NUMBER == NUMBER(38, 127) �ڸ��� ���������ָ� �ִ� ũ��� ������.
    
    ��. �׽�Ʈ
    CREATE TABLE tbl_number(
        kor NUMBER(3) -- ����3�ڸ� ��, -999 ~ 999 3 �ڸ� ����
        , eng NUMBER(3)
        , mat NUMBER(3)
        , tot NUMBER(3)
        , avgs NUMBER(5, 2)
    );
    
    INSERT INTO tbl_number(kor, eng, mat) VALUES (90.89, 85, 100); -- 90.89�� 91�� ����Ǿ���
    INSERT INTO tbl_number(kor, eng, mat) VALUES (90, 85, 101);
    INSERT INTO tbl_number(kor, eng, mat) VALUES (90, 85, -1);
    
    INSERT INTO tbl_number(kor, eng, mat) VALUES (90, 85, 1001);
    -- ORA-01438: value larger than specified precision allowed for this column
    -- �ؼ� : ��¡�� precision���� ũ�⶧���� ���� �� ����.
    
    INSERT INTO tbl_number(kor, eng, mat) VALUES (90, 85, 999);
    
    INSERT INTO tbl_number(kor, eng, mat) VALUES (90, 85, -1001);
    -- ORA-01438: value larger than specified precision allowed for this column
    
    COMMIT;
    
    SELECT *
    FROM tbl_number;
    
    -- ��� �л��� ����, ����, ���� ������ 0 ~ 100 ������ ������ ����
    UPDATE tbl_number
    SET kor = TRUNC(dbms_random.value(0, 101))
        , eng = TRUNC(dbms_random.value(0, 101))
        , mat = TRUNC(dbms_random.value(0, 101));
    
    -- ��� �л��� ������ ��� ����Ͽ� ����
    UPDATE tbl_number
    SET tot = kor + mat + eng
        , avgs = (kor + mat + eng) / 3;
        
    
    -- avgs �÷� �ڷ��� NUMBER(5, 2) -> ���� 5�ڸ� �� 3�ڸ��� ����, 2�ڸ��� �Ǽ�
    UPDATE tbl_number
    SET avgs = 999.87123; -- 999.87�� ����
    SET avgs = 89.12945678; -- 89.13���� ����, �Ҽ��� 3��° �ڸ����� �ݿø��� �Ͼ�� ������.
    SET avgs = 89.12345678; -- 89.12�� ����
    SET avgs = 100.00;
    SET avgs = 9999; -- ORA-01438: value larger than specified precision allowed for this column
    SET avgs = 999;
    SET avgs = 89.23;
    
    
    ��. ���� NUMBER(4,5)ó�� scale�� precision���� ũ�ٸ�, �̴� ù�ڸ��� 0�� ���̰� �ȴ�.
    NUMBER(p) == NUMBER(p, 0) -- �Ҽ����� ����. ��, ����
    
    
    ���� ������   NUMBER         ���� ����Ǵ� ��
    [p > s]
    123.89      NUMBER          123.89 
    123.89      NUMBER(3)       124 
    123.89      NUMBER(3,2)     precision�� �ʰ� 
    123.89      NUMBER(4,2)     precision�� �ʰ� 
    123.89      NUMBER(5,2)     123.89 
    123.89      NUMBER(6,1)     123.9 
    123.89      NUMBER(6,-2)    100  (����ϱ�)
    
    [p < s] -- ���� NUMBER(4,5)ó�� scale�� precision���� ũ�ٸ�, �̴� ù�ڸ��� 0�� ���̰� �ȴ�.
    .01234      NUMBER(4,5)     .01234 
    .00012      NUMBER(4,5)     .00012 
    .000127     NUMBER(4,5)     .00013 
    .0000012    NUMBER(2,7)     .0000012   -> .0000123 ���� �߻� / .0000100 �����߻�
    .00000123   NUMBER(2,7)     .0000012 
    1.2e-4      NUMBER(2,5)     0.00012 
    1.2e-5      NUMBER(2,5)     0.00001 
    
    0.000012 p == 2, s == 5 -> 0.00001 �� ���´�.
    0.000012 p == 1, s == 5 -> ���� �߻�
    p�� ��ü �ڸ����� �ƴ϶� ���� ���� �ڸ����̴�.

�׽�Ʈ�� ���̺� ���� - ���ΰ���
        CREATE TABLE tbl_test(
         a1 NUMBER(2, 7)
         , a2 NUMBER(2, 5)
         , a3 NUMBER(5, 2)
         , a4 NUMBER(4,2)
         , a5 NUMBER(4,5)
        );
        
        DESC
-------------------
7) FLOAT( [p] ) == FLOAT�� ���������� NUMBERó�� ��Ÿ��, ���� �ڷ��� -> ��� X �ؾ �ȴ�.
���е��� p 1��126 binary digits��, 1��22bytes�� �ʿ���

---------------
8) DATE
����, ��, ��, �� + ��, ��, �ʸ� �����ϴ� �ڷ���(�������� 7����Ʈ ����)
�÷� :
�й� NUMBER(7) -1111111 ~ 1111111
�̸� VARCHAR2(20)
    CHAR, NCHAR - �������� : �̸��̶� �������̴� X
    , VARCHAR2, NVARCHAR2 - �������� : ����Ǹ� ���ٸ� NVARCHAR2 �ʿ� X �ѱ۸� ���ٸ� NVARCHAR2 ��
                            ��Ȳ�� ���� �����ϱ�~
���� NUMBER(3) -999 ~ 999 -> 0<= n <= 100 üũ ���������ʿ�, �̰� ������ ��� ����!
���� NUMBER(3)
���� NUMBER(3)
���� NUMBER(3)
��� NUMBER(5, 2)
��� NUMBER(3)
���� DATE
�ֹι�ȣ CHAR(14)
��Ÿ VARCHAR2 -- �ִ�ũ�� 

---------
9) TIMESTAMP( [n] )
    TIMESTAMP == TIMESTAMP(6) -> 00.000000
    TIMESTAMP(9) -> 95/08/08 00:00:[00.000000000]
    DATE�� Ȯ�� ���·�, �ִ� 9�ڸ��� ��,��,��,��,��,��,�и��ʱ��� ������
    n�� 0 ~ 9���� �� �� �ְ�, n�� �ʴ��� ������ �̾ ��Ÿ�� milli second�� �ڸ����� �⺻���� 6�̴�

------------
10) �Ʒ� �ΰ����� �׳� �Ѿ��...
    INTERVAL YEAR[(n)] TO MONTH
    INTERVAL DAY[(n1)] TO SECOND[(n2)]

--------
11) RAW(size)
    LONG RAW
    - 2�� ������ �����ϴ� �ڷ���
    - RAW�� �ִ밪�� 2000����Ʈ�� �ݵ�� size�� ����ؾ� �ϸ�, LONG RAW�� 2GB���� ����
    
    �̹��� ������ ���̺��� � �÷��� �ֱ� ���ؼ��� 010101 2�������ͷ� ��ȯ�ؾߵǴµ� 
    �̶� img RAW/LONG RAW�� ���

----------
12) BFILE == B(binary, 2��������) + FILE(�ܺ� ���� �������� ����)
    2GB �̻��� 2�������͸� �����ϰ��� �Ѵٸ� BFILE �ڷ����� ����Ѵ�.
    2�������͸� �ܺο� file���·� (264 -1����Ʈ)���� ����

----------
13) LOB([L]arge [O][B]ject)
    - 2GB �̻��� �ڷḦ ������ �� ���
    -  4000����Ʈ������ LOB�÷��� ���������, �� �̻��̸� �ܺο� ����ȴ�
    ��. B + LOB = BLOB (2�������� ����)
    ��. C + LOB = CLOB (�ؽ�Ʈ ������ ����)
    ��. N + C + LOB = NCLOB (�����ڵ������� �ؽ�Ʈ ������ ����)
     
    �ؽ�Ʈ(LONG), �̹���, ����������(LONG RAW) ����� 2GB���� ����
    2GB �̻� ��뷮 ����� LOB�� �پ��ִ� �ڷ��� �ʿ�

---------
14) ROWID pseudo(�ǻ�) �÷� -- �μ��� ���� �����ϴ� ������(������) ��(�ĺ���)

SELECT ROWID, dept.*
FROM dept;

-- ���� ��� �ڷ��� �����ϰ� ���� --
��¥ - DATE, TIMESTAMP(n)
���� - NUMBER(p, s), FLOAT(p)
���� - CHAR, NCHAR
        VARCHAR2, NVARCHAR2
        LONG (2GB)
2�������� - RAW, LONG RAW

LOB - BLOB, CLOB, NCLOB, BFILE

-------------------------
4. [COUNT �Լ�]
    �����ġ�
	COUNT([* ? DISTINCT ? ALL] �÷���) [ [OVER] (analytic ��)]

-- ORA-00937: not a single-group group function
SELECT name, basicpay, COUNT(*)
FROM insa;

-- COUNT(*) OVER(ORDER BY basicpay) : ������ ���� ������ ������� ��ȯ
SELECT name, basicpay, COUNT(*) OVER(ORDER BY basicpay)
FROM insa;

-- �μ����� ������ �հ踦 ���� �� �ִ�.
SELECT buseo, name, basicpay
    , COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay DESC) -- �μ��� ��Ƽ���� ������ ���� ī��Ʈ �ϰڴ�.
FROM insa;

--------------------
5. SUM �Լ�
�����ġ�
	SUM ([DISTINCT ? ALL] expr)
         [OVER (analytic_clause)]

SELECT buseo, name, SUM(basicpay) OVER(ORDER BY buseo) -- �� �μ����� ������ ���� ���´�.
FROM insa;
���ߺ�	�̻���	19430000
���ߺ�	����ö	19430000
��ȹ��	�����	32420000 -- ���ߺ��� �հ� + ��ȹ���� �հ� 
��ȹ��	�ǿ���	32420000
������	�긶��	58044200 -- ���ߺ��� �հ� + ��ȹ���� �հ� + �������� �հ�
������	���μ�	58044200

SELECT DISTINCT buseo, SUM(basicpay) OVER(ORDER BY buseo) ps -- �� �μ����� ������ ���� ���´�.
FROM insa
ORDER BY ps;

���ߺ�	19430000
��ȹ��	32420000
������	58044200
�λ��	64176200
�����	72676600
�ѹ���	84680600
ȫ����	93391600 ��+��+��+��+��+��+ȫ �հ�

SELECT DISTINCT buseo, SUM(basicpay) OVER(PARTITION BY buseo ORDER BY buseo) -- �� �μ����� ������ ���� ���´�.
FROM insa;

---------------------
6. AVG �Լ�
�����ġ�
	AVG ([DISTINCT ? ALL] expr)
         [OVER (analytic_clause)]

SELECT city, name, basicpay
    , AVG(basicpay) OVER(ORDER BY city) ������� -- ������ ��� ��ȯ
    , AVG(basicpay) OVER(PARTITION BY city ORDER BY city) �ش�������� -- �ش� ������ ��� ��ȯ
    , basicpay - AVG(basicpay) OVER(PARTITION BY city ORDER BY city) ������հ����޿�����
FROM insa;

����	���ѱ�	880000	930000
���	�ǿ���	1020000	1371066.66666666666666666666666666666667 -- ������ ����� ������ ���

----------------------------
7. ���̺� ����, ����, ���� - �߰�, ����, ���� ���

*** DB �𵨸� *** -> ���� �ֿ� ��� ����!
���̺�(table) : � �����͸� �����ϱ� ���� ���

1)
���̺� - tbl_member
�÷�(��) : �÷���      �ڷ����� ũ��                            �����             ����Ű(PK)
���̵�     id          ����/�������� VARCHAR2(10)              NOT NULL          PRIMARY KEY
�̸�      name        ����/�������� VARCHAR2(20)               NOT NULL
����      age         ����/���� NUMBER(3)                     
��ȭ��ȣ   tel         ����/��������(�޴���) CHAR(13) 3-4-4      NOT NULL
����      birth       ��¥/�� DATE
��Ÿ      etc         ���� VARCHAR(200)

-- 
�������� ���̺� ���� ���ġ�
    CREATE [GLOBAL TEMPORARY] TABLE [schema.] table��
      ( 
        ���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] 
       [,���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] ] 
       [,...]  
      ); 

- GLOBAL TEMPORARY : �ӽ� ���̺��� �����ϰڴٴ� �ǹ�
    �� ���? �α����ϰ� �α׾ƿ��ϱ� �������� ���ȸ� ��ٱ��ϸ� �����ϰ� �α׾ƿ��ϸ� ��ٱ��� ���� ���ؼ�! �ӽ����̺� ���
- schema : ������ ������
- �������� : �����, ����Ű ���

--
2) ���̺� ����
    CREATE TABLE scott.tbl_member
      ( 
        id VARCHAR2(10) NOT NULL PRIMARY KEY
        , name VARCHAR(2) NOT NULL
        , age NUMBER(3) 
        , tel CHAR(13)
        , birth DATE
        , etc VARCHAR2(200) 
      );
    -- Table SCOTT.TBL_MEMBER��(��) �����Ǿ����ϴ�.
    
    SELECT *
    FROM tbl_member;
    
    SELECT *
    FROM tabs
    WHERE table_name LIKE '%MEMBER%';
    
3) ������ ���̺� ����
DROP TABLE tbl_member;
--Table TBL_MEMBER��(��) �����Ǿ����ϴ�.

4) �ٽ� ����..
    CREATE TABLE scott.tbl_member
      ( 
        id VARCHAR2(10) NOT NULL PRIMARY KEY
        , name VARCHAR(2) NOT NULL
        , age NUMBER(3) 
        , birth DATE
      );
    -- Table SCOTT.TBL_MEMBER��(��) �����Ǿ����ϴ�.

5) ���̺� ���� Ȯ��   
    DESC tbl_member;
    �̸�    ��?       ����           
    ----- -------- ------------ 
    ID    NOT NULL VARCHAR2(10) 
    NAME  NOT NULL VARCHAR2(2)  
    AGE            NUMBER(3)    
    BIRTH          DATE

--------------------------------------------
6) ���� tbl_member ���̺� ���ο� �÷��� ��ȭ��ȣ, ��Ÿ �÷� �߰� - (1) ����
	ALTER TABLE tbl_member
	ADD(
        tel CHAR(13) NOT NULL
        , etc VARCHAR2(200)
	    );
-- Table TBL_MEMBER��(��) ����Ǿ����ϴ�.

DESC tbl_member; -- ���� �߰��� �÷��� �������� ������
�̸�    ��?       ����            
----- -------- ------------- 
ID    NOT NULL VARCHAR2(10)  
NAME  NOT NULL VARCHAR2(2)   
AGE            NUMBER(3)     
BIRTH          DATE          
TEL   NOT NULL CHAR(13)      
ETC            VARCHAR2(200) 

-- ALTER ����
[DDL�� ALTER..]

ALTER TABLE

(1) ���ο� �÷� �߰� ...ADD
    �����ġ��÷��߰�
	ALTER TABLE ���̺��
	ADD (�÷��� datatype [DEFAULT ��]
	    [,�÷��� datatype]...);

? �ѹ��� add ������� ���� ���� �÷� �߰��� �����ϰ�, �ϳ��� �÷��� �߰��ϴ� ��쿡�� ��ȣ�� �����ص� �ȴ�.
? �߰��� �÷��� ���̺��� ������ �κп� �����Ǹ� ����ڰ� �÷��� ��ġ�� ������ �� ����
? �߰��� �÷����� �⺻ ���� ������ �� �ִ�.
? ���� �����Ͱ� �����ϸ� �߰��� �÷� ���� NULL�� �Է� �ǰ�, ���� �ԷµǴ� �����Ϳ� ���ؼ��� �⺻ ���� ����ȴ�.

(2) ���� �÷� ����
�����ġ����� �÷� ����
 ALTER TABLE ���̺��
 MODIFY (�÷��� datatype [DEFAULT ��]
 [,�÷��� datatype]...);
 
? �������� type, size, default ���� ������ �� �ִ�.
? ���� ��� �÷��� �����Ͱ� ���ų� null ���� ������ ��쿡�� size�� ���� �� �ִ�.
    -> �����Ͱ� �ִ� ��� size�� ���� �� ����! ***
? ������ Ÿ���� ������ CHAR�� VARCHAR2 ��ȣ���� ���游 �����ϴ�.
    -> ���� �ڷ��� �������� ���� ����
? �÷� ũ���� ������ ����� �������� ũ�⺸�� ���ų� Ŭ ��쿡�� �����ϴ�.
    -> �����Ͱ� �ִ� ��쿡�� size ������ ����
? NOT NULL �÷��� ��쿡�� size�� Ȯ�븸 �����ϴ�.
    -> ���������� NOT NULL�̸� size Ȯ�븸 ����
? �÷��� �⺻�� ������ �� ���Ŀ� ���ԵǴ� ����� ������ �ش�.
? �÷��̸��� [�������� ����]�� �Ұ����ϴ�.
? �÷��̸��� ������ ���������� ���� ���̺� ������ alias�� �̿��Ͽ� ������ �����ϴ�.
? alter table ... modify�� �̿��Ͽ� constraint(��������)�� ������ �� ����.

(3) ���� �÷� ����
�����ġ�
   ALTER TABLE ���̺��
   DROP COLUMN �÷���; 

? �÷��� �����ϸ� �ش� �÷��� ����� �����͵� �Բ� �����ȴ�.
? �ѹ��� �ϳ��� �÷��� ������ �� �ִ�.
? ���� �� ���̺��� ��� �ϳ��� �÷��� �����ؾ� �Ѵ�.
? DDL������ ������ �÷��� ������ �� ����.

(4) �������� �߰�
(5) �������� ����

------
7) ETC �÷� �ڷ����� ũ�⸦ VARCHAR2(200) -> VARCHAR2(255) �����ϰ�ʹ�. - (2) ����

 ALTER TABLE tbl_member
 MODIFY ( etc VARCHAR2(255) );
 -- Table TBL_MEMBER��(��) ����Ǿ����ϴ�.
 
 DESC tbl_member;
     �̸�    ��?       ����            
    ----- -------- ------------- 
    ID    NOT NULL VARCHAR2(10)  
    NAME  NOT NULL VARCHAR2(2)   
    AGE            NUMBER(3)     
    BIRTH          DATE          
    TEL   NOT NULL CHAR(13)      
    ETC            VARCHAR2(255)
    
------
8) etc �÷����� bigo �÷������� �����ϰ�ʹ�.

���1) ��Ī(alias) ���
    SELECT etc bigo FROM tbl_member;

���2) �ʵ���� ����
    ALTER TABLE tbl_member
    RENAME COLUMN etc TO bigo;
    -- Table TBL_MEMBER��(��) ����Ǿ����ϴ�.
    
    DESC tbl_member;
           �̸�    ��?       ����           
    ----- -------- ------------ 
    ID    NOT NULL VARCHAR2(10) 
    NAME  NOT NULL VARCHAR2(2)  
    AGE            NUMBER(3)    
    BIRTH          DATE         
    TEL   NOT NULL CHAR(13)
    BIGO           VARCHAR2(255)

------  
9) bigo �÷��� �����ϰ�ʹ�
   ALTER TABLE tbl_member
   DROP COLUMN bigo;
   -- Table TBL_MEMBER��(��) ����Ǿ����ϴ�.
   
   DESC tbl_member;
       �̸�    ��?       ����           
    ----- -------- ------------ 
    ID    NOT NULL VARCHAR2(10) 
    NAME  NOT NULL VARCHAR2(2)  
    AGE            NUMBER(3)    
    BIRTH          DATE         
    TEL   NOT NULL CHAR(13)     

-----
10) tbl_member ���̺��� �̸� ����

RENAME tbl_member TO tbl_customer;