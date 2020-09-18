-- Lester Andrés García Aquino - 1003115

USE AdventureWorks2017;

SELECT Cards.CardType, Addr.City, 
	   COUNT(H.SalesOrderID) AS 'Cantidad de Compras', 
	   SUM(H.TotalDue) AS 'Monto total'
FROM Sales.SalesOrderHeader H 
		inner join Sales.CreditCard Cards ON H.CreditCardID = Cards.CreditCardID
			inner join Person.Address Addr ON H.ShipToAddressID = Addr.AddressID
				inner join Sales.CurrencyRate Curr ON H.CurrencyRateID = Curr.CurrencyRateID
WHERE Curr.CurrencyRateID IS NOT NULL
	GROUP BY cards.CardType, Addr.City

