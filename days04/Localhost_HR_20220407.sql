-- [ HR�� ���ӵ� ��ũ��Ʈ ���� ]
23. hr �������� ����
    employees ���̺��� first_name, last_name �̸� �ӿ� 'ev' ���ڿ� �����ϴ� ��� ���� ���
    
FIRST_NAME           LAST_NAME                 NAME                                           NAME                                                                                                                                                                                    
-------------------- ------------------------- ---------------------------------------------- -------------------------
Kevin                Feeney                    Kevin Feeney                                   K[ev]in Feeney                                                                                                                                                                          
Steven               King                      Steven King                                    St[ev]en King                                                                                                                                                                           
Steven               Markle                    Steven Markle                                  St[ev]en Markle                                                                                                                                                                         
Kevin                Mourgos                   Kevin Mourgos                                  K[ev]in Mourgos    

SELECT first_name, last_name
        , first_name || ' ' || last_name NAME
FROM employees
WHERE CONCAT(first_name, last_name) LIKE '%ev%';

SELECT t.*, REPLACE(t.name, 'ev', '<sapn color = blue>ev</span>')
SELECT t.*, REPLACE(t.name, 'ev', '[ev]')
FROM(
    SELECT first_name, last_name
            , first_name || ' ' || last_name NAME
    FROM employees
) t
WHERE t.name LIKE '%ev%';

------------------------------------------------------
�ó��(synonym) ����

SELECT *
FROM emp;
-- ���� �޽��� : ORA-00942: table or view does not exist
-- ���� : emp ���̺��� scott ����

SELECT *
FROM scott.emp;
-- ���� �޽��� : ORA-00942: table or view does not exist

-- SYS�� ���� ����

scott ������ ������ emp ���̺��� �ִٸ�
emp ���̺��� �����ڴ� scott�̴�. -> ��, �����ڸ� ����� �� �ִ�. -> ���� �ο��� �ʿ�
������ �ο��ϸ� ��Ű��.���̺������ ��� ���� -> �ó��(SYNONYM)�� �����ϸ� ���ϰ� ��� ����

SELECT *
FROM arirang;

DELETE FROM arirang
WHERE empno = 7369;
-- ���� �޽��� : SQL ����: ORA-01031: insufficient privileges
-- �ؼ� : ������ ������� �ʴ�.

