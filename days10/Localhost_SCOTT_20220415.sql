-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]
---- �������� ----

1. ����Ŭ �� DataType �� ���� ���� �����ϼ���
DATE ��,��,��,��,��,�ʱ��� ������ ��¥��
TIMESTAMP DATE�� Ȯ�������� n���� 0~9�� �� �� �ְ� ns���� ǥ���� �� �ִ�.

2.  emp ���̺��� [�⵵��] [����] �Ի����� ���.( PIVOT() �Լ� ��� )

    [������]
    1982	1	0	0	0	0	0	0	0	0	0	0	0
    1980	0	0	0	0	0	0	0	0	0	0	0	1
    1981	0	2	0	1	1	1	0	0	2	0	1	2

SELECT *    
FROM (SELECT TO_CHAR(hiredate, 'YYYY') �Ի�⵵, TO_CHAR(hiredate, 'FMMM') �Ի�� FROM emp )
PIVOT(COUNT(*) FOR �Ի�� IN(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12));
    
2-2.   emp ���̺��� �� JOB�� �Ի�⵵�� 1��~ 12�� �Ի��ο��� ���.  ( PIVOT() �Լ� ��� ) 
    [������]
    ANALYST		1981	0	0	0	0	0	0	0	0	0	0	0	1
    CLERK		1980	0	0	0	0	0	0	0	0	0	0	0	1
    CLERK		1981	0	0	0	0	0	0	0	0	0	0	0	1
    CLERK		1982	1	0	0	0	0	0	0	0	0	0	0	0
    MANAGER		1981	0	0	0	1	1	1	0	0	0	0	0	0
    PRESIDENT	1981	0	0	0	0	0	0	0	0	0	0	1	0
    SALESMAN	1981	0	2	0	0	0	0	0	0       

SELECT *
FROM (SELECT job, TO_CHAR(hiredate, 'YYYY') �Ի�⵵, TO_CHAR(hiredate, 'FMMM') �Ի�� FROM emp )
PIVOT(COUNT(*) FOR �Ի�� IN(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12))
ORDER BY job;


3. emp���̺��� �Ի����ڰ� ������ ������ 3�� ��� ( TOP 3 )
    [������]
    1	7369	SMITH	CLERK	    7902	80/12/17	800		    20
    2	7499	ALLEN	SALESMAN	7698	81/02/20	1600	300	30
    3	7521	WARD	SALESMAN	7698	81/02/22	1250	500	30    

Ǯ��1) RANK()
SELECT *
FROM(
    SELECT RANK() OVER(ORDER BY hiredate) rn
    , emp.* 
    FROM emp
) t
WHERE rn <= 3;

Ǯ��2) TOP-N

SELECT ROWNUM, t.*
FROM(
    SELECT *
    FROM emp
    ORDER BY hiredate
) t
WHERE ROWNUM <= 3;


4. SMS ������ȣ  ������  6�ڸ� ���� ��� ( dbms_random  ��Ű�� ��� )
SELECT ROUND(dbms_random.value(0, 1000000))
    , SUBSTR(LTRIM(LTRIM(dbms_random.value, '0.'), '0'), 0, 6)
    , TRUNC(dbms_random.value(100000, 1000000))
FROM dual;

4-2. ������ ��ҹ��� 5���� ���( dbms_random  ��Ű�� ��� )
SELECT dbms_random.string('A', 5)
FROM dual;

5. �Խñ��� �����ϴ� ���̺� ����
   ��.   ���̺�� : tbl_test
   ��.   �÷�                   �ڷ���  ũ��    ����뿩��    ����Ű
         �۹�ȣ    seq          NUMBER        NOT NULL     PRIMARY KEY
         �ۼ���    writer       VARCHAR2(20)    NOT NULL   
         ��й�ȣ passwd        VARCHAR2(15)    NOT NULL
         ������    title         VARCHAR2(20) NOT NULL
         �۳���    content        VARCHAR2 
         �ۼ���    regdate     DATE
    ��.  �۹�ȣ, �ۼ���, ��й�ȣ, �� ������ �ʼ� �Է� �������� ����
    ��.  �۹�ȣ��  �⺻Ű( PK )�� ����
    ��.  �ۼ����� ���� �ý����� ��¥�� �ڵ� ����


CREATE TABLE tbl_test(
    -- seq NUMBER NOT NULL [CONSTRAINTS PK���������̸�] PRIMARY KEY
     seq NUMBER NOT NULL CONSTRAINTS PK_tbltest_seq PRIMARY KEY
    , writer VARCHAR2(20) NOT NULL
    , passwd VARCHAR2(20) NOT NULL
    , title VARCHAR2(100) NOT NULL
    , content LONG
    , regdate DATE DEFAULT SYSDATE
);
-- Table TBL_TEST��(��) �����Ǿ����ϴ�.

5-2. ��ȸ��    read   �÷��� �߰� ( �⺻�� 0 ����  ���� ) 
ALTER TABLE tbl_test
ADD read NUMBER DEFAULT 0;
-- Table TBL_TEST��(��) ����Ǿ����ϴ�.

5-3. �۳���    content �÷��� �ڷ����� clob �� ���� 
ALTER TABLE tbl_test
MODIFY(content CLOB);
-- Table TBL_TEST��(��) ����Ǿ����ϴ�.

5-4. ���̺� ���� Ȯ��
DESC tbl_test;

�̸�      ��?       ����            
------- -------- ------------- 
SEQ     NOT NULL NUMBER        
WRITER  NOT NULL VARCHAR2(20)  
PASSWD  NOT NULL VARCHAR2(20)  
TITLE   NOT NULL VARCHAR2(100) 
CONTENT          CLOB          
REGDATE          DATE          
READ             NUMBER    

