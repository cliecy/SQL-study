--将被全部学生都选修了的课程的总学分改为4学分
UPDATE kc
SET 学分=4
WHERE 课程号 IN (
SELECT 课程号
FROM kc X
WHERE NOT EXISTS(
SELECT *
FROM xs Y
WHERE NOT EXISTS(
SELECT *
FROM cj Z
WHERE Z.学号=Y.学号 AND Z.课程号=X.课程号
      )
   )
)



--从学生表删除没有选课的学生。
DELETE 
FROM xs
WHERE 学号 NOT IN(
SELECT DISTINCT 学号
FROM cj
)

--将每个学生的平均分，总分和选课门数插入到数据库中（学号，姓名，平均分，总分，选课门数）
--首先建立新表
CREATE TABLE fs 
(
学号 Char(10),
姓名 nchar(10),
平均分 int,
总分 int,
选课门数 int,
FOREIGN KEY(学号) REFERENCES xs(学号),
)
INSERT INTO fs (学号,平均分,选课门数,总分)
SELECT 学号,AVG(成绩),COUNT(成绩),SUM(成绩) FROM cj GROUP BY 学号
UPDATE X
SET 姓名=(
SELECT 姓名
FROM xs Y
WHERE Y.学号=X.学号
)
FROM fs X

--创建每门课程的平均分和选课人数的视图（课程号，课程名，平均分，人数）
CREATE VIEW 平均分与人数 
AS
SELECT 课程名,kc.课程号,AVG(成绩) as'平均分',COUNT(*) as '人数'
FROM cj JOIN kc ON(cj.课程号=kc.课程号)
GROUP BY 课程名,kc.课程号


--将李强同学从学生表删除（提示应该先删除李强同学的选课记录）
DELETE 
FROM cj
WHERE 学号=(
SELECT 学号
FROM xs
WHERE 姓名='李强'
)
DELETE 
FROM xs
WHERE 学号=(
SELECT 学号
FROM xs
WHERE 姓名='李强'
)

--插入一条选课记录（具体内容自己选）
INSERT 
INTO cj (学号,课程号,成绩)
VALUES('2006030315','A001',100)


--创建网络工程专业的学生的选课信息的视图，要求视图包含，学号，姓名，专业，课程号，课程名，成绩
CREATE VIEW 网络工程选课信息
AS
SELECT xs.学号,姓名,专业,kc.课程号,课程名,成绩
FROM xs,cj,kc
WHERE xs.学号=cj.学号 AND kc.课程号=cj.课程号 AND 专业='网络工程'


--查询网络工程专业的各科的平均成绩，要求使用第7题创建的视图进行查询
SELECT 课程号,课程名,AVG(成绩)
FROM 网络工程选课信息
GROUP BY 课程号,课程名


--查询被信息管理专业的学生都选修了的课程的课程号，课程名

SELECT 课程号,课程名
FROM kc X
WHERE NOT EXISTS(
SELECT *
FROM xs Y
WHERE 专业='信息管理'AND NOT EXISTS(
SELECT *
FROM cj
WHERE cj.学号=Y.学号 AND cj.课程号=X.课程号
     )
)



--显示选修课程数最多的学号及选修课程数最少的学号，姓名（使用派生表实现）
SELECT *
FROM (
SELECT TOP 1 xs.学号,姓名 
FROM xs JOIN cj ON(xs.学号=cj.学号) 
GROUP BY xs.学号,姓名 
ORDER BY COUNT(*) DESC) AS X
UNION
SELECT *
FROM (
SELECT TOP 1 xs.学号,姓名 
FROM xs JOIN cj ON(xs.学号=cj.学号)
GROUP BY xs.学号,姓名 
ORDER BY COUNT(*)) AS Y


--查询每个学生成绩高于自己的平均成绩的学号，姓名，课程号和成绩（使用派生表实现）
SELECT cj.学号,课程号,姓名,成绩
FROM cj,xs,(
SELECT 学号,AVG(成绩)
FROM cj
GROUP BY 学号) AS Avgcj(X,Y)
WHERE cj.学号=Avgcj.X AND cj.成绩>Avgcj.Y AND cj.学号=xs.学号

--自己验证with check option的作用

--创建一个网络工程系的学生基本信息的视图MA_STUDENT，在此视图的基础上，再定义一个该专业女生信息的视图，然后再删除MA_STUDENT，观察执行情况。
CREATE VIEW MA_STUDENT
AS
SELECT *
FROM xs
WHERE 专业='网络工程'

CREATE VIEW FMA_STUDENT
AS
SELECT *
FROM MA_STUDENT
WHERE 性别='女'

DROP VIEW MA_STUDENT
--成功了，但是这个FMA的视图看不了了


