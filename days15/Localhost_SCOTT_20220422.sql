-- [ SCOTT에 접속된 스크립트 파일 ]        
--------------------------------------------------------------------------------
[수업내용시작]

SELECT *
FROM tabs
WHERE table_name LIKE 'T\_%' ESCAPE '\';

SELECT *
FROM T_SAMPLE;

----------------------------------------------------------------------------
T_MEMBER -- 회원
T_POLL -- 설문
T_POLLSUB -- 설문항목들
T_VOTER -- 투표

회원
1) 회원가입 / 탈퇴 / 수정
'회원 시퀀스 생성'
CREATE SEQUENCE seq_member
INCREMENT BY 1
START WITH 1
MAXVALUE 9999
NOCACHE;

'데이터 추가'
INSERT INTO T_MEMBER ( MemberSeq, MemberID, MemberPasswd, MemberName,MemberPhone, MemberAddress  )
VALUES (seq_member.nextval, 'admin', '1234', '관리자', '010-1111-1111', '서울 강남구');
INSERT INTO T_MEMBER ( MemberSeq, MemberID, MemberPasswd, MemberName,MemberPhone, MemberAddress  )
VALUES (seq_member.nextval, 'hong', '1234', '홍길동', '010-1111-1111', '서울 도봉구');
INSERT INTO T_MEMBER ( MemberSeq, MemberID, MemberPasswd, MemberName,MemberPhone, MemberAddress  )
VALUES (seq_member.nextval, 'kim', '1234', '익순이', '010-1111-1111', '서울 마포구');
COMMIT;

'확인'
SELECT *
FROM t_member;


2) 설문 등록(작성) / 수정 / 삭제
'설문 시퀀스 생성'
CREATE SEQUENCE seq_poll;

'데이터 추가'
INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
VALUES (seq_poll.nextval, '좋아하는 여배우?'
            , TO_DATE('2022-03-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , TO_DATE('2022-03-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , 5
            , 0
            , TO_DATE('2022-02-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , 1
        );

INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
VALUES (seq_poll.nextval, '좋아하는 과목?'
            , TO_DATE('2022-04-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , TO_DATE('2022-05-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , 4
            , 0
            , TO_DATE('2022-04-15 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , 1
        );

INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
VALUES (seq_poll.nextval, '5월 5일 휴강 찬반'
            , TO_DATE('2022-05-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , TO_DATE('2022-05-04 18:00:00', 'YYYY-MM-DD HH24:MI:SS' )
            , 2
            , 0
            , SYSDATE
            , 1
        );        

COMMIT;

'확인'
SELECT *
FROM t_poll;

2-1) 세부 항목 추가하는 쿼리 작성
'순번 시퀀스 생성'
CREATE SEQUENCE seq_pollsub;

'데이터 추가'
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '배슬기', 0, 1);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '김옥빈', 0, 1);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '아이유', 0, 1);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '김선아', 0, 1);

INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '수학', 0, 2);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '국어', 0, 2);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '영어', 0, 2);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '사회', 0, 2);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '과학', 0, 2);

INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '찬성', 0, 3);
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )
VALUES (seq_pollsub.nextval, '반대', 0, 3);

COMMIT;

'확인'
SELECT *
FROM t_pollsub;

3) 설문 목록 페이지와 연동되는 쿼리
질문번호, 질문내용, 작성자, 시작일, 종료일, 항목수, 참여자수, 상태 

SELECT pollseq, question, membername, sdate, edate, itemcount, polltotal
        , CASE
            WHEN SYSDATE > edate THEN '종료'
            WHEN SYSDATE BETWEEN sdate AND edate THEN '진행중'
            ELSE '시작전'
          END state
FROM t_poll p JOIN t_member m ON p.memberseq = m.memberseq;

SELECT *
FROM t_member;

4) 설문 투표 -> 1)+2)+3) 3가지 작업 -> PL/SQL 만들면 된다.
'투표번호 시퀀스 생성'
CREATE SEQUENCE seq_vector;

-- 작업1)
INSERT INTO t_voter (VectorSeq , UserName,RegDate, PollSeq,PollSubSeq, MemberSeq) 
VALUES (seq_vector.nextval, '홍길동', SYSDATE, 1, 3 ,2);

-- 작업2)
UPDATE t_poll
SET polltotal = polltotal + 1
WHERE pollseq = 1;

-- 작업3)
UPDATE t_pollsub
SET acount = acount + 1
WHERE pollsubseq = 3;

