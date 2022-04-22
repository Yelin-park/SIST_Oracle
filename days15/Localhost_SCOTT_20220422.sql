-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]        
--------------------------------------------------------------------------------
[�����������]

SELECT *
FROM tabs
WHERE table_name LIKE 'T\_%' ESCAPE '\';

SELECT *
FROM T_SAMPLE;

----------------------------------------------------------------------------
T_MEMBER -- ȸ��
T_POLL -- ����
T_POLLSUB -- �����׸��
T_VOTER -- ��ǥ

ȸ��
1) ȸ������ / Ż�� / ����
'ȸ�� ������ ����'
CREATE SEQUENCE seq_member
INCREMENT BY 1
START WITH 1
MAXVALUE 9999
NOCACHE;

'������ �߰�'
INSERT INTO T_MEMBER ( MemberSeq, MemberID, MemberPasswd, MemberName,MemberPhone, MemberAddress  )
VALUES (seq_member.nextval, 'admin', '1234', '������', '010-1111-1111', '���� ������');
INSERT INTO T_MEMBER ( MemberSeq, MemberID, MemberPasswd, MemberName,MemberPhone, MemberAddress  )
VALUES (seq_member.nextval, 'hong', '1234', 'ȫ�浿', '010-1111-1111', '���� ������');
INSERT INTO T_MEMBER ( MemberSeq, MemberID, MemberPasswd, MemberName,MemberPhone, MemberAddress  )
VALUES (seq_member.nextval, 'kim', '1234', '�ͼ���', '010-1111-1111', '���� ������');
COMMIT;

'Ȯ��'
SELECT *
FROM t_member;


2) ���� ���(�ۼ�) / ���� / ����
'���� ������ ����'
CREATE SEQUENCE seq_poll;

'������ �߰�'
INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
VALUES (seq_poll.nextval, '�����ϴ� �����?'
            , TO_DATE('2022-03-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , TO_DATE('2022-03-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , 5
            , 0
            , TO_DATE('2022-02-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , 1
        );

INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
VALUES (seq_poll.nextval, '�����ϴ� ����?'
            , TO_DATE('2022-04-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , TO_DATE('2022-05-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , 4
            , 0
            , TO_DATE('2022-04-15 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , 1
        );

INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
VALUES (seq_poll.nextval, '5�� 5�� �ް� ����'
            , TO_DATE('2022-05-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , TO_DATE('2022-05-04 18:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , 2
            , 0
            , SYSDATE
            , 1
        );        

COMMIT;

'Ȯ��'
SELECT *
FROM t_poll;

2-1) ���� �׸� �߰��ϴ� ���� �ۼ�
'���� ������ ����'
CREATE SEQUENCE seq_pollsub;

'������ �߰�'
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '�载��', 0, 1);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '�����', 0, 1);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '������', 0, 1);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '�輱��', 0, 1);

INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '����', 0, 2);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '����', 0, 2);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '����', 0, 2);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '��ȸ', 0, 2);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '����', 0, 2);

INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '����', 0, 3);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '�ݴ�', 0, 3);

COMMIT;

'Ȯ��'
SELECT *
FROM t_pollsub;

3) ���� ��� �������� �����Ǵ� ����
������ȣ, ��������, �ۼ���, ������, ������, �׸��, �����ڼ�, ���� 

SELECT pollseq, question, membername, sdate, edate, itemcount, polltotal
        , CASE
            WHEN SYSDATE > edate THEN '����'
            WHEN SYSDATE BETWEEN sdate AND edate THEN '������'
            ELSE '������'
          END state
FROM t_poll p JOIN t_member m ON p.memberseq = m.memberseq;

SELECT *
FROM t_member;

4) ���� ��ǥ -> 1)+2)+3) 3���� �۾� -> PL/SQL ����� �ȴ�.
'��ǥ��ȣ ������ ����'
CREATE SEQUENCE seq_vector;

-- �۾�1)
INSERT INTO t_voter (VectorSeq , UserName,RegDate, PollSeq,PollSubSeq, MemberSeq) 
VALUES (seq_vector.nextval, 'ȫ�浿', SYSDATE, 1, 3 ,2);

-- �۾�2)
UPDATE t_poll
SET polltotal = polltotal + 1
WHERE pollseq = 1;

