-- [ Localhost_SYS_20220405.sql ���Ϸ� ���� ]

-- 1. SQL ���� : ����ȭ�� ������� �Ǵ� ���Ǿ�(Structured Query Language)
--              ����Ŭ ����         <--DATA ���� ����/����-->         Ŭ���̾�Ʈ(Ŭ���̾�Ʈ ��)
-- 2. SQL 5���� ����
--      DQL : Query ��ȸ, �˻� - SELECT��
--      DDL : ������ ����    - [CREATE��(����)], [ALTER��(����)], DROP��(����)
--      DML : ������ ����    - [INSERT], UPDATE, [DELETE��] + Ŀ��(COMMINT) �Ǵ� �ѹ�(ROLLBACK)�� �� ����� �Ѵ�.
--      DCL : ����Ʈ ��Ʈ��(���� �ο�, ����) - [GRANT], REVOKE
--      TCL : Ʈ����� ���� - [COMMIT], ROLLBACK< SAVEPOINT ��

-- 1. ��� ��� ������ ��ȸ(�˻�) : DQL   SELECT��
SELECT *
FROM all_users;

-- 2. scott ���� ����(tiger ��й�ȣ)
CREATE USER scott IDENTIFIED BY tiger;
-- User SCOTT��(��) �����Ǿ����ϴ�.

-- 3. scott ������ ���� �ο��ϱ�
GRANT RESOURCE, CONNECT TO scott;
-- Grant��(��) �����߽��ϴ�.

-- 4. scott ���� ���� : ������ ������ ������ �־�� ���� => SYS / SYSTEM
-- ������ ������ �� CASCADE �ɼ��� �߰��ϸ� ������ ������ �����ϴ� ��� ��ü�� ����
DROP USER scott CASCADE;
-- User SCOTT��(��) �����Ǿ����ϴ�.

-- 5. scott �������� ����Ŭ ������ ����(���� == CONNECT)

-- 6. ��� ��� ������ ��ȸ(�˻�) �� HR ���� ���� Ȯ��
SELECT *
FROM all_users;

-- 7. HR �������� ����Ŭ ������ ����(���� == CONNECT) -> ��й�ȣ�� ���� �Ʒ��� ���� �۾� ����

-- 8. HR ������ ��й�ȣ�� lion���� ����
ALTER USER hr IDENTIFIED BY lion;
-- User HR��(��) ����Ǿ����ϴ�.

-- 9. HR ������ ���� ���� ��� �������� ��ȸ(Ȯ��)
SELECT *
FROM dba_users;
FROM all_users; -- ������, ����ID, ������ �÷��� Ȯ��(��ȸ) ����

-- 10. HR ���� ��� ����
ALTER USER hr ACCOUNT UNLOCK;
-- User HR��(��) ����Ǿ����ϴ�.

-- 11. hr ���� ��й�ȣ ���� + ��� ���� ����
ALTER USER hr IDENTIFIED BY lion
                ACCOUNT UNLOCK;

-- 12. scott ���� �⺻���� SYSTEM�� USERS�� ����                
ALTER USER SCOTT DEFAULT TABLESPACE USERS;
ALTER USER SCOTT TEMPORARY TABLESPACE TEMP;

-- 13. �Ϻη� ���� �߻���Ű���� - SYS���� emp ���̺��� ��� �Ʒ��� ���� �����޽��� �߻� -> SCOTT�� ���� �ؾ� ��
SELECT *
FROM emp;
-- ORA-00942: table or view does not exist
-- 00942. 00000 -  "table or view does not exist"
-- *Cause:    
-- *Action:
-- 59��, 6������ ���� �߻�




