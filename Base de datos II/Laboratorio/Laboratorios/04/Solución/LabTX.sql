--Lester Andrés García Aquino - 1003115
--Héctor Rodrigo Zetino Chinchilla - 1295617

USE AdventureWorks2017;


--Realizar un proceso para la carga de datos de personas con sus números telefónicos.  La carga se realizará a partir de un archivo .csv con el formato:
--Nombre1, Nombre2, Apellido, tipo teléfono o teléfono, no insertarlo.
--Y poder manejar los errores para permitir y asegurar la actualización de los datos (según su nivel) aunque existan errores posteriores.

BEGIN TRANSACTION
BEGIN TRY
	BULK INSERT
	AdventureWorks2017.dbo.Person.Person
	FROM 'C:\Users\leste\Desktop'
		WITH
		(
			ROWTERMINATOR = '\r\n',
			DATAFILETYPE = 'char',
			FIELDTERMINATOR = ','
		);
			INSERT Person.Person
			WHERE
			COMMIT
END TRY
BEGIN CATCH
	ROLLBACK;
	PRINT 'TERMINADO'
END CATCH


--Crear un procedimiento que aplique un descuento D a cada uno de los productos vendidos para cierta orden de venta.  Siempre y cuando
--la cantidad de dicho producto	sea mayor a 2.  Mientras ocurre dicha actualización nadie puede visualizar ni actualizar la información
--relacionada a dicha orden.

CREATE PROCEDURE Sales.uspDescuento 
@OrderID INT, @DiscountPorcentage MONEY AS
	BEGIN
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		BEGIN TRAN
			SELECT *
			FROM Sales.SalesOrderDetail 
			WHERE OrderQty > 2 AND SalesOrderID = @OrderID
			IF @@ROWCOUNT >= 1
				BEGIN
					UPDATE Sales.SalesOrderDetail SET UnitPriceDiscount = @DiscountPorcentage 
					WHERE SalesOrderID = @OrderID and OrderQty > 2
					COMMIT
				END
			ELSE 
				BEGIN
					PRINT 'ERROR, no se puede continuar con la tarea'
					ROLLBACK
				END
		END


--Al departamento de DWH le han solicitado generar una tabla resumen de las compras realizadas.  Dichas tabla resumen requiere la información
--de: Año, Mes, Producto, Cantidad de unidades, precio y descuentos aplicados.
--Dicha información se debe generar cada hora y debe asegurarse de generar el 100% de los registros, aun así, se estén actualizando.

--¿Qué riesgo encuentra dentro de esta generación de datos?
	--Que tanta manipulación de datos pueda alterar la integridad de la información o incluso que del lado de la confidencialidad se filtre algo.
--¿Qué sugerencia/cambio aplicaría a la solicitud?
	--Que dicha información se genere por mes, ya que es un tiempo más largo y con mucha más información sólida para poder manejar.

SELECT DATEPART(YEAR,SOD.ModifiedDate) AS [AÑO], 
	   DATEPART(MONTH, SOD.ModifiedDate) AS [MES], 
	   SOD.ProductID AS [Producto Vendido] , 
	   P.Name AS [Nombre del producto], 
	   SOD.OrderQty AS [Cantidad], 
	   SOD.UnitPrice AS [Precio],
	   SOD.UnitPriceDiscount AS [Desdcuentos aplicados]
--insert into Resumen
FROM Sales.SalesOrderDetail SOD
		INNER JOIN Production.Product P ON SOD.ProductID = P.ProductID