-- SYS ���� ���� --
-- �ְ� ������(DBA) ���� --

-- 9�� ���� ����.. �߰��� �ó���� �ִ��� Ȯ���ϱ�
-- SYS �������� ��� �ó���� Ȯ���� �� �ִ� ����
SELECT *
FROM all_synonyms;

SELECT *
FROM all_synonyms -- �ڷ����(data dictionary)�ȿ� �ִ� ��(view)
WHERE synonym_name LIKE UPPER('%arirang%');

CREATE PUBLIC SYNONYM arirang
    FOR scott.dept;