

--1������һwindows�û��������Զ�������sql��佨��windows��֤ģʽ�ĵ�¼����Ĭ�����ݿ�Ϊstudent
CREATE LOGIN [DELL\ABC]
FROM WINDOWS 
WITH DEFAULT_DATABASE= student

--2����sql����ϵͳ�洢���̽�����¼��sqluser,����Ϊ1234 3��Ϊstudent���ݿ��½��û�u1�����¼��Ϊsqluser��
CREATE LOGIN sqluser
WITH PASSWORD='1234 3'
,DEFAULT_DATABASE= student

--4���½���¼usersf����������뵽sysadmin�̶���������ɫ�С�
CREATE LOGIN usersf
    WITH PASSWORD='123456'

EXEC sp_addsrvrolemember 'usersf', 'sysadmin'


--5����student�û�usersf����¼��Ϊusersf�����뵽db_owner��ɫ�У�ʹ��ȫȨ��������ݿ�,����֤��Ȩ�ޡ�
USE student
GO
CREATE USER usersf
FOR LOGIN usersf

USE student
GO
EXEC sp_addrolemember 'db_owner', 'usersf'

/*6��ΪSPJ���ݿ��½��û�u2��u3�����¼���ֱ�Ϊu2��u3��
��1�������û�u2��S����SELECT Ȩ����P����ɫ��COLOR�����и���Ȩ�ޣ�
��2��u2����ӵ�е�Ȩ������u3��
��3����sql�����һ��֤u2��u3����õ�Ȩ�ޡ�
��4�������û�u3����õ�Ȩ�ޣ�����֤��*/

CREATE LOGIN u2
    WITH PASSWORD='123456'
CREATE LOGIN u3
    WITH PASSWORD='123456'
USE SPJ
GO
CREATE USER u2
FOR LOGIN u2

CREATE USER u3
FOR LOGIN u3

GRANT SELECT
ON S
TO u2
WITH GRANT OPTION
GRANT UPDATE
ON P(COLOR)
TO u2
WITH GRANT OPTION
--�˴�ʹ��u2�����Լ���Ȩ��
GRANT SELECT
ON S
TO u3
GRANT UPDATE
ON P(COLOR)
TO u3
--��֤ʡ�ԣ���ž����л��û�ʹ�ü���select��update��䳢��һ��
REVOKE SELECT
ON S
FROM u3
REVOKE UPDATE
ON P(COLOR)
FROM u3

--7.��student���ݿ��н�����ɫoperate,�ý�ɫ���ж�student��course��Ĳ�ѯȨ�ޣ����жԱ�sc�Ĳ�����޸�Ȩ�ޡ�
USE student
GO
CREATE ROLE operate

GRANT SELECT
ON student
TO operate

GRANT SELECT
ON course
TO operate

GRANT INSERT
ON sc
TO operate

GRANT UPDATE
ON sc
TO operate

--8.�ܾ��û�u1��sc����޸�Ȩ�ޡ�
DENY UPDATE
ON sc
TO u1

--9.ʹ�ô洢���̽���ɫoperate�����û�u1,����sql�����֤��Ȩ�ޡ����ر���֤u1��sc����޸�Ȩ�ޣ�

EXEC sp_addrolemember 'u1', 'operate'
--�л���u1
UPDATE sc
SET Grade =100

SELECT *
FROM sc

--10. ��student���ݿ��д����ܹ���schema��teacherָ�����û�teacher��Ҳ����Ҫ�ȴ���һ��teacher�û���
USE student
GO
CREATE LOGIN teacher
 WITH PASSWORD='123456'
CREATE USER teacher
FOR LOGIN teacher
GO
CREATE SCHEMA  teacher
AUTHORIZATION teacher
--11.	���Ѵ�����teacher�ܹ��д�����tea������ṹΪ��tno(���), tname(����), tsd��רҵ��,tphone, te_mail��(�������ͺͳ����Լ�����)��ͨ��teacher�ܹ�Ϊteacher�û����ò�ѯȨ�ޣ���֤teacher�û��Ա�tea�Ƿ����selectȨ�޺�deleteȨ�ޣ�Ϊʲô��
CREATE TABLE teacher.tea
(
tno char(10),
tname nchar(10),
tsd nchar(10),
tphone varchar(20),
te_mail varchar(20)
)



SELECT *
FROM teacher.tea

INSERT teacher.tea(tno,tname)
VALUES('1','3')

DELETE teacher.tea

--���������ֲ�����Ӧ������Ϊteacher�Ǹüܹ���ӵ���ߣ����Զ���tea����˵��teacherҲ������ӵ����owner
