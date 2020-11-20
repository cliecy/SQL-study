--1.	用函数实现：求某个专业选修了某门课程的学生人数，并调用函数求出计算机系“数据库”课程的选课人数。
GO
CREATE FUNCTION Total_numer (@dept varchar(20),@cname nvarchar(10))
RETURNS int
BEGIN
DECLARE @output int;
SELECT @output=COUNT(*)
FROM sc JOIN course ON(course.Cno=sc.Cno) JOIN  student ON(sc.Sno=student.Sno)
WHERE Sdept=@dept AND Cname=@cname;
RETURN @output;
END
GO
print dbo.Total_numer('CS','数据库')
--2.	用内嵌表值函数实现：查询某个专业所有学生所选的每门课的平均成绩；调用该函数求出计算机系的所有课程的平均成绩。
GO
CREATE FUNCTION avggradeforcdept (@dept varchar(20))
RETURNS TABLE
AS
RETURN (SELECT AVG(Grade) as '平均成绩 ' FROM sc JOIN student ON (sc.Cno=student.Sno) WHERE Sdept= @dept )
GO
SELECT *
FROM avggradeforcdept('CS')
--3.	创建多语句表值函数，通过学号作为实参调用该函数，可显示该学生的姓名以及各门课的成绩和学分，调用该函数求出“200515002”的各门课成绩和学分。
GO
CREATE FUNCTION XYZ (@sno char(9))
RETURNS @OUTPUT TABLE(
Sname nvarchar(10),
Cname nvarchar(10),
grade smallint,
credit smallint
)
AS
BEGIN
INSERT @OUTPUT
SELECT Sname,Cname,Grade,Ccredit
FROM sc JOIN course ON(course.Cno=sc.Cno) JOIN  student ON(sc.Sno=student.Sno)
WHERE student.Sno=@sno
RETURN
END

SELECT *
FROM XYZ('200515002')

--4.	编写一个存储过程，统计某门课程的优秀（90-100）人数、良好（80-89）人数、中等（70-79）人数、及格（60-69）人数和及格率，其输入参数是课程号，
--输出的是各级别人数及及格率，及格率的形式是90.25%，执行存储过程，在消息区显示1号课程的统计信息。
GO
CREATE PROC X @cno smallint
AS 
DECLARE @X int
DECLARE @Y int
DECLARE @Z int
DECLARE @A int
DECLARE @B float
SELECT @X=COUNT(*)
FROM sc
WHERE Cno=@cno AND Grade BETWEEN 90 AND 100 
SELECT @Y=COUNT(*)
FROM sc
WHERE Cno=@cno AND Grade BETWEEN 80 AND 89
SELECT @Z=COUNT(*)
FROM sc
WHERE Cno=@cno AND Grade BETWEEN 70 AND 79
SELECT @A=COUNT(*)
FROM sc
WHERE Cno=@cno AND Grade BETWEEN 60 AND 69
SET @B=cast((SELECT COUNT(*) FROM sc WHERE Grade>=60 AND Cno =@cno) as float)/cast((SELECT COUNT(*) FROM sc WHERE Cno=@cno) as float)
PRINT str(@X)+' '+str(@Y)+' '+str(@Z)+' '+str(@A)+' '+str(@B*100)+'%'

EXEC X 1

--5.	创建一个带有输入参数的存储过程，该存储过程根据传入的学生名字，查询其选修的课程名和成绩，执行存储过程，在消息区显示赵箐箐的相关信息。
GO
CREATE PROC Y @sname nvarchar(10)
AS 
SELECT Cname,Grade
FROM sc JOIN course ON(sc.Cno=course.Cno) JOIN student ON(sc.Sno=student.Sno)
WHERE Sname=@sname

EXEC Y '赵菁菁'

--6.	以基本表 course为基础，完成如下操作
--生成显示如下报表形式的游标：报表首先列出学生的学号和姓名，然后在此学生下，列出其所选的全部课程的课程号、课程名和学分；依此类推，直到列出全部学生。
GO
DECLARE @sno char(9)
DECLARE @sname nvarchar(10)
DECLARE @cno smallint
DECLARE @cname nvarchar(10)
DECLARE @credit smallint

DECLARE M1 SCROLL CURSOR
FOR SELECT Sno,Sname
FROM student

OPEN M1
FETCH NEXT FROM M1 INTO @sno,@sname

WHILE(@@FETCH_STATUS=0)
BEGIN
print @sno+' '+@sname
DECLARE M2 SCROLL CURSOR
FOR SELECT course.Cno,Cname,Ccredit
FROM course JOIN sc ON(course.Cno=sc.Cno)
WHERE Sno=@sno
OPEN M2
FETCH NEXT FROM M2 INTO @cno,@cname,@credit
WHILE(@@FETCH_STATUS=0)
BEGIN
print cast(@cno as varchar(20))+' '+@cname+' '+cast(@credit as char(4))
FETCH NEXT FROM M2 INTO @cno,@cname,@credit
END
CLOSE M2
DEALLOCATE M2
FETCH NEXT FROM M1 INTO @sno,@sname
END
CLOSE M1
DEALLOCATE M1
--7.	请设计一个存储过程实现下列功能：判断某个专业某门课程成绩排名为n的学生的成绩是否低于该门课程的平均分，如果低于平均分，则将其成绩改为平均分，否则输出学号、姓名、班号、课程号、课程名、成绩。（提示：可以在存储过程内部使用游标）。
GO
CREATE PROC changegradeforlow
@dept varchar(20),
@cname nvarchar(10),
@n int
AS
DECLARE @count int
DECLARE @preS char(9)
DECLARE @preG smallint

