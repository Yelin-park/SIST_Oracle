-- SYS ���� ���� --
-- �ְ� ������(DBA) ���� --

SELECT *
FROM dba_sys_privs
WHERE grantee = 'RESOURCE';

---------------------------------------
�ó��(synonym) ����

��� ������ �ִ� SYS�� ���̺��� ��ã�´�.
SELECT *
FROM emp;
-- ���� �޽��� : ORA-00942: table or view does not exist

�Ʒ��� ���� '��Ű��.���̺��'���� ���ָ� ��°���
SELECT *
FROM scott.emp;

5) �ó���� ����
    [����]
    - PUBLIC�� �����ϸ� PRIVATE �ó���� ��
	CREATE [PUBLIC] SYNONYM [schema.]synonym��
  	FOR [schema.]object��;
    
- PUBLIC �ó���� ��� ����ڰ� ���� �����ϱ� ������ ���� �� ������ ���� DBA���� �� �� �ִ�.

- PUBLIC �ó���� ���� ����
(1) SYSTEM / SYS �������� �����Ѵ�. - SYS ����
(2) PUBLIC �ɼ��� ����Ͽ� �ó���� �����Ѵ�. - SYS ����
(3) ������ �ó�Կ� ���� ��ü �����ڷ� �����Ѵ�. - SCOTT ����(������)
(4) �ó�Կ� ������ �ο��Ѵ�. - SCOTT ����(������)

CREATE PUBLIC SYNONYM arirang
    FOR scott.emp;
-- SYNONYM ARIRANG��(��) �����Ǿ����ϴ�.

6) �ó�� ����
DROP PUBLIC SYNONYM arirang;
-- SYNONYM ARIRANG��(��) �����Ǿ����ϴ�.




