select p.Name,YEAR(StartDate) as año, COUNT(1) as cantidad
from Production.WorkOrder wo
inner join Production.Product p on
wo.ProductID = p.ProductID
group by name,YEAR(StartDate) order by 1,2

create procedure Purchasing.uspProblema_2 
@año integer,@mes integer, @producto varchar(10)
as
begin
declare @shipmethod varchar(10)

select @shipmethod = poh.ShipMethodID from Purchasing.PurchaseOrderHeader poh
inner join Purchasing.PurchaseOrderDetail pod on
poh.PurchaseOrderID = poh.PurchaseOrderID
where year(OrderDate) = @año and MONTH(OrderDate) = @mes
and pod.ProductID = @producto

update PurchaseOrderHeader set ShipMethodID = @shipmethod
end

create function Purchasing.PromedioPrecioUnitario
(@orderId integer)
returns money
as
begin

declare @retorno money 
select @retorno = avg(UnitPrice)
from Purchasing.PurchaseOrderDetail poh
where poh.PurchaseOrderID = @orderId

return @retorno
end
