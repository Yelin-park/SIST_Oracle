-- [ Localhost_SYS_20220406.sql 파일로 저장 ]
-- 1. 모든 롤을 확인하는 쿼리
select *
FROM dba_roles;

-- 2. RESOURCE롤이 어떤 권한들을 가지고 있는지 확인하는 쿼리
SELECT *
FROM dba_sys_privs
WHERE grantee = 'RESOURCE';

-- 3. scott 계정이 부여받은 롤 확인
SELECT *
FROM user_role_privs
WHERE username = 'scott';

--4. 문제3. SYS 계정으로 접속하여 모든 사용자 정보를 조회하는 쿼리(SQL)을 작성하세요.
SELECT *
FROM user_users; -- user_ 접두사 : 현재 접속중인 USER(여기서는 SYS)가 접근할 수 있는 모든 사용자 정보 뷰(view)
FROM dba_users; -- dba_ 접두사 : 오라클 관리자만 사용할 수 있음 + DB 내의 모든 사용자의 데이터(정보) 뷰(view) 
FROM all_users; -- all_ 접두사 : 모든 사용자 정보를 가져오는 view

--5. 문제20. HR 계정의 생성 시기와 [잠금상태]를 확인하는 쿼리를 작성하세요.
DESC dba_users;

SELECT username, account_status
FROM dba_users
WHERE username = 'HR'; -- 검색할 때와 비밀번호는 대소문자 구분함 꼭 알기~!




