-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]

-- scott���� �����ؼ� ������ �ϳ� �����ϰڴ�... ���� �߻�
-- ������ ������ ���� ������ �� �ִ� ���� X
-- CREATE USER admin IDENTIFIED BY a123$;

--����� 4 �࿡�� �����ϴ� �� ���� �߻� -
--CREATE USER admin IDENTIFIED BY 123$  -> ��й�ȣ�� a�� ������..
���� ���� -
ORA-00911: invalid character
00911. 00000 -  "invalid character"           -> ��й�ȣ �ο��� �߸��ƴ�
*Cause:    The identifier name started with an ASCII character other than a
          letter or a number. After the first character of the identifier
           name, ASCII characters are allowed including "$", "#" and "_".
           Identifiers enclosed in double quotation marks may contain any
           character other than a double quotation. Alternate quotation
           marks (q'#...#') cannot use spaces, tabs, or carriage returns as
           delimiters. For all other contexts, consult the SQL Language
           Reference Manual.

CREATE USER admin IDENTIFIED BY a123$
���� ���� -
ORA-01031: insufficient privileges        -> ������ ������� �ʾƼ� ������ ������ �� ����.
01031. 00000 -  "insufficient privileges"
*Cause:    An attempt was made to perform a database operation without
           the necessary privileges.

--------------------------------------------------------------------------------------------------------

-- 1. ���̺� ����
-- CREATE TABLE �̷��� �ϴ°ǵ� ���� ������ �ȹ����
-- C����̺� -> oralcexe -> SCOTT.sql �˻� �� �޸������� ����
REM rem -> �̰͵� �ּ�

-- 2. scott ������ �����ϰ� �ִ� ���̺� ��ȸ(Ȯ��)
SELECT *
FROM tabs;
-- �����ϰ� �ִ� ���̺��� ����.

-- 3. DEPT ���̺�(�μ� ���̺�)�� �����ϰڴ�.
CREATE TABLE DEPT(
    DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY, -- DEPNO �÷�(�μ���ȣ �÷�)
	DNAME VARCHAR2(14) ,                             --DNAME �÷�(�μ��� �÷�)
	LOC VARCHAR2(13)                                 -- LOC �÷�(������ �÷�)
) ;
-- Table DEPT��(��) �����Ǿ����ϴ�.

-- ����Ŭ �ڷ��� :
-- number(2) -> 2�ڸ� ���� �ڷ���
-- varchar2(14) -> 14����Ʈ ũ���� ���ڿ� �ڷ���

SELECT *
FROM scott.dept;
FROM dept;
FROM ��Ű��.���̺��; -- ��Ģ�� �̷��� �ؾߵǴµ� ���� SCOTT�� �����߱� ������ ���̺�� ��� ����

-- 4. � ���̺��� ������ ��ȸ(Ȯ��)
-- 1�� ���
DESC dept;
DESC ���̺��;

-- scott ������ �����ϸ� scott ������ ������ ��Ű��(SCHEMA) ����

-- 5. dept ���̺� - �μ����� �߰� �۾�     DML INSERT��
--                      �μ���ȣ    '�μ���'     '������'
--                      ����Ŭ���� ���ڿ��� ��� �յڿ� ''(Ȭ����ǥ)�� ���δ�.
INSERT INTO DEPT VALUES	(10,'ACCOUNTING','NEW YORK'); -- ������ �ϳ��� �߰��ϴ� �۾�
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES	(30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES	(40,'OPERATIONS','BOSTON');
COMMIT;

-- 6. 4���� ��(���ڵ�)�� �߰�(INSERT) �Ǿ����� Ȯ��(��ȸ)
SELECT *
FROM dept;

-- 7. EMP (���) ���̺� ����
CREATE TABLE EMP(
-- ������� ������ �� �ִ� ������ Ű�� �����ȣ(empno) �÷��� ����
    EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY, -- �����ȣ, PRIMARY KEY(PK) == ������ Ű, ����Ű
	ENAME VARCHAR2(10),                            -- �����
	JOB VARCHAR2(9),        -- ��(��)
	MGR NUMBER(4),          -- ���ӻ���� �����ȣ
	HIREDATE DATE,          -- �Ի�����
	SAL NUMBER(7,2),        -- �޿�
	COMM NUMBER(7,2),       -- Ŀ�̼�
	DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT -- �μ���ȣ, REFERENCES(����) / dept(�μ�) ���̺��� DEPTNO(�μ���ȣ)�� �����ϰڴ�.
);
-- Table EMP��(��) �����Ǿ����ϴ�.

-- 8. ���(emp) ���̺� ��ȸ
SELECT *
FROM emp;

-- 9. ���(emp) ���̺� ������� �߰� (SCOTT, ADAMS ����)
INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,to_date('13-JUL-87')-85,3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,to_date('13-JUL-87')-51,1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);
COMMIT;

