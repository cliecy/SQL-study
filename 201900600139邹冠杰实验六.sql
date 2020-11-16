--��ϵͳ����Ա��ݵ�¼��SQL Server����������ʹ��T-SQL���ʵ�����²�����
--1.	��stu���ݿ���student���sno����Ϊ����
ALTER table student
ADD CONSTRAINT A PRIMARY KEY(sno)

--2.	�����ݿ�stu�ı�course��cno�ֶζ���Ϊ������Լ������Ϊcno_pk;
ALTER table course
ADD CONSTRAINT cno_pk PRIMARY KEY(cno)

--3.	Ϊ��course�е��ֶ�cname���ΨһֵԼ����
ALTER table course
ADD CONSTRAINT B UNIQUE

--4.	�����ݿ�stu�ı�sc��sno��cno�ֶ���϶���Ϊ������Լ������Ϊsc_pk;
ALTER table sc
ADD CONSTRAINT sc_pk PRIMARY KEY(sno,cno)

/*5.	�������ݱ�sc��sno��cno�ֶζ���Ϊ���룬ʹ֮���student������sno����course������cno��Ӧ��ʵ�����²��������ԣ�
1)	ɾ��student���м�¼��ͬʱɾ��sc������ü�¼sno�ֶ�ֵ��ͬ�ļ�¼��
2)	�޸�student��ĳ��¼��snoʱ����sc��������ֶ�ֵ��Ӧ������������¼����ܾ��޸ģ�
3)	�޸�course��cno�ֶ�ֵʱ�����ֶ���sc���еĶ�ӦֵҲӦ�޸ģ�
4)	ɾ��course��һ����¼ʱ�������ֶ�����sc���д��ڣ���ɾ�����ֶζ�Ӧ�ļ�¼��
5)	��sc����Ӽ�¼ʱ������ü�¼��sno�ֶε�ֵ��student�в����ڣ���ܾ�����*/
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
PRINT('�ܾ��޸�')
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
PRINT('�ܾ�����')
ROLLBACK TRANSACTION
END

--6.	����checkԼ����Ҫ��ѧ��ѧ��sno����Ϊ9λ�����ַ����Ҳ�����0��ͷ���ڶ���λ��Ϊ0��
ALTER table student
ADD CONSTRAINT check_1 CHECK(Sno LIKE '[^0]00______' )

--7.	����stu���ݿ���student����ѧ������ֵ��16-25��Χ�ڣ�
ALTER table student
ADD CONSTRAINT check_2 CHECK(Sage BETWEEN 16 AND 25)

--8.	����stu���ݿ���student����ѧ������������2-8֮��
ALTER table student
ADD CONSTRAINT check_3 CHECK(len(Sname) BETWEEN 2 AND 8)

--9.	����stu���ݿ���student����ѧ���Ա�����ֻ�����롰�С���Ů����
ALTER table student
ADD CONSTRAINT check_4 CHECK(Ssex LIKE [��Ů])

--10.	����stu���ݿ�student����ѧ������ֵĬ��ֵΪ20
ALTER table student
ADD CONSTRAINT defalut_1 DEFAULT(20) FOR Sage

--11.	�޸�student��ѧ��������ֵԼ������Ϊ15-30��Χ�ڣ�
ALTER table student
ADD CONSTRAINT check_5 CHECK(Sage BETWEEN 15 AND 30)

--12.	ɾ������ΨһֵԼ�������Լ����checkԼ����
ALTER table student
DROP CONSTRAINT check_1,check_2,check_3,check_4,check_5,A,B,cno_pk,sc_pk,snof,cnof

--13.	��ƴ�����ʵ�����һ��ѧ��תרҵ�ˣ���ô���һ����Ϣ��ʾ��ѧ�����ſγ̵�ƽ���֡�
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
--14.	��ƴ�����ʵ������ɼ����޸���20�����ϣ��������ʾ��Ϣ���޸ĳɼ�����20�֣������ء���
GO
CREATE TRIGGER B ON sc
FOR UPDATE
AS
IF UPDATE(Grade)
BEGIN
IF(ABS((SELECT Grade FROM deleted) - (SELECT Grade FROM inserted))>20)
BEGIN
PRINT'�޸ĳɼ�����20�֣�������'
END
END

--15. ��student��������һ��total,��ʾѧ��ѡ������������ʼֵΪ0������һ����������ʵ������������Լ��������SC�����ѡ�μ�¼ʱ���Զ�����student���Ӧѧ�ŵ�totalֵ,���ǳ����������ݵ������
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

