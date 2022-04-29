-- 홍길동 사용자가 원격으로 SCOTT 계정 접속
6) 홍길동 트랜잭션 테스트
(1)
        SELECT *
        FROM emp;

(2) A 계정에서 COMMIT, ROLLBACK을 완료안해서 무한 루프 돌았음
     *** JSP할 때 주의!!
        UPDATE emp
        SET comm = 0
        WHERE ename ='SMITH';
        
        ROLLBACK;