-- 작업1)
INSERT INTO t_voter (VectorSeq , UserName,RegDate, PollSeq,PollSubSeq, MemberSeq) 
VALUES (seq_vector.nextval, '익순이', SYSDATE, 1, 3 ,2);

-- 작업2)
UPDATE t_poll
SET polltotal = polltotal + 1
WHERE pollseq = 1;

-- 작업3)
UPDATE t_pollsub
SET acount = acount + 1
WHERE pollsubseq = 3;


-- 작업1)
INSERT INTO t_voter (VectorSeq , UserName,RegDate, PollSeq,PollSubSeq, MemberSeq) 
VALUES (seq_vector.nextval, '관리자', SYSDATE, 1, 2 ,2);

-- 작업2)
UPDATE t_poll
SET polltotal = polltotal + 1
WHERE pollseq = 1;

-- 작업3)
UPDATE t_pollsub
SET acount = acount + 1
WHERE pollsubseq = 2;

COMMIT;

SELECT * FROM t_voter;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;

5) 1번 설문에 대한 투표 결과 보기
(1) 총 참여자수
SELECT polltotal
FROM t_poll
WHERE pollseq = 1;

-- 아래 쿼리로 하면 성능이 떨어지기 때문에 위와 같이 컬럼을 추가해서 확인할 수 있도록 하였다.
SELECT COUNT(*)
FROM t_voter
WHERE pollseq = 1;


(2) 투표 결과 보기
SELECT question, answer
        , RPAD(' ', v+1, '#') || acount || '(' || v || '%)'
FROM(   
    SELECT question, answer, acount, polltotal
            , ROUND(acount / polltotal * 100) v
    FROM t_pollsub s JOIN t_poll p ON s.pollseq = p.pollseq
    WHERE p.pollseq = 1
) t;



------------------------------------------------------------------------------------------------
1. PL/SQL
    1) SQL 확장 + PL == [P]rocedural [L]anguage extensions to SQL을 의미
    
    2) 이는 비절차적인 SQL 언어를 절차적으로 사용할 수 있도록 한다. 
                                ㄱ. 변수 선언
                                ㄴ. 제어문
                                ㄷ. 예외 처리 등등
                                
    3) PL/SQL은 블록 구조로 된 언어이며, 3가지의 블럭으로 구조되어있다.
        [ 선언 기능 블럭 ]
        [ 실행 기능 블럭 ]
        [ 예외 처리 블럭 ]
    
    4) PL/SQL 선언 형식 ***
      【형식】
       [ DECLARE ]   -- 선언블럭(declarations) : 변수 선언, 상수 선언
       BEGIN         -- 실행블럭(statements) : INSERT, DELETE, UPDATE 등
       [ EXCEPTION ] -- 예외 처리 블럭(handlers) 
       END; 
       
      [ DECLARE       -- 선언블럭(declarations) : 변수 선언, 상수 선언
            변수명 자료형(크기)
            변수명 자료형(크기)
                 :           ]   
       BEGIN         -- 실행블럭(statements) : INSERT, DELETE, UPDATE 등
       [ EXCEPTION ] -- 예외 처리 블럭(handlers) 
       END;
       
    5) PL/SQL의 블록 작성요령 
    > 블럭 내에 SQL 문을 여러번 사용할 수 있음 *
       DECLARE
            INSERT
            SELECT
            SELECT
            UPDATE
              :
       BEGIN
       EXCEPTION
       END;
       
    > 블럭 내에는 CREATEST, LEAST, DECODE, 그룹함수를 사용할 수 없음 *
    --  식별자는 최대 30문자로 작성 
    --  식별자는 테이블 또는 컬럼명과 같을 수 없음 
    --  식별자는 알파벳으로 시작해야 함 
    --  문자와 날짜 타입은 단일 인용부호로 표시함 
    --  주석은 단일 라인인 경우 2개의 대시(--), 여러 라인 경우 /* ... */로 표기

    6) PL/SQL의 6가지 종류
        (1) 익명 프로시저(anonymous procedure)  anonymous PL/SQL은 DECLARE ...로 시작되며, 사용자가 반복적으로 실행하려는 SQL문을 필요할 때마다 작성하여 실행하는 방법, 데이터베이스에 그 정보가 저장되지 않음  
        (2) 저장 프로시저(stored procedure)     CREATE PROCEDURE name ...문에 의해서 생성된 후, 데이터베이스 내에 그 정보가 저장됨. stored procedure는 로직을 처리만 하고 끝남  
        (3) 저장 함수(stored function)         stored procedure와 같으며, stored procedure는 로직을 처리만 하고 끝나지만, stored function은 그 처리 결과를 사용자에게 반환함.  
        (4) 패키지(package)                    자주 사용되는 여러 procedure, function들을 하나의 package묶어서 관리에 편리토록 함  -> ex) dbms_random 패키지
        (5) 트리거(trigger)                    어떤 작업전, 또는 작업 후 trigger에 정의한 로직을 실행시키는 PL/SQL 블럭임. 
        (6) 객체 타입(object type)             객체에 데이터를 입력, 수정, 삭제, 조회하기 위해서는 반드시 PL/SQL 언어를 사용해야 함  

    7) 익명 프로시저 ( anonymous procedure )
    -- 실행할 때 반드시 선택을 한 후 실행***
       [ DECLARE       -- 선언블럭(declarations) : 변수 선언, 상수 선언
            변수명 자료형(크기)
            변수명 자료형(크기)
                 :           ]   
       BEGIN         -- 실행블럭(statements) : INSERT, DELETE, UPDATE 등
       [ EXCEPTION ] -- 예외 처리 블럭(handlers) 
       END;
        
       DECLARE
        vname VARCHAR2(10);
        vsal NUMBER(7, 2);
       BEGIN
        SELECT ename, sal
                INTO vname, vsal -- SELECT한 결과를 DECLATE에 선언된 변수에 담겠다.
        FROM emp
        WHERE empno = 7369;

        DBMS_OUTPUT.PUT_LINE(vname);
        DBMS_OUTPUT.PUT_LINE(vsal);
       -- EXCEPTION
       -- WHEN THEN
       END;

-- EXCEPTION에 WHEN THEN이 없어서 오류 발생       
--        오류 보고 -
--        ORA-06550: line 13, column 8:
--        PLS-00103: Encountered the symbol "END" when expecting one of the following:
--        
--           pragma when
--        06550. 00000 -  "line %s, column %s:\n%s"
--        *Cause:    Usually a PL/SQL compilation error.
--        *Action:

    --> PL/SQL 프로시저가 성공적으로 완료되었습니다.
    
    + dbms_output 패키지
      > 이 패키지는 PL/SQL 내에서 처리된 어떤 결과를 사용자의 화면에 출력할 때 사용한다.
      > DBMS_OUTPUT 패키지의 서브프로그램(함수)은 다음과 같다.
            put() 또는 put_line() : 정의된 문자값을 화면에 출력하는 프로세서 
            NEW_LINE()           : GET_LINE에 의해 읽힌 행의 다음 라인을 읽을 때 사용 
            GET_LINE() 또는 GET_LINES() : 현재 라인의 문자값을 읽는 프로세서 
            ENABLE()    : 화면에 문자값을 출력하는 모드로 설정하며 문자값을 지정할 수 있는 버퍼크기를 정의함 
            DISABLE()   : 화면에 문자값을 출력하는 모드로 해제함 
    -- 보기 -> DBMS 출력하면 보여짐
    
    예시1) 홍길동의 이름과 나이를 변수에 저장해서 DBMS로 출력하기
    DECLARE
        vname VARCHAR2(20);
        vage NUMBER(3);
    BEGIN
        vname := '홍길동';
        vage := 20;
        
        DBMS_OUTPUT.PUT_LINE(vname || ', ' || vage);
    -- EXCEPTION
    END;
    
    --오류 보고 -
    --ORA-06550: line 5, column 15:
    --PLS-00103: Encountered the symbol "=" when expecting one of the following:
    --
    --   := . ( @ % ;
    --06550. 00000 -  "line %s, column %s:\n%s"
    --*Cause:    Usually a PL/SQL compilation error.
    --*Action:    
    
    -- 원인 : vname = '홍길동';    -> = 이렇게 하면 안되고 := 이걸로 해야됨
    
    예시2) 30번 부서의 지역명(loc)를 가져와서 10번 부서의 loc로 수정
   
    SELECT loc
    FROM dept
    WHERE deptno = 30;
    
    UPDATE dept
    SET loc = 'CHICAGO'
    WHERE deptno = 10;
    
    DESC dept;
    
    -- 익명 프로시저 생성 + 실행
    DECLARE
        -- vloc VARCHAR2(13);
        vloc dept.loc%TYPE;  -- 타입형 변수(dept의 loc와 자료형을 똑같이 주겠다.)
    BEGIN
        SELECT loc INTO vloc
        FROM dept
        WHERE deptno = 30;
        
        UPDATE dept
        SET loc = vloc
        WHERE deptno = 10;
        
        --COMMIT;
    -- EXCEPTION
        -- ROLLBACK;
    END;
    --> PL/SQL 프로시저가 성공적으로 완료되었습니다.   
    
    SELECT *
    FROM dept;

    ROLLBACK;   
    
