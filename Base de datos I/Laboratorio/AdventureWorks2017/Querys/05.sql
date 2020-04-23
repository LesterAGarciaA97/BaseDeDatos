USE AdventureWorks2017;

--31,465
SELECT *
FROM Sales.SalesOrderHeader

--13,532
SELECT *
FROM Sales.CurrencyRate

--Inner Join
--13,976
SELECT *
FROM Sales.SalesOrderHeader S
		INNER JOIN Sales.CurrencyRate CR ON S.CurrencyRateID = CR.CurrencyRateID
											--PK			   --FK
--Left Outer Join
SELECT SUM(subtotal), count(1)
FROM sales.SalesOrderHeader S
		LEFT OUTER JOIN Sales.CurrencyRate CR ON S.CurrencyRateID = CR.CurrencyRateID
		GROUP BY CR.CurrencyRateID
		ORDER BY CR.CurrencyRateID

--Right Outer Join
SELECT *
FROM Sales.SalesOrderHeader S
		RIGHT OUTER JOIN Sales.CurrencyRate CR ON S.CurrencyRateID = CR.CurrencyRateID
		GROUP BY CR.CurrencyRateID
		ORDER BY CR.CurrencyRateID

--Left Outer Join with exclusion
Select SUM(SubTotal) as  [Total de Subtotal], COUNT(1) 
from sales.SalesOrderHeader S
	LEFT OUTER JOIN Sales.CurrencyRate CR ON S.CurrencyRateID = CR.CurrencyRateID	
where CR.CurrencyRateID IS NULL

--Right Outer Join with exclusion
Select SUM(SubTotal) as  [Total de Subtotal], COUNT(1) 
from sales.SalesOrderHeader S
	RIGHT OUTER JOIN Sales.CurrencyRate CR ON S.CurrencyRateID = CR.CurrencyRateID	
where S.CurrencyRateID IS NULL