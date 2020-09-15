USE AdventureWorks2017;

-- 2) Mostrar las personas con sus respectivas direcciones
--		a. Nombre
--		b. Apellido
--		c. Tipo dirección
--		d. Línea 1
--		e. Línea 2
--		f. Ciudad

SELECT P.FirstName AS 'Nombre', 
	   P.LastName AS 'Apellido', 
	   ADT.Name AS 'Tipo de dirección', 
	   ADDR.AddressLine1 AS 'Línea 1', 
	   ADDR.AddressLine2 AS 'Línea 2', --Aquí se esperan valores NULL ya que no todas las personas tienen registrada una Línea 2
	   ADDR.City AS 'Ciudad'
FROM Person.Person P 
			inner join Person.BusinessEntity BE ON P.BusinessEntityID = BE.BusinessEntityID 
				inner join Person.BusinessEntityAddress BEA ON BE.BusinessEntityID = BEA.BusinessEntityID
					inner join Person.Address ADDR ON BEA.AddressID = ADDR.AddressID
						inner join Person.AddressType ADT ON BEA.AddressTypeID = ADT.AddressTypeID