DECLARE youbiao SCROLL CURSOR
FOR SELECT student.Sno,Grade
FROM sc JOIN student ON(sc.Sno=student.Sno) JOIN course ON (sc.Cno=course.Cno)
WHERE Sdept=@dept AND Cname =@cname
ORDER BY Grade DESC

SET @count=0
OPEN youbiao
WHILE @count<@n
BEGIN
FETCH NEXT FROM youbiao INTO @preS,@preG
SET @count=@count+1
END

IF(@preG<(SELECT AVG(Grade) FROM sc JOIN course ON(sc.Cno=course.Cno) WHERE Cname=@cname ))
BEGIN
UPDATE sc
SET Grade=(SELECT AVG(Grade) FROM sc JOIN course ON(sc.Cno=course.Cno) WHERE Cname=@cname )
WHERE Sno=@preS
END
ELSE
BEGIN
SELECT student.Sno,Sdept,course.Cno,Cname,Grade
FROM sc JOIN student ON(sc.Sno=student.Sno) JOIN course ON (sc.Cno=course.Cno)
WHERE student.Sno=@preS
END
DEALLOCATE youbiao

EXEC changegradeforlow 'CS','数据库',1
--8.	对student数据库设计存储过程，实现将某门课程成绩低于课程平均成绩的学生成绩都加上3分。（提示可以使用存储过程内部使用游标）
GO
CREATE PROC plusthree 
@cname nvarchar(10)
AS
DECLARE P1 SCROLL CURSOR
FOR SELECT Grade
FROM sc JOIN course ON (sc.Cno=course.Cno)
WHERE Cname=@cname



DECLARE @preG smallint
DECLARE @avg smallint

SELECT @avg=Grade
FROM sc JOIN course ON(sc.Cno=course.Cno)
WHERE Cname=@cname

OPEN P1
FETCH NEXT FROM P1 INTO @preG

WHILE(@@FETCH_STATUS=0)
BEGIN

IF(@preG<@avg)
BEGIN
UPDATE sc
SET Grade=Grade+3
WHERE CURRENT OF P1
END
FETCH NEXT FROM P1 INTO @preG
END
DEALLOCATE P1

--9.	设计存储过程实现学生转专业功能：某个学生（学号）在转专业时，如果想转入的专业是计算机专业那么要求该学生的平均成绩必须超过95分，否则不允许转专业，并
--将转专业的信息插入到一个转专业的表里，changesd(学号，原专业，新专业，平均成绩)
CREATE TABLE changesd(
Sno char(9),
pSdept varchar(20),
aSdept varchar(20),
Avggrade smallint
)

GO
CREATE PROC changedept
@sno char(9),
@dept varchar(20)
AS
IF(@dept='CS' AND (SELECT AVG(Grade) FROM sc WHERE Sno=@sno)<95)

BEGIN
print'成绩不满足要求，不允许转专业'
RETURN
END

ELSE

BEGIN
INSERT 
INTO changesd
SELECT student.Sno,Sdept,@dept,AVG(Grade)
FROM sc JOIN student ON(sc.Sno=student.Sno)
END


/*
10.	现有图书管理数据库， 其中包含如下几个表：
读者表：reader(学号，姓名，性别，余额)
借书表：lend（学号，书号，借书日期，应还日期，是否续借）
欠款表：debt(学号，日期，欠款金额)
还书表：return(学号，书号，还书日期) 
请设计一个存储过程实现续借或还书操作，具体要求如下：
只有没有超期的书才可以续借（借书和续借时间都为30天），并修改应还日期，否则只能还书；还书时删除借书表内的借阅记录，并向还书表中插入一条还书记录，注意还书日
期为当前日期，并且对超期图书，按照超期的天数计算出罚款金额（每天每本书罚款0.1元），并将罚款信息插入到欠款表中，同时将罚款从读者表的余额里扣除。
*/
CREATE TABLE reader(
学号 char(9),
姓名 nvarchar(10),
性别 nchar(2),
余额 int
)

CREATE TABLE lend(
学号 char(9),
书号 char(9),
借书日期 datetime,
应还日期 datetime,
是否续借 nchar(1)
)

CREATE TABLE debt
(
学号 char(9),
日期 datetime,
欠款金额 int
)

CREATE TABLE retur_n
(
学号 char(9),
书号 char(9),
还书日期 datetime
)
GO
CREATE PROC forbookdb
@cho int,
@Bno char(9),
@Sno char(9)
AS
DECLARE @lenddata datetime
DECLARE @time int
DECLARE @debt int

SELECT @lenddata=lend.借书日期
FROM lend
WHERE 学号=@Sno AND 书号=@Bno

SET @time=DATEDIFF(DAY,@lenddata,GETDATE())
SET @debt=@time*0.1



IF(@cho=1)
BEGIN

IF(@time>30)
BEGIN
print'超出还书日期，不能续借，请还书'
RETURN
END

UPDATE lend
SET 应还日期=应还日期+30
WHERE 书号=@Bno


END


IF(@cho=2)
BEGIN

DELETE 
FROM lend
WHERE 学号=@Sno AND 书号=@Bno

INSERT INTO retur_n
VALUES(@Sno,@Bno,GETDATE())

IF(@time>30)
BEGIN

INSERT debt
VALUES(@Sno,GETDATE(),@debt)

UPDATE reader
SET 余额=余额-@debt
WHERE 学号=@Sno

END


END

