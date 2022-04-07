-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]

1. subquery �� ���� �����ϼ��� ? 
	1) �ϳ��� SQL ������ ���� �μӵ� �� �ٸ� SELECT ��������,
        �� ���� ���Ǹ� �����ؾ� ���� �� �ִ� ����� �� ���� ���Ƿ� �ذ��� �� �ִ� �����̴�.
    2) subquery���� �� ������ �����ڰ� ���Ǹ�, �������� �����ʿ� ���������� () ������ �ִ�. -> ������ + (��������) -> ����� �� X
        ����� �ϳ��� ���� ��ȯ�ϴ� ������  >, <, >=, <=, < > 
        ����� ���� ���� ��ȯ�ϴ� SQL ������  IN, ANY, ALL 
    3) ���ǰ� �������� ���� �ٰŷ� �� �� �����ϴ� -> ���� ����
    4) ���������� ���������� �������ε� ���ȴ�.
        WHERE ������ �ȿ� (��������)                   -> ����� �� X
    5) ���������� ����� main out query�� ���� ���ȴ�. -> ����� �� X
    6) ���� ���� : �������� ���� ���� -> �� ����� main query�� �����Ͽ� ����
    7) WHERE, HAVING, INSERT INTO ��, UPDATE SET ��, SELECT, DELETE FROM ���� ���������� ����� �� �ִ�.
    8) ���������� ORDER BY ���� ������ �� ����. �ζ��� �信���� ����� �� �ִ�.
    9) ���������� ����ϸ� ������ ���ϵ�����(����), �ڵ��� �����ϰ� ������ �� �ִ�.(����)

2. Inline View �� ���� �����ϼ��� ?
	1) FROM �� �ڿ� ���Ǵ� ��������
    2) FROM ���̺�� �Ǵ� ���
            (��������) -> �̷��� �ͼ� ��ġ ���̺�ó�� ���Ǿ���

3. WITH ���� ���� �����ϼ��� ?
    1) ���� �������� ����� �̸� �����Ͽ� �ݺ��Ͽ� ����� �� �ֵ��� ��
    2) ���� -> ���� ���� ���������� �����ؼ� ����� �� ����
        WITH �����̸�1 AS (SELECT�� ��������), -> WITH�� �ӿ��� SELECT���� �ݵ�� �־�� ��
             �����̸�2 AS (SELECT�� ��������),
             �����̸�3 AS (SELECT�� ��������)
    3) with���� �ҷ��� ����ϴ� body ���������� block���� �켱�ǹǷ� ���̺���� ����� �� ����.
    4) with�� ���� �� �ٸ� with���� ������ �� ����.
    5) set operator�� ����� ���������� ����� �� ����
    6) WITH���� ����ϸ� ���������� �������ϸ� ������ �� �ִ�.
    7) ���̺� ��Ī..
    WITH 
     person_maxpay AS (select p.deptno, max(sal) as maxpay
                       from emp p, dept d
                       where p.deptno=d.deptno
                       group by p.deptno)

    SELECT m.deptno,m.maxpay
    FROM person_maxpay m;   �� ���⿡�� with ������ ���� emp,dept ���̺� �̸��� ����ϸ� X
                                �̸��� ª���ؼ� ����ϱ� ���ؼ� ��Ī�� �ش�.

9. �������� ��� Oracle �Լ��� ���� �����ϼ��� .
   ��. NVL(1, 2) -> 1�� ���� null�̸� 0�Ǵ� �ٸ� ������ ��ȯ���ִ� �Լ�
   ��. NVL2(1, 2, 3) -> 1�� ���� null�� �ƴϸ� 2�� ������, null�̸� 3�� ������ ��ȯ���ִ� �Լ�
   ��. UPPER(���ڿ�) -> �ҹ��ڸ� �빮�ڷ� �ٲ��ִ� �Լ�
   ��. TO_CHAR(�÷���, ��¥ǥ����) -> ��¥���� ���ڿ��� ��ȯ���ִ� �Լ�
   ��. EXTRACT(��¥ǥ���� FROM �÷���) -> ��¥���� ���������� ��ȯ���ִ� �Լ�
   ��. CONCAT(1�� ���ڿ�, 2�� ���ڿ�) -> ���ڿ� �������ִ� �Լ�
   ��. SUBSTR(���ڿ�, ��ġ(������ : �ڿ�������), [����]) -> ���ڿ��� ���ϴ� ��ġ���� ���̸�ŭ �߶��ִ� �Լ�
   ��. LIKE()�� REGEXP_LIKE()
   ���

