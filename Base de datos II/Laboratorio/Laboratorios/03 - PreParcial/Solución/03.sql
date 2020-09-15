USE AdventureWorks2017;

-- 3) Cuántas órdenes de trabajo se han realizado por producto en cada año.
--		a. Nombre producto
--		b. Año
--		c. Cantidad de órdenes de trabajo

SELECT P.ProductID AS 'ID del producto',
	   P.Name AS 'Nombre del producto',
	   YEAR(WORKO.StartDate) AS 'Anio',
	   COUNT(DISTINCT WORKO.WorkOrderID) AS '# de ordenes'
FROM Production.WorkOrder WORKO
		inner join Production.Product P ON WORKO.ProductID = P.ProductID
				GROUP BY P.ProductID, 
						 P.Name, 
						 YEAR(WORKO.StartDate)
				ORDER BY Anio ASC