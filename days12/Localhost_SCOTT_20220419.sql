-- [ SCOTT에 접속된 스크립트 파일 ]
---- 복습문제 ----

1. 이번 달 1일 부터 마지막 날까지 아래와 같이 출력 
     ( LEVEL 의사컬럼 사용 )
실행결과) 
  날짜	       요일    주차(IW)
21/11/01	월	44
21/11/02	화	44
21/11/03	수	44
21/11/04	목	44
21/11/05	금	44
21/11/06	토	44 
 :
21/11/29	월	48
21/11/30	화	48


SELECT dates, TO_CHAR(dates, 'DY'), TO_CHAR(dates, 'IW')
FROM(
    SELECT TO_DATE('202111', 'YYYYMM') + LEVEL - 1 dates
    FROM dual
    CONNECT BY LEVEL <= EXTRACT( DAY FROM LAST_DAY( TO_DATE('202111', 'YYYYMM') ) )
) t;
 

 2-1.  아래와 같이 계층 구조로 출력하는 쿼리 작성  ( 계층구조 질의문)
실행결과)
NAME		LEVEL   empno	mgr
------------------------------------
KING		1	7839	null
   JONES	2	7566	7839         
      FORD	3	7902	7566
         SMITH	4	7369	7902     
   BLAKE	2	7698	7839
      ALLEN	3	7499	7698
      WARD	3	7521	7698
      MARTIN	3	7654	7698
      TURNER	3	7844	7698
      JAMES	3	7900	7698
   CLARK	2	7782	7839
      MILLER	3	7934	7782
    
SELECT LPAD(' ', 3*LEVEL-3) || ename
    , LEVEL, empno, mgr    
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;


2-2. 위의 JONES 계층구조 제거하는 쿼리 작성. 
실행결과)
NAME		LEVEL   empno	mgr
------------------------------------
KING		1	7839	null
   BLAKE	2	7698	7839
      ALLEN	3	7499	7698
      WARD	3	7521	7698
      MARTIN	3	7654	7698
      TURNER	3	7844	7698
      JAMES	3	7900	7698
   CLARK	2	7782	7839
      MILLER	3	7934	7782


SELECT LPAD(' ', 3*LEVEL-3) || ename
    , LEVEL, empno, mgr 
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr AND ename != 'JONES';



3.  MERGE : 병합 , 한쪽 테이블의 정보를 다른 테이블에 병합(추가)

CREATE TABLE tbl_merge1
(
   id      number Primary key
   , name  varchar2(20)
   , pay  number
   , sudang number
);

CREATE TABLE tbl_merge2
(
   id      number Primary key 
   , sudang number
);

INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (1, 'a', 100, 10);
INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (2, 'b', 150, 20);
INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (3, 'c', 130, 0);
    
INSERT INTO tbl_merge2 (id, sudang) VALUES (2,5);
INSERT INTO tbl_merge2 (id, sudang) VALUES (3,10);
INSERT INTO tbl_merge2 (id, sudang) VALUES (4,20);



SELECT * FROM tbl_merge1;
1	a	100	10
2	b	150	20
3	c	130	0

SELECT * FROM tbl_merge2;
2	5
3	10
4	20

COMMIT;

MERGE INTO tbl_merge1 m1
USING (SELECT id, sudang FROM tbl_merge2) m2
ON (m2.id = m1.id)
WHEN MATCHED THEN
    UPDATE SET m1.sudang = m1.sudang + m2.sudang
WHEN NOT MATCHED THEN
    INSERT (m1.id, m1.sudang) VALUES (m2.id, m2.sudang);


