-- [ SCOTT�� ���ӵ� ��ũ��Ʈ ���� ]
--������ �������
--ȸ�� �������
--���� ���
--���� ����
--ȸ���� �����ϴ°�
--�������

1) ������ ���
INSERT INTO ������ VALUES (1, 'admin', '12345', '������');   

COMMIT;

SELECT *
FROM ������;


2) ȸ�� ���
INSERT INTO ȸ�� VALUES (1, 'yelin', '12345', '�ڿ���', '951217-2112248', '010-6777-7428');
INSERT INTO ȸ�� VALUES (2, 'baek', '12345', '���ȯ', '940120-1234567', '010-1234-5678');
INSERT INTO ȸ�� VALUES (3, 'min', '12345', '������', '970418-1544318', '010-5678-2349');
INSERT INTO ȸ�� VALUES (4, 'kim', '12345', '���', '970815-1224888', '010-7777-8899');

COMMIT;

SELECT *
FROM ȸ��;


3-1) �������
INSERT INTO ��ϼ��� VALUES(1, '��������������', SYSDATE, TRUNC(SYSDATE), '2022.04.25', 2, null, null, 1);

COMMIT;

SELECT *
FROM ��ϼ���;

3-2) 1�� ������ ���� �׸� ���
INSERT INTO �׸� (������ȣ, �׸�1, �׸�2) VALUES (1, '����', '�ݴ�');

COMMIT;

SELECT *
FROM �׸�;

4) ��������
INSERT INTO ���� VALUES(1, '������');

COMMIT;

SELECT *
FROM ����;

5) ȸ���� �����ϱ�

INSERT INTO ���� VALUES(1, 1, SYSDATE, 1);
INSERT INTO ���� VALUES(1, 2, SYSDATE, 2);
INSERT INTO ���� VALUES(1, 3, SYSDATE, 2);
INSERT INTO ���� VALUES(1, 4, SYSDATE, 2);

COMMIT;

SELECT *
FROM ����;


6) ���
INSERT INTO ���
(
    SELECT ������ȣ,
        COUNT(*) �����ڼ�,
        NVL(COUNT(DECODE(�����׸�,1,'O')),0) ���1,
        NVL(COUNT(DECODE(�����׸�,2,'O')),0) ���2,
        NVL(COUNT(DECODE(�����׸�,3,'O')),0) ���3,
        NVL(COUNT(DECODE(�����׸�,4,'O')),0) ���4,
        NVL(COUNT(DECODE(�����׸�,5,'O')),0) ���5,
        NVL(COUNT(DECODE(�����׸�,6,'O')),0) ���6,
        NVL(COUNT(DECODE(�����׸�,7,'O')),0) ���7,
        NVL(COUNT(DECODE(�����׸�,8,'O')),0) ���8,
        NVL(COUNT(DECODE(�����׸�,9,'O')),0) ���9,
        NVL(COUNT(DECODE(�����׸�,10,'O')),0) ���10
    FROM ����
    GROUP BY ������ȣ
    HAVING ������ȣ = 1
);

COMMIT;

SELECT *
FROM ���;    

SELECT ������ȣ, �����ڼ�, ���1, ���2, ���3
        , ���1/�����ڼ� * 100 || '%' ���1����
        , ���2/�����ڼ� * 100 || '%' ���2����
        , ���3/�����ڼ� * 100 || '%' ���3����
FROM ���;



!!!!!!!!!!!!!!!!!!!!!���Ǻ����!!!!!!!!!!!!!!!!!!!
SELECT *
FROM(
    SELECT ������ȣ, �����ڼ�, ���1, ���2, ���3
        , ���1/�����ڼ� * 100 || '%' ���1����
        , ���2/�����ڼ� * 100 || '%' ���2����
        , ���3/�����ڼ� * 100 || '%' ���3����
    FROM ���
    WHERE ������ȣ = 1
)   
UNPIVOT( (��ǥ��, ����) FOR �׸� IN ( (���1, ���1���� ), (���2, ���2����), (���3, ���3����)   ) );

SELECT *
FROM(
    SELECT ������ȣ, ���1, ���2, ���3
        , ���1/�����ڼ� * 100 || '%' ���1����
        , ���2/�����ڼ� * 100 || '%' ���2����
        , ���3/�����ڼ� * 100 || '%' ���3����
    FROM ���
    WHERE ������ȣ = 3
)   
UNPIVOT( (��ǥ��, ����) FOR �׸� IN ( (���1, ���1���� ) AS '������', (���2, ���2����) AS '�ν�Ʈ��ũ', (���3, ���3����) AS '�ٶ��ǳ���'  ) );




SELECT ������ȣ, ���, ����
FROM(
    SELECT ������ȣ, �����ڼ�, ���1, ���2
        , ���1/�����ڼ� * 100 || '%' ���1���� , ���2/�����ڼ� * 100 || '%' ���2����
    FROM ���    
)
UNPIVOT( ���� FOR ��� IN (���1����, ���2���� ) );


