USE AdventureWorks2017;

-- 2) Mostrar las personas con sus respectivas direcciones
--		a. Nombre
--		b. Apellido
--		c. Tipo direcci�n
--		d. L�nea 1
--		e. L�nea 2
--		f. Ciudad

SELECT P.FirstName AS 'Nombre', 
	   P.LastName AS 'Apellido', 
	   ADT.Name AS 'Tipo de direcci�n', 
	   ADDR.AddressLine1 AS 'L�nea 1', 
	   ADDR.AddressLine2 AS 'L�nea 2', --Aqu� se esperan valores NULL ya que no todas las personas tienen registrada una L�nea 2
	   ADDR.City AS 'Ciudad'
FROM Person.Person P 
			inner join Person.BusinessEntity BE ON P.BusinessEntityID = BE.BusinessEntityID 
				inner join Person.BusinessEntityAddress BEA ON BE.BusinessEntityID = BEA.BusinessEntityID
					inner join Person.Address ADDR ON BEA.AddressID = ADDR.AddressID
						inner join Person.AddressType ADT ON BEA.AddressTypeID = ADT.AddressTypeID