-- 10. 12���� ��� ���(�߰�)�� ���� Ȯ��(��ȸ)
SELECT *
FROM emp;

-- 11. ���ʽ� ���̺� ����
CREATE TABLE BONUS
	(
	ENAME VARCHAR2(10)	,
	JOB VARCHAR2(9)  ,
	SAL NUMBER,
	COMM NUMBER
	) ;

-- 12. �޿� ��� ���̺� ����
CREATE TABLE SALGRADE
      ( GRADE NUMBER,
	LOSAL NUMBER,
	HISAL NUMBER );
INSERT INTO SALGRADE VALUES (1,700,1200); -- 700~1200 �޿��� ������ 1���
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999); -- 3001~9999 �޿��� ������ 5���
COMMIT;

-- 13. SCOTT�� ������ ���̺� ���� ��ȸ
SELECT *
FROM tabs;

-- salgrade(�޿����) ���̺� ��ȸ
SELECT *
FROM salgrade;

-- ������� �� �۾��� SCOTT.sql ���Ϸ�(�޸��忭�) ���÷� ����� ���̺� 4�� ���� + ������ �߰� �۾�

-- 14. DQL - [ SELECT�� ]
-- 1) SELECT �Ǵ� subquery�� �̿��Ͽ�
-- 2) ��� : '�ϳ� �̻�'�� ���̺�, �� �κ���
-- 3) �����͸� �������� �� ����ϴ� �� ***

-- 15. � ���̺� �Ǵ� ��κ��� �����͸� ������ ������ ������(�ڽ� ������ ��Ű��) �Ǵ� SELECT ������ �־�� �Ѵ�.

-- 16.�����ġ�-> �ϱ� ���� ^^
    [subquery_factoring_clause] subquery [for_update_clause];

��subquery ���ġ�- ���� �ȿ� �ִ� subquery
   {query_block ?
    subquery {UNION [ALL] ? INTERSECT ? MINUS }... ? (subquery)} 
   [order_by_clause] 

��query_block ���ġ�- subquery �ȿ� �ִ� query_block
   SELECT [hint] [DISTINCT ? UNIQUE ? ALL] select_list
   FROM {table_reference ? join_clause ? (join_clause)},...
     [where_clause] 
     [hierarchical_query_clause] 
     [group_by_clause]
     [HAVING condition]
     [model_clause]

��subquery factoring_clause���ġ�
   WITH {query AS (subquery),...}
   
-- 17. ***** SELECT ���� ��(clause, �� �κ��� ��Ÿ���� ��) ***** �� ó�� ���� ***
������ ������ �� �ٲ��� �Ѵ�. (�Ʒ��� ����..)
ȣ�� ó�� ���������� �ڵ��� �Ʒ��� ���� ������ �Ѵ�.
[ WITH ��      --- 1 ]
SELECT ��    --- 6
FROM ��      --- 2
[ WHERE ��     --- 3 ]
[ GROUP BY ��  --- 4 ]
[ HAVING ��    --- 5 ]
[ ORDER BY ��  --- 7 ]

-- 18. SELECT ������ ����� �� �ִ� Ű����(�����) : DISTINCT, ALL, [AS]

-- 19. SELECT ����..
-- 1) ��� ��� ������ ��ȸ(Ȯ��, �˻�) �ϴ� SQL(����==Query)�� �ۼ��ϼ���.
SELECT * -- ��� �÷��� ��ȸ�ϰڴ�
FROM emp; -- ���̺�� �Ǵ� �� ���

