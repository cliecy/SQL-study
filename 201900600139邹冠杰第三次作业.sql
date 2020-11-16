--1.	查询以‘DB_’开头,且倒数第3个字符为‘s’的课程的详细情况；
SELECT *
FROM course
WHERE Cname LIKE 'DB\_%s__' ESCAPE '\';

--2.	查询名字中第2个字为‘阳’的学生姓名和学号及选修的课程号、课程名；
SELECT student.Sno,Sname,course.Cno,Cname
FROM student,sc,course
WHERE student.Sno=sc.Sno AND sc.Cno=course.Cno AND Sname Like '_阳%'

--3.	列出选修了‘数学’或者‘大学英语’的学生学号、姓名、所在院系、选修课程号及成绩；
SELECT student.Sno,Sname,course.Cno,Grade
FROM student,sc,course
WHERE student.Sno=sc.Sno AND sc.Cno=course.Cno AND Cname IN ('大学英语','数学')

--4.	查询缺少成绩的所有学生的详细情况；
SELECT student.Sno,Sname,Sdept,Sage
FROM student,sc
WHERE student.Sno=sc.Sno AND Grade IS NULL

--5.	查询与‘张力’(假设姓名唯一)年龄不同的所有学生的信息；
SELECT student.Sno,Sname,Sdept,Sage
FROM student
WHERE Sage !=(
SELECT Sage
FROM student
WHERE Sname='张力'
)
--6.	查询所选课程的平均成绩大于张力的平均成绩的学生学号、姓名及平均成绩；
SELECT student.Sno,Sname,AVG(Grade) as'平均成绩'
FROM sc,student
WHERE student.Sno=sc.Sno
GROUP BY student.Sno,Sname
HAVING AVG(Grade)>(
SELECT AVG(Grade)
FROM sc,student
WHERE sc.Sno=student.Sno AND Sname='张力'
)

--7.	按照“学号，姓名，所在院系，已修学分”的顺序列出学生学分的获得情况。其中已修学分为考试已经及格的课程学分之和；
SELECT student.Sno,Sname,Sdept,SUM(Ccredit) as'已修学分'
FROM student,sc,course
WHERE student.Sno=sc.Sno AND sc.Cno=course.Cno AND Grade>=60
GROUP BY student.Sno,Sname,Sdept

--8.	列出只选修一门课程的学生的学号、姓名、院系及成绩；
SELECT student.Sno,Sname,Sdept,Grade
FROM student,sc
WHERE student.Sno=sc.Sno
GROUP BY student.Sno,Sname,Sdept,Grade
HAVING COUNT(Grade)=1

--9.	查找选修了至少一门和张力选修课程一样的学生的学号、姓名及课程号；
SELECT student.Sno,Sname,course.Cno
FROM student,sc X,course
WHERE student.Sno=X.Sno AND X.Cno=course.Cno AND
EXISTS(
SELECT *
FROM student,sc Y
WHERE student.Sno=Y.Sno AND Sname='张力' AND X.Cno=Y.Cno
)

--10.	查询至少选修“数据库”和“数据结构”课程的学生的基本信息；
SELECT X.Sno,Sname,Sdept,Sage
FROM student X --JOIN sc  ON (X.Sno=sc.Sno)
WHERE EXISTS(
SELECT *
FROM student Y,sc,course
WHERE Y.Sno=sc.Sno AND sc.Cno=course.Cno AND Y.Sno=X.Sno AND Cname='数据库'

)
AND EXISTS(
SELECT *
FROM student Y,sc,course
WHERE Y.Sno=sc.Sno AND sc.Cno=course.Cno AND Y.Sno=X.Sno AND Cname='数据结构'

)

--11.	查询没有选修张力所选修的全部课程的学生的姓名；
SELECT Sname
FROM student
EXCEPT 
SELECT Sname
FROM student JOIN sc ON(student.Sno=sc.Sno)
WHERE Cno IN(
SELECT Cno
FROM student JOIN sc ON(student.Sno=sc.Sno)
WHERE student.Sname='张力'
)

--12.	查询每个专业年龄超过该专业平均年龄的学生的姓名和专业；
SELECT Sname,Sdept
FROM student X
WHERE Sage>(
SELECT AVG(Sage)
FROM student Y
WHERE Y.Sdept=X.Sdept 
)

--13.	查询选修了张力同学所选修的全部课程的学生的姓名；选择一个学生，不存在任何一个张力的课这个学生没选修
SELECT Sname
FROM student X
WHERE NOT EXISTS(
SELECT *
FROM student JOIN sc ON(student.Sno=sc.Sno)
WHERE Sname ='张力'AND Cno NOT IN (
 SELECT Cno
FROM student Y JOIN sc ON(Y.Sno=sc.Sno)
WHERE Y.Sno=X.Sno
 ) 
)

--14.	检索选修了全部课程的学生姓名；不存在任何一门课这个学生没有选修
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

--15.	列出同时选修“1”号课程和“2”号课程的所有学生的姓名；（使用两种方法实现）
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