/*
SELECT *
FROM ( �ǹ� ��� ������ )
UNPIVOT ( �÷���Ī(��) FOR �÷���Ī(��) IN (�ǹ����� AS '��Ī', ... )
*/


SELECT t.*
FROM(
    SELECT ������ȣ, �����ڼ�, ���1, ���2
        , ���1/�����ڼ� * 100 || '%' ���1���� , ���2/�����ڼ� * 100 || '%' ���2����
    FROM ���     
) t
UNPIVOT(
        (���, ����)
        FOR ������ȣ
        IN (   (���1, ���1����)
                , (���2, ���2����)
        )
);



SELECT ������ȣ, ���, ����
FROM(
    SELECT ������ȣ, �����ڼ�, ���1, ���2
        , ���1/�����ڼ� * 100 || '%' ���1���� , ���2/�����ڼ� * 100 || '%' ���2����
    FROM ���    
)
UNPIVOT( ���� FOR ��� IN (���1����, ���2���� ) );


/*   
    SELECT ������ȣ, �����׸�, COUNT(*) �׸������ڼ�
        , (SELECT COUNT(*) FROM ���� WHERE ������ȣ = 1) �����ڼ�
    FROM ����
    GROUP BY ������ȣ, �����׸�
    ORDER BY ������ȣ, �����׸�;
*/


--------------------------------------
-- ������ ���� ���
INSERT INTO ������ (�����ڹ�ȣ, ������ID, �����ں�й�ȣ, �������̸�) 
       VALUES (1, 'admin01', 'a1234567890', 'admin');

DELETE FROM ������ WHERE �����ڹ�ȣ = 1;

COMMIT;
ROLLBACK;

-- ȸ�� ���� ���
INSERT INTO ȸ�� (ȸ����ȣ, ȸ��ID, ȸ����й�ȣ, ȸ���̸�, �ֹι�ȣ, �ڵ�����ȣ)
        VALUES (1, 'id1231', 'pw123', 'ȫ�浿', '900101-1234567', '010-1234-5678');
INSERT INTO ȸ�� (ȸ����ȣ, ȸ��ID, ȸ����й�ȣ, ȸ���̸�, �ֹι�ȣ, �ڵ�����ȣ)
        VALUES (2, 'id1232', 'pw123', 'ȫ�浿', '900102-1234567', '010-2234-5678');
INSERT INTO ȸ�� (ȸ����ȣ, ȸ��ID, ȸ����й�ȣ, ȸ���̸�, �ֹι�ȣ, �ڵ�����ȣ)
        VALUES (3, 'id1233', 'pw123', 'ȫ�浿', '900103-1234567', '010-3234-5678');
INSERT INTO ȸ��(ȸ����ȣ, ȸ��ID, ȸ����й�ȣ, ȸ���̸�, �ֹι�ȣ, �ڵ�����ȣ)
        VALUES (4, 'id1234', 'pw123', 'ȫ�浿', '900104-1234567', '010-4234-5678');
INSERT INTO ȸ��(ȸ����ȣ, ȸ��ID, ȸ����й�ȣ, ȸ���̸�, �ֹι�ȣ, �ڵ�����ȣ)
        VALUES (5, 'id1235', 'pw123', 'ȫ�浿', '900105-1234567', '010-5234-5678');
        
DELETE FROM ȸ�� WHERE ȸ����ȣ = 1;

COMMIT;
ROLLBACK;

-- ���� ���
INSERT INTO ��ϼ��� (������ȣ, ��������, �ۼ���, ������, ������, �׸��, ������, ������, �����ڹ�ȣ) 
        VALUES (1, '�ְ��� ������?', SYSDATE, SYSDATE+1, SYSDATE+2, 3, null, null, 1); 
INSERT INTO ��ϼ��� (������ȣ, ��������, �ۼ���, ������, ������, �׸��, ������, ������, �����ڹ�ȣ) 
        VALUES (2, '�ְ��� ������?', SYSDATE, SYSDATE-3, SYSDATE-2, 3, null, null, 1); 
INSERT INTO ��ϼ��� (������ȣ, ��������, �ۼ���, ������, ������, �׸��, ������, ������, �����ڹ�ȣ) 
        VALUES (3, '�ְ��� ������?', SYSDATE, SYSDATE-1, SYSDATE+2, 3, null, null, 1); 
-- �׸� ���
INSERT INTO �׸� (������ȣ, �׸�1, �׸�2, �׸�3) VALUES(1, '�����ý��丮', '�ν�Ʈ��ũ', '�ٶ��ǳ���');
INSERT INTO �׸� (������ȣ, �׸�1, �׸�2, �׸�3) VALUES(2, '�����ý��丮', '�ν�Ʈ��ũ', '�ٶ��ǳ���');
INSERT INTO �׸� (������ȣ, �׸�1, �׸�2, �׸�3) VALUES(3, '�����ý��丮', '�ν�Ʈ��ũ', '�ٶ��ǳ���');
--���� �Խ���
INSERT INTO ���� VALUES (1, (SELECT CASE
                                        WHEN SYSDATE < ������ THEN '������'
                                        WHEN ������ < SYSDATE AND SYSDATE < ������ THEN '������'
                                        ELSE '����'
                                    END ����
                                FROM ��ϼ���
                                WHERE ������ȣ = 1));