-- 2) ��� ��� ������ ��ȸ�ϴ� SQL(����==Query)�� �ۼ��Ұǵ�.. ������ �ִ�.
(���� : �����ȣ, �����, �Ի����ڸ� ��ȸ)
SELECT empno, ename, hiredate
FROM emp;

-- 3) ��� ������� ��ȸ (�����ȣ, �����, �Ի�����, �޿�, Ŀ�̼�)
���� 1) �޿�(sal) ���� �޴� ��� ������ �����ؼ� ��ȸ
        sal ��������(descending) ����
SELECT empno, ename, hiredate, sal, comm
FROM emp
ORDER BY sal DESC; -- �������� ����
ORDER BY sal [ASC]; -- �⺻ ���� : ��������(ascending) ����

-- 4) ��� ������� ��ȸ
���� 1) �μ���ȣ, �����ȣ, �����, �Ի�����
���� 2) �Ի����� ������ ����(�ֱٿ� �Ի��� ����� ���� ���)
SELECT deptno, empno, ename, hiredate
FROM emp
ORDER BY deptno, hiredate;
ORDER BY deptno ASC, hiredate ASC;
-- 1���� ���� : deptno(�μ���) �������� ����
-- 2���� ���� : �μ����� ���ĵ� ���¿��� 2���� hiredate(�Ի�����)�������� �������� ����
ORDER BY 1 ASC, 4 DESC; -- 1�� deptno���� �ν�, 4�� hiredate�� �ν�
ORDER BY deptno ASC, hiredate DESC;
ORDER BY hiredate DESC; -- �Ի����� �������� ����

-- 5) HR �������� ���� Localhost_HR

-- ���ڿ� �����ϴ� ���
-- ���1) ||
SELECT ename || ' has $' || sal
FROM emp;

-- ���2) CONCAT
SELECT CONCAT( CONCAT( ename, ' has $' ), sal)
FROM emp;

-- 6) �����ȣ, �����, �Ի�����, sal, comm ���
-- ����1) sal + comm == pay�� ���

-- �̸� == ���� == ��Ī 
[AS Ű����]�� SELECT���� �÷��� ��Ī�� �ο��� �� ����ϴ� Ű����(�����)
"" �ֵ���ǥ�� �����ص� �����ϴ�.
AS�� �����ص� ��Ī�� �� �� �ִ�.
SELECT empno AS "�����ȣ"
       , ename AS �����
       , hiredate �Ի�����
       , sal, comm
       , sal + comm AS "����"
       , nvl2(sal + comm, sal + comm, sal) AS pay
       , nvl2(comm, sal + comm, sal)
       , sal + nvl(comm, 0) -- ���� nvl2() �ڵ��� ������ ���
FROM emp;
    (1) � �� + null ==> ������ null�� ���´�.
    (2) ����Ŭ null �ǹ�? ��Ȯ�� ��, ���� ������� ���� ��   
    ��) �̸� / ������
         ȫ�浿 / 65.93
         ��ö�� / null      -> ��ö���� �����Ը� ���� X -> Ȯ�� ���� ���� ��
    (3) comm �÷��� �� �� null ó�� �ʿ�
       ����) null�� 0���� ó���ϰڴ�.
    (4) ����Ŭ���� null ó���ϴ� �Լ� : nvl2(), nvl()
    �����ġ�
        NVL2(expr1, expr2, expr3)
        expr1 ���� null �ƴϸ� expr2
                  null �̸� expr3
        ù��° ���� � ������ Ÿ�Ե� ����, �� ��°�� �� ��° ������ LONG ������ Ÿ�� ��� X
    
    �����ġ�
	 NVL(expr1,expr2)
     null�� 0 �Ǵ� �ٸ� ������ ��ȯ�ϱ� ���� �Լ�
SELECT comm
        , nvl(comm, 0)
        , sal + nvl(comm, 0)
FROM emp;

-- 7) emp ������̺��� job ���(��ȸ)
-- ����1) �ߺ��� ������� ���� �� ���..  -> DISTINCT Ű���� ���
SELECT DISTINCT job -- ������ SELECT ALL job ALL�� �����Ǿ��� �ִ°�
FROM emp
ORDER BY job ASC;

