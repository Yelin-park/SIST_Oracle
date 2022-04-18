-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]
---- �������� ----

1.  truncate / delete / drop ���ؼ� �����ϼ���

truncate�� ���̺� �ȿ� �ִ� �����͸� �������ܰ� ���ÿ� Ŀ�� �۾��� ���ش�. �� �ѹ��� �����ʴ´�. DML �̴�.
delete�� ���̺� �ȿ� �ִ� �����͸� �����ϴ� ���̴�. Ŀ�� �Ǵ� �ѹ� �۾��� �� ����� �Ѵ�. DML �̴�.
drop�� ���̺� �Ǵ� ������ ������ �� ����ϴ� DDL �̴�.

2.  insert �� ���� �� ������ ���� ������ �߻��ߴٸ� ������ ���� �����ϼ���
  ��. 00947. 00000 -  "not enough values"
  - �÷� ���� ��� ���� ���� �ʾƼ� �߻�
  ��. ORA-00001: unique constraint (SCOTT.SYS_C007770) violated  
  - ����Ű�� ������ �÷��� �ߺ��� ���� �־ �߻�
  ��. ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found
  - ���Ἲ �������� ����
    deptno ���� 10 ~ 40������ �ִµ� 50�� �������� �Ѵٸ� �߻�
   
3. ���������� ����ؼ� ���̺� ����
  ��. deptno, dname, empno, ename, sal+nvl(comm,0) pay, grade �÷��� ���� ���ο� ���̺� ����  
  ��. ���̺�� : tbl_empdeptgrade  
  
  CREATE TABLE tbl_empdeptgrade
  AS( SELECT e.deptno, dname, empno, ename, sal+nvl(comm,0) pay, grade FROM emp e, dept d, salgrade s
        WHERE e.deptno = d.deptno AND sal+nvl(comm,0) BETWEEN losal AND hisal);

SELECT *
FROM tbl_empdeptgrade;

4-1. insa ���̺��� num, name �����ͼ� tbl_score ���̺� ����

DROP TABLE tbl_score;

CREATE TABLE tbl_score
AS( SELECT num, name FROM insa);

SELECT *
FROM tbl_score;

4-2. kor, eng, mat, tot, avg , grade, rank �÷� �߰�

ALTER TABLE tbl_score
ADD(kor NUMBER(3)
    , eng NUMBER(3)
    , mat NUMBER(3)
    , tot NUMBER(3)
    , avg NUMBER(5,2)
    , grade CHAR
    , rank NUMBER(3)
);

DESC tbl_score;

4-3. �� �л����� kor,eng,mat ���� 0~100 �����ϰ� ä���ֱ�.

UPDATE tbl_score
SET kor = TRUNC(dbms_random.value(0, 101))
    , eng = TRUNC(dbms_random.value(0, 101))
    , mat = TRUNC(dbms_random.value(0, 101));

SELECT *
FROM tbl_score;

4-4. ����, ���, ���, ��� ����
    ����)
     ����� ��� ������ 40���̻��̰�, ��� 60 �̻��̸� "�հ�"
           ��� 60 �̻��̶� �� �����̶� 40�� �̸��̶��  "����"
           �׿ܴ� "���հ�" �̶�� ����.
           
UPDATE tbl_score
SET tot = kor + eng + mat;

UPDATE tbl_score
SET avg = tot / 3;

COMMIT;

UPDATE tbl_score
SET grade = CASE
                WHEN (kor >= 40 AND eng >= 40 AND mat >= 40) AND avg >= 60 THEN '�հ�'
                WHEN (kor < 40 OR eng < 40 OR mat < 40) AND avg >= 60 THEN '����'
                ELSE '���հ�'
             END;

ALTER TABLE tbl_score
MODIFY grade VARCHAR2(15);

SELECT *
FROM tbl_score;
             
5.  emp ���̺��� ������ Ȯ���ϰ�, ���������� Ȯ���ϰ�, ������ ��� ������ �߰��ϴ� INSERT ���� �ۼ��ϼ���.
   ��. ����Ȯ�� ���� 
   DESC emp;
   
   �̸�       ��?       ����           
-------- -------- ------------ 
EMPNO    NOT NULL NUMBER(4)    
ENAME             VARCHAR2(10) 
JOB               VARCHAR2(9)  
MGR               NUMBER(4)    
HIREDATE          DATE         
SAL               NUMBER(7,2)  
COMM              NUMBER(7,2)  
DEPTNO            NUMBER(2)  

   ��. �������� Ȯ�� ����
   
   SELECT *
   FROM user_constraints
   WHERE REGEXP_LIKE(table_name, 'emp', 'i');
   
   ��. INSERT ����
   
   INSERT INTO emp VALUES(8000, 'YELIN', 'ANALYST', 7566, '2022.04.18', 2500, 0, 20);

SELECT *
FROM emp
ORDER BY empno;

COMMIT;

6-1. emp ���̺��� ������ �����ؼ� ���ο� tbl_emp10, tbl_emp20, tbl_emp30, tbl_emp40 ���̺��� �����ϼ���. 

CREATE TABLE tbl_emp10
AS(SELECT * FROM emp WHERE 1 = 0);

CREATE TABLE tbl_emp20
AS(SELECT * FROM emp WHERE 1 = 0);

CREATE TABLE tbl_emp30
AS(SELECT * FROM emp WHERE 1 = 0);

CREATE TABLE tbl_emp40
AS(SELECT * FROM emp WHERE 1 = 0);


SELECT *
FROM tbl_emp10;

6-2. emp ���̺��� �� �μ��� �ش��ϴ� ���������  ������ ������ ���̺� INSERT �ϴ� ������ �ۼ��ϼ���.

INSERT ALL
    WHEN deptno = 10 THEN
        INTO tbl_emp10 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 20 THEN
        INTO tbl_emp20 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 30 THEN
        INTO tbl_emp30 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
    ELSE
        INTO tbl_emp40 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT * FROM emp;

COMMIT;

7. ������ �ִ� ���� INSERT ������  INSERT ALL �� INSERT FIRST ���� ���� �������� �����ϼ���.
INSERT ALL �ش��ϴ� �������� ������ ������ �ϴ� ���̰�
INSERT FIRST�� �ش��ϴ� ������ ������ ���� �������� �ִ� ������ �����Ѵ�.
---------------------------------------------------------------------------------------
���� �� ����) ���л��鸸..