11. insa ���̺��� 70���� ���ڻ���� �Ʒ��� ���� �ֹε�Ϲ�ȣ�� �����ؼ� ����ϼ���.
SELECT name, CONCAT(SUBSTR(ssn, 0, 8), '******') RRN
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d{5}-[13579]\d{6}')
WHERE REGEXP_LIKE(ssn, '^7.{6}[13579]')
 . -> ��� ���� 1����
 \. -> ���� .
ORDER BY RRN ASC;

SELECT name, CONCAT(SUBSTR(ssn, 0, 8), '******') RRN
FROM insa
WHERE REGEXP_LIKE(ssn, '^7') AND MOD(SUBSTR(ssn, -7, 1), 2) = '1'
ORDER BY RRN ASC;

WHERE LIKE '7%'

NAME                 RRN           
-------------------- --------------
�����               721217-1******
���μ�               731211-1******
������               751010-1******
����               760105-1******
���ѱ�               760909-1******
�ּ���               770129-1******
����ȯ               771115-1******
ȫ�浿               771212-1******
�긶��               780505-1******
����ö               780506-1******
�ڹ���               780710-1******
�̻���               781010-1******
������               790304-1******
�ڼ���               790509-1******
�̱��               790604-1******

15�� ���� ���õǾ����ϴ�. 




12. insa ���̺��� 70��� 12���� ��� ��� �Ʒ��� ���� �ֹε�Ϲ�ȣ�� �����ؼ� ����ϼ���.
SELECT name, ssn
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d12')
ORDER BY ssn ASC;

SELECT name, ssn
FROM insa
WHERE ssn LIKE '7_12%'
ORDER BY ssn ASC;

<������>
NAME                 SSN           
-------------------- --------------
�����               721217-1951357
���μ�               731211-1214576
ȫ�浿               771212-1022432


13. LIKE �������� ESCAPE �� ���ؼ� �����ϼ���. + DML�� �ٷ��
- whildcard(% _)�� �Ϲ� ����ó�� ���� ���� ��쿡 ESCAPE �ɼ��� ��� -> o. ���� Ȯ�� ����

��. dept ���̺� ��ȸ
SELECT *
FROM dept;

��. dept ���̺��� ���� Ȯ��
DESC dept;
�̸�     ��?       ����           
------ -------- ------------ 
DEPTNO NOT NULL NUMBER(2)    null�� X �ʼ��� �ԷµǾ����� �Ѵ�. 2�ڸ� ����
DNAME           VARCHAR2(14) 14����Ʈ ���ڿ�
LOC             VARCHAR2(13) 13����Ʈ ���ڿ�

��. ���ο� �μ��� �߰� : DML - INSERT�� + COMMIT
[INSERT�� ����]
INSERT INTO ���̺�� (�÷���..) VALUES (�÷���..);
COMMIT;

INSERT INTO dept (deptno, dname, loc) VALUES (50, 'QC100%T', 'SEOUL');
COMMIT;
-- 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO dept (deptno, dname, loc) VALUES (40, 'QC100%T', 'SEOUL');
<���� �޽���>
ORA-00001: unique constraint (SCOTT.PK_DEPT) violated
�ؼ� :      ���ϼ�  ��������     PK = Primary Key(������ Ű��)    ����  -> �̹� ������ Ű���� �μ���ȣ 40�� �����Ѵ�.
�ذ� : ������ Ű���� �ߺ����� �ʴ� ������ �߰��ϱ�

INSERT INTO dept (deptno, dname, loc) VALUES (100, 'QC100%T', 'SEOUL');
<���� �޽���>
ORA-01438: value larger than specified precision allowed for this column
�ؼ� : �÷����� ������ ���е� ������ �� ū ���� ���Դ�.
�ذ� : ������ ���е� ���� ���� �Ǵ� ���� ������ ���е� ���� �°� ����ֱ�
precision : ���е�(p)

��. �߰� �Ǿ����� Ȯ��
SELECT *
FROM dept;

��. ������ ���� : DML - UPDATE�� + COMMIT
30�� �μ��� �μ����� SALES -> SA%LES�� ����

UPDATE dept
SET dname = 'SA%LES'
WHERE deptno = 30; -- WHERE �������� ������ ��� ��(���ڵ�)�� ������ �ȴ�.
--> WHERE ���� ���ָ� dname�� �� SA%LES�� �ٲ� WHERE ���༭ �� �ٲ���� �� ROLLBACK; �ϸ� �ǵ��ư� �� ����
COMMIT;
-- 1 �� ��(��) ������Ʈ�Ǿ����ϴ�.

[UPDATE ����]
UPDATE ���̺��
SET ������ �÷��� = ���ο� �÷���, ������ �÷��� = ���ο� �÷���, ������ �÷��� = ���ο� �÷���.. -> ������ �൵ ��
[WHERE]

��. ���� �Ǿ����� Ȯ��
SELECT *
FROM dept;

��. 40 �μ��� ���� :DML - DELETE�� + COMMIT / TRUNCATE�� -> �̰� ���߿� 
40	OPERATIONS	BOSTON

DELETE dept
WHERE deptno = 40;
-- 1 �� ��(��) �����Ǿ����ϴ�.
COMMIT;

!!����!! COMMIT�� �ع����� ROLLBACK�� ���� �ʴ´�.

ROLLBACK;

INSERT INTO dept (deptno, dname, loc) VALUES (40, 'OPERATIONS', 'BOSTON');
INSERT INTO dept VALUES (40, 'OPERATIONS', 'BOSTON'); -- (deptno, dname, loc) �� �κ� ������ �� ����
COMMIT;

[DELETE ����]
DELETE FROM ���̺��; -- WHERE ���� ���� ������ ��� ��(���ڵ�) ����
[WHERE]  -- ���ǽ��� ������Ű�� �־�� ���� loc�� �־��� �� �ٸ� �μ��� BOSTON�� ���� �� �ֱ� ������...

��. ����1) dept ���̺��� �μ���(dname)�� '%' ���ڸ� �����ϴ� �μ����� ���
    ��. LIKE ������ ���
SELECT *
FROM dept
WHERE dname LIKE '%\%%' ESCAPE '\';  --> \�� ���� ���ϵ� ī��� �Ϲ� ���ڷ� �ν��ض� ��� ��
                                     --> ESCAPE�� �ִ� ��ȣ�� �ƹ��ų� �൵ �ȴ�. ������, ���ڿ� �ȿ� ���� ��ȣ�� ���!
                                     
    ����2) 50�� �μ� ����
DELETE FROM dept
WHERE deptno = 50;

    ����3) 30�� �μ����� SALES�� ����
UPDATE dept
SET dname = 'SALES'
SET danme = REPLACE(dname, '%', '') --> %�� ���ְڴ�.
WHERE deptno = 30;
COMMIT; -- Ŀ���� �������� �� ���� ����~

-- JAVA "SA%LES".replace("%", "")
- ����Ŭ���� REPLACE('SA%LES', '%' , '') �Լ��� �ִ�.

SELECT *, REPLACE('SA%LES', '%' , '')
���� �޽��� : ORA-00923: FROM keyword not found where expected -> * ���� ,�� �ͼ�..

SELECT dept.*, REPLACE('SA%LES', '%' , '')
FROM dept d -- dept ���̺��� ��Ī�� d�� �ְڴ�. why? ���̺� ���� ��� �ڵ��ϱ� ����� ������ ��Ī�� ��
WHERE dname LIKE '%\%%' ESCAPE '\';

    ����4) dept ���̺��� �μ��� 'r' ���ڿ��� �����ϸ� �μ���ȣ�� 1���� ��Ű�� ���� �ۼ��ϼ���.
       
    UPDATE dept
    SET deptno = deptno + 1
    WHERE dname LIKE UPPER('%r%');
    �����޽��� : ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
    �ؼ� :                 ���Ἲ      ��������      FK(�ܷ�Ű)       ����ȴ�.    �ڽ� ���ڵ��� ã�Ҵ�.
                          �ڽ� ���ڵ��� ���� ���Ἲ ���� ���� FK(�ܷ�Ű)�� ����Ǵ� ���� ã�Ҵ�.
    
    parent           deptno(����)         child
    dept ���̺��� ���� ��������� �� �Ŀ� emp ���̺� ����
    �θ����̺��� deptno                �ڽ����̺��� deptno(FK, �ܷ�Ű)���� ����
    
    ������ ������ ��
    ��ü - ����(������) - ��ü
    �����̼� �Ǵ� ���̺�
    �θ����̺�              �ڽ����̺�
    dept                  emp
    deptno ����Ű(PK)      deptno ����Ű, �ܷ�Ű(FK)               
                          empno ����Ű(PK)