-- 8) SCOTT ������ �����ϴ� ��� ���̺� ��ȸ
FROM ���̺�� �Ǵ� ���
-- user_tables�� tabs ���� ���̴�.
-- ����Ŭ '������ ����(dictionary)'�� ���Ե� ��(view) - user_tables == ���
SELECT *
FROM user_tables; -- ���
FROM tabs;

-- 9) emp ��� ���̺��� ��� ��� ������ ��ȸ(Ȯ��, �˻�)
-- ����1) 10�� �μ� ��� ������ ��ȸ - [WHERE ���]
-- ����2) sal+comm �޿� �������� �������� ����
-- �μ���ȣ, �����, pay(sal+comm)
SELECT deptno, ename, sal+nvl(comm, 0) pay
FROM emp
WHERE deptno = 10
ORDER BY sal + nvl(comm, 0) ASC;

WHERE deptno == 10
ORA-00936: missing expression
00936. 00000 -  "missing expression" -- '==' ������ �߸��Ǿ���. ����Ŭ���� ���ٶ�� �����ڴ� = 1��
*Cause:    
*Action:
299��, 15������ ���� �߻�

-- 10) insa.spl ��ũ��Ʈ ���� �ڵ�(������� �ֽ�)
CREATE TABLE insa(
        num NUMBER(5) NOT NULL CONSTRAINT insa_pk PRIMARY KEY
       ,name VARCHAR2(20) NOT NULL
       ,ssn  VARCHAR2(14) NOT NULL
       ,ibsaDate DATE     NOT NULL
       ,city  VARCHAR2(10)
       ,tel   VARCHAR2(15)
       ,buseo VARCHAR2(15) NOT NULL
       ,jikwi VARCHAR2(15) NOT NULL
       ,basicPay NUMBER(10) NOT NULL
       ,sudang NUMBER(10) NOT NULL
);
-- Table INSA��(��) �����Ǿ����ϴ�.

INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1001, 'ȫ�浿', '771212-1022432', '1998-10-11', '����', '011-2356-4528', '��ȹ��', 
   '����', 2610000, 200000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1002, '�̼���', '801007-1544236', '2000-11-29', '���', '010-4758-6532', '�ѹ���', 
   '���', 1320000, 200000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1003, '�̼���', '770922-2312547', '1999-02-25', '��õ', '010-4231-1236', '���ߺ�', 
   '����', 2550000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1004, '������', '790304-1788896', '2000-10-01', '����', '019-5236-4221', '������', 
   '�븮', 1954200, 170000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1005, '�Ѽ���', '811112-1566789', '2004-08-13', '����', '018-5211-3542', '�ѹ���', 
   '���', 1420000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1006, '�̱���', '780505-2978541', '2002-02-11', '��õ', '010-3214-5357', '���ߺ�', 
   '����', 2265000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1007, '����ö', '780506-1625148', '1998-03-16', '����', '011-2345-2525', '���ߺ�', 
   '�븮', 1250000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1008, '�迵��', '821011-2362514', '2002-04-30', '����', '016-2222-4444', 'ȫ����',    
