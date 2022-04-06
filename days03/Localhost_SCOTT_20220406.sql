-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]

--1. �������
--  ��. Data : �ǹ̰� �ִ� ����(�ڷ�)
--  ��. DataBase : �ǹ̰� �ִ� ������ �����, �������� ����
--  ��. DBMS : ������ ���̽� ���� �ý���, ����Ʈ����
--  ��. DBA : ������ ���̽� ������, SYS�� SYSTEM ���� �ڵ� ���� ��� ������ SYS�� ���, SYSTEM�� DB ���� ���� ����
--  ��. ��(ROLE) :
        �ټ��� ����ڿ� �پ��� ����(privilege)�� ȿ����(���� �ο�, ����)���� �����ϱ� ���Ͽ� ���� ���õ� ������ �� ���� ���� �׷�
        ���̶�, ����ڳ� ����� �׷��� �ʿ�� �ϴ� ���� ���õ� ���ѵ��� �ѵ� ��� �̸��� �ٿ� ���� ������ ������ �ǹ�
        1) �� ���� -> 2) �ѿ� ���� �ο� -> 3) ����ڿ��� �� �ο�
        
        �����ġ�
        CREATE ROLE ���̸�
        [NOT IDENTFIED �Ǵ� IDENTIFIED
        {BY PASSWORD �Ǵ� EXTERNALLY �Ǵ� GLOBALLY �Ǵ� USING ��Ű��}];
        [���̺�]
        CREATE TABLE ���̺��
        ALTER TABLE ���̺��~
        DROP TABLE ���̺��
        
        [����]
        CREATE USER ������
        ALTER USER ������ IDENTIFIED BY ��й�ȣ ACCOUNT UNLOCK;
        DROP USER ������
        
        [��]
        CREATE ROLE �Ѹ�
        ALTER ROLE �Ѹ� ~
        DROP ROLE �Ѹ�
        
        �����ο���(ROLE) <- 50���� ���� �ο�
         > CREATE ROLE ������ ����
        ����ο���(ROLE) <- 100���� ���� �ο�
        ���λ������(ROLE) <- ����1... ����30
        GRANT 50���� ���� TO �Ѹ�
        
        ��) ���Ի�� 50�� <- ���Ի�� 30���� ����
            A      <- ����1...����30        -> �̷��� �ϳ��� �ִ� �ͺ��� ��ó�� ���� ���� �ִ� ���� ��
            B      <- ����1...����30, �����ο��� 50�� ����
            C      <- ���Ի������(ROLE), ����ο���(ROLE)

select *
FROM dba_roles; -- ������ ������ ���� ������ ��ȸ����, SYS������ ��ȸ ����
00942. 00000 -  "table or view does not exist" - ���� �߻�

select *
FROM user_role_privs; -- �������� �ο��� ���� ������ �ִ��� ��ȸ
<������>
SCOTT	CONNECT	NO	YES	NO
SCOTT	RESOURCE	NO	YES	NO

SELECT *
FROM role_sys_privs -- �ѿ� �ο��� �ý��� ������ ������ �ִ��� ��ȸ
WHERE role = 'RESOURCE';
<������>
CREATE SEQUENCE
CREATE TRIGGER
CREATE CLUSTER
CREATE PROCEDURE
CREATE TYPE
CREATE OPERATOR
CREATE TABLE
CREATE INDEXTYPE

where role='STUDENT_ROLE';

�� ȸ��(����)
REVOKE ���̸�
FROM ������ �Ǵ� ���̸� �Ǵ� PUBLIC;

����1) scott ������ �����ϰ� �ִ� ���� Ȯ���ϰ�
      CONNECT �� �����ϰ�
      CONNECT �� �ο�(����)
      
SELECT *
FROM role_sys_privs;


REVOKE CONNECT FROM scott; -- SYS�� ���� �����ؾ� �� (������ ���� ������ �����߻�)
REVOKE CONNECT FROM scott
���� ���� -
ORA-01932: [ADMIN option] not granted for role 'CONNECT' -- ADMIN �ɼ��� ����.
01932. 00000 -  "ADMIN option not granted for role '%s'"
*Cause:    The operation requires the admin option on the role.
*Action:   Obtain the grant option and re-try.

