CREATE TABLE student (Sno CHAR(9) PRIMARY KEY
,Sname NVARCHAR(10) NOT NULL
,Ssex nchar(1)
,Sage SMALLINT
,Sdept CHAR(2))

CREATE TABLE course (Cno SMALLINT PRIMARY KEY
,Cname NVARCHAR(10)
,Cpno SMALLINT
,Ccredit SMALLINT)

CREATE TABLE sc(Sno CHAR(9)
,Cno SMALLINT
,Grade SMALLINT
PRIMARY KEY(Sno,Cno),
FOREIGN KEY(Sno) REFERENCES student(Sno),
FOREIGN KEY(Cno) REFERENCES course(Cno)
)

INSERT //�����ʱ��û���ҵ�����������﷨�����Ծ��ظ�ʹ����INSERT INTO���
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES ('200515001','��ݼݼ',    'Ů'          ,23             ,'CS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515002','����',	'��',	20	,'CS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515003','����',	'��',	19	,'CS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515004','�ź�',	'��',	18	,'IS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515005','����',    '��',	20	,'IS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515006','������',     'Ů',	20	,'IS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515007','����',	'Ů',	20	,'CS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515008','������',	'��',	25	,'MA')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515009','��С��',	'Ů',	18	,'MA')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515010','�',	'Ů',	22	,'MA')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515011','����',	'��',	20	,'WM')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515012','����',	'Ů',	20	,'EN')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515013','�',	'Ů',	19	,'MA')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515014','�ŷ���'     ,'��',	22	,'CS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515015','����',	'Ů',	21	,'EN')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515016','����',	'��',	21	,'CM')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515017','����ҫ',	'��',	18	,'CM')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515018','���',	'��',	19	,'EN')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515019','������',	'��',	20	,'WM')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515020','����',	'��',	21	,NULL)
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515021','����',	'��',	25	,'CS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515022','����',	'��',	22	,NULL)
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515023','������',	'Ů',	18	,NULL)
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515024','����',	'Ů',	20	,NULL)
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515025','��СŸ',	'Ů',	30	,'WM')
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(1,'���ݿ�',5,4)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(2,'��ѧ',NULL,2)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(3,'��Ϣϵͳ',1,4)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(4,'����ϵͳ',6,3)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(5,'���ݽṹ',7,4)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(6,'���ݴ���',NULL,2)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(7,'PASCAL����',6,4)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(8,'��ѧӢ��',NULL,4)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(9,'���������',NULL,4)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(10,'�˹�����',NULL,2)
     

INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515001',1,75)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515002',1,85)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515002',3,53)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515003',1,86)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515004',1,74)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515005',1,58)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515006',1,84)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515004',2,46)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515005',2,89)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515006',2,65)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515008',2,72)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515009',2,76)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515010',2,96)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515010',8,86)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515011',8,62)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515015',8,0)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515018',8,58)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515001',4,62)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515002',4,85)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515021',9,54)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515001',5,58)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515021',6,58)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515001',7,70)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515005',10,65)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515016',8,NULL)
INSERT
INTO Sc(Sno,Cno,Grade)
VALUES('200515017',8,NULL)

ALTER TABLE student
ADD phone char(11)
ALTER TABLE student
ADD e_mail char(20)
ALTER TABLE student
ALTER COLUMN Sdept VARCHAR(20)
ALTER TABLE student
DROP COLUMN phone    //����CASACDEʱ�﷨����
