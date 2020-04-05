USE ElBuenGusto;

--Tiempo promedio de revisiones realizadas en el último semestre.
SELECT AVG(DATEDIFF(DAY,Fecha_Ingreso,Fecha_Salida) ) AS 'Tiempo promedio de evisión' 
FROM REVISION 
WHERE ((MONTH(Fecha_Salida) BETWEEN 1 AND 3) AND (MONTH(Fecha_Ingreso) BETWEEN 1 AND 3) AND YEAR(Fecha_Salida) = 2020)

--Listado de clientes con sus respectivas compras (vehículos) realizados.
SELECT (c.Id_Cliente) AS 'ID Cliente', a.Placa_Automovil FROM Cliente c inner join Automovil a ON c.Id_Cliente = a.Id_Cliente

--Cantidad de operaciones para cada vehículo, que hayan utilizado por lo menos 2 materiales.
SELECT SUM(m.Materiales_Utilizados) AS 'Cantidad de operaciones', r.Placa_Automovil AS 'Placa automóvil' 
FROM REVISION r inner join OPERACION o ON r.Id_Revision = o.Id_Revision inner join MATERIAL m ON o.Id_Operacion = m.Id_Operacion
GROUP BY r.Placa_Automovil,o.Id_Operacion  HAVING COUNT(m.Materiales_Utilizados) >= 2

