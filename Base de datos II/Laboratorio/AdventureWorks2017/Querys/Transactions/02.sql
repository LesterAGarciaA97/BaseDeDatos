/*
1. Crear procedimiento que inserte en SalesOrderHeader
	-Reciba las columnas necesarias para insertar
	Reciba cuantos productos ( lineas ) tendrá el detalle

2.	Insertar en SalesOrderDetail
	-Utilizo el mismo del header o creo uno adicional?
	-Maneja los errores para determinar o confirmar los que si aplican
	-Presentar el resultado de detalle
	-Actualizar columnas respectivas de detalle
*/

create or alter procedure Sales.spIngresaVenta
@pOrderDate date,@pCustomerID int,@nProductos int,@pvalida int output
as
begin
declare @var_ciclo int
declare @var_rden_nueva int

begin tran

insert into Sales.SalesOrderHeader
	   (OrderDate,DueDate,CustomerID,BillToAddressID,ShipToAddressID,ShipMethodID)
values (@pOrderDate,'10/09/2020',@pCustomerID,1,1,1)

set @var_rden_nueva =SCOPE_IDENTITY()	--@@IDENTITY

if(@@ERROR = 0)
begin
set @var_ciclo = 1

while(@var_ciclo <= @nProductos)
begin
set @var_ciclo += 1

EXEC sales.PIngresaVentaDetalle @var_rden_nueva

end

update Sales.SalesOrderHeader set SubTotal = 
(select sum(LineTotal) from Sales.SalesOrderDetail where SalesOrderDetailID = @var_rden_nueva)
where SalesOrderID = @var_rden_nueva

if @@ERROR = 0
begin commit print 'Todo ok' end
else begin rollback print 'Error update' end

commit
set @pvalida = 1
end

else
begin
rollback
print 'error'
set @pvalida = 0
end

end

declare @validar int
exec Sales.spIngresaVenta '01/30/2020',5,6,@validar output
print @validar

select *from Sales.SalesOrderDetail order by 1 desc
create or alter procedure sales.PIngresaVentaDetalle
@pOrderId int
as
begin

begin tran

insert into Sales.SalesOrderDetail
(SalesOrderID,ProductID,OrderQty,SpecialOfferID,UnitPrice)
values(@pOrderId,772,5,1,25.50)

if @@ERROR = 0

 begin
	commit 
 end

else
begin
	rollback
end

end

select *from Sales.SalesOrderDetail where SalesOrderID = 75131