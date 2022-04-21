-- SYS 계정 접속 --
-- 최고 관리자(DBA) 계정 --

GRANT CREATE VIEW TO scott;

SELECT *
FROM DBA_SYS_PRIVS
WHERE grantee = 'SCOTT';