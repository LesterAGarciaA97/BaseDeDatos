--Ejemplo # 1
BEGIN TRANSACTION
update Person.CountryRegion
set Name = 'otro'
where CountryRegionCode = 'AD' 

if((1+1) = 2)
begin
rollback transaction;
--rollback se utiliza para revertir la transaccion
print 'rollback'
end

else
begin
commit transaction
--commit se usa para la transaccion sea realizada de manera permanente
print 'commit'
end

--Ejemplo # 2
--puede servir para incrementar los likes

alter table sales.SalesPerson
add mayor int

begin transaction

update sales.SalesPerson set mayor = 
(	select case when count(1) > 50 then 1 else 0 end mayor
from sales.SalesOrderHeader where SalesPersonID = BusinessEntityID
)
--roww count es el total de filas afectadas en la previa transaccion
if(@@rowCOUNT > 5)
begin
commit
print 'commit'
end

else
begin
rollback
print 'rollback'
end

--Ejercicio # 3
begin transaction

update HumanResources.EmployeePayHistory
set payfrequency = 9304 
where rate between 50 and 150

--Variable de sql que valida si hay errores
if(@@error <> 0)
begin
rollback
print 'rollback'
end

else
begin
print 'commit'
end


--Ejercicio # 4

begin transaction

begin try
update HumanResources.EmployeePayHistory
set payfrequency = 9304 
where rate between 50 and 150
print 'commit'
commit
end try

begin catch
print 'rollback'
rollback
select ERROR_NUMBER() as numero, ERROR_LINE() as linea,ERROR_MESSAGE() as mensaje,ERROR_PROCEDURE() as proce
end catch

--select *from sys.sysprocesses

--ejercicio 5
begin tran

update HumanResources.EmployeePayHistory
set PayFrequency = 1
where rate between 50 and 150

while(1=1)
begin
print 'd'
end

rollback




















