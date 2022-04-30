-- 회원 테이블에 컬럼 추가
ALTER TABLE CUSTOMER
ADD withdrawal NUMBER DEFAULT 0 NOT NULL;

-----------------------------------------
-- 1) 회원 탈퇴하는 프로시저 생성
CREATE OR REPLACE PROCEDURE mk_p_customer_withdrawal
(
    pC_CODE CUSTOMER.C_CODE%TYPE
)
IS
    vC_CODE CUSTOMER.C_CODE%TYPE;
    vNUM NUMBER(1);
    
    e_no_c_code EXCEPTION;    
BEGIN

    SELECT COUNT(*) INTO vNUM
    FROM CUSTOMER
    WHERE C_CODE = pC_CODE;
    
    IF vNUM = 1 THEN
        vC_CODE := pC_CODE;
    ELSE
        RAISE e_no_c_code;
    END IF;
 
    UPDATE SIGN_UP
    SET (C_ID, C_PWD, C_ADDRESS, C_EMAIL, C_NAME, C_BIRTHDAY, C_PHONE)
        = (SELECT '회탈' || TRUNC(DBMS_RANDOM.VALUE(0,9999)), 'MARKETKURLYBYE', '-', 'MARKETKURLY@MARKETKURLY.COM', '-', SYSDATE, '010-0000-0000' FROM DUAL)
    WHERE C_CODE = vC_CODE;
    COMMIT; 
    
    UPDATE CUSTOMER
    SET C_NAME ='-', C_ID = '회탈' || TRUNC(DBMS_RANDOM.VALUE(0,9999)), WITHDRAWAL = 1
    WHERE C_CODE = vC_CODE;
    
EXCEPTION
    WHEN e_no_c_code THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20010, '존재하지 않는 회원코드입니다.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, '회원 탈퇴가 불가능합니다.');
END;

----------------------------------------
-- 2) 테스트 및 확인
EXEC MK_P_CUSTOMER_WITHDRAWAL(6);

SELECT *
FROM CUSTOMER
WHERE C_CODE = 28;

SELECT * FROM SIGN_UP;

-------------------------------------------
-- 3) 예외 처리 테스트
EXEC MK_P_CUSTOMER_WITHDRAWAL(100); -- 회원코드 존재 X



