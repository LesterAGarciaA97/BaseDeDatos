SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRAN
INSERT INTO Sales.Currency
	(CurrencyCode, Name)
	VALUES
	('BZB', 'BBZZ')

COMMIT


SELECT *
FROM Sales.Currency
WHERE CurrencyCode like 'B%'