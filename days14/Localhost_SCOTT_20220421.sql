-- [ SCOTT에 접속된 스크립트 파일 ]
5) 정규화(Normal From) 종류
    (1) 제1정규화(1NF)
        - 릴레이션에 속한 '모든 속성의 도메인(컬럼 값)이 원자 값(atomic value) (= 중복이 되지 않은 값)으로만 구성'되어 있으면
          제1정규형에 속한다.
        - 반복되는 속성을 제거한 뒤 기본 테이블의 기본 컬럼을 추가해 새로운 테이블을 생성한다.
        
    (2) 제2정규화(2NF)
        - '부분 함수적 종속성 제거'해서 완전 함수 종속으로 만드는 것
        - 모든 컬럼(속성)이 복합키 전체에 종속적이어야한다.
        
        * 함수적 종속성 개념 : 항상 속성의 값이 오직 하나만 연관되어있을 때 Y는 X에 함수적 종속이라고 한다.(X -> Y)
                            ex) dname은 deptno에 함수적 종속, loc는 deptno에 함수적 종속
                            X는 결정자, Y(dname) Z(loc) 는 종속자
                            
        * '부분 함수적 종속성 개념'
         - 복합키에 전체적으로 의존하지 않는 속성. '즉, 복합키 중 한 개에만 종속적인 것'
            ex) 학과 등록 테이블
                학번 + 과정코드 => 복합키
                학번  과정코드    평가코드    과정명     과정기간
                100   A001         A       Java     1개월
                100   A002         F       ASP      3개월
                101   A001         A       Java     1개월
                101   A003         B       C#       1개월
                100   A001         A       Java     1개월
             > 과정명과 과정기간 속성은 복합키에 종속적이지 않고, 과정코드 속성에 부분 함수적 종속성이 있다.
             > 과정명과 과정기간 속성을 제거하는 것(=부분 함수적 종속성을 제거하는 것) -> 제2정규화 -> 새로운 테이블 생성
             
             결과) 아래처럼 과정테이블을 새롭게 만들어짐
               학번 + 과정코드 => 복합키
               학번  과정코드    평가코드    
                100   A001         A      
                100   A002         F      
                101   A001         A      
                101   A003         B       
                100   A001         A      
                
                [과정테이블] new!
                PK
                과정코드  과정명 과정기간
                A001    Java    1개월
                A002    ASP     3개월
                A003    C#      1개월
                
    (3) 제3정규화(3NF)
        - '이행적 함수적 종속성 제거'하는 것
              X      ->     Y
            결정자         종속자
            
              Y -> Z (Z는 일반컬럼인 Y한테 종속적임) -> 이것을 제거하는 것이 제3정규화
        
        ex) [ 사원(emp) 테이블]
            PK
            empno   ename   deptno    dname
            7369    홍길동     10      영업부
             X        Y       Z         K
             
            X -> Y
            X -> Z
            Z -> K (이행적 함수 종속)
                        
        결과) 부서 테이블을 따로 만들어서 이행적 함수적 종속성을 제거함
            [ 사원(emp) 테이블]
            PK
            empno   ename   deptno    
            7369    홍길동     10     
             X        Y       Z       
            
            [부서(dept) 테이블] new!
            PK
            deptno  dname
            10      영업부
            
    (4) BCNF(Boyce/Codd Normal Form)
        - 릴레이션 R이 제3정규화를 만족하고, 모든 결정자가 후보키이어야 한다는 것
        - 제3정규화를 만족하는 대부분의 릴레이션들은 BCNF도 만족한다.
        
        [X + Y] 복합키
        Z -> Y  : '복합키 중의 한 속성(Y)이 일반속성(컬럼, Z)에 종속적인 것 -> 이것을 제거하는 것이 BCNF'
    
    (5) 제4정규화
    
    (6) 제5정규화

----------------------------------------------------------------------------------------------------
2. 물리적 DB 모델링
   -- > 논리적 모델링을 했다. ERD로 관계 스키마를 만들고 정규화 작업이 완료된 것
   - 좀 더 효율적으로 구현하기 위한 작업 방법과 함께 개발하려는 DBMS의 특성에 맞게 실제 DB 내의 개체들을 정의하는 단계
   - 데이터 사용량 분석, 업무 프로세스 분석을 통해서 보다 효율적인 DB가 될 수 있도록 Index 사용, 역정규화 수행
   