--16.	使用嵌套查询列出选修了“数据结构”课程的学生学号和姓名；
SELECT X.Sno,Sname
FROM student X JOIN sc ON(X.Sno=sc.Sno)
WHERE Cno =(
SELECT Cno
FROM course
WHERE Cname ='数据结构'
) 

--17.	使用嵌套查询查询其它系中年龄小于CS系的某个学生的学生姓名、年龄和院系；？？？为什么什么也查不出来啊

SELECT Sname,Sage,Sdept
FROM student
WHERE Sage<(
SELECT Sage
FROM student
WHERE Sno='200515001' AND Sdept='CS'
)

--18.	查询选课人数最多的课程号和课程名（包含并列）；
SELECT course.Cno,Cname
FROM course JOIN sc ON(course.Cno=sc.Cno)
GROUP BY course.Cno,Cname
HAVING COUNT(*)=(
SELECT TOP 1  COUNT(*)
FROM sc JOIN course ON(sc.Cno=course.Cno)
GROUP BY sc.Cno,Cname
ORDER BY COUNT(*) DESC)

--19.	使用集合查询列出CS系的学生以及性别为女的学生名单；
SELECT *
FROM student
WHERE Ssex='女'
INTERSECT
SELECT *
FROM student
WHERE Sdept='CS'

--20.	使用集合查询列出CS系的学生与年龄不大于19岁的学生的交集、差集；
SELECT *
FROM student
WHERE Sdept='CS'
INTERSECT
SELECT *
FROM student
WHERE Sage<=19





--1.找出所有供应商的姓名和所在城市
SELECT SNAME,CITY
FROM S

--2.找出所有零件的名称颜色重量
SELECT PNAME,COLOR,WEIGHT
FROM P

--3.找出使用供应商S1所供应零件的工程号码
SELECT DISTINCT JNO
FROM SPJ
WHERE PNO IN(
SELECT PNO
FROM SPJ
WHERE SNO='S1'
)

--4.找出工程项目J2使用的各种零件的名称及其数量
SELECT PNAME,SUM(QTY)
FROM P,SPJ
WHERE P.PNO=SPJ.PNO AND JNO='J2'
GROUP BY PNAME

--5.找出上海厂商供应的所有零件号码
SELECT DISTINCT P.PNO 
FROM S,P,SPJ
WHERE S.SNO=SPJ.SNO AND P.PNO=SPJ.PNO AND CITY='上海'

--6.找出使用上海产的零件的工程的名称
SELECT DISTINCT JNAME
FROM SPJ JOIN J ON(SPJ.JNO=J.JNO)
WHERE PNO IN(SELECT DISTINCT P.PNO 
FROM S,P,SPJ
WHERE S.SNO=SPJ.SNO AND P.PNO=SPJ.PNO AND CITY='上海')--复用上一题

--7.找出没有使用天津生产零件的工程的名称
SELECT DISTINCT JNAME
FROM SPJ JOIN J ON(SPJ.JNO=J.JNO)
WHERE PNO NOT IN(SELECT DISTINCT P.PNO 
FROM S,P,SPJ
WHERE S.SNO=SPJ.SNO AND P.PNO=SPJ.PNO AND CITY='天津')







--1.查询每个订单购买产品的数量和总金额，显示订单号，数量，总金额
SELECT OrderID,Quantity,UnitPrice
FROM [Order Details]

--2. 查询每个员工在7月份处理订单的数量
SELECT EmployeeID,COUNT(*)
FROM Orders
GROUP BY EmployeeID

--3. 查询每个顾客的订单总数，显示顾客ID，订单总数
SELECT  CustomerID,COUNT(*) as'订单总数'
FROM Orders
GROUP BY CustomerID

--4. 查询每个顾客的订单总数和订单总金额
SELECT CustomerID,COUNT(*) as '订单总数',SUM(UnitPrice) as'订单总金额'
FROM Orders JOIN [Order Details] ON([Order Details].OrderID=Orders.OrderID)
GROUP BY CustomerID

--5. 查询每种产品的卖出总数和总金额
SELECT ProductID,SUM(Quantity) as'总数',SUM(UnitPrice)as '总金额'
FROM Orders JOIN [Order Details] ON([Order Details].OrderID=Orders.OrderID)
GROUP BY ProductID

--6. 查询购买过全部商品的顾客的ID和姓名
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







--1.	查询各种类别的图书的类别和数量（包含目前没有图书的类别）   忽略空值但是保留不存在的项目
SELECT TypeName,COUNT(BookNo) as'数量'
FROM BookType  LEFT JOIN BookInfo ON(BookType.TypeID=BookInfo.TypeID)
GROUP BY TypeName

--2.	查询借阅了‘数据库基础’的读者的卡编号和姓名 为什么不加distinct会出现三条一样的呢?
SELECT DISTINCT X.CardNo,Reader
FROM CardInfo X JOIN BorrowInfo ON (X.CardNo=BorrowInfo.CardNo)
WHERE EXISTS (
SELECT *
FROM BorrowInfo A
WHERE A.CardNo=X.CardNo AND A.BookNo =(
SELECT BookNo
FROM BookInfo
WHERE BookName='数据库基础'
 )
)