4. 제약조건( Contratrint ) 
  ㄱ. 제약조건이란 ?    
       데이터 무결성을 위해서 테이블에 레코드를 추가, 수정, 삭제할 때 적용되는 규칙
       
  ㄴ. 제약조건을 설정하는 2가지 방법에 대해 설명하세요.
    CREATE TABLE 테이블 생성할 때
    ALTER TABLE 테이블 수정할 때
  
  ㄷ. 제약조건의 5가지 종류 
      PRIMARY KEY 고유키(PK)
      FOREIGN KEY 참조키(FK)
      NOT NULL NN
      UNIQUE 유일성(UK)
      CHECK C
        
  ㄹ. emp 테이블의 제약조건 확인 쿼리 작성 
     SELECT *
     FROM user_constraints
     WHERE table_name = UPPER('emp');
     
  ㅁ. 데이터 무결성 종류 및 설명
  개체 무결성 - PK로 설정한 컬럼에 중복된 값 허용 X
  참조 무결성 - 부모 테이블 자식 테이블이 참조되어있는경우 부모테이블을 삭제할 수 X
  도메인 무결성 - 컬럼에서 허용 가능한 값의 범위를 지정하기 위한 제약조건이다.
  

5. 아래 테이블 생성 쿼리 에서 [컬럼 레벨] 방식으로 
   ㄱ. deptno 를 PK 로 설정
   ㄴ. dname을 NN 로 설정
CREATE TABLE tbl_dept
(
    DEPTNO  NUMBER(2) CONSTRAINTS pk_tbldept_deptno PRIMARY KEY   
   , DNAME VARCHAR2(14) NOT NULL  
   , LOC   VARCHAR2(13)      
);

6. 아래 테이블 생성 쿼리 에서 [테이블 레벨] 방식으로 
   ㄱ. deptno 를 PK 로 설정
   ㄴ. dname을 NN 로 설정     
   
CREATE TABLE tbl_dept
(
    DEPTNO  NUMBER(2) 
   , DNAME VARCHAR2(14) 
   , LOC   VARCHAR2(13)
   , CONSTRAINTS pk_tbldept_deptno PRIMARY KEY(deptno)
   , CONSTRAINTS nn_tbldept_dname NOT NULL(dname)

);

DROP TABLE tbl_dept;

DESC tbl_dept;

7. tbl_dept 테이블을 생성 후 [모든 제약조건 제거]하는 쿼리 작성  
ALTER TABLE tbl_dept
DROP CONSTRAINTS pk_tbldept_deptno;

ALTER TABLE tbl_dept
DROP NOT NULL;


8. ALTER TABLE 문을 사용해서 PK 제약조건 설정. 

ALTER TABLE tbl_dept
ADD CONSTRAINTS pk_tbldept_enpno PRIMARY KEY(empno);


9. UK 제약 조건 삭제 쿼리 작성
   예) tbl_member테이블에  tel 컬럼이 UK_MEMBER_TEL 이란 제약조건명으로
     UNIQUE 제약 조건이 설정된 경우 
     
     ALTER TABLE tbl_member
     DROP CONSTRAINTS UK_MEMBER_TEL;

10. FK 제약 조건 설정 시 아래 옵션에 대해 설명하세요
   CONSTRAINT FK_TBLEMP_DEPTNO FOREIGN KEY ( deptno ) 
                                REFERENCES tbl_dept(deptno )
                                
   ㄱ. ON DELETE CASCADE 
   부모 테이블에서 삭제하면 자식 테이블에서도 삭제
   
   ㄴ. ON DELETE SET NULL 
   부모테이블에서 삭제하면 자식테이블에 null로 바뀜
   
--------------------------------------------------------------------------------------------------
[새로운 개념!!!]
1. [ JOIN(조인) ]

1) 책(book) 테이블 생성
CREATE TABLE book(
       b_id     VARCHAR2(10)  NOT NULL PRIMARY KEY -- 책ID
      ,title      VARCHAR2(100) NOT NULL -- 책제목
      ,c_name  VARCHAR2(100) NOT NULL -- 지역명
);
-- Table BOOK이(가) 생성되었습니다.

2) 책의 단가(danga) 테이블 생성
CREATE TABLE danga(
      b_id  VARCHAR2(10)  NOT NULL -- 책ID
      ,price  NUMBER(7) NOT NULL -- 책가격
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)  -- 고유키이면서
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id) -- 참조키(외래키)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- ORA-00942: table or view does not exist
-- 부모 테이블인 book 테이블 생성을 하지 않아서 에러 발생
-- Table DANGA이(가) 생성되었습니다.

