-- Localhost_SYS_20220404.sql
-- 오라클 주석 처리(-- 두개 붙이는 것)

-- 모든 사용자 계정 조회(확인)라는 쿼리(SQL)이다.
SELECT *
FROM all_users;
-- 쿼리 실행하는 방법
-- 1) 실행하고자 하는 쿼리(SQL)를 선택(select)하고(드래그) F5 키를 누른다.
-- 2) 실행하고자 하는 쿼리(SQL)를 선택하고 Ctrl+Enter 누른다.
-- 3) 실행하고자 하는 쿼리(SQL)를 선택하지 않고 실행하고자 하는 쿼리(SQL)에 커서를 둔 상태로 Ctrl+Enter 누른다.

-- scott 계정 생성 (SQL문)
CREATE USER scott IDENTIFIED BY tiger;

-- 로그인 권한 부여
GRANT CREATE SESSION TO scott;
GRANT RESOURCE, CONNECT TO scott;