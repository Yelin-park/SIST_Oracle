-- [ HR에 접속된 스크립트 파일 ]

-- SCOTT 계정으로 접속해서 문제푼 것들

1. book, panmai, danga, gogaek 조인하여 다음을 출력 한다.
  -- 책이름(title) 고객명(g_name) 년도(p_date) 수량(p_su) 단가(price) 금액(p_su*price)
  -- 단, 년도 내림차순 출력

TITLE            G_NAME               P_DATE         P_SU      PRICE         금액
---------------- -------------------- -------- ---------- ---------- ----------
운영체제         강남서점             21/11/03          5        450       2250
엑셀             서울서점             21/11/03         31        321       9951
데이터베이스     강북서점             21/11/03         26        300       7800
데이터베이스     강남서점             21/11/03         17        300       5100
엑세스           강남서점             21/11/03         21        510      10710
운영체제         우리서점             21/11/03         13        450       5850
데이터베이스     우리서점             00/10/10         10        300       3000
데이터베이스     강북서점             00/10/10         15        500       7500
워드             서울서점             00/07/07          5        320       1600
데이터베이스     도시서점             00/03/04         20        300       6000

SELECT title, g_name, p_date, p_su, price, p_su * price 금액
FROM book b JOIN panmai p ON b.b_id = p.b_id
            JOIN danga d ON b.b_id = d.b_id
            JOIN gogaek g ON p.g_id = g.g_id
ORDER BY p_date DESC;

2. book 테이블, panmai 테이블, gogaek 테이블을 b_id 필드와 g_id 필드를 기준으로 조인하여 
다음의 필드 출력 한다. 단, book 테이블의 모든 행은 출력 되도록 한다.(OUTER 조인)
( 판매가 안된 책 정보도 출력 )  

SELECT b.b_id, title, g.g_id, g_name, p_su
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
            LEFT JOIN gogaek g ON p.g_id = g.g_id;

책ID       제목                     G_ID G_NAME                     판매수량
---------- ------------------- ---------- -------------------- ----------
b-1        운영체제                     1 우리서점                     13
a-1        데이터베이스                 1 우리서점                     10
a-1        데이터베이스                 2 도시서점                     20
d-1        엑셀                         4 서울서점                     31
c-1        워드                         4 서울서점                      5
b-1        운영체제                     6 강남서점                      5
a-1        데이터베이스                 6 강남서점                     17
f-1        엑세스                       6 강남서점                     21
a-2        데이터베이스                 7 강북서점                     15
a-1        데이터베이스                 7 강북서점                     26
e-1        파워포인트                                                     
f-2        엑세스                                                        
b-2        운영체제                                                      


3. 년도, 월별 판매 현황 구하기

SELECT TO_CHAR(p_date, 'YYYY') 년도
        , TO_CHAR(p_date, 'MM') 월
        , SUM(p_su * price) 판매금액
FROM panmai p JOIN danga d ON p.b_id = d.b_id
GROUP BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM')
ORDER BY 년도, 월;

SELECT *
FROM panmai;

년도   월        판매금액( p_su * price )
---- -- ----------
2000 03       6000
2000 07       1600
2000 10      10500
2021 11      41661

 

4. 서점별 년도별 판매현황 구하기 

SELECT TO_CHAR(p_date, 'YYYY') 년도
        , g.g_id 서점ID, g_name 서점명
        , SUM(p_su * price) 판매금액
FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
              JOIN danga d ON p.b_id = d.b_id
GROUP BY TO_CHAR(p_date, 'YYYY'), g.g_id, g_name
ORDER BY TO_CHAR(p_date, 'YYYY');

년도         서점ID 서점명                판매금액
---- ---------- -------------------- ----------
2000          7 강북서점                   7500
2000          2 도시서점                   6000
2000          4 서울서점                   1600
2000          1 우리서점                   3000
2021          6 강남서점                  18060
2021          7 강북서점                   7800
2021          4 서울서점                   9951
2021          1 우리서점                   5850

8개 행이 선택되었습니다. 
 

5. 올해 가장 판매가 많은 책(수량을 기준으로) 

책ID       제목       권수
---------- ----------------
a-1        데이터베이스  43
 
-- TOP-N 방식, RANK() 함수

SELECT t.책ID, t.제목, t.권수
FROM(
    SELECT b.b_id 책ID, title 제목, SUM(NVL(p_su, 0)) 권수
        , RANK() OVER(ORDER BY SUM(NVL(p_su, 0)) DESC) rn
    FROM book b FULL JOIN panmai p ON b.b_id = p.b_id
    WHERE TO_CHAR(p_date, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')
    GROUP BY b.b_id, title
) t
WHERE rn = 1;


SELECT t.책ID, t.제목, t.권수
FROM(
    SELECT b.b_id 책ID, title 제목, SUM(NVL(p_su, 0)) 권수
    FROM book b FULL JOIN panmai p ON b.b_id = p.b_id
    WHERE TO_CHAR(p_date, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')
    GROUP BY b.b_id, title
    ORDER BY 권수 DESC
) t
WHERE ROWNUM = 1;


6. 서점별 판매현황 구하기

서점코드  서점명  판매금액합  비율(소수점 둘째반올림)  
---------- -------------------------- ----------------
7	    강북서점	15300		26%
4	    서울서점	11551		19%
2	    도시서점	6000		10%
6	    강남서점	18060		30%
1	    우리서점	8850		15%

SELECT t.서점코드, t.서점명, t.판매금액합, ROUND( t.판매금액합 / t.전체판매금액 * 100) || '%' 비율
FROM(
    SELECT g.g_id 서점코드, g_name 서점명, SUM(p_su * price) 판매금액합
        , (SELECT SUM(p_su * price) FROM panmai p JOIN danga d ON p.b_id = d.b_id) 전체판매금액
    FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
                  JOIN danga d ON p.b_id = d.b_id
    GROUP BY g.g_id, g_name
) t;


