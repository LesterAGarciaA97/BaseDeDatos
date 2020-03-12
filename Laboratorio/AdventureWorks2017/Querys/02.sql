use AdventureWorks2017

select * 
from HumanResources.Employee

Select count (*)
from HumanResources.Employee

Select count (OrganizationLevel)
from HumanResources.Employee  --No se recomienda cuando quieren verse TODOS los registros ya que pueden existir nulos

Select count (distinct OrganizationLevel)
from HumanResources.Employee

Select count (distinct BirthDate)
from HumanResources.Employee

Select *
from HumanResources.Employee where JobTitle like '%S%' --Contengan S

Select *
from HumanResources.Employee where JobTitle like 'S%' --Empiezan con S

Select *
from HumanResources.Employee where JobTitle like '%S' --Finalicen con S

Select *
from HumanResources.Employee where SUBSTRING(JobTitle,3,1)='S' --Retorna los datos que contengan una S en la tercera posicionn del campo JobTitle


Select *
from HumanResources.Employee, HumanResources.JobCandidate  --EVITAR PRODUCTO CARTESIANO

select *
from HumanResources.Employee, HumanResources.EmployeePayHistory
where HumanResources.Employee.BusinessEntityID = HumanResources.EmployeePayHistory.BusinessEntityID --Para evitar prpducto catesiano, se buscan campos que conecten directamente una tabla con otra (llave primaria y foránea)

select *
from HumanResources.Employee E, HumanResources.EmployeePayHistory P
where E.BirthDate = P.RateChangeDate --Para evitar escribir todo se usan alias... No se encontrará coincidencias, pero se elimina el producto cartesiano

select *
from HumanResources.Employee E
		inner join HumanResources.EmployeeDepartmentHistory P
			on E.BusinessEntityID = P.BusinessEntityID

select *
from Production.Product
where name like 'M%' and ListPrice between 500 and 1500 

Select Name, ProductNumber, Weight, ListPrice,SUBSTRING(name,1,1)
from Production.Product
where SUBSTRING(name,1,1) = 'M'
	AND ListPrice >= 500
	AND ListPrice <= 1500

Select Name, ProductNumber, Weight, ListPrice,SUBSTRING(name,1,1)
from Production.Product
where (SUBSTRING(name,1,1) = 'M'
	OR SUBSTRING(name,1,1) = 'H') --Con los () se mantiene la lógica matemática
	AND ListPrice >= 500
	AND ListPrice <= 1500

