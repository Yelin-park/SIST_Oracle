-- SYS 계정 접속 --
-- 최고 관리자(DBA) 계정 --

-- 9번 문제 관련.. 추가할 시노님이 있는지 확인하기
-- SYS 계정에서 모든 시노님을 확인할 수 있는 쿼리
SELECT *
FROM all_synonyms;

SELECT *
FROM all_synonyms -- 자료사전(data dictionary)안에 있는 뷰(view)
WHERE synonym_name LIKE UPPER('%arirang%');

CREATE PUBLIC SYNONYM arirang
    FOR scott.dept;