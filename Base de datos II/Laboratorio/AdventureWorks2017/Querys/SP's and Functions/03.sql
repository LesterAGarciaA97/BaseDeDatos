-- Crear funcion que retorne la existancia de un producto en el inventario

CREATE FUNCTION getProductStock(@id INT) RETURNS INT
AS 
BEGIN
DECLARE @iRetorna INT
SELECT @iRetorna= Quantity
FROM Production.ProductInventory
WHERE ProductID = @id and LocationID = 50
IF @iRetorna is null
BEGIN SET @iRetorna = 0 END
RETURN @iRetorna
END

SELECT ProductID, NAME, dbo.getProductStock(ProductID) AS Existencia  FROM  Production.Product
ORDER BY 1