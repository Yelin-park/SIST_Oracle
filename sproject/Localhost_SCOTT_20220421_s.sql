-- [ SCOTT에 접속된 스크립트 파일 ]
--관리자 계정등록
--회원 계정등록
--설문 등록
--설문 내역
--회원이 설문하는거
--설문결과

1) 관리자 등록
INSERT INTO 관리자 VALUES (1, 'admin', '12345', '관리자');   

COMMIT;

SELECT *
FROM 관리자;


2) 회원 등록
INSERT INTO 회원 VALUES (1, 'yelin', '12345', '박예린', '951217-2112248', '010-6777-7428');
INSERT INTO 회원 VALUES (2, 'baek', '12345', '백경환', '940120-1234567', '010-1234-5678');
INSERT INTO 회원 VALUES (3, 'min', '12345', '민윤기', '970418-1544318', '010-5678-2349');
INSERT INTO 회원 VALUES (4, 'kim', '12345', '김민', '970815-1224888', '010-7777-8899');

COMMIT;

SELECT *
FROM 회원;


3-1) 설문등록
INSERT INTO 등록수정 VALUES(1, '대면수업찬반조사', SYSDATE, TRUNC(SYSDATE), '2022.04.25', 2, null, null, 1);

COMMIT;

SELECT *
FROM 등록수정;

3-2) 1번 설문에 대한 항목 등록
INSERT INTO 항목 (설문번호, 항목1, 항목2) VALUES (1, '찬성', '반대');

COMMIT;

SELECT *
FROM 항목;

4) 설문내역
INSERT INTO 설문 VALUES(1, '진행중');

COMMIT;

SELECT *
FROM 설문;

5) 회원이 설문하기

INSERT INTO 참여 VALUES(1, 1, SYSDATE, 1);
INSERT INTO 참여 VALUES(1, 2, SYSDATE, 2);
INSERT INTO 참여 VALUES(1, 3, SYSDATE, 2);
INSERT INTO 참여 VALUES(1, 4, SYSDATE, 2);

COMMIT;

SELECT *
FROM 참여;


6) 결과
INSERT INTO 결과
(
    SELECT 설문번호,
        COUNT(*) 참여자수,
        NVL(COUNT(DECODE(선택항목,1,'O')),0) 결과1,
        NVL(COUNT(DECODE(선택항목,2,'O')),0) 결과2,
        NVL(COUNT(DECODE(선택항목,3,'O')),0) 결과3,
        NVL(COUNT(DECODE(선택항목,4,'O')),0) 결과4,
        NVL(COUNT(DECODE(선택항목,5,'O')),0) 결과5,
        NVL(COUNT(DECODE(선택항목,6,'O')),0) 결과6,
        NVL(COUNT(DECODE(선택항목,7,'O')),0) 결과7,
        NVL(COUNT(DECODE(선택항목,8,'O')),0) 결과8,
        NVL(COUNT(DECODE(선택항목,9,'O')),0) 결과9,
        NVL(COUNT(DECODE(선택항목,10,'O')),0) 결과10
    FROM 참여
    GROUP BY 설문번호
    HAVING 설문번호 = 1
);

COMMIT;

SELECT *
FROM 결과;    

SELECT 설문번호, 참여자수, 결과1, 결과2, 결과3
        , 결과1/참여자수 * 100 || '%' 결과1비율
        , 결과2/참여자수 * 100 || '%' 결과2비율
        , 결과3/참여자수 * 100 || '%' 결과3비율
FROM 결과;



!!!!!!!!!!!!!!!!!!!!!언피봇결과!!!!!!!!!!!!!!!!!!!
SELECT *
FROM(
    SELECT 설문번호, 참여자수, 결과1, 결과2, 결과3
        , 결과1/참여자수 * 100 || '%' 결과1비율
        , 결과2/참여자수 * 100 || '%' 결과2비율
        , 결과3/참여자수 * 100 || '%' 결과3비율
    FROM 결과
    WHERE 설문번호 = 1
)   
UNPIVOT( (투표수, 비율) FOR 항목 IN ( (결과1, 결과1비율 ), (결과2, 결과2비율), (결과3, 결과3비율)   ) );

SELECT *
FROM(
    SELECT 설문번호, 결과1, 결과2, 결과3
        , 결과1/참여자수 * 100 || '%' 결과1비율
        , 결과2/참여자수 * 100 || '%' 결과2비율
        , 결과3/참여자수 * 100 || '%' 결과3비율
    FROM 결과
    WHERE 설문번호 = 3
)   
UNPIVOT( (투표수, 비율) FOR 항목 IN ( (결과1, 결과1비율 ) AS '메이플', (결과2, 결과2비율) AS '로스트아크', (결과3, 결과3비율) AS '바람의나라'  ) );




