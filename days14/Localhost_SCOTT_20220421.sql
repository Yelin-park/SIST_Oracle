-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]
5) ����ȭ(Normal From) ����
    (1) ��1����ȭ(1NF)
        - �����̼ǿ� ���� '��� �Ӽ��� ������(�÷� ��)�� ���� ��(atomic value) (= �ߺ��� ���� ���� ��)���θ� ����'�Ǿ� ������
          ��1�������� ���Ѵ�.
        - �ݺ��Ǵ� �Ӽ��� ������ �� �⺻ ���̺��� �⺻ �÷��� �߰��� ���ο� ���̺��� �����Ѵ�.
        
    (2) ��2����ȭ(2NF)
        - '�κ� �Լ��� ���Ӽ� ����'�ؼ� ���� �Լ� �������� ����� ��
        - ��� �÷�(�Ӽ�)�� ����Ű ��ü�� �������̾���Ѵ�.
        
        * �Լ��� ���Ӽ� ���� : �׻� �Ӽ��� ���� ���� �ϳ��� �����Ǿ����� �� Y�� X�� �Լ��� �����̶�� �Ѵ�.(X -> Y)
                            ex) dname�� deptno�� �Լ��� ����, loc�� deptno�� �Լ��� ����
                            X�� ������, Y(dname) Z(loc) �� ������
                            
        * '�κ� �Լ��� ���Ӽ� ����'
         - ����Ű�� ��ü������ �������� �ʴ� �Ӽ�. '��, ����Ű �� �� ������ �������� ��'
            ex) �а� ��� ���̺�
                �й� + �����ڵ� => ����Ű
                �й�  �����ڵ�    ���ڵ�    ������     �����Ⱓ
                100   A001         A       Java     1����
                100   A002         F       ASP      3����
                101   A001         A       Java     1����
                101   A003         B       C#       1����
                100   A001         A       Java     1����
             > ������� �����Ⱓ �Ӽ��� ����Ű�� ���������� �ʰ�, �����ڵ� �Ӽ��� �κ� �Լ��� ���Ӽ��� �ִ�.
             > ������� �����Ⱓ �Ӽ��� �����ϴ� ��(=�κ� �Լ��� ���Ӽ��� �����ϴ� ��) -> ��2����ȭ -> ���ο� ���̺� ����
             
             ���) �Ʒ�ó�� �������̺��� ���Ӱ� �������
               �й� + �����ڵ� => ����Ű
               �й�  �����ڵ�    ���ڵ�    
                100   A001         A      
                100   A002         F      
                101   A001         A      
                101   A003         B       
                100   A001         A      
                
                [�������̺�] new!
                PK
                �����ڵ�  ������ �����Ⱓ
                A001    Java    1����
                A002    ASP     3����
                A003    C#      1����
                
    (3) ��3����ȭ(3NF)
        - '������ �Լ��� ���Ӽ� ����'�ϴ� ��
              X      ->     Y
            ������         ������
            
              Y -> Z (Z�� �Ϲ��÷��� Y���� ��������) -> �̰��� �����ϴ� ���� ��3����ȭ
        
        ex) [ ���(emp) ���̺�]
            PK
            empno   ename   deptno    dname
            7369    ȫ�浿     10      ������
             X        Y       Z         K
             
            X -> Y
            X -> Z
            Z -> K (������ �Լ� ����)
                        
        ���) �μ� ���̺��� ���� ���� ������ �Լ��� ���Ӽ��� ������
            [ ���(emp) ���̺�]
            PK
            empno   ename   deptno    
            7369    ȫ�浿     10     
             X        Y       Z       
            
            [�μ�(dept) ���̺�] new!
            PK
            deptno  dname
            10      ������
            
    (4) BCNF(Boyce/Codd Normal Form)
        - �����̼� R�� ��3����ȭ�� �����ϰ�, ��� �����ڰ� �ĺ�Ű�̾�� �Ѵٴ� ��
        - ��3����ȭ�� �����ϴ� ��κ��� �����̼ǵ��� BCNF�� �����Ѵ�.
        
        [X + Y] ����Ű
        Z -> Y  : '����Ű ���� �� �Ӽ�(Y)�� �ϹݼӼ�(�÷�, Z)�� �������� �� -> �̰��� �����ϴ� ���� BCNF'
    
    (5) ��4����ȭ
    
    (6) ��5����ȭ

