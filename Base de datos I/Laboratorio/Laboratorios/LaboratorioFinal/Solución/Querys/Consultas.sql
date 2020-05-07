/*Listado de asistencias (marcajes) de todo el personal, para el mes actual, 
ordenado por fecha de asistencia y nombre departamento/facultad.*/

SELECT E.Id_Empleado, MA.Hora_Entrada AS 'ENTRADA ADMINISTRACIÓN', MD.Hora_Entrada AS 'ENTRADA DOCENTE', 
MA.Fecha AS 'MARCAJE ADMINISTRACION', MD.Fecha AS 'MARCAJE DOCENTE',
FA.Nombre, DEP.Nombre
FROM dbo.EMPLEADO E FULL OUTER JOIN
dbo.ADMINISTRACION AD ON E.Id_Administracion=AD.Id_Administracion FULL OUTER JOIN
dbo.MARCAJE_ADMINISTRACION MA ON MA.Id_Administracion = AD.Id_Administracion
FULL OUTER JOIN dbo.DOCENTE DO ON DO.Id_Docente = E.Id_Docente FULL OUTER JOIN
dbo.MARCAJE_DOCENTE MD ON MD.Id_Docente = DO.Id_Docente FULL OUTER JOIN dbo.FACULTAD FA
ON FA.Id_Docente = DO.Id_Docente FULL OUTER JOIN dbo.DEPARTAMENTO DEP 
ON DEP.Id_Administracion = AD.Id_Administracion
WHERE (Ma.Fecha BETWEEN '2020-05-01'AND '2020-05-05') OR (MD.Fecha BETWEEN '2020-05-01'AND '2020-05-05') AND AD.Id_Administracion IS NULL
AND DO.Id_Docente IS NULL
GROUP BY e.Id_Empleado,MA.Hora_Entrada, MD.Hora_Entrada, MA.Fecha, MD.Fecha, FA.Nombre, DEP.Nombre
ORDER BY e.Id_Empleado,MA.Hora_Entrada, MD.Hora_Entrada,MA.Fecha, MD.Fecha, FA.Nombre, DEP.Nombre


/*Cantidad de llegadas tarde del personal administrativo, por cada departamento de los últimos 15 días. 
(no tomar en cuenta inasistencias) */
SELECT E.Id_Empleado, MA.Hora_Entrada AS 'ENTRADA ADMINISTRACIÓN', MD.Hora_Entrada AS 'ENTRADA DOCENTE', 
MA.Fecha AS 'FECHA ADMINISTRACION', MD.Fecha AS 'FECHA DOCENTE',
FA.Nombre, DEP.Nombre
FROM dbo.EMPLEADO E INNER JOIN
dbo.ADMINISTRACION AD ON E.Id_Administracion=AD.Id_Administracion INNER JOIN
dbo.MARCAJE_ADMINISTRACION MA ON MA.Id_Administracion = AD.Id_Administracion
INNER JOIN dbo.DOCENTE DO ON DO.Id_Docente = E.Id_Docente INNER JOIN
dbo.MARCAJE_DOCENTE MD ON MD.Id_Docente = DO.Id_Docente INNER JOIN dbo.FACULTAD FA
ON FA.Id_Docente = DO.Id_Docente INNER JOIN dbo.DEPARTAMENTO DEP 
ON DEP.Id_Administracion = AD.Id_Administracion
WHERE (MA.Fecha BETWEEN '2020-04-21' AND '2020-05-05' ) and (MD.Fecha BETWEEN '2020-04-21' AND '2020-05-05') 
and MA.Hora_Entrada > '07:00:00' and MD.Hora_Entrada > '14:20:00'
GROUP BY E.Id_Empleado, FA.Nombre, DEP.Nombre, ma.Hora_Entrada, md.Hora_Entrada, md.Fecha, ma.Fecha


