SELECT *
FROM student
WHERE Sname NOT LIKE '��%';

SELECT *
FROM student
WHERE Sage>(SELECT AVG(Sage) FROM student)
ORDER BY Sage DESC

SELECT *
FROM student
WHERE year(getdate())-Sage>1985

SELECT *
FROM course
WHERE Cname LIKE '%����%'

SELECT Sno,Sname,Ssex,Sdept
FROM student
WHERE Sno LIKE '________[12349]'OR Sno LIKE '_______[12349]_'

SELECT Sno,Grade
FROM sc
WHERE Cno=1
ORDER BY Grade DESC
/*�о���β�̫��
*/
SELECT Sno,AVG(Grade) as 'ƽ���ɼ�',COUNT(*) as 'ѡ������'
FROM sc
GROUP BY Sno
HAVING COUNT(*)>3   

SELECT *
FROM course
ORDER BY Cpno ASC

SELECT  Cno,AVG(Grade) as 'ƽ����'
FROM sc
GROUP BY Cno
HAVING AVG(Grade)>80

SELECT Sno as 'ѧ��',Sname as '����',Ssex as '�Ա�',year(getdate())-Sage as '�������',Sdept as 'Ժϵ'
FROM student
ORDER BY ������� ASC /*Ϊʲô����ֱ��д Ȼ���ASC �ᱨ��*/

SELECT Sno,Cno,Grade
FROM sc
WHERE Grade BETWEEN 70 AND 80

SELECT COUNT(*) as ѧ��������,AVG(Sage) as ƽ������
FROM student

SELECT Sdept,COUNT(*) as '����'
FROM student
WHERE Sname LIKE '��%'
GROUP BY Sdept

SELECT Cno,COUNT(*) as '����',MAX(Grade)as '��߳ɼ�',MIN(Grade)as '��ͳɼ�' ,AVG(Grade) as 'ƽ���ɼ�'
FROM sc
GROUP BY Cno
ORDER BY Cno

SELECT TOP 1 Sno
FROM sc
GROUP BY Sno
ORDER BY COUNT(*) DESC


SELECT Sno,AVG(Grade) as 'ƽ���ɼ�'
FROM sc
WHERE Grade<60
GROUP BY Sno
HAVING COUNT(*)>=2

SELECT TOP(5) Sno,Grade
FROM sc
WHERE Cno=1
ORDER BY Grade DESC

SELECT Sno,MIN(Grade) as '��ͳɼ�',COUNT(*) 'ѡ������'
FROM sc
GROUP BY Sno;


SELECT Sdept,Ssex,COUNT(*)
FROM student
GROUP BY Sdept,Ssex

SELECT LEFT(Sname,1) as '����',COUNT(*) as '����'
FROM student
GROUP BY LEFT(Sname,1)




SELECT SNO
FROM SPJ
WHERE JNO='J1'

SELECT SNO,JNO,COUNT(*) as '�������'
FROM SPJ
GROUP BY SNO,JNO

SELECT DISTINCT JNO 
FROM SPJ
WHERE PNO='P3' AND QTY>200

SELECT PNO,PNAME
FROM P
WHERE COLOR='��' OR COLOR='��'   

SELECT JNO
FROM SPJ
GROUP BY JNO
HAVING SUM(QTY) BETWEEN 200 AND 400    -

SELECT PNO,COUNT(*) AS '������'
FROM SPJ
GROUP BY PNO





