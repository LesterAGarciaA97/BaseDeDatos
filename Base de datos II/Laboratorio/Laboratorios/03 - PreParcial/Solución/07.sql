USE AdventureWorks2017;

-- 7) ¿Cuál es el producto más vendido, por año? Tome en cuenta únicamente los productos que se hayan vendido a más de un cliente?

SELECT P.ProductID,
	   SUM(SOD.OrderQty) AS 'Total de ventas',
	   YEAR(SOH.OrderDate) AS 'Anio' INTO Sales.Total_Ventas_Año
FROM Sales.Productos_Vendidos P 
    inner join Sales.SalesOrderDetail SOD ON P.ProductID = SOD.ProductID 
      inner join Sales.SalesOrderHeader soh ON SOD.SalesOrderID = SOH.SalesOrderID
WHERE SOH.Status = 5 
	GROUP BY P.ProductID,YEAR(SOH.OrderDate) 
	ORDER BY 3 ASC

SELECT MAX([Total de ventas]) AS 'Total de ventas',
	   Anio INTO Sales.TotalProductosVendidos
FROM Sales.Total_Ventas_Año 
	GROUP BY Anio

SELECT TPV.[Total de ventas],
	   TVA.ProductID,
	   TVA.Año 
FROM Sales.TotalProductosVendidos TPV 
    inner join Sales.Total_Ventas_Año TVA ON TPV.[Total de ventas] = TVA.[Total de ventas] 
		ORDER BY 3