15. insa���̺��� ssn �÷��� ���ؼ� year, month, date, gender ���

SELECT ssn
       , SUBSTR(ssn, 0, 2) year
       , SUBSTR(ssn, 3, 2) MONTH
       , SUBSTR(ssn, 5, 2) "DATE" -- date�� ��¥�ڷ��� ��, Ű����(�����)�̴�.
       , SUBSTR(ssn, -7, 1) GENDER
FROM insa;

16. emp ���̺��� �Ի�⵵ �÷����� ��,��,�� ã�Ƽ� ���
    ��. �⵵ ã�� ���� TO_CHAR() �Լ� ���
    ��. �� ã�� ���� SUBSTR() �Լ� ���
    ��. �� ã�� ���� EXTRACT() �Լ� ���

SELECT hiredate
        , TO_CHAR(hiredate, 'YYYY') "YEAR"
        , SUBSTR(hiredate, 4, 2) "MONTH"
        , EXTRACT(DAY FROM hiredate) "DATE"
FROM emp
ORDER BY hiredate ASC;

<RR�� YY ��ȣ�� ������>
    '97/01/12'           '03/12/21'
RR  1997/01/12          2003/12/21 -> RR�� ���簡 21���� 2000����̸� ���� 50��~����49�⿡�� 1900���� ���ϰ� 
YY  2097/01/12          2003/12/21  -> YY�� ���� 21���� 2000��븦 �����༭ ����ϴ� ���̰�

����) ���� �ý����� ��¥/�ð� ������ ������
����Ŭ : SYSDATE �Լ�

- 2000��� / 21����
SELECT SYSDATE, TO_CHAR(SYSDATE, 'CC') -- CC�� ����
FROM dept;
      
23. hr �������� ����
employees ���̺��� first_name, last_name �̸� �ӿ� 'ev' ���ڿ� �����ϴ� ��� ���� ���
    
FIRST_NAME           LAST_NAME                 NAME                                           NAME                                                                                                                                                                                    
-------------------- ------------------------- ---------------------------------------------- ------------------
Kevin                Feeney                    Kevin Feeney                                   K[ev]in Feeney                                                                                                                                                                          
Steven               King                      Steven King                                    St[ev]en King                                                                                                                                                                           
Steven               Markle                    Steven Markle                                  St[ev]en Markle                                                                                                                                                                         
Kevin                Mourgos                   Kevin Mourgos                                  K[ev]in Mourgos     
                                                                                                                                                  
 
 -----------------------------------------------------------------------------------------
��������! - ���� �� ���ο� ����

SELECT *
FROM dept;

DESC dept;
 
����1) 50�� �μ��� �Ƹ��ٿ� �μ�, ���� �߰�
 
INSERT INTO dept(deptno, dname, loc) VALUES (50, '�Ƹ��ٿ�μ�', '����');
���� ���� -
���� �޽��� : ORA-12899: value too large for column "SCOTT"."DEPT"."DNAME" (actual: 18, maximum: 14)
���� : dname�� ���� ���� �ʹ� ũ��. 
�ѱ��� 1���ڿ� 3����Ʈ�� 6���ڴ� 18����Ʈ

VSIZE() �Լ� - ������ ����Ʈ�� �˷��ִ� �Լ�
SELECT VSIZE('��') -- 3����Ʈ
       , VSIZE('�Ƹ��ٿ�μ�') -- 18����Ʈ
       , VSIZE('a') -- ���ĺ���ҹ��ڴ� 1����Ʈ
FROM dual;

����2) dept ���̺� 40,50,60,70 �μ��� ����
DELETE FROM dept WHERE deptno = 40;
DELETE FROM dept WHERE deptno = 50;
DELETE FROM dept WHERE deptno = 60;
DELETE FROM dept WHERE deptno = 70;
COMMIT;
--
DELETE FROM dept
WHERE deptno = 40 OR deptno = 50 OR deptno = 60 OR deptno = 70;
COMMIT;
--
DELETE FROM dept
WHERE deptno IN (40, 50, 60, 70);
--
DELETE FROM dept
WHERE deptno BETWEEN 40 AND 70;

