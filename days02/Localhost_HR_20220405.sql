-- SELECT ���� ��.. 5) HR ���� ���� -- 

-- ����1) HR ������ ������ ���̺� ������ ��ȸ�ϴ� ����(SQL)�� �ۼ��ϼ���.
SELECT *
FROM tabs;

-- ����2) EMPLOYEES ���̺��� ���� Ȯ���ϴ� ����(SQL)�� �ۼ��ϼ���
DESC employees;
DESCRIBE employees; -- ���� �ڵ��� ������
�÷���           ����뿩��  �ڷ���(ũ��)
�̸�             ��?       ����           
-------------- -------- ------------ 
EMPLOYEE_ID    NOT NULL NUMBER(6)               ���ID ����(6�ڸ�)
FIRST_NAME              VARCHAR2(20)            �̸�
LAST_NAME      NOT NULL VARCHAR2(25)            �̸�
EMAIL          NOT NULL VARCHAR2(25)            �̸���
PHONE_NUMBER            VARCHAR2(20)            ����ó
HIRE_DATE      NOT NULL DATE                    �Ի�����
JOB_ID         NOT NULL VARCHAR2(10)            ��ID
SALARY                  NUMBER(8,2)             ����(����, �Ǽ�) -> �Ǽ���
COMMISSION_PCT          NUMBER(2,2)             Ŀ�̼�
MANAGER_ID              NUMBER(6)               ���ӻ��ID
DEPARTMENT_ID           NUMBER(4)               �μ�ID

-- ����3) employees ���̺��� first_name�� last_name �÷��� ��ȸ�ϴ� ����(SQL) �ۼ��ϼ���
-- ����1) first_name�� last_name ���ڿ��� ���ļ� full_name �÷������� ���
SELECT first_name, last_name
     -- , 'full_name'
     -- ,first_name + last_name -- ���ڿ� + ���ڿ� �̹Ƿ� ���ڰ� �ƴ϶� ���� �߻�
     -- , first_name || ' ' || last_name AS "name"
     ,  CONCAT( CONCAT( first_name, ' '), last_name) "full name"
FROM employees;

-- ��Ī�� ������ �� ��� "" �ʼ�
ORA-00923: FROM keyword not found where expected
00923. 00000 -  "FROM keyword not found where expected"
*Cause:    
*Action:
27��, 243������ ���� �߻�

-- ����Ŭ ������  +   ���� ������
-- �ڹ� ������ + ���� ����, ���ڿ� ���� ������
ORA-01722: invalid number
01722. 00000 -  "invalid number"
*Cause:    The specified number was invalid.
*Action:   Specify a valid number.