----------------------------------------------------------------------------------------------------
2. ������ DB �𵨸�
   -- > ���� �𵨸��� �ߴ�. ERD�� ���� ��Ű���� ����� ����ȭ �۾��� �Ϸ�� ��
   - �� �� ȿ�������� �����ϱ� ���� �۾� ����� �Բ� �����Ϸ��� DBMS�� Ư���� �°� ���� DB ���� ��ü���� �����ϴ� �ܰ�
   - ������ ��뷮 �м�, ���� ���μ��� �м��� ���ؼ� ���� ȿ������ DB�� �� �� �ֵ��� Index ���, ������ȭ ����
   
-----------------------------------------------------------
3. View(��)
FROM ���̺�� �Ǵ� ���
FROM user_tables;
    1) ���̺��� �������� â�� = View (���� ���⿡ ���� �ٸ��� ���δ�)
    
    2) View�� �ǹ̴� �ϳ��� SELECT ���� �����ϴ�(�����ִ� ��)
        SELECT deptno, ename
        FROM emp
        WHERE deptno = 10;
        
    3) View�� ���� INSERT, UPDATE, DELETE �� ���������� ��κ� SELECT �� �ϱ� ���ؼ� ����Ѵ�.
    
    4) View�� ���� ���̺��̴�
    
    5) View�� �� �� �̻��� ���̺�� �並 ������ �� �ִ�.
              �� �ٸ� �並 ���ؼ� �並 ������ �� �ִ�.
              
    6) View�� ����ϴ� ���� : �������� �Ϻθ� ������ �� �ֵ��� �����ϱ� ���� ������� ���Ǿ�����.
                            + ���ȼ� + ����
    
    7) View �����Ѵٴ� �ǹ� : Data Dictionary(������ �ڷ����) ���̺� �信 ���� ���Ǹ� ����ǰ�
                           ���� ��ũ���� ��������� �Ҵ���� �ʴ´�.
                        ex) user_tables �� -> �ڷ������ ����
                        
    8) View�� ����ؼ� DML + ���� ���� ������ �����ϴ�.
    
    9) View ����
     (1) ���ú�(Simple View) - 1���� ���� ���̺��� �����ϴ� ��
     (2) ���պ�(Complex View) - 2�� �̻��� ���� ���̺��� �����ϴ� ��
    
    10) View ���� ����
    �����ġ�
        CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW ���̸�
            [(alias[,alias]...]
        AS subquery
        [WITH CHECK OPTION]
        [WITH READ ONLY];
        
        ������ �ɼ��� �ǹ̴� ������ ����.
        > OR REPLACE ���� �̸��� �䰡 ������ �׳� ����, ������ �����ؼ� ���� 
        > FORCE �⺻ ���̺��� ������ ������� �並 ���� 
        > NOFORCE �⺻ ���̺��� ���� ���� �並 ���� 
        > ALIAS �⺻ ���̺��� �÷��̸��� �ٸ��� ������ ���� �÷��� �ο� 
        > WITH CHECK OPTION �信 ���� access�� �� �ִ� ��(row)���� ����, ���� ���� 
        > WITH READ ONLY     DML �۾��� ����(���� �д� �͸� ����, �б� ����) 
        
    11) �׽�Ʈ
      ����) �츮�� ���� �Ǹŷ��� Ȯ���ϴ� ������ �����Ѵ�. (�Ʒ��� ����)
    
      SELECT b.b_id, title, price, g.g_id, g_name, p_date, p_su
      FROM book b JOIN danga d ON b.b_id = d.b_id
                  JOIN panmai p ON b.b_id = p.b_id
                  JOIN gogaek g ON g.g_id = p.g_id;
     
      --> ��� �̷��� ������ �ϸ� ������ �������� ������ �並 �����ϰڴ�.
      
      [�� ����]
          CREATE OR REPLACE VIEW panView
                (bookid, booktitle, bookdanga, gogaekid, gogaekname, pdate, psu)
              -- b.b_id, title, price, g.g_id, g_name, p_date, p_su �̰ſ� ���� ��Ī
          AS SELECT b.b_id, title, price, g.g_id, g_name, p_date , p_su
             FROM book b JOIN danga d ON b.b_id = d.b_id
                         JOIN panmai p ON b.b_id = p.b_id
                         JOIN gogaek g ON g.g_id = p.g_id;
          
          -- ORA-01031: insufficient privileges
          -- �ؼ� : scott ������ View ������ ������ ����.
          -- �ذ� : SYS �������� ���� �ο��ϱ�
          --> View PANVIEW��(��) �����Ǿ����ϴ�.
          
      [�� ���] ��� �����ߴ��� �� �𸣰�(���ȼ�) ���� ���°� ���ϰ� �ҷ��� �� �ִ�.
          SELECT *
          FROM panview;
          
          scott�� ������ �ִ� ���� Ȯ��)
          SELECT *
          FROM user_sys_privs;
          
          view ���� Ȯ�� ����)
          DESC panview; -- �������̺�(���� �����͸� ������ ������ ����)
          
          View �ҽ� Ȯ��)
          SELECT *
          FROM user_views;
          -- WHERE view_name = 'PANVIEW';
          
          �並 ����ؼ� ��ü �Ǹűݾ� Ȯ���ϱ�)
          SELECT SUM(psu * bookdanga) ��ü�Ǹűݾ�
          FROM panview;
      
      [����] �� ���� - gogaekView
              �⵵, ��, ���ڵ�, ����, �Ǹűݾ���(�⵵�� ����) ��ȸ�ϴ� �� ����
                     
             CREATE OR REPLACE VIEW gogaekView
                (�⵵, ��, ���ڵ�, ����, �Ǹűݾ��� )
             AS SELECT TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM')
                        , g.g_id, g_name, SUM(p_su * price)
                 FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
                            JOIN danga d ON p.b_id = d.b_id
                 GROUP BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM'), g.g_id, g_name
                 ORDER BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM'), g.g_id, g_name;
              
              �� ��ȸ)
              SELECT *
              FROM gogaekView;
    
     [�並 ����ؼ� DML �۾��غ���]
         CREATE TABLE testa(
              aid        number primary key
              , name    varchar2(20) not null
              , tel    varchar2(20) not null
              , memo   varchar2(100)
         );       
         
            CREATE TABLE testb(
               bid  number primary key
               , aid  number constraint fk_testb_aid references testa(aid) on delete cascade
               , score number(3)
            ); 
            
            INSERT INTO testa (aid, NAME, tel) VALUES (1, 'a', '1');
            INSERT INTO testa (aid, name, tel) VALUES (2, 'b', '2');
            INSERT INTO testa (aid, name, tel) VALUES (3, 'c', '3');
            INSERT INTO testa (aid, name, tel) VALUES (4, 'd', '4');
            
            INSERT INTO testb (bid, aid, score) VALUES (1, 1, 80);
            INSERT INTO testb (bid, aid, score) VALUES (2, 2, 70);
            INSERT INTO testb (bid, aid, score) VALUES (3, 3, 90);
            INSERT INTO testb (bid, aid, score) VALUES (4, 4, 100);

            COMMIT;
            
            SELECT * FROM testa;
            AID         NAME                 TEL                  MEMO                                                                                                
            ---------- -------------------- -------------------- --------------------
                     1 a                    1                                                                                                                        
                     2 b                    2                                                                                                                        
                     3 c                    3                                                                                                                        
                     4 d                    4             
            
            SELECT * FROM testb;
                   BID        AID      SCORE
            ---------- ---------- ----------
                     1          1         80
                     2          2         70
                     3          3         90
                     4          4        100
                 
        [���ú� ����]
        CREATE OR REPLACE VIEW aView
        AS
            SELECT aid, name, memo
            FROM testa;
        --> View AVIEW��(��) �����Ǿ����ϴ�.
        
        - ��ȸ
        SELECT *
        FROM aView;
    
        - aView ���ú並 ����ؼ� INSERT �۾��ϱ�
        INSERT INTO aView (aid, name, memo) VALUES (5,'f', null);
       -- ORA-01400: cannot insert NULL into ("SCOTT"."TESTA"."TEL")
       -- TEL�� NN ���������� ������ �ֱ⶧���� INESRT �۾��� �� ���� ����.
       -- ��, View�� ������ �� NN�� ������ �ִ� �÷��� �����ؾ� INSERT �۾� ����
       
       - memo�� tel�� �����Ͽ� �����
        CREATE OR REPLACE VIEW aView
        AS
            SELECT aid, name, tel
            FROM testa;
        
        - aView ���ú並 ����ؼ� �ٽ� INSERT �۾��ϱ�
        INSERT INTO aView (aid, name, tel) VALUES (5,'f', '5');    
        -- 1 �� ��(��) ���ԵǾ����ϴ�.
        
        - ���̺� �߰��� �� Ȯ��
        SELECT *
        FROM testa;
        
        --
        [���պ� ����] abView
        CREATE OR REPLACE VIEW abView
        AS
            SELECT a.aid, name, tel, bid, score
            FROM testa a JOIN testb b ON a.aid = b.aid;
        -- WITH READ ONLY; -- SELECT�� �ϰڴ�. I/U/D �� �� ����.
         
         [����]    
        INSERT INTO abView (aid, name, tel, bid, score) VALUES (10, 'X', '5', 20, 70);
        -- SQL ����: ORA-01779: cannot modify a column which maps to a non key-preserved table
        -- ���ÿ� �� ���̺� INSERT �� �� ����.
        
         [����] : �ϳ��� ���̺� �����ϰڴ�.
        UPDATE abView
        SET score = 99
        WHERE bid = 1;
        -- 1 �� ��(��) ������Ʈ�Ǿ����ϴ�.
        
        ROLLBACK;
        
         [����]
         DELETE FROM abView
         WHERE aid = 1;
         -- 1 �� ��(��) �����Ǿ����ϴ�.
    
        [�� ����]
        DROP VIEW abview;
        DROP VIEW panview;
        DROP VIEW aView;
        DROP VIEW gogaekView;
        
        SELECT *
        FROM user_views;

    12) WITH CHECK OPTION �信 ���� Access�� �� �ִ� ��(row)���� ����, ���� ����

    CREATE OR REPLACE VIEW bView
    AS
        SELECT bid, aid, score
        FROM testb
        WHERE score >= 90;
        
    SELECT *
    FROM bView;
    
    [����] bid = 3�� score�� 70���� ����
        UPDATE bView
        SET score = 70
        WHERE bid = 3;
        -- 1 �� ��(��) ������Ʈ�Ǿ����ϴ�.
        
        ROLLBACK;
        
     [View�� WITH CHECK OPTION �߰��� Ȯ��]
        CREATE OR REPLACE VIEW bView
        AS
            SELECT bid, aid, score
            FROM testb
            WHERE score >= 90
        WITH CHECK OPTION CONSTRAINTS ck_bview;
        
                UPDATE bView
        SET score = 70
        WHERE bid = 3;
        -- View BVIEW��(��) �����Ǿ����ϴ�.
        -- ORA-01402: view WITH CHECK OPTION where-clause violation
        -- WITH CHECK OPTION �ɼ��� �߰��߱� ������ 90�� �̸��� ������ ������ ���� ����.
        
        INSERT INTO bView VALUES(5, 4, 100);
        -- 1 �� ��(��) ���ԵǾ����ϴ�.
        
        INSERT INTO bView VALUES(6, 4, 87);
        -- ORA-01402: view WITH CHECK OPTION where-clause violation
        -- 90���� ���� ���� WITH CHECK OPTION ������ �߰��� �� ����.
                
    (�߰�����) �� ? �������̺�, �������̺� ���ȼ�, ���� -> SELECT, ���ú�, ���պ�, I/U/D ����
    
