-- SYS ���� ���� --
-- �ְ� ������(DBA) ���� --

GRANT CREATE VIEW TO scott;

SELECT *
FROM DBA_SYS_PRIVS
WHERE grantee = 'SCOTT';