GRANT CONNECT TO scott; -- SYS�� ���� �����ؾ� �� (������ ���� ������ �����߻�)

            
--  ��. SID( ���� �����ͺ��̽� �̸� )
    -- ��ġ�� ����Ŭ DB�� ������ �̸�
    -- ����Ŭ ���� ������ ��ġ�ϸ� �ڵ����� SID�� XE�� ����
    -- ����Ŭ ���� ������ 1���� ��ġ ����
    
--  ��. ������ ��
--  ��. R+DBMS
    -- ��ǻ�Ϳ� �����͸� �����ϴ� ����� ������ ���� ���� ��
    -- ������ ������ �� ��� �� 
    -- ������ ������ �� + DBMS = RDBMS
    
--  ��. ��Ű��(Schema)
    -- 1) DB���� � ������ ���Ͽ� �ʿ��� ���� ���� ������ ���̺���� ������ Schema�� �Ѵ�
    
    -- 2) DATABASE SCHEMA(DB ��Ű��) ?
        -- USER A�� �����Ǹ� �ڵ������� ������ �̸��� SCHEMA A�� �����ȴ�.
        -- USER A�� SCHEMA A�� ���õǾ� DATABASE�� ACCESS�Ѵ�.
        -- �׷��Ƿ� USER�� �̸��� SCHEM A�� ���� �ٲ�� ���� �� �ִ�.

        -- Ư�� USER�� ���õ� ��� OBJECT�� ����
        -- scott ���� ���� -> scott ������ ����� �� �ִ� ��� OBJECT ��������� �� ������ '��Ű��'��� �Ѵ�.
        -- emp ���̺�(��ü) ����
        FROM ��Ű��.���̺��
        FROM scott.emp;
        
    -- 3) ��� ����
    -- �ν��Ͻ�(instance) : ����Ŭ ���� -> ����(startup)�ؼ� ����(shutdown)�� �� ����
    -- ����(session) : � Ư�� ����ڰ� �α����ؼ� �α׾ƿ� �� �� ����
    -- ��Ű��(schema) : Ư�� USER�� ���õ� OBJECT(���̺� ��..)�� ����


--2. ��ġ�� [����Ŭ�� ����]�ϴ� ������ [�˻�]�ؼ� ���� ��������.  ***
  ��. ���񽺾� -> ����Ŭ ���� ���� ����
  ��. uninstall.exe / ���α׷� �߰� �� ���� - ����
  ��. Ž���� - ����Ŭ ���õ� ���� ����
  ��. ������Ʈ��������(regedit.exe) -> ����Ŭ�� ���õ� ������Ʈ�� ����(���۸� �˻��ؼ� 4���� ����..) 

--3. SYS �������� �����Ͽ� ��� ����� ������ ��ȸ�ϴ� ����(SQL)�� �ۼ��ϼ���.
SELECT *
FROM all_tables; -- SCOTT ������ �����ϰ� �ִ� ���̺� + ���� �ο� �޾Ƽ� ����� �� �ִ� ���̺� View
FROM tabs; -- �ؿ� �ſ� ������
FROM user_tables; -- SCOTT ������ �����ϰ� �ִ� ���̺� View

��) ȸ��
    ȫ�浿 - K9  user_cars; - ȫ�浿�� ���� �����ϰ� �ִ� �ڵ���
            BMW all_cars; - ȫ�浿�� ����� �� �ִ� �ڵ���
    
    SM6
    NIRO
    ȸ�� �ȿ� �ִ� ��� ������ ������ �� dba_cars;

[SYS  �����ؼ� ��]
SELECT *
FROM dba_users; -- dba_ ���λ� : ����Ŭ �����ڰ� �����ͺ��̽� ���� ��� ������� �����͸� �� �� �ִ�.
�����޽��� : ���� ���� �Ǵ� ö�� Ʋ�� ��
ORA-00942: table or view does not exist
00942. 00000 -  "table or view does not exist" 

SELECT *
FROM user_users;

