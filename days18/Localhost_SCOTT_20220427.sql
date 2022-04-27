-- [ SCOTT에 접속된 스크립트 파일 ]
1. 트리거(Trigger)
    1) 어떤 작업 전(before) 또는 작업 후(after) 트리거에 정의한 로직을 실행하는 PL/SQL의 한 종류
    2) 대상(테이블)에 미리 트리거를 지정하면 어떤 이벤트(DML)가 발생할 때 자동으로 지정된 트리거가 작동(할당) 하도록한 객체
    3) 예.
        입고테이블(대상)
        입고번호    입고제품명   입고날짜      입고수량
        101        LG냉장고    2022.04.27  10
        > 입고테이블에는 INSERT 실행
        
        재고테이블
        LG냉장고 120개
        > 재고테이블에는 UPDATE 실행(120 + 10)
    
        > 입고테이블에 이벤트(DML)가 발생되면 재고테이블은 자동으로 재고수량을 수정하는 트리거
    
    4) 트리거 키워드(예약어)
        ㄱ. 작업 전에 자동 처리되는 트리거 : BEFORE TRIGGER
        ㄴ. 작업 후에 자동 처리되는 트리거 : AFTER TRIGGER
        ㄷ. FOR EACH ROW : 행 마다 처리되는 트리거(ROW TRIGGER)
        ㄹ. REFERENCING : 영향받는 행의 값 참조
        ㅁ. :OLD -> 참조되기 전에 열(컬럼)의 값
        ㅂ. :NEW -> 참조한 후에 열(컬럼)의 값
        
    5) 트리거 형식
    【형식】 
        CREATE [OR REPLACE] TRIGGER 트리거명 [BEFORE ? AFTER] -- BEFORE/AFTER 기본값은 AFTER
          trigger_event ON 테이블명
          [FOR EACH ROW [WHEN TRIGGER 조건]]
        DECLARE
          선언문
        BEGIN
          PL/SQL 코드
        EXCEPTION
          예외 처리 부분
        END;
        
        - 저장프로시저는 COMMIT을 해야되지만, 트리거는 자동으로 COMMIT/ROLLBACK 된다.
        
    6) 트리거 확인
        SELECT *
        FROM user_triggers;
        
    7) 트리거 테스트
     <테이블 2개 생성>
        CREATE TABLE tbl_trigger1(
            id NUMBER PRIMARY KEY
            , name VARCHAR2(20)
        );
        
        CREATE TABLE tbl_trigger2(
           memo VARCHAR2(100) -- 로그 내용
            , ilja DATE DEFAULT SYSDATE -- 이벤트(DML)가 발생한 시간
        );
    
    이벤트 : tbl_trigger1 테이블에 한 개의 레코드(행)을 INSERT
    대상(tbl_trigger1)에 이벤트(DML)가 발생하면 tbl_trigger2 테이블에
    자동으로 로그를 기록하는 트리거 생성
    
    <트리거 선언> ut = user trigger
      <INSERT 트리거>
        CREATE OR REPLACE TRIGGER ut_exam01 AFTER -- 이벤트 작업이 완료된 후에 작동하는 트리거
        INSERT ON tbl_trigger1 -- 대상 테이블에 INSERT라는 이벤트가 발생할 때
        -- FOR EACH ROW 행트리거
        -- DECLARE -- 변수선언할필요없어서 주석처리
        BEGIN
            INSERT INTO tbl_trigger2 (memo) VALUES ('TBL_TRIGGER1 테이블에 새로운 데이터 추가됨');
        -- EXCEPTION
        END;
        
      <UPDATE 트리거>
        CREATE OR REPLACE TRIGGER ut_exam01 AFTER -- 이벤트 작업이 완료된 후에 작동하는 트리거
        UPDATE ON tbl_trigger1 -- 대상 테이블에 INSERT라는 이벤트가 발생할 때
        -- FOR EACH ROW 행트리거
        -- DECLARE -- 변수선언할필요없어서 주석처리
        BEGIN
            INSERT INTO tbl_trigger2 (memo) VALUES ('TBL_TRIGGER1 테이블에 새로운 데이터 추가됨');
        -- EXCEPTION
        END;
        
      <DELETE 트리거>
        CREATE OR REPLACE TRIGGER ut_exam01 AFTER -- 이벤트 작업이 완료된 후에 작동하는 트리거
        DELETE ON tbl_trigger1 -- 대상 테이블에 INSERT라는 이벤트가 발생할 때
        -- FOR EACH ROW 행트리거
        -- DECLARE -- 변수선언할필요없어서 주석처리
        BEGIN
            INSERT INTO tbl_trigger2 (memo) VALUES ('TBL_TRIGGER1 테이블에 새로운 데이터 추가됨');
        -- EXCEPTION
        END; 
        
    ** 위와 같이 3개의 트리거를 선언해도 되지만 아래와 같이 OR 연산자로 연결하여 선언할 수 있음!!!
        CREATE OR REPLACE TRIGGER ut_exam01 AFTER -- 이벤트 작업이 완료된 후에 작동하는 트리거
        INSERT OR UPDATE OR DELETE ON tbl_trigger1 -- 대상 테이블에 INSERT라는 이벤트가 발생할 때
        -- FOR EACH ROW 행트리거
        -- DECLARE -- 변수선언할필요없어서 주석처리
        BEGIN
            IF INSERTING THEN
                INSERT INTO tbl_trigger2 (memo) VALUES ('TBL_TRIGGER1 테이블에 새로운 데이터 추가됨');
            ELSIF UPDATING THEN
                INSERT INTO tbl_trigger2 (memo) VALUES ('TBL_TRIGGER1 테이블에 데이터 수정됨');
            ELSIF DELETING THEN
                INSERT INTO tbl_trigger2 (memo) VALUES ('TBL_TRIGGER1 테이블에 데이터 삭제됨');
            END IF;
        -- EXCEPTION
        END;        
    
    
    <테이블 안에 데이터 확인>
        SELECT * FROM tbl_trigger1;
        SELECT * FROM tbl_trigger2;
    
    
    <이벤트 실행 및 확인>
        INSERT INTO tbl_trigger1 VALUES (1, 'admin');
        INSERT INTO tbl_trigger1 VALUES (1, 'hong');
         -- ORA-00001: unique constraint (SCOTT.SYS_C007485) violated
         -- 개체 무결성 위반하면 AFTER 트리거는 작동하지 않는다.
        
        INSERT INTO tbl_trigger1 VALUES (2, 'hong');
    
        ROLLBACK; -- 롤백을 하면 자동으로 트리거 작업도 롤백되어진다.

    > 트리거를 추가, 수정, 삭제하는 로그를 기록하는 것으로 수정했음
        - DML(UPDATE) 자동으로 트리거 발생 -> 로그 기록
        UPDATE tbl_trigger1
        SET name = 'kim'
        WHERE id = 2;
    
        - DML(DELETE) 자동으로 트리거 발생 -> 로그 기록
        DELETE FROM tbl_trigger1
        WHERE id = 2;   
        
        COMMIT;

