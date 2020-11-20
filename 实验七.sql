--1.	�ú���ʵ�֣���ĳ��רҵѡ����ĳ�ſγ̵�ѧ�������������ú�����������ϵ�����ݿ⡱�γ̵�ѡ��������
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
print dbo.Total_numer('CS','���ݿ�')
--2.	����Ƕ��ֵ����ʵ�֣���ѯĳ��רҵ����ѧ����ѡ��ÿ�ſε�ƽ���ɼ������øú�����������ϵ�����пγ̵�ƽ���ɼ���
GO
CREATE FUNCTION avggradeforcdept (@dept varchar(20))
RETURNS TABLE
AS
RETURN (SELECT AVG(Grade) as 'ƽ���ɼ� ' FROM sc JOIN student ON (sc.Cno=student.Sno) WHERE Sdept= @dept )
GO
SELECT *
FROM avggradeforcdept('CS')
--3.	����������ֵ������ͨ��ѧ����Ϊʵ�ε��øú���������ʾ��ѧ���������Լ����ſεĳɼ���ѧ�֣����øú��������200515002���ĸ��ſγɼ���ѧ�֡�
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

--4.	��дһ���洢���̣�ͳ��ĳ�ſγ̵����㣨90-100�����������ã�80-89���������еȣ�70-79������������60-69�������ͼ����ʣ�����������ǿγ̺ţ�
--������Ǹ����������������ʣ������ʵ���ʽ��90.25%��ִ�д洢���̣�����Ϣ����ʾ1�ſγ̵�ͳ����Ϣ��
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

--5.	����һ��������������Ĵ洢���̣��ô洢���̸��ݴ����ѧ�����֣���ѯ��ѡ�޵Ŀγ����ͳɼ���ִ�д洢���̣�����Ϣ����ʾ������������Ϣ��
GO
CREATE PROC Y @sname nvarchar(10)
AS 
SELECT Cname,Grade
FROM sc JOIN course ON(sc.Cno=course.Cno) JOIN student ON(sc.Sno=student.Sno)
WHERE Sname=@sname

EXEC Y '��ݼݼ'

--6.	�Ի����� courseΪ������������²���
--������ʾ���±�����ʽ���α꣺���������г�ѧ����ѧ�ź�������Ȼ���ڴ�ѧ���£��г�����ѡ��ȫ���γ̵Ŀγ̺š��γ�����ѧ�֣��������ƣ�ֱ���г�ȫ��ѧ����
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
--7.	�����һ���洢����ʵ�����й��ܣ��ж�ĳ��רҵĳ�ſγ̳ɼ�����Ϊn��ѧ���ĳɼ��Ƿ���ڸ��ſγ̵�ƽ���֣��������ƽ���֣�����ɼ���Ϊƽ���֣��������ѧ�š���������š��γ̺š��γ������ɼ�������ʾ�������ڴ洢�����ڲ�ʹ���α꣩��
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

EXEC changegradeforlow 'CS','���ݿ�',1
--8.	��student���ݿ���ƴ洢���̣�ʵ�ֽ�ĳ�ſγ̳ɼ����ڿγ�ƽ���ɼ���ѧ���ɼ�������3�֡�����ʾ����ʹ�ô洢�����ڲ�ʹ���α꣩
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

--9.	��ƴ洢����ʵ��ѧ��תרҵ���ܣ�ĳ��ѧ����ѧ�ţ���תרҵʱ�������ת���רҵ�Ǽ����רҵ��ôҪ���ѧ����ƽ���ɼ����볬��95�֣���������תרҵ����
--��תרҵ����Ϣ���뵽һ��תרҵ�ı��changesd(ѧ�ţ�ԭרҵ����רҵ��ƽ���ɼ�)
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
print'�ɼ�������Ҫ�󣬲�����תרҵ'
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
10.	����ͼ��������ݿ⣬ ���а������¼�����
���߱�reader(ѧ�ţ��������Ա����)
�����lend��ѧ�ţ���ţ��������ڣ�Ӧ�����ڣ��Ƿ����裩
Ƿ���debt(ѧ�ţ����ڣ�Ƿ����)
�����return(ѧ�ţ���ţ���������) 
�����һ���洢����ʵ������������������Ҫ�����£�
ֻ��û�г��ڵ���ſ������裨���������ʱ�䶼Ϊ30�죩�����޸�Ӧ�����ڣ�����ֻ�ܻ��飻����ʱɾ��������ڵĽ��ļ�¼����������в���һ�������¼��ע�⻹����
��Ϊ��ǰ���ڣ����ҶԳ���ͼ�飬���ճ��ڵ���������������ÿ��ÿ���鷣��0.1Ԫ��������������Ϣ���뵽Ƿ����У�ͬʱ������Ӷ��߱�������۳���
*/
CREATE TABLE reader(
ѧ�� char(9),
���� nvarchar(10),
�Ա� nchar(2),
��� int
)

CREATE TABLE lend(
ѧ�� char(9),
��� char(9),
�������� datetime,
Ӧ������ datetime,
�Ƿ����� nchar(1)
)

CREATE TABLE debt
(
ѧ�� char(9),
���� datetime,
Ƿ���� int
)

CREATE TABLE retur_n
(
ѧ�� char(9),
��� char(9),
�������� datetime
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

SELECT @lenddata=lend.��������
FROM lend
WHERE ѧ��=@Sno AND ���=@Bno

SET @time=DATEDIFF(DAY,@lenddata,GETDATE())
SET @debt=@time*0.1



IF(@cho=1)
BEGIN

IF(@time>30)
BEGIN
print'�����������ڣ��������裬�뻹��'
RETURN
END

UPDATE lend
SET Ӧ������=Ӧ������+30
WHERE ���=@Bno


END


IF(@cho=2)
BEGIN

DELETE 
FROM lend
WHERE ѧ��=@Sno AND ���=@Bno

INSERT INTO retur_n
VALUES(@Sno,@Bno,GETDATE())

IF(@time>30)
BEGIN

INSERT debt
VALUES(@Sno,GETDATE(),@debt)

UPDATE reader
SET ���=���-@debt
WHERE ѧ��=@Sno

END


END