3) 고객(gogaek) 테이블 생성 -- 서점
CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY -- 고객ID
      ,g_name   VARCHAR2(20) NOT NULL -- 고객명
      ,g_tel      VARCHAR2(20) -- 고객연락처
);
-- Table GOGAEK이(가) 생성되었습니다.

4) 판매(panmai) 테이블
CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY -- 판매번호(순서) 보통 seq라고 많이 함
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID -- 고객테이블의 고객ID가 FK
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID -- 책테이블의 책ID FK
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE -- 판매날짜
      ,p_su       NUMBER(5)  NOT NULL -- 판매수량
);
-- Table PANMAI이(가) 생성되었습니다.

5) 저자 테이블
CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY -- 저자ID
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID -- 책ID 참조
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL -- 저자명
);
-- Table AU_BOOK이(가) 생성되었습니다.

INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '데이터베이스', '서울');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '데이터베이스', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '운영체제', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '운영체제', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '워드', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '엑셀', '대구');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '파워포인트', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '엑세스', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '엑세스', '서울');

INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

-- 출판사가 서점(고객)에게 판매
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '우리서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '도시서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '지구서점', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '서울서점', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '수도서점', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '강남서점', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '강북서점', '777-7777');

INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '저팔개');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '손오공');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '사오정');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '김유신');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '유관순');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '김하늘');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '심심해');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '허첨');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '이한나');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '정말자');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '이영애');

COMMIT;

SELECT * FROM book;
SELECT * FROM danga;
SELECT * FROM gogaek;
SELECT * FROM panmai;
SELECT * FROM au_book;

------
1. [ EQUI JOIN(== Natural JOIN) ]
    - 두 개 이상의 테이블에 [관계되는 컬럼들의 값이 일치]하는 경우에 사용되는 조인

문제1) 책 ID, 책 제목, 출판사(c_name), 책단가 컬럼을 조회(출력)
    BOOK : b_id, title, c_name
    DANGA : price
    질문1) price 컬럼을 book 테이블에 추가를 해도 문제가 되지 않을 거 같은데 단가 테이블을 왜 따로 만들었을까?
         단가가 바뀔 수 있기 때문에
         
    book(PK)             danga
    b_1  1번   <- == ->   b_1(FK, PK) price
    > 책의 1번에 해당하는 책 가격을 찾아온다

ㄱ) book, danga 객체 사용
    SELECT book.b_id, title, c_name, price
    FROM book, danga
    WHERE book.b_id = danga.b_id; -- 비교연산자(=) 사용했기에 EQUI JOIN
    
ㄴ) book b, danga d 별칭 사용
    SELECT b.b_id, title, c_name, price
    FROM book b, danga d
    WHERE b.b_id = d.b_id;

ㄷ) book b, danga d ***
    SELECT b.b_id, b.title, b.c_name, d.price
    FROM book b, danga d
    WHERE b.b_id = d.b_id;

ㄹ) JOIN ~ ON 구문 사용 ***
    SELECT b.b_id, b.title, b.c_name, d.price
    FROM book b JOIN danga d ON b.b_id = d.b_id; 
    
ㅁ) USING 절 사용 -- 사용을 잘 안함
    SELECT b_id, title, c_name, price
    FROM book JOIN danga USING(b_id);

ㅂ) NATURAL JOIN 구문 사용 -- 사용을 잘 안함
    SELECT b_id, title, c_name, price
    FROM book NATURAL JOIN danga;

--    
문제2) KING 사원의 부서를 확인 후 null로 수정

SELECT *
FROM emp
WHERE ename = 'KING';

UPDATE emp
SET deptno = null
WHERE empno = 7839;

COMMIT;
<변경전 - 변경후>
deptno = 10 -> null

--
문제3) dept, emp를 조인해서
    empno, deptno, dname, ename, hiredate 컬럼 조회

ㄱ) JOIN ~ ON 구문
SELECT empno, e.deptno, dname, ename, hiredate
FROM emp e JOIN dept d ON e.deptno = d.deptno;