/*Listado de personas que no se presentaron el día de hoy. Ordenado por apellido y edad.*/
SELECT E.Nombre, DATEDIFF(YEAR,E.Fecha_Nacimiento, GETDATE()) AS 'Edad'
FROM dbo.EMPLEADO E INNER JOIN
dbo.ADMINISTRACION AD ON E.Id_Administracion=AD.Id_Administracion INNER JOIN
dbo.MARCAJE_ADMINISTRACION MA ON MA.Id_Administracion = AD.Id_Administracion
INNER JOIN dbo.DOCENTE DO ON DO.Id_Docente = E.Id_Docente INNER JOIN
dbo.MARCAJE_DOCENTE MD ON MD.Id_Docente = DO.Id_Docente
WHERE (MA.Hora_Entrada IS NULL AND MA.Hora_Salida IS NULL) AND (MD.Hora_Entrada IS NULL AND MD.Hora_Salida IS NULL) AND
(MA.Fecha = '2020-05-05') AND (MD.Fecha = '2020-05-05')
ORDER BY E.Apellido, DATEDIFF(YEAR,E.Fecha_Nacimiento, GETDATE())


/*Cantidad de personas por turno y por género.*/
SELECT COUNT (E.Id_Empleado) AS 'Cantidad de personas', e.Genero, DO.Turno_Docente, AD.Turno_Admonistracion
FROM dbo.EMPLEADO E INNER JOIN
dbo.ADMINISTRACION AD ON E.Id_Administracion=AD.Id_Administracion INNER JOIN
dbo.MARCAJE_ADMINISTRACION MA ON MA.Id_Administracion = AD.Id_Administracion
INNER JOIN dbo.DOCENTE DO ON DO.Id_Docente = E.Id_Docente
GROUP BY E.Genero,DO.Turno_Docente, AD.Turno_Admonistracion
ORDER BY E.Genero,DO.Turno_Docente, AD.Turno_Admonistracion

/*- Listado de personas que tienen ambos roles, administrativo y docente.*/
SELECT E.Id_Empleado,E.Nombre, AD.Id_Administracion, DO.Id_Docente
FROM dbo.EMPLEADO E INNER JOIN
dbo.ADMINISTRACION AD ON E.Id_Administracion=AD.Id_Administracion INNER JOIN
dbo.MARCAJE_ADMINISTRACION MA ON MA.Id_Administracion = AD.Id_Administracion
INNER JOIN dbo.DOCENTE DO ON DO.Id_Docente = E.Id_Docente
WHERE AD.Id_Administracion IS NOT NULL AND DO.Id_Docente IS NOT NULL
GROUP BY E.Id_Empleado, E.Nombre, AD.Id_Administracion, DO.Id_Docente


/*Listado del personal administrativo con su respectivo jefe inmediato.*/
 SELECT AD.Id_Administracion,E.Nombre, ad.id_jefe
FROM dbo.EMPLEADO E INNER JOIN
dbo.ADMINISTRACION AD ON E.Id_Administracion=AD.Id_Administracion


/*Cantidad de inasistencias por departamento para el mes actual (días laborales).*/
SELECT E.Id_Empleado, ISNULL(CAST(MA.Hora_Entrada AS NVARCHAR(15)), 'Entrada no registrada'), 
MA.Fecha AS 'MARCAJE ADMINISTRACION', DEP.Nombre
FROM dbo.EMPLEADO E INNER JOIN
dbo.ADMINISTRACION AD ON E.Id_Administracion=AD.Id_Administracion INNER JOIN
dbo.MARCAJE_ADMINISTRACION MA ON MA.Id_Administracion = AD.Id_Administracion INNER JOIN dbo.DEPARTAMENTO DEP 
ON DEP.Id_Administracion = AD.Id_Administracion
WHERE Ma.Fecha BETWEEN '2020-05-01'AND '2020-05-05' AND MA.Hora_Entrada IS NULL
GROUP BY e.Id_Empleado,MA.Hora_Entrada,  MA.Fecha, DEP.Nombre
ORDER BY e.Id_Empleado,MA.Hora_Entrada,MA.Fecha,  DEP.Nombre

