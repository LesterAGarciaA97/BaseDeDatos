--Agregaciones

SELECT *
FROM Sales.SalesOrderDetail

SELECT COUNT(*)
FROM Sales.SalesOrderDetail

SELECT COUNT(*) --Conteo
FROM Sales.SalesOrderDetail --de una entidad (relacion)
WHERE ProductID between 770 and 780 --aplicando una selección

SELECT max(listPrice) as PrecioMax, min(listPrice) as PrecioMin
FROM Production.Product

SELECT max(listPrice) as PrecioMax, min(listPrice) as PrecioMin
FROM Production.Product
WHERE ProductID between 770 and 780

SELECT sum(weight)
FROM Production.Product

SELECT count(1)
FROM Sales.SalesOrderDetail V
	inner join Production.Product P on V.ProductID = p.ProductID

SELECT P.Name, COUNT(1)
FROM Sales.SalesOrderDetail V
	inner join Production.Product P on V.ProductID = p.ProductID
GROUP BY P.Name

--TODO lo que tenga en mi proyección y que no sea una funcion de agregación DEBE existir en la sección de agrupacion GROUP BY

SELECT P.Name, COUNT(1)
FROM Sales.SalesOrderDetail V
	inner join Production.Product P on V.ProductID = p.ProductID
GROUP BY P.Name, YEAR(V.modifieddate)

SELECT P.Name, COUNT(1)
FROM Sales.SalesOrderDetail V
	inner join Production.Product P on V.ProductID = p.ProductID
GROUP BY P.Name, YEAR(V.modifieddate) --los campos no tienen que ser exactamente los mismos del grupo
order by P.Name, YEAR(V.modifieddate)