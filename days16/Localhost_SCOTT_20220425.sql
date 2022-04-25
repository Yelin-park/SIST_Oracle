-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]        
1. PL/SQL ***
1) ���� ���ν���

    ��. ���� ���ν��� ���� - dept ���̺� ���ο� �μ��� �߰��ϴ� up_incdept
        (1) ���̺� Ȯ��
        SELECT *
        FROM dept;
        
        (2) seq_dept ������ ���� Ȯ��
        SELECT *
        FROM user_sequences;
        
        (3) seq_dept ������ ���� �� �����
        DROP SEQUENCE seq_dept;
        
        (4) ������ ����
        CREATE SEQUENCE seq_dept
        INCREMENT BY 10
        START WITH 50
        MAXVALUE 90
        NOCACHE; 
        
        (5) ���� ���ν��� ���� **
        CREATE OR REPLACE PROCEDURE up_insDept
        (
            pdname dept.dname%TYPE := null -- �μ���
            , ploc dept.loc%TYPE DEFAULT null -- ������
        )
        IS
        BEGIN
            INSERT INTO dept (deptno, dname, loc) VALUES (seq_dept.nextval, pdname, ploc );
            -- COMMIT; -- �ٽ� �ѹ��� �Ŷ� �ּ�ó��
        -- EXCEPTION
            -- ROLLBACK; -- ������ �ִٸ�..
        END;
        
        (6) �͸� ���ν������� ���� ���ν��� ȣ��
        BEGIN
            -- UP_INSDEPT(pdname => 'QC', ploc => 'SEOUL'); -- �̷��� �����ص� �ȴ�.
            -- UP_INSDEPT('QC', 'SEOUL'); -- ������� �شٸ� �Ķ���͸� ���� ��
            -- UP_INSDEPT( ploc => 'SEOUL', pdname => 'QC'); -- ������� ���ָ� �ش��ϴ� �Ķ���Ϳ� �־���� �Ѵ�.
            UP_INSDEPT(pdname => 'QC'); -- �⺻���� �־ ploc�� null�� ��
        END;
        
        ROLLBACK;
        
        SELECT * FROM dept;
        
        COMMIT;
    
----------   
    ��. dept ���̺��� �μ������� �����ϴ� ���� ���ν��� ����
 
        (2)
        -- EXECUTE �Ǵ� EXEC �̷��� �����Ͽ� ���
        EXEC up_updDept(60, 'QC', 'SEOUL'); -- �μ���, ������ ����
        EXEC up_updDept(60, pdname => 'XX'); -- �μ��� ����
        EXEC up_updDept(60, ploc => 'YY'); -- ������ ����
        --> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.
    
        (1) �������ν��� ����
        CREATE OR REPLACE PROCEDURE up_updDept
        (
            pdeptno IN dept.deptno%TYPE
            , pdname IN dept.dname%TYPE := null
            , ploc IN dept.loc%TYPE DEFAULT null
        )
        IS
            vdname dept.dname%TYPE; -- ������ ���� ���ڵ��� �μ���
            vloc dept.loc%TYPE; -- ������ ���� ���ڵ��� ������
        BEGIN
            IF pdname IS NULL OR ploc IS NULL THEN
                SELECT dname, loc INTO vdname, vloc -- �����ϱ� ���� ���� ������ �ִ� �μ���, ������
                FROM dept
                WHERE deptno = pdeptno;
            END IF;
            
            UPDATE dept
            SET dname = CASE
                            WHEN pdname IS NULL THEN vdname -- pdname�� null�̴�. �ȳѾ�Դ�. �μ����� �������ϰڴ�.
                            ELSE pdname
                        END
                , loc = NVL(ploc, vloc)
            WHERE deptno = pdeptno;
            -- COMMIT;
        --EXCEPTION
        END;

----------
    ��. ��� �μ� ������ ��ȸ�ϴ� ���� ���ν��� ����
        (1) ���ν��� ���� + ����� Ŀ���� ����� ����
        CREATE OR REPLACE PROCEDURE up_selDept
        -- �Ķ���Ͱ� ���� ��� () ���� ����
        IS
            CURSOR vcurdept IS (SELECT * FROM dept); -- ��� �μ��� ������ �������� Ŀ��(����� Ŀ�� ����)
            vrowdept dept%ROWTYPE; -- ���� �����ϴ� ���� ����
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
        --> Procedure UP_SELDEPT��(��) �����ϵǾ����ϴ�.
        
        (2) ���ν��� ����
        EXECUTE up_selDept;
    
------
        (3) ���� ���ν��� ���� + �Ͻ��� Ŀ���� ����� ����
        CREATE OR REPLACE PROCEDURE up_selDept
        -- �Ķ���Ͱ� ���� ��� () ���� ����
        IS
        BEGIN
            FOR vrowdept IN (SELECT * FROM dept)
            LOOP
                DBMS_OUTPUT.PUT_LINE(vrowdept.deptno || ', ' || vrowdept.dname || ', ' || vrowdept.loc);
            END LOOP;
        -- EXCEPTION
        END;
        --> Procedure UP_SELDEPT��(��) �����ϵǾ����ϴ�.    
        
        (4) ���ν��� ����
        EXECUTE up_selDept;

----------------------------------
1-2) ���� ���ν����� �Ķ������ MODE(IN/OUT/INOUT)�� ���ؼ� ���캸��

     ��. insa ���̺��� �����ȣ�� �Է¿��Ķ���ͷ� �Է��� �ϸ� �� ����� �ֹι�ȣ ���ڸ�
         6�ڸ��� ��¿��Ķ���Ϳ� ����ϴ� �������ν��� ����
        
        (1) ���ν��� ����
        CREATE OR REPLACE PROCEDURE up_rrn6Insa
        (
            pnum IN insa.num%TYPE
            , prrn6 OUT VARCHAR2 -- ���� ���ν����� ũ�� �������� ����
        )
        IS
            vssn insa.ssn%TYPE;
        BEGIN
            SELECT ssn INTO vssn
            FROM insa
            WHERE num = pnum; -- �Ķ���Ϳ� �ش��ϴ� num
            
            prrn6 := SUBSTR(vssn, 0, 6);
        -- EXCEPTION
        END;
        --> Procedure UP_RRN6INSA��(��) �����ϵǾ����ϴ�.
        
        (2) �͸����ν������� ��¿� �Ķ���͸� ���� �������ν��� ȣ��
        DECLARE
            vssn6 VARCHAR2(6);
        BEGIN
            UP_RRN6INSA(1001, vssn6);
            DBMS_OUTPUT.PUT_LINE('vssn6 : ' || vssn6);
        END;

----
    ����1) tbl_score ���̺� ���ο� �л��� ���� ������ �����ϴ� ���ν��� : up_insScore
        p : num, kor, eng, mat �Է����� ������ 0���� ó��
        tot, avg, grade������ ó���� �ǵ���
        
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
        
        
        EXEC up_insScore(1100, '�߸���', 80, 87, 90);
        
        SELECT *
        FROM tbl_score;
        
        
    ����2) tbl_score ���̺� ���ο� �л��� ���� ������ �����ϴ� ���ν��� : up_updScore
        p : kor, eng, mat �Է����� ������ 0���� ó��
        tot, avg, grade������ ó���� �ǵ���
        
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
        
    ����3) tbl_score ���̺� �����ϴ� ���ν��� : up_delScore
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
   
    ����4) tbl_score ���̺� ��� �л� ������ ��ȸ�ϴ� ���ν��� : up_selScore
    
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
    
    ����5) ����� ó���ϴ� ���ν��� : up_rankScore
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
        
        
        
        
        
        
        