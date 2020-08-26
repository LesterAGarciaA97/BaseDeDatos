-- Iv�n Andr�s Arango Saucedo - 1158116
-- H�ctor Rodgrigo Zetino Chinchilla - 1295617
-- Lester Andr�s Garc�a Aquino - 1003115

USE AdventureWorks2017;

--1. �Cu�ntas ordenes de trabajo se han realizado por producto en cada a�o?
	--a. Nombre producto
	--b. A�o
	--c. Cantidad de ordenes de trabajo
SELECT P.Name AS [Nombre Producto], count(1) AS [Cantidad], YEAR(Wo.StartDate) AS [Anio] 
FROM Production.WorkOrder WO
  inner join Production.Product P ON (WO.ProductID = P.ProductID)
GROUP BY P.Name, YEAR(WO.StartDate)
ORDER BY YEAR(WO.StartDate) ASC, P.Name ASC

--2. Crear un procedimiento que actuailce el m�todo de entrega para todas las compras realizadas en un a�o y mes espec�fico
--   validando que dicha compra contenga cierto producto (nombre).
		--a. Par�metros: a�o, mes, producto
		--b. Tabla y campo a actualizar: PurchaseOrderHeader, ShipMethodID

create procedure uspProblema2 
@a�o int, @mes integer, @producto varchar(MAX)
as
begin

declare @shipMethodId int

select @shipMethodId = sm.ShipMethodID from Purchasing.PurchaseOrderHeader poh inner join Purchasing.ShipMethod sm on poh.ShipMethodID = sm.ShipMethodID
where YEAR(poh.OrderDate) = @a�o and MONTH(OrderDate) = @mes and sm.Name = @producto

update Purchasing.PurchaseOrderHeader set ShipMethodID = @shipMethodId 

end

exec uspProblema2 2011,4,'ZY - EXPRESS'


--3. Crear una funci�n que calcule el promedio del precio unitario para una compra en espec�fico.
--   Utilice la  funci�n en una consulta mostrando:
		--a. N�mero de orden
		--b. Fecha
		--c. Total
		--d. Promedio precio unitario (utilizar funci�n)

