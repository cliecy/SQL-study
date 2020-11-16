--1.	��ѯ�ԡ�DB_����ͷ,�ҵ�����3���ַ�Ϊ��s���Ŀγ̵���ϸ�����
SELECT *
FROM course
WHERE Cname LIKE 'DB\_%s__' ESCAPE '\';

--2.	��ѯ�����е�2����Ϊ��������ѧ��������ѧ�ż�ѡ�޵Ŀγ̺š��γ�����
SELECT student.Sno,Sname,course.Cno,Cname
FROM student,sc,course
WHERE student.Sno=sc.Sno AND sc.Cno=course.Cno AND Sname Like '_��%'

--3.	�г�ѡ���ˡ���ѧ�����ߡ���ѧӢ���ѧ��ѧ�š�����������Ժϵ��ѡ�޿γ̺ż��ɼ���
SELECT student.Sno,Sname,course.Cno,Grade
FROM student,sc,course
WHERE student.Sno=sc.Sno AND sc.Cno=course.Cno AND Cname IN ('��ѧӢ��','��ѧ')

--4.	��ѯȱ�ٳɼ�������ѧ������ϸ�����
SELECT student.Sno,Sname,Sdept,Sage
FROM student,sc
WHERE student.Sno=sc.Sno AND Grade IS NULL

--5.	��ѯ�롮������(��������Ψһ)���䲻ͬ������ѧ������Ϣ��
SELECT student.Sno,Sname,Sdept,Sage
FROM student
WHERE Sage !=(
SELECT Sage
FROM student
WHERE Sname='����'
)
--6.	��ѯ��ѡ�γ̵�ƽ���ɼ�����������ƽ���ɼ���ѧ��ѧ�š�������ƽ���ɼ���
SELECT student.Sno,Sname,AVG(Grade) as'ƽ���ɼ�'
FROM sc,student
WHERE student.Sno=sc.Sno
GROUP BY student.Sno,Sname
HAVING AVG(Grade)>(
SELECT AVG(Grade)
FROM sc,student
WHERE sc.Sno=student.Sno AND Sname='����'
)

--7.	���ա�ѧ�ţ�����������Ժϵ������ѧ�֡���˳���г�ѧ��ѧ�ֵĻ���������������ѧ��Ϊ�����Ѿ�����Ŀγ�ѧ��֮�ͣ�
SELECT student.Sno,Sname,Sdept,SUM(Ccredit) as'����ѧ��'
FROM student,sc,course
WHERE student.Sno=sc.Sno AND sc.Cno=course.Cno AND Grade>=60
GROUP BY student.Sno,Sname,Sdept

--8.	�г�ֻѡ��һ�ſγ̵�ѧ����ѧ�š�������Ժϵ���ɼ���
SELECT student.Sno,Sname,Sdept,Grade
FROM student,sc
WHERE student.Sno=sc.Sno
GROUP BY student.Sno,Sname,Sdept,Grade
HAVING COUNT(Grade)=1

--9.	����ѡ��������һ�ź�����ѡ�޿γ�һ����ѧ����ѧ�š��������γ̺ţ�
SELECT student.Sno,Sname,course.Cno
FROM student,sc X,course
WHERE student.Sno=X.Sno AND X.Cno=course.Cno AND
EXISTS(
SELECT *
FROM student,sc Y
WHERE student.Sno=Y.Sno AND Sname='����' AND X.Cno=Y.Cno
)

--10.	��ѯ����ѡ�ޡ����ݿ⡱�͡����ݽṹ���γ̵�ѧ���Ļ�����Ϣ��
SELECT X.Sno,Sname,Sdept,Sage
FROM student X --JOIN sc  ON (X.Sno=sc.Sno)
WHERE EXISTS(
SELECT *
FROM student Y,sc,course
WHERE Y.Sno=sc.Sno AND sc.Cno=course.Cno AND Y.Sno=X.Sno AND Cname='���ݿ�'

)
AND EXISTS(
SELECT *
FROM student Y,sc,course
WHERE Y.Sno=sc.Sno AND sc.Cno=course.Cno AND Y.Sno=X.Sno AND Cname='���ݽṹ'

)

--11.	��ѯû��ѡ��������ѡ�޵�ȫ���γ̵�ѧ����������
SELECT Sname
FROM student
EXCEPT 
SELECT Sname
FROM student JOIN sc ON(student.Sno=sc.Sno)
WHERE Cno IN(
SELECT Cno
FROM student JOIN sc ON(student.Sno=sc.Sno)
WHERE student.Sname='����'
)

--12.	��ѯÿ��רҵ���䳬����רҵƽ�������ѧ����������רҵ��
SELECT Sname,Sdept
FROM student X
WHERE Sage>(
SELECT AVG(Sage)
FROM student Y
WHERE Y.Sdept=X.Sdept 
)

