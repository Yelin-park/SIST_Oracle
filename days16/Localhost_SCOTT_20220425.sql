-- [ SCOTT에 접속된 스크립트 파일 ]        
1. PL/SQL ***
1) 저장 프로시저

    ㄱ. 저장 프로시저 생성 - dept 테이블에 새로운 부서를 추가하는 up_incdept
        (1) 테이블 확인
        SELECT *
        FROM dept;
        
        (2) seq_dept 시퀀스 유무 확인
        SELECT *
        FROM user_sequences;
        
        (3) seq_dept 시퀀스 삭제 후 재생성
        DROP SEQUENCE seq_dept;
        
        (4) 시퀀스 생성
        CREATE SEQUENCE seq_dept
        INCREMENT BY 10
        START WITH 50
        MAXVALUE 90
        NOCACHE; 
        
        (5) 저장 프로시저 생성 **
        CREATE OR REPLACE PROCEDURE up_insDept
        (
            pdname dept.dname%TYPE := null -- 부서명
            , ploc dept.loc%TYPE DEFAULT null -- 지역명
        )
        IS
        BEGIN
            INSERT INTO dept (deptno, dname, loc) VALUES (seq_dept.nextval, pdname, ploc );
            -- COMMIT; -- 다시 롤백할 거라 주석처리
        -- EXCEPTION
            -- ROLLBACK; -- 오류가 있다면..
        END;
        
        (6) 익명 프로시저에서 저장 프로시저 호출
        BEGIN
            -- UP_INSDEPT(pdname => 'QC', ploc => 'SEOUL'); -- 이렇게 선언해도 된다.
            -- UP_INSDEPT('QC', 'SEOUL'); -- 순서대로 준다면 파라미터를 빼도 됨
            -- UP_INSDEPT( ploc => 'SEOUL', pdname => 'QC'); -- 순서대로 안주면 해당하는 파라미터에 넣어줘야 한다.
            UP_INSDEPT(pdname => 'QC'); -- 기본값을 주어서 ploc는 null로 들어감
        END;
        
        ROLLBACK;
        
        SELECT * FROM dept;
        
        COMMIT;
    
----------   
    ㄴ. dept 테이블에서 부서정보를 수정하는 저장 프로시저 생성
 
        (2)
        -- EXECUTE 또는 EXEC 이렇게 선언하여 사용
        EXEC up_updDept(60, 'QC', 'SEOUL'); -- 부서명, 지역명 수정
        EXEC up_updDept(60, pdname => 'XX'); -- 부서명만 수정
        EXEC up_updDept(60, ploc => 'YY'); -- 지역명만 수정
        --> PL/SQL 프로시저가 성공적으로 완료되었습니다.
    
        (1) 저장프로시저 생성
        CREATE OR REPLACE PROCEDURE up_updDept
        (
            pdeptno IN dept.deptno%TYPE
            , pdname IN dept.dname%TYPE := null
            , ploc IN dept.loc%TYPE DEFAULT null
        )
        IS
            vdname dept.dname%TYPE; -- 수정할 원래 레코드의 부서명
            vloc dept.loc%TYPE; -- 수정할 원래 레코드의 지역명
        BEGIN
            IF pdname IS NULL OR ploc IS NULL THEN
                SELECT dname, loc INTO vdname, vloc -- 수정하기 전에 원래 가지고 있는 부서명, 지역명
                FROM dept
                WHERE deptno = pdeptno;
            END IF;
            
            UPDATE dept
            SET dname = CASE
                            WHEN pdname IS NULL THEN vdname -- pdname이 null이다. 안넘어왔다. 부서명을 수정안하겠다.
                            ELSE pdname
                        END
                , loc = NVL(ploc, vloc)
            WHERE deptno = pdeptno;
            -- COMMIT;
        --EXCEPTION
        END;