SELECT *
FROM all_users; -- all_ ���λ� : ���� �������� USER(���⼭�� SYS)�� ��� ����� ������ �������� view

--7-1. SCOTT ��������  scott.sql ������ ã�Ƽ� emp, dept, bonus, salgrade ���̺��� ���� �� ������ �߰��� ������ �ۼ��ϼ���.
--7-2. �� ���̺� � ������ �����ϴ��� �÷��� ���� ����( �÷���, �ڷ��� )�� �����ϼ���.
--  ��. emp
--  ��. dept
--  ��. bonus
--  ��. salgrade

SELECT *
FROM tabs;

DESC emp;

--8. SCOTT ������ �����ϰ� �մ� ��� ���̺��� ��ȸ�ϴ� ����(SQL)�� �ۼ��ϼ���.
SELECT *
FROM user_users;
FROM all_users;

--9. SQL*Plus �� ����Ͽ� SYS�� �����Ͽ� ������ ����� Ȯ���ϰ�, ��� ����� ������ ��ȸ�ϰ�
--   �����ϴ� ��ɹ��� �ۼ��ϼ���.  

--10. ������ ������ ���� �ٽ� ���� ���
   ��.  
   ��.  
   ��.  

--11. Oracle SQL Developer ���� ����(SQL)�� �����ϴ� ����� ��� ��������.
   ��. F9
   ��. F5
   ��. Ctrl + Enter

--12. ����Ŭ �ּ�ó�� ���  3������ ��������.
    ��. -- ���� �ּ�ó��
    ��. rem REM ���� �ּ�ó��
    ��. /* */ �� �ּ�ó��

--13. �ڷ� ����( Data [Dictionary] ) �̶�? 
    ��Ÿ ������(META DATA) == Data Dictionary�� ����
    1) Data Dictionary = TABLE�� View���� ����  -> View�� ���߿� ��� ����..
    2) ���� : DB�� ������ �����ϴ� ����
        ��) soctt ������ �����ϰ� �ִ� ���̺� ����
            FROM user_users; -- Data Dictionary �ȿ� �ִ� View �߿� �ϳ�...
    3) DB ������ �ڵ����� SYS ���� ���� -> SYS Schema ���� -> ���ο� �ڷ� ����(Data Dictionary) ����
    4) ���� �߰��� �Ǿ���� ����� �Ǿ��ִ�.
    5) �ڷ������ DB ���� �Ŀ� �⺻ ���̺� �����Ǿ� ����. ���� DBA_, ALL_, USER_�� �����ϴ� �ڷ���� View�� Ȯ�� X
    6) �ڷ������ ������ ���� ���۵Ǵ� ��ǥ���� 4����
    FROM user_tables; // �ڷ���� �ȿ� �ִ� '��'  -> � ������ �����ϴ� ����
    dba_
    all_
    user_ 
    v$_ DB�� ���ɺм� / ��� ������ �����ϴ� ��
    
SCOTT ���� emp ���̺� ����
���̺��� �����Ǿ��ٰ� ��ϵǾ����� ���� �ڷ� ����
�� �ȿ� ���̺��� �����ñ�, ������ ����� ����
    
--14. SQL �̶� ? 
���� <- ����/���� -> Ŭ���̾�Ʈ
        ��� �ʿ� -> ����ϴ� ��� -> ����ȭ�� ���� ��� == SQL

--15. SQL�� ������ ���� ���� ��������.
    ��. DQL  SELECT
    ��. DDL  CREATE ALTER DROP
    ��. DML  INSERT UPDATE DELETE RENAME TRUNCATE  + �ݵ�� COMMIT �Ǵ� ROLLBACK
    ��. DCL  GRANT REVOKE
    ��. TCL  COMMIT ROLLBACK SAVE POINT

--16. select ���� 7 ���� ���� ó�� ������ ���ؼ� ��������.
WITH 1
SELECT 6
FROM 2
WHERE 3
GROUP BY 4
HAVING 5
ORDER BY 7

--17. emp ���̺��� ���̺� ����(�÷�����)�� Ȯ���ϴ�  ������ �ۼ��ϼ���.
DESC emp;