--13.	��ѯѡ��������ͬѧ��ѡ�޵�ȫ���γ̵�ѧ����������ѡ��һ��ѧ�����������κ�һ�������Ŀ����ѧ��ûѡ��
SELECT Sname
FROM student X
WHERE NOT EXISTS(
SELECT *
FROM student JOIN sc ON(student.Sno=sc.Sno)
WHERE Sname ='����'AND Cno NOT IN (
 SELECT Cno
FROM student Y JOIN sc ON(Y.Sno=sc.Sno)
WHERE Y.Sno=X.Sno
 ) 
)

--14.	����ѡ����ȫ���γ̵�ѧ���������������κ�һ�ſ����ѧ��û��ѡ��
SELECT Sname
FROM student X
WHERE NOT EXISTS(
SELECT Cno
FROM course
WHERE Cno NOT IN(
SELECT Cno
FROM student Z JOIN sc ON(Z.Sno=sc.Sno)
WHERE Z.Sno=X.Sno
 )
)

--15.	�г�ͬʱѡ�ޡ�1���ſγ̺͡�2���ſγ̵�����ѧ������������ʹ�����ַ���ʵ�֣�
SELECT Sname
FROM student X
WHERE EXISTS(
SELECT *
FROM student Y JOIN sc ON(Y.Sno=sc.Sno)
WHERE Y.Sno=X.Sno AND Cno =1
)
AND
EXISTS(
SELECT *
FROM student Z JOIN sc ON(Z.Sno=sc.Sno)
WHERE Z.Sno=X.Sno AND Cno =2
)

SELECT Sname
FROM student JOIN sc ON(student.Sno=sc.Sno)
WHERE Cno =1
INTERSECT
SELECT Sname
FROM student JOIN sc ON(student.Sno=sc.Sno)
WHERE Cno =2

--16.	ʹ��Ƕ�ײ�ѯ�г�ѡ���ˡ����ݽṹ���γ̵�ѧ��ѧ�ź�������
SELECT X.Sno,Sname
FROM student X JOIN sc ON(X.Sno=sc.Sno)
WHERE Cno =(
SELECT Cno
FROM course
WHERE Cname ='���ݽṹ'
) 

--17.	ʹ��Ƕ�ײ�ѯ��ѯ����ϵ������С��CSϵ��ĳ��ѧ����ѧ�������������Ժϵ��������ΪʲôʲôҲ�鲻������

SELECT Sname,Sage,Sdept
FROM student
WHERE Sage<(
SELECT Sage
FROM student
WHERE Sno='200515001' AND Sdept='CS'
)

--18.	��ѯѡ���������Ŀγ̺źͿγ������������У���
SELECT course.Cno,Cname
FROM course JOIN sc ON(course.Cno=sc.Cno)
GROUP BY course.Cno,Cname
HAVING COUNT(*)=(
SELECT TOP 1  COUNT(*)
FROM sc JOIN course ON(sc.Cno=course.Cno)
GROUP BY sc.Cno,Cname
ORDER BY COUNT(*) DESC)

--19.	ʹ�ü��ϲ�ѯ�г�CSϵ��ѧ���Լ��Ա�ΪŮ��ѧ��������
SELECT *
FROM student
WHERE Ssex='Ů'
INTERSECT
SELECT *
FROM student
WHERE Sdept='CS'

--20.	ʹ�ü��ϲ�ѯ�г�CSϵ��ѧ�������䲻����19���ѧ���Ľ��������
SELECT *
FROM student
WHERE Sdept='CS'
INTERSECT
SELECT *
FROM student
WHERE Sage<=19





--1.�ҳ����й�Ӧ�̵����������ڳ���
SELECT SNAME,CITY
FROM S

--2.�ҳ����������������ɫ����
SELECT PNAME,COLOR,WEIGHT
FROM P

--3.�ҳ�ʹ�ù�Ӧ��S1����Ӧ����Ĺ��̺���
SELECT DISTINCT JNO
FROM SPJ
WHERE PNO IN(
SELECT PNO
FROM SPJ
WHERE SNO='S1'
)

--4.�ҳ�������ĿJ2ʹ�õĸ�����������Ƽ�������
SELECT PNAME,SUM(QTY)
FROM P,SPJ
WHERE P.PNO=SPJ.PNO AND JNO='J2'
GROUP BY PNAME

--5.�ҳ��Ϻ����̹�Ӧ�������������
SELECT DISTINCT P.PNO 
FROM S,P,SPJ
WHERE S.SNO=SPJ.SNO AND P.PNO=SPJ.PNO AND CITY='�Ϻ�'