5-5. ������     title ��   subject�� ���� 
���� �ٲ��� �ʾƵ� ��Ī ��� ����!
SELECT title subject
FROM tbl_test;

ALTER TABLE tbl_test
RENAME COLUMN title TO subject;
-- Table TBL_TEST��(��) ����Ǿ����ϴ�.

5-6.  tbl_test  -> tbl_board ���̺�� ���� 
RENAME tbl_test TO tbl_board;
-- ���̺� �̸��� ����Ǿ����ϴ�.

�̸�      ��?       ����            
------- -------- ------------- 
SEQ     NOT NULL NUMBER        
WRITER  NOT NULL VARCHAR2(20)  
PASSWD  NOT NULL VARCHAR2(20)  
SUBJECT NOT NULL VARCHAR2(100) 
CONTENT          CLOB          
REGDATE          DATE          
READ             NUMBER  

5-7. CRUD  ( insert, select, update, delete ) 
   ��. ������ �Խñ� 5���� �߰� insert
   INSERT INTO tbl_board (seq, writer, passwd, subject, content, regdate, read)
                VALUES(1, 'admin', '1234', 'test 1', 'test 1', SYSDATE, 0);
   
   -- regdate, read �÷� ���� - DEFAULT ���� �Ǿ� �־             
   INSERT INTO tbl_board (seq, writer, passwd, subject, content)
                VALUES(2, 'ȫ�浿', '1234', 'ȫ�浿 1', 'ȫ�浿 1');             
   
   -- �۳���(content) �ʼ��Է»��� X             
   INSERT INTO tbl_board (seq, writer, passwd, subject)
                VALUES(3, '�ͼ���', '1234', 'ȫ�浿 1'); 
                
   COMMIT;
   
   ��. �Խñ� ��ȸ select
   SELECT *
   FROM tbl_board;
   
   ��. 3�� �Խñ��� �� ����, ���� ���� update
   -- �Խñ� ����, ������ ���� �˻� �Ŀ� �Խñ��� �����ϰų� �����Ѵ�.
   1) �˻��۾�
   SELECT seq, subject, content
   FROM tbl_board
   WHERE seq = 3;
   
   2) �������
   UPDATE tbl_board
   SET subject = '[e]'|| subject , content = '[e]' || NVL(content, '�ƹ�����')
   WHERE seq = 3;
   
   3) ���泻�� Ȯ��
   SELECT *
   FROM tbl_board;
   
   4) Ŀ��
   COMMIT;
   
   ��. 4�� �Խñ� ���� delete
   DELETE tbl_board
   WHERE seq = 4;
   -- 0�� �� ��(��) �����Ǿ����ϴ�.
   4��° �Խñ��� ���� ������ ���� ���� �޽����� ���� ��, �˻��ϴ� �۾��� �����ؾߵȴ�!
   
5-8. tbl_board ���̺� ����  
DROP TABLE tbl_board PURGE;
-- PUGE �ɼ� ���̺��� �����뿡 �ִ� ���� �ƴ϶� ������ �����ؼ� ������Ű�� ���ϵ��� �ϰڴ�.


6-1. ������ ��¥�� ���� ��� 
 [������]
���ó�¥  ���ڿ���  ���ڸ�����       ����
-------- ---        ------   ------------
22/04/15  6             ��      �ݿ���      

SELECT SYSDATE ���ó�¥
    , TO_CHAR(SYSDATE, 'D') ���ڿ���
    , TO_CHAR(SYSDATE, 'DY') ���ڸ�����
    , TO_CHAR(SYSDATE, 'DAY') ����
FROM dual;

6-2. �̹� ���� ������ ���� ��¥�� ��� 
 [������]
���ó�¥  �̹��޸�������¥                  ��������¥(��)
-------- -------- -- ---------------------------------
22/04/15 22/04/30 30                                30

SELECT SYSDATE ���ó�¥
    , LAST_DAY(SYSDATE) �̹��޸�������¥
    , TO_CHAR(LAST_DAY(SYSDATE), 'DD')
FROM dual;


6-3.
 [������]
���ó�¥    �������� �������� ���� ����
--------    -       --      --
22/04/15    3       15      15

SELECT SYSDATE
    , TO_CHAR(SYSDATE, 'W')
    , TO_CHAR(SYSDATE, 'IW')
    , TO_CHAR(SYSDATE, 'WW')
FROM dual;

------------------------------------------
!!���ο� ����~!!

1. [�� ����]
 - "WW"�� "IW" ��� 1���� �� ����(1~53)�� ��ȸ�ϴ� ���� �̴�.
 - "WW" :  1�� ~ 7���� 1������ ���� -> ��, �ش�⵵�� 1��~7���� 1���� 7������ ��� ���Ǵ� ��
 - "IW" : �� ~ �Ͽ��� ����(���� �޷¿� �°� ������ ���)

1/2/3   4
IW 13   14
WW 13  2�Ϻ��� 14
SELECT TO_CHAR(TO_DATE('2022.4.4'), 'IW')
    ,TO_CHAR(TO_DATE('2022.4.4'), 'WW')
FROM dual;

