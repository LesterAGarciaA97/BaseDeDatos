SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRAN

SELECT *
FROM Sales.Currency
WHERE CurrencyCode like 'B%'