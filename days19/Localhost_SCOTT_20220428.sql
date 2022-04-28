-- [ SCOTT에 접속된 스크립트 파일 ]
1. PL/SQL의 패키지(PACKAGE)  
 1) 관계되는 타입, 프로그램 객체, 서브프로그램(procedure, function)을 논리적으로 묶어 놓은 것은 의미
 2) 패키지는 specification과 body 부분으로 되어 있으며, 오라클에서 기본적으로 제공하는 패키지가 있다.
 3) SPECIFICATION 부분은 type, constant, variable, exception, cursor, sub program(저장프로시저, 저장 함수)이 선언된다. 
 4) BODY 부분은 cursor, subprogram 따위가 존재한다.
 5) 호출할 때 '패키지_이름.프로시저_이름' 형식의 참조를 이용해야 한다.  
-----

ㄱ. SPECIFICATION 부분

CREATE OR REPLACE PACKAGE logon_pkg
AS
    PROCEDURE up_idCheck
    (
        pempno IN emp.empno%TYPE -- ID를 받을 파라미터
        , pempnoCheck OUT NUMBER -- 사용가능여부(0, 1)를 돌려주는 파라미터
    );
    
    PROCEDURE up_logon
    (
        pempno IN emp.empno%TYPE -- ID를 받을 파라미터(ID 대신 사용)
        , pename IN emp.ename%TYPE -- PW 받을 파라미터
        , plogonCheck OUT NUMBER -- 로그인 성공 0, ID가 존재X 1, PW가 일치하지않으면 -1
    );
    
    FUNCTION uf_age
    (
        prrn VARCHAR2
    )
    RETURN NUMBER;
    
END logon_pkg; 
--> Package LOGON_PKG이(가) 컴파일되었습니다.

ㄴ. BODY 부분
CREATE OR REPLACE PACKAGE BODY logon_pkg
AS
    PROCEDURE up_idCheck
    (
        pempno IN emp.empno%TYPE -- ID를 받을 파라미터
        , pempnoCheck OUT NUMBER -- 사용가능여부(0, 1)를 돌려주는 파라미터
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
                    WHEN -1 THEN  -- 생일 안지난것
                     vt_year - vb_year - 1
                    ELSE   -- 0, 1
                     vt_year - vb_year
                END;         
    
        RETURN vage;
    END uf_age;
    
END logon_pkg;
--> Package Body LOGON_PKG이(가) 컴파일되었습니다.



<실행 테스트>
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
2. 커서(CURSOR) + 파라미터를 이용하는 방법
----------------------------------------------------------------
    CREATE OR REPLACE PROCEDURE up_selDeptEmp
    (
        pdeptno emp.deptno%TYPE
    )
    IS
        vename emp.ename%TYPE;
        vsal emp.sal%TYPE;
        
        -- (2) 커서가 받을 변수 생성하고
        CURSOR cemplist ( cdeptno dept.deptno%TYPE ) 
        IS ( SELECT ename, sal
             FROM emp
             WHERE deptno = cdeptno
            );
    BEGIN
        
        OPEN cemplist(pdeptno); -- (1) 파라미터로 받은 값을 커서에게 주입시켜주고
        
        LOOP
            FETCH cemplist INTO vename, vsal; -- 커서에서 가져와 변수에 담는다.
            EXIT WHEN cemplist%NOTFOUND; -- 커서가 더이상 가져올 것이 없을 때 나가는 조건문
            DBMS_OUTPUT.PUT_LINE(vename || ', ' || vsal);
        END LOOP;
        
        CLOSE cemplist;
    -- EXCEPTION
    END;
    
    EXEC UP_SELDEPTEMP(30);

---------------------------------------
3. ***** SYS_REFCURSOR 타입( 오라클 9i 이전까지 없었고 REF CURSORS 라는 타입이 있었음)
SYS_
    REF 참조
        CURSOR 커서
--------------------------------------
    - 커서를 매개변수로 받아서 출력하는 저장 프로시저
    CREATE OR REPLACE PROCEDURE up_selInsa
    (
        pcursor SYS_REFCURSOR -- 커서를 매개변수로 받는다는 의미! 커서 파라미터
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
    
    -->Procedure UP_SELINSA이(가) 컴파일되었습니다.
    - 위의 프로시저를 테스트하는 프로시저 생성
    CREATE OR REPLACE PROCEDURE up_test_selInsa
    IS
        vcursor SYS_REFCURSOR; -- 커서 변수 선언
    BEGIN
        OPEN vcursor FOR SELECT name, city, basicpay FROM insa;
        UP_SELINSA(vcursor); -- UP_SELINSA 저장프로시저를 호출하려면 커서 파라미터(변수)가 필요함
        -- 위의 작업이 LOOP 작업을 대신하는 것
        CLOSE vcursor;
    --EXCEPTION
    END;
    --> Procedure UP_TEST_SELINSA이(가) 컴파일되었습니다.
    
    EXEC up_test_selInsa;
    
    --------------------------------------
    CREATE OR REPLACE PROCEDURE up_selInsa
    (
        pcursor OUT SYS_REFCURSOR -- 출력용 매개변수 커서 사용
    )
    IS
    BEGIN
        OPEN pcursor FOR SELECT name, city, basicpay FROM insa;
    END;
    
    -- JDBC = JAVA + Oracle 연동하여 사용하는 곳

----------------------------------------------------------------------------
4. PL/SQL 블럭 내에서 에러를 처리하는 블럭 : EXCEPTION 블럭(절)
항목                  에러 코드   설명 
NO_DATA_FOUND       ORA-01403  SQL문에 의한 검색조건을 만족하는 결과가 전혀 없는 조건의 경우 
NOT_LOGGED_ON       ORA-01012  데이터베이스에 연결되지 않은 상태에서 SQL문 실행하려는 경우 
TOO_MANY_ROWS       ORA-01422  SQL문의 실행결과가 여러 개의 행을 반환하는 경우, 스칼라 변수에 저장하려고 할 때 발생 
VALUE_ERROR         ORA-06502  PL/SQL 블럭 내에 정의된 변수의 길이보다 큰 값을 저장하는 경우 
ZERO_DEVIDE         ORA-01476  SQL문의 실행에서 컬럼의 값을 0으로 나누는 경우에 발생 
INVALID_CURSOR      ORA-01001  잘못 선언된 커서에 대해 연산이 발생하는 경우 
DUP_VAL_ON_INDEX    ORA-00001  이미 입력되어 있는 컬럼 값을 다시 입력하려는 경우에 발생 


    예)
    CREATE OR REPLACE PROCEDURE up_exception01
    (
        psal emp.sal%TYPE -- 파라미터
    )
    IS
        vename emp.ename%TYPE; -- 이름을 담을 변수
    BEGIN
        SELECT ename INTO vename -- 사원을 검색해서 변수에 담아라
        FROM emp
        WHERE sal = psal; -- 파라미터로 받은 금액과 같은
        
        DBMS_OUTPUT.PUT_LINE(psal || ' => ' || vename);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN -- Oracle에서 미리 정의된 예외
            RAISE_APPLICATION_ERROR(-20002, '>QUERY DATA NOT FOUND<');
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20003, '>QUERY TOO MANY ROWS FOUND<');
        WHEN OTHERS THEN -- 위에서 처리하는 예외가 아닌 다른 모든 예외들 처리
            RAISE_APPLICATION_ERROR(-20004, '>QUERY OTHERS EXCEPTION FOUND<');
    END;
    --> Procedure UP_EXCEPTION01이(가) 컴파일되었습니다.
    
    <실행 및 확인>
    EXEC UP_EXCEPTION01(1250);
    EXEC UP_EXCEPTION01(6000);
    EXEC UP_EXCEPTION01(800);

