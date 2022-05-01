? [배송비] 전체 금액 계산하는 함수
CREATE OR REPLACE FUNCTION mk_f_shipping_pay
(
    pc_code customer.c_code%TYPE,
    po_price NUMBER
)
RETURN NUMBER
IS
    v_shipping_pay NUMBER;
    v_pass_check NUMBER(1);
BEGIN

    SELECT c_curlypass INTO v_pass_check
    FROM customer
    WHERE c_code = pc_code;
    
    IF po_price < 15000 THEN
        v_shipping_pay := 3000;
    ELSIF v_pass_check = 0 AND po_price < 40000 THEN
        v_shipping_pay := 3000;
    ELSE
        v_shipping_pay := 0;
    END IF;
    
    RETURN v_shipping_pay;
END;