�ٸ� ��� Ǯ��)
UPDATE tbl_score
SET eng = eng + 5
WHERE num = (
            SELECT ts.num
            FROM tbl_score ts, (
                SELECT num, DECODE(MOD(SUBSTR(ssn, -1, 1), 2), 0, '����') gender
                FROM insa ) i
        WHERE ts.num = i.num AND gender IS NOT NULL );
        
--
����� Ǯ��) ANY ������ ���
UPDATE tbl_score
SET eng = eng + 5
--           1003 , 1005
WHERE num = ANY (
    SELECT num 
    FROM insa
    WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 0 AND num <= 1005
);

---------------------------------------------------------------------------------------
[ ���ο� ���� ����]
1. ����޷� �׸���

-- Ȯ���ϴ� ����
SELECT dates
    , TO_CHAR(dates, 'D') D -- 1(��) 2(��) ~ 7(��)
    , TO_CHAR(dates, 'DY') DY
    , TO_CHAR(dates, 'DAY') DAY
    -- �Ͽ����� ������(�� ��)�� ó��
    , TO_CHAR(dates, 'IW') IW
    , CASE
        WHEN TO_CHAR(dates, 'D') = 1 THEN TO_CHAR(dates, 'IW') + 1
        ELSE TO_NUMBER(TO_CHAR(dates, 'IW'))
      END ��
    , TO_CHAR(dates, 'WW') WW
    , TO_CHAR(dates, 'W') W -- �ش�Ǵ� ���� 1�� ~ 7�� ���ֶ�� �ν� 7�Ϸ� �ڸ�
FROM(
    SELECT TO_DATE(:yyyymm, 'YYYYMM') + LEVEL - 1 dates
    FROM dual
    CONNECT BY LEVEL <= EXTRACT(DAY FROM LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')))
) t;


-- �޷� �׸��� ����
SELECT
    -- �Ͽ����̶�� ��¥(DD)�� ��� �������� NULL�� ��ڴ�.
    NVL( MIN( DECODE(TO_CHAR(dates, 'D'), 1, TO_CHAR(dates, 'DD') ) ), ' ') ��
    , NVL(MIN( DECODE(TO_CHAR(dates, 'D'), 2, TO_CHAR(dates, 'DD') ) ), ' ') ��
    , NVL(MIN( DECODE(TO_CHAR(dates, 'D'), 3, TO_CHAR(dates, 'DD') ) ), ' ') ȭ
    , NVL(MIN( DECODE(TO_CHAR(dates, 'D'), 4, TO_CHAR(dates, 'DD') ) ), ' ') ��
    , NVL(MIN( DECODE(TO_CHAR(dates, 'D'), 5, TO_CHAR(dates, 'DD') ) ), ' ') ��
    , NVL(MIN( DECODE(TO_CHAR(dates, 'D'), 6, TO_CHAR(dates, 'DD') ) ), ' ') ��
    , NVL(MIN( DECODE(TO_CHAR(dates, 'D'), 7, TO_CHAR(dates, 'DD') ) ), ' ') ��
FROM(
    SELECT TO_DATE(:yyyymm, 'YYYYMM') + LEVEL - 1 dates
    FROM dual
    CONNECT BY LEVEL <= EXTRACT(DAY FROM LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')))
) t
GROUP BY CASE
        -- IW ���� 50�ְ� �����鼭 �Ͽ���(1)�̶�� 1�� �ְ�, �Ͽ���(1)�� �ƴ϶�� 0�� �ְڴ�.
        WHEN TO_CHAR(dates, 'MM') = 1 AND TO_CHAR(dates, 'D') = 1 AND TO_CHAR(dates, 'IW') > 50 THEN 1
        WHEN TO_CHAR(dates, 'MM') = 1 AND TO_CHAR(dates, 'D') != 1 AND TO_CHAR(dates, 'IW') > 50 THEN 0
        WHEN TO_CHAR(dates, 'D') = 1 THEN TO_CHAR(dates, 'IW') + 1
        ELSE TO_NUMBER(TO_CHAR(dates, 'IW'))
      END
ORDER BY CASE
        WHEN TO_CHAR(dates, 'MM') = 1 AND TO_CHAR(dates, 'D') = 1 AND TO_CHAR(dates, 'IW') > 50 THEN 1
        WHEN TO_CHAR(dates, 'MM') = 1 AND TO_CHAR(dates, 'D') != 1 AND TO_CHAR(dates, 'IW') > 50 THEN 0
        WHEN TO_CHAR(dates, 'D') = 1 THEN TO_CHAR(dates, 'IW') + 1
        ELSE TO_NUMBER(TO_CHAR(dates, 'IW'))
      END
;

----
�ٸ� �л��� Ǭ��)
SELECT
    -- �Ͽ����̶�� ��¥(DD)�� ��� �������� NULL�� ��ڴ�.
    NVL( MIN( DECODE(TO_CHAR(dates, 'D'), 1, TO_CHAR(dates, 'DD') ) ), ' ') ��
    , NVL(MIN( DECODE(TO_CHAR(dates, 'D'), 2, TO_CHAR(dates, 'DD') ) ), ' ') ��
    , NVL(MIN( DECODE(TO_CHAR(dates, 'D'), 3, TO_CHAR(dates, 'DD') ) ), ' ') ȭ
    , NVL(MIN( DECODE(TO_CHAR(dates, 'D'), 4, TO_CHAR(dates, 'DD') ) ), ' ') ��
    , NVL(MIN( DECODE(TO_CHAR(dates, 'D'), 5, TO_CHAR(dates, 'DD') ) ), ' ') ��
    , NVL(MIN( DECODE(TO_CHAR(dates, 'D'), 6, TO_CHAR(dates, 'DD') ) ), ' ') ��
    , NVL(MIN( DECODE(TO_CHAR(dates, 'D'), 7, TO_CHAR(dates, 'DD') ) ), ' ') ��
FROM(
    SELECT TO_DATE(:yyyymm, 'YYYYMM') + LEVEL - 1 dates
    FROM dual
    CONNECT BY LEVEL <= EXTRACT(DAY FROM LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')))
) t
GROUP BY CASE
            WHEN TO_CHAR( dates, 'D' ) < TO_CHAR( TO_DATE( :yyyymm,'YYYYMM' ), 'D' ) THEN TO_CHAR( dates, 'W' ) + 1
            ELSE TO_NUMBER( TO_CHAR( dates, 'W' ) )
        END
ORDER BY CASE
            WHEN TO_CHAR( dates, 'D' ) < TO_CHAR( TO_DATE( :yyyymm,'YYYYMM' ), 'D' ) THEN TO_CHAR( dates, 'W' ) + 1
            ELSE TO_NUMBER( TO_CHAR( dates, 'W' ) )
        END;

----
2. [LEVEL �ǻ��÷�]
    [����] ���̺��� ��(row)�� LEVEL�� ����Ű�� �Ϸù�ȣ ���� 
    
    [LEVEL�� ���õ� 3���� �Լ�]
    ��. CONNECT_BY_ISLEAF  �� �̻� LEAF �����Ͱ� ������ 1, ������ 0�� ��ȯ (�ڽ�(����) ������ ������ ���� ������ 0, ������ 1)
    ��. CONNECT_BY_ISCYCLE  root �������̸� 1, �ƴϸ� 0�� ��ȯ 
    ��. CONNECT_BY_ROOT  �� �������� root���� LEVEL ���� ��ȯ 
    
    [������ ����(hierarchical query)]
    ��. ������ ���ǹ��� ���ι��̳� �信���� ����� �� ������,
    ��. CONNECT BY �������� �������� ���� ������ �� ����.
    
   �����ġ� 
	SELECT 	[LEVEL] {*,�÷��� [alias],...}
	FROM	���̺��
	WHERE	����
	START WITH ����
	CONNECT BY [PRIOR �÷�1��  �񱳿�����  �÷�2��]
		�Ǵ� 
		   [�÷�1�� �񱳿����� PRIOR �÷�2��]
           
- START WITH �� �������� ��� ������ ǥ���ϱ� ���� �ֻ��� �� 
- CONNECT BY �� ���������� �����͸� �����ϴ� �÷� 
- PRIOR ������ CONNECT BY�� PRIOR �����ڿ� �Բ� ����Ͽ� �θ� ���� Ȯ���� �� �ִ�.
    PRIOR �������� ��ġ�� ���� top-down ������� bottom up ��������� �����Ѵ�.
    PRIOR �ڽ�Ű = �θ�Ű(top-down ���)
- WHERE �� where ���� JOIN�� �����ϰ� ���� ��� CONNECT BY ���� ó���ϱ� ���� JOIN ���Ǻθ� �����Ͽ� ó���ϰ�,
        JOIN�� �����ϰ� ���� ���� ��� CONNECT BY ���� ó���� �Ŀ� WHERE ���� ������ ó���Ѵ�. 
- LEVEL ������ ���ǹ����� �˻��� ����� ���� �������� ���� ��ȣ ǥ��, ��Ʈ ���� 1, ���� ������ �� ���� 1�� ���� 
         
�׽�Ʈ)

    SELECT empno,ename,mgr,deptno
    FROM emp;

--
<������ ����>
    SELECT empno, ename, mgr, LEVEL
    FROM emp
    -- START WITH emp = 7839 -- �̷��� king�� �����ȣ�� �־ �ǰ�,
    START WITH mgr IS NULL -- ����� ���� ��� ��, mgr�� null�� ���
    CONNECT BY PRIOR empno = mgr; -- ���� ���踦 ��Ÿ���� �÷��� �����������
    
    --
    SELECT LPAD(' ', 3*LEVEL-3) || ename 
            , empno, mgr, LEVEL
            , SYS_CONNECT_BY_PATH(ename, '/') path
            , CONNECT_BY_ROOT ename ROOT_NODE
            , CONNECT_BY_ISLEAF 
    FROM emp
    START WITH mgr IS NULL
    CONNECT BY PRIOR empno = mgr; 
    
--
������ ���Ǵ� ��� ����ϴ°�?
  > ����� �� �� �ִ� �Խ��� ��, �亯�� �Խ����� ������ �� ������ ���Ǹ� ����ϸ� �ȴ�.
  �Խñ� �۹�ȣ empno �θ�Խñ۹�ȣ mgr
  ��� X -> why? ���������Ǵ� DBMS ����Ŭ������ ����� �� �ִ�.
  
��)
    create table tbl_level(
        deptno number(3) not null primary key,
        dname varchar2(30) not null,
        college number(3),
        loc varchar2(10)
    );
    
    ALTER TABLE tbl_level
    MODIFY dname VARCHAR(30);
    
    DESC tbl_level;
    
    insert into tbl_level ( deptno, dname, college, loc ) values ( 10,'��������', null , null);
    insert into tbl_level ( deptno, dname, college, loc ) values ( 100,'�����̵���к�',10, null );
    insert into tbl_level ( deptno, dname, college, loc ) values ( 101,'��ǻ�Ͱ��а�',100,'1ȣ��');
    insert into tbl_level ( deptno, dname, college, loc ) values ( 102,'��Ƽ�̵���а�',100,'2ȣ��');
    insert into tbl_level ( deptno, dname, college, loc ) values ( 200,'��īƮ�δн��к�', 10,null);
    insert into tbl_level ( deptno, dname, college, loc ) values ( 201,'���ڰ��а�',200,'3ȣ��');
    insert into tbl_level ( deptno, dname, college, loc ) values ( 202,'�����а�',200,'4ȣ��');
    
    SELECT *
    FROM tbl_level;
    
    COMMIT;
    
    ROLLBACK;

--
    SELECT LPAD(' ', (LEVEL-1)*3) || dname ������
            , deptno, college, LEVEL
    FROM tbl_level
    START WITH deptno = 10 -- deptno IS NULL
    CONNECT BY PRIOR deptno = college;

[������������ ���� ���� ���]
    -- �����̵���к� ������ ����
    SELECT LPAD(' ', (LEVEL-1)*3) || dname ������
            , deptno, college, LEVEL
    FROM tbl_level
    WHERE dname != '�����̵���к�'
    START WITH deptno = 10 -- deptno IS NULL
    CONNECT BY PRIOR deptno = college;

    -- �����̵���к� + ����(�ڽ�) ������ ����
    SELECT LPAD(' ', (LEVEL-1)*3) || dname ������
            , deptno, college, LEVEL
    FROM tbl_level
    -- WHERE dname != '�����̵���к�'
    START WITH deptno = 10 -- deptno IS NULL
    CONNECT BY PRIOR deptno = college AND dname != '�����̵���к�';