-----------------------------------------------------
2. [CREATE TABLE ���� ���� ���̺� ����]
    ? *** ���̺��� ����� ���� �ܼ��ϸ鼭�� �Ϲ����� ��� �������� ����� ���  -> �츮�� ��� ����ߴ� ���
    
    ? Extend table ���� -> ������� ������~
        �����ġ�
        CREATE TABLE table
        ( �÷�1  	������Ÿ��,
          �÷�2  	������Ÿ��,...)
        STORAGE    (INITIAL  	ũ��
                NEXT	ũ��
                MINEXTENTS	ũ��
                MAXEXTENTS	ũ��
                PCTINCREASE	n);

        ĳ�� ���̺��� ����ϰ� ���Ǵ� ���̺� �����͸� �����͹��� ĳ�ÿ����� ���ֽ��� 
        �˻��� ������ ����Ŵ.
        
    ? *** Subquery�� �̿��� table ���� -> ���� ��� ���!
    
    ? External table ���� -> ������� ������~
     - external ���̺��� DB �ܺο� ����� data source�� �����ϱ� ���� ���� ����� �ϳ��� �б� ���� ���̺��̴�.

    ? NESTED TABLE ���� -> ������� ������~
    ���̺��� ��� �÷��� �ϳ��� �����͸� �ִ� ���� �ƴ϶� �� �÷��� ���� ���� �Ӽ��� ���� �����͸� ���� �� �ִ� ������ ������Ÿ���̴�.
    ��, ���̺� ���� ��� �÷��� �� �ٸ� ���̺� ������ ������.
    
    ? Partitioned Tables & Indexes ���� 

-----
[Subquery�� �̿��� table ����]
--  ���� ���̺� ���ϴ� �����Ͱ� �̹� ������ ��� subquery�� �̿��Ͽ� ���̺��� �����Ѵٸ�
-- ���̺� ������ ������ �Է��� ���ÿ� �� �� �ִ�.

1) �̹� �����ϴ� ���̺��� �ְ�
2) SELECT ~ ���������� �̿��ؼ�
3) ���ο� ���̺��� ���� + ������ �߰�(INSERT) �� �� �ִ�.

4)�����ġ�
	CREATE TABLE ���̺�� [�÷��� (,�÷���),...] -- �÷����� ������ָ� �÷����� �ٲ� �� �ִ�.
	AS subquery;
    
    ? �ٸ� ���̺� �����ϴ� Ư�� �÷��� ���� �̿��� ���̺��� �����ϰ� ���� �� ���
    ? Subquery�� ��������� table�� ������
    ? �÷����� ����� ��� subquery�� �÷����� ���̺��� �÷����� �����ؾ� �Ѵ�.
        -> �÷����� ������ָ� �÷����� �ٲ� �� �ִ�. ��, ������ ���ƾ��Ѵ�.
    ? �÷��� ������� ���� ���, �÷����� subquery�� �÷���� ���� �ȴ�.
        -> [�÷��� (,�÷���),...] ������� ������ �Ȱ��� ��������.
    ? subquery�� �̿��� ���̺��� ������ �� CREATE TABLE ���̺�� �ڿ� �÷����� ����� �ִ� ���� ����.
    
5) ��)
    ��. emp ���̺��� 10�� �μ����鸸 �˻� -> empno, ename, hiredate, sal + NVL(comm, 0) pay �̷� �����͸� ������
        ���ο� ���̺��� ����
        
    CREATE TABLE tbl_emp10 -- (no, name, ibsadate, pay) 
    AS (
        SELECT empno, ename, hiredate, sal + NVL(comm, 0) pay
        FROM emp
        WHERE deptno = 10
    );
    -- Table TBL_EMP10��(��) �����Ǿ����ϴ�.
    
6) ���̺��� ����Ȯ��
    DESC tbl_emp10;
    
    �̸�       ��? ����           
    -------- -- ------------ 
    EMPNO       NUMBER(4)       emp ���̺��� �ڷ���
    ENAME       VARCHAR2(10)    emp ���̺��� �ڷ���
    HIREDATE    DATE            emp ���̺��� �ڷ���
    PAY         NUMBER          �ý����� �ڵ����� �ڷ��� ����

7) ���� ���̺��� �״�� �ΰ�, ���̺��� �����ؼ� ����ϰ� ���� ��
    ��, ������ �ΰ� �����ؼ� ���
    CREATE TABLE tbl_empcopy
    AS( SELECT * FROM emp );
    -- Table TBL_EMPCOPY��(��) �����Ǿ����ϴ�.
    -- emp ���̺��� ���� + 12���� ���(������) �״�� ���� -> ���ο� ���̺� ����
    
    DESC tbl_empcopy;
    
    SELECT *
    FROM tbl_empcopy;
    
8) ���������� ������� �ʴ´�. (NOT NULL ���������� ����! ����ȴ�)
    ��. emp �������� Ȯ��
    SELECT *
    FROM user_constraints -- �������� Ȯ��
    WHERE table_name = UPPER('emp');
    
    OWNER   CONSTRAINT_NAME   CONSTRAINT_TYPE  
    ������     ���������̸�      ��������Ÿ��
    SCOTT	PK_EMP	            P           -> PK
    SCOTT	FK_DEPTNO	        R           -> FK
    
    ��. ������ tbl_empcopy �������� Ȯ�� -- ���������� �ƹ��͵� ���簡 ���� �Ⱦ���
    SELECT *
    FROM user_constraints -- �������� Ȯ��
    WHERE table_name = UPPER('tbl_empcopy');

9) ���̺� ����
    DROP TABLE tbl_emp10 PURGE;
    DROP TABLE tbl_empcopy PURGE;
    
    COMMIT;
    
10) ���� - ���̺��� �������̺� ���������� ����ؼ� ���� + �����ʹ� �߰� X