ㄴ) USING 절 사용
SELECT empno, deptno, dname, ename, hiredate
FROM emp JOIN dept USING (deptno);

ㄷ) 별칭 사용
SELECT empno, e.deptno, dname, ename, hiredate
FROM emp e, dept d
WHERE e.deptno = d.deptno;

문제점) KING 사원은 출력되지 않는다. -> EQUI JOIN이기 때문에 발생

--
문제4) 책ID, 책제목, 판매수량, 단가, 서점명(고객), 판매금액(판매수량 * 단가) 조회

풀이1) 별칭 사용
SELECT b.b_id, title, p_su, price, g_name, p_su * price 판매금액
FROM book b, panmai p, danga d, gogaek g
WHERE b.b_id = p.b_id AND b.b_id = d.b_id AND p.g_id = g.g_id;

풀이2) JOIN ON 구문 사용
SELECT b.b_id, title, p_su, price, g_name, p_su * price 판매금액
FROM book b JOIN panmai p ON b.b_id = p.b_id
            JOIN danga d ON b.b_id = d.b_id
            JOIN gogaek g ON p.g_id = g.g_id;

--            
문제5) 출판된 책들이 각각 총 몇권이 판매되었는지 조회
        책ID, 책제목, 총판매권수, 단가 컬럼 출력

SELECT b.b_id, title, SUM(p_su), price
FROM book b JOIN panmai p ON b.b_id = p.b_id
            JOIN danga d ON b.b_id = d.b_id
GROUP BY b.b_id, title, price
ORDER BY b.b_id;
-- ORA-00979: not a GROUP BY expression

상관서브쿼리로 풀어보기)
SELECT b.b_id, title, SUM(SELECT p_su FROM panmai WHERE b.b_id = panmai.b_id), price
FROM book b JOIN panmai p ON b.b_id = p.b_id
            JOIN danga d ON b.b_id = d.b_id
GROUP BY b.b_id
ORDER BY b.b_id;

--
문제6) 각각의 책이 전체 판매량의 몇 퍼센트에 해당되는지 출력

SELECT b.b_id
    , title, price
    , SUM(p_su) bid_qty
    , (SELECT SUM(p_su) FROM panmai) total_qty
    , ROUND(SUM(p_su) / (SELECT SUM(p_su) FROM panmai) * 100 , 2) per
FROM panmai p JOIN book b ON p.b_id = b.b_id
              JOIN danga d ON b.b_id = d.b_id
GROUP BY b.b_id, title, price
ORDER BY per DESC;


내가 푼 것)
SELECT t.*, ROUND(각각의책 / (SELECT SUM(p_su) FROm panmai) * 100, 2) 판매퍼센트
    FROM(
        SELECT b.b_id, title, SUM(p_su) 각각의책 , price
        FROM book b JOIN panmai p ON b.b_id = p.b_id
                    JOIN danga d ON b.b_id = d.b_id
        GROUP BY b.b_id, title, price
) t;

+ 문제) 상위 n% 출력해라

--
문제7) book 테이블에서 판매가 된 적이 없는/있는 책들의 정보를 조회 --> OUTER JOIN을 사용해서 풀어도 된다. 아직 안배움
        b_id, title, price 컬럼 출력
        
판매된 적이 있는 책)      
    풀이1)
    SELECT DISTINCT b.b_id, title, price
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON b.b_id = p.b_id;       

    풀이2)
    SELECT DISTINCT b.b_id, title, price
    FROM book b JOIN danga d ON b.b_id = d.b_id
    WHERE b.b_id IN(SELECT DISTINCT b_id FROM panmai);
    
    풀이3) 별로 좋은 코딩 X
    WITH a AS(
        SELECT DISTINCT b_id
        FROM panmai
    ),
    b AS(
        SELECT b.b_id, title, price
        FROM book b JOIN danga d ON b.b_id = d.b_id
    )
    SELECT b.b_id, title, price
    FROM a JOIN b ON a.b_id = b.b_id;   
    
    풀이4)
    SELECT b.b_id, title, price
    FROM book b JOIN ( SELECT DISTINCT b_id FROM panmai) p ON b.b_id = p.b_id
                JOIN danga d ON b.b_id = d.b_id;
    
