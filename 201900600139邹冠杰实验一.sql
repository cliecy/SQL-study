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

INSERT //插入的时候，没有找到批量插入的语法，所以就重复使用了INSERT INTO语句
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES ('200515001','赵菁菁',    '女'          ,23             ,'CS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515002','李勇',	'男',	20	,'CS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515003','张力',	'男',	19	,'CS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515004','张衡',	'男',	18	,'IS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515005','张向东',    '男',	20	,'IS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515006','张向丽',     '女',	20	,'IS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515007','王芳',	'女',	20	,'CS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515008','王民生',	'男',	25	,'MA')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515009','王小民',	'女',	18	,'MA')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515010','李辰',	'女',	22	,'MA')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515011','张毅',	'男',	20	,'WM')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515012','杨磊',	'女',	20	,'EN')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515013','李晨',	'女',	19	,'MA')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515014','张丰毅'     ,'男',	22	,'CS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515015','李蕾',	'女',	21	,'EN')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515016','刘社',	'男',	21	,'CM')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515017','刘星耀',	'男',	18	,'CM')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515018','李贵',	'男',	19	,'EN')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515019','林自许',	'男',	20	,'WM')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515020','马翔',	'男',	21	,NULL)
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515021','刘峰',	'男',	25	,'CS')
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515022','刘峰',	'男',	22	,NULL)
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515023','李婷婷',	'女',	18	,NULL)
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515024','严丽',	'女',	20	,NULL)
INSERT
INTO student(Sno,Sname,Ssex,Sage,Sdept)
VALUES('200515025','朱小鸥',	'女',	30	,'WM')
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(1,'数据库',5,4)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(2,'数学',NULL,2)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(3,'信息系统',1,4)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(4,'操作系统',6,3)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(5,'数据结构',7,4)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(6,'数据处理',NULL,2)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(7,'PASCAL语言',6,4)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(8,'大学英语',NULL,4)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(9,'计算机网络',NULL,4)
INSERT
INTO course(Cno,Cname,Cpno,Ccredit)
VALUES(10,'人工智能',NULL,2)
     

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
DROP COLUMN phone    //输入CASACDE时语法报错