--------------------------------
[여기서부터 새로운 개념~]

익명 프로시저 복습하기..

(1) 이름 출력하기
--DECLARE
BEGIN
    dbms_output.put_line('홍길동');
--EXCEPTION
END;

(2)
DECLARE
    vname VARCHAR2(20);
    vage NUMBER(3) := 20; -- 여기서 선언하면 기본값
BEGIN
    vname := '익순이';
    vage := 28; -- 선언을 해주면 기본값이 아닌 이 값으로 출력
    DBMS_OUTPUT.PUT_LINE(vname || ', ' || vage);
--EXCEPTION
END;

        
문제1) emp 테이블에서 10번 부서원 중에 급여를 가장 많이 받는 사원의 정보를 출력하는 익명프로시저 작성
        정보) empno, deptno, ename, job, mgr, hiredate, pay(sal + comm)
        
DECLARE
    tempno emp.empno%TYPE;
    tdeptno emp.deptno%TYPE;
    tename emp.ename%TYPE;
    tjob emp.job%TYPE;
    tmgr emp.mgr%TYPE;
    thiredate emp.hiredate%TYPE;
    tpay emp.sal%TYPE;    
BEGIN    
    SELECT empno, deptno, ename, job, mgr, hiredate, sal + NVL(comm, 0) pay
         INTO tempno, tdeptno, tename, tjob, tmgr, thiredate, tpay
    FROM emp
    WHERE deptno = 10 AND sal + NVL(comm, 0) = (SELECT MAX(sal+NVL(comm,0)) max_pay FROM emp WHERE deptno = 10);

    DBMS_OUTPUT.PUT_LINE(tempno || ', '|| tdeptno || ', '|| tename || ', '|| tjob || ', '|| tmgr || ', '|| thiredate || ', '|| tpay);
--EXCEPTION
END;

--------------------
1. %TYPE형 변수 : 변수명 table명.column명%TYPE;

DECLARE
    tempno emp.empno%TYPE;
    tdeptno emp.deptno%TYPE;
    tename emp.ename%TYPE;
    tjob emp.job%TYPE;
    tmgr emp.mgr%TYPE;
    thiredate emp.hiredate%TYPE;
    tpay emp.sal%TYPE;  
    
    vmax_pay NUMBER;
BEGIN 
    -- 1번 수행 *** 서브쿼리를 따로 빼와서 변수에 저장
    SELECT MAX(sal+NVL(comm,0)) max_pay
        INTO vmax_pay
    FROM emp
    WHERE deptno = 10;

    -- 2번 수행
    SELECT empno, deptno, ename, job, mgr, hiredate, sal + NVL(comm, 0) pay
         INTO tempno, tdeptno, tename, tjob, tmgr, thiredate, tpay
    FROM emp
    WHERE deptno = 10 AND sal + NVL(comm, 0) = vmax_pay;

    DBMS_OUTPUT.PUT_LINE(tempno || ', '|| tdeptno || ', '|| tename || ', '|| tjob || ', '|| tmgr || ', '|| thiredate || ', '|| tpay);
--EXCEPTION
END;

--------------------
2. %ROWTYPE형 변수 : 변수명 table명%ROWTYPE;

DECLARE
    -- emp 테이블의 한 행(레코드) 전체를 저장할 변수 선언
    vemprow emp%ROWTYPE;
    vpay NUMBER;
    
    vmax_pay NUMBER;
BEGIN 
    -- 1번 수행 *** 서브쿼리를 따로 빼와서 변수에 저장
    SELECT MAX(sal+NVL(comm,0)) max_pay INTO vmax_pay
    FROM emp
    WHERE deptno = 10;

    -- 2번 수행
    SELECT empno, deptno, ename, job, mgr, hiredate, sal + NVL(comm, 0) pay
         INTO vemprow.empno, vemprow.deptno, vemprow.ename, vemprow.job, vemprow.mgr, vemprow.hiredate, vpay
    FROM emp
    WHERE deptno = 10 AND sal + NVL(comm, 0) = vmax_pay;

    DBMS_OUTPUT.PUT_LINE(vemprow.empno || ', '|| vemprow.deptno || ', '|| vemprow.ename || ', '|| vemprow.job
                            || ', '|| vemprow.mgr || ', '|| vemprow.hiredate || ', '|| vpay);