--16.���һ��������Լ�����ݿ�ϵͳ�γ̵Ŀ�����Ϊ120��
GO
CREATE TRIGGER control ON sc
FOR INSERT,DELETE
AS
DECLARE @count int
SET @count=(SELECT COUNT(*)
FROM sc JOIN course ON(sc.Cno=course.Cno)
WHERE Cname='���ݿ�ϵͳ')
IF(@count>120)
BEGIN
print'�������������γ�����'
ROLLBACK TRANSACTION
END

--16��������������Ʒ������Ʒ��ţ���Ʒ���ƣ������������浥�ۣ���������Ʒ���۱���Ʒ��ţ���Ʒ���ƣ������̺ţ��������������۵��ۣ����۽������һ������ʵ������ҵ�����
--��1����֤����Ʒ�����в�������ݣ������ = ������� * ��浥�ۡ�
--��2��������۵���Ʒ�����ڿ����߿��Ϊ�㣬�򷵻���ʾ��Ϣ�������Զ�������Ʒ�����ж�Ӧ��Ʒ�Ŀ�������Ϳ���������֤��������ִ�С�
CREATE TABLE ��Ʒ����
(��Ʒ��� NCHAR(10),
��Ʒ���� NCHAR(10),
������� int,
��浥�� int,
����� int)

CREATE TABLE ��Ʒ���۱�
(��Ʒ��� NCHAR(10),
��Ʒ���� NCHAR(10),
�����̺� CHAR(15),
�������� int,
���۵��� int,
���۽�� int)

GO
CREATE TRIGGER X ON ��Ʒ����
FOR INSERT,UPDATE
AS
UPDATE ��Ʒ����
SET �����=�������*��浥��

GO
CREATE TRIGGER Y ON ��Ʒ���۱�
FOR INSERT
AS
DECLARE @Sno NCHAR(10)
DECLARE @number int
SELECT @Sno=��Ʒ���,@number=��������
FROM inserted
IF(@Sno NOT IN(SELECT ��Ʒ��� FROM ��Ʒ����) OR (SELECT ������� FROM ��Ʒ����)-@number<0 )
BEGIN
print'���������Ʒ����в����ڸ���Ʒ�����߿����������'
END
ELSE 
BEGIN
UPDATE ��Ʒ����
SET �������=�������-@number
WHERE ��Ʒ���=@Sno
END

--17��������ʦ���̹���ţ�������רҵ��ְ�ƣ����ʣ��͹��ʱ仯���̹���ţ�ԭ���ʣ��¹��ʣ�����ƴ�����ʵ�ֽ��ڵĹ��ʲ��õ���4000Ԫ���������4000Ԫ���Զ���Ϊ4000Ԫ��
CREATE TABLE ��ʦ��
(�̹���� CHAR(10),
���� NCHAR(10),
רҵ NCHAR(10),
ְ�� NCHAR(10),
���� int)

CREATE TABLE ���ʱ仯��
(�̹���� CHAR(10),
ԭ���� int,
�¹��� int)
GO
CREATE TRIGGER X ON ���ʱ仯��
FOR UPDATE,INSERT
AS
DECLARE @Tno CHAR(10)
DECLARE @ְ�� NCHAR(10)
DECLARE @�¹��� int
SET @�¹���=(SELECT �¹��� FROM inserted)
SET @Tno=(SELECT �̹���� FROM INSERTED)
SELECT @ְ��=ְ��
FROM ��ʦ��
WHERE �̹����=@Tno
IF(@�¹���<4000 AND @ְ��='����')
BEGIN
print'���ڹ��ʲ����Ե���4000��������Ϊ4000'
UPDATE ���ʱ仯��
SET �¹���=4000
WHERE �̹����=@Tno
END

--18.	ʹ�õ�17�����������ƴ�����ʵ������̹��Ĺ��ʷ����仯�����ʱ仯�����һ����¼�������̹���ţ�ԭ���ʣ��¹��ʡ�
GO
CREATE TRIGGER Z ON ��ʦ��
FOR UPDATE
AS
DECLARE @Tno CHAR(10)
DECLARE @ԭ int
DECLARE @�� int
SELECT @Tno=�̹����,@ԭ=����
FROM deleted
SELECT @��=����
FROM inserted
IF UPDATE(����)
BEGIN
INSERT ���ʱ仯��
VALUES(@Tno,@ԭ,@��)
END