--        
* ��������(MATREIALIZED VIEW) -- ������ ���
    - ���� ���������� �����͸� �����ϰ� �ִ� ��
    
----------------------------------------------------
4. ������(Sequence)
    1) ������ ���̺� ���� �⺻Ű(PK)�� ����ũ Ű(UK)�� ����Ͽ� �ΰ��ϴ� ������ ���ο� �÷�ó�� ����� �� �ִ� '�Ϸù�ȣ�� �ű��ϱ� ����'
      '�ϳ��� �÷����� ������ ���̺�'�� ����.
      ex) ���� ��ȣǥ �̴� ��谡 ������
  
    2) ������ ���� ����
    �����ġ�
        CREATE SEQUENCE ��������
        [ INCREMENT BY ����]
        [ START WITH ����]
        [ MAXVALUE n ? NOMAXVALUE]
        [ MINVALUE n ? NOMINVALUE]
        [ CYCLE ? NOCYCLE]
        [ CACHE n ? NOCACHE];

        <�ɼ� ���� >
        INCREMENT BY ���� ������ ��ȣ�� ������ŭ�� ����(����Ʈ=1) 
        START WITH ���� ���۰��� ����(����Ʈ=1) cycle �ɼ��� ����� ��� �ٽ� ���� ������ �� minvalue�� ������ ������ ���� 
        MAXVALUE ���� ������ �� �ִ� �ִ밪 
        NOMAXVALUE(default) �������� �ִ밪�� ������ ����, ���������� 10^27���� Ŀ�� �� �ְ�, ������������ 1���� �۾��� �� ���� 
        MINVALUE ���� ������ �� �ִ� �ּҰ� 
        NOMINVALUE(default) �������� �ּҰ��� ������ ����, ���������� �ּ� 1����, ������������ -(10^26)���� ����. 
        CYCLE �ִ� �Ǵ� �ּҰ��� ������ �� ���� �ٽ� ���� 
        NOCYCLE(default) �ִ� �Ǵ� �ּҰ��� ������ �� ���� �ٽ� ������� �� ���� 
        CACHE ���� access�� ���� �������� ���� �޸𸮿� ����(�⺻ 20) 
        NOCACHE � ���������� ĳ�̵��� ���� 

    - sequence�� currval�� nextval�̶�� pseudo �÷��� ����Ͽ� ���� �����Ѵ�. 
      ***** 'CURRVAL�� �����Ǳ� ���� NEXTVAL�� ���� ���Ǿ�� �Ѵ�.' *****
      �̴� pseudo �÷��� CURRVAL�� ���� NEXTVAL �÷� ���� �����ϱ� �����̴�.
      �׷��Ƿ� NEXTVAL �÷��� ������ ���� ���¿��� CURRVAL�� ����ϸ� �ƹ��� ���� ���� ������ error�� ����Ѵ�.
    
    [Pseudo column ������� ����] 
    NEXTVAL     ��������.NEXTVAL    ���� �ۼ��� �������� '���� ��'�� ��ȯ 
    CURRVAL     ��������.CURRVAL    ���� �ۼ��� �������� '���� ��'�� ��ȯ
    
    3) �׽�Ʈ
        [������ ����]
        CREATE SEQUENCE seq01
            INCREMENT BY 1 -- 1�� ����
            START WITH   100 -- ��ȣǥ�� 1���� ����
            MAXVALUE     10000 -- 10,000������ ����.
            MINVALUE     1     -- ������ 1���� 10,000���� ���� CYCLE�Ǿ �ٽ� ������ 1���� �����ϰڴ�.
            CYCLE              -- 1 ~ 10,000���� ���� �ٽ� �ݺ��� Ƚ�� ����( NOCYCLE�ϸ� �ݺ� X)
            CACHE        20;   -- �̸� ��ȣǥ�� ������ �ִ� ����(�޸𸮿� �����ϴ� ����)
        --> Sequence SEQ01��(��) �����Ǿ����ϴ�.
        
        CREATE SEQUENCE seq02;
        --> Sequence SEQ02��(��) �����Ǿ����ϴ�.
        
        [������ ������ Ȯ��]
        SELECT *
        FROM user_sequences;
        SEQUENCE_NAME                   MIN_VALUE  MAX_VALUE INCREMENT_BY C O CACHE_SIZE LAST_NUMBER
        ------------------------------ ---------- ---------- ------------ - - ---------- -----------
        SEQ01                                   1      10000            1 Y N         20         100
        SEQ02                                   1 1.0000E+28            1 N N         20           1
        -- ������ �����൵ �⺻ ���� ���� �ֵ�.
        
        [������ ����]
        DROP SEQUENCE seq01;
        DROP SEQUENCE seq02;
        
        [������ �ٸ� ���̺� ���]
        -- �μ����̺� ���ο� �μ� �߰��ض� -> �μ� �߰��� �μ���ȣ�� 10�� �����Ǵ� �̶� ������ ����ϱ�
        SELECT MAX(deptno) + 10 FROM dept;
        INSERT INTO dept (deptno, dname, loc) VALUES((SELECT MAX(deptno) + 10 FROM dept), 'QC', 'SEOUL');

        ROLLBACK;
        
         ������ ����)
        CREATE SEQUENCE seq_dept
        INCREMENT BY 10
        START WITH 50
        MAXVALUE 90
        MINVALUE 10
        NOCYCLE
        NOCACHE;
        
        INSERT INTO dept (deptno, dname, loc) VALUES(seq_dept.nextval, 'QC', 'SEOUL' || seq_dept.currval);
        
        SELECT * FROM dept;
        
        SELECT seq_dept.currval -- ���� ��ȣǥ �� (�ϳ��� �̾ƾ��� Ȯ�� ����)
        FROM dual;
        
        DELETE FROM dept
        WHERE deptno = 50;
        -- ���������� ��ȣ�� �̾ƿͼ� ����� ��ȣ�� �ٽ� ������ �� ����.
        -- ������ ��ȣ�� �߰��ϰ� �ʹٸ� ������ ����� �Ǵ� ���������� INSERT �ϱ�
        