--------------------------------------------------------------------
예시1) tbl_trigger1 테이블에 근무시간X, 주말(토,일)에는 INSERT, UPDATE, DELETE 하면 에러 발생
    <트리거 선언>
    CREATE OR REPLACE TRIGGER ut_exam02 BEFORE -- 이벤트 작업이 실행되기 전에 작동하는 트리거
    INSERT OR UPDATE OR DELETE ON tbl_trigger1 -- 대상 테이블에 INSERT라는 이벤트가 발생하기 전에
    -- FOR EACH ROW 행트리거
    -- DECLARE -- 변수선언할필요없어서 주석처리
    BEGIN
        -- 가정 : 근무시간은 12~18시
        IF TO_CHAR(SYSDATE, 'DY') IN ('토', '일')
           OR
           NOT(TO_CHAR(SYSDATE, 'HH24') BETWEEN 12 AND 18) THEN
            -- 에러 강제로 발생시키면 DML문도 취소가 되어짐
            RAISE_APPLICATION_ERROR(-20000, '지금은 근무시간 외 또는 주말이기에 작업 안됩니다.'); -- 에러코드번호, 메시지
        END IF;
    -- EXCEPTION
    END;

--> Trigger UT_EXAM02이(가) 컴파일되었습니다.

    <실행> 새로운 데이터가 삽입되기 전에 트리거가 발생이 되어서 근무/주말 체크 후에 삽입 결정
    INSERT INTO tbl_trigger1 VALUES (2, 'hong');

