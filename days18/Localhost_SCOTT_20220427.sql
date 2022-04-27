-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]
1. Ʈ����(Trigger)
    1) � �۾� ��(before) �Ǵ� �۾� ��(after) Ʈ���ſ� ������ ������ �����ϴ� PL/SQL�� �� ����
    2) ���(���̺�)�� �̸� Ʈ���Ÿ� �����ϸ� � �̺�Ʈ(DML)�� �߻��� �� �ڵ����� ������ Ʈ���Ű� �۵�(�Ҵ�) �ϵ����� ��ü
    3) ��.
        �԰����̺�(���)
        �԰��ȣ    �԰���ǰ��   �԰�¥      �԰����
        101        LG�����    2022.04.27  10
        > �԰����̺��� INSERT ����
        
        ������̺�
        LG����� 120��
        > ������̺��� UPDATE ����(120 + 10)
    
        > �԰����̺� �̺�Ʈ(DML)�� �߻��Ǹ� ������̺��� �ڵ����� �������� �����ϴ� Ʈ����
    
    4) Ʈ���� Ű����(�����)
        ��. �۾� ���� �ڵ� ó���Ǵ� Ʈ���� : BEFORE TRIGGER
        ��. �۾� �Ŀ� �ڵ� ó���Ǵ� Ʈ���� : AFTER TRIGGER
        ��. FOR EACH ROW : �� ���� ó���Ǵ� Ʈ����(ROW TRIGGER)
        ��. REFERENCING : ����޴� ���� �� ����
        ��. :OLD -> �����Ǳ� ���� ��(�÷�)�� ��
        ��. :NEW -> ������ �Ŀ� ��(�÷�)�� ��
        
    5) Ʈ���� ����
    �����ġ� 
        CREATE [OR REPLACE] TRIGGER Ʈ���Ÿ� [BEFORE ? AFTER] -- BEFORE/AFTER �⺻���� AFTER
          trigger_event ON ���̺��
          [FOR EACH ROW [WHEN TRIGGER ����]]
        DECLARE
          ����
        BEGIN
          PL/SQL �ڵ�
        EXCEPTION
          ���� ó�� �κ�
        END;
        
        - �������ν����� COMMIT�� �ؾߵ�����, Ʈ���Ŵ� �ڵ����� COMMIT/ROLLBACK �ȴ�.
        
    6) Ʈ���� Ȯ��
        SELECT *
        FROM user_triggers;
        
    7) Ʈ���� �׽�Ʈ
     <���̺� 2�� ����>
        CREATE TABLE tbl_trigger1(
            id NUMBER PRIMARY KEY
            , name VARCHAR2(20)
        );
        
        CREATE TABLE tbl_trigger2(
           memo VARCHAR2(100) -- �α� ����
            , ilja DATE DEFAULT SYSDATE -- �̺�Ʈ(DML)�� �߻��� �ð�
        );
    
    �̺�Ʈ : tbl_trigger1 ���̺� �� ���� ���ڵ�(��)�� INSERT
    ���(tbl_trigger1)�� �̺�Ʈ(DML)�� �߻��ϸ� tbl_trigger2 ���̺�
    �ڵ����� �α׸� ����ϴ� Ʈ���� ����
    
    <Ʈ���� ����> ut = user trigger
      <INSERT Ʈ����>
        CREATE OR REPLACE TRIGGER ut_exam01 AFTER -- �̺�Ʈ �۾��� �Ϸ�� �Ŀ� �۵��ϴ� Ʈ����
        INSERT ON tbl_trigger1 -- ��� ���̺� INSERT��� �̺�Ʈ�� �߻��� ��
        -- FOR EACH ROW ��Ʈ����
        -- DECLARE -- �����������ʿ��� �ּ�ó��
        BEGIN
            INSERT INTO tbl_trigger2 (memo) VALUES ('TBL_TRIGGER1 ���̺� ���ο� ������ �߰���');
        -- EXCEPTION
        END;
        
      <UPDATE Ʈ����>
        CREATE OR REPLACE TRIGGER ut_exam01 AFTER -- �̺�Ʈ �۾��� �Ϸ�� �Ŀ� �۵��ϴ� Ʈ����
        UPDATE ON tbl_trigger1 -- ��� ���̺� INSERT��� �̺�Ʈ�� �߻��� ��
        -- FOR EACH ROW ��Ʈ����
        -- DECLARE -- �����������ʿ��� �ּ�ó��
        BEGIN
            INSERT INTO tbl_trigger2 (memo) VALUES ('TBL_TRIGGER1 ���̺� ���ο� ������ �߰���');
        -- EXCEPTION
        END;
        
      <DELETE Ʈ����>
        CREATE OR REPLACE TRIGGER ut_exam01 AFTER -- �̺�Ʈ �۾��� �Ϸ�� �Ŀ� �۵��ϴ� Ʈ����
        DELETE ON tbl_trigger1 -- ��� ���̺� INSERT��� �̺�Ʈ�� �߻��� ��
        -- FOR EACH ROW ��Ʈ����
        -- DECLARE -- �����������ʿ��� �ּ�ó��
        BEGIN
            INSERT INTO tbl_trigger2 (memo) VALUES ('TBL_TRIGGER1 ���̺� ���ο� ������ �߰���');
        -- EXCEPTION
        END; 
        
    ** ���� ���� 3���� Ʈ���Ÿ� �����ص� ������ �Ʒ��� ���� OR �����ڷ� �����Ͽ� ������ �� ����!!!
        CREATE OR REPLACE TRIGGER ut_exam01 AFTER -- �̺�Ʈ �۾��� �Ϸ�� �Ŀ� �۵��ϴ� Ʈ����
        INSERT OR UPDATE OR DELETE ON tbl_trigger1 -- ��� ���̺� INSERT��� �̺�Ʈ�� �߻��� ��
        -- FOR EACH ROW ��Ʈ����
        -- DECLARE -- �����������ʿ��� �ּ�ó��
        BEGIN
            IF INSERTING THEN
                INSERT INTO tbl_trigger2 (memo) VALUES ('TBL_TRIGGER1 ���̺� ���ο� ������ �߰���');
            ELSIF UPDATING THEN
                INSERT INTO tbl_trigger2 (memo) VALUES ('TBL_TRIGGER1 ���̺� ������ ������');
            ELSIF DELETING THEN
                INSERT INTO tbl_trigger2 (memo) VALUES ('TBL_TRIGGER1 ���̺� ������ ������');
            END IF;
        -- EXCEPTION
        END;        
    
    
    <���̺� �ȿ� ������ Ȯ��>
        SELECT * FROM tbl_trigger1;
        SELECT * FROM tbl_trigger2;
    
    
    <�̺�Ʈ ���� �� Ȯ��>
        INSERT INTO tbl_trigger1 VALUES (1, 'admin');
        INSERT INTO tbl_trigger1 VALUES (1, 'hong');
         -- ORA-00001: unique constraint (SCOTT.SYS_C007485) violated
         -- ��ü ���Ἲ �����ϸ� AFTER Ʈ���Ŵ� �۵����� �ʴ´�.
        
        INSERT INTO tbl_trigger1 VALUES (2, 'hong');
    
        ROLLBACK; -- �ѹ��� �ϸ� �ڵ����� Ʈ���� �۾��� �ѹ�Ǿ�����.

    > Ʈ���Ÿ� �߰�, ����, �����ϴ� �α׸� ����ϴ� ������ ��������
        - DML(UPDATE) �ڵ����� Ʈ���� �߻� -> �α� ���
        UPDATE tbl_trigger1
        SET name = 'kim'
        WHERE id = 2;
    
        - DML(DELETE) �ڵ����� Ʈ���� �߻� -> �α� ���
        DELETE FROM tbl_trigger1
        WHERE id = 2;   
        
        COMMIT;