SELECT 설문번호, 결과, 비율
FROM(
    SELECT 설문번호, 참여자수, 결과1, 결과2
        , 결과1/참여자수 * 100 || '%' 결과1비율 , 결과2/참여자수 * 100 || '%' 결과2비율
    FROM 결과    
)
UNPIVOT( 비율 FOR 결과 IN (결과1비율, 결과2비율 ) );


/*
SELECT *
FROM ( 피벗 대상 쿼리문 )
UNPIVOT ( 컬럼별칭(값) FOR 컬럼별칭(열) IN (피벗열명 AS '별칭', ... )
*/


SELECT t.*
FROM(
    SELECT 설문번호, 참여자수, 결과1, 결과2
        , 결과1/참여자수 * 100 || '%' 결과1비율 , 결과2/참여자수 * 100 || '%' 결과2비율
    FROM 결과     
) t
UNPIVOT(
        (결과, 비율)
        FOR 설문번호
        IN (   (결과1, 결과1비율)
                , (결과2, 결과2비율)
        )
);



SELECT 설문번호, 결과, 비율
FROM(
    SELECT 설문번호, 참여자수, 결과1, 결과2
        , 결과1/참여자수 * 100 || '%' 결과1비율 , 결과2/참여자수 * 100 || '%' 결과2비율
    FROM 결과    
)
UNPIVOT( 비율 FOR 결과 IN (결과1비율, 결과2비율 ) );


/*   
    SELECT 설문번호, 선택항목, COUNT(*) 항목별참여자수
        , (SELECT COUNT(*) FROM 참여 WHERE 설문번호 = 1) 참여자수
    FROM 참여
    GROUP BY 설문번호, 선택항목
    ORDER BY 설문번호, 선택항목;
*/


--------------------------------------
-- 관리자 계정 등록
INSERT INTO 관리자 (관리자번호, 관리자ID, 관리자비밀번호, 관리자이름) 
       VALUES (1, 'admin01', 'a1234567890', 'admin');

DELETE FROM 관리자 WHERE 관리자번호 = 1;

COMMIT;
ROLLBACK;

-- 회원 계정 등록
INSERT INTO 회원 (회원번호, 회원ID, 회원비밀번호, 회원이름, 주민번호, 핸드폰번호)
        VALUES (1, 'id1231', 'pw123', '홍길동', '900101-1234567', '010-1234-5678');
INSERT INTO 회원 (회원번호, 회원ID, 회원비밀번호, 회원이름, 주민번호, 핸드폰번호)
        VALUES (2, 'id1232', 'pw123', '홍길동', '900102-1234567', '010-2234-5678');
INSERT INTO 회원 (회원번호, 회원ID, 회원비밀번호, 회원이름, 주민번호, 핸드폰번호)
        VALUES (3, 'id1233', 'pw123', '홍길동', '900103-1234567', '010-3234-5678');
INSERT INTO 회원(회원번호, 회원ID, 회원비밀번호, 회원이름, 주민번호, 핸드폰번호)
        VALUES (4, 'id1234', 'pw123', '홍길동', '900104-1234567', '010-4234-5678');
INSERT INTO 회원(회원번호, 회원ID, 회원비밀번호, 회원이름, 주민번호, 핸드폰번호)
        VALUES (5, 'id1235', 'pw123', '홍길동', '900105-1234567', '010-5234-5678');
        
DELETE FROM 회원 WHERE 회원번호 = 1;

COMMIT;
ROLLBACK;

-- 설문 등록
INSERT INTO 등록수정 (설문번호, 설문제목, 작성일, 시작일, 종료일, 항목수, 수정일, 삭제일, 관리자번호) 
        VALUES (1, '최고의 게임은?', SYSDATE, SYSDATE+1, SYSDATE+2, 3, null, null, 1); 
INSERT INTO 등록수정 (설문번호, 설문제목, 작성일, 시작일, 종료일, 항목수, 수정일, 삭제일, 관리자번호) 
        VALUES (2, '최고의 게임은?', SYSDATE, SYSDATE-3, SYSDATE-2, 3, null, null, 1); 
INSERT INTO 등록수정 (설문번호, 설문제목, 작성일, 시작일, 종료일, 항목수, 수정일, 삭제일, 관리자번호) 
        VALUES (3, '최고의 게임은?', SYSDATE, SYSDATE-1, SYSDATE+2, 3, null, null, 1); 
-- 항목 등록
INSERT INTO 항목 (설문번호, 항목1, 항목2, 항목3) VALUES(1, '메이플스토리', '로스트아크', '바람의나라');
INSERT INTO 항목 (설문번호, 항목1, 항목2, 항목3) VALUES(2, '메이플스토리', '로스트아크', '바람의나라');
INSERT INTO 항목 (설문번호, 항목1, 항목2, 항목3) VALUES(3, '메이플스토리', '로스트아크', '바람의나라');
--설문 게시판
INSERT INTO 설문 VALUES (1, (SELECT CASE
                                        WHEN SYSDATE < 시작일 THEN '시작전'
                                        WHEN 시작일 < SYSDATE AND SYSDATE < 종료일 THEN '시작전'
                                        ELSE '종료'
                                    END 상태
                                FROM 등록수정
                                WHERE 설문번호 = 1));
