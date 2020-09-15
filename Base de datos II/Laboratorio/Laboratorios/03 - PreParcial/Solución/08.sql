USE AdventureWorks2017;

-- 8) Actualice la comisión a pagar para los vendedores, cada vez que ocurra algún movimiento de venta.

CREATE TABLE Sales.Commissions
(
	SalesOrderID INT PRIMARY KEY NOT NULL,
	TotalVenta MONEY NOT NULL,
	SalesPersonID INT NOT NULL,
	PorcentajeComision MONEY NOT NULL,
	ComisionVenta MONEY NOT NULL
)

CREATE TRIGGER tiu_Commissions ON Sales.SalesOrderHeader
AFTER INSERT AS
BEGIN
	DECLARE @Persona INT, @SaleID INT
	SELECT  @Persona = SalesPersonID, 
		    @SaleID = SalesOrderID FROM inserted

	IF(@Persona IS NOT NULL)
		BEGIN
			INSERT INTO Sales.Commissions (SalesOrderID, TotalVenta, SalesPersonID, PorcentajeComision, ComisionVenta)
			SELECT SOH.SalesOrderID, SOH.TotalDue, SOH.SalesPersonID, SP.CommissionPct, (SP.CommissionPct * SOH.TotalDue)
				FROM Sales.SalesOrderHeader SOH
					inner join Sales.SalesPerson SP ON SOH.SalesPersonID = SP.BusinessEntityID
				WHERE SalesOrderID = @SaleID
		END
END
GO

SELECT P.ProductID AS 'ID del producto', 
	   P.Name AS 'Nombre del producto', 
	   YEAR(WORKO.StartDate) AS 'Anio', 
	   COUNT(DISTINCT WORKO.WorkOrderID) AS 'Cantidad de ordenes'
FROM Production.WorkOrder WORKO
		inner join Production.Product P
			ON WORKO.ProductID = P.ProductID
				GROUP BY P.ProductID, 
						 P.Name, YEAR(WORKO.StartDate)
				ORDER BY Anio DESC