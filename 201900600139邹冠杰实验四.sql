--����ȫ��ѧ����ѡ���˵Ŀγ̵���ѧ�ָ�Ϊ4ѧ��
UPDATE kc
SET ѧ��=4
WHERE �γ̺� IN (
SELECT �γ̺�
FROM kc X
WHERE NOT EXISTS(
SELECT *
FROM xs Y
WHERE NOT EXISTS(
SELECT *
FROM cj Z
WHERE Z.ѧ��=Y.ѧ�� AND Z.�γ̺�=X.�γ̺�
      )
   )
)



--��ѧ����ɾ��û��ѡ�ε�ѧ����
DELETE 
FROM xs
WHERE ѧ�� NOT IN(
SELECT DISTINCT ѧ��
FROM cj
)

--��ÿ��ѧ����ƽ���֣��ֺܷ�ѡ���������뵽���ݿ��У�ѧ�ţ�������ƽ���֣��ܷ֣�ѡ��������
--���Ƚ����±�
CREATE TABLE fs 
(
ѧ�� Char(10),
���� nchar(10),
ƽ���� int,
�ܷ� int,
ѡ������ int,
FOREIGN KEY(ѧ��) REFERENCES xs(ѧ��),
)
INSERT INTO fs (ѧ��,ƽ����,ѡ������,�ܷ�)
SELECT ѧ��,AVG(�ɼ�),COUNT(�ɼ�),SUM(�ɼ�) FROM cj GROUP BY ѧ��
UPDATE X
SET ����=(
SELECT ����
FROM xs Y
WHERE Y.ѧ��=X.ѧ��
)
FROM fs X

--����ÿ�ſγ̵�ƽ���ֺ�ѡ����������ͼ���γ̺ţ��γ�����ƽ���֣�������
CREATE VIEW ƽ���������� 
AS
SELECT �γ���,kc.�γ̺�,AVG(�ɼ�) as'ƽ����',COUNT(*) as '����'
FROM cj JOIN kc ON(cj.�γ̺�=kc.�γ̺�)
GROUP BY �γ���,kc.�γ̺�


--����ǿͬѧ��ѧ����ɾ������ʾӦ����ɾ����ǿͬѧ��ѡ�μ�¼��
DELETE 
FROM cj
WHERE ѧ��=(
SELECT ѧ��
FROM xs
WHERE ����='��ǿ'
)
DELETE 
FROM xs
WHERE ѧ��=(
SELECT ѧ��
FROM xs
WHERE ����='��ǿ'
)

--����һ��ѡ�μ�¼�����������Լ�ѡ��
INSERT 
INTO cj (ѧ��,�γ̺�,�ɼ�)
VALUES('2006030315','A001',100)


--�������繤��רҵ��ѧ����ѡ����Ϣ����ͼ��Ҫ����ͼ������ѧ�ţ�������רҵ���γ̺ţ��γ������ɼ�
CREATE VIEW ���繤��ѡ����Ϣ
AS
SELECT xs.ѧ��,����,רҵ,kc.�γ̺�,�γ���,�ɼ�
FROM xs,cj,kc
WHERE xs.ѧ��=cj.ѧ�� AND kc.�γ̺�=cj.�γ̺� AND רҵ='���繤��'


--��ѯ���繤��רҵ�ĸ��Ƶ�ƽ���ɼ���Ҫ��ʹ�õ�7�ⴴ������ͼ���в�ѯ
SELECT �γ̺�,�γ���,AVG(�ɼ�)
FROM ���繤��ѡ����Ϣ
GROUP BY �γ̺�,�γ���


--��ѯ����Ϣ����רҵ��ѧ����ѡ���˵Ŀγ̵Ŀγ̺ţ��γ���

SELECT �γ̺�,�γ���
FROM kc X
WHERE NOT EXISTS(
SELECT *
FROM xs Y
WHERE רҵ='��Ϣ����'AND NOT EXISTS(
SELECT *
FROM cj
WHERE cj.ѧ��=Y.ѧ�� AND cj.�γ̺�=X.�γ̺�
     )
)



--��ʾѡ�޿γ�������ѧ�ż�ѡ�޿γ������ٵ�ѧ�ţ�������ʹ��������ʵ�֣�
SELECT *
FROM (
SELECT TOP 1 xs.ѧ��,���� 
FROM xs JOIN cj ON(xs.ѧ��=cj.ѧ��) 
GROUP BY xs.ѧ��,���� 
ORDER BY COUNT(*) DESC) AS X
UNION
SELECT *
FROM (
SELECT TOP 1 xs.ѧ��,���� 
FROM xs JOIN cj ON(xs.ѧ��=cj.ѧ��)
GROUP BY xs.ѧ��,���� 
ORDER BY COUNT(*)) AS Y