---------------------------------
3. [ MERGE(����, ����) ]
 ��. ������ ���� �� ���� ���̺��� ���Ͽ� �ϳ��� ���̺�� ��ġ�� ���� ������ �����̴�.
 
 ��. UNION, UNION ALL ���� ������?
    A U B ������ ������ A <- B ��, �ϳ��� ���̺�� �������� ��
 
 ��. ����ϴ� ��?
    �Ϸ翡 �����Ǿ� �߻��ϴ� �����͸� �ϳ��� ���̺� ������ ��� �뷮�� �����ͷ� ���� ���ǹ��� ������ ���ϵȴ�.
    �̷� ���, �������� ������ ���̺��� �����ϴٰ� �⸻�� ���� �м��� ���� �ϳ��� ���̺�� ��ĥ �� merge ���� ����ϸ� ���ϴ�.
 
 ��. merge�ϰ��� �ϴ� �ҽ� ���̺��� ���� �о� ŸŶ ���̺� ��ġ�Ǵ� ���� �����ϸ� ���ο� ������ UPDATE�� �����ϰ�,
    ���� ��ġ�Ǵ� ���� ���� ��� ���ο� ���� ŸŶ ���̺��� INSERT�� �����Ѵ�. 
    
    A ����        B ����
    X 3          Y 5
                 X 10

    A ����   <-    B ����
    X 13(UPDATE)  Y 5
    Y 5(INSERT)   X 10
    
 ��. merge ������ where ���� ����� �� ������ ��� on�� ���ȴ�.
    ���� when matched then ���� when not matched then ������ ���̺�� ��� alias�� ����Ѵ�.

 ��.
    �����ġ�
    MERGE [hint] INTO [schema.] {table ? view} [t_alias]
      USING {{[schema.] {table ? view}} ?
            subquery} [t_alias]
      ON (condition-����) [merge_update_clause-��������] [merge_insert_clause] [error_logging_clause];

    ��merge_update_clause ���ġ�
       WHEN MATCHED THEN UPDATE SET {column = {expr ? DEFAULT},...}
         [where_clause] [DELETE where_clause]
    
    ��merge_insert_clause ���ġ�
       WHEN NOT MATCHED THEN INSERT [(column,...)]
        VALUES ({expr,... ? DEFAULT}) [where_clause]
       
    ��where_clause ���ġ�
       WHERE condition
    
    ��error_logging_clause ���ġ�
       LOG ERROR [INTO [schema.] table] [(simple_expression)]
         [REJECT LIMIT {integer ? UNLIMITED}]

 ��. �׽�Ʈ
    CREATE TABLE tbl_emp(
        id NUMBER PRIMARY KEY
        , name VARCHAR2(10) NOT NULL
        , salary NUMBER
        , bonus NUMBER DEFAULT 100
    );
    -- Table TBL_EMP��(��) �����Ǿ����ϴ�.
    
    INSERT INTO tbl_emp(id, name, salary) VALUES(1001, 'jijoe', 150);
    INSERT INTO tbl_emp(id, name, salary) VALUES(1002, 'cho', 130);
    INSERT INTO tbl_emp(id, name, salary) VALUES(1003, 'kim', 140);
    -- 1 �� ��(��) ���ԵǾ����ϴ�.
    -- 1 �� ��(��) ���ԵǾ����ϴ�.
    -- 1 �� ��(��) ���ԵǾ����ϴ�.
    
    SELECT *
    FROM tbl_emp;
    
    COMMIT;
    
    CREATE TABLE tbl_bonus(
        id NUMBER
        , bonus NUMBER DEFAULT 100
    );
    -- Table TBL_BONUS��(��) �����Ǿ����ϴ�.
    
    INSERT INTO tbl_bonus(id) (SELECT id FROM tbl_emp);
    -- 3�� �� ��(��) ���ԵǾ����ϴ�.
    
    COMMIT;
    
    INSERT INTO tbl_bonus VALUES ( 1004, 50);
    
    SELECT *
    FROM tbl_bonus;
    <��ȸ ���>
    1001	100
    1002	100
    1003	100
    1004	50
    
    SELECT *
    FROM tbl_emp;
    <��ȸ ���>
    1001	jijoe	150	100
    1002	cho	    130	100
    1003	kim	    140	100
    
    -- ���� tbl_emp -> tbl_bonus
    MERGE INTO tbl_bonus b
    USING (SELECT id, salary FROM tbl_emp) e
    ON(b.id = e.id)
    WHEN MATCHED THEN -- UPDATE
        UPDATE SET b.bonus = b.bonus + e.salary * 0.01
    WHEN NOT MATCHED THEN -- INSERT
        INSERT (b.id, b.bonus) VALUES (e.id, e.salary * 0.01);
    -- 3�� �� ��(��) ���յǾ����ϴ�.
    
    SELECT *
    FROM tbl_bonus;
    <��ȸ ���>
    1001	101.5
    1002	101.3
    1003	101.4
    1004	50
    
--
���� ����1)

CREATE TABLE tbl_merge1
(
   id number primary key
   , name varchar2(20)
   , pay number
   , sudang number
);

CREATE TABLE tbl_merge2
(
   id number primary key 
   , sudang number
);

INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (1, 'a', 100, 10);
INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (2, 'b', 150, 20);
INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (3, 'c', 130, 0);
    
INSERT INTO tbl_merge2 (id, sudang) VALUES (2,5);
INSERT INTO tbl_merge2 (id, sudang) VALUES (3,10);
INSERT INTO tbl_merge2 (id, sudang) VALUES (4,20);

COMMIT;
        
SELECT *
FROM tbl_merge1;
<��ȸ ���>
id name pay sudang
1	a	100	10
2	b	150	20
3	c	130	0

SELECT *
FROM tbl_merge2;
<��ȸ ��� + (����� ��)>
id sudang
2	5(25)
3	10
4	20
(1) (10)

merge1 -> merge2 ����

MERGE INTO tbl_merge2 m2
USING(SELECT id, sudang FROM tbl_merge1) m1
ON(m2.id = m1.id)
WHEN MATCHED THEN
    UPDATE SET m2.sudang = m2.sudang + m1.sudang
WHEN NOT MATCHED THEN
    INSERT (m2.id, m2.sudang) VALUES (m1.id, m1.sudang);
-- 3�� �� ��(��) ���յǾ����ϴ�.

SELECT *
FROM tbl_merge1;
<��ȸ ���>
1	a	100	10
2	b	150	20
3	c	130	0

SELECT *
FROM tbl_merge2;
<��ȸ ���>
2	25
3	10
4	20
1	10

--------------------------------------------------------------
4. [ Constraints(��������) ]
    1) ���̺� ���� ���� Ȯ�� : user_constraints ��(view);
        SELECT *
        FROM user_constraints
        WHERE table_name = 'EMP';
    
    2) ���������̶�?
        ��. data integrity(������ ���Ἲ)�� ���ؼ� ���̺� ���ڵ�(��)�� �߰�, ����, ������ �� ����Ǵ� ��Ģ
        
        ��. ���̺� ���� �����ǰ� �ִ� ��� ���̺��� ���� ������ ���ؼ��� ���ȴ�.
    
        DEPT(deptno PK) <-> EMP (deptno FK)
        DELETE FROM dept
        WHERE deptno = 30;
        -- ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
        -- ���� : �ڽ����̺�(emp)�� deptno�� �θ����̺�(dept)�� deptno�� �����ϰ� �ִµ� �����ϸ� �ȵȴ�.
        
        SELECT *
        FROM emp
        WHERE deptno = 30;
    
        ��. �������� ���Ἲ�̶�? �����Ͱ� �㰡���� �ʴ� ������ �߰�, ����, ������ �����ϴ� Ư��
        (1) ��ü ���Ἲ(Entity Integrity) : ���� �����ͷ� X
         - �����̼�(���̺�)�� ����Ǵ� Ʃ��(tuple = row = record)�� ���ϼ��� �����ϱ� ���� ���������̴� == PK ����Ű
         
            INSERT INTO dept VALUES(10, 'QC', 'SEOUL');
            -- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated
            deptno = 10 �����ϱ� ������ 10������ �μ��� �߰��� �� ����. -> ��ü ���Ἲ
            
        (2) ���� ���Ἲ(Relational Integrity)
         - �����̼�(���̺�) ���� �������� �ϰ����� �����ϱ� ���� ���������̴�.
            -> deptno ���̺� : 10, 20, 30, 40
            -> emp ���̺� : 90�� ����� �����ϸ� X
            
             UPDATE emp
             SET deptno = 90
             WHERE empno = 7369;
             -- ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found
             -- emp ���̺��� deptno�� dept ���̺��� deptno �����ϰ� �ְ�, deptno���� 90�� �μ��� ���� ������ ������ �� ����.
        
        (3) ������ ���Ἲ(domain integrity)
         - �÷�(�Ӽ�)���� ��� ������ ���� ������ �����ϱ� ���� ���������̴�.
         - �÷�(�Ӽ�)�� ������ Ÿ��, ����, �⺻ Ű, ���ϼ�, null ���, ��� ���� ������ ���� �پ��� ���������� ������ �� �ִ�.
         
             ��) ���� ���� - kor NUMBER(3) NOT NULL DEFAULT 0
                  �Է��� ���� ������ �⺻�� 0���� �Է�
                  �ʼ� �Է»���
                  -999 ~ 999 ������ ������ �� �ִ�.    0 <= ���� <= 100 (��������)
                  
        ��. ���������� ����ϴ� ����? DML�� ���� �����Ͱ� �߸� ���۵Ǵ� ���� �����ϱ� ���ؼ�
            �������� ���̵� �⺻ ������ ���̺��� �����ȴ�.
            �׷��� ���̺��� ������ ��쿡 DML�� ���� ������ ������ ����ڰ� ���ϴ� ��� ���� ���� �� �ִ�.
             

            ��) �ֹε�Ϲ�ȣ
            ������ ���Ἲ ���� -> �������� ����
            rrn char(14)        INSERT INTO ���̺�� (rrn) VALUES('123') -> �̷��� ���� ����
                                �ߺ��Ǵ� �ֹε�Ϲ�ȣ ��
        
        ��. ���� ������ ����(����)�ϴ� ���
            (1) CREATE TABLE ���̺� ������ ��
            (2) ALTER TABLE ���̺� ������ ��
            -- * ��� ��� �� �ٽ�..
            
            CREATE TABLE XXX(
                id �ڷ��� PRIMARY KEY <-- �������� ����
                cnt     DEFAULT 0 <-- �������� ����
                tel   NOT NULL  <-- �������� ����
            );
        
        ��. ���� ������ ���� 5����
         (1) PRIMARY KEY ��������(����Ű PK)
         (2) FOREIGN KEY ��������(�ܷ�Ű, ����Ű FK)
         (3) NOT NULL ��������(NN)
         (4) UNIQUE KEY ��������(���ϼ� UK)
         (5) CHECK ��������(CK)
         
         
        ��. ���������� �����ϴ� 2���� ���
         (1) �÷� ����(column level) == IN-LINE constaint ���
         (2) ���̺� ����(table level) == OUT-LINE constaint ���
         
         ���� �� �׽�Ʈ)
         -- �������� X
         CREATE TABLE tbl_constraint(
            empno NUMBER(4) NOT NULL
            , ename VARCHAR2(20) NOT NULL
            , deptno NUMBER(2) NOT NULL
            , kor NUMBER(3)
            , email VARCHAR(50)
            , city VARCHAR(20)
         );
         -- Table TBL_CONSTRAINT��(��) �����Ǿ����ϴ�.
         
         INSERT INTO tbl_constraint (empno, ename, deptno, kor, email, city)
                                    VALUES(null, null, null, null, null, null);
         -- NOT NULL �������� ���� �� ���� �߻�
         -- ORA-01400: cannot insert NULL into ("SCOTT"."TBL_CONSTRAINT"."EMPNO")
         
         -- �ʼ� �Է� �÷� ���� : NOT NULL ��������
         INSERT INTO tbl_constraint (empno, ename, deptno, kor, email, city)
                                    VALUES(1111, null, null, null, null, null);
         -- NOT NULL �������� ���� �� ���� �߻�
         -- ORA-01400: cannot insert NULL into ("SCOTT"."TBL_CONSTRAINT"."EMPNO")                                    
         
         INSERT INTO tbl_constraint (empno, ename, deptno, kor, email, city)
                                    VALUES(1111, 'admin', 10, null, null, null);
         INSERT INTO tbl_constraint (empno, ename, deptno, kor, email, city)
                                    VALUES(1111, 'hong', 10, null, null, null);
         -- ���� ��� ��ȣ�� 2���� ��� -> ��ü ���Ἲ ����                                     

         SELECT *
         FROM tbl_constraint;
         
         ROLLBACK;
         
         DROP TABLE tbl_constraint;
         
    
         -- �÷����� ������� �������� ����
         -- �÷� �ڿ� ���������� ���̴� ���
         -- ����Ű ���� X
         CREATE TABLE tbl_column_level(
            empno NUMBER(4) NOT NULL CONSTRAINTS pk_tblcolumnlevel_empno PRIMARY KEY
            , ename VARCHAR2(20) NOT NULL
            -- dept ���̺��� PK(deptno) �÷��� �����ϴ� �ܷ�Ű(=����Ű) FK ����
            , deptno NUMBER(2) NOT NULL CONSTRAINTS fk_tblcolumnlevel_deptno REFERENCES dept(deptno)
            -- kor�� 0 ~ 100���� ���� �� �ֵ��� ���� CHECK(CK)
            , kor NUMBER(3) CONSTRAINTS ck_tblcolumnlevel_kor CHECK (kor BETWEEN 0 AND 100) 
            , email VARCHAR(50) CONSTRAINTS uk_tblcolumnlevel_email UNIQUE -- ���ϼ�(UK)
            -- ����, �λ�, �뱸, ������ �Է� ����
            , city VARCHAR(20) CONSTRAINTS ck_tblcolumnlevel_city CHECK (city IN ('����', '�λ�', '�뱸', '����') )          
         );
         -- Table TBL_COLUMN_LEVEL��(��) �����Ǿ����ϴ�.
         
         
         -- ���̺��� ������� �������� ����
         -- ���̺� ���� �� �� �Ŀ� �������� �������� �����ϴ� ���
         -- NOT NULL �������� ���̺��� ������� ���� X, �÷��� �ִ� �κп� ���� �־������
         -- ����Ű ���� O
         CREATE TABLE tbl_table_level(
            empno NUMBER(4) NOT NULL
            , ename VARCHAR2(20) NOT NULL
            , deptno NUMBER(2) NOT NULL
            , kor NUMBER(3)
            , email VARCHAR(50)
            , city VARCHAR(20)
            
            -- PK ���� ���� ����
            -- CONSTRAINTS [�������Ǹ�] PRIMARY KEY(�÷��� [,�÷���, �÷���...] )
            -- �÷����� ������ ���ͼ� PK�� ������ �شٸ� ����Ű��� �Ѵ�.
            , CONSTRAINTS pk_tbltablelevel_empno PRIMARY KEY(empno)
            , CONSTRAINTS fk_tbltablelevel_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
            , CONSTRAINTS uk_tbltablelevel_email UNIQUE(email)
            , CONSTRAINTS ck_tbltablelevel_kor CHECK (kor BETWEEN 0 AND 100)
            , CONSTRAINTS ck_tbltablelevel_city CHECK (city IN ('����', '�λ�', '�뱸', '����') )   
         );
        -- Table TBL_TABLE_LEVEL��(��) �����Ǿ����ϴ�.          
        
        
        INSERT INTO tbl_table_level (empno, ename, deptno, kor, email, city)
                        VALUES('1111', 'admin', 20, 90, 'admin@naver.com', '����');
        -- ORA-01438: value larger than specified precision allowed for this column
        -- �����ȣ 4�ڸ� �־�� �ϴµ� 5�ڸ� �Է��ؼ� �߻�
        
        INSERT INTO tbl_table_level (empno, ename, deptno, kor, email, city)
                        VALUES('2222', 'hong', 30, 89, 'hong@naver.com', '�뱸');
        -- ��ü ���Ἲ ����                        
        -- ORA-00001: unique constraint (SCOTT.PK_TBLTABLELEVEL_EMPNO) violated
        -- �����ȣ�� PK�̹Ƿ� ���� �߻�(�ߺ� �߻� X)
        
        -- ���� ���Ἲ ����
        -- ORA-02291: integrity constraint (SCOTT.FK_TBLTABLELEVEL_DEPTNO) violated - parent key not found
        -- dept ���̺��� deptno 50���� ���� ������ ���� �߻�
        
        -- ������ ���Ἲ ����
        -- ORA-02290: check constraint (SCOTT.CK_TBLTABLELEVEL_KOR) violated
        -- kor�� �Է��� �� �ִ� ���� 0 ~ 100 �����̱� ������ ���� �߻�
        -- ORA-02290: check constraint (SCOTT.CK_TBLTABLELEVEL_CITY) violated
        -- city�� ����, ����, �뱸, �λ길 �Է��� �� �ֱ� ������ ���� �߻�
        
        INSERT INTO tbl_table_level (empno, ename, deptno, kor, email, city)
                        VALUES('3333', 'choi', 30, null, null, null);
        -- ORA-01400: cannot insert NULL into ("SCOTT"."TBL_TABLE_LEVEL"."ENAME")
        -- ename�� NOT NULL ���������̱� ������ �ݵ�� ���� ����Ѵ�.
                                                
        SELECT *
        FROM tbl_table_level;
        
        -- �������� Ȯ��
        SELECT *
        FROM user_constraints
        WHERE table_name = UPPER('tbl_table_level');
        
        <���>
        ��������    �������Ǹ�         ��������Ÿ��        ��������
        SCOTT	SYS_C007151	            C	    TBL_TABLE_LEVEL	"EMPNO" IS NOT NULL
        SCOTT	SYS_C007152	            C	    TBL_TABLE_LEVEL	"ENAME" IS NOT NULL
        SCOTT	SYS_C007153	            C	    TBL_TABLE_LEVEL	"DEPTNO" IS NOT NULL
        SCOTT	CK_TBLTABLELEVEL_KOR	C	    TBL_TABLE_LEVEL	kor BETWEEN 0 AND 100
        SCOTT	CK_TBLTABLELEVEL_CITY	C	    TBL_TABLE_LEVEL	city IN ('����', '�λ�', '�뱸', '����') 
        SCOTT	PK_TBLTABLELEVEL_EMPNO	P	    TBL_TABLE_LEVEL	
        SCOTT	UK_TBLTABLELEVEL_EMAIL	U	    TBL_TABLE_LEVEL	
        SCOTT	FK_TBLTABLELEVEL_DEPTNO	R	    TBL_TABLE_LEVEL	
        
        
       ��. ���� ���̺� ���Ἲ���������� �߰����
        �����ġ�
            ALTER TABLE ���̺��
            ADD [CONSTRAINT �������Ǹ�] ��������Ÿ�� (�÷���);

       ��. ���̺��� ���� ������ ����
        ? ���������� ������ �� ������, ������ constraint�� ���� �� �� �����Ͽ��� �Ѵ�.
        ? constraint�� �����ҷ���, ���� constraint���� ����ؼ� �����ϰų� �Ǵ� constraint�� ���Ե� ���̺��� �����ϸ� �� ���̺� ���� constraint�� �Բ� �����ȴ�.
        ? ���Ἲ constraint�� ������ ��, �� constraint�� �� �̻� ������ ���ؼ� ������� �ʱ� ������ data dictionary���� Ȯ���� �� ����.
        ? primary key�� ���̺�� �ϳ��� �����ϹǷ� ������ constraint���� �������� �ʾƵ� primary key ���������� �����ȴ�.
        
        [�����ϴ� ����]
        ALTER TABLE ���̺�� 
        DROP [CONSTRAINT constraint�� | PRIMARY KEY | UNIQUE(�÷���)]
        [CASCADE];
        
        (1) tbl_table_level ���̺��� PK ����
            ALTER TABLE tbl_table_level 
            DROP PRIMARY KEY;
            -- Table TBL_TABLE_LEVEL��(��) ����Ǿ����ϴ�.
            
            -- �������Ǹ����� �����ϴ� ���
            ALTER TABLE tbl_table_level 
            DROP CONSTRAINT pk_tbltablelevel_empno;
            -- Table TBL_TABLE_LEVEL��(��) ����Ǿ����ϴ�.
            
        (2) PK�� ���� ���̺� �߰� -- o ����
            ALTER TABLE tbl_table_level 
            ADD CONSTRAINT pk_tbltablelevel_empno PRIMARY KEY (empno);
            -- Table TBL_TABLE_LEVEL��(��) ����Ǿ����ϴ�.
            
