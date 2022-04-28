-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]
1. PL/SQL�� ��Ű��(PACKAGE)  
 1) ����Ǵ� Ÿ��, ���α׷� ��ü, �������α׷�(procedure, function)�� �������� ���� ���� ���� �ǹ�
 2) ��Ű���� specification�� body �κ����� �Ǿ� ������, ����Ŭ���� �⺻������ �����ϴ� ��Ű���� �ִ�.
 3) SPECIFICATION �κ��� type, constant, variable, exception, cursor, sub program(�������ν���, ���� �Լ�)�� ����ȴ�. 
 4) BODY �κ��� cursor, subprogram ������ �����Ѵ�.
 5) ȣ���� �� '��Ű��_�̸�.���ν���_�̸�' ������ ������ �̿��ؾ� �Ѵ�.  
-----

��. SPECIFICATION �κ�

CREATE OR REPLACE PACKAGE logon_pkg
AS
    PROCEDURE up_idCheck
    (
        pempno IN emp.empno%TYPE -- ID�� ���� �Ķ����
        , pempnoCheck OUT NUMBER -- ��밡�ɿ���(0, 1)�� �����ִ� �Ķ����
    );
    
    PROCEDURE up_logon
    (
        pempno IN emp.empno%TYPE -- ID�� ���� �Ķ����(ID ��� ���)
        , pename IN emp.ename%TYPE -- PW ���� �Ķ����
        , plogonCheck OUT NUMBER -- �α��� ���� 0, ID�� ����X 1, PW�� ��ġ���������� -1
    );
    
    FUNCTION uf_age
    (
        prrn VARCHAR2
    )
    RETURN NUMBER;
    
END logon_pkg; 
--> Package LOGON_PKG��(��) �����ϵǾ����ϴ�.

��. BODY �κ�
CREATE OR REPLACE PACKAGE BODY logon_pkg
AS
    PROCEDURE up_idCheck
    (
        pempno IN emp.empno%TYPE -- ID�� ���� �Ķ����
        , pempnoCheck OUT NUMBER -- ��밡�ɿ���(0, 1)�� �����ִ� �Ķ����
    )
    IS
    BEGIN
        SELECT COUNT(*) INTO pempnoCheck
        FROM emp
        WHERE empno = pempno;
    -- EXCEPTION
    END up_idCheck;
    
    PROCEDURE up_logon
    (
        pempno IN emp.empno%TYPE -- ID�� ���� �Ķ����(ID ��� ���)
        , pename IN emp.ename%TYPE -- PW ���� �Ķ����
        , plogonCheck OUT NUMBER -- �α��� ���� 0, ID�� ����X 1, PW�� ��ġ���������� -1
    )
    IS
        vename emp.ename%TYPE; -- ���� ��й�ȣ�� ������ ����
    BEGIN
        SELECT COUNT(*) INTO plogonCheck
        FROM emp
        WHERE empno = pempno;

        IF plogonCheck = 1 THEN -- ID�� �����Ѵٸ�

            SELECT ename INTO vename
            FROM emp
            WHERE empno = pempno;

            IF vename = pename THEN -- ID�� �����ϰ� PW ��ġ�ϸ�
              plogonCheck := 0; -- �α��� ����
            ELSE
              plogonCheck := -1; -- ID�� ���������� PW ��ġ���� ������ -1 ��ȯ
            END IF;

        ELSE
            plogonCheck := 1; -- ID�� �������� �ʴ� ���
        END IF;
    -- EXCEPTION
    END up_logon;
    
    FUNCTION uf_age
    (
        prrn VARCHAR2
    )
    RETURN NUMBER
    IS
        vischeck NUMBER(1);
        vt_year NUMBER(4);
        vb_year NUMBER(4);
        vage NUMBER(3);
    BEGIN
        vischeck :=  SIGN(  TRUNC( SYSDATE ) -  TO_DATE(  SUBSTR( prrn, 3,4), 'MMDD') );
        vt_year := TO_CHAR( SYSDATE  , 'YYYY');
        vb_year := CASE  
                     WHEN SUBSTR( prrn, 8, 1 ) IN (1,2,5,6) THEN '1900' + SUBSTR( prrn, 1,2)
                     WHEN SUBSTR( prrn, 8, 1 ) IN (3,4,7,8) THEN '2000' + SUBSTR( prrn, 1,2)
                     ELSE '1800'  + SUBSTR( prrn, 1,2)
                    END;
    
       vage :=  CASE  vischeck
                    WHEN -1 THEN  -- ���� ��������
                     vt_year - vb_year - 1
                    ELSE   -- 0, 1
                     vt_year - vb_year
                END;         
    
        RETURN vage;
    END uf_age;
    
END logon_pkg;
--> Package Body LOGON_PKG��(��) �����ϵǾ����ϴ�.



<���� �׽�Ʈ>
SELECT name, ssn
    , logon_pkg.uf_age(ssn) age
FROM insa;

DECLARE
  vempnoCheck NUMBER;
