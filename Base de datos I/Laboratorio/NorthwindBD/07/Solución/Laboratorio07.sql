--La cantidad de productos descontinuados 
SELECT COUNT(1) AS [Total de productos que se encuentran descontinuados] 
FROM Products
WHERE Discontinued IS NOT NULL --Con esto se valida que si existen datos o no, y como es con tipo byte, la lógica que se toma es 1 = true , 0 = false.

--Mostrar las cantidades totales ordenadas por cada c�digo de producto (del detalle de ordenes)
SELECT COUNT(Quantity) AS [Cantidades totales], OD.ProductID 
FROM [Order Details] OD GROUP BY OD.ProductID

--Mostrar una lista de códigos de clientes, que han realizado pedidos con fecha requerida entre 1 de enero de 1997 y 1 de enero de 1998, y que su "freith" esté por abajo de 100 unidades.
SELECT CustomerID
FROM Orders
WHERE (RequiredDate between '01/01/1997' and '01/01/1998') and (Freight < 100)

--Lester Andrés García Aquino 1003115
--Yazmine Isabel Sierra Aragón 1174916