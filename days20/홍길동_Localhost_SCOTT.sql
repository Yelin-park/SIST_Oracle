-- ȫ�浿 ����ڰ� �������� SCOTT ���� ����
6) ȫ�浿 Ʈ����� �׽�Ʈ
(1)
        SELECT *
        FROM emp;

(2) A �������� COMMIT, ROLLBACK�� �Ϸ���ؼ� ���� ���� ������
     *** JSP�� �� ����!!
        UPDATE emp
        SET comm = 0
        WHERE ename ='SMITH';
        
        ROLLBACK;