--------------------------------------------------------------------
����1) tbl_trigger1 ���̺� �ٹ��ð�X, �ָ�(��,��)���� INSERT, UPDATE, DELETE �ϸ� ���� �߻�
    <Ʈ���� ����>
    CREATE OR REPLACE TRIGGER ut_exam02 BEFORE -- �̺�Ʈ �۾��� ����Ǳ� ���� �۵��ϴ� Ʈ����
    INSERT OR UPDATE OR DELETE ON tbl_trigger1 -- ��� ���̺� INSERT��� �̺�Ʈ�� �߻��ϱ� ����
    -- FOR EACH ROW ��Ʈ����
    -- DECLARE -- �����������ʿ��� �ּ�ó��
    BEGIN
        -- ���� : �ٹ��ð��� 12~18��
        IF TO_CHAR(SYSDATE, 'DY') IN ('��', '��')
           OR
           NOT(TO_CHAR(SYSDATE, 'HH24') BETWEEN 12 AND 18) THEN
            -- ���� ������ �߻���Ű�� DML���� ��Ұ� �Ǿ���
            RAISE_APPLICATION_ERROR(-20000, '������ �ٹ��ð� �� �Ǵ� �ָ��̱⿡ �۾� �ȵ˴ϴ�.'); -- �����ڵ��ȣ, �޽���
        END IF;
    -- EXCEPTION
    END;

--> Trigger UT_EXAM02��(��) �����ϵǾ����ϴ�.

    <����> ���ο� �����Ͱ� ���ԵǱ� ���� Ʈ���Ű� �߻��� �Ǿ �ٹ�/�ָ� üũ �Ŀ� ���� ����
    INSERT INTO tbl_trigger1 VALUES (2, 'hong');

INSERT INTO tbl_trigger1 VALUES (2, 'hong')
���� ���� -
ORA-20000: ������ �ٹ��ð� �� �Ǵ� �ָ��̱⿡ �۾� �ȵ˴ϴ�.
ORA-06512: at "SCOTT.UT_EXAM02", line 7
ORA-04088: error during execution of trigger 'SCOTT.UT_EXAM02'