-- �۾�3)
UPDATE t_pollsub
SET acount = acount + 1
WHERE pollsubseq = 3;

-- �۾�1)
INSERT INTO t_voter (VectorSeq , UserName,RegDate, PollSeq,PollSubSeq, MemberSeq) 
VALUES (seq_vector.nextval, '�ͼ���', SYSDATE, 1, 3 ,2);

-- �۾�2)
UPDATE t_poll
SET polltotal = polltotal + 1
WHERE pollseq = 1;

-- �۾�3)
UPDATE t_pollsub
SET acount = acount + 1
WHERE pollsubseq = 3;


-- �۾�1)
INSERT INTO t_voter (VectorSeq , UserName,RegDate, PollSeq,PollSubSeq, MemberSeq) 
VALUES (seq_vector.nextval, '������', SYSDATE, 1, 2 ,2);

-- �۾�2)
UPDATE t_poll
SET polltotal = polltotal + 1
WHERE pollseq = 1;

-- �۾�3)
UPDATE t_pollsub
SET acount = acount + 1
WHERE pollsubseq = 2;

COMMIT;

SELECT * FROM t_voter;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;

5) 1�� ������ ���� ��ǥ ��� ����
(1) �� �����ڼ�
SELECT polltotal
FROM t_poll
WHERE pollseq = 1;

-- �Ʒ� ������ �ϸ� ������ �������� ������ ���� ���� �÷��� �߰��ؼ� Ȯ���� �� �ֵ��� �Ͽ���.
SELECT COUNT(*)
FROM t_voter
WHERE pollseq = 1;


(2) ��ǥ ��� ����
SELECT question, answer
        , RPAD(' ', v+1, '#') || acount || '(' || v || '%)'
FROM(   
    SELECT question, answer, acount, polltotal
            , ROUND(acount / polltotal * 100) v
    FROM t_pollsub s JOIN t_poll p ON s.pollseq = p.pollseq
    WHERE p.pollseq = 1
) t;



------------------------------------------------------------------------------------------------
1. PL/SQL
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
    > �� ���� SQL ���� ������ ����� �� ���� *
       DECLARE
            INSERT
            SELECT
            SELECT
            UPDATE
              :
       BEGIN
       EXCEPTION
       END;
       
    > �� ������ CREATEST, LEAST, DECODE, �׷��Լ��� ����� �� ���� *
    --  �ĺ��ڴ� �ִ� 30���ڷ� �ۼ� 
    --  �ĺ��ڴ� ���̺� �Ǵ� �÷���� ���� �� ���� 
    --  �ĺ��ڴ� ���ĺ����� �����ؾ� �� 
    --  ���ڿ� ��¥ Ÿ���� ���� �ο��ȣ�� ǥ���� 
    --  �ּ��� ���� ������ ��� 2���� ���(--), ���� ���� ��� /* ... */�� ǥ��

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
       -- EXCEPTION
       -- WHEN THEN
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
    
--------------------------------
[���⼭���� ���ο� ����~]

�͸� ���ν��� �����ϱ�..

(1) �̸� ����ϱ�
--DECLARE
BEGIN
    dbms_output.put_line('ȫ�浿');
--EXCEPTION
END;

(2)
DECLARE
    vname VARCHAR2(20);
    vage NUMBER(3) := 20; -- ���⼭ �����ϸ� �⺻��
BEGIN
    vname := '�ͼ���';
    vage := 28; -- ������ ���ָ� �⺻���� �ƴ� �� ������ ���
    DBMS_OUTPUT.PUT_LINE(vname || ', ' || vage);
--EXCEPTION
END;

        
����1) emp ���̺��� 10�� �μ��� �߿� �޿��� ���� ���� �޴� ����� ������ ����ϴ� �͸����ν��� �ۼ�
        ����) empno, deptno, ename, job, mgr, hiredate, pay(sal + comm)
        
DECLARE
    tempno emp.empno%TYPE;
    tdeptno emp.deptno%TYPE;
    tename emp.ename%TYPE;
    tjob emp.job%TYPE;
    tmgr emp.mgr%TYPE;
    thiredate emp.hiredate%TYPE;
    tpay emp.sal%TYPE;    
