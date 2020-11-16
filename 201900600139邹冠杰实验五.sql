

--1．创建一windows用户（名字自定），用sql语句建立windows验证模式的登录名。默认数据库为student
CREATE LOGIN [DELL\ABC]
FROM WINDOWS 
WITH DEFAULT_DATABASE= student

--2．用sql语句和系统存储过程建立登录名sqluser,密码为1234 3．为student数据库新建用户u1，其登录名为sqluser。
CREATE LOGIN sqluser
WITH PASSWORD='1234 3'
,DEFAULT_DATABASE= student

--4．新建登录usersf，并将其加入到sysadmin固定服务器角色中。
CREATE LOGIN usersf
    WITH PASSWORD='123456'

EXEC sp_addsrvrolemember 'usersf', 'sysadmin'


--5．将student用户usersf（登录名为usersf）加入到db_owner角色中，使其全权负责该数据库,并验证其权限。
USE student
GO
CREATE USER usersf
FOR LOGIN usersf

USE student
GO
EXEC sp_addrolemember 'db_owner', 'usersf'

/*6．为SPJ数据库新建用户u2，u3，其登录名分别为u2，u3。
（1）授予用户u2对S表有SELECT 权，对P表颜色（COLOR）具有更新权限；
（2）u2将其拥有的权限授予u3；
（3）用sql语句逐一验证u2、u3所获得的权限。
（4）撤销用户u3所获得的权限，并验证。*/

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
--此处使用u2传播自己的权限
GRANT SELECT
ON S
TO u3
GRANT UPDATE
ON P(COLOR)
TO u3
--验证省略，大概就是切换用户使用几个select和update语句尝试一下
REVOKE SELECT
ON S
FROM u3
REVOKE UPDATE
ON P(COLOR)
FROM u3

--7.在student数据库中建立角色operate,该角色具有对student和course表的查询权限；具有对表sc的插入和修改权限。
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

--8.拒绝用户u1对sc表的修改权限。
DENY UPDATE
ON sc
TO u1

--9.使用存储过程将角色operate赋给用户u1,并用sql语句验证其权限。（特别验证u1对sc表的修改权限）

EXEC sp_addrolemember 'u1', 'operate'
--切换到u1
UPDATE sc
SET Grade =100

SELECT *
FROM sc

--10. 在student数据库中创建架构（schema）teacher指定给用户teacher（也就是要先创建一个teacher用户）
USE student
GO
CREATE LOGIN teacher
 WITH PASSWORD='123456'
CREATE USER teacher
FOR LOGIN teacher
GO
CREATE SCHEMA  teacher
AUTHORIZATION teacher
--11.	在已创建的teacher架构中创建“tea”表，表结构为（tno(编号), tname(姓名), tsd（专业）,tphone, te_mail）(数据类型和长度自己定义)，通过teacher架构为teacher用户设置查询权限，验证teacher用户对表tea是否具有select权限和delete权限，为什么？
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

--可以做各种操作，应该是因为teacher是该架构的拥有者，所以对于tea表来说，teacher也是它的拥有者owner
