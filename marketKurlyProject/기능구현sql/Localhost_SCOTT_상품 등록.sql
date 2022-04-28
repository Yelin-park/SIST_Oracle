[2. 상품 등록]
1) 상품 코드 시퀀스 생성
/*
CREATE SEQUENCE seq_mk_product_code
INCREMENT BY 1
START WITH 11
NOMAXVALUE
MINVALUE 1
NOCYCLE;
*/

1-1) 상품 코드 시퀀스 삭제
-- DROP SEQUENCE seq_mk_product_code;

--------------------------------------------------
2) 상품 등록 저장 프로시저 생성 -- 파일경로 파라미터 안줬을 때 사용자정의예외발생 할 수 없음. PL/SQL 구문 자체의 오류 문제라서..
CREATE OR REPLACE PROCEDURE mk_p_product
(
    pP_NAME product.p_name%TYPE
    , pP_PRICE product.P_PRICE%TYPE
    , pP_DISCOUNT product.P_DISCOUNT%TYPE
    , pP_DETAIL product.P_DETAIL%TYPE
    , pP_COLD_TYPE product.P_COLD_TYPE%TYPE
    , pV_CODE product.V_CODE%TYPE
    , pCTGR_CODE product.CTGR_CODE%TYPE
    , pB_CODE product.B_CODE%TYPE
    , pP_RDATE product.P_RDATE%TYPE
    , pPATH product_img.file_path%TYPE
)
IS
    vP_DETAIL product.P_DETAIL%TYPE;
    vV_CODE product.V_CODE%TYPE;
    vB_CODE product.B_CODE%TYPE;
    vP_PRICE product.P_PRICE%TYPE;
    vP_DISCOUNT product.P_DISCOUNT%TYPE;
    
    e_no_code EXCEPTION;
    e_null_product EXCEPTION;
    e_cold_type EXCEPTION;
    e_price EXCEPTION;
    e_discount EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_no_code, -02291);
    PRAGMA EXCEPTION_INIT(e_null_product, -01400);
    PRAGMA EXCEPTION_INIT(e_cold_type, -02290);
BEGIN
    
    IF pP_DETAIL IS NOT NULL THEN
        vP_DETAIL := pP_DETAIL;
    ELSE vP_DETAIL := null;
    END IF;
    
    IF pV_CODE IS NOT NULL THEN
        vV_CODE := pV_CODE;
    ELSE vV_CODE := null;
    END IF;
    
    IF pB_CODE IS NOT NULL THEN
        vB_CODE := pB_CODE;
    ELSE vB_CODE := null;
    END IF;
    
    IF pP_price >= 0 THEN
        vP_PRICE := pP_price;
    ELSE
        RAISE e_price;
    END IF;
    
    IF pP_DISCOUNT BETWEEN 0 AND 1 THEN
        vP_DISCOUNT := pP_DISCOUNT;
    ELSE 
        RAISE e_discount;
    END IF;

    INSERT INTO product (P_CODE, P_NAME, P_PRICE, P_DISCOUNT, P_DETAIL, P_COLD_TYPE, V_CODE, CTGR_CODE, B_CODE, P_RDATE)
    VALUES (seq_mk_product_code.nextval, pP_NAME, vP_PRICE, pP_DISCOUNT, vP_DETAIL, pP_COLD_TYPE, vV_CODE, pCTGR_CODE, vB_CODE, pP_RDATE);
    COMMIT;
        
    MK_P_PRODUCTIMG(seq_mk_product_code.currval, pPATH);
    
EXCEPTION
    WHEN e_no_code THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20010, '납품업체 / 카테고리 / 특가혜택 코드가 존재하지 않습니다.');
    WHEN e_null_product THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, '필수항목을 입력해 주세요.');
    WHEN e_cold_type THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, '상온1, 냉장2, 냉동3으로 입력해 주세요.');
    WHEN e_price THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20005, '가격은 0원 이상으로 입력해주세요.');
    WHEN e_discount THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20006, '할인가는 0.00 ~ 1.00(0% ~ 100%) 사이의 값으로 입력해주세요.');        
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, '상품 등록이 불가능합니다.');
END;

----------------------------------------
3) 상품 등록 테스트 및 확인
EXEC MK_P_PRODUCT('[커피빈] 바닐라 라떼 파우치', 1500, 0, '바닐라의 부드러운 매력', 2, 1, 'H5', null, SYSDATE, 'C:\admin\marketKurlyProject');
EXEC MK_P_PRODUCT('[폴 바셋] 바리스타 돌체라떼 330ml', 2900, 0, '간편하게 맛보는 달콤한 풍미', 2, 1, 'H5', null, SYSDATE, 'C:\admin\marketKurlyProject');

SELECT * FROM product;
SELECT * FROM product_img;

----------------------------------------
4) 예외처리 확인
EXEC MK_P_PRODUCT('[폴 바셋] 바리스타 돌체라떼 330ml', -2900, 0, '간편하게 맛보는 달콤한 풍미', 2, 1, 'H5', null, SYSDATE, 'C:\admin\marketKurlyProject'); -- 가격 문제
EXEC MK_P_PRODUCT('[폴 바셋] 바리스타 돌체라떼 330ml', 2900, 100, '간편하게 맛보는 달콤한 풍미', 2, 1, 'H5', null, SYSDATE, 'C:\admin\marketKurlyProject'); -- 할인가 문제
EXEC MK_P_PRODUCT('[폴 바셋] 바리스타 돌체라떼 330ml', 2900, 0, '간편하게 맛보는 달콤한 풍미', 5, 1, 'H5', null, SYSDATE, 'C:\admin\marketKurlyProject'); -- 상온냉장냉동문제
EXEC MK_P_PRODUCT('[폴 바셋] 바리스타 돌체라떼 330ml', 2900, 0, '간편하게 맛보는 달콤한 풍미', 2, 1, 'Z99', null, SYSDATE, 'C:\admin\marketKurlyProject'); -- 카테고리 코드 문제
EXEC MK_P_PRODUCT(null, 2900, 0, '간편하게 맛보는 달콤한 풍미', 2, 1, 'Z99', null, SYSDATE); -- 필수항목 문제



