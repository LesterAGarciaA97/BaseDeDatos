USE AdventureWorks2017;

-- 4) Aplicar un aumento del 10% a todos los empleados de la empresa:
--		a. Utilizando un cursor:
--			i. Actualizar el "rate", aumentando un 10% del último sueldo.
--			ii. Si la persona es de Ventas, aumentar también un 10% su bono. Implementando un Trigger.

Select E.BusinessEntityID, EPH.Rate, ED.Department into HumanResources.EmployeeDepartmentPay
from HumanResources.Employee E 
		inner join HumanResources.EmployeePayHistory EPH on (E.BusinessEntityID = EPH.BusinessEntityID)
			inner join HumanResources.vEmployeeDepartment ED on (ED.BusinessEntityID = E.BusinessEntityID)


select * 
from HumanResources.EmployeeDepartmentPay


Declare @ID int,
		@RatePay money,
		@DepartmentPay nvarchar(50)
Declare C_UpdatePay cursor
for select *
	from HumanResources.EmployeeDepartmentPay
Open C_UpdatePay
fetch next from C_UpdatePay into @ID, @RatePay, @DepartmentPay
	while(@@FETCH_STATUS = 0)
	begin 
		Update HumanResources.EmployeeDepartmentPay
		set Rate = @RatePay + (@RatePay * 0.10) 
		where BusinessEntityID = @ID
		fetch next from C_UpdatePay into @ID, @RatePay, @DepartmentPay
	end
Close C_UpdatePay
Deallocate C_UpdatePay
Go

Create trigger HumanResources.tiu_UpdatePaySales on HumanResources.EmployeeDepartmentPay after update as
	begin
	Declare @ID int,
			@RatePay money,
			@DepartmentPay nvarchar(50)
	if UPDATE(Rate)
	begin 
		Select  @ID = BusinessEntityID, @RatePay = Rate 
		From inserted 
		Where Department = 'Sales'
	 --Luego de tener el valor de los 18 empleados de Sales se procede a realizar el update
		Update HumanResources.EmployeeDepartmentPay
		set Rate = @RatePay + (@RatePay * 0.10)
		Where BusinessEntityID = @ID
	print 'Sueldo actualizado de empleados del departamento Sales'
	End
End
