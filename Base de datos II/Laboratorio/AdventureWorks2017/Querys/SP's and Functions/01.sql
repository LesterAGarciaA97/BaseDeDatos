USE AdventureWorks2017;

--Crear SP que reciba el apellido de un contacto y regresa el ID Contact de la primera ocurrencia con dicho apellido

CREATE PROCEDURE Person.uspGetCodeContact
  @plastName VARCHAR(50),
  @pContacId INTEGER OUTPUT 
  AS
BEGIN
  SELECT TOP 1 @pContacId =  P.BusinessEntityID
  FROM Purchasing.Vendor V
    inner join Person.BusinessEntityContact BEC 
        ON V.BusinessEntityID = BEC.BusinessEntityID
      inner join Person.Person P
          ON BEC.PersonID = P.BusinessEntityID
  WHERE P.LastName = @plastName
END

--exec nombre_procedimiento parametros