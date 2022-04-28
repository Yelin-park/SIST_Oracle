-- [ SCOTT에 접속된 스크립트 파일 ]    
1. 저장프로시저 예제 다루기
예제1) 회원가입할때 ID 중복체크 하는 저장 프로시저 생성
      가정 : emp 테이블에서 empno(ID)라고 가정
      프로시저에 출력용 파라미터 선언을해서 그 값이 0을 돌리면 ID 사용가능, 1을 돌리면 ID 사용불가능
    <생성>
    CREATE OR REPLACE PROCEDURE up_idCheck
    (
        pempno IN emp.empno%TYPE -- ID를 받을 파라미터
        , pempnoCheck OUT NUMBER -- 사용가능여부(0, 1)를 돌려주는 파라미터
    )
    IS
    BEGIN
        SELECT COUNT(*) INTO pempnoCheck
        FROM emp
        WHERE empno = pempno;
        -- ID가 있다면 갯수가 늘어나니까 바로 확인 가능.
    -- EXCEPTION
    END;
    
    <실행>
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
예제2) 회원가입한 후에 ID/PW 입력하고 로그인(인증) -> ID : empno PW : ename
        로그인 성공, 로그인 실패(ID, PW 둘 중에 틀렸다는 메시지)
    <생성>
    CREATE OR REPLACE PROCEDURE up_logon
    (
        pempno IN emp.empno%TYPE -- ID를 받을 파라미터(ID 대신 사용)
        , pename IN emp.ename%TYPE -- PW 받을 파라미터
        , plogonCheck OUT NUMBER -- 로그인 성공 0, ID가 존재X 1, PW가 일치하지않으면 -1
    )
    IS
        vename emp.ename%TYPE; -- 실제 비밀번호를 저장할 변수
    BEGIN
        SELECT COUNT(*) INTO plogonCheck
        FROM emp
        WHERE empno = pempno;
        
        IF plogonCheck = 1 THEN -- ID가 존재한다면
            
            SELECT ename INTO vename
            FROM emp
            WHERE empno = pempno;
            
            IF vename = pename THEN -- ID가 존재하고 PW 일치하면
              plogonCheck := 0; -- 로그인 성공
            ELSE
              plogonCheck := -1; -- ID가 존재하지만 PW 일치하지 않으면 -1 반환
            END IF;
            
        ELSE
            plogonCheck := 1; -- ID가 존재하지 않는 경우
        END IF;
    -- EXCEPTION
    END;        

    <실행>
    DECLARE
        vlogonCheck NUMBER;
    BEGIN
        UP_LOGON(7369, 'SMITH', vlogonCheck); -- 0
        UP_LOGON(7369, 'YALIN', vlogonCheck); -- -1
        UP_LOGON(1111, 'YALIN', vlogonCheck); -- 1
        DBMS_OUTPUT.PUT_LINE(vlogonCheck);
    END;     

--------------    
2. STORED FUNCTION(저장함수)

SELECT num, name, ssn
FROM insa;

ssn 주민등록번호를 파라미터로 넘겨주면 남자/여자를 반환하는 저장 함수
저장함수 == 저장프로시저 99% 같지만, 차이점은 리턴값의 유무(저장함수는 리턴값이 있음)

    <형식> uf = user function
    CREATE OR REPLACE FUNCTION uf_저장함수명
    (
    )
    RETURN 리턴자료형
    IS
    BEGIN
    
    
        RETURN (리턴값); -- 괄호는 있어도 되고, 없어도 됨
    -- EXCEPTION
    END;

--------
예제1) 주민등록번호를 입력받아서 성별을 반환하는 함수 uf_gender 생성

    <저장함수 생성>
    CREATE OR REPLACE FUNCTION uf_gender
    (
      prrn VARCHAR2 -- 주민번호를 입력받는 파라미터
    )
    RETURN VARCHAR2 -- 리턴자료형 선언, '남자'/'여자'라고 리턴
    IS
        vgender VARCHAR2(6) := '여자'; -- 결과물을 담는 변수
    BEGIN
        
        IF MOD(SUBSTR(prrn, -7, 1), 2) = 1 THEN
            vgender := '남자';
        END IF;
        
        RETURN vgender;
    -- EXCEPTION
    END;

    <실행>
    SELECT num, name, ssn, uf_gender(ssn) gender
    FROM insa;

--
예제2) uf_sum(10) 1~10까지 합을 반환하는 함수 + 테스트 코딩
    CREATE OR REPLACE FUNCTION uf_sum
    (
        pnum NUMBER
    )
    RETURN NUMBER
    IS
        vi NUMBER;
        vsum NUMBER := 0; -- 기본값을 0으로 설정해줘야함
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
문제1) 주민등록번호를 입력받아서 생년월일(yyyy.mm.dd)로 반환하는 함수 uf_birth()
    <저장함수 생성>
    CREATE OR REPLACE FUNCTION uf_birth
    (
        prrn VARCHAR2
    )
    RETURN VARCHAR2
    IS
        vbirth VARCHAR2(10);
        vgender NUMBER(1);
        vcentry NUMBER(2); -- 세기를 받는 변수
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
    
    <실행>
    SELECT name, ssn, uf_birth(ssn)
    FROM insa;

문제2) 주민등록번호를 입력받아서 만나이를 반환하는 함수 uf_age()
CREATE OR REPLACE FUNCTION uf_age
(
    prrn VARCHAR2
)
RETURN NUMBER;
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
                WHEN -1 THEN  -- 생일 안지난것
                 vt_year - vb_year-1
                ELSE   -- 0, 1
                 vt_year - vb_year
            END;         

    RETURN vage;
END;

------------------------
예제다루기) 저장 프로시저인데 MODE : INOUT(입출력용) 파라미터 매개변수 사용
전화번호를 8765-8652
         8765 전화번호 앞자리만 출력용 매개변수로 쓰겠다.
    <프로시저 생성>
    CREATE OR REPLACE PROCEDURE up_tel4
    (
        pphone IN OUT VARCHAR2
    )
    IS
    BEGIN
        pphone := SUBSTR(pphone, 0, 4);
    -- EXCEPTION
    END;
    
    <실행>
    DECLARE
        vphone VARCHAR2(9) := '8765-8652';
    BEGIN
        up_tel4(vphone);
        
        DBMS_OUTPUT.PUT_LINE(vphone);
    END;