BEGIN    
    SELECT empno, deptno, ename, job, mgr, hiredate, sal + NVL(comm, 0) pay
         INTO tempno, tdeptno, tename, tjob, tmgr, thiredate, tpay
    FROM emp
    WHERE deptno = 10 AND sal + NVL(comm, 0) = (SELECT MAX(sal+NVL(comm,0)) max_pay FROM emp WHERE deptno = 10);

    DBMS_OUTPUT.PUT_LINE(tempno || ', '|| tdeptno || ', '|| tename || ', '|| tjob || ', '|| tmgr || ', '|| thiredate || ', '|| tpay);
--EXCEPTION
END;

--------------------
1. %TYPE�� ���� : ������ table��.column��%TYPE;

DECLARE
    tempno emp.empno%TYPE;
    tdeptno emp.deptno%TYPE;
    tename emp.ename%TYPE;
    tjob emp.job%TYPE;
    tmgr emp.mgr%TYPE;
    thiredate emp.hiredate%TYPE;
    tpay emp.sal%TYPE;  
    
    vmax_pay NUMBER;
BEGIN 
    -- 1�� ���� *** ���������� ���� ���ͼ� ������ ����
    SELECT MAX(sal+NVL(comm,0)) max_pay
        INTO vmax_pay
    FROM emp
    WHERE deptno = 10;

    -- 2�� ����
    SELECT empno, deptno, ename, job, mgr, hiredate, sal + NVL(comm, 0) pay
         INTO tempno, tdeptno, tename, tjob, tmgr, thiredate, tpay
    FROM emp
    WHERE deptno = 10 AND sal + NVL(comm, 0) = vmax_pay;

    DBMS_OUTPUT.PUT_LINE(tempno || ', '|| tdeptno || ', '|| tename || ', '|| tjob || ', '|| tmgr || ', '|| thiredate || ', '|| tpay);
--EXCEPTION
END;

--------------------
2. %ROWTYPE�� ���� : ������ table��%ROWTYPE;

DECLARE
    -- emp ���̺��� �� ��(���ڵ�) ��ü�� ������ ���� ����
    vemprow emp%ROWTYPE;
    vpay NUMBER;
    
    vmax_pay NUMBER;
BEGIN 
    -- 1�� ���� *** ���������� ���� ���ͼ� ������ ����
    SELECT MAX(sal+NVL(comm,0)) max_pay INTO vmax_pay
    FROM emp
    WHERE deptno = 10;

    -- 2�� ����
    SELECT empno, deptno, ename, job, mgr, hiredate, sal + NVL(comm, 0) pay
         INTO vemprow.empno, vemprow.deptno, vemprow.ename, vemprow.job, vemprow.mgr, vemprow.hiredate, vpay
    FROM emp
    WHERE deptno = 10 AND sal + NVL(comm, 0) = vmax_pay;

    DBMS_OUTPUT.PUT_LINE(vemprow.empno || ', '|| vemprow.deptno || ', '|| vemprow.ename || ', '|| vemprow.job
                            || ', '|| vemprow.mgr || ', '|| vemprow.hiredate || ', '|| vpay);
--EXCEPTION
END;

------------------------------
PL/SQL �� �ȿ��� SELECT�� ó�� ����� ���� ���� ���� ��ȯ�� ��쿡�� �Ʒ��� ���� ������ �߻��Ѵ�.
���� �ݵ�� 'Ŀ��(CURSOR)'�� ����ؾ� �ȴ�.  -> ���߿� �ٽ� �˷��ֽ� ����!
    ���� : ORA-01422: exact fetch returns more than requested number of rows
    �ؼ� : ��û�� ���� ������ �� ���� �����´�.
    
    DECLARE
        vename emp.ename%TYPE;
        vjob emp.job%TYPE;
    BEGIN
        SELECT ename, job -- 12�� ��� == 12 row (��)
            INTO vename, vjob
        FROM emp;
        --WHERE empno = 7369;
    --EXCEPTION
        DBMS_OUTPUT.PUT_LINE(vename || ',' || vjob);
    END;

------------------------------
3. [PL/SQL�� ���]
1) IF / ELSE IF��
[Java]
if(���ǽ�) {
}

[PL/SQL]
IF( ���ǽ� ) THEN
IF ���ǽ� THEN
END IF;

