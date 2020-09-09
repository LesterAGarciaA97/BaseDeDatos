SELECT * 
FROM sys.stats
WHERE object_id = 1893581784

SELECT * 
FROM sys.objects
WHERE name like '%Employee%' and type = 'U'

DBCC --DataBase Console Command
DBCC show_statistics('TABLA','ESTADÍSTICA')

DBCC show_statistics ('HumanResources.Employee','AK_Employee_LoginID')

CREATE STATISTICS orderH_status on Purchasing.PurchaseOrderHeader (Status)
DBCC show_statistics ('Purchasing.PurchaseOrderHeader','orderH_status')

	SELECT *
	FROM Purchasing.PurchaseOrderHeader POH
			inner join Purchasing.PurchaseOrderDetail POD oN POH.PurchaseOrderID = POD.PurchaseOrderID