판매된 적이 없는 책)
    SELECT DISTINCT b.b_id, title, price
    FROM book b JOIN danga d ON b.b_id = d.b_id
    WHERE b.b_id NOT IN(SELECT DISTINCT b_id FROM panmai); 

--
문제8) 가장 많이 판매가 된 책의 정보를 조회

풀이1) TOP-N 방식, ROWNUM 의사컬럼 사용
    SELECT t.*, ROWNUM
    FROM(   
        SELECT b.b_id, title, price, SUM(p_su) qty
        FROM book b JOIN danga d ON b.b_id = d.b_id
                    JOIN panmai p ON b.b_id = p.b_id
        GROUP BY b.b_id, title, price
        ORDER BY qty DESC
    ) t
    WHERE ROWNUM = 1; 


풀이2) RANK 함수 사용

SELECT t.*
FROM(
        SELECT b.b_id, title, price, SUM(p_su) qty
            , RANK() OVER(ORDER BY SUM(p_su) DESC ) qty_rank
        FROM book b JOIN danga d ON b.b_id = d.b_id
                    JOIN panmai p ON b.b_id = p.b_id
        GROUP BY b.b_id, title, price
        ORDER BY qty DESC
) t
WHERE qty_rank = 1;

문제9) 가장 적게 판매가 된 책의 정보를 조회 -- OUTER JOIN 필요

아래와 같이 작성한 것은 판매된 책 중에 가장 적게 판매가 된 책들을 가져오는 것
SELECT t.*
FROM(
        SELECT b.b_id, title, price, SUM(p_su) qty
            , RANK() OVER(ORDER BY SUM(p_su) DESC ) qty_rank
        FROM book b JOIN danga d ON b.b_id = d.b_id
                    JOIN panmai p ON b.b_id = p.b_id
        GROUP BY b.b_id, title, price
        ORDER BY qty DESC
) t
WHERE qty_rank = 1;

--
문제10) 총 판매권수가 10권 이상 판매된 책의 정보 조회
       책 ID, 제목, 가격, 총판매량 컬럼 조회
      
SELECT b.b_id, title, price, SUM(p_su) qty
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
GROUP BY b.b_id, title, price
HAVING SUM(p_su) >= 10;

---------------
2. [ NON-EQUI JOIN ]
    - 관계되는 컬럼이 정확히 일치하지 않는 경우에 사용되는 JOIN의 형태이다.
    - WHERE 절에 비교연산자(=) 사용 X, BETWEEN ... AND ... 연산자를 사용한다.
    - 오라클에서는 ON 절을 이용하여 NON-EQUI JOIN과 동일한 역할을 한다.

    SELECT empno, sal, losal || '~' || hisal, grade
    FROM emp e JOIN salgrade s ON e.sal BETWEEN losal AND hisal;

----------------
+ (기능) 산술연산자 중에 덧셈연산자
  (항갯수) 이항 연산자 3 + 5

? (기능) 조건연산자
  (항갯수) 삼항 연산자 