------------------------------------------------------------------------------
- 미리 정의되지 않은 예외를 처리하는 방법(미리 정의된 7가지 예외에 없는 예외 처리)
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
        -- 내가 만든 예외객체는 02291 코드 번호 에러가 발생하게 되면 처리하겠다라는 문법
        ve_invalid_deptno EXCEPTION; -- 잘못된 부서번호를 줬다는 예외(내가 만든 사용자 정의 예외)
        -- 예외 객체 지정(매핑)할 때 PRAGMA EXCEPTION 절 사용한다.
        PRAGMA EXCEPTION_INIT(ve_invalid_deptno, -02291); -- 코드번호 앞에는 -를 꼭 붙인다.
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
    --> Procedure UP_INSEMP이(가) 컴파일되었습니다.

<실행 및 확인>
    EXEC up_insEmp(9999, 'admin', 'CLERK', 9000, SYSDATE, 950, null, 90 );
    -- 우리가 선언한 예외 코드가 발생되는 것을 확인할 수 있음
    오류 보고 -
    ORA-20999: >QUERY DEPTNO FK NOT FOUND<
    ORA-06512: at "SCOTT.UP_INSEMP", line 23
    ORA-06512: at line 1
    
----------------
[사용자가 정의하는 예외 처리 방법]

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
    WHERE sal BETWEEN (psal-100) AND (psal+100); -- 입력받은 파라미터보다 +-100 범위에 있는..
    
    IF vempcount = 0 THEN
        -- 0일 때 강제 예외 발생
        -- RAISE 사용자예외객체;
        RAISE ve_no_emp_returned;
    ELSE
        DBMS_OUTPUT.PUT_LINE('>처리 결과 : ' || vempcount);
    END IF;
EXCEPTION
    WHEN ve_no_emp_returned THEN
        RAISE_APPLICATION_ERROR(-20011, '>QUERY EMP COUNT = 0 ...<');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, '>QUERY OTHERS EXCEPTION FOUND<');
END;
--> Procedure UP_EXCEPTION02이(가) 컴파일되었습니다.

EXEC UP_EXCEPTION02(500);





