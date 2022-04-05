-- [ Localhost_SYS_20220405.sql 파일로 저장 ]

-- 1. SQL 정의 : 구조화된 쿼리언어 또는 질의어(Structured Query Language)
--              오라클 서버         <--DATA 조작 질의/응답-->         클라이언트(클라이언트 툴)
-- 2. SQL 5가지 종류
--      DQL : Query 조회, 검색 - SELECT문
--      DDL : 데이터 정의    - [CREATE문(생성)], [ALTER문(수정)], DROP문(삭제)
--      DML : 데이터 조작    - [INSERT], UPDATE, [DELETE문] + 커밋(COMMINT) 또는 롤백(ROLLBACK)을 꼭 해줘야 한다.
--      DCL : 데이트 컨트롤(권한 부여, 제거) - [GRANT], REVOKE
--      TCL : 트랜잭션 조작 - [COMMIT], ROLLBACK< SAVEPOINT 문

-- 1. 모든 사원 정보를 조회(검색) : DQL   SELECT문
SELECT *
FROM all_users;

-- 2. scott 계정 생성(tiger 비밀번호)
CREATE USER scott IDENTIFIED BY tiger;
-- User SCOTT이(가) 생성되었습니다.

-- 3. scott 계정에 권한 부여하기
GRANT RESOURCE, CONNECT TO scott;
-- Grant을(를) 성공했습니다.

-- 4. scott 계정 삭제 : 접속한 계정이 권한이 있어야 가능 => SYS / SYSTEM
-- 계정을 삭제할 때 CASCADE 옵션을 추가하면 삭제할 계정이 소유하는 모든 객체도 삭제
DROP USER scott CASCADE;
-- User SCOTT이(가) 삭제되었습니다.

-- 5. scott 계정으로 오라클 서버에 접속(연결 == CONNECT)

-- 6. 모든 사원 정보를 조회(검색) 후 HR 계정 유무 확인
SELECT *
FROM all_users;

-- 7. HR 계정으로 오라클 서버에 접속(연결 == CONNECT) -> 비밀번호를 몰라서 아래와 같은 작업 수행

-- 8. HR 계정의 비밀번호를 lion으로 수정
ALTER USER hr IDENTIFIED BY lion;
-- User HR이(가) 변경되었습니다.

-- 9. HR 계정이 현재 상태 잠금 상태인지 조회(확인)
SELECT *
FROM dba_users;
FROM all_users; -- 계정명, 계정ID, 생성일 컬럼만 확인(조회) 가능

-- 10. HR 계정 잠금 해제
ALTER USER hr ACCOUNT UNLOCK;
-- User HR이(가) 변경되었습니다.

-- 11. hr 계정 비밀번호 수정 + 잠금 상태 해제
ALTER USER hr IDENTIFIED BY lion
                ACCOUNT UNLOCK;

-- 12. scott 계정 기본값인 SYSTEM을 USERS로 변경                
ALTER USER SCOTT DEFAULT TABLESPACE USERS;
ALTER USER SCOTT TEMPORARY TABLESPACE TEMP;

-- 13. 일부러 에러 발생시키셨음 - SYS에는 emp 테이블이 없어서 아래와 같은 에러메시지 발생 -> SCOTT에 가서 해야 됨
SELECT *
FROM emp;
-- ORA-00942: table or view does not exist
-- 00942. 00000 -  "table or view does not exist"
-- *Cause:    
-- *Action:
-- 59행, 6열에서 오류 발생