--6.�ҳ�ʹ���Ϻ���������Ĺ��̵�����
SELECT DISTINCT JNAME
FROM SPJ JOIN J ON(SPJ.JNO=J.JNO)
WHERE PNO IN(SELECT DISTINCT P.PNO 
FROM S,P,SPJ
WHERE S.SNO=SPJ.SNO AND P.PNO=SPJ.PNO AND CITY='�Ϻ�')--������һ��

--7.�ҳ�û��ʹ�������������Ĺ��̵�����
SELECT DISTINCT JNAME
FROM SPJ JOIN J ON(SPJ.JNO=J.JNO)
WHERE PNO NOT IN(SELECT DISTINCT P.PNO 
FROM S,P,SPJ
WHERE S.SNO=SPJ.SNO AND P.PNO=SPJ.PNO AND CITY='���')







--1.��ѯÿ�����������Ʒ���������ܽ���ʾ�����ţ��������ܽ��
SELECT OrderID,Quantity,UnitPrice
FROM [Order Details]

--2. ��ѯÿ��Ա����7�·ݴ�����������
SELECT EmployeeID,COUNT(*)
FROM Orders
GROUP BY EmployeeID

--3. ��ѯÿ���˿͵Ķ�����������ʾ�˿�ID����������
SELECT  CustomerID,COUNT(*) as'��������'
FROM Orders
GROUP BY CustomerID

--4. ��ѯÿ���˿͵Ķ��������Ͷ����ܽ��
SELECT CustomerID,COUNT(*) as '��������',SUM(UnitPrice) as'�����ܽ��'
FROM Orders JOIN [Order Details] ON([Order Details].OrderID=Orders.OrderID)
GROUP BY CustomerID

--5. ��ѯÿ�ֲ�Ʒ�������������ܽ��
SELECT ProductID,SUM(Quantity) as'����',SUM(UnitPrice)as '�ܽ��'
FROM Orders JOIN [Order Details] ON([Order Details].OrderID=Orders.OrderID)
GROUP BY ProductID

--6. ��ѯ�����ȫ����Ʒ�Ĺ˿͵�ID������
SELECT  CustomerID
FROM Customers X
WHERE NOT EXISTS(
SELECT *
FROM Products A
WHERE NOT EXISTS
 (
 SELECT *
 FROM Orders JOIN [Order Details] ON[Order Details].OrderID=Orders.OrderID
 WHERE A.ProductID=[Order Details].ProductID AND X.CustomerID=Orders.CustomerID
  )
)







--1.	��ѯ��������ͼ�����������������Ŀǰû��ͼ������   ���Կ�ֵ���Ǳ��������ڵ���Ŀ
SELECT TypeName,COUNT(BookNo) as'����'
FROM BookType  LEFT JOIN BookInfo ON(BookType.TypeID=BookInfo.TypeID)
GROUP BY TypeName

--2.	��ѯ�����ˡ����ݿ�������Ķ��ߵĿ���ź����� Ϊʲô����distinct���������һ������?
SELECT DISTINCT X.CardNo,Reader
FROM CardInfo X JOIN BorrowInfo ON (X.CardNo=BorrowInfo.CardNo)
WHERE EXISTS (
SELECT *
FROM BorrowInfo A
WHERE A.CardNo=X.CardNo AND A.BookNo =(
SELECT BookNo
FROM BookInfo
WHERE BookName='���ݿ����'
 )
)

--3.��ѯ�����������ͼ��۸񳬹����������ͼ���ƽ���۸��ͼ��ı�ź����ơ�
SELECT BookNo,BookName
FROM BookInfo X
WHERE Price>(
SELECT AVG(Price)
FROM BookInfo Y
WHERE Y.Publisher=X.Publisher
)


--4.��ѯ���Ĺ���ȫ��ͼ��Ķ��ߵı�ź�����
SELECT CardNo,Reader
FROM CardInfo X
WHERE NOT EXISTS(
SELECT *
FROM BookInfo Y
WHERE NOT EXISTS(
SELECT *
FROM BorrowInfo Z
WHERE Z.CardNo=X.CardNo AND Z.BookNo=Y.BookNo
 )
)

--5.��ѯ����ͼ��������������ȫ��ͼ��Ķ��ߵı�ź�����--����û�����
SELECT CardNo,Reader
FROM CardInfo X
WHERE NOT EXISTS(
SELECT *
FROM BorrowInfo JOIN  CardInfo ON(BorrowInfo.CardNo=CardInfo.CardNo)
WHERE Reader='����' AND BookNo NOT IN(
SELECT BookNo
FROM BorrowInfo Y JOIN  CardInfo ON(Y.CardNo=CardInfo.CardNo)
WHERE Y.CardNo=X.CardNo
 )
)

--6.��ѯ���Ĵ�������2�εĶ��ߵı�ź�����
SELECT CardInfo.CardNo,Reader
FROM BorrowInfo JOIN CardInfo ON(BorrowInfo.CardNo=CardInfo.CardNo)
GROUP BY CardInfo.CardNo,Reader
HAVING COUNT(*)>2

