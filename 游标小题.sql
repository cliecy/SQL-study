/*��8.4.5 ������ʾ���±�����ʽ���α꣺���������г�һ�ſγ̵Ŀγ̺źͿγ�����ֻ�������ѡ�Ŀγ̣���Ȼ���ڴ˿γ����г�ѡ�˴��ſγ��ҳɼ����ڵ���80��ѧ��������
����ϵ�ʹ��ſγ̵Ŀ��Գɼ���Ȼ�����г���һ�ſγ̵Ŀγ̺źͿγ�����Ȼ���ڴ˿γ����г�ѡ�˴��ſγ��ҳɼ����ڵ���80��ѧ������������ϵ�ʹ��ſγ̵Ŀ��Գɼ�����
�����ƣ�ֱ���г�ȫ���γ̡�*/
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