NLS
��¥ ���� : RR/MM/DD
           YY/MM/DD
           RR�⵵�� YY�⵵ ��ȣ ������ �߿� ***

--18. employees ���̺���  �Ʒ��� ���� ��µǵ��� ���� �ۼ��ϼ���. 
SELECT first_name, last_name
FROM employees;

���� �޽��� : ö�� Ʋ���ų� �ν��� ���ϰų�
ORA-00942: table or view does not exist
00942. 00000 -  "table or view does not exist" 

[HR ������ ����..]
FIRST_NAME          LAST_NAME                   NAME                                           
-------------------- ------------------------- ---------------------------------------------- 
Samuel               McCain                    Samuel McCain                                  
Allan                McEwen                    Allan McEwen                                   
Irene                Mikkilineni               Irene Mikkilineni                              
Kevin                Mourgos                   Kevin Mourgos                                  
Julia                Nayer                     Julia Nayer     

--20. HR ������ ���� �ñ�� [��ݻ���]�� Ȯ���ϴ� ������ �ۼ��ϼ���.
[SYS ��������..]
SELECT *
FROM dba_users;

--21. emp ���̺��� ��,  �����ȣ, �̸�, �Ի����ڸ� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT job, num, name, ibsadate
FROM emp;

--22.  emp ���̺���  �Ʒ��� ���� ��ȸ ����� �������� ������ �ۼ��ϼ���.
    (  sal + comm = pay  )
SELECT empno, ename, sal, comm
        , NVL(comm, 0) + sal PAY
        , NVL2(comm, sal + comm, sal) PAY
FROM emp;
     EMPNO ENAME             SAL       COMM        PAY
---------- ---------- ---------- ---------- ----------
      7369 SMITH             800          0        800
      7499 ALLEN            1600        300       1900
      7521 WARD             1250        500       1750
      7566 JONES            2975          0       2975
      7654 MARTIN           1250       1400       2650
      7698 BLAKE            2850          0       2850
      7782 CLARK            2450          0       2450
      7839 KING             5000          0       5000
      7844 TURNER           1500          0       1500
      7900 JAMES             950          0        950
      7902 FORD             3000          0       3000

     EMPNO ENAME             SAL       COMM        PAY
---------- ---------- ---------- ---------- ----------
      7934 MILLER           1300          0       1300

	12�� ���� ���õǾ����ϴ�.  

--23.  emp���̺���
--    �� �μ����� �������� 1�� �����ϰ� �޿�(PAY)���� 2�� �������� �����ؼ� ��ȸ�ϴ� ������ �ۼ��ϼ���.    
SELECT deptno, name, sal + NVL(comm, 0) PAY
FROM emp
ORDER BY deptno ASC, PAY DESC;

--29. SQL�� �ۼ���� @@@
SQL ���� �ۼ���
? SQL ������ ��ҹ��ڸ� �������� �ʴ´�.
? SQL*Plus���� SQL ������ SQL ������Ʈ�� �ԷµǸ�, ������ Line�� �ٹ�ȣ�� �ٴ´�.
? SQL ����� ������ ���� �����ݷ�(;)�� �ݵ�� �ٿ��� �Ѵ�.
? �� ������ ��ɾ� 1���� SQL buffer�� ����ȴ�.
? SQL ������ �� �� �̻��� �� �ִ�.
? SQL ��ɾ �����ϰ� �ִ� �ܾ��� ��𿡼��� �и��ص� �ȴ�.
? �� ���� line�� �� ���� ��(select, from, where) ���·� ������ �Է��ϴ� ���� ���Ѵ�.�׷��� �� ���� �ܾ �� �ٷ� ������ �Է��ؼ��� �ȵȴ�.
? keyword�� �빮�ڷ� �Է��ϵ��� ���Ѵ�.
? �ٸ� ��� �ܾ� ��, table �̸�, column �̸��� �ҹ��ڷ� �Է��� ���Ѵ�.
? keyword�� �����ϰų� �ٷ� ������ �� �� ����.
? ���� �밳 ���� ������ ������ ���Ѵ�.
? �ǰ� �� �ֱ�� �б� ���� �ϱ� ���� ����� ���Ѵ�.