-----------------------------------------------------------
3. View(뷰)
FROM 테이블명 또는 뷰명
FROM user_tables;
    1) 테이블을 보기위한 창문 = View (보는 방향에 따라서 다르게 보인다)
    
    2) View의 의미는 하나의 SELECT 문과 동일하다(보여주는 것)
        SELECT deptno, ename
        FROM emp
        WHERE deptno = 10;
        
    3) View를 통해 INSERT, UPDATE, DELETE 가 가능하지만 대부분 SELECT 를 하기 위해서 사용한다.
    
    4) View는 가상 테이블이다
    
    5) View는 한 개 이상의 테이블로 뷰를 생성할 수 있다.
              또 다른 뷰를 통해서 뷰를 생성할 수 있다.
              
    6) View를 사용하는 목적 : 데이터의 일부만 접근할 수 있도록 제한하기 위한 기법으로 사용되어진다.
                            + 보안성 + 편리성
    
    7) View 생성한다는 의미 : Data Dictionary(데이터 자료사전) 테이블에 뷰에 대한 정의만 저장되고
                           실제 디스크에는 저장공간이 할당되지 않는다.
                        ex) user_tables 뷰 -> 자료사전에 정의
                        
    8) View를 사용해서 DML + 제약 조건 설정도 가능하다.
    
    9) View 종류
     (1) 심플뷰(Simple View) - 1개의 실제 테이블을 연동하는 것
     (2) 복합뷰(Complex View) - 2개 이상의 실제 테이블을 연동하는 것
    
    10) View 생성 형식
    【형식】
        CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름
            [(alias[,alias]...]
        AS subquery
        [WITH CHECK OPTION]
        [WITH READ ONLY];
        
        각각의 옵션의 의미는 다음과 같다.
        > OR REPLACE 같은 이름의 뷰가 없으면 그냥 생성, 있으면 수정해서 생성 
        > FORCE 기본 테이블의 유무에 상관없이 뷰를 생성 
        > NOFORCE 기본 테이블이 있을 때만 뷰를 생성 
        > ALIAS 기본 테이블의 컬럼이름과 다르게 지정한 뷰의 컬럼명 부여 
        > WITH CHECK OPTION 뷰에 의해 access될 수 있는 행(row)만이 삽입, 수정 가능 
        > WITH READ ONLY     DML 작업을 제한(단지 읽는 것만 가능, 읽기 전용) 
        
    11) 테스트
      가정) 우리가 자주 판매량을 확인하는 쿼리를 수행한다. (아래와 같이)
    
      SELECT b.b_id, title, price, g.g_id, g_name, p_date, p_su
      FROM book b JOIN danga d ON b.b_id = d.b_id
                  JOIN panmai p ON b.b_id = p.b_id
                  JOIN gogaek g ON g.g_id = p.g_id;
     
      --> 계속 이렇게 조인을 하면 성능이 떨어지기 때문에 뷰를 생성하겠다.
      
      [뷰 생성]
          CREATE OR REPLACE VIEW panView
                (bookid, booktitle, bookdanga, gogaekid, gogaekname, pdate, psu)
              -- b.b_id, title, price, g.g_id, g_name, p_date, p_su 이거에 대한 별칭
          AS SELECT b.b_id, title, price, g.g_id, g_name, p_date , p_su
             FROM book b JOIN danga d ON b.b_id = d.b_id
                         JOIN panmai p ON b.b_id = p.b_id
                         JOIN gogaek g ON g.g_id = p.g_id;
          
          -- ORA-01031: insufficient privileges
          -- 해석 : scott 계정이 View 생성할 권한이 없다.
          -- 해결 : SYS 계정에서 권한 부여하기
          --> View PANVIEW이(가) 생성되었습니다.
          
      [뷰 사용] 어떤걸 조인했는지 잘 모르고(보안성) 자주 쓰는걸 편하게 불러올 수 있다.
          SELECT *
          FROM panview;
          
          scott이 가지고 있는 권한 확인)
          SELECT *
          FROM user_sys_privs;
          
          view 구조 확인 가능)
          DESC panview; -- 가상테이블(실제 데이터를 가지고 있지는 않음)
          
          View 소스 확인)
          SELECT *
          FROM user_views;
          -- WHERE view_name = 'PANVIEW';
          
          뷰를 사용해서 전체 판매금액 확인하기)
          SELECT SUM(psu * bookdanga) 전체판매금액
          FROM panview;
      
      [문제] 뷰 생성 - gogaekView
              년도, 월, 고객코드, 고객명, 판매금액합(년도별 월별) 조회하는 뷰 생성
                     
             CREATE OR REPLACE VIEW gogaekView
                (년도, 월, 고객코드, 고객명, 판매금액합 )
             AS SELECT TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM')
                        , g.g_id, g_name, SUM(p_su * price)
                 FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
                            JOIN danga d ON p.b_id = d.b_id
                 GROUP BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM'), g.g_id, g_name
                 ORDER BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM'), g.g_id, g_name;
              
              뷰 조회)
              SELECT *
              FROM gogaekView;
    
     [뷰를 사용해서 DML 작업해보기]
         CREATE TABLE testa(
              aid        number primary key
              , name    varchar2(20) not null
              , tel    varchar2(20) not null
              , memo   varchar2(100)
         );       
         
            CREATE TABLE testb(
               bid  number primary key
               , aid  number constraint fk_testb_aid references testa(aid) on delete cascade
               , score number(3)
            ); 
            
            INSERT INTO testa (aid, NAME, tel) VALUES (1, 'a', '1');
            INSERT INTO testa (aid, name, tel) VALUES (2, 'b', '2');
            INSERT INTO testa (aid, name, tel) VALUES (3, 'c', '3');
            INSERT INTO testa (aid, name, tel) VALUES (4, 'd', '4');
            
            INSERT INTO testb (bid, aid, score) VALUES (1, 1, 80);
            INSERT INTO testb (bid, aid, score) VALUES (2, 2, 70);
            INSERT INTO testb (bid, aid, score) VALUES (3, 3, 90);
            INSERT INTO testb (bid, aid, score) VALUES (4, 4, 100);

            COMMIT;
            
            SELECT * FROM testa;
            AID         NAME                 TEL                  MEMO                                                                                                
            ---------- -------------------- -------------------- --------------------
                     1 a                    1                                                                                                                        
                     2 b                    2                                                                                                                        
                     3 c                    3                                                                                                                        
                     4 d                    4             
            
            SELECT * FROM testb;
                   BID        AID      SCORE
            ---------- ---------- ----------
                     1          1         80
                     2          2         70
                     3          3         90
                     4          4        100
                 
        [심플뷰 생성]
        CREATE OR REPLACE VIEW aView
        AS
            SELECT aid, name, memo
            FROM testa;
        --> View AVIEW이(가) 생성되었습니다.
        
        - 조회
        SELECT *
        FROM aView;
    
        - aView 심플뷰를 사용해서 INSERT 작업하기
        INSERT INTO aView (aid, name, memo) VALUES (5,'f', null);
       -- ORA-01400: cannot insert NULL into ("SCOTT"."TESTA"."TEL")
       -- TEL은 NN 제약조건을 가지고 있기때문에 INESRT 작업을 할 수가 없다.
       -- 즉, View를 생성할 때 NN을 가지고 있는 컬럼을 생성해야 INSERT 작업 가능
       
       - memo를 tel로 변경하여 뷰생성
        CREATE OR REPLACE VIEW aView
        AS
            SELECT aid, name, tel
            FROM testa;
        
        - aView 심플뷰를 사용해서 다시 INSERT 작업하기
        INSERT INTO aView (aid, name, tel) VALUES (5,'f', '5');    
        -- 1 행 이(가) 삽입되었습니다.
        
        - 테이블에 추가된 것 확인
        SELECT *
        FROM testa;
        
        --
        [복합뷰 생성] abView
        CREATE OR REPLACE VIEW abView
        AS
            SELECT a.aid, name, tel, bid, score
            FROM testa a JOIN testb b ON a.aid = b.aid;
        -- WITH READ ONLY; -- SELECT만 하겠다. I/U/D 할 수 없음.
         
         [삽입]    
        INSERT INTO abView (aid, name, tel, bid, score) VALUES (10, 'X', '5', 20, 70);
        -- SQL 오류: ORA-01779: cannot modify a column which maps to a non key-preserved table
        -- 동시에 두 테이블에 INSERT 할 수 없다.
        
         [수정] : 하나의 테이블만 수정하겠다.
        UPDATE abView
        SET score = 99
        WHERE bid = 1;
        -- 1 행 이(가) 업데이트되었습니다.
        
        ROLLBACK;
        
         [삭제]
         DELETE FROM abView
         WHERE aid = 1;
         -- 1 행 이(가) 삭제되었습니다.
    
        [뷰 삭제]
        DROP VIEW abview;
        DROP VIEW panview;
        DROP VIEW aView;
        DROP VIEW gogaekView;
        
        SELECT *
        FROM user_views;

    12) WITH CHECK OPTION 뷰에 의해 Access될 수 있는 행(row)만이 삽입, 수정 가능

    CREATE OR REPLACE VIEW bView
    AS
        SELECT bid, aid, score
        FROM testb
        WHERE score >= 90;
        
    SELECT *
    FROM bView;
    
    [수정] bid = 3의 score를 70으로 수정
        UPDATE bView
        SET score = 70
        WHERE bid = 3;
        -- 1 행 이(가) 업데이트되었습니다.
        
        ROLLBACK;
        
     [View에 WITH CHECK OPTION 추가후 확인]
        CREATE OR REPLACE VIEW bView
        AS
            SELECT bid, aid, score
            FROM testb
            WHERE score >= 90
        WITH CHECK OPTION CONSTRAINTS ck_bview;
        
                UPDATE bView
        SET score = 70
        WHERE bid = 3;
        -- View BVIEW이(가) 생성되었습니다.
        -- ORA-01402: view WITH CHECK OPTION where-clause violation
        -- WITH CHECK OPTION 옵션을 추가했기 때문에 90점 미만의 점수로 수정할 수는 없다.
        
        INSERT INTO bView VALUES(5, 4, 100);
        -- 1 행 이(가) 삽입되었습니다.
        
        INSERT INTO bView VALUES(6, 4, 87);
        -- ORA-01402: view WITH CHECK OPTION where-clause violation
        -- 90보다 작은 값은 WITH CHECK OPTION 때문에 추가할 수 없다.
                
    (중간정리) 뷰 ? 가상테이블, 실제테이블 보안성, 편리성 -> SELECT, 심플뷰, 복합뷰, I/U/D 가능
    
