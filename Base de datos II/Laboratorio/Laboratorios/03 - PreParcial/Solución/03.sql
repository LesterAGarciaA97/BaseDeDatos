USE AdventureWorks2017;

-- 3) Cu�ntas �rdenes de trabajo se han realizado por producto en cada a�o.
--		a. Nombre producto
--		b. A�o
--		c. Cantidad de �rdenes de trabajo

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