3. INNER JOIN 과 OUTER JOIN
    1) INNER JOIN == EQUI JOIN과 결과 동일
     - 둘 이상의 테이블에서 JOIN 조건을 만족하는 행만 반환
     - 기본이 INNER JOIN
     
    SELECT b.b_id, title, price, SUM(p_su) qty
    FROM book b INNER JOIN danga d ON b.b_id = d.b_id
                INNER JOIN panmai p ON b.b_id = p.b_id
    GROUP BY b.b_id, title, price
    HAVING SUM(p_su) >= 10;
    
    2) OUTER JOIN ***
    - JOIN 조건을 만족하지 않는 행을 보기 위한 추가적인 join의 형태이다.
    - 일반적인 JOIN으로 얻을 수 없는 데이터를 구하고 싶을 때 사용하며, '(+)' 연산자를 사용한다.
    - FULL OUTER JOIN은 이전 버전에서 UNION을 이용한 연산과 동일한 결과를 얻는다.
    - OUTER JOIN 3가지 종류
        ㄱ. LEFT [OUTER] JOIN - 왼쪽 테이블은 무조건 나오게 하겠다
        ㄴ. RIGHT [OUTER] JOIN - 오른쪽 테이블은 무조건 나오게 하겠다.
        ㄷ. FULL [OUTER] JOIN - 모든 테이블이 무조건 나오게 하겠다.
    
    예) emp 테이블 KING의 deptno = null
        dept 테이블은 deptno가 10/20/30/40만 있음
        따라서 king이 나오지 않음
        -> OUTER JOIN을 사용하면 나올 수 있다.
    
    SELECT empno, ename, NVL(dname, '부서없음')
    FROM emp e LEFT JOIN dept d ON e.deptno = d.deptno;
    
    SELECT empno, ename, NVL(dname, '부서없음')
    FROM dept d RIGHT JOIN emp e ON e.deptno = d.deptno;

    -- (+) 연산자를 사용하려면 해당하는 테이블의 컬럼에 붙여야 한다.
    SELECT empno, ename, NVL(dname, '부서없음')
    FROM emp e JOIN dept d ON e.deptno = d.deptno(+);
    
    SELECT empno, ename, NVL(dname, '부서없음')
    FROM emp e JOIN dept d ON d.deptno(+) = e.deptno;
    
    SELECT empno, ename, NVL(dname, '부서없음')
    FROM dept d JOIN emp e ON e.deptno = d.deptno(+);
    
    SELECT empno, ename, NVL(dname, '부서없음')
    FROM dept d JOIN emp e ON d.deptno(+) = e.deptno;
    
    -- FULL OUTER JOIN
    SELECT empno, ename, NVL(dname, '부서없음')
    FROM emp e FULL JOIN dept d ON e.deptno = d.deptno;

--
문제1) 각 부서별 사원수 조회(출력)
      10 2
      20 3
      30 6
      40 0

SELECT d.deptno, COUNT(e.deptno) 부서원수 -- COUNT(*)는 NULL 포함이기 때문에 X
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno;

      10 2
      20 3
      30 6
      40 0
      부서없음 0

SELECT d.deptno, COUNT(e.ename) 부서원수 -- COUNT(*)는 NULL 포함이기 때문에 X
FROM emp e FULL JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno;    


OUTER JOIN 사용-              
판매된 적이 없는 책) 

    SELECT b.b_id, title, p_su, price
    FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id -- LEFT OUTER JOIN
                JOIN danga d ON b.b_id = d.b_id -- INNER JOIN == EQUI JOIN
    WHERE p_su IS NULL;
    
가장 적게 판매가 된 책의 정보를 조회
SELECT t.b_id, t.title, t.p_su, t.price
FROM(
    SELECT b.b_id, title, p_su, price
            , RANK() OVER(ORDER BY NVL(p_su, 0)) rn
    FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
                     JOIN danga d ON b.b_id = d.b_id
) t
WHERE t.rn = 1;
    
------------------      
4. 나머지 JOIN 3가지
? CROSS JOIN :
Cartesian Product를 수행한 결과와 같다.
이 cartesian product는 매우 많은 행을 생성하므로 "극히 드물게 사용"된다.
두 테이블에 각각 100개의 행을 가지고 있다면, 10000개의 cartesian product 결과가 생성되기 때문이다.

12 * 4 = 48 가지수가 다 나오게 된다.
SELECT e.*, d.*
FROM emp e, dept d;

? ANTIJOIN : 서브쿼리 + NOT IN 연산자 사용
서브쿼리한 결과 속에 해당 컬럼이 존재하지 않는 경우로 NOT IN을 사용함

? SEMIJOIN : 서브쿼리 + EXISTS 연산자 사용
서브쿼리한 결과 속에 해당 컬럼이 존재하는 경우로 EXISTS을 사용함


        
        
        
        
        
        
        
        
        
        
        
        
        
        