--��ѯÿ��ѧ���ɼ������Լ���ƽ���ɼ���ѧ�ţ��������γ̺źͳɼ���ʹ��������ʵ�֣�
SELECT cj.ѧ��,�γ̺�,����,�ɼ�
FROM cj,xs,(
SELECT ѧ��,AVG(�ɼ�)
FROM cj
GROUP BY ѧ��) AS Avgcj(X,Y)
WHERE cj.ѧ��=Avgcj.X AND cj.�ɼ�>Avgcj.Y AND cj.ѧ��=xs.ѧ��

--�Լ���֤with check option������

--����һ�����繤��ϵ��ѧ��������Ϣ����ͼMA_STUDENT���ڴ���ͼ�Ļ����ϣ��ٶ���һ����רҵŮ����Ϣ����ͼ��Ȼ����ɾ��MA_STUDENT���۲�ִ�������
CREATE VIEW MA_STUDENT
AS
SELECT *
FROM xs
WHERE רҵ='���繤��'

CREATE VIEW FMA_STUDENT
AS
SELECT *
FROM MA_STUDENT
WHERE �Ա�='Ů'

DROP VIEW MA_STUDENT
--�ɹ��ˣ��������FMA����ͼ��������


--��ѯ�ͳ���ͬ���ѧ����ѧ�ź������Լ�����
SELECT ѧ��,����,YEAR(GETDATE())-YEAR(����ʱ��) as ����
FROM xs
WHERE YEAR(GETDATE())-YEAR(����ʱ��)=(
SELECT YEAR(GETDATE())-YEAR(����ʱ��)
FROM xs
WHERE ����='����'
)
EXCEPT
SELECT ѧ��,����,YEAR(GETDATE())-YEAR(����ʱ��) as ����
FROM xs
WHERE ����='����'

--��ѯû�б�ȫ����ѧ����ѡ�޵Ŀγ̵Ŀγ̺źͿγ���
SELECT �γ̺�,�γ���
FROM kc
EXCEPT
SELECT �γ���,�γ̺�
FROM kc X
WHERE NOT EXISTS(
SELECT *
FROM xs Y
WHERE NOT EXISTS(
SELECT *
FROM cj Z
WHERE Z.ѧ��=Y.ѧ�� AND Z.�γ̺�=X.�γ̺�
      )
   )


--��ѯѡ��ѧ��������ѡӢ���ȫ��ѧ���Ŀγ̵Ŀγ̺źͿγ�����
--���������κ�һ��ѡӢ���ѧ����ѧ�Ų���ѡ�ÿγ̵�ѧ���ļ�����
SELECT �γ̺�,�γ���
FROM kc X
WHERE NOT EXISTS(
SELECT DISTINCT *
FROM cj JOIN kc ON(cj.�γ̺�=kc.�γ̺�)
WHERE �γ���='Ӣ��' AND ѧ�� NOT IN(
SELECT ѧ��
FROM cj Y
WHERE Y.�γ̺�=X.�γ̺�
 )
)

--1. ��Ա��lastname��: Peacock����Ķ����й�����������50����Ʒ�ۿ۸�Ϊ����
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

--2. ɾ��lastname��: Peacock��������ж���
CREATE VIEW Peacock�����ж���
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
WHERE [Orders].OrderID IN Peacock�����ж���

DELETE
FROM [Order Details]
WHERE [Order Details].OrderID IN Peacock�����ж���

--3. ��ÿ�������Ķ�����ţ��˿ͱ�ţ���Ʒ���������ܽ����뵽���ݿ���
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



--4. ����һ���µĶ�����Ҫ��ö�����������Ʒ���Ϊ5,7,9����Ʒ����5����Ʒ����10����7������20����9������15������û���ۿۣ�
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


--5. ��ÿ��ÿ��Ա���������������Ͷ������ܽ���Ϊ��ͼ
CREATE VIEW ������������
AS
SELECT COUNT(*) as '��������',SUM(UnitPrice) as'�ܽ��'
FROM Orders JOIN [Order Details] ON([Order Details].OrderID=Orders.OrderID)
GROUP BY EmployeeID



--6. ������CustomerID�ǡ�VINET���û��������ȫ����Ʒ���û���CustomerID��CompanyName��
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













��



