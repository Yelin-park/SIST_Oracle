-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]
---- �������� ----

1. �̹� �� 1�� ���� ������ ������ �Ʒ��� ���� ��� 
     ( LEVEL �ǻ��÷� ��� )
������) 
  ��¥	       ����    ����(IW)
21/11/01	��	44
21/11/02	ȭ	44
21/11/03	��	44
21/11/04	��	44
21/11/05	��	44
21/11/06	��	44 
 :
21/11/29	��	48
21/11/30	ȭ	48


SELECT dates, TO_CHAR(dates, 'DY'), TO_CHAR(dates, 'IW')
FROM(
    SELECT TO_DATE('202111', 'YYYYMM') + LEVEL - 1 dates
    FROM dual
    CONNECT BY LEVEL <= EXTRACT( DAY FROM LAST_DAY( TO_DATE('202111', 'YYYYMM') ) )
) t;
 

 2-1.  �Ʒ��� ���� ���� ������ ����ϴ� ���� �ۼ�  ( �������� ���ǹ�)
������)
NAME		LEVEL   empno	mgr
------------------------------------
KING		1	7839	null
   JONES	2	7566	7839         
      FORD	3	7902	7566
         SMITH	4	7369	7902     
   BLAKE	2	7698	7839
      ALLEN	3	7499	7698
      WARD	3	7521	7698
      MARTIN	3	7654	7698
      TURNER	3	7844	7698
      JAMES	3	7900	7698
   CLARK	2	7782	7839
      MILLER	3	7934	7782
    
SELECT LPAD(' ', 3*LEVEL-3) || ename
    , LEVEL, empno, mgr    
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;


2-2. ���� JONES �������� �����ϴ� ���� �ۼ�. 
������)
NAME		LEVEL   empno	mgr
------------------------------------
KING		1	7839	null
   BLAKE	2	7698	7839
      ALLEN	3	7499	7698
      WARD	3	7521	7698
      MARTIN	3	7654	7698
      TURNER	3	7844	7698
      JAMES	3	7900	7698
   CLARK	2	7782	7839
      MILLER	3	7934	7782


SELECT LPAD(' ', 3*LEVEL-3) || ename
    , LEVEL, empno, mgr 
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr AND ename != 'JONES';



3.  MERGE : ���� , ���� ���̺��� ������ �ٸ� ���̺� ����(�߰�)

CREATE TABLE tbl_merge1
(
   id      number Primary key
   , name  varchar2(20)
   , pay  number
   , sudang number
);

CREATE TABLE tbl_merge2
(
   id      number Primary key 
   , sudang number
);

INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (1, 'a', 100, 10);
INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (2, 'b', 150, 20);
INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (3, 'c', 130, 0);
    
INSERT INTO tbl_merge2 (id, sudang) VALUES (2,5);
INSERT INTO tbl_merge2 (id, sudang) VALUES (3,10);
INSERT INTO tbl_merge2 (id, sudang) VALUES (4,20);



SELECT * FROM tbl_merge1;
1	a	100	10
2	b	150	20
3	c	130	0

SELECT * FROM tbl_merge2;
2	5
3	10
4	20

COMMIT;

MERGE INTO tbl_merge1 m1
USING (SELECT id, sudang FROM tbl_merge2) m2
ON (m2.id = m1.id)
WHEN MATCHED THEN
    UPDATE SET m1.sudang = m1.sudang + m2.sudang
WHEN NOT MATCHED THEN
    INSERT (m1.id, m1.sudang) VALUES (m2.id, m2.sudang);