--EXCEPTION
END;

------------------------------
PL/SQL 문 안에서 SELECT한 처리 결과가 여러 개의 행을 반환할 경우에는 아래와 같이 에러가 발생한다.
따라서 반드시 '커서(CURSOR)'를 사용해야 된다.  -> 나중에 다시 알려주실 예정!
    에러 : ORA-01422: exact fetch returns more than requested number of rows
    해석 : 요청된 행의 수보다 더 많이 가져온다.
    
    DECLARE
        vename emp.ename%TYPE;
        vjob emp.job%TYPE;
    BEGIN
        SELECT ename, job -- 12명 사원 == 12 row (행)
            INTO vename, vjob
        FROM emp;
        --WHERE empno = 7369;
    --EXCEPTION
        DBMS_OUTPUT.PUT_LINE(vename || ',' || vjob);
    END;

------------------------------
3. [PL/SQL의 제어문]
1) IF / ELSE IF문
[Java]
if(조건식) {
}

[PL/SQL]
IF( 조건식 ) THEN
IF 조건식 THEN
END IF;

----
[Java]
if(조건식) {
} else {
}

[PL/SQL]
IF( 조건식 ) THEN
    -- 코딩
ELSE
    -- 코딩
END IF;

----
[Java]
if(조건식) {
} else if() {
} else if() {
} else {
}

[PL/SQL]
IF( 조건식 ) THEN
ELSIF( 조건식 ) THEN
ELSIF( 조건식 ) THEN
ELSIF( 조건식 ) THEN
ELSE 
END IF;


    예시1) 변수를 하나 선언해서 정수를 입력받아서 짝수/홀수 출력
    
    DECLARE
        vnum NUMBER := 0;
        vresult VARCHAR2(20);
    BEGIN
        vnum :=  :bindNumber; -- 변수를 입력받아서 대입하겠다.
        
        IF(mod(vnum, 2) = 0) THEN
            vresult := '짝수';
        ELSE
            vresult := '홀수';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE(vresult);
    -- EXCEPTION
    END;
    
    예시2) 국어 점수를 입력받아서 수우미양가라고 출력하는 익명프로시저 작성
    
    DECLARE
        kor NUMBER(3) := 0;
        grade VARCHAR2(3) := '가';
    BEGIN
        kor := :bindNumber;
        
        IF kor >= 90 THEN
            grade := '수';
        ELSIF kor >= 80 THEN
            grade := '우';
        ELSIF kor >= 70 THEN
            grade := '미';
        ELSIF kor >= 60 THEN
            grade := '양';        
        ELSE
            grade := '가';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE(grade);
    -- EXCEPTION
    END;


-------
CASE문 사용)

    DECLARE
        kor NUMBER(3) := 0;
        grade VARCHAR2(3) := '가';
    BEGIN
        kor := :bindKor;
        kor := TRUNC(kor / 10);
        
        CASE kor
            WHEN 10 THEN grade := '수';
            WHEN 9 THEN grade := '수';
            WHEN 8 THEN grade := '우';
            WHEN 7 THEN grade := '미';
            WHEN 6 THEN grade := '양';
            ELSE grade := '가';
        END CASE;
        
        DBMS_OUTPUT.PUT_LINE(grade);
    -- EXCEPTION
    END;

------------
2) FOR...LOOP 문(제한적 반복)
    【형식】 
        FOR counter변수 IN [REVERSE] 시작값 .. 끝값
        LOOP 
          실행문; -- 반복처리할 코딩
        END LOOP; 
    
    예시1) 1 ~ 10까지 합을 출력
    1+2+3+4+5+6+7+8+9+10+=65 마지막 + 제거
    
    DECLARE
        vi NUMBER;
        vsum NUMBER := 10;
    BEGIN
        FOR vi IN 1..10
        LOOP
            vsum := vsum + vi;
            -- DBMS_OUTPUT.PUT_LINE(vi || '+' );
            IF(vi = 10) THEN
                DBMS_OUTPUT.PUT(vi);
            ELSE
                DBMS_OUTPUT.PUT(vi || '+' );
            END IF;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('=' || vsum );
    -- EXCEPTION
    END;