BEGIN
  logon_pkg.up_idcheck( 1111 , vempnoCheck);
  DBMS_OUTPUT.PUT_LINE( vempnoCheck );
END;


---------------------------------------------------------------
2. Ŀ��(CURSOR) + �Ķ���͸� �̿��ϴ� ���
----------------------------------------------------------------
    CREATE OR REPLACE PROCEDURE up_selDeptEmp
    (
        pdeptno emp.deptno%TYPE
    )
    IS
        vename emp.ename%TYPE;
        vsal emp.sal%TYPE;
        
        -- (2) Ŀ���� ���� ���� �����ϰ�
        CURSOR cemplist ( cdeptno dept.deptno%TYPE ) 
        IS ( SELECT ename, sal
             FROM emp
             WHERE deptno = cdeptno
            );
    BEGIN
        
        OPEN cemplist(pdeptno); -- (1) �Ķ���ͷ� ���� ���� Ŀ������ ���Խ����ְ�
        
        LOOP
            FETCH cemplist INTO vename, vsal; -- Ŀ������ ������ ������ ��´�.
            EXIT WHEN cemplist%NOTFOUND; -- Ŀ���� ���̻� ������ ���� ���� �� ������ ���ǹ�
            DBMS_OUTPUT.PUT_LINE(vename || ', ' || vsal);
        END LOOP;
        
        CLOSE cemplist;
    -- EXCEPTION
    END;
    
    EXEC UP_SELDEPTEMP(30);

---------------------------------------
3. ***** SYS_REFCURSOR Ÿ��( ����Ŭ 9i �������� ������ REF CURSORS ��� Ÿ���� �־���)
SYS_
    REF ����
        CURSOR Ŀ��
--------------------------------------
    - Ŀ���� �Ű������� �޾Ƽ� ����ϴ� ���� ���ν���
    CREATE OR REPLACE PROCEDURE up_selInsa
    (
        pcursor SYS_REFCURSOR -- Ŀ���� �Ű������� �޴´ٴ� �ǹ�! Ŀ�� �Ķ����
    )
    IS
        vname insa.name%TYPE;
        vcity insa.city%TYPE;
        vbasicpay insa.basicpay%TYPE;
    BEGIN
        LOOP
            FETCH pcursor INTO vname, vcity, vbasicpay;
            EXIT WHEN pcursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vname || ', ' || vcity || ', ' || vbasicpay);
        END LOOP;
    --EXCEPTION
    END;
    
    -->Procedure UP_SELINSA��(��) �����ϵǾ����ϴ�.
    - ���� ���ν����� �׽�Ʈ�ϴ� ���ν��� ����
    CREATE OR REPLACE PROCEDURE up_test_selInsa
    IS
        vcursor SYS_REFCURSOR; -- Ŀ�� ���� ����
    BEGIN
        OPEN vcursor FOR SELECT name, city, basicpay FROM insa;
        UP_SELINSA(vcursor); -- UP_SELINSA �������ν����� ȣ���Ϸ��� Ŀ�� �Ķ����(����)�� �ʿ���
        -- ���� �۾��� LOOP �۾��� ����ϴ� ��
        CLOSE vcursor;
    --EXCEPTION
    END;
    --> Procedure UP_TEST_SELINSA��(��) �����ϵǾ����ϴ�.
    
    EXEC up_test_selInsa;
    
    --------------------------------------
    CREATE OR REPLACE PROCEDURE up_selInsa
    (
        pcursor OUT SYS_REFCURSOR -- ��¿� �Ű����� Ŀ�� ���
    )
    IS
    BEGIN
        OPEN pcursor FOR SELECT name, city, basicpay FROM insa;
    END;
    
    -- JDBC = JAVA + Oracle �����Ͽ� ����ϴ� ��

----------------------------------------------------------------------------
4. PL/SQL �� ������ ������ ó���ϴ� �� : EXCEPTION ��(��)
�׸�                  ���� �ڵ�   ���� 
NO_DATA_FOUND       ORA-01403  SQL���� ���� �˻������� �����ϴ� ����� ���� ���� ������ ��� 
NOT_LOGGED_ON       ORA-01012  �����ͺ��̽��� ������� ���� ���¿��� SQL�� �����Ϸ��� ��� 
TOO_MANY_ROWS       ORA-01422  SQL���� �������� ���� ���� ���� ��ȯ�ϴ� ���, ��Į�� ������ �����Ϸ��� �� �� �߻� 
VALUE_ERROR         ORA-06502  PL/SQL �� ���� ���ǵ� ������ ���̺��� ū ���� �����ϴ� ��� 
ZERO_DEVIDE         ORA-01476  SQL���� ���࿡�� �÷��� ���� 0���� ������ ��쿡 �߻� 
INVALID_CURSOR      ORA-01001  �߸� ����� Ŀ���� ���� ������ �߻��ϴ� ��� 
DUP_VAL_ON_INDEX    ORA-00001  �̹� �ԷµǾ� �ִ� �÷� ���� �ٽ� �Է��Ϸ��� ��쿡 �߻� 


    ��)
    CREATE OR REPLACE PROCEDURE up_exception01
    (
        psal emp.sal%TYPE -- �Ķ����
    )
    IS
        vename emp.ename%TYPE; -- �̸��� ���� ����
    BEGIN
        SELECT ename INTO vename -- ����� �˻��ؼ� ������ ��ƶ�
        FROM emp
        WHERE sal = psal; -- �Ķ���ͷ� ���� �ݾװ� ����
        
        DBMS_OUTPUT.PUT_LINE(psal || ' => ' || vename);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN -- Oracle���� �̸� ���ǵ� ����
            RAISE_APPLICATION_ERROR(-20002, '>QUERY DATA NOT FOUND<');
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20003, '>QUERY TOO MANY ROWS FOUND<');
        WHEN OTHERS THEN -- ������ ó���ϴ� ���ܰ� �ƴ� �ٸ� ��� ���ܵ� ó��
            RAISE_APPLICATION_ERROR(-20004, '>QUERY OTHERS EXCEPTION FOUND<');
    END;
    --> Procedure UP_EXCEPTION01��(��) �����ϵǾ����ϴ�.
    
    <���� �� Ȯ��>
    EXEC UP_EXCEPTION01(1250);
    EXEC UP_EXCEPTION01(6000);
    EXEC UP_EXCEPTION01(800);

------------------------------------------------------------------------------
- �̸� ���ǵ��� ���� ���ܸ� ó���ϴ� ���(�̸� ���ǵ� 7���� ���ܿ� ���� ���� ó��)
INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
        VALUES (9999, 'admin', 'CLERK', 9000, SYSDATE, 950, null, 90 );
ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found

--
    CREATE OR REPLACE PROCEDURE up_insEmp
    (
        pempno emp.empno%TYPE
        , pename emp.ename%TYPE
        , pjob emp.job%TYPE
        , pmgr emp.mgr%TYPE
        , phiredate emp.hiredate%TYPE
        , psal emp.sal%TYPE
        , pcomm emp.comm%TYPE
        , pdeptno emp.deptno%TYPE
    )
    IS
        -- ���� ���� ���ܰ�ü�� 02291 �ڵ� ��ȣ ������ �߻��ϰ� �Ǹ� ó���ϰڴٶ�� ����
        ve_invalid_deptno EXCEPTION; -- �߸��� �μ���ȣ�� ��ٴ� ����(���� ���� ����� ���� ����)
        -- ���� ��ü ����(����)�� �� PRAGMA EXCEPTION �� ����Ѵ�.
        PRAGMA EXCEPTION_INIT(ve_invalid_deptno, -02291); -- �ڵ��ȣ �տ��� -�� �� ���δ�.
    BEGIN
        INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
                VALUES (pempno, pename, pjob, pmgr, phiredate, psal, pcomm, pdeptno);
        COMMIT;
    EXCEPTION
        WHEN ve_invalid_deptno THEN 
            RAISE_APPLICATION_ERROR(-20999, '>QUERY DEPTNO FK NOT FOUND<');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20004, '>QUERY OTHERS EXCEPTION FOUND<');
    END;
    --> Procedure UP_INSEMP��(��) �����ϵǾ����ϴ�.

<���� �� Ȯ��>
    EXEC up_insEmp(9999, 'admin', 'CLERK', 9000, SYSDATE, 950, null, 90 );
    -- �츮�� ������ ���� �ڵ尡 �߻��Ǵ� ���� Ȯ���� �� ����
    ���� ���� -
    ORA-20999: >QUERY DEPTNO FK NOT FOUND<
    ORA-06512: at "SCOTT.UP_INSEMP", line 23
    ORA-06512: at line 1
    
----------------
[����ڰ� �����ϴ� ���� ó�� ���]

CREATE OR REPLACE PROCEDURE up_exception02
(
    psal IN emp.sal%TYPE
)
IS
    vempcount NUMBER;
    
    ve_no_emp_returned EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO vempcount
    FROM emp
    WHERE sal BETWEEN (psal-100) AND (psal+100); -- �Է¹��� �Ķ���ͺ��� +-100 ������ �ִ�..
    
    IF vempcount = 0 THEN
        -- 0�� �� ���� ���� �߻�
        -- RAISE ����ڿ��ܰ�ü;
        RAISE ve_no_emp_returned;
    ELSE
        DBMS_OUTPUT.PUT_LINE('>ó�� ��� : ' || vempcount);
    END IF;
EXCEPTION
    WHEN ve_no_emp_returned THEN
        RAISE_APPLICATION_ERROR(-20011, '>QUERY EMP COUNT = 0 ...<');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, '>QUERY OTHERS EXCEPTION FOUND<');
END;
--> Procedure UP_EXCEPTION02��(��) �����ϵǾ����ϴ�.

EXEC UP_EXCEPTION02(500);