SQL? ����ȭ�� ���� ���
PL/SQL = SQL + ������ ��� ���� -> SQL�� ������ ���(Procedural Language)�� Ȯ��� ��

������ ��� ����
if
for
���� ���� ���
����

--30. �Ʒ� ���� �޽����� �ǹ̸� ��������.
  ��. ORA-00942: table or view does not exist  -> ���̺�� / ��� ��Ÿ �Ǵ� ���� ������ ���ų�
  ��. ORA-00904: "SCOTT": invalid identifier  -> ��й�ȣ �߸��Ǿ���
                                    �ĺ���
  ��. ORA-00936: missing expression   -> ǥ����(����)�� �߸��Ǿ���.
  ��. ORA-00933: SQL command not properly ended -> ��� ���� ���� �߸��Ǿ���.
  WHERE score >= 40 ||  -> �̷� ��� �߻�...

-- 31. emp ���̺��� �μ���ȣ�� 10���̰�, ���� CLERK  �� ����� ������ ��ȸ�ϴ� ���� �ۼ�.
-- 31-2. emp ���̺��� ���� CLERK �̰�, �μ���ȣ�� 10���� �ƴ� ����� ������ ��ȸ�ϴ� ���� �ۼ�.
SELECT *
FROM emp
WHERE NOT(deptno = 10) AND job = 'CLERK';
WHERE deptno <> 10 AND job = 'CLERK';
WHERE deptno ^= 10 AND job = 'CLERK';
WHERE deptno != 10 AND job = 'CLERK';
WHERE deptno = 10 AND job = 'CLERK';

-- 32. ����Ŭ�� null�� �ǹ� �� null ó�� �Լ��� ���ؼ� �����ϼ��� .
      ��. null �ǹ�? 
       ��. null ó�� �Լ� 2���� ������ ������ ���� �����ϼ��� .

-- 33.  emp ���̺��� �μ���ȣ�� 30���̰�, Ŀ�̼��� null�� ����� ������ ��ȸ�ϴ� ���� �ۼ�.
  ( ��.  deptno, ename, sal, comm,  pay �÷� ���,  pay= sal+comm )
  ( ��. comm�� null �� ���� 0���� ��ü�ؼ� ó�� )
  ( ��. pay �� ���� ������ ���� )

SELECT deptno, ename, sal, comm, sal + NVL(comm, 0) PAY
FROM emp
WHERE deptno = 30 AND comm IS NULL;
WHERE deptno = 30 AND comm IS NOT NULL;

[NOT] IN(list)
[NOT] BETWEEN a AND b
IS [NOT] NULL

-- 34. insa ���̺��� ������ ����� ��� ������ ��� ��ȸ�ϴ� ���� �ۼ� ( �������� ���� )
  ��. OR ������ ����ؼ� Ǯ��
SELECT *
FROM insa
WHERE city = '����' OR city = '���' OR city = '��õ'
ORDER BY city ASC;

  ��. IN ( LIST ) SQL ������ ����ؼ� Ǯ�� 
SELECT *
FROM insa
WHERE city IN( '����', '���', '��õ')
ORDER BY city ASC;
  
-- 35. insa ���̺��� ������ ����� �ƴ� ��� ������ ��� ��ȸ�ϴ� ���� �ۼ� ( �������� ���� )
  ��. AND ������ ����ؼ� Ǯ��
SELECT *
FROM insa
WHERE city != '����' AND city != '���' AND city != '��õ'
ORDER BY city ASC;

  ��. NOT IN ( LIST ) SQL ������ ����ؼ� Ǯ��
SELECT *
FROM insa
WHERE city NOT IN ('����', '���', '��õ')
ORDER BY city ASC;

  ��. OR, NOT �� ������ ����ؼ� Ǯ��
SELECT *
FROM insa
WHERE NOT(city = '����' OR city = '���' OR city = '��õ')
ORDER BY city ASC;
       
-- 36. ����Ŭ �� �����ڸ� ��������.
  ��. ����   :   =
  ��. �ٸ���  :   != <> ^=
  
