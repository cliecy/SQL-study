--以系统管理员身份登录到SQL Server服务器，并使用T-SQL语句实现以下操作：
--1.	将stu数据库中student表的sno定义为主键
ALTER table student
ADD CONSTRAINT A PRIMARY KEY(sno)

--2.	将数据库stu的表course的cno字段定义为主键，约束名称为cno_pk;
ALTER table course
ADD CONSTRAINT cno_pk PRIMARY KEY(cno)

--3.	为表course中的字段cname添加唯一值约束；
ALTER table course
ADD CONSTRAINT B UNIQUE

--4.	将数据库stu的表sc的sno及cno字段组合定义为主键，约束名称为sc_pk;
ALTER table sc
ADD CONSTRAINT sc_pk PRIMARY KEY(sno,cno)

/*5.	对于数据表sc的sno、cno字段定义为外码，使之与表student的主码sno及表course的主码cno对应，实现如下参照完整性：
1)	删除student表中记录的同时删除sc表中与该记录sno字段值相同的记录；
2)	修改student表某记录的sno时，若sc表中与该字段值对应的有若干条记录，则拒绝修改；
3)	修改course表cno字段值时，该字段在sc表中的对应值也应修改；
4)	删除course表一条记录时，若该字段在在sc表中存在，则删除该字段对应的记录；
5)	向sc表添加记录时，如果该记录的sno字段的值在student中不存在，则拒绝插入*/
ALTER table sc
ADD CONSTRAINT snoF FOREIGN KEY(sno) REFERENCES student(sno)
ALTER table sc
ADD CONSTRAINT cnoF FOREIGN KEY(cno) REFERENCES course(cno)

GO
CREATE TRIGGER compelete1 ON student
FOR DELETE
AS
DELETE 
FROM student
WHERE student.Sno=(SELECT Sno FROM DELETED)

GO
CREATE TRIGGER complete2 ON student
FOR UPDATE
AS
IF UPDATE(sno) 
BEGIN
IF((SELECT sno FROM deleted) IN (SELECT sno FROM student))
BEGIN
PRINT('拒绝修改')
ROLLBACK TRANSACTION
END
END
GO
CREATE TRIGGER compelete3 ON course
FOR UPDATE
AS
IF UPDATE(cno)
BEGIN
UPDATE sc
SET sc.Cno=(SELECT Cno FROM inserted)
WHERE sc.Cno=(SELECT Cno FROM deleted)
END

GO
CREATE TRIGGER complete4 ON course
FOR DELETE
AS
IF((SELECT Cno FROM deleted) IN (SELECT Cno FROM sc))
BEGIN
DELETE 
FROM sc
WHERE sc.Cno=(SELECT Cno FROM deleted)
END

GO
CREATE TRIGGER compelete5 ON sc
FOR INSERT
AS
IF((SELECT sno FROM inserted) NOT IN (SELECT sno FROM student))
BEGIN
PRINT('拒绝插入')
ROLLBACK TRANSACTION
END

--6.	定义check约束，要求学生学号sno必须为9位数字字符，且不能以0开头，第二三位皆为0；
ALTER table student
ADD CONSTRAINT check_1 CHECK(Sno LIKE '[^0]00______' )

--7.	定义stu数据库中student表中学生年龄值在16-25范围内；
ALTER table student
ADD CONSTRAINT check_2 CHECK(Sage BETWEEN 16 AND 25)

--8.	定义stu数据库中student表中学生姓名长度在2-8之间
ALTER table student
ADD CONSTRAINT check_3 CHECK(len(Sname) BETWEEN 2 AND 8)

--9.	定义stu数据库中student表中学生性别列中只能输入“男”或“女”；
ALTER table student
ADD CONSTRAINT check_4 CHECK(Ssex LIKE [男女])

--10.	定义stu数据库student表中学生年龄值默认值为20
ALTER table student
ADD CONSTRAINT defalut_1 DEFAULT(20) FOR Sage

--11.	修改student表学生的年龄值约束可以为15-30范围内；
ALTER table student
ADD CONSTRAINT check_5 CHECK(Sage BETWEEN 15 AND 30)

--12.	删除上述唯一值约束、外键约束及check约束；
ALTER table student
DROP CONSTRAINT check_1,check_2,check_3,check_4,check_5,A,B,cno_pk,sc_pk,snof,cnof

--13.	设计触发器实现如果一个学生转专业了，那么输出一条信息显示该学生各门课程的平均分。
GO
CREATE TRIGGER A ON student
FOR UPDATE
AS
DECLARE @Sno CHAR(9)
SELECT @Sno=Sno
FROM inserted
IF UPDATE(Sdept)
BEGIN
SELECT AVG(Grade)
FROM sc
WHERE Sno=@Sno
GROUP BY Cno
END
--14.	设计触发器实现如果成绩被修改了20分以上，则输出提示信息“修改成绩超过20分，请慎重”。
GO
CREATE TRIGGER B ON sc
FOR UPDATE
AS
IF UPDATE(Grade)
BEGIN
IF(ABS((SELECT Grade FROM deleted) - (SELECT Grade FROM inserted))>20)
BEGIN
PRINT'修改成绩超过20分，请慎重'
END
END