----------------------------------------------------
5. PL/SQL
    1) SQL Ȯ�� + PL == [P]rocedural [L]anguage extensions to SQL�� �ǹ�
    2) �̴� ���������� SQL �� ���������� ����� �� �ֵ��� �Ѵ�. 
                                ��. ���� ����
                                ��. ���
                                ��. ���� ó�� ���
    3) PL/SQL�� ��� ������ �� ����̸�, 3������ ������ �����Ǿ��ִ�.
        [ ���� ��� �� ]
        [ ���� ��� �� ]
        [ ���� ó�� �� ]
    
    4) PL/SQL ���� ���� ***
      �����ġ�
       [ DECLARE ]   -- �����(declarations) : ���� ����, ��� ����
       BEGIN         -- �����(statements) : INSERT, DELETE, UPDATE ��
       [ EXCEPTION ] -- ���� ó�� ��(handlers) 
       END; 
       
      [ DECLARE       -- �����(declarations) : ���� ����, ��� ����
            ������ �ڷ���(ũ��)
            ������ �ڷ���(ũ��)
                 :           ]   
       BEGIN         -- �����(statements) : INSERT, DELETE, UPDATE ��
       [ EXCEPTION ] -- ���� ó�� ��(handlers) 
       END;
       
    5) PL/SQL�� ��� �ۼ���� 
    ? �� ���� SQL ���� ������ ����� �� ���� *
       DECLARE
            INSERT
            SELECT
            SELECT
            UPDATE
              :
       BEGIN
       EXCEPTION
       END;
    ? �� ������ CREATEST, LEAST, DECODE, �׷��Լ��� ����� �� ���� *
    --    ? �ĺ��ڴ� �ִ� 30���ڷ� �ۼ� 
    --    ? �ĺ��ڴ� ���̺� �Ǵ� �÷���� ���� �� ���� 
    --    ? �ĺ��ڴ� ���ĺ����� �����ؾ� �� 
    --    ? ���ڿ� ��¥ Ÿ���� ���� �ο��ȣ�� ǥ���� 
    --    ? �ּ��� ���� ������ ��� 2���� ���(--), ���� ���� ��� /* ... */�� ǥ��

    6) PL/SQL�� 6���� ����
        (1) �͸� ���ν���(anonymous procedure)  anonymous PL/SQL�� DECLARE ...�� ���۵Ǹ�, ����ڰ� �ݺ������� �����Ϸ��� SQL���� �ʿ��� ������ �ۼ��Ͽ� �����ϴ� ���, �����ͺ��̽��� �� ������ ������� ����  
        (2) ���� ���ν���(stored procedure)     CREATE PROCEDURE name ...���� ���ؼ� ������ ��, �����ͺ��̽� ���� �� ������ �����. stored procedure�� ������ ó���� �ϰ� ����  
        (3) ���� �Լ�(stored function)         stored procedure�� ������, stored procedure�� ������ ó���� �ϰ� ��������, stored function�� �� ó�� ����� ����ڿ��� ��ȯ��.  
        (4) ��Ű��(package)                    ���� ���Ǵ� ���� procedure, function���� �ϳ��� package��� ������ ����� ��  -> ex) dbms_random ��Ű��
        (5) Ʈ����(trigger)                    � �۾���, �Ǵ� �۾� �� trigger�� ������ ������ �����Ű�� PL/SQL ����. 
        (6) ��ü Ÿ��(object type)             ��ü�� �����͸� �Է�, ����, ����, ��ȸ�ϱ� ���ؼ��� �ݵ�� PL/SQL �� ����ؾ� ��  

    7) �͸� ���ν��� ( anonymous procedure )
    -- ������ �� �ݵ�� ������ �� �� ����***
       [ DECLARE       -- �����(declarations) : ���� ����, ��� ����
            ������ �ڷ���(ũ��)
            ������ �ڷ���(ũ��)
                 :           ]   
       BEGIN         -- �����(statements) : INSERT, DELETE, UPDATE ��
       [ EXCEPTION ] -- ���� ó�� ��(handlers) 
       END;
        
       DECLARE
        vname VARCHAR2(10);
        vsal NUMBER(7, 2);
       BEGIN
        SELECT ename, sal
                INTO vname, vsal -- SELECT�� ����� DECLATE�� ����� ������ ��ڴ�.
        FROM emp
        WHERE empno = 7369;

        DBMS_OUTPUT.PUT_LINE(vname);
        DBMS_OUTPUT.PUT_LINE(vsal);
       --EXCEPTION
        --WHEN THEN
       END;