------------
3) WHILE...LOOP 문(제한적 반복)           

 [형식1]
     LOOP 
       EXIT WHEN 빠져나가는조건;
       실행문; 
     END LOOP; 
    
 [형식2]
     WHILE 조건
     LOOP
       실행문; -- 조건이 참일동안 실행되는 문
     END LOOP; 

----------
    예시1) 1 ~ 10까지 합을 출력
    1+2+3+4+5+6+7+8+9+10+=65 마지막 + 제거   
    
    풀이1) LOOP END LOOP; 문
    DECLARE
        vi NUMBER := 1;
        vsum NUMBER := 0;
    BEGIN
        vi := 1;
        LOOP
          EXIT WHEN vi = 11;
            DBMS_OUTPUT.PUT(vi || '+');
            vsum := vsum + vi;
            vi := vi + 1;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('=' || vsum);
    -- EXCEPTION
    END;
    
    
    풀이2) WHILE LOOP END LOOP; 문
    DECLARE
        vi NUMBER := 1;
        vsum NUMBER := 0;
    BEGIN
        vi := 1;
        WHILE (vi <= 10)
        LOOP
            DBMS_OUTPUT.PUT(vi || '+');
            vsum := vsum + vi;
            vi := vi + 1;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('=' || vsum);
    -- EXCEPTION
    END;

----------
    예시2) 구구단
    1) FOR문 2개 사용
    
    DECLARE
        vdan NUMBER(1);
        vi NUMBER(1);
    BEGIN
        FOR vdan IN 2..9
        LOOP
            FOR vi IN 1..9
            LOOP
                DBMS_OUTPUT.PUT(vdan || '*' || vi || '=' || RPAD(vdan * vi, 4, ' ') );
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
    -- EXCEPTION
    END;
    
    2) WHILE문 2개 사용
    
    DECLARE
        vdan NUMBER(2) := 2;
        vi NUMBER(2) := 1;
    BEGIN
        WHILE (vdan <= 9)
        LOOP
            vi := 1;
            WHILE (vi <= 9)
            LOOP
                DBMS_OUTPUT.PUT(vdan || '*' || vi || '=' || RPAD(vdan * vi, 4, ' ') );
                vi := vi + 1;
            END LOOP;
                DBMS_OUTPUT.PUT_LINE('');
                vdan := vdan + 1;
        END LOOP;
    END;
    
    
    3) LOOP END LOOP 문 사용   
         
    -- 경환쓰~  
    DECLARE
        vdan NUMBER;
        vnum NUMBER;
    BEGIN
        vdan := 2;
        LOOP
            vnum := 1;
    
            LOOP
                DBMS_OUTPUT.PUT_LINE(vdan || '*' || vnum || '=' ||vdan*vnum);
                vnum := vnum +1;
                EXIT WHEN (vnum > 9); 
            END LOOP;
            
            vdan := vdan +1;
            EXIT WHEN (vdan > 9);    
        END LOOP; 
    --EXCEPTION
    END;

----------------------------------------------------------
4. [RECORD형 변수 설명]
    emp / dept조인
    deptno, dname, empno, ename
    
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
    FROM emp e JOIN dept d ON e.deptno = d.deptno
    WHERE empno = 7369;

1) %TYPE형 변수 선언
    DECLARE
        vdeptno dept.deptno%TYPE; 
        vdname dept.dname%TYPE;
        vempno emp.empno%TYPE;
        vename emp.ename%TYPE;
        vpay NUMBER;
    BEGIN
        SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
            INTO vdeptno, vdname, vempno, vename, vpay
        FROM emp e JOIN dept d ON e.deptno = d.deptno
        WHERE empno = 7369;
        
        DBMS_OUTPUT.PUT_LINE(vdeptno || ', ' ||  vdname || ', ' || vempno || ', ' || vename || ', ' || vpay);
    -- EXCEPTION
    END;

-------
2) %ROWTYPE형 변수 선언
    DECLARE
        vdrow dept%ROWTYPE;
        verow emp%ROWTYPE; 
    
        vpay NUMBER;
    BEGIN
        SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
            INTO vdrow.deptno, vdrow.dname, verow.empno, verow.ename, vpay
        FROM emp e JOIN dept d ON e.deptno = d.deptno
        WHERE empno = 7369;
        
        DBMS_OUTPUT.PUT_LINE(vdrow.deptno || ', ' ||   vdrow.dname || ', ' || verow.empno || ', ' || verow.ename || ', ' || vpay);
    -- EXCEPTION
    END;

