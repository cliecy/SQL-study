SELECT *
FROM student
WHERE Sname NOT LIKE '刘%';

SELECT *
FROM student
WHERE Sage>(SELECT AVG(Sage) FROM student)
ORDER BY Sage DESC

SELECT *
FROM student
WHERE year(getdate())-Sage>1985

SELECT *
FROM course
WHERE Cname LIKE '%数据%'

SELECT Sno,Sname,Ssex,Sdept
FROM student
WHERE Sno LIKE '________[12349]'OR Sno LIKE '_______[12349]_'

SELECT Sno,Grade
FROM sc
WHERE Cno=1
ORDER BY Grade DESC
/*感觉这段不太好
*/
SELECT Sno,AVG(Grade) as '平均成绩',COUNT(*) as '选修门数'
FROM sc
GROUP BY Sno
HAVING COUNT(*)>3   

SELECT *
FROM course
ORDER BY Cpno ASC

SELECT  Cno,AVG(Grade) as '平均分'
FROM sc
GROUP BY Cno
HAVING AVG(Grade)>80

SELECT Sno as '学号',Sname as '姓名',Ssex as '性别',year(getdate())-Sage as '出生年份',Sdept as '院系'
FROM student
ORDER BY 出生年份 ASC /*为什么不能直接写 然后加ASC 会报错啊*/

SELECT Sno,Cno,Grade
FROM sc
WHERE Grade BETWEEN 70 AND 80

SELECT COUNT(*) as 学生总人数,AVG(Sage) as 平均年龄
FROM student

SELECT Sdept,COUNT(*) as '人数'
FROM student
WHERE Sname LIKE '张%'
GROUP BY Sdept

SELECT Cno,COUNT(*) as '人数',MAX(Grade)as '最高成绩',MIN(Grade)as '最低成绩' ,AVG(Grade) as '平均成绩'
FROM sc
GROUP BY Cno
ORDER BY Cno

SELECT TOP 1 Sno
FROM sc
GROUP BY Sno
ORDER BY COUNT(*) DESC


SELECT Sno,AVG(Grade) as '平均成绩'
FROM sc
WHERE Grade<60
GROUP BY Sno
HAVING COUNT(*)>=2

SELECT TOP(5) Sno,Grade
FROM sc
WHERE Cno=1
ORDER BY Grade DESC

SELECT Sno,MIN(Grade) as '最低成绩',COUNT(*) '选课门数'
FROM sc
GROUP BY Sno;


SELECT Sdept,Ssex,COUNT(*)
FROM student
GROUP BY Sdept,Ssex

SELECT LEFT(Sname,1) as '姓氏',COUNT(*) as '人数'
FROM student
GROUP BY LEFT(Sname,1)




SELECT SNO
FROM SPJ
WHERE JNO='J1'

SELECT SNO,JNO,COUNT(*) as '零件数量'
FROM SPJ
GROUP BY SNO,JNO

SELECT DISTINCT JNO 
FROM SPJ
WHERE PNO='P3' AND QTY>200

SELECT PNO,PNAME
FROM P
WHERE COLOR='蓝' OR COLOR='红'   

SELECT JNO
FROM SPJ
GROUP BY JNO
HAVING SUM(QTY) BETWEEN 200 AND 400    -

SELECT PNO,COUNT(*) AS '工程数'
FROM SPJ
GROUP BY PNO





