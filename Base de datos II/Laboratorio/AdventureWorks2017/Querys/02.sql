USE AdventureWorks2017;

-- Procedimiento que obtenga el primer contacto ordenado por apellido
CREATE PROCEDURE Person.uspObtenerContacto AS
BEGIN
	SELECT v.Name, p.LastName, p.FirstName
	FROM Purchasing.Vendor v
		inner join Person.BusinessEntityContact bec
					ON v.BusinessEntityID = bec.BusinessEntityID
			inner join person.Person p
					ON p.BusinessEntityID = bec.PersonID
				inner join person.ContactType ct
					ON bec.ContactTypeID = ct.ContactTypeID
END

EXEC Person.uspObtenerContacto

-- Crear SP que obtenga el primer contacto ordenado por nombre recibiendo de parámetro el apellido
CREATE PROCEDURE Person.uspObtenerContacto
				@pLastName VARCHAR(50) , @pOtro INTEGER AS
BEGIN
	SELECT v.Name, p.LastName, p.FirstName
	FROM Purchasing.Vendor v
		inner join Person.BusinessEntityContact bec
					ON v.BusinessEntityID = bec.BusinessEntityID
			inner join person.Person p
					ON p.BusinessEntityID = bec.PersonID
				inner join person.ContactType ct
					ON bec.ContactTypeID = ct.ContactTypeID
	WHERE p.LastName = @pLastName
	order by FirstName;
END

EXEC Person.uspObtenerContacto 'Moya', 1