----------------------------   
3) RECORD형 변수    
    DECLARE
        -- 사용자가 정의하는 새로운 구조의 자료형 => '사용자 정의 구조체'
        TYPE EmpDeptType IS RECORD -- 구조체 이름 정의
        (
            vdeptno dept.deptno%TYPE, 
            vdname dept.dname%TYPE, -- 구분자는 ,(콤마)!!
            vempno emp.empno%TYPE,
            vename emp.ename%TYPE,
            vpay NUMBER
        );
        
        vrow EmpDeptType; -- RECORD형 변수 선언
    BEGIN
        SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
            INTO vrow.vdeptno, vrow.vdname, vrow.vempno, vrow.vename, vrow.vpay
        FROM emp e JOIN dept d ON e.deptno = d.deptno
        WHERE empno = 7369;
        
        DBMS_OUTPUT.PUT_LINE(vrow.vdeptno || ', ' ||  vrow.vdname || ', ' || vrow.vempno || ', ' || vrow.vename || ', ' || vrow.vpay);
    -- EXCEPTION
    END;

----------------------------  
5. CURSOR
1) CURSOR ? PL/SQL 블럭 내에서 실행되는 SELECT문을 의미
2) 여러 개의 레코드를 처리하기위해서 커서(CURSOR)를 사용해야된다.
3) 커서의 2가지 종류
    ㄱ. implicit cursor 묵시적(암시적, 자동) 커서
    예시)
        DECLARE
            -- vrow 선언X
        BEGIN
            FOR vrow IN (SELECT empno, ename, job FROM emp)
            LOOP
                DBMS_OUTPUT.PUT_LINE(vrow.empno || ', ' || vrow.ename || ', ' || vrow.job);
            END LOOP;
        --EXCEPTION
        END;

    ㄴ. explicit cursor 명시적 커서
     (1) 커서 선언
     (2) 커서 OPEN
     (3) LOOP
            -- 커서로부터 SELECT한 것을 가져오는 코딩(FETCH)
            EXIT WHEN 커서가 읽을 것이 없을 때 까지의 조건 (%NOTFOUND 참이될 때 까지)
         END LOOP;
     (4) 커서 CLOSE
     
4) 형식
    [커서선언형식]
    CURSOR 커서명 IS (서브쿼리);
    OPEN [커서명];
    FOR
     FETCH [커서명] INTO [변수명];
     EXIT WHEN [조건절];
    END LOOP;
    CLOSE [커서명];
    
    [커서의 속성]
    > %ROWCOUNT  실행된 커서문장에서 읽힌 행의 수 
    > %FOUND  실행된 커서문장에서 검색된 행이 발견되었는지 알 수 있는 속성 
    > %NOTFOUND  실행된 커서문장에서 검색된 행이 발견되지 않았음을 알 수 있는 속성 
    > %ISOPEN  선언된 커서가 현재 OPEN되어 있는지를 반환 
   
    
5) 예시
        DECLARE
            vename emp.ename%TYPE;
            vsal emp.sal%TYPE;
            vhiredate emp.hiredate%TYPE;
        BEGIN
            SELECT ename, sal, hiredate
                INTO vename, vsal, vhiredate
            FROM emp
            WHERE deptno = 30;
            
            DBMS_OUTPUT.PUT_LINE(vename || ', ' || vsal || ', ' || vhiredate );
        -- EXCEPTION
        END;
        
        에러 : ORA-01422: exact fetch returns more than requested number of rows
        원인 : 가져올 레코드가 많아서 발생, 커서를 사용하여 해결하기
        
커서를 사용하기)
        DECLARE
            vename emp.ename%TYPE;
            vsal emp.sal%TYPE;
            vhiredate emp.hiredate%TYPE;
            
            -- 1) 커서 선언 : CURSOR 커서명 IS (서브쿼리);
            CURSOR emp30_cursor IS(
                                        SELECT ename, sal, hiredate
                                        FROM emp
                                        WHERE deptno = 30
                                );
        BEGIN
            --2) OPEN : OPEN 커서명;
            OPEN emp30_cursor;
            
            --3) LOOP ~ FETCH 작업(반복적으로 가져오는 작업)
            LOOP
                FETCH emp30_cursor INTO vename, vsal, vhiredate;
                DBMS_OUTPUT.PUT_LINE(vename || ', ' || vsal || ', ' || vhiredate );
                EXIT WHEN emp30_cursor%NOTFOUND;
            END LOOP;        
            
            --4) CLOSE : CLOSE 커서명;
            CLOSE emp30_cursor;
            
        -- EXCEPTION
        END;   