INSERT INTO tbl_trigger1 VALUES (2, 'hong')
오류 보고 -
ORA-20000: 지금은 근무시간 외 또는 주말이기에 작업 안됩니다.
ORA-06512: at "SCOTT.UT_EXAM02", line 7
ORA-04088: error during execution of trigger 'SCOTT.UT_EXAM02'

--------------------------------------------------------------------
예시2) 한 학생의 학번, 이름, 국어, 영어, 수학 -> tbl_trg1 에 INSERT
      자동으로 tbl_trg2 테이블에 tot, avg INSERT 되는 트리거 생성 -> 테스트
      
    <2개의 테이블 생성>
    create table tbl_trg1
    (
        hak varchar2(10) primary key
      , name varchar2(20)
      , kor number(3)
      , eng number(3)
      , mat number(3)
    );
    -- Table TBL_TRG1이(가) 생성되었습니다.
    
    create table tbl_trg2
    (
      hak varchar2(10) primary key
      , tot number(3)
      , avg number(5,2)
      , constraint fk_test2_hak foreign key(hak)   references tbl_trg1(hak)
    );
    -- Table TBL_TRG2이(가) 생성되었습니다.


    <트리거 선언>
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
    -- 원인 : 테이블 레벨 트리거에서 :NEW, :OLD 키워드 참조를 허용하지 않는다.
    -- 해결 : FOR EACH ROW를 넣으면 해결 -> 행 레벨 트리거로 선언
    
    --> Trigger UT_TRG1DML이(가) 컴파일되었습니다.
    
    <실행>
    INSERT INTO tbl_trg1 ( hak, name, kor, eng, mat ) VALUES ( 1, 'hong', 90,78, 99 );

    <확인>
    SELECT * FROM tbl_trg1;
    SELECT * FROM tbl_trg2;
    
    COMMIT;
    
--------------------------------------------------------------------
예시3) 학생의 성적을 수정(UPDATE) -> 자동으로 tbl_trg2 테이블의 총점, 평균 수정
    -- 1	hong	90	78	99  :OLD
    -- 1	hong	87	67	100 :NEW
    <트리거 선언>
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

    --> Trigger UT_TRG1DML이(가) 컴파일되었습니다.    

    <실행>
    UPDATE tbl_trg1
    SET kor = 87, eng = 67, mat = 100
    WHERE hak = 1;
    
    <확인>
    SELECT * FROM tbl_trg1;
    SELECT * FROM tbl_trg2;
    
    COMMIT;
    
-----------------------------------------------------
문제) tbl_trg1 테이블에 학번 1인 학생을 삭제하면 자동으로 tbl_trg2 테이블의 학번 1 학생도 삭제하는
    트리거를 만들어서 테스트하세요.

    <트리거 선언>
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
            WHERE hak = :OLD.hak; -- 새로운 데이터가 아니라 기존 데이터 이니까 :OLD
        END IF;  
    -- EXCEPTION
    END;
    
    <실행>
    DELETE tbl_trg1
    WHERE hak = 1;
    
    <확인>
    SELECT * FROM tbl_trg1;
    SELECT * FROM tbl_trg2;
    
    ROLLBACK;    
    