--3.查询各个出版社的图书价格超过这个出版社图书的平均价格的图书的编号和名称。
SELECT BookNo,BookName
FROM BookInfo X
WHERE Price>(
SELECT AVG(Price)
FROM BookInfo Y
WHERE Y.Publisher=X.Publisher
)


--4.查询借阅过了全部图书的读者的编号和姓名
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

--5.查询借阅图书包含李明所借的全部图书的读者的编号和姓名--李明没借过书
SELECT CardNo,Reader
FROM CardInfo X
WHERE NOT EXISTS(
SELECT *
FROM BorrowInfo JOIN  CardInfo ON(BorrowInfo.CardNo=CardInfo.CardNo)
WHERE Reader='李明' AND BookNo NOT IN(
SELECT BookNo
FROM BorrowInfo Y JOIN  CardInfo ON(Y.CardNo=CardInfo.CardNo)
WHERE Y.CardNo=X.CardNo
 )
)

--6.查询借阅次数超过2次的读者的编号和姓名
SELECT CardInfo.CardNo,Reader
FROM BorrowInfo JOIN CardInfo ON(BorrowInfo.CardNo=CardInfo.CardNo)
GROUP BY CardInfo.CardNo,Reader
HAVING COUNT(*)>2

--7.查询借阅卡的类型为老师和研究生的读者人数
SELECT TypeName,COUNT(*) as 人数
FROM CardInfo JOIN CardType ON(CardInfo.CTypeID=CardType.CTypeID)
WHERE TypeName IN ('教师','研究生')
GROUP BY TypeName

--8.查询没有被借过的图书的编号和名称
SELECT BookNo,BookName
FROM BookInfo 
EXCEPT
SELECT DISTINCT BookInfo.BookNo,BookName
FROM BookInfo JOIN BorrowInfo ON(BookInfo.BookNo=BorrowInfo.BookNo)

--9.查询没有借阅过英语类型的图书的学生的编号和姓名
SELECT CardNo,Reader
FROM CardInfo
EXCEPT
SELECT DISTINCT CardInfo.CardNo,Reader
FROM BorrowInfo,CardInfo,BookType,BookInfo
WHERE BookType.TypeName='英语' AND BorrowInfo.BookNo=BookInfo.BookNo AND BookInfo.TypeID=BookType.TypeID 
AND BorrowInfo.CardNo=CardInfo.CardNo

--10.查询借阅了‘计算机应用’类别的‘数据库基础’课程的学生的编号读者以及该读者的借阅卡的类型。
SELECT DISTINCT Reader,TypeName
FROM CardType,BorrowInfo,CardInfo,BookInfo
WHERE CardInfo.CTypeID=CardType.CTypeID AND CardInfo.CardNo=BorrowInfo.CardNo AND BookInfo.BookNo=BorrowInfo.BookNo
AND BookInfo.BookName='数据库基础' 











/*Market (mno, mname, city)
Item (ino, iname, type, color)
Sales (mno, ino, price)
其中，market表示商场，它的属性依次为商场号、商场名和所在城市；item表示商品，它的属性依次为商品号、商品名、商品类别和颜色；sales表示销售，它的属性依次为商场号、商品号和售价。用SQL语句实现下面的查询要求：
*/

--1.列出北京各个商场都销售，且售价均超过10000 元的商品的商品号和商品名
SELECT DISTINCT X.ino,iname
FROM item X JOIN sales ON(X.ino=sales.ino)
WHERE price>10000 AND NOT EXISTS(
SELECT mno
FROM market Y
WHERE city='北京' AND mno NOT IN(

SELECT mno
FROM sales Y
WHERE Y.ino=X.ino 
)
)

--2.列出在不同商场中最高售价和最低售价只差超过100 元的商品的商品号、最高售价和最低售价
SELECT ino as'商品号',MAX(price) as'最高售价',MIN(price)as'最低售价'
FROM sales
GROUP BY ino
HAVING MAX(price)-MIN(price)>100

--3.列出售价超过该商品的平均售价的各个商品的商品号和售价
SELECT ino,price
FROM sales X
WHERE price >(
SELECT AVG(price)
FROM sales Y
WHERE Y.ino=X.ino
)

--4.查询销售了全部商品的商场号，商场名和城市
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

--5.查询所有商场都销售了的商品的商品号和商品名。（用两种方法实现）
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



--实在想不出来第二种了。

--6.	查询每个商场里价格最高的商品的名称（用两种方法做）
SELECT TOP 1 iname
FROM item JOIN sales ON(item.ino=sales.ino)
ORDER BY price DESC



SELECT iname
FROM item JOIN sales ON(item.ino=sales.ino)
WHERE price=(
SELECT MAX(price)
FROM sales
)