--查询和程明同龄的学生的学号和姓名以及年龄
SELECT 学号,姓名,YEAR(GETDATE())-YEAR(出生时间) as 年龄
FROM xs
WHERE YEAR(GETDATE())-YEAR(出生时间)=(
SELECT YEAR(GETDATE())-YEAR(出生时间)
FROM xs
WHERE 姓名='程明'
)
EXCEPT
SELECT 学号,姓名,YEAR(GETDATE())-YEAR(出生时间) as 年龄
FROM xs
WHERE 姓名='程明'

--查询没有被全部的学生都选修的课程的课程号和课程名
SELECT 课程号,课程名
FROM kc
EXCEPT
SELECT 课程名,课程号
FROM kc X
WHERE NOT EXISTS(
SELECT *
FROM xs Y
WHERE NOT EXISTS(
SELECT *
FROM cj Z
WHERE Z.学号=Y.学号 AND Z.课程号=X.课程号
      )
   )


--查询选课学生包含了选英语的全部学生的课程的课程号和课程名。
--不存在有任何一个选英语的学生的学号不在选该课程的学生的集合中
SELECT 课程号,课程名
FROM kc X
WHERE NOT EXISTS(
SELECT DISTINCT *
FROM cj JOIN kc ON(cj.课程号=kc.课程号)
WHERE 课程名='英语' AND 学号 NOT IN(
SELECT 学号
FROM cj Y
WHERE Y.课程号=X.课程号
 )
)

--1. 将员工lastname是: Peacock处理的订单中购买数量超过50的商品折扣改为七折
UPDATE Products
SET Discontinued=3
WHERE ProductID IN(
SELECT [Order Details].ProductID
FROM Orders JOIN [Order Details] ON([Order Details].OrderID=Orders.OrderID)
WHERE EmployeeID=(
SELECT EmployeeID
FROM Employees
WHERE LastName='Peacock'
 )
)

--2. 删除lastname是: Peacock处理的所有订单
CREATE VIEW Peacock的所有订单
AS
SELECT [Order Details].OrderID
FROM Orders JOIN [Order Details] ON([Order Details].OrderID=Orders.OrderID)
WHERE EmployeeID=(
SELECT EmployeeID
FROM Employees
WHERE LastName='Peacock'
 )


DELETE 
FROM [Orders]
WHERE [Orders].OrderID IN Peacock的所有订单

DELETE
FROM [Order Details]
WHERE [Order Details].OrderID IN Peacock的所有订单

--3. 将每个订单的订单编号，顾客编号，产品总数量，总金额插入到数据库中
CREATE TABLE new
(
OrderID int,
EmployeeID int,
Quantity smallint,
Unitprice int,
FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY(EmployeeID) REFERENCES Employees(EmployeeID)
)

INSERT INTO new (OrderID,Quantity,Unitprice)
SELECT OrderID,Quantity,Unitprice FROM [Order Details]

UPDATE X
SET X.EmployeeID=(
SELECT EmployeeID
FROM Orders Y
WHERE Y.OrderID=X.OrderID)
FROM new X



--4. 插入一个新的订单，要求该订单购买了商品编号为5,7,9的商品。（5号商品买了10个，7号买了20个，9号买了15个，都没有折扣）
--
INSERT [Order Details] 
VALUES(1,5,10*(SELECT Products.UnitPrice
FROM Products
WHERE ProductID=5)
,10,0
)
INSERT [Order Details] 
VALUES(1,7,20*(SELECT Products.UnitPrice
FROM Products
WHERE ProductID=7)
,10,0
)
INSERT [Order Details] 
VALUES(1,9,15*(SELECT Products.UnitPrice
FROM Products
WHERE ProductID=9)
,10,0
)


--5. 将每年每个员工处理订单的数量和订单的总金额创建为视图
CREATE VIEW 订单数量与金额
AS
SELECT COUNT(*) as '订单数量',SUM(UnitPrice) as'总金额'
FROM Orders JOIN [Order Details] ON([Order Details].OrderID=Orders.OrderID)
GROUP BY EmployeeID



--6. 购买了CustomerID是‘VINET’用户所购买的全部商品的用户的CustomerID和CompanyName。
SELECT CustomerID,CompanyName
FROM Customers X
WHERE NOT EXISTS(
SELECT ProductID
FROM Orders JOIN [Order Details] on([Order Details].OrderID=Orders.OrderID)
WHERE CustomerID='VINET'  AND ProductID NOT IN(
SELECT ProductID
FROM Orders Y JOIN [Order Details] on([Order Details].OrderID=Y.OrderID)
WHERE Y.CustomerID=X.CustomerID
 )
)













。