----------
    ㄷ. 모든 부서 정보를 조회하는 저장 프로시저 생성
        (1) 프로시저 생성 + 명시적 커서를 사용한 예제
        CREATE OR REPLACE PROCEDURE up_selDept
        -- 파라미터가 없을 경우 () 생략 가능
        IS
            CURSOR vcurdept IS (SELECT * FROM dept); -- 모든 부서의 정보를 가져오는 커서(명시적 커서 선언)
            vrowdept dept%ROWTYPE; -- 행을 저장하는 변수 선언
        BEGIN
            OPEN vcurdept;
            
            LOOP
                FETCH vcurdept INTO vrowdept;
                EXIT WHEN vcurdept %NOTFOUND;
                DBMS_OUTPUT.PUT_LINE(vrowdept.deptno || ', ' || vrowdept.dname || ', ' || vrowdept.loc);
            END LOOP;
            
            CLOSE vcurdept;
        -- EXCEPTION
        END;
        --> Procedure UP_SELDEPT이(가) 컴파일되었습니다.
        
        (2) 프로시저 실행
        EXECUTE up_selDept;
    
------
        (3) 저장 프로시저 생성 + 암시적 커서를 사용한 예제
        CREATE OR REPLACE PROCEDURE up_selDept
        -- 파라미터가 없을 경우 () 생략 가능
        IS
        BEGIN
            FOR vrowdept IN (SELECT * FROM dept)
            LOOP
                DBMS_OUTPUT.PUT_LINE(vrowdept.deptno || ', ' || vrowdept.dname || ', ' || vrowdept.loc);
            END LOOP;
        -- EXCEPTION
        END;
        --> Procedure UP_SELDEPT이(가) 컴파일되었습니다.    
        
        (4) 프로시저 실행
        EXECUTE up_selDept;

----------------------------------
1-2) 저장 프로시저의 파라미터의 MODE(IN/OUT/INOUT)에 대해서 살펴보자

     ㄹ. insa 테이블의 사원번호를 입력용파라미터로 입력을 하면 그 사원의 주민번호 앞자리
         6자리를 출력용파라미터에 출력하는 저장프로시저 생성
        
        (1) 프로시저 생성
        CREATE OR REPLACE PROCEDURE up_rrn6Insa
        (
            pnum IN insa.num%TYPE
            , prrn6 OUT VARCHAR2 -- 저장 프로시저는 크기 설정하지 않음
        )
        IS
            vssn insa.ssn%TYPE;
        BEGIN
            SELECT ssn INTO vssn
            FROM insa
            WHERE num = pnum; -- 파라미터에 해당하는 num
            
            prrn6 := SUBSTR(vssn, 0, 6);
        -- EXCEPTION
        END;
        --> Procedure UP_RRN6INSA이(가) 컴파일되었습니다.
        
        (2) 익명프로시저에서 출력용 파라미터를 가진 저장프로시저 호출
        DECLARE
            vssn6 VARCHAR2(6);
        BEGIN
            UP_RRN6INSA(1001, vssn6);
            DBMS_OUTPUT.PUT_LINE('vssn6 : ' || vssn6);
        END;