'���', 950000 , 145000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1009, '������', '810810-1552147', '2003-10-10', '���', '019-1111-2222', '�λ��', 
   '���', 840000 , 220400);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1010, '������', '751010-1122233', '1997-08-08', '�λ�', '011-3214-5555', '������', 
   '����', 2540000, 130000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1011, '������', '801010-2987897', '2000-07-07', '����', '010-8888-4422', '������', 
   '���', 1020000, 140000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1012, '���ѱ�', '760909-1333333', '1999-10-16', '����', '018-2222-4242', 'ȫ����', 
   '���', 880000 , 114000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1013, '���̼�', '790102-2777777', '1998-06-07', '���', '019-6666-4444', 'ȫ����', 
   '�븮', 1601000, 103000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1014, 'Ȳ����', '810707-2574812', '2002-02-15', '��õ', '010-3214-5467', '���ߺ�', 
   '���', 1100000, 130000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1015, '������', '800606-2954687', '1999-07-26', '���', '016-2548-3365', '�ѹ���', 
   '���', 1050000, 104000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1016, '�̻���', '781010-1666678', '2001-11-29', '���', '010-4526-1234', '���ߺ�', 
   '����', 2350000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1017, '�����', '820507-1452365', '2000-08-28', '��õ', '010-3254-2542', '���ߺ�', 
   '���', 950000 , 210000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1018, '�̼���', '801028-1849534', '2004-08-08', '����', '018-1333-3333', '���ߺ�', 
   '���', 880000 , 123000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1019, '�ڹ���', '780710-1985632', '1999-12-10', '����', '017-4747-4848', '�λ��', 
   '����', 2300000, 165000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1020, '������', '800304-2741258', '2003-10-10', '����', '011-9595-8585', '�����', 
   '���', 880000 , 140000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1021, 'ȫ�泲', '801010-1111111', '2001-09-07', '���', '011-9999-7575', '���ߺ�', 
   '���', 875000 , 120000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1022, '�̿���', '800501-2312456', '2003-02-25', '����', '017-5214-5282', '��ȹ��', 
   '�븮', 1960000, 180000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1023, '���μ�', '731211-1214576', '1995-02-23', '����', NULL           , '������', 
   '����', 2500000, 170000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1024, '�踻��', '830225-2633334', '1999-08-28', '����', '011-5248-7789', '��ȹ��', 
   '�븮', 1900000, 170000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1025, '�����', '801103-1654442', '2000-10-01', '����', '010-4563-2587', '������', 
   '���', 1100000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1026, '�����', '810907-2015457', '2002-08-28', '���', '010-2112-5225', '������', 
   '���', 1050000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1027, '�迵��', '801216-1898752', '2000-10-18', '����', '019-8523-1478', '�ѹ���', 
   '����', 2340000, 170000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1028, '�̳���', '810101-1010101', '2001-09-07', '����', '016-1818-4848', '�λ��', 
   '���', 892000 , 110000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1029, '�踻��', '800301-2020202', '2000-09-08', '����', '016-3535-3636', '�ѹ���', 
   '���', 920000 , 124000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1030, '������', '790210-2101010', '1999-10-17', '�λ�', '019-6564-6752', '�ѹ���', 
   '����', 2304000, 124000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1031, '����ȯ', '771115-1687988', '2001-01-21', '����', '019-5552-7511', '��ȹ��', 
   '����', 2450000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1032, '�ɽ���', '810206-2222222', '2000-05-05', '����', '016-8888-7474', '�����', 
   '���', 880000 , 108000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1033, '��̳�', '780505-2999999', '1998-06-07', '����', '011-2444-4444', '������', 
   '���', 1020000, 104000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1034, '������', '820505-1325468', '2005-09-26', '���', '011-3697-7412', '��ȹ��', 
   '���', 1100000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1035, '������', '831010-2153252', '2002-05-16', '��õ', NULL           , '���ߺ�', 
   '���', 1050000, 140000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1036, '���翵', '701126-2852147', '2003-08-10', '����', '011-9999-9999', '�����', 
   '���', 960400 , 190000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1037, '�ּ���', '770129-1456987', '1998-10-15', '��õ', '011-7777-7777', 'ȫ����', 
   '����', 2350000, 187000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1038, '���μ�', '791009-2321456', '1999-11-15', '�λ�', '010-6542-7412', '������', 
   '�븮', 2000000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1039, '�����', '800504-2000032', '2003-12-28', '���', '010-2587-7895', '������', 
   '�븮', 2010000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1040, '�ڼ���', '790509-1635214', '2000-09-10', '���', '016-4444-7777', '�λ��', 
   '�븮', 2100000, 130000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1041, '�����', '721217-1951357', '2001-12-10', '�泲', '016-4444-5555', '�����', 
   '����', 2300000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1042, 'ä����', '810709-2000054', '2003-10-17', '���', '011-5125-5511', '���ߺ�', 
   '���', 1020000, 200000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1043, '��̿�', '830504-2471523', '2003-09-24', '����', '016-8548-6547', '������', 
   '���', 1100000, 210000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1044, '����ȯ', '820305-1475286', '2004-01-21', '����', '011-5555-7548', '������', 
   '���', 1060000, 220000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1045, 'ȫ����', '690906-1985214', '2003-03-16', '����', '011-7777-7777', '������', 
   '���', 960000 , 152000);         
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1046, '����', '760105-1458752', '1999-05-04', '�泲', '017-3333-3333', '�ѹ���', 
   '����', 2650000, 150000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1047, '�긶��', '780505-1234567', '2001-07-15', '����', '018-0505-0505', '������', 
   '�븮', 2100000, 112000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1048, '�̱��', '790604-1415141', '2001-06-07', '����', NULL           , '���ߺ�', 
   '�븮', 2050000, 106000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1049, '�̹̼�', '830908-2456548', '2000-04-07', '��õ', '010-6654-8854', '���ߺ�', 
   '���', 1300000, 130000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1050, '�̹���', '810403-2828287', '2003-06-07', '���', '011-8585-5252', 'ȫ����', 
   '�븮', 1950000, 103000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1051, '�ǿ���', '790303-2155554', '2000-06-04', '����', '011-5555-7548', '������', 
   '����', 2260000, 104000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1052, '�ǿ���', '820406-2000456', '2000-10-10', '���', '010-3644-5577', '��ȹ��', 
   '���', 1020000, 105000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1053, '��̽�', '800715-1313131', '1999-12-12', '����', '011-7585-7474', '�����', 
   '���', 960000 , 108000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1054, '����ȣ', '810705-1212141', '1999-10-16', '����', '016-1919-4242', 'ȫ����', 
   '���', 980000 , 114000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1055, '���ѳ�', '820506-2425153', '2004-06-07', '����', '016-2424-4242', '������', 
   '���', 1000000, 104000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1056, '������', '800605-1456987', '2004-08-13', '��õ', '010-7549-8654', '������', 
   '�븮', 1950000, 200000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1057, '�̹̰�', '780406-2003214', '1998-02-11', '���', '016-6542-7546', '�����', 
   '����', 2520000, 160000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1058, '�����', '800709-1321456', '2003-08-08', '��õ', '010-2415-5444', '��ȹ��', 
   '�븮', 1950000, 180000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1059, '�Ӽ���', '810809-2121244', '2001-10-10', '����', '011-4151-4154', '���ߺ�', 
   '���', 890000 , 102000);