--7.��ѯ���Ŀ�������Ϊ��ʦ���о����Ķ�������
SELECT TypeName,COUNT(*) as ����
FROM CardInfo JOIN CardType ON(CardInfo.CTypeID=CardType.CTypeID)
WHERE TypeName IN ('��ʦ','�о���')
GROUP BY TypeName

--8.��ѯû�б������ͼ��ı�ź�����
SELECT BookNo,BookName
FROM BookInfo 
EXCEPT
SELECT DISTINCT BookInfo.BookNo,BookName
FROM BookInfo JOIN BorrowInfo ON(BookInfo.BookNo=BorrowInfo.BookNo)

--9.��ѯû�н��Ĺ�Ӣ�����͵�ͼ���ѧ���ı�ź�����
SELECT CardNo,Reader
FROM CardInfo
EXCEPT
SELECT DISTINCT CardInfo.CardNo,Reader
FROM BorrowInfo,CardInfo,BookType,BookInfo
WHERE BookType.TypeName='Ӣ��' AND BorrowInfo.BookNo=BookInfo.BookNo AND BookInfo.TypeID=BookType.TypeID 
AND BorrowInfo.CardNo=CardInfo.CardNo

--10.��ѯ�����ˡ������Ӧ�á����ġ����ݿ�������γ̵�ѧ���ı�Ŷ����Լ��ö��ߵĽ��Ŀ������͡�
SELECT DISTINCT Reader,TypeName
FROM CardType,BorrowInfo,CardInfo,BookInfo
WHERE CardInfo.CTypeID=CardType.CTypeID AND CardInfo.CardNo=BorrowInfo.CardNo AND BookInfo.BookNo=BorrowInfo.BookNo
AND BookInfo.BookName='���ݿ����' 











/*Market (mno, mname, city)
Item (ino, iname, type, color)
Sales (mno, ino, price)
���У�market��ʾ�̳���������������Ϊ�̳��š��̳��������ڳ��У�item��ʾ��Ʒ��������������Ϊ��Ʒ�š���Ʒ������Ʒ������ɫ��sales��ʾ���ۣ�������������Ϊ�̳��š���Ʒ�ź��ۼۡ���SQL���ʵ������Ĳ�ѯҪ��
*/

--1.�г����������̳������ۣ����ۼ۾�����10000 Ԫ����Ʒ����Ʒ�ź���Ʒ��
SELECT DISTINCT X.ino,iname
FROM item X JOIN sales ON(X.ino=sales.ino)
WHERE price>10000 AND NOT EXISTS(
SELECT mno
FROM market Y
WHERE city='����' AND mno NOT IN(

SELECT mno
FROM sales Y
WHERE Y.ino=X.ino 
)
)

--2.�г��ڲ�ͬ�̳�������ۼۺ�����ۼ�ֻ���100 Ԫ����Ʒ����Ʒ�š�����ۼۺ�����ۼ�
SELECT ino as'��Ʒ��',MAX(price) as'����ۼ�',MIN(price)as'����ۼ�'
FROM sales
GROUP BY ino
HAVING MAX(price)-MIN(price)>100

--3.�г��ۼ۳�������Ʒ��ƽ���ۼ۵ĸ�����Ʒ����Ʒ�ź��ۼ�
SELECT ino,price
FROM sales X
WHERE price >(
SELECT AVG(price)
FROM sales Y
WHERE Y.ino=X.ino
)

--4.��ѯ������ȫ����Ʒ���̳��ţ��̳����ͳ���
SELECT mno,mname,city
FROM market X
WHERE NOT EXISTS (
SELECT *
FROM item Y
WHERE Y.ino NOT IN(
SELECT ino
FROM sales
WHERE sales.mno=X.mno
)
)

--5.��ѯ�����̳��������˵���Ʒ����Ʒ�ź���Ʒ�����������ַ���ʵ�֣�
SELECT DISTINCT X.ino,iname
FROM sales JOIN item X ON(sales.ino=X.ino)
WHERE NOT EXISTS(
SELECT *
FROM market Y
WHERE NOT EXISTS(
SELECT *
FROM sales 
WHERE sales.ino=X.ino AND sales.mno=Y.mno
 ) 
)



--ʵ���벻�����ڶ����ˡ�

--6.	��ѯÿ���̳���۸���ߵ���Ʒ�����ƣ������ַ�������
SELECT TOP 1 iname
FROM item JOIN sales ON(item.ino=sales.ino)
ORDER BY price DESC



SELECT iname
FROM item JOIN sales ON(item.ino=sales.ino)
WHERE price=(
SELECT MAX(price)
FROM sales
)