4. ��������( Contratrint ) 
  ��. ���������̶� ?    
       ������ ���Ἲ�� ���ؼ� ���̺� ���ڵ带 �߰�, ����, ������ �� ����Ǵ� ��Ģ
       
  ��. ���������� �����ϴ� 2���� ����� ���� �����ϼ���.
    CREATE TABLE ���̺� ������ ��
    ALTER TABLE ���̺� ������ ��
  
  ��. ���������� 5���� ���� 
      PRIMARY KEY ����Ű(PK)
      FOREIGN KEY ����Ű(FK)
      NOT NULL NN
      UNIQUE ���ϼ�(UK)
      CHECK C
        
  ��. emp ���̺��� �������� Ȯ�� ���� �ۼ� 
     SELECT *
     FROM user_constraints
     WHERE table_name = UPPER('emp');
     
  ��. ������ ���Ἲ ���� �� ����
  ��ü ���Ἲ - PK�� ������ �÷��� �ߺ��� �� ��� X
  ���� ���Ἲ - �θ� ���̺� �ڽ� ���̺��� �����Ǿ��ִ°�� �θ����̺��� ������ �� X
  ������ ���Ἲ - �÷����� ��� ������ ���� ������ �����ϱ� ���� ���������̴�.
  

5. �Ʒ� ���̺� ���� ���� ���� [�÷� ����] ������� 
   ��. deptno �� PK �� ����
   ��. dname�� NN �� ����
CREATE TABLE tbl_dept
(
    DEPTNO  NUMBER(2) CONSTRAINTS pk_tbldept_deptno PRIMARY KEY   
   , DNAME VARCHAR2(14) NOT NULL  
   , LOC   VARCHAR2(13)      
);

6. �Ʒ� ���̺� ���� ���� ���� [���̺� ����] ������� 
   ��. deptno �� PK �� ����
   ��. dname�� NN �� ����     
   
CREATE TABLE tbl_dept
(
    DEPTNO  NUMBER(2) 
   , DNAME VARCHAR2(14) 
   , LOC   VARCHAR2(13)
   , CONSTRAINTS pk_tbldept_deptno PRIMARY KEY(deptno)
   , CONSTRAINTS nn_tbldept_dname NOT NULL(dname)

);

DROP TABLE tbl_dept;

DESC tbl_dept;

7. tbl_dept ���̺��� ���� �� [��� �������� ����]�ϴ� ���� �ۼ�  
ALTER TABLE tbl_dept
DROP CONSTRAINTS pk_tbldept_deptno;

ALTER TABLE tbl_dept
DROP NOT NULL;


8. ALTER TABLE ���� ����ؼ� PK �������� ����. 

ALTER TABLE tbl_dept
ADD CONSTRAINTS pk_tbldept_enpno PRIMARY KEY(empno);


9. UK ���� ���� ���� ���� �ۼ�
   ��) tbl_member���̺�  tel �÷��� UK_MEMBER_TEL �̶� �������Ǹ�����
     UNIQUE ���� ������ ������ ��� 
     
     ALTER TABLE tbl_member
     DROP CONSTRAINTS UK_MEMBER_TEL;

10. FK ���� ���� ���� �� �Ʒ� �ɼǿ� ���� �����ϼ���
   CONSTRAINT FK_TBLEMP_DEPTNO FOREIGN KEY ( deptno ) 
                                REFERENCES tbl_dept(deptno )
                                
   ��. ON DELETE CASCADE 
   �θ� ���̺��� �����ϸ� �ڽ� ���̺����� ����
   
   ��. ON DELETE SET NULL 
   �θ����̺��� �����ϸ� �ڽ����̺� null�� �ٲ�
   
--------------------------------------------------------------------------------------------------
[���ο� ����!!!]
1. [ JOIN(����) ]

1) å(book) ���̺� ����
CREATE TABLE book(
       b_id     VARCHAR2(10)  NOT NULL PRIMARY KEY -- åID
      ,title      VARCHAR2(100) NOT NULL -- å����
      ,c_name  VARCHAR2(100) NOT NULL -- ������
);
-- Table BOOK��(��) �����Ǿ����ϴ�.

2) å�� �ܰ�(danga) ���̺� ����
CREATE TABLE danga(
      b_id  VARCHAR2(10)  NOT NULL -- åID
      ,price  NUMBER(7) NOT NULL -- å����
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)  -- ����Ű�̸鼭
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id) -- ����Ű(�ܷ�Ű)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- ORA-00942: table or view does not exist
-- �θ� ���̺��� book ���̺� ������ ���� �ʾƼ� ���� �߻�
-- Table DANGA��(��) �����Ǿ����ϴ�.