-- NVL(), NVL2() ����ϴ� ����
����3) insa ���̺��� ����ó(tel)�� ���� ����� '����ó ��� �ȵ�' ���
SELECT num, name, tel
        , NVL(tel, '����ó ��� �ȵ�') ����ó
FROM insa
WHERE tel IS NULL;

����4) insa ���̺��� num, name, tel �÷� ����� �� ����ó(tel) ���� ����� X�� ����ϰ�, �ִ� ����� O ���
    ����) ���ߺθ� ���

SELECT num, name, tel, buseo
        ,NVL2(tel, 'O', 'X')
FROM insa
WHERE buseo = '���ߺ�';

----------------------------------------------------
���� ���� �κ�~

[����Ŭ ������]
[����Ŭ �ڷ���]
[����Ŭ �Լ�]


[����Ŭ ������]
1. �� ������
    1) WHERE������ ���! ����, ����, ��¥�� ũ�⳪ ������ ���ϴ� ������ - true, false, null�� ��ȯ
    2) ���� : > >= < <= != <> ^= =  (ANY, SOME, ALL�� �������� �ڼ��ϰ� ��ﶧ �ٽ�!)
    -- SELECT 3 > 5 -- MS SQL�� ���� �ȳ��µ� ����Ŭ�� ������ FROM�� ���� �־�� ��!
    3) LOB �ڷ����� �񱳿����ڸ� ����� �� ������, PL/SQL������ CLOB �ڷ����� �����͸� ���� �� �ִ�. -> �ڷ��� ������ �� �ٽ�!

2. �� ������
    1) WHERE������ ���! true, false, null�� ��ȯ
    2) ���� : AND OR NOT 
    
3. SQL ������
    1) [NOT] IN (list)
    2) [NOT] BETWEEN a AND b
    3) [NOT] LIKE
    4) IS [NOT] NULL
    5) ANY, SOME, ALL�� SQL ������ + �� ������ -> ���߿� �ٽ� �ڼ��� ����
    6) EXISTS SQL ������  - WHERE (���(��ȣ����, Correlated) �������� ���� �����ϸ� true ��ȯ) -> ���߿� �ٽ� �ڼ��� ����
        ex) where EXISTS (select 'x' from dept 
                         where deptno=p.deptno);
       [NOT] EXISTS == [NOT] IN -> EXISTS ���� ��� IN ������ ����ؼ� ǥ���� ���� �ִ�.

4. NULL ������
    1) ���� : IS NULL, IS NOT NULL
    
5. ���� ������
    1) ���� : ||    - �Լ��δ� CONCAT()
    
6. ��� ������
    1) ���� : + - * /   ->  ������ ���ϴ� ���� �Լ� - MOD()


SELECT 5 + 3
       , 5 - 3
       , 5 * 3
       , 5 / 3
       , MOD(5, 3)
FROM dual;

SELECT 5 / 0
FROM dual;
���� �޽��� : ORA-01476: divisor is equal to zero
�ؼ� : 0���� ������ ���� �߻�

SELECT 5.0 / 0
FROM dual;
���� �޽��� : ORA-01476: divisor is equal to zero
�ؼ� : 0���� ������ ���� �߻�

SELECT MOD(5, 0) -- 5
      , MOD(5.0, 0) -- 5
FROM dual;

- ������ ���ϴ� �Լ��� ������ MOD �ۿ� ���ٰ� ��������
SELECT MOD(5,2)
       , REMAINDER(5, 2)
FROM dual;

- FLOOR() �Լ��� ROUND() �Լ��� ������
-- MOD : n2 - n1 * FLOOR (n2 / n1)  -> �����Լ�
-- REMAINDER : n2 - n1 * ROUND (n2 / n1) -> �ݿø��Լ�

7. SET(����) ������
    1) UNION ������     - ������
SELECT deptno, empno, ename, job
FROM emp
WHERE deptno = 20
UNION
SELECT deptno, empno, ename, job
FROM emp
WHERE job = 'MANAGER';
-- 3�� : deptno = 20
20	7369	SMITH	CLERK
20	7566	JONES	MANAGER
20	7902	FORD	ANALYST

-- 3�� : job = MANAGER
20	7566	JONES	MANAGER
30	7698	BLAKE	MANAGER
10	7782	CLARK	MANAGER

