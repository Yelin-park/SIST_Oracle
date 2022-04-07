-- SYS 계정 접속 --
-- 최고 관리자(DBA) 계정 --

SELECT *
FROM dba_sys_privs
WHERE grantee = 'RESOURCE';

---------------------------------------
시노님(synonym) 설명

모든 권한이 있는 SYS도 테이블을 못찾는다.
SELECT *
FROM emp;
-- 에러 메시지 : ORA-00942: table or view does not exist

아래와 같이 '스키마.테이블명'으로 해주면 출력가능
SELECT *
FROM scott.emp;

5) 시노님의 생성
    [형식]
    - PUBLIC을 생략하면 PRIVATE 시노님이 됨
	CREATE [PUBLIC] SYNONYM [schema.]synonym명
  	FOR [schema.]object명;
    
- PUBLIC 시노님은 모든 사용자가 접근 가능하기 때문에 생성 및 삭제는 오직 DBA만이 할 수 있다.

- PUBLIC 시노님의 생성 순서
(1) SYSTEM / SYS 권한으로 접속한다. - SYS 접속
(2) PUBLIC 옵션을 사용하여 시노님을 생성한다. - SYS 접속
(3) 생성된 시노님에 대해 객체 소유자로 접속한다. - SCOTT 접속(소유자)
(4) 시노님에 권한을 부여한다. - SCOTT 접속(소유자)

CREATE PUBLIC SYNONYM arirang
    FOR scott.emp;
-- SYNONYM ARIRANG이(가) 생성되었습니다.

6) 시노님 삭제
DROP PUBLIC SYNONYM arirang;
-- SYNONYM ARIRANG이(가) 삭제되었습니다.