3) ��(gogaek) ���̺� ���� -- ����
CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY -- ��ID
      ,g_name   VARCHAR2(20) NOT NULL -- ����
      ,g_tel      VARCHAR2(20) -- ������ó
);
-- Table GOGAEK��(��) �����Ǿ����ϴ�.

4) �Ǹ�(panmai) ���̺�
CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY -- �ǸŹ�ȣ(����) ���� seq��� ���� ��
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID -- �����̺��� ��ID�� FK
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID -- å���̺��� åID FK
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE -- �Ǹų�¥
      ,p_su       NUMBER(5)  NOT NULL -- �Ǹż���
);
-- Table PANMAI��(��) �����Ǿ����ϴ�.

5) ���� ���̺�
CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY -- ����ID
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID -- åID ����
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL -- ���ڸ�
);
-- Table AU_BOOK��(��) �����Ǿ����ϴ�.

INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '�����ͺ��̽�', '����');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '�����ͺ��̽�', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '�ü��', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '�ü��', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '����', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '����', '�뱸');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '�Ŀ�����Ʈ', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '������', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '������', '����');

INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

-- ���ǻ簡 ����(��)���� �Ǹ�
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '�츮����', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '���ü���', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '��������', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '���Ｍ��', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '��������', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '��������', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '���ϼ���', '777-7777');

INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '���Ȱ�');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '�տ���');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '�����');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '���ϴ�');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '�ɽ���');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '��÷');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '���ѳ�');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '�̿���');

COMMIT;

SELECT * FROM book;
SELECT * FROM danga;
SELECT * FROM gogaek;
SELECT * FROM panmai;
SELECT * FROM au_book;

------
1. [ EQUI JOIN(== Natural JOIN) ]
    - �� �� �̻��� ���̺� [����Ǵ� �÷����� ���� ��ġ]�ϴ� ��쿡 ���Ǵ� ����

����1) å ID, å ����, ���ǻ�(c_name), å�ܰ� �÷��� ��ȸ(���)
    BOOK : b_id, title, c_name
    DANGA : price
    ����1) price �÷��� book ���̺� �߰��� �ص� ������ ���� ���� �� ������ �ܰ� ���̺��� �� ���� ���������?
         �ܰ��� �ٲ� �� �ֱ� ������
         
    book(PK)             danga
    b_1  1��   <- == ->   b_1(FK, PK) price
    > å�� 1���� �ش��ϴ� å ������ ã�ƿ´�

��) book, danga ��ü ���
    SELECT book.b_id, title, c_name, price
    FROM book, danga
    WHERE book.b_id = danga.b_id; -- �񱳿�����(=) ����߱⿡ EQUI JOIN
    
��) book b, danga d ��Ī ���
    SELECT b.b_id, title, c_name, price
    FROM book b, danga d
    WHERE b.b_id = d.b_id;

��) book b, danga d ***
    SELECT b.b_id, b.title, b.c_name, d.price
    FROM book b, danga d
    WHERE b.b_id = d.b_id;

��) JOIN ~ ON ���� ��� ***
    SELECT b.b_id, b.title, b.c_name, d.price
    FROM book b JOIN danga d ON b.b_id = d.b_id; 
    
��) USING �� ��� -- ����� �� ����
    SELECT b_id, title, c_name, price
    FROM book JOIN danga USING(b_id);

��) NATURAL JOIN ���� ��� -- ����� �� ����
    SELECT b_id, title, c_name, price
    FROM book NATURAL JOIN danga;

--    
����2) KING ����� �μ��� Ȯ�� �� null�� ����

SELECT *
FROM emp
WHERE ename = 'KING';

UPDATE emp
SET deptno = null
WHERE empno = 7839;

COMMIT;
<������ - ������>
deptno = 10 -> null

--
����3) dept, emp�� �����ؼ�
    empno, deptno, dname, ename, hiredate �÷� ��ȸ

��) JOIN ~ ON ����
SELECT empno, e.deptno, dname, ename, hiredate
FROM emp e JOIN dept d ON e.deptno = d.deptno;

��) USING �� ���
SELECT empno, deptno, dname, ename, hiredate
FROM emp JOIN dept USING (deptno);