-- 37. emp ���̺��� pay(sal+comm)��  1000 �̻�~ 2000 ���� �޴� 30�μ����鸸 ��ȸ�ϴ� ���� �ۼ�
  ���� : ��.  pay �������� �������� ���� --ename�� �������� �������� �����ؼ� ���(��ȸ)
           ��. comm �� null�� 0���� ó�� ( nvl () )
1��° Ǯ�� ���)
SELECT deptno, ename, sal + NVL(comm, 0) PAY
FROM emp
WHERE sal + NVL(comm, 0) BETWEEN 1000 AND 2000 AND deptno = 30
ORDER BY pay ASC;

���� �޽���:
ORA-00904: "PAY": invalid identifier -> WHERE�� ��Ī�� �ν����� ���Ѵ�.
00904. 00000 -  "%s: invalid identifier"

2��° Ǯ�� ���) WITH �� ���
SELECT deptno, ename, sal + NVL(comm, 0) PAY
FROM emp
WHERE deptno = 30;
<������>
30	ALLEN	1900
30	WARD	1750
30	MARTIN	2650
30	BLAKE	2850
30	TURNER	1500
30	JAMES	950

���� ������� ������ �Ʒ� �ڵ� �ϰڴ� -> WITH �� ���
WHERE pay BETWEEN 1000 AND 2000;

WITH temp AS(
    -- ���� �ȿ� ������ ���� �ִ� ���� ��������(subquery)��� �Ѵ�.
    SELECT deptno, ename, sal + NVL(comm, 0) PAY
    FROM emp
    WHERE deptno = 30
)
SELECT t.* -- t�� �ٿ��� ������ ���൵ ��
FROM temp t -- ���̺��� ��Ī
WHERE t.pay BETWEEN 1000 AND 2000; -- t�� �ٿ��� ������ ���൵ ��

3��° Ǯ�� ���) �ζ��κ�(inline view) ���
�ζ��κ�(inline view) ? FROM �� �ȿ� �ִ� ���������� �ζ��κ� ��� �Ѵ�.

SELECT t.*
FROM(
    -- �������� == �ζ��κ�(inline view)
    SELECT deptno, ename, sal + NVL(comm, 0) PAY
    FROM emp
    WHERE deptno = 30
) t -- ��Ī�� t��� �־���.
WHERE t.pay BETWEEN 1000 AND 2000;

-- 38. emp ���̺��� 1981�⵵�� �Ի��� ����鸸 ��ȸ�ϴ� ���� �ۼ�.
DESC emp; -- ���� Ȯ��

SELECT hiredate, ename
FROM emp
WHERE hiredate BETWEEN '1981-01-01' AND '1981-12-31'
-- 1981.01.01
ORDER BY hiredate ASC;

SELECT hiredate
        ,SUBSTR(hiredate, 1, [length]) -- length�� ���ָ� ������ �о�´�.
        ,SUBSTR(hiredate, 0, 2)
        ,SUBSTR(hiredate, 1, 2) YY -- ó������ �о���� �Ŷ�� 1�̶�� �൵ �ǰ� 0�� �൵ �ǰ�
FROM emp
WHERE SUBSTR(hiredate, 0, 2) = '81'
ORDER BY hiredate ASC;

-- ����Ŭ ��¥���� �⵵�� ��������
TO_CHAR(��¥��) �Լ��� ��¥�� ���ڰ�(�Ű�����)�� �޾� ���� ���ϴ� ��(�⵵, ��, ��, ���� ��)�� ���ڿ�(VARCHAR2)�� ��ȯ�ϴ� �Լ�
����Ŭ ��¥�� �ڷ��� : DATE, TIMESTAMP, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH LOCAL TIME ZONE

�����ġ�
 	TO_CHAR( date [,'fmt' [,'nlsparam']])
    nlsparam
��¥ ��� ������ ���� : Y, YYY

