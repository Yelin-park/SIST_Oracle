-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]
1. Ʈ�����(Transaction)
2. ��������
3. ��ȣȭ/��ȣȭ
--------------------------------------------------------------------------------
1. Ʈ�����(Transaction)
--------------------------------------------------------------------------------
    1) Ʈ�����(Transaction)�̶� ���� ó���� �Ϸ���� ���� �߰� ������ ����Ͽ� ���� ���� �� �ܰ�� �ǵ����� ����̴�.
    2) ����� ����Ǳ������ �߰� �ܰ迡�� ������ �߻��Ͽ��� ��� ��� �߰� ������ ��ȿȭ�Ͽ� �۾��� ó�� ���� �� �ܰ�� �ǵ����� ��
    3) ���� ��� �Ϸ�Ǹ� �˸��� COMMIT �� ���� ��Ҹ� �˸��� ROLLBACK �� ���δ�.
    4) DML���� �����ϸ� �ش� Ʈ�����ǿ� ���� �߻��� �����Ͱ� �ٸ� ����ڿ� ���� ������ �߻����� �ʵ��� LOCK(�������)�� �߻��Ѵ�.
    5) LOCK�� COMMIT �Ǵ� ROLLBACK ���� ����Ǹ� �����ȴ�.

    ��)
         (1) A ���忡�� UPDATE 100���� �����ϴ� DML
         (2) B ���忡�� UPDATE 100���� �����ϴ� DML
            (1) + (2) ��� �Ϸ�Ǹ� COMMIT
                      �ϳ��� �����ϸ� ��� ����ġ ��Ű�� ROLLBACK
    
         (1) �԰����̺� A��ǰ 15�� �԰� -> INSERT 15
         (2) ������̺� A��ǰ 100�� + 15�� ���� -> UPDATE 15
              (1) + (2) ��� �Ϸ�Ǹ� COMMIT
                        �ϳ��� �����ϸ� ��� ����ġ ��Ű�� ROLLBACK
    
        > ���� ���� �۾���.. Ʈ����� ó�� �ʿ� + �԰����̺� INSERT�� �� �� Ʈ���ŷ� ������̺� UPDATE�ϴ� Ʈ���� ���� ó��                
        
    -- A ����ڰ� �������� SCOTT ���� ����
    6) A Ʈ����� �׽�Ʈ
    
        SELECT *
        FROM emp;
    
    7369	SMITH	CLERK	7902	80/12/17	800		20
    (1) SMITH�� JOB�� CLERK -> MANAGER ����
        UPDATE emp
        SET job = 'MANAGER'
        WHERE ename ='SMITH';
        --> 1 �� ��(��) ������Ʈ�Ǿ����ϴ�.
        -- DML�� �����ϸ� ���(LOCK)
        -- COMMIT, ROLLBACK �۾��� ���ؼ� ��� ����X
    
    COMMIT;
    --> Ŀ�� �Ϸ�.   
    
    (2)SMITH�� JOB�� MANAGER -> CLERK ����
            UPDATE emp
            SET job = 'CLERK'
            WHERE ename ='SMITH';
        --> 1 �� ��(��) ������Ʈ�Ǿ����ϴ�.    
        -- DML�� �����ϸ� ���(LOCK)
        -- COMMIT, ROLLBACK �۾��� ���ؼ� ��� ����X
        COMMIT;
        
    ��� : INSERT/ UPDATE / DELETE ���� �� COMMIT, ROLLBACK
            ���ϸ� LOCK ������ �ȵǼ� ���ѷ����� ������.
    
    DML���� ����ϸ� �ڵ����� Ʈ������� �ɸ���(LOCK)
    DDL / DCL �����ϸ� Ʈ������� ����ȴ�.
    �����ͺ��̽� ����� Ʈ����� ����
    ------------------------------------        
    7) [ DEAD LOCK(�����)] 
        �ͼ��� - å����� �� ��ġ O, ����̹� X
        ������ - �ξ����� �� ��ġ X, ����̹� O
        ���� ���� ���� �޶�� �ο�
        
        A : ��ġ + ��X UPDATE ������
        ȫ�浿 : ��ġX + �� UPDATE ������    
    
    ------------------------------------  
    
    8) DQL ������ ����� �� �ִ� �� : FOR UPDATE OF
        - SELECT ���� ���� �ش� ���ڵ忡 lock�� �Ŵ� �����̴�.
         (DQL + Ʈ�����(LOCK)
        - ������ ���� COMMIT, ROLLBACK ���
     
        SELECT *
        FROM emp
        FOR UPDATE OF JOB NOWAIT;

--------------------------------------------------------------------------------
2. TCL�� SAVEPOINT
--------------------------------------------------------------------------------
COMMIT;

SELECT *
FROM dept;

1) ����
SAVEPOINT sp_dept_delete;
DELETE FROM dept WHERE deptno = 60; -- LOCK ����

2) �߰�
SAVEPOINT sp_dept_insert;
INSERT INTO dept VALUES(50, 'AA', 'YY'); -- LOCK ����

3) ����
SAVEPOINT sp_dept_update;
UPDATE dept
SET loc = 'SEOUL'
WHERE deptno = 40; -- LOCK ����


(1)
ROLLBACK; -- ��� �۾� ���, LOCK ����
    
(2) ���� �۾� ���� �ѹ��ϰ�ʹ�
ROLLBACK TO SAVEPOINT sp_dept_insert;

--------------------------------------------------------------------------------
3. [ ���� SQL ] *****
    JAVA ���� �迭
    int[] m;
    int length = 10;
    m = new int[length];
--------------------------------------------------------------------------------
    1) ���� SQL ? ������ �ÿ� SQL ������ Ȯ���� ���� �ʴ� ��� -> ������ �� SQL ���� Ȯ��
    
    SELECT *
    FORM �Խ��� ���̺�
    -- ���� �˻�
    IF ���� �˻��� ��� THEN
        WHERE ������ LIKE '�浿';
    -- ���� + ���� �˻�
    ELSIF ����+�������� �˻��� ��� THEN
        WHERE ������ LIKE '�浿' OR ���� LIKE '�浿';
    END IF;
    
    5�� ������ ���... ���� ���� ������ �� ����.. �̷� �� �������� ���!

    2) WHERE ������, SELECT �÷�.. �̷� �׸���� �������� ���ϴ� ��� ����Ѵ�.
    SELECT ?,?,?,?
    FROM
    WHERE ? AND ? OR ? ? ?......
    
    3) PL/SQL ���� DDL(CREATE, ALTER, DROP + TRUNCATE) ���� �����ϴ� ���
    
    4) PL/SQL ���� ALTER SESSION / SYSTEM ��ɾ �����ϴ� ��� -> DBA�� �ƴ� �̻� ���� �� �� ����
    
    5) ���� ������ ����ϴ� 2���� ���
     **** (1) ���� ���� ����(Native Dynamic SQL : NDS)
     (2) DBMS_SQL ��Ű�� ��� -> �̰� �Ⱦ˷��ֽ�
     
    6) ���� ������ ���� ���
     (1) EXECUTE IMMEDIATE ����������
                            [INTO ��] -> INTO ������, ������..  
                            [USING MODE(IN, OUT, IN OUT) ��] -> USING �Ķ����, �Ķ����...

    7) ���� ���� ����(�ۼ�) -> ���� �׽�Ʈ          
    DECLARE
        vdsql VARCHAR2(1000);
        vdeptno emp.deptno%TYPE;
        vempno emp.empno%TYPE;
        vename emp.ename%TYPE;
        vjob emp.job%TYPE;
    BEGIN
        -- ��. ���� ���� �ۼ�
        vdsql := 'SELECT deptno, empno, ename, job ';
        vdsql := vdsql || ' FROM emp ';
        vdsql := vdsql || ' WHERE empno = 7369 ';
    
        -- ��. ���� ���� ����
        EXECUTE IMMEDIATE vdsql INTO vdeptno, vempno, vename, vjob;
                            
        DBMS_OUTPUT.PUT_LINE(vdeptno || ', ' || vempno || ', ' || vename || ', ' || vjob);                            
    
    -- EXCEPTION
    END;