------
    ����1) tbl_table_level ���̺��� ���� ������ Ȯ���ϰ�, ��� CK �������Ǹ� ����
    
    SELECT *
    FROM user_constraints
    WHERE table_name = UPPER('tbl_table_level');
    
    ALTER TABLE tbl_table_level
    DROP CONSTRAINTS CK_TBLTABLELEVEL_KOR;
    
    ALTER TABLE tbl_table_level
    DROP CONSTRAINTS CK_TBLTABLELEVEL_CITY;
    
    --
    ����2) kor �÷��� NN �������� �߰��ϼ���
    
    UPDATE tbl_table_level
    SET kor = 0
    WHERE empno = 3333;
    
    ��� 2����)
    ALTER TABLE ���̺��
    ADD CONSTRAINT �������Ǹ� CHECK( kor IS NOT NULL );
    
    �Ǵ�
    
    ALTER TABLE tbl_table_level
    MODIFY kor NOT NULL;

    <�������� Ȱ��ȭ/��Ȱ��ȭ>
    -- ���������� �����س��µ� ��� ������� �ʴ� ��
    ALTER TABLE ���̺��
    ENABLE CONSTRAINT �������Ǹ� [CASCADE];
    
    ALTER TABLE ���̺��
    DISABLE CONSTRAINT �������Ǹ� [CASCADE];