-------------------------
        DECLARE
            CURSOR emp_cursor IS( SELECT empno, ename, job FROM emp );
        BEGIN
            FOR vrow IN emp_cursor     
            LOOP
                DBMS_OUTPUT.PUT_LINE(vrow.ename || ', ' || vrow.ename  || ', ' || vrow.job );
            END LOOP;
            
        -- EXCEPTION
        END;   

--------------------
        DECLARE
            vename emp.ename%TYPE;
            vsal emp.sal%TYPE;
            vhiredate emp.hiredate%TYPE;
            
            -- 1) 커서 선언 : CURSOR 커서명 IS (서브쿼리);
            CURSOR emp30_cursor IS(
                                        SELECT ename, sal, hiredate
                                        FROM emp
                                        WHERE deptno = 30
                                );
        BEGIN
            --2) OPEN : OPEN 커서명;
            OPEN emp30_cursor;
            
            --3) LOOP ~ FETCH 작업(반복적으로 가져오는 작업)
            LOOP
                FETCH emp30_cursor INTO vename, vsal, vhiredate;
                DBMS_OUTPUT.PUT_LINE(vename || ', ' || vsal || ', ' || vhiredate );
                EXIT WHEN emp30_cursor%NOTFOUND OR emp30_cursor%ROWCOUNT >= 3;
            END LOOP;        
            
            --4) CLOSE : CLOSE 커서명;
            CLOSE emp30_cursor;
            
        -- EXCEPTION
        END;

-- 지금까지 익명 프로시저를 사용해서 PL/SQL 기본(변수 선언, 커서, 제어문) 문법 배웠음 --

저장 프로시저(stored procedure)
1) PL/SQL 6가지 중에 가장 대표적인 구조

2) 개발자가 자주 실행해야 하는 업무를 이 문법에 의해 미리 작성하고
    DB 내에 저장해 두었다가 필요할 때 마다 호출해서 사용할 수 있다. (성능 때문에..)
    
3) 저장 프로시저 선언 형식
    CREATE OR REPLACE PROCEDURE 프로시저명
    (
        -- 파라미터를 여러개 준다면 ,(콤마) 구분 / 자료형은 크기 설정 안한다.
        파라미터 선언 MODE (IN/OUT/INOUT) 자료형, -- 기본은 IN(입력용) 
        파라미터 선언 MODE (IN/OUT/INOUT) 자료형, -- 기본은 IN(입력용)
        파라미터 선언 MODE (IN/OUT/INOUT) 자료형 -- 기본은 IN(입력용)
    )
    IS -- DECLARE 대신에 사용함
        -- 변수,
        -- 변수,
        -- 변수,
    BEGIN
        -- 실행 쿼리
    EXCEPTION
        -- 예외처리
    END;
    

4) 저장 프로시저 사용하는 방법
    ㄱ. EXECUTE문 실행
    ㄴ. 또 다른 저장 프로시저 안에서 호출해서 실행
    ㄷ. 익명 프로시저에서 호출할 수 있음

5) 예시 up == user procedure
(1) 프로시저 생성
CREATE OR REPLACE PROCEDURE up_delDept
(
    -- 파라미터 MODE IN 자료형,
    pdeptno IN NUMBER -- 삭제하고자 하는 부서번호를 입력받을 파라미터(인자)
)
IS
    -- 변수
BEGIN
    -- 실행
    DELETE FROM dept
    WHERE deptno = pdeptno;
    
    -- COMMIT; -- 커밋 또는 롤백해줘야 작업이 완료됨 현재는 다시 돌릴 거라 하지 않음
    
-- EXCEPTION
END up_delDept;
--> rocedure UP_DELDEPT이(가) 컴파일되었습니다.



(2) 익명 프로시저에서 저장 프로시저 호출
DECLARE
BEGIN
    up_deldept(40); -- 40이 pdeptno임!
--EXCEPTION
END;
--> PL/SQL 프로시저가 성공적으로 완료되었습니다.



(3) EXECUTE에서 사용
EXECUTE up_deldept(40);

ROLLBACK;

------------------
SELECT *
FROM dept;

<변경전>
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON

<변경후>
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
    
    
    