----
[Java]
if(���ǽ�) {
} else {
}

[PL/SQL]
IF( ���ǽ� ) THEN
    -- �ڵ�
ELSE
    -- �ڵ�
END IF;

----
[Java]
if(���ǽ�) {
} else if() {
} else if() {
} else {
}

[PL/SQL]
IF( ���ǽ� ) THEN
ELSIF( ���ǽ� ) THEN
ELSIF( ���ǽ� ) THEN
ELSIF( ���ǽ� ) THEN
ELSE 
END IF;


    ����1) ������ �ϳ� �����ؼ� ������ �Է¹޾Ƽ� ¦��/Ȧ�� ���
    
    DECLARE
        vnum NUMBER := 0;
        vresult VARCHAR2(20);
    BEGIN
        vnum :=  :bindNumber; -- ������ �Է¹޾Ƽ� �����ϰڴ�.
        
        IF(mod(vnum, 2) = 0) THEN
            vresult := '¦��';
        ELSE
            vresult := 'Ȧ��';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE(vresult);
    -- EXCEPTION
    END;
    
    ����2) ���� ������ �Է¹޾Ƽ� ����̾簡��� ����ϴ� �͸����ν��� �ۼ�
    
    DECLARE
        kor NUMBER(3) := 0;
        grade VARCHAR2(3) := '��';
    BEGIN
        kor := :bindNumber;
        
        IF kor >= 90 THEN
            grade := '��';
        ELSIF kor >= 80 THEN
            grade := '��';
        ELSIF kor >= 70 THEN
            grade := '��';
        ELSIF kor >= 60 THEN
            grade := '��';        
        ELSE
            grade := '��';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE(grade);
    -- EXCEPTION
    END;


-------
CASE�� ���)

    DECLARE
        kor NUMBER(3) := 0;
        grade VARCHAR2(3) := '��';
    BEGIN
        kor := :bindKor;
        kor := TRUNC(kor / 10);
        
        CASE kor
            WHEN 10 THEN grade := '��';
            WHEN 9 THEN grade := '��';
            WHEN 8 THEN grade := '��';
            WHEN 7 THEN grade := '��';
            WHEN 6 THEN grade := '��';
            ELSE grade := '��';
        END CASE;
        
        DBMS_OUTPUT.PUT_LINE(grade);
    -- EXCEPTION
    END;

------------
2) FOR...LOOP ��(������ �ݺ�)
    �����ġ� 
        FOR counter���� IN [REVERSE] ���۰� .. ����
        LOOP 
          ���๮; -- �ݺ�ó���� �ڵ�
        END LOOP; 
    
    ����1) 1 ~ 10���� ���� ���
    1+2+3+4+5+6+7+8+9+10+=65 ������ + ����
    
    DECLARE
        vi NUMBER;
        vsum NUMBER := 10;
    BEGIN
        FOR vi IN 1..10
        LOOP
            vsum := vsum + vi;
            -- DBMS_OUTPUT.PUT_LINE(vi || '+' );
            IF(vi = 10) THEN
                DBMS_OUTPUT.PUT(vi);
            ELSE
                DBMS_OUTPUT.PUT(vi || '+' );
            END IF;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('=' || vsum );
    -- EXCEPTION
    END;

------------
3) WHILE...LOOP ��(������ �ݺ�)           

 [����1]
     LOOP 
       EXIT WHEN ��������������;
       ���๮; 
     END LOOP; 
    
 [����2]
     WHILE ����
     LOOP
       ���๮; -- ������ ���ϵ��� ����Ǵ� ��
     END LOOP; 

----------
    ����1) 1 ~ 10���� ���� ���
    1+2+3+4+5+6+7+8+9+10+=65 ������ + ����   
    
    Ǯ��1) LOOP END LOOP; ��
    DECLARE
        vi NUMBER := 1;
        vsum NUMBER := 0;
    BEGIN
        vi := 1;
        LOOP
          EXIT WHEN vi = 11;
            DBMS_OUTPUT.PUT(vi || '+');
            vsum := vsum + vi;
            vi := vi + 1;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('=' || vsum);
    -- EXCEPTION
    END;
    
    
    Ǯ��2) WHILE LOOP END LOOP; ��
    DECLARE
        vi NUMBER := 1;
        vsum NUMBER := 0;
    BEGIN
        vi := 1;
        WHILE (vi <= 10)
        LOOP
            DBMS_OUTPUT.PUT(vi || '+');
            vsum := vsum + vi;
            vi := vi + 1;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('=' || vsum);
    -- EXCEPTION
    END;

