use AdventureWorks2017;

declare @Codigo INT, @Estado nchar(1), @Genero nchar(1), @Salario money
declare Lab cursor

for( select HRE.BusinessEntityID,HRE.Gender,HRE.MaritalStatus,EPH.Rate  from HumanResources.Employee HRE 
inner join HumanResources.EmployeePayHistory EPH on HRE.BusinessEntityID = EPH.BusinessEntityID where  YEAR(EPH.ModifiedDate) = 2014)

open Lab
fetch NEXT FROM Lab into @Codigo,@Estado,@Genero,@Salario
while(@@FETCH_STATUS = 0)
begin
 if(@Estado = 'M' and @Genero = 'F')
begin 
set @Salario = (@Salario * 0.10)+ @Salario
print cast(@Codigo as nvarchar) + '-'+ cast(@Genero as nvarchar) + '-' + cast(@Estado as nvarchar) + '-' +cast(@Salario as nvarchar)
end

else 
begin set @Salario = (@Salario * 0.05)+ @Salario 
print cast(@Codigo as nvarchar) + '-'+ cast(@Genero as nvarchar) + '-' + cast(@Estado as nvarchar) + '-' +cast(@Salario as nvarchar)
end

fetch next from  Lab into @Codigo,@Estado,@Genero,@Salario
end
close Lab
Deallocate Lab
GO

--Yazmine Isabel Sierra Aragon 1174916
--Lester Andres Garcia Aquino 10031115