��) ��Ī ���
SELECT empno, e.deptno, dname, ename, hiredate
FROM emp e, dept d
WHERE e.deptno = d.deptno;

������) KING ����� ��µ��� �ʴ´�. -> EQUI JOIN�̱� ������ �߻�

--
����4) åID, å����, �Ǹż���, �ܰ�, ������(��), �Ǹűݾ�(�Ǹż��� * �ܰ�) ��ȸ

Ǯ��1) ��Ī ���
SELECT b.b_id, title, p_su, price, g_name, p_su * price �Ǹűݾ�
FROM book b, panmai p, danga d, gogaek g
WHERE b.b_id = p.b_id AND b.b_id = d.b_id AND p.g_id = g.g_id;

Ǯ��2) JOIN ON ���� ���
SELECT b.b_id, title, p_su, price, g_name, p_su * price �Ǹűݾ�
FROM book b JOIN panmai p ON b.b_id = p.b_id
            JOIN danga d ON b.b_id = d.b_id
            JOIN gogaek g ON p.g_id = g.g_id;

--            
����5) ���ǵ� å���� ���� �� ����� �ǸŵǾ����� ��ȸ
        åID, å����, ���ǸűǼ�, �ܰ� �÷� ���

SELECT b.b_id, title, SUM(p_su), price
FROM book b JOIN panmai p ON b.b_id = p.b_id
            JOIN danga d ON b.b_id = d.b_id
GROUP BY b.b_id, title, price
ORDER BY b.b_id;
-- ORA-00979: not a GROUP BY expression

������������� Ǯ���)
SELECT b.b_id, title, SUM(SELECT p_su FROM panmai WHERE b.b_id = panmai.b_id), price
FROM book b JOIN panmai p ON b.b_id = p.b_id
            JOIN danga d ON b.b_id = d.b_id
GROUP BY b.b_id
ORDER BY b.b_id;

--
����6) ������ å�� ��ü �Ǹŷ��� �� �ۼ�Ʈ�� �ش�Ǵ��� ���

SELECT b.b_id
    , title, price
    , SUM(p_su) bid_qty
    , (SELECT SUM(p_su) FROM panmai) total_qty
    , ROUND(SUM(p_su) / (SELECT SUM(p_su) FROM panmai) * 100 , 2) per
FROM panmai p JOIN book b ON p.b_id = b.b_id
              JOIN danga d ON b.b_id = d.b_id
GROUP BY b.b_id, title, price
ORDER BY per DESC;


���� Ǭ ��)
SELECT t.*, ROUND(������å / (SELECT SUM(p_su) FROm panmai) * 100, 2) �Ǹ��ۼ�Ʈ
    FROM(
        SELECT b.b_id, title, SUM(p_su) ������å , price
        FROM book b JOIN panmai p ON b.b_id = p.b_id
                    JOIN danga d ON b.b_id = d.b_id
        GROUP BY b.b_id, title, price
) t;

+ ����) ���� n% ����ض�

--
����7) book ���̺��� �ǸŰ� �� ���� ����/�ִ� å���� ������ ��ȸ --> OUTER JOIN�� ����ؼ� Ǯ� �ȴ�. ���� �ȹ��
        b_id, title, price �÷� ���
        
�Ǹŵ� ���� �ִ� å)      
    Ǯ��1)
    SELECT DISTINCT b.b_id, title, price
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON b.b_id = p.b_id;       

    Ǯ��2)
    SELECT DISTINCT b.b_id, title, price
    FROM book b JOIN danga d ON b.b_id = d.b_id
    WHERE b.b_id IN(SELECT DISTINCT b_id FROM panmai);
    
    Ǯ��3) ���� ���� �ڵ� X
    WITH a AS(
        SELECT DISTINCT b_id
        FROM panmai
    ),
    b AS(
        SELECT b.b_id, title, price
        FROM book b JOIN danga d ON b.b_id = d.b_id
    )
    SELECT b.b_id, title, price
    FROM a JOIN b ON a.b_id = b.b_id;   
    
    Ǯ��4)
    SELECT b.b_id, title, price
    FROM book b JOIN ( SELECT DISTINCT b_id FROM panmai) p ON b.b_id = p.b_id
                JOIN danga d ON b.b_id = d.b_id;
    