--        
* 물리적뷰(MATREIALIZED VIEW) -- 빅데이터 사용
    - 실제 물리적으로 데이터를 저장하고 있는 뷰
    
----------------------------------------------------
4. 시퀀스(Sequence)
    1) 기존의 테이블에 대해 기본키(PK)나 유니크 키(UK)를 사용하여 부가하는 일종의 새로운 컬럼처럼 사용할 수 있는 '일련번호를 매김하기 위한'
      '하나의 컬럼으로 구성된 테이블'과 같다.
      ex) 은행 번호표 뽑는 기계가 시퀀스
  
    2) 시퀀스 생성 형식
    【형식】
        CREATE SEQUENCE 시퀀스명
        [ INCREMENT BY 정수]
        [ START WITH 정수]
        [ MAXVALUE n ? NOMAXVALUE]
        [ MINVALUE n ? NOMINVALUE]
        [ CYCLE ? NOCYCLE]
        [ CACHE n ? NOCACHE];

        <옵션 설명 >
        INCREMENT BY 정수 시퀀스 번호를 정수만큼씩 증가(디폴트=1) 
        START WITH 정수 시작값을 지정(디폴트=1) cycle 옵션을 사용한 경우 다시 값을 생성할 때 minvalue에 설정한 값부터 시작 
        MAXVALUE 정수 증가할 수 있는 최대값 
        NOMAXVALUE(default) 시퀀스의 최대값이 없음을 정의, 오름차순은 10^27까지 커질 수 있고, 내림차순으로 1까지 작아질 수 있음 
        MINVALUE 정수 생성할 수 있는 최소값 
        NOMINVALUE(default) 시퀀스의 최소값이 없음을 정의, 오름차순은 최소 1까지, 내림차순으로 -(10^26)까지 간다. 
        CYCLE 최대 또는 최소값에 도달한 후 값을 다시 생성 
        NOCYCLE(default) 최대 또는 최소값에 도달한 후 값을 다시 재시작할 수 없음 
        CACHE 빠른 access를 위해 시퀀스의 값을 메모리에 저장(기본 20) 
        NOCACHE 어떤 시퀀스값도 캐싱되지 않음 

    - sequence는 currval과 nextval이라는 pseudo 컬럼을 사용하여 값을 리턴한다. 
      ***** 'CURRVAL이 참조되기 전에 NEXTVAL이 먼저 사용되어야 한다.' *****
      이는 pseudo 컬럼의 CURRVAL의 값은 NEXTVAL 컬럼 값을 참조하기 때문이다.
      그러므로 NEXTVAL 컬럼이 사용되지 않은 상태에서 CURRVAL을 사용하면 아무런 값이 없기 때문에 error를 출력한다.
    
    [Pseudo column 사용형식 설명] 
    NEXTVAL     시퀀스명.NEXTVAL    새로 작성된 시퀀스의 '다음 값'을 반환 
    CURRVAL     시퀀스명.CURRVAL    새로 작성된 시퀀스의 '현재 값'을 반환
    
    3) 테스트
        [시퀀스 생성]
        CREATE SEQUENCE seq01
            INCREMENT BY 1 -- 1씩 증가
            START WITH   100 -- 번호표는 1부터 시작
            MAXVALUE     10000 -- 10,000까지만 돈다.
            MINVALUE     1     -- 시작은 1부터 10,000까지 돌고 CYCLE되어서 다시 돌때는 1부터 시작하겠다.
            CYCLE              -- 1 ~ 10,000까지 돌고 다시 반복할 횟수 지정( NOCYCLE하면 반복 X)
            CACHE        20;   -- 미리 번호표를 빼놔서 주는 갯수(메모리에 저장하는 갯수)
        --> Sequence SEQ01이(가) 생성되었습니다.
        
        CREATE SEQUENCE seq02;
        --> Sequence SEQ02이(가) 생성되었습니다.
        
        [생성된 시퀀스 확인]
        SELECT *
        FROM user_sequences;
        SEQUENCE_NAME                   MIN_VALUE  MAX_VALUE INCREMENT_BY C O CACHE_SIZE LAST_NUMBER
        ------------------------------ ---------- ---------- ------------ - - ---------- -----------
        SEQ01                                   1      10000            1 Y N         20         100
        SEQ02                                   1 1.0000E+28            1 N N         20           1
        -- 설정을 안해줘도 기본 값이 들어가져 있따.
        
        [시퀀스 삭제]
        DROP SEQUENCE seq01;
        DROP SEQUENCE seq02;
        
        [기존의 다른 테이블에 사용]
        -- 부서테이블에 새로운 부서 추가해라 -> 부서 추가시 부서번호가 10씩 증가되니 이때 시퀀스 사용하기
        SELECT MAX(deptno) + 10 FROM dept;
        INSERT INTO dept (deptno, dname, loc) VALUES((SELECT MAX(deptno) + 10 FROM dept), 'QC', 'SEOUL');

        ROLLBACK;
        
         시퀀스 생성)
        CREATE SEQUENCE seq_dept
        INCREMENT BY 10
        START WITH 50
        MAXVALUE 90
        MINVALUE 10
        NOCYCLE
        NOCACHE;
        
        INSERT INTO dept (deptno, dname, loc) VALUES(seq_dept.nextval, 'QC', 'SEOUL' || seq_dept.currval);
        
        SELECT * FROM dept;
        
        SELECT seq_dept.currval -- 현재 번호표 값 (하나라도 뽑아야지 확인 가능)
        FROM dual;
        
        DELETE FROM dept
        WHERE deptno = 50;
        -- 시퀀스에서 번호를 뽑아와서 사용한 번호는 다시 가져올 수 없다.
        -- 삭제한 번호를 추가하고 싶다면 시퀀스 재생성 또는 고정값으로 INSERT 하기
        
----------------------------------------------------
5. PL/SQL
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
    ? 블럭 내에 SQL 문을 여러번 사용할 수 있음 *
       DECLARE
            INSERT
            SELECT
            SELECT
            UPDATE
              :
       BEGIN
       EXCEPTION
       END;
    ? 블럭 내에는 CREATEST, LEAST, DECODE, 그룹함수를 사용할 수 없음 *
    --    ? 식별자는 최대 30문자로 작성 
    --    ? 식별자는 테이블 또는 컬럼명과 같을 수 없음 
    --    ? 식별자는 알파벳으로 시작해야 함 
    --    ? 문자와 날짜 타입은 단일 인용부호로 표시함 
    --    ? 주석은 단일 라인인 경우 2개의 대시(--), 여러 라인 경우 /* ... */로 표기

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
       --EXCEPTION
        --WHEN THEN
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
    
--------------------------------------------------------------------------------
<세미프로젝트>
    관리자 로그인 : 설문 등록, 삭제, 수정
    회원 로그인 : 설문 목록 -> 설문 선정 후 투표 + 참가자 설문 정보 보기
    
    관리자
    INSERT 설문 등록
    INSERT 설문 등록
    INSERT 설문 등록
    
    회원 설문 투표
    
    설문 내용 출력
    
        
        


            
