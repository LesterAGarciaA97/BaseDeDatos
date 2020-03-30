SELECT * --Proyección
FROM Sales.Customer
WHERE PersonID is not null

--Operadores lógicos: AND - OR - NOT

--comparo valores : operador relacionales

--Obtener los productos, dónde el nombre inicie con 'P' y su precio unitario comprendido entre 10 y 100

SELECT *
FROM Sales.Customer
WHERE PersonID is null
      and StoreID in (644,930)

--IN Listado de valores
--BETWEEN = Rango de valores (Minimo y Maximo)

--Listar los clientes dónde sea nulo el PersonID y la Tienda sea 644 o 930 o el Territorio sea 5

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

--Obtener las órdenes realizadas en el territorio 2 0 4 (Vendedor) y realizadas en el año 2011
SELECT *
FROM Sales.SalesOrderHeader
--WHERE year(orderdate) = 2010
--WHERE year(orderdate) in (2011)
--WHERE Substring(Convert(varchar,orderdate),0,5) = '2011'
--WHERE orderdate >= '01/01/2011' and orderdate <= '31/12/2011'
WHERE orderdate between '01/01/2011' and '31/12/2011'