INSERT INTO 설문 VALUES (2, (SELECT CASE
                                        WHEN SYSDATE < 시작일 THEN '시작전'
                                        WHEN 시작일 < SYSDATE AND SYSDATE < 종료일 THEN '진행중'
                                        ELSE '종료'
                                    END 상태
                                FROM 등록수정
                                WHERE 설문번호 = 2));
INSERT INTO 설문 VALUES (3, (SELECT CASE
                                        WHEN SYSDATE < 시작일 THEN '시작전'
                                        WHEN 시작일 < SYSDATE AND SYSDATE < 종료일 THEN '진행중'
                                        ELSE '종료'
                                    END 상태
                                FROM 등록수정
                                WHERE 설문번호 = 3));
COMMIT;
ROLLBACK;

-- 설문 게시판 조회

SELECT
    s.설문번호 번호,
    설문제목,
    관리자이름 작성자,
    시작일,
    종료일,
    항목수,
    상태
FROM 설문 s
    JOIN 등록수정 d ON s.설문번호 = d.설문번호
    JOIN 관리자 g ON g.관리자번호 = d.관리자번호
ORDER BY d.설문번호;


-- 설문하기
INSERT INTO 참여 (설문번호, 회원번호, 참여일, 선택항목)
    VALUES (3, 1, SYSDATE, 1);
INSERT INTO 참여 (설문번호, 회원번호, 참여일, 선택항목)
    VALUES (3, 2, SYSDATE, 2);
INSERT INTO 참여 (설문번호, 회원번호, 참여일, 선택항목)
    VALUES (3, 3, SYSDATE, 2);
INSERT INTO 참여 (설문번호, 회원번호, 참여일, 선택항목)
    VALUES (3, 4, SYSDATE, 3);
    
INSERT INTO 참여 (설문번호, 회원번호, 참여일, 선택항목)
    VALUES (1, 5, SYSDATE, 3);

DELETE FROM 참여;

-- 설문 결과 테이블에 담기

INSERT INTO 결과
(
    SELECT 설문번호,
        COUNT(*) 참여자수,
        NVL(COUNT(DECODE(선택항목,1,'O')),0) 결과1,
        NVL(COUNT(DECODE(선택항목,2,'O')),0) 결과2,
        NVL(COUNT(DECODE(선택항목,3,'O')),0) 결과3,
        NVL(COUNT(DECODE(선택항목,4,'O')),0) 결과4,
        NVL(COUNT(DECODE(선택항목,5,'O')),0) 결과5,
        NVL(COUNT(DECODE(선택항목,6,'O')),0) 결과6,
        NVL(COUNT(DECODE(선택항목,7,'O')),0) 결과7,
        NVL(COUNT(DECODE(선택항목,8,'O')),0) 결과8,
        NVL(COUNT(DECODE(선택항목,9,'O')),0) 결과9,
        NVL(COUNT(DECODE(선택항목,10,'O')),0) 결과10
    FROM 참여
    GROUP BY 설문번호
    HAVING 설문번호 = 3
);

-- 설문 결과 보이기


SELECT
    항목1 항목,
    결과1 득표수,
    ROUND(결과1/참여자수*100) || '%' 득표율
FROM 결과 r
    JOIN 항목 h ON r.설문번호 = h.설문번호 
WHERE r.설문번호 = 3;


(SELECT 항목 FROM (SELECT * FROM 항목 a JOIN 등록수정 b ON a.설문번호 = b.설문번호 WHERE a.설문번호 =1)
    UNPIVOT (항목 FOR 항목번호 IN ( 항목1, 항목2, 항목3, 항목4, 항목5, 항목6, 항목7, 항목8, 항목9, 항목10)) WHERE ROWNUM <= 항목수 ) 항목,
    (SELECT 득표 FROM (SELECT * FROM 결과 a JOIN 등록수정 b ON a.설문번호 = b.설문번호 WHERE a.설문번호 =1)
    UNPIVOT (득표 FOR 득표번호 IN ( 결과1, 결과2, 결과3, 결과4, 결과5, 결과6, 결과7, 결과8, 결과9, 결과10)) WHERE ROWNUM <= 항목수 ) 득표,
    (SELECT 득표 /참여자수 FROM (SELECT * FROM 결과 a JOIN 등록수정 b ON a.설문번호 = b.설문번호 WHERE a.설문번호 =1)
    UNPIVOT (득표 FOR 득표번호 IN ( 결과1, 결과2, 결과3, 결과4, 결과5, 결과6, 결과7, 결과8, 결과9, 결과10)) WHERE ROWNUM <= 항목수 ) 비율;




            