[YY�� RR�� ������] - Ora_Help���� to_char �˻� �� �о��
RR�� YY�� �Ѵ� �⵵�� ������ ���ڸ��� ����� ������, ���� system���� ����� ��Ÿ������ �ϴ� �⵵�� ���⸦ ������ �� ��µǴ� ���� �ٸ���.
RR�� �ý��ۻ�(1900���)�� �⵵�� �������� �Ͽ� ���� 50�⵵���� ���� 49������� ���س⵵�� ����� 1850�⵵���� 1949�⵵������ ������ ǥ���ϰ�, 
�� ������ ���Ƴ� ��� �ٽ� 2100���� �������� ���� 50�⵵���� ���� 49������� ���� ����Ѵ�.
YY�� ������ system���� �⵵�� ������.

SELECT hiredate
        , TO_CHAR(hiredate, 'RR') as RR
        , TO_CHAR(hiredate, 'YY') as YY
        , TO_CHAR(hiredate, 'YYYY') as YYYY
        , TO_CHAR(hiredate, 'RRRR') as RRRR
        , TO_CHAR(hiredate, 'YEAR') as YEAR
        , TO_CHAR(hiredate, 'SYYYY') as SYYYY
FROM emp;

SELECT hiredate
FROM emp
WHERE TO_CHAR(hiredate, 'YYYY') = '1981';

-- ���� ã�ƺ� �� EXTRACT()
SELECT EXTRACT(YEAR FROM hiredate) as year
FROM emp;

�Ʒ� �ΰ����ε� 38�� ������ Ǯ ���� ���� ���߿� �ٽ� �ٷﺼ ����~
LIKE SQL ������
REGEXP_LIKE() �Լ�

����) insa ���̺��� �ֹε�Ϲ�ȣ�� ����
     ���ڸ� 6�ڸ� ���, ���ڸ� 7�ڸ� ���, �⵵ 2�ڸ� ���, �� 2�ڸ�, �� 2�ڸ� ���,
     �ֹι�ȣ ������ ���� 1�ڸ� ���

SELECT ssn
        , SUBSTR(ssn, 0, 8) || '******' as RRN
        , CONCAT(SUBSTR(ssn, 0, 8), '******') as RRN
--        , SUBSTR(ssn, 0, 6) as ���ڸ�
--        , SUBSTR(ssn, 8) as ���ڸ�
--        , SUBSTR(ssn, -7) as ���ڸ�2 -- �ι�° ���ڰ��� ���̳ʽ��� �־ �ڿ������� ������ �� ����
--        , SUBSTR(ssn, 0, 2) as �⵵
--        , SUBSTR(ssn, 3, 2) as ��
--        , SUBSTR(ssn, 5, 2) as ��
--        , SUBSTR(ssn, 14 ) as ������ȣ
--        , SUBSTR(ssn, -1, 1 ) as ������ȣ2 -- �ڿ������� ������ �� ����
FROM insa;

DESC insa;
-- 39. emp ���̺��� ���ӻ��(mgr)�� ����  ����� ������ ��ȸ
SELECT empno, ename, mgr
FROM emp
WHERE mgr IS NULL;

-- 41. Alias �� �ۼ��ϴ� 3���� ����� ��������.
   SELECT deptno, ename 
     , sal + comm   (��)  AS "PAY"
     , sal + comm   (��)  "PAY"
     , sal + comm   (��)  PAY
    FROM emp;

--42. ����Ŭ�� �� �����ڸ� ��������.
  ��.  & AND
  ��.  | OR
  ��.  ! NOT

-- 43. ���� ��� ����Ŭ�� SQL �����ڸ� ��������.
  ��. [NOT] IN()
  ��. [NOT] BETWEEN a AND B
  ��. IS [NOT] NULL
  
  ANY, SOME, ALL -> WHERE �������� ���������� ����� �� ���̴� SQL �������̴�.
------------------------------------------------------------------------------------

���� ���� ����.
1. LIKE SQL ������ ����

����1) insa ���̺��� ���� "��"�� �� ����� ���� ��ȸ

1) SUBSTR() ���
SELECT name
    -- ,SUBSTR(name, 0, 1), ibsadate
FROM insa
WHERE SUBSTR(name, 0, 1) = '��';