----------
    ����2) ������
    1) FOR�� 2�� ���
    
    DECLARE
        vdan NUMBER(1);
        vi NUMBER(1);
    BEGIN
        FOR vdan IN 2..9
        LOOP
            FOR vi IN 1..9
            LOOP
                DBMS_OUTPUT.PUT(vdan || '*' || vi || '=' || RPAD(vdan * vi, 4, ' ') );
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
    -- EXCEPTION
    END;
    
    2) WHILE�� 2�� ���
    
    DECLARE
        vdan NUMBER(2) := 2;
        vi NUMBER(2) := 1;
    BEGIN
        WHILE (vdan <= 9)
        LOOP
            vi := 1;
            WHILE (vi <= 9)
            LOOP
                DBMS_OUTPUT.PUT(vdan || '*' || vi || '=' || RPAD(vdan * vi, 4, ' ') );
                vi := vi + 1;
            END LOOP;
                DBMS_OUTPUT.PUT_LINE('');
                vdan := vdan + 1;
        END LOOP;
    END;
    
    
    3) LOOP END LOOP �� ���   
         
    -- ��ȯ��~  
    DECLARE
        vdan NUMBER;
        vnum NUMBER;
    BEGIN
        vdan := 2;
        LOOP
            vnum := 1;
    
            LOOP
                DBMS_OUTPUT.PUT_LINE(vdan || '*' || vnum || '=' ||vdan*vnum);
                vnum := vnum +1;
                EXIT WHEN (vnum > 9); 
            END LOOP;
            
            vdan := vdan +1;
            EXIT WHEN (vdan > 9);    
        END LOOP; 
    --EXCEPTION
    END;

----------------------------------------------------------
4. [RECORD�� ���� ����]
    emp / dept����
    deptno, dname, empno, ename
    
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
    FROM emp e JOIN dept d ON e.deptno = d.deptno
    WHERE empno = 7369;

1) %TYPE�� ���� ����
    DECLARE
        vdeptno dept.deptno%TYPE; 
        vdname dept.dname%TYPE;
        vempno emp.empno%TYPE;
        vename emp.ename%TYPE;
        vpay NUMBER;
    BEGIN
        SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
            INTO vdeptno, vdname, vempno, vename, vpay
        FROM emp e JOIN dept d ON e.deptno = d.deptno
        WHERE empno = 7369;
        
        DBMS_OUTPUT.PUT_LINE(vdeptno || ', ' ||  vdname || ', ' || vempno || ', ' || vename || ', ' || vpay);
    -- EXCEPTION
    END;

-------
2) %ROWTYPE�� ���� ����
    DECLARE
        vdrow dept%ROWTYPE;
        verow emp%ROWTYPE; 
    
        vpay NUMBER;
    BEGIN
        SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
            INTO vdrow.deptno, vdrow.dname, verow.empno, verow.ename, vpay
        FROM emp e JOIN dept d ON e.deptno = d.deptno
        WHERE empno = 7369;
        
        DBMS_OUTPUT.PUT_LINE(vdrow.deptno || ', ' ||   vdrow.dname || ', ' || verow.empno || ', ' || verow.ename || ', ' || vpay);
    -- EXCEPTION
    END;

----------------------------   
3) RECORD�� ����    
    DECLARE
        -- ����ڰ� �����ϴ� ���ο� ������ �ڷ��� => '����� ���� ����ü'
        TYPE EmpDeptType IS RECORD -- ����ü �̸� ����
        (
            vdeptno dept.deptno%TYPE, 
            vdname dept.dname%TYPE, -- �����ڴ� ,(�޸�)!!
            vempno emp.empno%TYPE,
            vename emp.ename%TYPE,
            vpay NUMBER
        );
        
        vrow EmpDeptType; -- RECORD�� ���� ����
    BEGIN
        SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
            INTO vrow.vdeptno, vrow.vdname, vrow.vempno, vrow.vename, vrow.vpay
        FROM emp e JOIN dept d ON e.deptno = d.deptno
        WHERE empno = 7369;
        
        DBMS_OUTPUT.PUT_LINE(vrow.vdeptno || ', ' ||  vrow.vdname || ', ' || vrow.vempno || ', ' || vrow.vename || ', ' || vrow.vpay);
    -- EXCEPTION
    END;

