USE AdventureWorks2017;

BEGIN TRAN
UPDATE Sales.SalesOrderDetail
	SET UnitPriceDiscount += 0.02
WHERE SalesOrderID = 43662;

SELECT *
FROM Sales.SalesOrderDetail
WHERE SalesOrderId = 43662