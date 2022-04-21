-- [ HR�� ���ӵ� ��ũ��Ʈ ���� ]

-- SCOTT �������� �����ؼ� ����Ǭ �͵�

1. book, panmai, danga, gogaek �����Ͽ� ������ ��� �Ѵ�.
  -- å�̸�(title) ����(g_name) �⵵(p_date) ����(p_su) �ܰ�(price) �ݾ�(p_su*price)
  -- ��, �⵵ �������� ���

TITLE            G_NAME               P_DATE         P_SU      PRICE         �ݾ�
---------------- -------------------- -------- ---------- ---------- ----------
�ü��         ��������             21/11/03          5        450       2250
����             ���Ｍ��             21/11/03         31        321       9951
�����ͺ��̽�     ���ϼ���             21/11/03         26        300       7800
�����ͺ��̽�     ��������             21/11/03         17        300       5100
������           ��������             21/11/03         21        510      10710
�ü��         �츮����             21/11/03         13        450       5850
�����ͺ��̽�     �츮����             00/10/10         10        300       3000
�����ͺ��̽�     ���ϼ���             00/10/10         15        500       7500
����             ���Ｍ��             00/07/07          5        320       1600
�����ͺ��̽�     ���ü���             00/03/04         20        300       6000

SELECT title, g_name, p_date, p_su, price, p_su * price �ݾ�
FROM book b JOIN panmai p ON b.b_id = p.b_id
            JOIN danga d ON b.b_id = d.b_id
            JOIN gogaek g ON p.g_id = g.g_id
ORDER BY p_date DESC;

2. book ���̺�, panmai ���̺�, gogaek ���̺��� b_id �ʵ�� g_id �ʵ带 �������� �����Ͽ� 
������ �ʵ� ��� �Ѵ�. ��, book ���̺��� ��� ���� ��� �ǵ��� �Ѵ�.(OUTER ����)
( �ǸŰ� �ȵ� å ������ ��� )  

SELECT b.b_id, title, g.g_id, g_name, p_su
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
            LEFT JOIN gogaek g ON p.g_id = g.g_id;

åID       ����                     G_ID G_NAME                     �Ǹż���
---------- ------------------- ---------- -------------------- ----------
b-1        �ü��                     1 �츮����                     13
a-1        �����ͺ��̽�                 1 �츮����                     10
a-1        �����ͺ��̽�                 2 ���ü���                     20
d-1        ����                         4 ���Ｍ��                     31
c-1        ����                         4 ���Ｍ��                      5
b-1        �ü��                     6 ��������                      5
a-1        �����ͺ��̽�                 6 ��������                     17
f-1        ������                       6 ��������                     21
a-2        �����ͺ��̽�                 7 ���ϼ���                     15
a-1        �����ͺ��̽�                 7 ���ϼ���                     26
e-1        �Ŀ�����Ʈ                                                     
f-2        ������                                                        
b-2        �ü��                                                      


3. �⵵, ���� �Ǹ� ��Ȳ ���ϱ�

SELECT TO_CHAR(p_date, 'YYYY') �⵵
        , TO_CHAR(p_date, 'MM') ��
        , SUM(p_su * price) �Ǹűݾ�
FROM panmai p JOIN danga d ON p.b_id = d.b_id
GROUP BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM')
ORDER BY �⵵, ��;

SELECT *
FROM panmai;

�⵵   ��        �Ǹűݾ�( p_su * price )
---- -- ----------
2000 03       6000
2000 07       1600
2000 10      10500
2021 11      41661

 

4. ������ �⵵�� �Ǹ���Ȳ ���ϱ� 

SELECT TO_CHAR(p_date, 'YYYY') �⵵
        , g.g_id ����ID, g_name ������
        , SUM(p_su * price) �Ǹűݾ�
FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
              JOIN danga d ON p.b_id = d.b_id
GROUP BY TO_CHAR(p_date, 'YYYY'), g.g_id, g_name
ORDER BY TO_CHAR(p_date, 'YYYY');

�⵵         ����ID ������                �Ǹűݾ�
---- ---------- -------------------- ----------
2000          7 ���ϼ���                   7500
2000          2 ���ü���                   6000
2000          4 ���Ｍ��                   1600
2000          1 �츮����                   3000
2021          6 ��������                  18060
2021          7 ���ϼ���                   7800
2021          4 ���Ｍ��                   9951
2021          1 �츮����                   5850

8�� ���� ���õǾ����ϴ�. 
 

5. ���� ���� �ǸŰ� ���� å(������ ��������) 

åID       ����       �Ǽ�
---------- ----------------
a-1        �����ͺ��̽�  43
 
-- TOP-N ���, RANK() �Լ�

SELECT t.åID, t.����, t.�Ǽ�
FROM(
    SELECT b.b_id åID, title ����, SUM(NVL(p_su, 0)) �Ǽ�
        , RANK() OVER(ORDER BY SUM(NVL(p_su, 0)) DESC) rn
    FROM book b FULL JOIN panmai p ON b.b_id = p.b_id
    WHERE TO_CHAR(p_date, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')
    GROUP BY b.b_id, title
) t
WHERE rn = 1;


SELECT t.åID, t.����, t.�Ǽ�
FROM(
    SELECT b.b_id åID, title ����, SUM(NVL(p_su, 0)) �Ǽ�
    FROM book b FULL JOIN panmai p ON b.b_id = p.b_id
    WHERE TO_CHAR(p_date, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')
    GROUP BY b.b_id, title
    ORDER BY �Ǽ� DESC
) t
WHERE ROWNUM = 1;


6. ������ �Ǹ���Ȳ ���ϱ�

�����ڵ�  ������  �Ǹűݾ���  ����(�Ҽ��� ��°�ݿø�)  
---------- -------------------------- ----------------
7	    ���ϼ���	15300		26%
4	    ���Ｍ��	11551		19%
2	    ���ü���	6000		10%
6	    ��������	18060		30%
1	    �츮����	8850		15%

SELECT t.�����ڵ�, t.������, t.�Ǹűݾ���, ROUND( t.�Ǹűݾ��� / t.��ü�Ǹűݾ� * 100) || '%' ����
FROM(
    SELECT g.g_id �����ڵ�, g_name ������, SUM(p_su * price) �Ǹűݾ���
        , (SELECT SUM(p_su * price) FROM panmai p JOIN danga d ON p.b_id = d.b_id) ��ü�Ǹűݾ�
    FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
                  JOIN danga d ON p.b_id = d.b_id
    GROUP BY g.g_id, g_name
) t;