-- EXCEPTION�� WHEN THEN�� ��� ���� �߻�       
--        ���� ���� -
--        ORA-06550: line 13, column 8:
--        PLS-00103: Encountered the symbol "END" when expecting one of the following:
--        
--           pragma when
--        06550. 00000 -  "line %s, column %s:\n%s"
--        *Cause:    Usually a PL/SQL compilation error.
--        *Action:

    --> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.
    
    + dbms_output ��Ű��
      > �� ��Ű���� PL/SQL ������ ó���� � ����� ������� ȭ�鿡 ����� �� ����Ѵ�.
      > DBMS_OUTPUT ��Ű���� �������α׷�(�Լ�)�� ������ ����.
            put() �Ǵ� put_line() : ���ǵ� ���ڰ��� ȭ�鿡 ����ϴ� ���μ��� 
            NEW_LINE()           : GET_LINE�� ���� ���� ���� ���� ������ ���� �� ��� 
            GET_LINE() �Ǵ� GET_LINES() : ���� ������ ���ڰ��� �д� ���μ��� 
            ENABLE()    : ȭ�鿡 ���ڰ��� ����ϴ� ���� �����ϸ� ���ڰ��� ������ �� �ִ� ����ũ�⸦ ������ 
            DISABLE()   : ȭ�鿡 ���ڰ��� ����ϴ� ���� ������ 
    -- ���� -> DBMS ����ϸ� ������
    
    ����1) ȫ�浿�� �̸��� ���̸� ������ �����ؼ� DBMS�� ����ϱ�
    DECLARE
        vname VARCHAR2(20);
        vage NUMBER(3);
    BEGIN
        vname := 'ȫ�浿';
        vage := 20;
        
        DBMS_OUTPUT.PUT_LINE(vname || ', ' || vage);
    -- EXCEPTION
    END;
    
    --���� ���� -
    --ORA-06550: line 5, column 15:
    --PLS-00103: Encountered the symbol "=" when expecting one of the following:
    --
    --   := . ( @ % ;
    --06550. 00000 -  "line %s, column %s:\n%s"
    --*Cause:    Usually a PL/SQL compilation error.
    --*Action:    
    
    -- ���� : vname = 'ȫ�浿';    -> = �̷��� �ϸ� �ȵǰ� := �̰ɷ� �ؾߵ�
    
    ����2) 30�� �μ��� ������(loc)�� �����ͼ� 10�� �μ��� loc�� ����
   
    SELECT loc
    FROM dept
    WHERE deptno = 30;
    
    UPDATE dept
    SET loc = 'CHICAGO'
    WHERE deptno = 10;
    
    DESC dept;
    
    -- �͸� ���ν��� ���� + ����
    DECLARE
        -- vloc VARCHAR2(13);
        vloc dept.loc%TYPE;  -- Ÿ���� ����(dept�� loc�� �ڷ����� �Ȱ��� �ְڴ�.)
    BEGIN
        SELECT loc INTO vloc
        FROM dept
        WHERE deptno = 30;
        
        UPDATE dept
        SET loc = vloc
        WHERE deptno = 10;
        
        --COMMIT;
    -- EXCEPTION
        -- ROLLBACK;
    END;
    --> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.   
    
    SELECT *
    FROM dept;

    ROLLBACK;   
    
--------------------------------------------------------------------------------
<����������Ʈ>
    ������ �α��� : ���� ���, ����, ����
    ȸ�� �α��� : ���� ��� -> ���� ���� �� ��ǥ + ������ ���� ���� ����
    
    ������
    INSERT ���� ���
    INSERT ���� ���
    INSERT ���� ���
    
    ȸ�� ���� ��ǥ
    
    ���� ���� ���
    
        
        


            