--15. 在student表中增加一列total,表示学生选课总门数，初始值为0。定义一个触发器，实现如下完整性约束：当向SC表插入选课记录时，自动更新student表对应学号的total值,考虑成批插入数据的情况。
ALTER table student
ADD total int DEFAULT(0)
GO
CREATE TRIGGER A ON sc
FOR INSERT
AS
UPDATE ABC
SET ABC.total=ABC.total+(
SELECT COUNT(*)
FROM inserted
WHERE ABC.sno=sno
GROUP BY Sno
)
FROM student ABC
WHERE ABC.sno IN (SELECT Sno FROM inserted)

--16.设计一触发器，约束数据库系统课程的课容量为120。
GO
CREATE TRIGGER control ON sc
FOR INSERT,DELETE
AS
DECLARE @count int
SET @count=(SELECT COUNT(*)
FROM sc JOIN course ON(sc.Cno=course.Cno)
WHERE Cname='数据库系统')
IF(@count>120)
BEGIN
print'超出课容量，课程已满'
ROLLBACK TRANSACTION
END

--16．设有两个表：商品库存表（商品编号，商品名称，库存数量，库存单价，库存金额）；商品销售表（商品编号，商品名称，购货商号，销售数量，销售单价，销售金额）；设计一触发器实现如下业务规则：
--（1）保证在商品库存表中插入的数据，库存金额 = 库存数量 * 库存单价。
--（2）如果销售的商品不存在库存或者库存为零，则返回提示信息。否则自动减少商品库存表中对应商品的库存数量和库存金额。建表并验证触发器的执行。
CREATE TABLE 商品库存表
(商品编号 NCHAR(10),
商品名称 NCHAR(10),
库存数量 int,
库存单价 int,
库存金额 int)

CREATE TABLE 商品销售表
(商品编号 NCHAR(10),
商品名称 NCHAR(10),
购货商号 CHAR(15),
销售数量 int,
销售单价 int,
销售金额 int)

GO
CREATE TRIGGER X ON 商品库存表
FOR INSERT,UPDATE
AS
UPDATE 商品库存表
SET 库存金额=库存数量*库存单价

GO
CREATE TRIGGER Y ON 商品销售表
FOR INSERT
AS
DECLARE @Sno NCHAR(10)
DECLARE @number int
SELECT @Sno=商品编号,@number=销售数量
FROM inserted
IF(@Sno NOT IN(SELECT 商品编号 FROM 商品库存表) OR (SELECT 库存数量 FROM 商品库存表)-@number<0 )
BEGIN
print'插入错误，商品库存中不存在该商品，或者库存数量不足'
END
ELSE 
BEGIN
UPDATE 商品库存表
SET 库存数量=库存数量-@number
WHERE 商品编号=@Sno
END

--17．建立教师表（教工编号，姓名，专业，职称，工资）和工资变化表（教工编号，原工资，新工资），设计触发器实现教授的工资不得低于4000元，如果低于4000元则自动改为4000元。
CREATE TABLE 教师表
(教工编号 CHAR(10),
姓名 NCHAR(10),
专业 NCHAR(10),
职称 NCHAR(10),
工资 int)

CREATE TABLE 工资变化表
(教工编号 CHAR(10),
原工资 int,
新工资 int)
GO
CREATE TRIGGER X ON 工资变化表
FOR UPDATE,INSERT
AS
DECLARE @Tno CHAR(10)
DECLARE @职称 NCHAR(10)
DECLARE @新工资 int
SET @新工资=(SELECT 新工资 FROM inserted)
SET @Tno=(SELECT 教工编号 FROM INSERTED)
SELECT @职称=职称
FROM 教师表
WHERE 教工编号=@Tno
IF(@新工资<4000 AND @职称='教授')
BEGIN
print'教授工资不可以低于4000，已修正为4000'
UPDATE 工资变化表
SET 新工资=4000
WHERE 教工编号=@Tno
END

--18.	使用第17题的两个表设计触发器实现如果教工的工资发生变化则向工资变化表插入一条记录，包含教工编号，原工资，新工资。
GO
CREATE TRIGGER Z ON 教师表
FOR UPDATE
AS
DECLARE @Tno CHAR(10)
DECLARE @原 int
DECLARE @新 int
SELECT @Tno=教工编号,@原=工资
FROM deleted
SELECT @新=工资
FROM inserted
IF UPDATE(工资)
BEGIN
INSERT 工资变化表
VALUES(@Tno,@原,@新)
END