----
      [�������] FOREIGN KEY ������ ���ǻ���
      ? �����ϰ��� �ϴ� �θ� ���̺��� ���� �����ؾ� �Ѵ�.
      ? �����ϰ��� �ϴ� �÷��� PRIMARY KEY �Ǵ� UNIQUE ���������� �־�� �Ѵ�.
      ? ���̺� ���̿� PRIMARY KEY�� FOREIGN KEY�� ���� �Ǿ� ������, primary key ������ foreign key �÷��� �� ���� �ԷµǾ� ������ ������ �ȵȴ�. (��, FK ���� ON DELETE CASCADE�� ON DELETE SET NULL�ɼ��� ����� ��쿡�� �����ȴ�.)
      ? �θ� ���̺��� �����ϱ� ���ؼ��� �ڽ� ���̺��� ���� �����ؾ� �Ѵ�.
    
     ��. FK ������ �� ���� �ɼ� ����
     ? ON DELETE CASCADE �ɼ�
        - �θ� ���̺��� ���� ������ �� �̸� ������ �ڽ� ���̺��� ���� ���ÿ� ������ �� �ִ�.
     ? ON DELETE SET NULL �ɼ�
        - �ڽ� ���̺��� �����ϴ� �θ� ���̺��� ���� �����Ǹ� �ڽ� ���̺��� ���� NULL ������ �����Ų��.
     
     ���÷������� ���ġ�
        �÷��� ������Ÿ�� CONSTRAINT constraint��
        REFERENCES �������̺�� (�����÷���) 
             [ON DELETE CASCADE | ON DELETE SET NULL]
             
     �����̺����� ���ġ�
            �÷��� ������Ÿ��,
            �÷��� ������Ÿ��,
             ...
            CONSTRAINT constraint�� FOREIGN KEY(�÷�)
            REFERENCES �������̺�� (�����÷���)
                 [ON DELETE CASCADE | ON DELETE SET NULL]
    ---- 