�Ǹŵ� ���� ���� å)
    SELECT DISTINCT b.b_id, title, price
    FROM book b JOIN danga d ON b.b_id = d.b_id
    WHERE b.b_id NOT IN(SELECT DISTINCT b_id FROM panmai); 

--
����8) ���� ���� �ǸŰ� �� å�� ������ ��ȸ

Ǯ��1) TOP-N ���, ROWNUM �ǻ��÷� ���
    SELECT t.*, ROWNUM
    FROM(   
        SELECT b.b_id, title, price, SUM(p_su) qty
        FROM book b JOIN danga d ON b.b_id = d.b_id
                    JOIN panmai p ON b.b_id = p.b_id
        GROUP BY b.b_id, title, price
        ORDER BY qty DESC
    ) t
    WHERE ROWNUM = 1; 


Ǯ��2) RANK �Լ� ���

SELECT t.*
FROM(
        SELECT b.b_id, title, price, SUM(p_su) qty
            , RANK() OVER(ORDER BY SUM(p_su) DESC ) qty_rank
        FROM book b JOIN danga d ON b.b_id = d.b_id
                    JOIN panmai p ON b.b_id = p.b_id
        GROUP BY b.b_id, title, price
        ORDER BY qty DESC
) t
WHERE qty_rank = 1;

����9) ���� ���� �ǸŰ� �� å�� ������ ��ȸ -- OUTER JOIN �ʿ�

�Ʒ��� ���� �ۼ��� ���� �Ǹŵ� å �߿� ���� ���� �ǸŰ� �� å���� �������� ��
SELECT t.*
FROM(
        SELECT b.b_id, title, price, SUM(p_su) qty
            , RANK() OVER(ORDER BY SUM(p_su) DESC ) qty_rank
        FROM book b JOIN danga d ON b.b_id = d.b_id
                    JOIN panmai p ON b.b_id = p.b_id
        GROUP BY b.b_id, title, price
        ORDER BY qty DESC
) t
WHERE qty_rank = 1;

--
����10) �� �ǸűǼ��� 10�� �̻� �Ǹŵ� å�� ���� ��ȸ
       å ID, ����, ����, ���Ǹŷ� �÷� ��ȸ
      
SELECT b.b_id, title, price, SUM(p_su) qty
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
GROUP BY b.b_id, title, price
HAVING SUM(p_su) >= 10;

---------------
2. [ NON-EQUI JOIN ]
    - ����Ǵ� �÷��� ��Ȯ�� ��ġ���� �ʴ� ��쿡 ���Ǵ� JOIN�� �����̴�.
    - WHERE ���� �񱳿�����(=) ��� X, BETWEEN ... AND ... �����ڸ� ����Ѵ�.
    - ����Ŭ������ ON ���� �̿��Ͽ� NON-EQUI JOIN�� ������ ������ �Ѵ�.

    SELECT empno, sal, losal || '~' || hisal, grade
    FROM emp e JOIN salgrade s ON e.sal BETWEEN losal AND hisal;

----------------
+ (���) ��������� �߿� ����������
  (�װ���) ���� ������ 3 + 5

? (���) ���ǿ�����
  (�װ���) ���� ������ 

