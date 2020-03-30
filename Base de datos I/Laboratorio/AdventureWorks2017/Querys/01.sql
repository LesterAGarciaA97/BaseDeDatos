select *
from Production.Product  --Proyecci�n de una tabla con el SELECT

select *
from Production.ProductCategory  --Producto cartesiano (EVITAR HACER ESO)

select *
from Production.Product 
where ListPrice between 25 and 35  --'WHERE' --> Selecci�n de �lgebra relacional

select ProductID, Name, Color, ListPrice --Proyecci�n de datos
from Production.Product 
where ListPrice between 25 and 35

select ProductID, Name, Color, ListPrice --Proyecci�n de datos
from Production.Product 
where ListPrice >= 25 and ListPrice <= 35

select *
from Production.Product
where Name like 'B%'  --Se realiza un SELECT en donde el nombre de los productos inicien con la letra B

select *
from Production.Product
where ProductNumber = 'CB-2903' --B�squeda espec�fica

select *
from Production.Product
where Color = 'Red' --B�squeda espec�fica

select *
from Production.Product
where Name like 'r%' and DATALENGTH(Name) = 2 --Que comiencen con una letra espec�fica y que seguidamente lleva solamente un car�cter

select ProductID, Name, Color, ListPrice, LEN(name)
from Production.Product
where Name like 'r%'
order by LEN(Name)  --Ordena las palabras por la longitud de la cadena completa (Al hacer el query se mostrar� la longitud en una columna sin nombre)

select ProductID, Name, Color, ListPrice, LEN(name)
from Production.Product
where Name like 'r%'
order by LEN(Name) desc --Ordena los datos descendentemente

select ProductID, Name, Color, ListPrice, LEN(name)
from Production.Product
where Weight is null
order by LEN(Name) desc

select ProductID, Name, Color, ListPrice, LEN(name)
from Production.Product
where Weight is not null
order by LEN(Name) desc

select ProductID, Name, Color, ListPrice, LEN(name)
from Production.Product
where Weight is not null
order by Color desc

select ProductID, Name, Color, ListPrice, LEN(name)
from Production.Product
where Weight is not null
order by LEN(Name), Color desc

select ProductID, Name, Color, ListPrice, LEN(name)
from Production.Product
where Weight is not null
order by LEN(Name) asc, Color desc