INSERT INTO ���� VALUES (2, (SELECT CASE
                                        WHEN SYSDATE < ������ THEN '������'
                                        WHEN ������ < SYSDATE AND SYSDATE < ������ THEN '������'
                                        ELSE '����'
                                    END ����
                                FROM ��ϼ���
                                WHERE ������ȣ = 2));
INSERT INTO ���� VALUES (3, (SELECT CASE
                                        WHEN SYSDATE < ������ THEN '������'
                                        WHEN ������ < SYSDATE AND SYSDATE < ������ THEN '������'
                                        ELSE '����'
                                    END ����
                                FROM ��ϼ���
                                WHERE ������ȣ = 3));
COMMIT;
ROLLBACK;

-- ���� �Խ��� ��ȸ

SELECT
    s.������ȣ ��ȣ,
    ��������,
    �������̸� �ۼ���,
    ������,
    ������,
    �׸��,
    ����
FROM ���� s
    JOIN ��ϼ��� d ON s.������ȣ = d.������ȣ
    JOIN ������ g ON g.�����ڹ�ȣ = d.�����ڹ�ȣ
ORDER BY d.������ȣ;


-- �����ϱ�
INSERT INTO ���� (������ȣ, ȸ����ȣ, ������, �����׸�)
    VALUES (3, 1, SYSDATE, 1);
INSERT INTO ���� (������ȣ, ȸ����ȣ, ������, �����׸�)
    VALUES (3, 2, SYSDATE, 2);
INSERT INTO ���� (������ȣ, ȸ����ȣ, ������, �����׸�)
    VALUES (3, 3, SYSDATE, 2);
INSERT INTO ���� (������ȣ, ȸ����ȣ, ������, �����׸�)
    VALUES (3, 4, SYSDATE, 3);
    
INSERT INTO ���� (������ȣ, ȸ����ȣ, ������, �����׸�)
    VALUES (1, 5, SYSDATE, 3);

DELETE FROM ����;

-- ���� ��� ���̺� ���

INSERT INTO ���
(
    SELECT ������ȣ,
        COUNT(*) �����ڼ�,
        NVL(COUNT(DECODE(�����׸�,1,'O')),0) ���1,
        NVL(COUNT(DECODE(�����׸�,2,'O')),0) ���2,
        NVL(COUNT(DECODE(�����׸�,3,'O')),0) ���3,
        NVL(COUNT(DECODE(�����׸�,4,'O')),0) ���4,
        NVL(COUNT(DECODE(�����׸�,5,'O')),0) ���5,
        NVL(COUNT(DECODE(�����׸�,6,'O')),0) ���6,
        NVL(COUNT(DECODE(�����׸�,7,'O')),0) ���7,
        NVL(COUNT(DECODE(�����׸�,8,'O')),0) ���8,
        NVL(COUNT(DECODE(�����׸�,9,'O')),0) ���9,
        NVL(COUNT(DECODE(�����׸�,10,'O')),0) ���10
    FROM ����
    GROUP BY ������ȣ
    HAVING ������ȣ = 3
);

-- ���� ��� ���̱�


SELECT
    �׸�1 �׸�,
    ���1 ��ǥ��,
    ROUND(���1/�����ڼ�*100) || '%' ��ǥ��
FROM ��� r
    JOIN �׸� h ON r.������ȣ = h.������ȣ 
WHERE r.������ȣ = 3;


(SELECT �׸� FROM (SELECT * FROM �׸� a JOIN ��ϼ��� b ON a.������ȣ = b.������ȣ WHERE a.������ȣ =1)
    UNPIVOT (�׸� FOR �׸��ȣ IN ( �׸�1, �׸�2, �׸�3, �׸�4, �׸�5, �׸�6, �׸�7, �׸�8, �׸�9, �׸�10)) WHERE ROWNUM <= �׸�� ) �׸�,
    (SELECT ��ǥ FROM (SELECT * FROM ��� a JOIN ��ϼ��� b ON a.������ȣ = b.������ȣ WHERE a.������ȣ =1)
    UNPIVOT (��ǥ FOR ��ǥ��ȣ IN ( ���1, ���2, ���3, ���4, ���5, ���6, ���7, ���8, ���9, ���10)) WHERE ROWNUM <= �׸�� ) ��ǥ,
    (SELECT ��ǥ /�����ڼ� FROM (SELECT * FROM ��� a JOIN ��ϼ��� b ON a.������ȣ = b.������ȣ WHERE a.������ȣ =1)
    UNPIVOT (��ǥ FOR ��ǥ��ȣ IN ( ���1, ���2, ���3, ���4, ���5, ���6, ���7, ���8, ���9, ���10)) WHERE ROWNUM <= �׸�� ) ����;




            
