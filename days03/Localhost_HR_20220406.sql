-- [ HR�� ���ӵ� ��ũ��Ʈ ���� ]

--1. ����18. employees ���̺���  �Ʒ��� ���� ��µǵ��� ���� �ۼ��ϼ���. 
SELECT first_name, last_name
        , first_name || ' ' ||last_name AS "NAME"
        , first_name || ' ' ||last_name "NAME"
        , first_name || ' ' ||last_name NAME
FROM employees;

SELECT first_name, last_name
FROM employees
WHERE REGEXP_LIKE(first_name, '^Ste(v|ph)en$')
ORDER BY first_name, last_name;

WHERE REGEXP_LIKE (first_name, '^Ste(v?ph)en$')
���ۺ��� ������ ��ġ�ؾ� �Ҷ� ^???$ Ste�� �����ϰ� ���� en
�߰��� v �Ǵ� ph�� �;��Ѵ�.