Ǯ��1)
    ��. ���̺� ����
    CREATE TABLE tbl_empcopy
    AS (
        SELECT *
        FROM emp
    );
    
    ��. Ȯ��
    SELECT *
    FROM tbl_empcopy;
    
    ��. ������ ����
    DELETE FROM tbl_empcopy; -- WHERE ������ ���ָ� ������ �ΰ� �����͸� ������
    
    ��. Ŀ��
    COMMIT;
    
    ��. Ȯ��
    SELECT *
    FROM tbl_empcopy;

Ǯ��2) *** ���� ������ �༭ ������ �����ϱ�
    CREATE TABLE tbl_empcopy
    AS (
        SELECT *
        FROM emp
        WHERE 1 = 0 -- ���� ������ �ش�.
    );
    
    SELECT *
    FROM tbl_empcopy;

-------------------------------------------------------------------------------------
3. [DML ����ϱ�]

1) tbl_member ���̺� �ִ��� Ȯ��
    SELECT *
    FROM user_tables
    WHERE REGEXP_LIKE (table_name, 'member', 'i');
    
2) tbl_member ���� �� Ȯ��
    DROP TABLE tbl_member;
    COMMIT;
    
3) ���̺� ����
rrn �ֹε�Ϲ�ȣ�� �÷�(�Ӽ�)���� �߰��ϸ� ����, ����, ������ ������ �� ���� -> ����, ����, ������ ���� �Ӽ��̶�� �Ѵ�.
�׷��� �Ʒ��� ���� �÷��� �ִ°� �ƴ϶� rrn���� �ִ� ���� ����! �𵨸� ��� �� �ٽ� ����~
    
    -- PRIMARY KEY�� ȸ���ؼ� �ٸ� �÷����� �ٲ������ NOT NULL ���������� ���ָ� ������� ������ NOT NULL�� �־��ִ°� ����
    CREATE TABLE tbl_member(
        id VARCHAR2(10) NOT NULL CONSTRAINTS PK_TBLMEMBER_ID PRIMARY KEY -- ȸ��ID / ����Ű(PK) == UK(���ϼ�) + NN(NOT NULL) ����
        , name VARCHAR2(20) NOT NULL-- ȸ���̸�
        , age NUMBER(3) -- ȸ������
        , birth DATE -- ȸ������
        , regdate DATE DEFAULT SYSDATE -- ȸ��������
        , point NUMBER DEFAULT 100 -- ȸ������Ʈ        
    );
    -- Table TBL_MEMBER��(��) �����Ǿ����ϴ�.
    
4) �������� Ȯ��
    SELECT *
    FROM user_constraints
    WHERE table_name = UPPER('tbl_member');
    ��������      Ÿ��
    PK           P
    NN           C
    FK           R
    -- �������� ���� �������� ������ �ڵ����� SYS_~~~ ����
    -- ex) SYS_C007078

5) ��� �߰�
INSERT INTO tbl_member (id, name, age, birth, regdate, point)
            VALUES('admin', '������', 32, TO_DATE('03/04/1991', 'MM/DD/YYYY'), SYSDATE, 100);
-- ORA-01830: date format picture ends before converting entire input string
-- ��¥ ���� �ȸ¾Ƽ� �߻�.. TO_DATE�� ��¥ ���� �ٲ��ֱ�

INSERT INTO tbl_member (id, name, age, birth, regdate, point)
            VALUES('admin', 'ȫ�浿', 22, '2001.01.01', SYSDATE, 100);
-- ORA-00001: unique constraint (SCOTT.PK_TBLMEMBER_ID) violated
-- PK ���������� �ָ� UK(���ϼ�) + NN(NOT NULL) ����

INSERT INTO tbl_member -- (id, name, age, birth, regdate, point) -> ������� �Է��� ���̶� �÷��� ���� ����
            VALUES('hong', 'ȫ�浿', 22, '2001.01.01', SYSDATE, 100);

INSERT INTO tbl_member VALUES('park', '������', 25, '1998.5.9');
-- SQL ����: ORA-00947: not enough values
-- VALUES ���� ������� ���� -> �÷����� �־���� ����

INSERT INTO tbl_member (id, name, age, birth) VALUES('park', '������', 25, '1998.5.9');

INSERT INTO tbl_member (name, birth, id, age) VALUES('�߸���', null, 'yaliny', 25);
-- �÷����� �� ������� ���� �ʾƵ� �ȴ�. �Է��ϴ� ���� ������ �����ϸ� ��
-- NULL�� ����ϴ� �÷��� NULL�� �����͸� �־ �ȴ�.

COMMIT; 

SELECT *
FROM tbl_member;

-----------
4. [���������� ����ؼ� INSERT �� �� �ִ�.]
[����]
    INSERT INTO ���̺�� (��������);

����)
1) tbl_emp10 ���̺� ���� Ȯ���� �ִٸ� ���̺� ����
2) emp ���̺��� ���� ����, ������ ���� X -> tbl_emp10 ���̺� ���� 

    CREATE TABLE tbl_emp10 -- �÷���...
    AS(
        SELECT *
        FROM emp
        WHERE 1 = 0
    );
-- Table TBL_EMP10��(��) �����Ǿ����ϴ�.

    SELECT *
    FROM tbl_emp10;

3) emp ���̺��� 10���μ������� SELECT�ؼ� tbl_emp10 ���̺� �߰�
    INSERT INTO tbl_emp10(SELECT * FROM emp WHERE deptno = 10);
    -- 3�� �� ��(��) ���ԵǾ����ϴ�.
    COMMIT;
    
    DROP TABLE tbl_emp10 PURGE;

