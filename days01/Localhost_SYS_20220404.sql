-- Localhost_SYS_20220404.sql
-- ����Ŭ �ּ� ó��(-- �ΰ� ���̴� ��)

-- ��� ����� ���� ��ȸ(Ȯ��)��� ����(SQL)�̴�.
SELECT *
FROM all_users;
-- ���� �����ϴ� ���
-- 1) �����ϰ��� �ϴ� ����(SQL)�� ����(select)�ϰ�(�巡��) F5 Ű�� ������.
-- 2) �����ϰ��� �ϴ� ����(SQL)�� �����ϰ� Ctrl+Enter ������.
-- 3) �����ϰ��� �ϴ� ����(SQL)�� �������� �ʰ� �����ϰ��� �ϴ� ����(SQL)�� Ŀ���� �� ���·� Ctrl+Enter ������.

-- scott ���� ���� (SQL��)
CREATE USER scott IDENTIFIED BY tiger;

-- �α��� ���� �ο�
GRANT CREATE SESSION TO scott;
GRANT RESOURCE, CONNECT TO scott;