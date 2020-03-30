SELECT * --Proyecci�n
FROM Sales.Customer
WHERE PersonID is not null

--Operadores l�gicos: AND - OR - NOT

--comparo valores : operador relacionales

--Obtener los productos, d�nde el nombre inicie con 'P' y su precio unitario comprendido entre 10 y 100

SELECT *
FROM Sales.Customer
WHERE PersonID is null
      and StoreID in (644,930)

--IN Listado de valores
--BETWEEN = Rango de valores (Minimo y Maximo)

--Listar los clientes d�nde sea nulo el PersonID y la Tienda sea 644 o 930 o el Territorio sea 5

SELECT *
FROM Sales.Customer
WHERE (
	PersonID is null
	and StoreID in (644,930)
      ) or
      (
	TerritoryID = 5
      )

SELECT *
FROM Sales.Customer
WHERE (
	PersonID is null AND
	(
	  StoreID = 644 or
	  StoreID = 930
      )
      ) or
      (
	TerritoryID = 5
      )

--Obtener las �rdenes realizadas en el territorio 2 0 4 (Vendedor) y realizadas en el a�o 2011
SELECT *
FROM Sales.SalesOrderHeader
--WHERE year(orderdate) = 2010
--WHERE year(orderdate) in (2011)
--WHERE Substring(Convert(varchar,orderdate),0,5) = '2011'
--WHERE orderdate >= '01/01/2011' and orderdate <= '31/12/2011'
WHERE orderdate between '01/01/2011' and '31/12/2011'