--------------------
5. [MULTITABLE INSERT ��]
- �ϳ��� insert ������ ���� ���� ���̺� ���ÿ� �ϳ��� ���� �Է��ϴ� ���̴�.
- 4���� ����
- conditional / unconditional : ������ ����
- all / first : ���� / ù��°���׸�
- pivoting : �ǹ�
    ��. unconditional insert all
    ��. conditional insert all
    ��. conditional first insert
    ��. pivoting insert 

1) ��. unconditional insert all
- ���ǰ� ������� ���� ���� ���̺� �����͸� �Է��Ѵ�.
? ���������κ��� �ѹ��� �ϳ��� ���� ��ȯ�޾� ���� insert ���� �����Ѵ�.
? into ���� values ���� ����� �÷��� ������ ������ Ÿ���� �����ؾ� �Ѵ�.

�����ġ�
	INSERT ALL | FIRST
	  [INTO ���̺�1 VALUES (�÷�1,�÷�2,...)]
	  [INTO ���̺�2 VALUES (�÷�1,�÷�2,...)]
	  .......
	��������;

---
    <����>
    CREATE TABLE dept_10 AS SELECT * FROM dept WHERE 1=0;
    CREATE TABLE dept_20 AS SELECT * FROM dept WHERE 1=0;
    CREATE TABLE dept_30 AS SELECT * FROM dept WHERE 1=0;
    CREATE TABLE dept_40 AS SELECT * FROM dept WHERE 1=0;
    
    <Ȯ��>
    SELECT * FROM dept_10;
    SELECT * FROM dept_20;
    SELECT * FROM dept_30;
    SELECT * FROM dept_40;
    
    INSERT ALL
            INTO dept_10 VALUES(deptno, dname, loc)
            INTO dept_20 VALUES(deptno, dname, loc)
            INTO dept_30 VALUES(deptno, dname, loc)
            INTO dept_40 VALUES(deptno, dname, loc)
    SELECT deptno, dname, loc
    FROM dept; 
    -- 16�� �� ��(��) ���ԵǾ����ϴ�.
        
    ROLLBACK;

DROP TABLE dept_10;
DROP TABLE dept_20;
DROP TABLE dept_30;
DROP TABLE dept_40;
COMMIT;
---------------
2) ��. conditional insert all
Ư�� ���ǵ��� ����Ͽ� �� ���ǿ� �´� ����� ���ϴ� ���̺� ������ �����Ѵ�.
���������κ��� �ѹ��� �ϳ��� ���� ��ȯ�޾� when ... then ������ ������ üũ�� ��
���ǿ� �´� ���� ����� ���̺� insert ���� �����Ѵ�.

�����ġ�
	INSERT ALL
	WHEN ������1 THEN
	  INTO [���̺�1] VALUES (�÷�1,�÷�2,...)
	WHEN ������2 THEN
	  INTO [���̺�2] VALUES (�÷�1,�÷�2,...)
	........
	ELSE
	  INTO [���̺�3] VALUES (�÷�1,�÷�2,...)
	Subquery;
    
? subquery�κ��� �ѹ��� �ϳ��� ���� ���Ϲ޾� WHEN...THEN������ üũ�� ��,
    ���ǿ� �´� ���� ����� ���̺� insert ���� �����Ѵ�.
? VALUES ���� ������ DEFAULT ���� ����� �� �ִ�. ���� default���� �����Ǿ� ���� �ʴٸ�, NULL ���� ���Եȴ�.

����) emp_10, emp_20, emp_30, emp_40 ���̺� ����
    emp ������̺� -> 10 �μ��� -> 10_emp INSERT
    emp ������̺� -> 20 �μ��� -> 20_emp INSERT
    emp ������̺� -> 30 �μ��� -> 30_emp INSERT
    emp ������̺� -> 40 �μ��� -> 40_emp INSERT
    
���� �۾��� �� ���� �� ó���ϰڴ�.

    1) emp ���̺��� ������ �����ؼ� ���̺� 4�� ����
    CREATE TABLE emp_10 AS SELECT * FROM emp WHERE 1=0;
    CREATE TABLE emp_20 AS SELECT * FROM emp WHERE 1=0;
    CREATE TABLE emp_30 AS SELECT * FROM emp WHERE 1=0;
    CREATE TABLE emp_40 AS SELECT * FROM emp WHERE 1=0;

    2) conditional insert all ����Ͽ� ������ �߰��ϱ�
    INSERT ALL
     WHEN deptno = 10 THEN
        INTO emp_10 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
     WHEN deptno = 20 THEN
        INTO emp_20 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
     WHEN deptno = 30 THEN
        INTO emp_30 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
     ELSE
        INTO emp_40 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    SELECT * FROM emp;
    
    3) Ȯ��
    SELECT * FROM emp_10;
    SELECT * FROM emp_20;
    SELECT * FROM emp_30;
    SELECT * FROM emp_40;    

    3) ���ڵ� ����
+ ���ڵ� ���� ��� 2����(DML�� DELETE�� TRUNCATE)
-- emp_10 ���ڵ� ��� ����
    DELETE FROM emp_10; -- WHERE ������ ������ �� �ȿ� �����͸� ��� ����
    ROLLBACK;
    
    TRUNCATE TABLE emp_10; -- ��� ���ڵ� ���� + �ڵ� COMMIT / ��, �ѹ� �� �� ����
    TRUNCATE TABLE emp_20;
    TRUNCATE TABLE emp_30;
    TRUNCATE TABLE emp_40;
    
-------------
3) ��. conditional first insert 
Ư�� ���ǵ��� ����Ͽ� �� ���ǿ� �´� ��(row)���� ���ϴ� ���̺� ������ �����ϰ��� �� �� ���������,
conditional insert all ���� �޸� ù ��° when ������ ������ ������ ��� ������ when ���� �������� �ʴ´�.

���������κ��� �ѹ��� �ϳ��� ���� ��ȯ�޾� when ... then ������ ������ üũ�� ��
���ǿ� �´� ���� ����� ���̺� insert ���� �����Ѵ�.

���� ���� when ... then ���� ����Ͽ� ���� ������ ����� �� �ִ�.
��, ù ��° when ������ ������ �����ϸ� into ���� ������ �� ������ when ���� �������� �ʴ´�. 

�����ġ�
    INSERT FIRST
    WHEN ������1 THEN
      INTO [���̺�1] VALUES (�÷�1,�÷�2,...)
    WHEN ������2 THEN
      INTO [���̺�2] VALUES (�÷�1,�÷�2,...)
    ........
    ELSE
      INTO [���̺�3] VALUES (�÷�1,�÷�2,...)
    Subquery;

? conditional INSERT FIRST�� �������� ����Ͽ� ���ǿ� �´� ������ ���ϴ� ���̺� ������ �� �ִ�.
? ���� ���� WHEN...THEN���� ����Ͽ� ���� ���� ����� �����ϴ�. ��, ù ��° WHEN ������ ������ �����Ѵٸ�, INTO ���� ������ �� ������ WHEN ������ �� �̻� �������� �ʴ´�.
? subquery�κ��� �� ���� �ϳ��� ���� ���� �޾� when...then������ ������ üũ�� �� ���ǿ� �´� ���� ����� ���̺� insert�� �����Ѵ�.
? ������ ����� when ������ �����ϴ� ���� ���� ��� else���� ����Ͽ� into ���� ������ �� �ִ�. else���� ���� ��� ���ϵ� ���࿡ ���ؼ��� �ƹ��� �۾��� �߻����� �ʴ´�.

SELECT *
FROM emp
WHERE deptno = 10;
<���>
7782	CLARK	MANAGER	7839	81/06/09	2450		10
7839	KING	PRESIDENT		81/11/17	5000		10
[7934	MILLER	CLERK	7782	82/01/23	1300		10]

SELECT *
FROM emp
WHERE job = 'CLERK';
<���>
7369	SMITH	CLERK	7902	80/12/17	800		20
7900	JAMES	CLERK	7698	81/12/03	950		30
[7934	MILLER	CLERK	7782	82/01/23	1300	10]

-- MILLER�� �μ� 10 AND job CLERK

WHEN ������ �����ϸ� THEN�� �����Ű�� �Ʒ��� �ִ� ������ ���� X
MILLER�� �μ���ȣ�� job ������ ��� ����������, emp_10�� ���� emp_20���� ���� ����
    
    1) ������ �߰�
    INSERT FIRST
        WHEN deptno = 10 THEN
            INTO emp_10 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
        WHEN job = 'CLERK' THEN
            INTO emp_20 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
        ELSE
            INTO emp_40 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    SELECT * FROM emp;

    2) Ȯ��
    SELECT * FROM emp_10;
    SELECT * FROM emp_20;
    SELECT * FROM emp_30;
    SELECT * FROM emp_40;

    3) ���̺� ����
    DROP TABLE emp_10 PURGE;
    DROP TABLE emp_20 PURGE;
    DROP TABLE emp_30 PURGE;
    DROP TABLE emp_40 PURGE;

-----------------------
4) ��. pivoting insert
- ���� ���� into ���� ����� �� ������, into �� �ڿ� ���� ���̺��� ��� �����ؾ� �Ѵ�. 
�����ġ�
    INSERT ALL
    WHEN ������1 THEN
      INTO [���̺�1] VALUES (�÷�1,�÷�2,...)
      INTO [���̺�1] VALUES (�÷�1,�÷�2,...)
      ..........
    Subquery;

? ���� ���� INTO ���� ����� �� ������, INTO �� �ڿ� ���� ���̺��� ��� �����Ͽ��� �Ѵ�.
? �ַ� ���� ���� �ý������κ��� �����͸� �޾� �۾��ϴ� dataware house�� �����ϴ�. ����ȭ ���� ���� data source���̳� �ٸ� format���� ����� data source���� Oracle�� ������ DB���� ����ϱ⿡ ������ ���·� ��ȯ�Ѵ�.
? ����ȭ ���� ���� �����͸� oracle�� �����ϴ� relational�� ���·� ���̺��� �����ϴ� �۾��� pivoting�̶�� �Ѵ�.

    1) ���̺� ����
    CREATE TABLE tbl_sales(
        employee_id       NUMBER(6),
        week_id            NUMBER(2),
        sales_mon          NUMBER(8, 2),
        sales_tue          NUMBER(8, 2),
        sales_wed          NUMBER(8, 2),
        sales_thu          NUMBER(8, 2),
        sales_fri          NUMBER(8, 2)
    );
    -- Table TBL_SALES��(��) �����Ǿ����ϴ�.
    
    2) ������ �߰�
    INSERT INTO tbl_sales VALUES(1101,4,100,150,80,60,120);
    INSERT INTO tbl_sales VALUES(1102,5,300,300,230,120,150);
    COMMIT;
    
    3) Ȯ��
    SELECT *
    FROM tbl_sales;
    
    EMPLOYEE_ID    WEEK_ID  SALES_MON  SALES_TUE  SALES_WED  SALES_THU  SALES_FRI
    ----------- ---------- ---------- ---------- ---------- ---------- ----------
       1101          4        100        150         80         60        120
       1102          5        300        300        230        120        150

    
    4) �� �ٸ� ���̺� ����
    CREATE TABLE tbl_sales_data(
    employee_id        NUMBER(6),
    week_id            NUMBER(2),
    sales              NUMBER(8, 2)
    );
    -- Table TBL_SALES_DATA��(��) �����Ǿ����ϴ�.

    5) �Ʒ��� ���� �������� ������ �߰� -> �ǹ�
    
    EMPLOYEE_ID    WEEK_ID      SALES
    ----------- ---------- ----------
       1101          4        100
       1102          5        300
       1101          4        150
       1102          5        300
       1101          4         80
       1102          5        230
       1101          4         60
       1102          5        120
       1101          4        120
       1102          5        150
    
     -- EMPLOYEE_ID    WEEK_ID  SALES_MON  SALES_TUE  SALES_WED  SALES_THU  SALES_FRI
     -- 1101          4        100        150         80         60        120
    INSERT ALL
      INTO tbl_sales_data VALUES(employee_id, week_id, sales_mon) -- ��
      INTO tbl_sales_data VALUES(employee_id, week_id, sales_tue) -- ȭ
      INTO tbl_sales_data VALUES(employee_id, week_id, sales_wed) -- ��
      INTO tbl_sales_data VALUES(employee_id, week_id, sales_thu) -- ��
      INTO tbl_sales_data VALUES(employee_id, week_id, sales_fri) -- ��
    SELECT employee_id, week_id, sales_mon, sales_tue, sales_wed, sales_thu, sales_fri
    FROM tbl_sales;

    Ȯ��)
    SELECT *
    FROM tbl_sales_data;