3. INNER JOIN �� OUTER JOIN
    1) INNER JOIN == EQUI JOIN�� ��� ����
     - �� �̻��� ���̺��� JOIN ������ �����ϴ� �ุ ��ȯ
     - �⺻�� INNER JOIN
     
    SELECT b.b_id, title, price, SUM(p_su) qty
    FROM book b INNER JOIN danga d ON b.b_id = d.b_id
                INNER JOIN panmai p ON b.b_id = p.b_id
    GROUP BY b.b_id, title, price
    HAVING SUM(p_su) >= 10;
    
    2) OUTER JOIN ***
    - JOIN ������ �������� �ʴ� ���� ���� ���� �߰����� join�� �����̴�.
    - �Ϲ����� JOIN���� ���� �� ���� �����͸� ���ϰ� ���� �� ����ϸ�, '(+)' �����ڸ� ����Ѵ�.
    - FULL OUTER JOIN�� ���� �������� UNION�� �̿��� ����� ������ ����� ��´�.
    - OUTER JOIN 3���� ����
        ��. LEFT [OUTER] JOIN - ���� ���̺��� ������ ������ �ϰڴ�
        ��. RIGHT [OUTER] JOIN - ������ ���̺��� ������ ������ �ϰڴ�.
        ��. FULL [OUTER] JOIN - ��� ���̺��� ������ ������ �ϰڴ�.
    
    ��) emp ���̺� KING�� deptno = null
        dept ���̺��� deptno�� 10/20/30/40�� ����
        ���� king�� ������ ����
        -> OUTER JOIN�� ����ϸ� ���� �� �ִ�.
    
    SELECT empno, ename, NVL(dname, '�μ�����')
    FROM emp e LEFT JOIN dept d ON e.deptno = d.deptno;
    
    SELECT empno, ename, NVL(dname, '�μ�����')
    FROM dept d RIGHT JOIN emp e ON e.deptno = d.deptno;

    -- (+) �����ڸ� ����Ϸ��� �ش��ϴ� ���̺��� �÷��� �ٿ��� �Ѵ�.
    SELECT empno, ename, NVL(dname, '�μ�����')
    FROM emp e JOIN dept d ON e.deptno = d.deptno(+);
    
    SELECT empno, ename, NVL(dname, '�μ�����')
    FROM emp e JOIN dept d ON d.deptno(+) = e.deptno;
    
    SELECT empno, ename, NVL(dname, '�μ�����')
    FROM dept d JOIN emp e ON e.deptno = d.deptno(+);
    
    SELECT empno, ename, NVL(dname, '�μ�����')
    FROM dept d JOIN emp e ON d.deptno(+) = e.deptno;
    
    -- FULL OUTER JOIN
    SELECT empno, ename, NVL(dname, '�μ�����')
    FROM emp e FULL JOIN dept d ON e.deptno = d.deptno;

--
����1) �� �μ��� ����� ��ȸ(���)
      10 2
      20 3
      30 6
      40 0

SELECT d.deptno, COUNT(e.deptno) �μ����� -- COUNT(*)�� NULL �����̱� ������ X
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno;

      10 2
      20 3
      30 6
      40 0
      �μ����� 0

SELECT d.deptno, COUNT(e.ename) �μ����� -- COUNT(*)�� NULL �����̱� ������ X
FROM emp e FULL JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno;    


OUTER JOIN ���-              
�Ǹŵ� ���� ���� å) 

    SELECT b.b_id, title, p_su, price
    FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id -- LEFT OUTER JOIN
                JOIN danga d ON b.b_id = d.b_id -- INNER JOIN == EQUI JOIN
    WHERE p_su IS NULL;
    
���� ���� �ǸŰ� �� å�� ������ ��ȸ
SELECT t.b_id, t.title, t.p_su, t.price
FROM(
    SELECT b.b_id, title, p_su, price
            , RANK() OVER(ORDER BY NVL(p_su, 0)) rn
    FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
                     JOIN danga d ON b.b_id = d.b_id
) t
WHERE t.rn = 1;
    
------------------      
4. ������ JOIN 3����
? CROSS JOIN :
Cartesian Product�� ������ ����� ����.
�� cartesian product�� �ſ� ���� ���� �����ϹǷ� "���� �幰�� ���"�ȴ�.
�� ���̺� ���� 100���� ���� ������ �ִٸ�, 10000���� cartesian product ����� �����Ǳ� �����̴�.

12 * 4 = 48 �������� �� ������ �ȴ�.
SELECT e.*, d.*
FROM emp e, dept d;

? ANTIJOIN : �������� + NOT IN ������ ���
���������� ��� �ӿ� �ش� �÷��� �������� �ʴ� ���� NOT IN�� �����

? SEMIJOIN : �������� + EXISTS ������ ���
���������� ��� �ӿ� �ش� �÷��� �����ϴ� ���� EXISTS�� �����


        
        
        
        
        
        
        
        
        
        
        
        
        
        
