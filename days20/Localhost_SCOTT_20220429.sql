-- [ SCOTT에 접속된 스크립트 파일 ]
1. 트랜잭션(Transaction)
2. 동적쿼리
3. 암호화/복호화
--------------------------------------------------------------------------------
1. 트랜잭션(Transaction)
--------------------------------------------------------------------------------
    1) 트랜잭션(Transaction)이란 일의 처리가 완료되지 않은 중간 과정을 취소하여 일의 시작 전 단계로 되돌리는 기능이다.
    2) 결과가 도출되기까지의 중간 단계에서 문제가 발생하였을 경우 모든 중간 과정을 무효화하여 작업의 처음 시작 전 단계로 되돌리는 것
    3) 일이 모두 완료되면 알리는 COMMIT 과 일의 취소를 알리는 ROLLBACK 이 쓰인다.
    4) DML문을 실행하면 해당 트랜젝션에 의해 발생한 데이터가 다른 사용자에 의해 변경이 발생하지 않도록 LOCK(잠김현상)을 발생한다.
    5) LOCK은 COMMIT 또는 ROLLBACK 문이 실행되면 해제된다.

    예)
         (1) A 통장에서 UPDATE 100만원 차감하는 DML
         (2) B 통장에서 UPDATE 100만원 증가하는 DML
            (1) + (2) 모두 완료되면 COMMIT
                      하나라도 실패하면 모두 원위치 시키는 ROLLBACK
    
         (1) 입고테이블 A상품 15개 입고 -> INSERT 15
         (2) 재고테이블 A상품 100개 + 15개 증가 -> UPDATE 15
              (1) + (2) 모두 완료되면 COMMIT
                        하나라도 실패하면 모두 원위치 시키는 ROLLBACK
    
        > 위와 같은 작업은.. 트랜잭션 처리 필요 + 입고테이블에 INSERT를 할 때 트리거로 재고테이블에 UPDATE하는 트리거 생성 처리                
        
    -- A 사용자가 원격으로 SCOTT 계정 접속
    6) A 트랜잭션 테스트
    
        SELECT *
        FROM emp;
    
    7369	SMITH	CLERK	7902	80/12/17	800		20
    (1) SMITH의 JOB을 CLERK -> MANAGER 수정
        UPDATE emp
        SET job = 'MANAGER'
        WHERE ename ='SMITH';
        --> 1 행 이(가) 업데이트되었습니다.
        -- DML문 실행하면 잠금(LOCK)
        -- COMMIT, ROLLBACK 작업을 안해서 잠금 해제X
    
    COMMIT;
    --> 커밋 완료.   
    
    (2)SMITH의 JOB을 MANAGER -> CLERK 수정
            UPDATE emp
            SET job = 'CLERK'
            WHERE ename ='SMITH';
        --> 1 행 이(가) 업데이트되었습니다.    
        -- DML문 실행하면 잠금(LOCK)
        -- COMMIT, ROLLBACK 작업을 안해서 잠금 해제X
        COMMIT;
        
    결론 : INSERT/ UPDATE / DELETE 수행 후 COMMIT, ROLLBACK
            안하면 LOCK 해제가 안되서 무한루프에 빠진다.
    
    DML문을 사용하면 자동으로 트랜잭션이 걸린다(LOCK)
    DDL / DCL 실행하면 트랜잭션이 종료된다.
    데이터베이스 종료시 트랜잭션 종료
    ------------------------------------        
    7) [ DEAD LOCK(데드락)] 
        익순이 - 책상수리 중 망치 O, 드라이버 X
        익준이 - 부엌수리 중 망치 X, 드라이버 O
        둘이 없는 것을 달라고 싸움
        
        A : 망치 + 못X UPDATE 실행중
        홍길동 : 망치X + 못 UPDATE 실행중    
    
    ------------------------------------  
    
    8) DQL 문에서 사용할 수 있는 절 : FOR UPDATE OF
        - SELECT 문을 통해 해당 레코드에 lock을 거는 문장이다.
         (DQL + 트랜잭션(LOCK)
        - 해제할 때도 COMMIT, ROLLBACK 사용
     
        SELECT *
        FROM emp
        FOR UPDATE OF JOB NOWAIT;

--------------------------------------------------------------------------------
2. TCL문 SAVEPOINT
--------------------------------------------------------------------------------
COMMIT;

SELECT *
FROM dept;

1) 삭제
SAVEPOINT sp_dept_delete;
DELETE FROM dept WHERE deptno = 60; -- LOCK 상태

2) 추가
SAVEPOINT sp_dept_insert;
INSERT INTO dept VALUES(50, 'AA', 'YY'); -- LOCK 상태

3) 수정
SAVEPOINT sp_dept_update;
UPDATE dept
SET loc = 'SEOUL'
WHERE deptno = 40; -- LOCK 상태


(1)
ROLLBACK; -- 모든 작업 취소, LOCK 해제
    
(2) 삭제 작업 빼고 롤백하고싶다
ROLLBACK TO SAVEPOINT sp_dept_insert;

--------------------------------------------------------------------------------
3. [ 동적 SQL ] *****
    JAVA 동적 배열
    int[] m;
    int length = 10;
    m = new int[length];
