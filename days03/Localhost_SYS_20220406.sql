-- [ Localhost_SYS_20220406.sql ���Ϸ� ���� ]
-- 1. ��� ���� Ȯ���ϴ� ����
select *
FROM dba_roles;

-- 2. RESOURCE���� � ���ѵ��� ������ �ִ��� Ȯ���ϴ� ����
SELECT *
FROM dba_sys_privs
WHERE grantee = 'RESOURCE';

-- 3. scott ������ �ο����� �� Ȯ��
SELECT *
FROM user_role_privs
WHERE username = 'scott';

--4. ����3. SYS �������� �����Ͽ� ��� ����� ������ ��ȸ�ϴ� ����(SQL)�� �ۼ��ϼ���.
SELECT *
FROM user_users; -- user_ ���λ� : ���� �������� USER(���⼭�� SYS)�� ������ �� �ִ� ��� ����� ���� ��(view)
FROM dba_users; -- dba_ ���λ� : ����Ŭ �����ڸ� ����� �� ���� + DB ���� ��� ������� ������(����) ��(view) 
FROM all_users; -- all_ ���λ� : ��� ����� ������ �������� view

--5. ����20. HR ������ ���� �ñ�� [��ݻ���]�� Ȯ���ϴ� ������ �ۼ��ϼ���.
DESC dba_users;

SELECT username, account_status
FROM dba_users
WHERE username = 'HR'; -- �˻��� ���� ��й�ȣ�� ��ҹ��� ������ �� �˱�~!




