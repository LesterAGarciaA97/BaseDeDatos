SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT *
FROM Sales.SalesOrderDetail
WHERE SalesOrderId = 43662