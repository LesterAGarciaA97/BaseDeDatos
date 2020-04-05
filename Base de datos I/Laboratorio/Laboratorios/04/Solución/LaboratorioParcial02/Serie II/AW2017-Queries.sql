USE AdventureWorks2017;

SELECT TotalDue, count (SalesOrderID) AS ventas_totales, ST.Name, CC.CardType
FROM Sales.SalesOrderHeader SO inner join Sales.SalesTerritory  ST
ON SO.TerritoryID=ST.TerritoryID inner join
Sales.CreditCard CC ON CC.CreditCardID=SO.CreditCardID
WHERE TotalDue>10000
GROUP BY TotalDue, CC.CardType, ST.Name

SELECT P.Name AS nombre_Productos, PM.Name AS Modelo, count(P.ProductID) AS Productos_Cambios 
FROM Production.Product P inner join Production.TransactionHistory TH ON P.ProductID=TH.ProductID inner join Production.ProductModel PM ON P.ProductModelID= PM.ProductModelID
WHERE P.Weight>=2
GROUP BY P.Name, PM.Name
HAVING count(P.ProductID)>2

