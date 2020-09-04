USE AdventureWorks2017;

-- Crear una copia del objeto

SELECT *
into Purchasing.copiaDetalle
FROM Purchasing.PurchaseOrderDetail

SELECT *
INTO Purchasing.copiaHeader
FROM Purchasing.PurchaseOrderHeader



SELECT *
FROM Purchasing.copiaDetalle

--Crear una regla donde al actualizar la cantidad de productos en una línea de detalle, actualiza automáticamente el subtotal de dicha línea de detalle
--Adicional: Actualizar en los N campos de las N tablas respectivas que impacte
UPDATE Purchasing.copiaDetalle
SET OrderQty = 5
WHERE PurchaseOrderID = 1 and PurchaseOrderDetailID = 1

SELECT *
FROM Purchasing.copiaDetalle
WHERE PurchaseOrderID = 1 AND PurchaseOrderDetailID = 1

ALTER TRIGGER purchasing.tu_cambia_detalle ON Purchasing.copiaDetalle AFTER UPDATE 
AS
	IF UPDATE(orderQty) OR UPDATE(unitPrice) --Validar por campo
	BEGIN
	UPDATE Purchasing.copiaDetalle
	SET LineTotal = copiaDetalle.orderQty * copiaDetalle.UnitPrice
	FROM inserted i
		 WHERE i.PurchaseOrderID = copiaDetalle.PurchaseOrderID AND
			   i.PurchaseOrderDetailID = copiaDetalle.PurchaseOrderDetailID;
	
	UPDATE Purchasing.copiaHeader
	SET Subtotal = (SELECT SUM(lineTotal) FROM Purchasing.copiaDetalle)
	FROM inserted i
	     WHERE i.PurchaseOrderID = copiaHeader.PurchaseOrderID;
END;