-- ���� 2���� ����� ��ģ ���(������)
-- 5�� : UNION ���
10	7782	CLARK	MANAGER
20	7369	SMITH	CLERK
20	7566	JONES	MANAGER
20	7902	FORD	ANALYST
30	7698	BLAKE	MANAGER



    2) UNION ALL ������ - ������ + ALL
    3) INTERSECT ������ - ������
    4) MINUS ������     - ������

-------------------------------------------
(6. ��������� �ٷ� �� ���� �����...)
[***** dual �̶�? *****]
1) SYS ������ ������ �����ϰ� �ִ� ���̺�(table)�̴�. = ����Ŭ ǥ�� ���̺�
2) ��(���ڵ�) 1��, ��(�÷�) 1���� dummy ���̺�
DESC dual;
DUMMY    VARCHAR2(1)   - DUMMY �÷� ����1����Ʈ

3) �Ͻ������� ��¥����, ��������� �� �� ���� ���
SELECT CURRENT_DATE
FROM dual;
-- 22/04/07

SELECT CURRENT_TIMESTAMP
FROM dual; -- timestamp�� �� ���� ������ ������ �ִ�.
-- 22/04/07 16:16:31.337000000 ASIA/SEOUL

4) ��Ű��.���̺��(sys.dual) -> PUBLIC �ó��(synonym) �����߱� ������ ���̺�� �ٷ� �Ἥ ����� �� �ִ�.
SELECT SYSDATE, CURRENT_DATE -- ���� �ý����� ��¥ ���� : 22/04/07	22/04/07
FROM sys.dual; -- ������ �̷���(��Ű��.���̺��) ����ϴµ� SYS ����(�����)�� ��� ����ڵ鿡�� ����� �� �ֵ��� �� ���̺� PUBLIC.synonym�� �־���..

5) dual ���̺��� ����Ŭ ��ġ�ϸ� �ڵ����� ��������� ���̺��̴�.

����Ŭ �Լ� : SQRT() ��Ʈ ���ϴ� �Լ�
SELECT SQRT(4)
FROM dual;

-------------------------------------------
[�ó��(synonym) �̶�?]
1. HR ����, SYS �����ؼ� �Ʒ� �ڵ�...
SELECT *
FROM emp;

- HR�� emp ���̺� ����� �� �ִ� ������ �ο� �ް� scott�̳� sys���� �ο������� �ȴ�. �ñ������� �������� scott���� �޴°� ����.
- ��Ű��.���̺��(scott.emp)�� �ڵ��ؾ� ����� �� �ִ�.

1) ��ü�� ��ȸ�� �� ���� 2)�� ó�� �ڵ��ϴ� ���� ���ŷο� ���̴�. �׷��� �ó��(synonym)�� ���Դ�~

2) '�ó���� �ϳ��� ��ü�� ���� �ٸ� �̸��� �����ϴ� ���'
    -> ��Ű��.���̺�� �̰��� �ٸ� �̸����� �����ϰ� �����ϴ� ���� �ó��

3) �ó���� DB ��ü���� ����� �� �ִ� ��ü

4) �ó���� ����
- PRIVATE �ó�� - �����ڸ� ����
- PUBLIC �ó�� - ��� ����ڰ� ����

5) �ó���� ����
    [����]
    - PUBLIC�� �����ϸ� PRIVATE �ó���� ��
	CREATE [PUBLIC] SYNONYM [schema.]synonym��
  	FOR [schema.]object��;
    
- PUBLIC �ó���� ��� ����ڰ� ���� �����ϱ� ������ ���� �� ������ ���� DBA���� �� �� �ִ�.

- PUBLIC �ó���� ���� ����
(1) SYSTEM / SYS �������� �����Ѵ�. - SYS ����
(2) PUBLIC �ɼ��� ����Ͽ� �ó���� �����Ѵ�. - SYS ����
(3) ������ �ó�Կ� ���� ��ü �����ڷ� �����Ѵ�. - SCOTT ����(������)
(4) �ó�Կ� ������ �ο��Ѵ�. - SCOTT ����(������)

GRANT SELECT ON emp TO HR; -- emp ���̺��� HR ������ SELECT �� �� �ֵ��� ���� �ο�
-- Grant��(��) �����߽��ϴ�.

6) �ó�� ������ DBA�� ���� -> SYS ���� ����

--------------------------------------------------------------------------------










