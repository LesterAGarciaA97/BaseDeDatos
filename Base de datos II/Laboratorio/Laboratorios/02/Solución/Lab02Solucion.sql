-- Lester Andrés García Aquino - 1003115
-- Héctor Rodrigo Zetino Chinchilla - 1295617


-- Laboratorio 02 - Triggers

-- No permita ingresar una tarjeta de crédito con diferencia de fecha de expiración menor a 30 días.

CREATE trigger Sales.ti_AgregarTarjeta ON Sales.CreditCard AFTER INSERT AS
   
DECLARE @CMonth INT
DECLARE @CYear INT

  SET @CMonth = (SELECT expmonth FROM inserted)
  SET @CYear = (SELECT expyear FROM inserted)

  IF (@CYear < year(GETDATE()) AND @CMonth < (MONTH(getdate()) - 1))
  BEGIN

  DELETE FROM Sales.CreditCard
  WHERE CreditCard.CreditCardID = (SELECT CreditCardID FROM inserted) -- Si se agrega una tarjeta de crédito cuya fecha de vencimiento no cumpla con los requisitos dados, se elimina automáticamente luego de haber sido insertada.
  END

-- No permita ingresar y/o actualizar un correo electrónico asociado a otra persona.

SELECT p.BusinessEntityID, EA.EmailAddress INTO Person.NuevoCorreo 
FROM Person.EmailAddress EA 
    inner join Person.Person p ON EA.BusinessEntityID = p.BusinessEntityID

CREATE TRIGGER tu_validar_correo ON
Person.NuevoCorreo
AFTER UPDATE
AS
IF UPDATE(EmailAddress)
BEGIN
DECLARE @Correo VARCHAR(100)
DECLARE @Comprueba INT
SELECT @Correo = EmailAddress 
FROM inserted
SELECT @Comprueba = COUNT(EmailAddress) 
FROM Person.EmailAddress WHERE EmailAddress = @Correo
IF(@valiCompruebadar > 0)
BEGIN
PRINT 'EL CORREO INGRESADO POR EL USARIO CUMPLE LOS REQUISITOS'
END
IF(@Comprueba = 0)
BEGIN
UPDATE Person.EmailAddress SET EmailAddress = @Correo
END
END

-- Actualizar el inventario del producto al vender cada uno de ellos. Al momento que se confirma y/o cancela la venta. (Primero actualizar el status de las ventas con un)

SELECT soh.SalesOrderID,sod.OrderQty,sod.ProductID,pri.Quantity,soh.Status INTO Sales.Material 
FROM Sales.SalesOrderHeader soh 
    inner join Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID 
        inner join Production.ProductInventory pri ON sod.ProductID = pri.ProductID

SELECT * 
FROM Sales.Material

ALTER trigger sales.P2_Material ON 
Sales.Material
AFTER UPDATE AS 
IF UPDATE(STATUS) 
BEGIN
DECLARE @newStatus INT
DECLARE @SalesOrderID INT
SELECT @newStatus = status,@SalesOrderID = SalesOrderID FROM inserted
IF (@newStatus = 2) OR (@newStatus = 6)
BEGIN
DECLARE @cantidad INT
DECLARE @ProductID INT
UPDATE Sales.SalesOrderHeader SET STATUS = @newStatus WHERE SalesOrderID = @SalesOrderID
IF(@newStatus = 2)
BEGIN
SELECT @cantidad = OrderQty,@ProductID = ProductID FROM Sales.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID
UPDATE Production.ProductInventory SET Quantity = Quantity - @cantidad 
WHERE ProductID = @ProductID
END
END
END