INSERT INTO insa (num, name, ssn, ibsaDate, city, tel, buseo, jikwi, basicPay, sudang) VALUES
  (1060, '��ž�', '810809-2111111', '2001-10-10', '����', '011-4151-4444', '���ߺ�', 
   '���', 900000 , 102000);
   
COMMIT;

----------------------------------------------------------------------------------
SELECT *
FROM insa;

-- ����1) insa ���̺��� ����� ��������� '����'�� ����� ���� ��ȸ(���)
--      ����1) �����ȣ, �̸�, �Ի�����, ������� ���
SELECT num, name, ibsadate, city
FROM insa
WHERE city = '����';

-- ����2) insa ���̺��� ����� ��������� �������� ����� ���� ��ȸ(���)
--      ����1) �����ȣ, �̸�, �Ի�����, ������� ���
-- ������ ?
-- ���1) OR ������ ���
SELECT num, name, ibsadate, city
FROM insa
WHERE city = '����' OR city = '��õ' OR city = '���' -- OR ������ == OR
ORDER BY city ASC;

-- ���2) SQL ������ �� IN ���
SELECT num, name, ibsadate, city
FROM insa
WHERE city IN('����', '���', '��õ')
ORDER BY city ASC;

-- ����3) insa ���̺��� ����� ��������� '����'�� �ƴ� ����� ���� ��ȸ(���)
--      ����1) �����ȣ, �̸�, �Ի�����, ������� ���
-- �� ������ �� ���� �ʴ� : !=  <>   ^=
-- �� ������ : NOT
-- SQL ������ : NOT IN -- ����� ��� ��� ����, �ϳ��� ������ ���� �񱳿����� ����ϱ�
SELECT num, name, ibsadate, city
FROM insa

WHERE city != '����'
WHERE city <> '����'
WHERE city ^= '����'

WHERE NOT city = '����'

WHERE city NOT IN('����') -- ����� ��� ��� ����, �ϳ��� ������ ���� �񱳿����� ����ϱ�

WHERE NOT city IN('����') -- �̶��� NOT�� ���������� city IN ('����')�� �����ϰڴ�.

ORDER BY city ASC;


-- ����4) insa ���̺��� ����� ��������� �������� �ƴ� ����� ���� ��ȸ(���)
--      ����1) �����ȣ, �̸�, �Ի�����, ������� ���
SELECT num, name, ibsadate, city
FROM insa
WHERE city != '����' AND city != '��õ' AND city != '���' -- �񱳿�����
WHERE city NOT IN ('����', '��õ', '���') -- NOT IN() SQL ������
WHERE NOT city IN ('����', '��õ', '���') -- NOT ���� ������
ORDER BY city ASC;

-- ����5) insa ���̺��� �⺻���� 150���� �̻��� ��� ������ ���
-- ����1) name, basicpay
-- ����2) �μ����� 1�� ����, 2�� ���ķ� basicpay �������� ����
SELECT buseo, name, basicpay
FROM insa
WHERE basicpay >= 1500000
ORDER BY buseo ASC, basicpay ASC; -- ASC ������ �⺻���� �������� ����!

-- ����6) insa ���̺��� �⺻���� 150���� �̻� 250���� ������ ��� ������ ���
-- ����1) ������ ����� ��ȸ
-- ����2) �⺻�� �������� ����
SELECT buseo, name, basicpay
FROM insa
-- WHERE buseo = '������' AND (basicpay >= 1500000 AND basicpay <= 2500000)
-- BETWEEN�� �ڱ� �ڽ��� ���� ����, a AND b �� b�� ���� a���� Ŀ����
WHERE buseo = '������' AND basicpay BETWEEN 1500000 AND 2500000  -- �̰� �� ���� �����
ORDER BY basicpay;

[������]
������	������	1950000
������	������	1954200
������	���μ�	2000000
������	�����	2010000
������	�긶��	2100000
������	�ǿ���	2260000
������	���μ�	2500000

-- ����7) insa ���̺��� �⺻���� 150���� �̸��̰� 250���� �ʰ��ؼ� �޴� ����� ���� ���
-- ����1) ������ ����� ��ȸ
-- ����2) �⺻�� �������� ����
SELECT buseo, name, basicpay
FROM insa
WHERE buseo = '������' AND basicpay < 1500000 OR basicpay > 2500000
WHERE buseo = '������' AND NOT(basicpay BETWEEN 1500000 AND 2500000)
WHERE buseo = '������' AND basicpay NOT BETWEEN 1500000 AND 2500000
ORDER BY basicpay;

-- ����8) insa ���̺��� �Ի�⵵�� 1998�⵵�� ����� ������ ���
-- ����1) name, ibsadate �÷� ���
-- ���̺� ���� Ȯ��..
DESC insa;  -- IBSADATE ����Ŭ �ڷ��� : ��¥��(DATE)
-- '98/01/01' ����Ŭ���� ���ڿ�, ��¥���� ''�� �ٴ´�.

-- WHERE ibsadate ����ǥ���� 98 ����(�˻��غ���)
-- ibsadate Java�� substring()�� ����.. SUBSTR() �Լ�
-- ����Ŭ ��¥ �⵵ ��ȯ �Լ� ? LIKE ������, REGEX_LIKE()
SELECT name, ibsadate
       -- , SUBSTR(ibsadate, 1, 2)
       -- , SUBSTR(ibsadate, 0, 2)
FROM insa
-- WHERE ibsadate >= '1998.1.1' AND ibsadate <= '1998.12.31'
-- WHERE ibsadate >= '98/01/01' AND ibsadate <= '98/12/31'
-- WHERE ibsadate BETWEEN '1998-01-01' AND '1998-12-31'
WHERE SUBSTR(ibsadate, 0, 2) = '98'
ORDER BY ibsadate ASC;

-- ���� ����Ŭ ������, �ڷ���, �Լ�...
-- ����) emp ���̺��� comm�� null�� ��� ��� ������ ��ȸ(���)�ϴ� ����(SQL) �ۼ��ϼ���.
SELECT *
FROM emp
WHERE comm IS NULL;