--------------------------------------------------------------------
����2) �� �л��� �й�, �̸�, ����, ����, ���� -> tbl_trg1 �� INSERT
      �ڵ����� tbl_trg2 ���̺� tot, avg INSERT �Ǵ� Ʈ���� ���� -> �׽�Ʈ
      
    <2���� ���̺� ����>
    create table tbl_trg1
    (
        hak varchar2(10) primary key
      , name varchar2(20)
      , kor number(3)
      , eng number(3)
      , mat number(3)
    );
    -- Table TBL_TRG1��(��) �����Ǿ����ϴ�.
    
    create table tbl_trg2
    (
      hak varchar2(10) primary key
      , tot number(3)
      , avg number(5,2)
      , constraint fk_test2_hak foreign key(hak)   references tbl_trg1(hak)
    );
    -- Table TBL_TRG2��(��) �����Ǿ����ϴ�.


    <Ʈ���� ����>
    CREATE OR REPLACE TRIGGER ut_trg1DML AFTER
    INSERT ON tbl_trg1
    FOR EACH ROW
    DECLARE
        vtot tbl_trg2.tot%TYPE;
        vavg tbl_trg2.avg%TYPE;
    BEGIN
        vtot := :NEW.kor + :NEW.eng + :NEW.mat;
        vavg := vtot/3;
        INSERT INTO tbl_trg2 (hak, tot, avg) VALUES (:NEW.hak, vtot, vavg);
    -- EXCEPTION
    END;
    
    -- ORA-04082: NEW or OLD references not allowed in table level triggers
    -- ���� : ���̺� ���� Ʈ���ſ��� :NEW, :OLD Ű���� ������ ������� �ʴ´�.
    -- �ذ� : FOR EACH ROW�� ������ �ذ� -> �� ���� Ʈ���ŷ� ����
    
    --> Trigger UT_TRG1DML��(��) �����ϵǾ����ϴ�.
    
    <����>
    INSERT INTO tbl_trg1 ( hak, name, kor, eng, mat ) VALUES ( 1, 'hong', 90,78, 99 );

    <Ȯ��>
    SELECT * FROM tbl_trg1;
    SELECT * FROM tbl_trg2;
    
    COMMIT;
    
--------------------------------------------------------------------
����3) �л��� ������ ����(UPDATE) -> �ڵ����� tbl_trg2 ���̺��� ����, ��� ����
    -- 1	hong	90	78	99  :OLD
    -- 1	hong	87	67	100 :NEW
    <Ʈ���� ����>
    CREATE OR REPLACE TRIGGER ut_trg1DML AFTER
    INSERT OR UPDATE ON tbl_trg1
    FOR EACH ROW
    DECLARE
        vtot tbl_trg2.tot%TYPE;
        vavg tbl_trg2.avg%TYPE;
    BEGIN
        vtot := :NEW.kor + :NEW.eng + :NEW.mat; -- 1	hong	87	67	100 :NEW
        vavg := vtot/3;
        
        IF INSERTING THEN
            INSERT INTO tbl_trg2 (hak, tot, avg) VALUES (:NEW.hak, vtot, vavg);
        ELSIF UPDATING THEN
            UPDATE tbl_trg2
            SET tot = vtot , avg = vavg
            WHERE hak = :NEW.hak; -- == :OLD.hak;
        END IF;  
    -- EXCEPTION
    END;

    --> Trigger UT_TRG1DML��(��) �����ϵǾ����ϴ�.    

    <����>
    UPDATE tbl_trg1
    SET kor = 87, eng = 67, mat = 100
    WHERE hak = 1;
    
    <Ȯ��>
    SELECT * FROM tbl_trg1;
    SELECT * FROM tbl_trg2;
    
    COMMIT;
    
-----------------------------------------------------
����) tbl_trg1 ���̺� �й� 1�� �л��� �����ϸ� �ڵ����� tbl_trg2 ���̺��� �й� 1 �л��� �����ϴ�
    Ʈ���Ÿ� ���� �׽�Ʈ�ϼ���.

    <Ʈ���� ����>
    CREATE OR REPLACE TRIGGER ut_trg1DML AFTER
    INSERT OR UPDATE OR DELETE ON tbl_trg1
    FOR EACH ROW
    DECLARE
        vtot tbl_trg2.tot%TYPE;
        vavg tbl_trg2.avg%TYPE;
    BEGIN
        vtot := :NEW.kor + :NEW.eng + :NEW.mat; -- 1	hong	87	67	100 :NEW
        vavg := vtot/3;
        
        IF INSERTING THEN
            INSERT INTO tbl_trg2 (hak, tot, avg) VALUES (:NEW.hak, vtot, vavg);
        ELSIF UPDATING THEN
            UPDATE tbl_trg2
            SET tot = vtot , avg = vavg
            WHERE hak = :NEW.hak; -- == :OLD.hak;
        ELSIF DELETING THEN
            DELETE tbl_trg2
            WHERE hak = :OLD.hak; -- ���ο� �����Ͱ� �ƴ϶� ���� ������ �̴ϱ� :OLD
        END IF;  
    -- EXCEPTION
    END;
    
    <����>
    DELETE tbl_trg1
    WHERE hak = 1;
    
    <Ȯ��>
    SELECT * FROM tbl_trg1;
    SELECT * FROM tbl_trg2;
    
    ROLLBACK;    
    