-----
����1) insa ���̺��� num, name �÷��� �����ؼ� tbl_score ���̺� ����
    �̹� �����ϴ� ���̺��� ����ؼ� ���ο� ���̺��� ����
    ����1) num <= 1005 �ڷ�(���ڵ�)�� ����
    
    CREATE TABLE tbl_score
    AS(
        SELECT num, name
        FROM insa
        WHERE num <= 1005
    );
    
    SELECT *
    FROM tbl_score;
    
--    
����2) tbl_score ���̺� kor, eng, mat, tot, avg, grade, rank �÷� �߰�
                        k,e,m�� �⺻�� 0, grade �ѹ���
    ALTER TABLE tbl_score
    ADD(kor NUMBER(3) DEFAULT 0
        , eng NUMBER(3) DEFAULT 0
        , mat NUMBER(3) DEFAULT 0
        , tot NUMBER(3)
        , avg NUMBER(5, 2)
        , grade CHAR(1 char)
        , rank NUMBER(3)
    ); 
    -- Table TBL_SCORE��(��) ����Ǿ����ϴ�
    
    DESC tbl_score;

�̸�    ��?       ����           
----- -------- ------------ 
NUM   NOT NULL NUMBER(5)    
NAME  NOT NULL VARCHAR2(20) 
KOR            NUMBER(3)    
ENG            NUMBER(3)    
MAT            NUMBER(3)    
TOT            NUMBER(3)    
AVG            NUMBER(5,2)  
GRADE          CHAR(1 CHAR) 
RANK           NUMBER(3) 

--
����3) 1001 ~ 1005, num, name 
    kor, eng, mat ������ ������ ����(0~100)�� �߻����Ѽ� ����

    UPDATE tbl_score
    SET kor = TRUNC(dbms_random.value(0, 101))
        , eng = TRUNC(dbms_random.value(0, 101))
        , mat = TRUNC(dbms_random.value(0, 101));
        
    COMMIT;

--
����4) tbl_score ���̺� tot, avg ����ؼ� ����
    UPDATE tbl_score
    SET tot = kor + eng + mat
        , avg = (kor + eng + mat) / 3;
    
    COMMIT;

--
����5) �Ʒ��� ���� grade �����ϱ�
����� 90 �̻� A
        80  B
        70  C
        60  D
            F

���� �ۼ��� ����)
    UPDATE tbl_score
    SET grade = 'A'
    WHERE avg BETWEEN 90 AND 100;
    
    UPDATE tbl_score
    SET grade = 'B'
    WHERE avg BETWEEN 80 AND 89;
    
    UPDATE tbl_score
    SET grade = 'C'
    WHERE avg BETWEEN 70 AND 79;
    
    UPDATE tbl_score
    SET grade = 'D'
    WHERE avg BETWEEN 60 AND 69;
    
    UPDATE tbl_score
    SET grade = 'F'
    WHERE avg BETWEEN 0 AND 59;

--
�ٸ� ��� ����)
    UPDATE tbl_score
    SET grade = CASE
                    WHEN avg BETWEEN 90 AND 100 THEN 'A' -- avg >= 90 �̷��� �൵ ��
                    WHEN avg BETWEEN 80 AND 89 THEN 'B' -- avg >= 80
                    WHEN avg BETWEEN 70 AND 79 THEN 'C' -- avg >= 70
                    WHEN avg BETWEEN 60 AND 69 THEN 'D' -- avg >= 60
                    ELSE 'F'
                END;
            
--
����� Ǯ��)
    UPDATE tbl_score
    SET grade - DECODE(TRUNC(avg/10), 10, 'A', 9, 'A', 8, 'B', 7, 'C', 6, 'D', 'F');
    
    SELECT *
    FROM tbl_score;
    
    COMMIT;

---
����6) rank ó���ϱ�

    Ǯ��1)
    UPDATE tbl_score ts
    SET rank = (SELECT rn
                FROM(
                    SELECT avg, RANK() OVER(ORDER BY avg DESC) rn
                    FROM tbl_score
                )t
                WHERE ts.avg = t. avg);

    Ǯ��2)
    UPDATE tbl_score ts
    SET rank = (SELECT COUNT(*) + 1 FROM tbl_score WHERE tot > ts.tot);