2) LIKE ���
LIKE ������ ��ȣ = ���ϵ�ī��(wildcard) : % ��                    _               -> 2�� �ۿ� ����
�ڹ� ����ǥ���� :                       * �ݺ�Ƚ�� 0 ~ ������     1�� �;��Ѵ�. 
[ wildcard�� �Ϲ� ����ó�� ���� ���� ��쿡�� ESCAPE �ɼ��� ��� -> ���� ����]

SELECT name
FROM insa
WHERE name LIKE '_��_'; -- ������ 3���� �����ε� ����� '��'�� ��
WHERE name LIKE '_��%'; -- ù��° ���� 1�� �ְ� �� �ڿ� '��'�� ���� �ڿ��� ���ڰ� �ִ� ���� ���X
WHERE name LIKE '%��'; -- �տ� ���ڰ� �ִ� ���� ������ ���ڴ� '��'���� ������ ��
WHERE name LIKE '%��%'; -- ���ڿ� �ӿ� '��'�� ���ԵǾ� �ִ� ��
WHERE name LIKE '��_'; -- ù��° ���ڴ� '��'�� ���� 1���ڴ� �� �;��Ѵ�.
WHERE name LIKE '��%'; -- ù��° ���ڴ� '��'�� ���� �ڿ� ���ڰ� �͵� �ȿ͵� ��� ����.

emp���̺��� 1981�⵵�� �Ի��� ����鸸 ��ȸ�ϴ� ���� -LIKE ���
SELECT hiredate, ename
FROM emp
WHERE hiredate LIKE '81%';

2. REGEXP_LIKE() �Լ� : ���ϵ�ī�� ��� ����ǥ������ ����ϴ� LIKE �Լ�
�����ġ�
    regexp_like (search_string, pattern [,match_option])
[match_option]�� ���� ������ ���� �ǹ̷� �۵��Ѵ�.
    i  ��ҹ��� ���� ����
    c  ��ҹ��� ���� ����
    n  period(.)�� �����
    m  source string�� ���� ���� ���(multiple lines)
    x  whitespace character(���鹮��) ���� 

����1) �达�� �����ϴ� ��� ���
SELECT name, ssn
FROM insa
WHERE REGEXP_LIKE(name, '��$'); -- ������ ������ ��
WHERE REGEXP_LIKE(name, '^��'); -- ������ �����ϴ� ��

����2) �达 �Ǵ� �̾� ��� ���
1) LIKE ������ ���
SELECT name
FROM insa
WHERE name LIKE '��%' OR name LIKE '��%'
ORDER BY name ASC;

2) REGEXP_LIKE ������ ���
SELECT name
FROM insa
WHERE REGEXP_LIKE(name, '^[����]')
ORDER BY name ASC;

SELECT name
FROM insa
WHERE REGEXP_LIKE(name, '^(��|��)')
ORDER BY name ASC;

����3) �̸� �ӿ� 'la' ���ڿ��� �����ϴ� ��� ������ ���
1) LIKE ������ ���
SELECT ename
FROM emp
WHERE ename LIKE '%LA%';
WHERE ename LIKE '%' || 'LA' || '%';
WHERE ename LIKE '%' || UPPER('la') || '%'; -- �빮�ڷ� ��ȯ�ϴ� �Լ� UPPER()

2) REGEXP_LIKE ������ ���
SELECT ename
FROM emp
WHERE REGEXP_LIKE(ename, 'la', 'i');
WHERE REGEXP_LIKE(ename, UPPER('la'));
WHERE REGEXP_LIKE(ename, 'LA');

����4) insa ���̺��� ���� �达, �̾��� ������ ��� ��� ���� ��ȸ
1) [NOT] LIKE ������ ���
SELECT name
FROM insa
WHERE NOT (name LIKE '��%' OR name LIKE '��%');
WHERE name NOT LIKE '��%' AND name NOT LIKE '��%';

2) [NOT] REGEXP_LIKE ������ ���
SELECT name
FROM insa
--WHERE NOT REGEXP_LIKE(name, '^(��|��)');
--WHERE NOT REGEXP_LIKE(name, '^[����]');
WHERE REGEXP_LIKE(name, '^[^����]');



