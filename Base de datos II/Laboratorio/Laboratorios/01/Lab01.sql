-- Iván Andrés Arango Saucedo - 1158116
-- Héctor Rodgrigo Zetino Chinchilla - 1295617
-- Lester Andrés García Aquino - 1003115

USE AdventureWorks2017;

--1. ¿Cuántas ordenes de trabajo se han realizado por producto en cada año?
	--a. Nombre producto
	--b. Año
	--c. Cantidad de ordenes de trabajo
SELECT P.Name AS [Nombre Producto], count(1) AS [Cantidad], YEAR(Wo.StartDate) AS [Anio] 
FROM Production.WorkOrder WO
  inner join Production.Product P ON (WO.ProductID = P.ProductID)
GROUP BY P.Name, YEAR(WO.StartDate)
ORDER BY YEAR(WO.StartDate) ASC, P.Name ASC

--2. Crear un procedimiento que actuailce el método de entrega para todas las compras realizadas en un año y mes específico
--   validando que dicha compra contenga cierto producto (nombre).
		--a. Parámetros: año, mes, producto
		--b. Tabla y campo a actualizar: PurchaseOrderHeader, ShipMethodID

create procedure uspProblema2 
@año int, @mes integer, @producto varchar(MAX)
as
begin

declare @shipMethodId int

select @shipMethodId = sm.ShipMethodID from Purchasing.PurchaseOrderHeader poh inner join Purchasing.ShipMethod sm on poh.ShipMethodID = sm.ShipMethodID
where YEAR(poh.OrderDate) = @año and MONTH(OrderDate) = @mes and sm.Name = @producto

update Purchasing.PurchaseOrderHeader set ShipMethodID = @shipMethodId 

end

exec uspProblema2 2011,4,'ZY - EXPRESS'


--3. Crear una función que calcule el promedio del precio unitario para una compra en específico.
--   Utilice la  función en una consulta mostrando:
		--a. Número de orden
		--b. Fecha
		--c. Total
		--d. Promedio precio unitario (utilizar función)