----
    문제1) tbl_score 테이블에 새로운 학생의 성적 정보를 저장하는 프로시저 : up_insScore
        p : num, kor, eng, mat 입력하지 않으면 0으로 처리
        tot, avg, grade까지는 처리가 되도록
        
        CREATE OR REPLACE PROCEDURE up_insScore
        (
            pnum tbl_score.num%TYPE
            , pname tbl_score.name%TYPE
            , pkor tbl_score.kor%TYPE
            , peng tbl_score.eng%TYPE
            , pmat tbl_score.mat%TYPE
        )
        IS 
            vtot tbl_score.tot%TYPE;
            vavg tbl_score.avg%TYPE;
            vgrade tbl_score.grade%TYPE;
            
        BEGIN
            vtot := pkor + peng + pmat;
            vavg := TRUNC(vtot / 3, 2);
            vgrade := CASE
                        WHEN vavg >= 90 THEN 'A'
                        WHEN vavg >= 80 THEN 'B'
                        WHEN vavg >= 70 THEN 'C'
                        WHEN vavg >= 60 THEN 'D'
                        ELSE 'F'
                      END;
            
            INSERT INTO tbl_score (num, name, kor, eng, mat, tot, avg, grade)
                    VALUES (pnum, pname, pkor, peng, pmat, vtot, vavg, vgrade);
        END;
        
        
        EXEC up_insScore(1100, '야리니', 80, 87, 90);
        
        SELECT *
        FROM tbl_score;
        
        
    문제2) tbl_score 테이블에 새로운 학생의 성적 정보를 수정하는 프로시저 : up_updScore
        p : kor, eng, mat 입력하지 않으면 0으로 처리
        tot, avg, grade까지는 처리가 되도록
        
        CREATE OR REPLACE PROCEDURE up_updScore
        (
            pnum tbl_score.num%TYPE
            , pkor tbl_score.kor%TYPE := NULL
            , peng tbl_score.eng%TYPE := NULL
            , pmat tbl_score.mat%TYPE := NULL
        )
        IS
            vkor tbl_score.kor%TYPE;
            veng tbl_score.eng%TYPE;
            vmat tbl_score.mat%TYPE;
            
            vtot tbl_score.tot%TYPE;
            vavg tbl_score.avg%TYPE;
            vgrade tbl_score.grade%TYPE;            
        BEGIN
            SELECT kor, eng, mat INTO vkor, veng, vmat
            FROM tbl_score
            WHERE num = pnum;
            
            vkor := NVL(pkor, vkor);
            veng := NVL(peng, veng);
            vmat := NVL(pmat, vmat);
            
            vtot := vkor + veng + vmat;
            vavg := TRUNC(vtot / 3, 2);
            vgrade := CASE
                        WHEN vavg >= 90 THEN 'A'
                        WHEN vavg >= 80 THEN 'B'
                        WHEN vavg >= 70 THEN 'C'
                        WHEN vavg >= 60 THEN 'D'
                        ELSE 'F'                   
                      END;
                      
            UPDATE tbl_score  
            SET   
                  kor = vkor, eng = veng, mat = vmat
                  , tot = vtot
                  , avg = vavg
                  , grade = vgrade
            WHERE num = pnum;
        END;
                
        EXEC up_updScore(1100, pkor => 80 );
        
        EXEC up_updScore(1100, 90, 85, 100 );
                
        SELECT *
        FROM tbl_score;
        
    문제3) tbl_score 테이블에 삭제하는 프로시저 : up_delScore
        p : num
    
        CREATE OR REPLACE PROCEDURE up_delScore
        (
            pnum tbl_score.num%TYPE
        )
        IS
        BEGIN
            DELETE FROM tbl_score
            WHERE num = pnum;
        -- EXCEPTION
        END;
        
        EXEC up_delScore(1100);
        
       SELECT *
       FROM tbl_score;    
   
    문제4) tbl_score 테이블에 모든 학생 정보를 조회하는 프로시저 : up_selScore
    
        CREATE OR REPLACE PROCEDURE up_selScore
        IS
            CURSOR vcurScore IS (SELECT * FROM tbl_score);
            vrowscore tbl_score%ROWTYPE;
        BEGIN
            OPEN vcurScore;
            LOOP
             FETCH vcurScore INTO vrowscore;
             EXIT WHEN vcurScore%NOTFOUND;
             DBMS_OUTPUT.PUT_LINE(vrowscore.num || ' / ' || vrowscore.name || ' / ' || vrowscore.tot
                                 || ' / ' || vrowscore.avg || ' / ' || vrowscore.grade || ' / ' || vrowscore.rank);
            END LOOP;
            CLOSE vcurScore;
        --EXCEPTION
        END;
        
        EXEC up_selScore;
    
    문제5) 등수를 처리하는 프로시저 : up_rankScore
    UPDATE tbl_score
    SET rank = 1;

    CREATE OR REPLACE PROCEDURE up_rankScore
    IS
        vrank tbl_score.rank%TYPE;
    BEGIN
        UPDATE tbl_score t
        SET rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE tot > t.tot);
    -- EXCEPTION
    END;


    EXEC up_rankScore;
        
        
        
        
        
        
        