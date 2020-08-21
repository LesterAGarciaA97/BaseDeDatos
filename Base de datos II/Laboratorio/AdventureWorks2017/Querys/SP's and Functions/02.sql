DECLARE @pID INTEGER
SET @pID = 0 
EXEC Person.uspGetCodeContact 'Mohan' , @pID OUTPUT
IF (@pID = 0)
BEGIN	 
  PRINT 'Contacto no encontrado'
END
ELSE
BEGIN
    SELECT FirstName, LastName
    FROM Person.Person
    WHERE BusinessEntityID = @pID
END