-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]    
1. �������ν��� ���� �ٷ��
����1) ȸ�������Ҷ� ID �ߺ�üũ �ϴ� ���� ���ν��� ����
      ���� : emp ���̺��� empno(ID)��� ����
      ���ν����� ��¿� �Ķ���� �������ؼ� �� ���� 0�� ������ ID ��밡��, 1�� ������ ID ���Ұ���
    <����>
    CREATE OR REPLACE PROCEDURE up_idCheck
    (
        pempno IN emp.empno%TYPE -- ID�� ���� �Ķ����
        , pempnoCheck OUT NUMBER -- ��밡�ɿ���(0, 1)�� �����ִ� �Ķ����
    )
    IS
    BEGIN
        SELECT COUNT(*) INTO pempnoCheck
        FROM emp
        WHERE empno = pempno;
        -- ID�� �ִٸ� ������ �þ�ϱ� �ٷ� Ȯ�� ����.
    -- EXCEPTION
    END;
    
    <����>
    DECLARE
        vempnoCheck NUMBER;
    BEGIN
        UP_IDCHECK(7369, vempnoCheck);
        DBMS_OUTPUT.PUT_LINE(vempnoCheck);
    END;
    
    DECLARE
        vempnoCheck NUMBER;
    BEGIN
        UP_IDCHECK(1111, vempnoCheck);
        DBMS_OUTPUT.PUT_LINE(vempnoCheck);
    END;    

--------------
����2) ȸ�������� �Ŀ� ID/PW �Է��ϰ� �α���(����) -> ID : empno PW : ename
        �α��� ����, �α��� ����(ID, PW �� �߿� Ʋ�ȴٴ� �޽���)
    <����>
    CREATE OR REPLACE PROCEDURE up_logon
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
    END;        

    <����>
    DECLARE
        vlogonCheck NUMBER;
    BEGIN
        UP_LOGON(7369, 'SMITH', vlogonCheck); -- 0
        UP_LOGON(7369, 'YALIN', vlogonCheck); -- -1
        UP_LOGON(1111, 'YALIN', vlogonCheck); -- 1
        DBMS_OUTPUT.PUT_LINE(vlogonCheck);
    END;     

--------------    
2. STORED FUNCTION(�����Լ�)

SELECT num, name, ssn
FROM insa;

ssn �ֹε�Ϲ�ȣ�� �Ķ���ͷ� �Ѱ��ָ� ����/���ڸ� ��ȯ�ϴ� ���� �Լ�
�����Լ� == �������ν��� 99% ������, �������� ���ϰ��� ����(�����Լ��� ���ϰ��� ����)

    <����> uf = user function
    CREATE OR REPLACE FUNCTION uf_�����Լ���
    (
    )
    RETURN �����ڷ���
    IS
    BEGIN
    
    
        RETURN (���ϰ�); -- ��ȣ�� �־ �ǰ�, ��� ��
    -- EXCEPTION
    END;

--------
����1) �ֹε�Ϲ�ȣ�� �Է¹޾Ƽ� ������ ��ȯ�ϴ� �Լ� uf_gender ����

    <�����Լ� ����>
    CREATE OR REPLACE FUNCTION uf_gender
    (
      prrn VARCHAR2 -- �ֹι�ȣ�� �Է¹޴� �Ķ����
    )
    RETURN VARCHAR2 -- �����ڷ��� ����, '����'/'����'��� ����
    IS
        vgender VARCHAR2(6) := '����'; -- ������� ��� ����
    BEGIN
        
        IF MOD(SUBSTR(prrn, -7, 1), 2) = 1 THEN
            vgender := '����';
        END IF;
        
        RETURN vgender;
    -- EXCEPTION
    END;

    <����>
    SELECT num, name, ssn, uf_gender(ssn) gender
    FROM insa;

--
����2) uf_sum(10) 1~10���� ���� ��ȯ�ϴ� �Լ� + �׽�Ʈ �ڵ�
    CREATE OR REPLACE FUNCTION uf_sum
    (
        pnum NUMBER
    )
    RETURN NUMBER
    IS
        vi NUMBER;
        vsum NUMBER := 0; -- �⺻���� 0���� �����������
    BEGIN
        FOR vi IN 1..pnum
        LOOP
         vsum := vsum + vi;
        END LOOP;
        
        RETURN vsum;
    -- EXCEPTION
    END;
    
    SELECT uf_sum(10)
    FROM dual;

--
����1) �ֹε�Ϲ�ȣ�� �Է¹޾Ƽ� �������(yyyy.mm.dd)�� ��ȯ�ϴ� �Լ� uf_birth()
    <�����Լ� ����>
    CREATE OR REPLACE FUNCTION uf_birth
    (
        prrn VARCHAR2
    )
    RETURN VARCHAR2
    IS
        vbirth VARCHAR2(10);
        vgender NUMBER(1);
        vcentry NUMBER(2); -- ���⸦ �޴� ����
        vrrn6 VARCHAR2(6);
    BEGIN
        vrrn6 := SUBSTR(prrn, 0, 6);
        vgender := SUBSTR(prrn, -7, 1);
        vcentry := CASE
                    WHEN vgender IN(1,2,5,6) THEN 19
                    WHEN vgender IN(3,4,7,8) THEN 20
                    ELSE 18
                   END;
        vbirth := TO_CHAR(TO_DATE(CONCAT(vcentry, vrrn6)), 'YYYY.MM.DD');
        RETURN vbirth;
    END;
    
    <����>
    SELECT name, ssn, uf_birth(ssn)
    FROM insa;

����2) �ֹε�Ϲ�ȣ�� �Է¹޾Ƽ� �����̸� ��ȯ�ϴ� �Լ� uf_age()
CREATE OR REPLACE FUNCTION uf_age
(
    prrn VARCHAR2
)
RETURN VARCHAR2
IS
    vischeck NUMBER(1);
    vtyear NUMBER(4);
    vbyear NUMBER(4);
    vage NUMBER(3);
BEGIN
    vischeck :=  SIGN(  TRUNC( SYSDATE ) -  TO_DATE(  SUBSTR( prrn, 3,4), 'MMDD') );
    vt_year := TO_CHAR( SYSDATE  , 'YYYY');
    vb_year := CASE  
                 WHEN SUBSTR( prrn, 8, 1 ) IN (1,2,5,6) THEN '1900' + SUBSTR( prrn, 1,2)
                 WHEN SUBSTR( prrn, 8, 1 ) IN (3,4,7,8) THEN '2000' + SUBSTR( prrn, 1,2)
                 ELSE                                       '1800'  + SUBSTR( prrn, 1,2)
                END;
                
   vage :=  CASE  VISCHECK
                WHEN -1 THEN  -- ���� ��������
                 vt_year - vb_year-1
                ELSE   -- 0, 1
                 vt_year - vb_year
            END;         

    RETURN vage;
END;

------------------------
�����ٷ��) ���� ���ν����ε� MODE : INOUT(����¿�) �Ķ���� �Ű����� ���
��ȭ��ȣ�� 8765-8652
         8765 ��ȭ��ȣ ���ڸ��� ��¿� �Ű������� ���ڴ�.
    <���ν��� ����>
    CREATE OR REPLACE PROCEDURE up_tel4
    (
        pphone IN OUT VARCHAR2
    )
    IS
    BEGIN
        pphone := SUBSTR(pphone, 0, 4);
    -- EXCEPTION
    END;
    
    <����>
    DECLARE
        vphone VARCHAR2(9) := '8765-8652';
    BEGIN
        up_tel4(vphone);
        
        DBMS_OUTPUT.PUT_LINE(vphone);
    END;