-------------------------------------------------------------    
    ��2) �������ν����� ����ؼ� �������� �ۼ� �� ����
    CREATE OR REPLACE PROCEDURE up_dselEmp 
    (
        pempno emp.empno%TYPE
    )
    IS
        vdsql VARCHAR2(1000);
        vdeptno emp.deptno%type;
        vempno emp.empno%type;
        vename emp.ename%type;
        vjob emp.job%type;
    BEGIN
        -- ��. ���� ���� �ۼ�
          vdsql :=  'SELECT deptno, empno, ename, job ';
          vdsql :=   vdsql || 'FROM emp ';
          vdsql :=  vdsql ||  'WHERE empno = :pempno ' ;
    
        -- ��. ���� ���� ����
        EXECUTE IMMEDIATE vdsql
                    INTO vdeptno, vempno, vename, vjob
                    USING pempno;
                            
        DBMS_OUTPUT.PUT_LINE( vdeptno  || ', ' || vempno || ', ' || vename || ', ' || vjob );                            
    
    -- EXCEPTION
    END;  
    
    EXEC up_dselEmp(7369);
    
-------------------------------------------------------------        
    ��3) �������ν����� ����ؼ� �������� �ۼ� �� ���� (INSERT)
    CREATE OR REPLACE PROCEDURE up_dinsDept
    (
      pdname dept.dname%type
      , ploc dept.loc%type

    )
    IS
        vdsql VARCHAR2(1000);
        vdeptno dept.deptno%type;
    BEGIN
    
        SELECT MAX(deptno)+10 INTO vdeptno FROM dept;
        -- ��. ���� ���� �ۼ�
        vdsql :=  'INSERT INTO dept ';
        vdsql :=   vdsql || ' VALUES ( :deptno, :dname, :loc ) '; 
    
        -- ��. ���� ���� ����
        EXECUTE IMMEDIATE vdsql                    
                USING vdeptno, pdname, ploc;
                
        -- COMMIT;                           
    
    -- EXCEPTION
    END;    
    
SELECT * FROM dept;

EXEC UP_DINSDEPT( 'QC', 'SEOUL');

ROLLBACK;

    
-------------------------------------------------------------    
    ��4)
    DECLARE
        vsql VARCHAR2(1000);
        vtableName VARCHAR2(20);
    BEGIN
        vtableName := 'tbl_nds';
        vsql := 'CREATE TABLE ' || vtableName ;
        -- vsql := 'CREATE TABLE :tableName ' ;
        vsql := vsql || ' ( ' ;
        vsql := vsql || '       id number primary key ' ;
        vsql := vsql || '       , name varchar2(20) ' ;
        vsql := vsql || ' ) ' ;
    
        DBMS_OUTPUT.PUT_LINE(vsql); -- �׽�Ʈ�� ��½��Ѻ��� ��
        
        EXECUTE IMMEDIATE vsql;
                            -- USING vtableName;
    END;
    
    <Ȯ��>
    DESC tbl_nds;

-------------------------------------------------------------        
    ��5) OPEN FOR �� ����? ���� SQL�� ���� ����� [���� ���� ���ڵ�(��) ��ȯ]�ϴ� [SELECT��] + [Ŀ��]

CREATE OR REPLACE PROCEDURE up_nds02
(
    pdeptno dept.deptno%TYPE
)
IS
    vsql VARCHAR2(1000);
    vrow emp%ROWTYPE;
    vcursor SYS_REFCURSOR;
BEGIN
    vsql := 'SELECT * ';
    vsql := vsql || 'FROM emp ';
    vsql := vsql || 'WHERE deptno = :deptno ';
    
    -- EXECUTE IMMEDIATE �������� ���X
    -- OPEN FOR �� ����Ѵ�.
    OPEN vcursor FOR vsql USING pdeptno;
    LOOP
        FETCH vcursor INTO vrow;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vrow.empno || ', ' || vrow.ename);
    END LOOP;
    CLOSE vcursor;
END;
--> Procedure UP_NDS02��(��) �����ϵǾ����ϴ�.

EXEC UP_NDS02(30);