--------------------------------------------------------------------------------
    1) 동적 SQL ? 컴파일 시에 SQL 문장이 확정이 되지 않는 경우 -> 실행할 때 SQL 문장 확정
    
    SELECT *
    FORM 게시판 테이블
    -- 제목 검색
    IF 제목 검색할 경우 THEN
        WHERE 글제목 LIKE '길동';
    -- 제목 + 내용 검색
    ELSIF 제목+내용으로 검색할 경우 THEN
        WHERE 글제목 LIKE '길동' OR 내용 LIKE '길동';
    END IF;
    
    5만 가지의 경우... 위와 같이 선언할 수 없다.. 이럴 때 동적쿼리 사용!

    2) WHERE 조건절, SELECT 컬럼.. 이런 항목들이 동적으로 변하는 경우 사용한다.
    SELECT ?,?,?,?
    FROM
    WHERE ? AND ? OR ? ? ?......
    
    3) PL/SQL 에서 DDL(CREATE, ALTER, DROP + TRUNCATE) 문을 실행하는 경우
    
    4) PL/SQL 에서 ALTER SESSION / SYSTEM 명령어를 실행하는 경우 -> DBA가 아닌 이상 거의 쓸 일 없음
    
    5) 동적 쿼리를 사용하는 2가지 방법
     **** (1) 원시 동적 쿼리(Native Dynamic SQL : NDS)
     (2) DBMS_SQL 패키지 사용 -> 이건 안알려주심
     
    6) 동적 쿼리를 실행 방법
     (1) EXECUTE IMMEDIATE 동적쿼리문
                            [INTO 문] -> INTO 변수명, 변수명..  
                            [USING MODE(IN, OUT, IN OUT) 문] -> USING 파라미터, 파라미터...

    7) 동적 쿼리 생성(작성) -> 실행 테스트          
    DECLARE
        vdsql VARCHAR2(1000);
        vdeptno emp.deptno%TYPE;
        vempno emp.empno%TYPE;
        vename emp.ename%TYPE;
        vjob emp.job%TYPE;
    BEGIN
        -- ㄱ. 동적 쿼리 작성
        vdsql := 'SELECT deptno, empno, ename, job ';
        vdsql := vdsql || ' FROM emp ';
        vdsql := vdsql || ' WHERE empno = 7369 ';
    
        -- ㄴ. 동적 쿼리 실행
        EXECUTE IMMEDIATE vdsql INTO vdeptno, vempno, vename, vjob;
                            
        DBMS_OUTPUT.PUT_LINE(vdeptno || ', ' || vempno || ', ' || vename || ', ' || vjob);                            
    
    -- EXCEPTION
    END;

-------------------------------------------------------------    
    예2) 저장프로시저를 사용해서 동적쿼리 작성 및 실행
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
        -- ㄱ. 동적 쿼리 작성
          vdsql :=  'SELECT deptno, empno, ename, job ';
          vdsql :=   vdsql || 'FROM emp ';
          vdsql :=  vdsql ||  'WHERE empno = :pempno ' ;
    
        -- ㄴ. 동적 쿼리 실행
        EXECUTE IMMEDIATE vdsql
                    INTO vdeptno, vempno, vename, vjob
                    USING pempno;
                            
        DBMS_OUTPUT.PUT_LINE( vdeptno  || ', ' || vempno || ', ' || vename || ', ' || vjob );                            
    
    -- EXCEPTION
    END;  
    
    EXEC up_dselEmp(7369);
    
-------------------------------------------------------------        
    예3) 저장프로시저를 사용해서 동적쿼리 작성 및 실행 (INSERT)
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
        -- ㄱ. 동적 쿼리 작성
        vdsql :=  'INSERT INTO dept ';
        vdsql :=   vdsql || ' VALUES ( :deptno, :dname, :loc ) '; 
    
        -- ㄴ. 동적 쿼리 실행
        EXECUTE IMMEDIATE vdsql                    
                USING vdeptno, pdname, ploc;
                
        -- COMMIT;                           
    
    -- EXCEPTION
    END;    
    
SELECT * FROM dept;

EXEC UP_DINSDEPT( 'QC', 'SEOUL');

ROLLBACK;

    
-------------------------------------------------------------    
    예4)
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
    
        DBMS_OUTPUT.PUT_LINE(vsql); -- 테스트로 출력시켜보는 것
        
        EXECUTE IMMEDIATE vsql;
                            -- USING vtableName;
    END;
    
    <확인>
    DESC tbl_nds;

-------------------------------------------------------------        
    예5) OPEN FOR 문 설명? 동적 SQL의 실행 결과가 [여러 개의 레코드(행) 반환]하는 [SELECT문] + [커서]

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
    
    -- EXECUTE IMMEDIATE 동적쿼리 사용X
    -- OPEN FOR 문 사용한다.
    OPEN vcursor FOR vsql USING pdeptno;
    LOOP
        FETCH vcursor INTO vrow;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vrow.empno || ', ' || vrow.ename);
    END LOOP;
    CLOSE vcursor;
END;
--> Procedure UP_NDS02이(가) 컴파일되었습니다.

EXEC UP_NDS02(30);