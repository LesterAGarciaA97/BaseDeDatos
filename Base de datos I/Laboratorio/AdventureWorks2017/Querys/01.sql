select *
from Production.Product  --Proyección de una tabla con el SELECT

select *
from Production.ProductCategory  --Producto cartesiano (EVITAR HACER ESO)

select *
from Production.Product 
where ListPrice between 25 and 35  --'WHERE' --> Selección de álgebra relacional

select ProductID, Name, Color, ListPrice --Proyección de datos
from Production.Product 
where ListPrice between 25 and 35

select ProductID, Name, Color, ListPrice --Proyección de datos
from Production.Product 
where ListPrice >= 25 and ListPrice <= 35

select *
from Production.Product
where Name like 'B%'  --Se realiza un SELECT en donde el nombre de los productos inicien con la letra B

select *
from Production.Product
where ProductNumber = 'CB-2903' --Búsqueda específica

select *
from Production.Product
where Color = 'Red' --Búsqueda específica

select *
from Production.Product
where Name like 'r%' and DATALENGTH(Name) = 2 --Que comiencen con una letra específica y que seguidamente lleva solamente un carácter

select ProductID, Name, Color, ListPrice, LEN(name)
from Production.Product
where Name like 'r%'
order by LEN(Name)  --Ordena las palabras por la longitud de la cadena completa (Al hacer el query se mostrará la longitud en una columna sin nombre)

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
