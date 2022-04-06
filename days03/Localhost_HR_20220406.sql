-- [ HR에 접속된 스크립트 파일 ]

--1. 문제18. employees 테이블에서  아래와 같이 출력되도록 쿼리 작성하세요. 
SELECT first_name, last_name
        , first_name || ' ' ||last_name AS "NAME"
        , first_name || ' ' ||last_name "NAME"
        , first_name || ' ' ||last_name NAME
FROM employees;

SELECT first_name, last_name
FROM employees
WHERE REGEXP_LIKE(first_name, '^Ste(v|ph)en$')
ORDER BY first_name, last_name;

WHERE REGEXP_LIKE (first_name, '^Ste(v?ph)en$')
시작부터 끝까지 일치해야 할때 ^???$ Ste로 시작하고 끝은 en
중간에 v 또는 ph가 와야한다.