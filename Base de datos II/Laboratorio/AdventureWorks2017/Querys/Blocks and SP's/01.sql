USE AdventureWorks2017;

-- Para cada cliente con su dirección de casa en Redmond, mostrar el campo line1 de dicha dirección y los campos line1, city de
-- la dirección de entrega (dejar en blanco si no tiene)

-- Mostrar las 3 más importantes ciudades (en cuanto a las ventas realizadas)

-- Cuantas ventas se han realizado según los rangos de venta de: 0-99; 100-999; 1000-9999;10000-

-- Muestre el total de venta por cada Region de mayor a menor

--TRUNCATE TABLE tmp_clase1;
DECLARE @cantidad INTEGER	
INSERT tmp_clase1
SELECT P.BusinessEntityID, P.FirstName, P.LastName, BEA.AddressID, BEA.AddressTypeID, A.AddressLine1, A.City
FROM Person.Person P
		inner join person.BusinessEntity BE on (P.BusinessEntityID = BE.BusinessEntityID)
			inner join Person.BusinessEntityAddress BEA on
				(BEA.BusinessEntityID = BEA.BusinessEntityID and BEA.AddressTypeID=2)
			inner join Person.Address A on (BEA.AddressID = A.AddressID and a.City = 'Redmond')
ORDER BY P.BusinessEntityID;

SELECT @cantidad = count(1)
FROM tmp_clase1;

IF (@cantidad > 500 ) BEGIN 
PRINT 'Mayor'
END ELSE
PRINT 'Menor'
END;