�׽�Ʈ)
    1)             
    emp -> tbl_emp ���̺� ����
        DROP TABLE tbl_emp;

        CREATE TABLE tbl_emp AS( SELECT * FROM emp);
    
    dept -> tbl_dept ���̺� ����
        CREATE TABLE tbl_dept AS( SELECT * FROM dept);
    
    2) tbl_emp�� tbl_dept ���̺��� ���� ���� Ȯ��
        SELECT *
        FROM user_constraints
        WHERE table_name IN( 'TBL_EMP', 'TBL_DEPT');
    
    3) tbl_emp(empno), tbl_dept(deptno) �������� PK �߰�
        ALTER TABLE tbl_emp
        ADD CONSTRAINT pk_tblemp_empno PRIMARY KEY (empno);
        
        ALTER TABLE tbl_dept
        ADD CONSTRAINT pk_tbldept_deptno PRIMARY KEY (deptno);

    4) tbl_dept(deptno PK) -> tbl_emp(deptno) ����Ű FK ����
        ALTER TABLE tbl_emp
        ADD CONSTRAINTS fk_tblemp_deptno FOREIGN KEY(deptno) REFERENCES tbl_dept(deptno);

    5) ��ȸ
        SELECT * FROM tbl_emp;
        SELECT * FROM tbl_dept;
        
    6) tbl_dept ���̺��� 30�� �μ��� �����ϸ� tbl_emp ���̺� 30�� �μ����鵵 �����ϰ�ʹ�. -> ON DELETE CASCADE �ɼ�
        DELETE FROM tbl_dept
        WHERE deptno = 30;
        -- ORA-02292: integrity constraint (SCOTT.FK_TBLEMP_DEPTNO) violated - child record found
        -- �ڽ� ���ڵ尡 �����ϰ� �ֱ� ������ ������ �� ����.
    
    -- 6) ���� ���ϴ� �����͸� �����ϱ� ���� �۾� 7) ~ 9) 
    7) fk_tblemp_deptno �������� ����
        ALTER TABLE tbl_emp
        DROP CONSTRAINTS fk_tblemp_deptno;
        
    8) FK �������� �ٽ� �߰��ϱ� + ON DELETE CASCADE �ɼ� �߰�
        ALTER TABLE tbl_emp
        ADD CONSTRAINTS fk_tblemp_deptno FOREIGN KEY(deptno) REFERENCES tbl_dept(deptno) ON DELETE CASCADE;

    8-2) FK �������� �ٽ� �߰��ϱ� + ON DELETE SET NULL �߰�
        ALTER TABLE tbl_emp
        ADD CONSTRAINTS fk_tblemp_deptno FOREIGN KEY(deptno) REFERENCES tbl_dept(deptno) ON DELETE SET NULL;        
    
    9) tbl_dept ���̺��� 30�� �μ��� �����ϸ� tbl_emp ���̺� 30�� �μ����鵵 �����Ǿ���
        DELETE FROM tbl_dept
        WHERE deptno = 30;
        
        SELECT * FROM tbl_emp;
        SELECT * FROM tbl_dept;
        
        ROLLBACK;

--------------------------------------------------------------------------------------------------
5. [ JOIN(����) ]
    1) ����ȭ(�𵨸�)�� ���ؼ� ���̺��� �ɰ��� �ִ� ���� ���ų� ���� �ٸ� �� �� �̻��� ���̺��� �÷��� �˻�(��ȸ)�ϱ� ���ؼ� ���
    RDBMS ������ ������ ���� ����ϴ� DBMS
    ���̺�� ���̺� ���� ���谡 �ξ��� �ִ�.
    PK <=> FK
    
    �μ���/�����/�Ի�����
    dept : �μ���
    emp : �����/�Ի�����
    
    2) JOIN�� ����
    (1) EQUI JOIN
    
    (2) NON-EQUI JOIN 
    
    (3) INNER JOIN
    
    (4) OUTER JOIN
    
    (5) SELF JOIN
        ? �� ���� ���̺��� �� ���� ���̺�ó�� ����ϱ� ���� ���̺� ��Ī�� ����Ͽ� �� ���̺��� ��ü������ JOIN�Ͽ� ����Ѵ�.
        ? SELF JOIN�� ���̺��� �ڽ��� Ư�� �÷��� �����ϴ� �� �ٸ� �ϳ��� �÷��� ������ �ִ� ��쿡 ����Ѵ�.
        
        �����ġ�
        SELECT alias1.�÷���, alias2.�÷���
        FROM �������̺� alais1, �������̺� alais2
        WHERE alias1.�÷�1��=alais2.�÷�2��;
    
        �����ġ�
        SELECT alias1.�÷���, alias2.�÷���
        FROM �������̺� alais1 JOIN �������̺� alais2
            ON alias1.�÷�1��=alais2.�÷�2��;
        
        --
        ����)
        SELECT *
        FROM emp;
        
        <���>
        7369	SMITH	CLERK	    7902	80/12/17	800		        20
        7499	ALLEN	SALESMAN	7698	81/02/20	1600	300	    30
        7521	WARD	SALESMAN	7698	81/02/22	1250	500	    30
        7566	JONES	MANAGER	    7839	81/04/02	2975		    20
        7654	MARTIN	SALESMAN	7698	81/09/28	1250	1400	30
        7698	BLAKE	MANAGER	    7839	81/05/01	2850		    30
        7782	CLARK	MANAGER	    7839	81/06/09	2450		    10
        7839	KING	PRESIDENT		    81/11/17	5000		    10
        7844	TURNER	SALESMAN	7698	81/09/08	1500	0	    30
        7900	JAMES	CLERK	    7698	81/12/03	950		        30
        7902	FORD	ANALYST	    7566	81/12/03	3000		    20
        7934	MILLER	CLERK	    7782	82/01/23	1300		    10
        8000	YELIN	ANALYST	    7566	22/04/18	2500	0	    20
        
        ����) �����ȣ, �����, �μ���ȣ ��ȸ + ���ӻ���� ����� + �μ��̸� -> SELF JOIN ��� + �ٸ� ���̺� JOIN(equi join)
        SELECT e1.empno, e1.ename, e1.deptno, e1.mgr, e2.ename, dname
        FROM emp e1, emp e2, dept d
        WHERE e1.mgr = e2.empno AND e1.deptno = d.deptno;
        
        SELECT e1.empno, e1.ename, e1.deptno, e1.mgr, e2.ename, dname
        FROM emp e1 JOIN emp e2 ON e1.mgr = e2.empno
                    JOIN dept d ON e1.deptno = d.deptno;

        
    (6) CROSS JOIN
    
    (7) ANTI JOIN
    
    (8) SEMI JOIN

        

       
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