----------------------------  
5. CURSOR
1) CURSOR ? PL/SQL �� ������ ����Ǵ� SELECT���� �ǹ�
2) ���� ���� ���ڵ带 ó���ϱ����ؼ� Ŀ��(CURSOR)�� ����ؾߵȴ�.
3) Ŀ���� 2���� ����
    ��. implicit cursor ������(�Ͻ���, �ڵ�) Ŀ��
    ����)
        DECLARE
            -- vrow ����X
        BEGIN
            FOR vrow IN (SELECT empno, ename, job FROM emp)
            LOOP
                DBMS_OUTPUT.PUT_LINE(vrow.empno || ', ' || vrow.ename || ', ' || vrow.job);
            END LOOP;
        --EXCEPTION
        END;

    ��. explicit cursor ����� Ŀ��
     (1) Ŀ�� ����
     (2) Ŀ�� OPEN
     (3) LOOP
            -- Ŀ���κ��� SELECT�� ���� �������� �ڵ�(FETCH)
            EXIT WHEN Ŀ���� ���� ���� ���� �� ������ ���� (%NOTFOUND ���̵� �� ����)
         END LOOP;
     (4) Ŀ�� CLOSE
     
4) ����
    [Ŀ����������]
    CURSOR Ŀ���� IS (��������);
    OPEN [Ŀ����];
    FOR
     FETCH [Ŀ����] INTO [������];
     EXIT WHEN [������];
    END LOOP;
    CLOSE [Ŀ����];
    
    [Ŀ���� �Ӽ�]
    > %ROWCOUNT  ����� Ŀ�����忡�� ���� ���� �� 
    > %FOUND  ����� Ŀ�����忡�� �˻��� ���� �߰ߵǾ����� �� �� �ִ� �Ӽ� 
    > %NOTFOUND  ����� Ŀ�����忡�� �˻��� ���� �߰ߵ��� �ʾ����� �� �� �ִ� �Ӽ� 
    > %ISOPEN  ����� Ŀ���� ���� OPEN�Ǿ� �ִ����� ��ȯ 
   
    
5) ����
        DECLARE
            vename emp.ename%TYPE;
            vsal emp.sal%TYPE;
            vhiredate emp.hiredate%TYPE;
        BEGIN
            SELECT ename, sal, hiredate
                INTO vename, vsal, vhiredate
            FROM emp
            WHERE deptno = 30;
            
            DBMS_OUTPUT.PUT_LINE(vename || ', ' || vsal || ', ' || vhiredate );
        -- EXCEPTION
        END;
        
        ���� : ORA-01422: exact fetch returns more than requested number of rows
        ���� : ������ ���ڵ尡 ���Ƽ� �߻�, Ŀ���� ����Ͽ� �ذ��ϱ�
        
Ŀ���� ����ϱ�)
        DECLARE
            vename emp.ename%TYPE;
            vsal emp.sal%TYPE;
            vhiredate emp.hiredate%TYPE;
            
            -- 1) Ŀ�� ���� : CURSOR Ŀ���� IS (��������);
            CURSOR emp30_cursor IS(
                                        SELECT ename, sal, hiredate
                                        FROM emp
                                        WHERE deptno = 30
                                );
        BEGIN
            --2) OPEN : OPEN Ŀ����;
            OPEN emp30_cursor;
            
            --3) LOOP ~ FETCH �۾�(�ݺ������� �������� �۾�)
            LOOP
                FETCH emp30_cursor INTO vename, vsal, vhiredate;
                DBMS_OUTPUT.PUT_LINE(vename || ', ' || vsal || ', ' || vhiredate );
                EXIT WHEN emp30_cursor%NOTFOUND;
            END LOOP;        
            
            --4) CLOSE : CLOSE Ŀ����;
            CLOSE emp30_cursor;
            
        -- EXCEPTION
        END;   

