/*例8.4.5 生成显示如下报表形式的游标：报表首先列出一门课程的课程号和课程名（只针对有人选的课程），然后在此课程下列出选了此门课程且成绩大于等于80的学生姓名、
所在系和此门课程的考试成绩；然后再列出下一门课程的课程号和课程名，然后在此课程下列出选了此门课程且成绩大于等于80的学生姓名、所在系和此门课程的考试成绩；依
此类推，直到列出全部课程。*/
DECLARE @Grade smallint,@Name nvarchar(10),@Dept varchar(20)
DECLARE @Cno smallint,@CName nvarchar(10)

DECLARE X CURSOR
FOR
SELECT DISTINCT course.Cno,Cname
FROM course JOIN sc ON(course.Cno=sc.Cno)

OPEN X

FETCH NEXT 
FROM X
INTO @Cno,@CName
WHILE(@@FETCH_STATUS=0)
BEGIN
print cast(@Cno AS CHAR(10))+' '+@CName
print'__________'

DECLARE Y CURSOR
FOR 
SELECT Sname,Sdept,Grade
FROM student JOIN sc ON (student.Sno=sc.Sno)
WHERE Grade>70 AND Cno=@Cno
OPEN Y
FETCH NEXT
FROM Y
INTO @Name,@Dept,@Grade

WHILE (@@FETCH_STATUS=0)
BEGIN
print @Name+' '+@Dept+' '+cast(@Grade AS CHAR(10))
FETCH NEXT
FROM Y
INTO @Name,@Dept,@Grade
END

DEALLOCATE Y

FETCH NEXT 
FROM X
INTO @Cno,@CName
END

DEALLOCATE X