COMMIT;

ROLLBACK;

--
����7) ��� �л��� ���� ������ 5�� ����  -> PL/SQL ��� ����
UPDATE tbl_score
SET kor = CASE
             WHEN avg BETWEEN 0 AND 95 THEN kor + 5
             ELSE 100
          END;

    SELECT *
    FROM tbl_score;
    1001	ȫ�浿	37	62	72	171	57	    F	2
    1002	�̼���	69	29	33	131	43.67	F	4
    1003	�̼���	86	2	40	128	42.67	F	5
    1004	������	61	17	88	166	55.33	F	3
    1005	�Ѽ���	95	100	63	258	86	    B	1

-- 
����8) 1001�� �л��� ����, ���� ������ 1005�� �л��� ����, ���� ������ ����
UPDATE tbl_score
SET kor = ( SELECT kor FROM tbl_score WHERE num = 1005 )
    , eng = ( SELECT eng FROM tbl_score WHERE num = 1005)
WHERE num = 1001;

COMMIT;

-- �Ʒ� ���� �ܿ��~
UPDATE tbl_score
SET (kor, eng) = (SELECT kor, eng FROM tbl_score WHERE num = 1005)
WHERE num = 1001;

--
����9) tbl_score ���̺��� ���л��鸸 ���� ���� -- �ָ��� �غ���
        (JOIN �ؾ� ����)
SELECT *
FROM tbl_scroe;

SELECT *
FROM insa;

--
[����޷�]
SELECT   
        -- TO_CHAR(dates, 'D') �� ���� ��(1) ~ ��(7)�� ���� �ش��ϴ� �÷��� ���� �ֱ�
          NVL( MIN( DECODE( TO_CHAR(dates, 'D'), 1, TO_CHAR(dates, 'DD') ) ), ' ') ��
         , NVL( MIN(  DECODE( TO_CHAR(dates, 'D'), 2, TO_CHAR(dates, 'DD') ) ), ' ') ��
         , NVL( MIN(  DECODE( TO_CHAR(dates, 'D'), 3, TO_CHAR(dates, 'DD') ) ), ' ') ȭ
         , NVL( MIN(  DECODE( TO_CHAR(dates, 'D'), 4, TO_CHAR(dates, 'DD') ) ), ' ') ��
         , NVL( MIN(  DECODE( TO_CHAR(dates, 'D'), 5, TO_CHAR(dates, 'DD') ) ), ' ') ��
         , NVL( MIN(  DECODE( TO_CHAR(dates, 'D'), 6, TO_CHAR(dates, 'DD') ) ), ' ') ��
         , NVL( MIN(  DECODE( TO_CHAR(dates, 'D'), 7, TO_CHAR(dates, 'DD') ) ), ' ') ��         
FROM (
        SELECT TO_DATE( :yyyymm, 'YYYYMM') + (LEVEL -1) dates -- 4�� 1�� + 30-1(29) �̴ϱ� 4�� 30���� �ȴ�.
        FROM dual
        CONNECT BY LEVEL <= EXTRACT( DAY FROM LAST_DAY( TO_DATE( :yyyymm , 'YYYYMM') ) )
      ) t      
GROUP BY  DECODE( TO_CHAR(dates, 'D'), 1, TO_CHAR( dates, 'IW') +1,  TO_CHAR( dates, 'IW')   )  -- �Ͽ���(1)�̸� ������ ǥ��.
ORDER BY  DECODE( TO_CHAR(dates, 'D'), 1, TO_CHAR( dates, 'IW') +1,  TO_CHAR( dates, 'IW')   );


-- ORA-01788: CONNECT BY clause required in this query block
-- �ؼ�:  CONNECT BY ���� �ʿ��ϴ�.


SELECT TO_DATE( :yyyymm, 'YYYYMM') + (LEVEL -1) dates -- 4�� 1�� + 30-1(29) �̴ϱ� 4�� 30���� �ȴ�.
FROM dual
CONNECT BY LEVEL <= EXTRACT( DAY FROM LAST_DAY( TO_DATE( :yyyymm , 'YYYYMM') ) );

SELECT TO_DATE( '202203', 'YYYYMM') + (LEVEL -1) -- 4�� 1�� + 30-1(29) �̴ϱ� 4�� 30���� �ȴ�.
FROM dual
CONNECT BY LEVEL <= 31;
-- CONNECT BY LEVEL <= EXTRACT( DAY FROM LAST_DAY( TO_DATE( :yyyymm , 'YYYYMM') ) );


SELECT TO_DATE( :yyyymm, 'YYYYMM') + 29 dates -- 4�� 1�� + 30-1(29) �̴ϱ� 4�� 30���� �ȴ�.
    , TO_CHAR(TO_DATE( :yyyymm, 'YYYYMM') + 29, 'DD') -- �����
    , DECODE( TO_CHAR(TO_DATE( :yyyymm, 'YYYYMM') + 29, 'D'), 1, TO_CHAR( TO_DATE( :yyyymm, 'YYYYMM') + 29, 'IW') +1,  TO_CHAR( TO_DATE( :yyyymm, 'YYYYMM') + 29, 'IW')   ) 
    DECODE( TO_CHAR(dates, 'D'), 1, TO_CHAR( dates, 'IW') +1,  TO_CHAR( dates, 'IW')
FROM dual;

SELECT *
    FROM (
        SELECT EXTRACT (MONTH FROM hiredate) mm
        FROM emp
    )
    PIVOT( COUNT(*) FOR mm IN(1,2,3,4,5,6,7,8,9,10,11,12) );