-------------------------
        DECLARE
            CURSOR emp_cursor IS( SELECT empno, ename, job FROM emp );
        BEGIN
            FOR vrow IN emp_cursor     
            LOOP
                DBMS_OUTPUT.PUT_LINE(vrow.ename || ', ' || vrow.ename  || ', ' || vrow.job );
            END LOOP;
            
        -- EXCEPTION
        END;   

--------------------
        DECLARE
            vename emp.ename%TYPE;
            vsal emp.sal%TYPE;
            vhiredate emp.hiredate%TYPE;
            
            -- 1) Ŀ�� ���� : CURSOR Ŀ���� IS (��������);
            CURSOR emp30_cursor IS(
                                        SELECT ename, sal, hiredate
                                        FROM emp
                                        WHERE deptno = 30
                                );
        BEGIN
            --2) OPEN : OPEN Ŀ����;
            OPEN emp30_cursor;
            
            --3) LOOP ~ FETCH �۾�(�ݺ������� �������� �۾�)
            LOOP
                FETCH emp30_cursor INTO vename, vsal, vhiredate;
                DBMS_OUTPUT.PUT_LINE(vename || ', ' || vsal || ', ' || vhiredate );
                EXIT WHEN emp30_cursor%NOTFOUND OR emp30_cursor%ROWCOUNT >= 3;
            END LOOP;        
            
            --4) CLOSE : CLOSE Ŀ����;
            CLOSE emp30_cursor;
            
        -- EXCEPTION
        END;

-- ���ݱ��� �͸� ���ν����� ����ؼ� PL/SQL �⺻(���� ����, Ŀ��, ���) ���� ����� --

���� ���ν���(stored procedure)
1) PL/SQL 6���� �߿� ���� ��ǥ���� ����

2) �����ڰ� ���� �����ؾ� �ϴ� ������ �� ������ ���� �̸� �ۼ��ϰ�
    DB ���� ������ �ξ��ٰ� �ʿ��� �� ���� ȣ���ؼ� ����� �� �ִ�. (���� ������..)
    
3) ���� ���ν��� ���� ����
    CREATE OR REPLACE PROCEDURE ���ν�����
    (
        -- �Ķ���͸� ������ �شٸ� ,(�޸�) ���� / �ڷ����� ũ�� ���� ���Ѵ�.
        �Ķ���� ���� MODE (IN/OUT/INOUT) �ڷ���, -- �⺻�� IN(�Է¿�) 
        �Ķ���� ���� MODE (IN/OUT/INOUT) �ڷ���, -- �⺻�� IN(�Է¿�)
        �Ķ���� ���� MODE (IN/OUT/INOUT) �ڷ��� -- �⺻�� IN(�Է¿�)
    )
    IS -- DECLARE ��ſ� �����
        -- ����,
        -- ����,
        -- ����,
    BEGIN
        -- ���� ����
    EXCEPTION
        -- ����ó��
    END;
    

4) ���� ���ν��� ����ϴ� ���
    ��. EXECUTE�� ����
    ��. �� �ٸ� ���� ���ν��� �ȿ��� ȣ���ؼ� ����
    ��. �͸� ���ν������� ȣ���� �� ����

5) ���� up == user procedure
(1) ���ν��� ����
CREATE OR REPLACE PROCEDURE up_delDept
(
    -- �Ķ���� MODE IN �ڷ���,
    pdeptno IN NUMBER -- �����ϰ��� �ϴ� �μ���ȣ�� �Է¹��� �Ķ����(����)
)
IS
    -- ����
BEGIN
    -- ����
    DELETE FROM dept
    WHERE deptno = pdeptno;
    
    -- COMMIT; -- Ŀ�� �Ǵ� �ѹ������ �۾��� �Ϸ�� ����� �ٽ� ���� �Ŷ� ���� ����
    
-- EXCEPTION
END up_delDept;
--> rocedure UP_DELDEPT��(��) �����ϵǾ����ϴ�.



(2) �͸� ���ν������� ���� ���ν��� ȣ��
DECLARE
BEGIN
    up_deldept(40); -- 40�� pdeptno��!
--EXCEPTION
END;
--> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.



(3) EXECUTE���� ���
EXECUTE up_deldept(40);

ROLLBACK;

------------------
SELECT *
FROM dept;

<������>
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON

<������>
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
    
    
    