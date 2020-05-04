--Consulta 01
--Cantidad de pruebas realizadas por departamento, municipio y zona seg�n la
--ubicacion de los aparatos. (mostrando cantidad de casos positivos y negativos)

select count(es.actual_status) as 'Total casos',es.actual_status,l.departamento as 'Departamento',l.municipio as 'Municipio',isnull(p.zone_name,'zona no registrada') as 'Zona' 
from LOCALIZACION l inner join  PUESTO_REGISTRO p on l.id_puesto = p.id_puesto inner join APARATO a on p.id_puesto = a.id_puesto inner join PRUEBA pr on a.id_aparato = pr.id_aparato inner join ESTADO es on pr.id_prueba = es.id_prueba 
where (es.actual_status = 'Contagiado' or es.actual_status = 'No contagiado') group by es.actual_status,l.departamento,l.municipio,p.zone_name order by l.departamento,L.municipio




--Consulta 02
--Reporte que muestra por Continente, pais, ciudad y genero de los lugares
--visitados por las personas que dieron positivo segun el control realizado. Mostrar los datos en cantidades y en porcentajes

--Se uso para obtener el numero total de datos de la tabla para poder obtener el porcentaje
select hv.continent,hv.country,hv.city,COUNT(hv.city)as 'Total' into #Cantidad
from PERSONA p inner join CONTAGIO c on p.id_persona = c.id_persona inner join PASAPORTE pa on c.id_contagio = pa.id_contagio inner join HISTORIAL_VIAJES hv on pa.id_passport = hv.id_passport
where c.infect_type = 'Asintomático ' group by hv.continent,hv.country,hv.city

declare @Continente nvarchar(50),@Country nvarchar(50),@City nvarchar(50),@Genero nvarchar(50) ,@Cantidad int,@Total int,@Porcentaje decimal(5,2)
declare Consulta2 cursor
for select hv.continent,hv.country,hv.city,p.gender,COUNT(hv.city)as 'Total' from PERSONA p inner join CONTAGIO c on p.id_persona = c.id_persona inner join PASAPORTE pa on c.id_contagio = pa.id_contagio inner join HISTORIAL_VIAJES hv on pa.id_passport = hv.id_passport where c.infect_type = 'Asintomático ' group by hv.continent,hv.country,hv.city,p.gender
open Consulta2
fetch NEXT FROM Consulta2 into @Continente,@Country,@City,@Genero,@Cantidad
while(@@FETCH_STATUS = 0)

begin
set @Total = (SELECT SUM(Total) FROM #Cantidad) 
set @Porcentaje = (CAST(@Cantidad as  decimal(5,2)) / CAST(@Total as  decimal(5,2))) *100

print 'Continente: ' + cast(@Continente as nvarchar(50)) + ', Pais: ' + cast(@Country as nvarchar(50)) + ', Ciudad: ' + cast(@City as nvarchar(50)) + ', Genero: '+ cast(@Genero as nvarchar(50)) + ', Cantidad: ' + cast(@Cantidad as nvarchar(50)) + ', Porcentaje: ' +  cast(@Porcentaje as nvarchar(50)) + ' %'

fetch next from Consulta2 into @Continente,@Country,@City,@Genero,@Cantidad
end
close Consulta2
Deallocate Consulta2
GO




--Consulta 03
--Reporte por edades de las personas que se han recuperado, siempre y cuando su
--padre, su madre o su abuelo est�n comprendidos entre 50 y 60 anios.

--SE FILTRO LAS PERSONAS QUE SUS PADRES,MADRES O ABUELOS ESTAN COMPRENDIDOS ENTRE 50 Y 60 A�OS DE EDAD
select p.id_persona,DATEDIFF(YEAR,p.birthdate,GETDATE()) as 'Edad' into #Filtro_1 
from PERSONA p inner join FAMILIAR_MAYOR fm on p.id_persona = fm.id_persona inner join REGISTRO r on fm.id_older = r.id_older
where (DATEDIFF(YEAR,r.birthday,GETDATE()) between 50 and 60) and (fm.KinShip = 'Mamá' or fm.KinShip = 'Papá' or fm.KinShip = 'abuelo')

--SE FILTRO LAS PERSONAS QUE SE HAN RECUPERADO, SU FAMILIA ESTE ENTRE 50 Y 6O A�OS DE EDAD, Y SE PROYECTA LA CLASIFICACION DE EDADES
select 
case when f1.Edad between 10 and 20 then 'Comprendido entre 10 y 20 años'
when f1.Edad between 21 and 30 then 'Comprendido entre 21 y 30 años'
when f1.Edad between 31 and 40 then 'Comprendido entre 31 y 40 años'
when f1.Edad between 41 and 50 then 'Comprendido entre 41 y 50 años'
when f1.Edad between 51 and 60 then 'Comprendido entre 51 y 60 años'
when f1.Edad between 61 and 70 then 'Comprendido entre 61 y 70 años'
else 'Mayor a 70 años' end as 'Rango edad'
into #Rango_Edades from #Filtro_1 f1 inner join ESTADO e on f1.id_persona = e.id_persona WHERE actual_status = 'Recuperado'

--SE MUESTRA REGISTRO DE EDADES DE LAS PERSONAS QUE SE HAN RECUPERADO
select COUNT([Rango edad]) as 'Total de personas' ,[Rango edad] from #Rango_Edades group by [Rango edad]




--Consulta 04
--Cuantas personas han pasado por 3 o m�s puntos de control el mismo d�a dentro del mismo municipio y han dado positivo. 


--Condicion 1 = Se filtra el id de personas que han pasado por 3 o m�s puntos de control en el mismo municipio
select COUNT(pr.id_persona) as 'Total' ,l.municipio ,pr.id_persona into #Cantidad_PuntoControl from LOCALIZACION l inner join PUESTO_REGISTRO pr on l.id_persona = pr.id_persona group by pr.id_persona,l.municipio having count (pr.id_persona) >=3 order by l.municipio 

--Condicion 2 = Sean positivos
select COUNT(e.id_persona) as 'Total',e.id_persona,a.time_life,p.id_prueba into #Filtrar_Positivo from APARATO a inner join PRUEBA p on a.id_aparato = p.id_aparato inner join ESTADO e on p.id_prueba = e.id_prueba where (e.actual_status = 'Contagiado') group by p.id_prueba,a.time_life,e.id_persona order by a.time_life


--Condicion 3 = condicion 2 + mismo d�a
select COUNT(id_persona) as 'Total veces id persona',id_persona,time_life,COUNT(time_life) as 'Total veces fecha' into #filtrar_fecha from #Filtrar_Positivo group by id_persona,time_life having COUNT (time_life) >= 3 and COUNT (id_persona) >= 3

--Total query = condicion 1 + condicion 3
select COUNT(ff.id_persona) as 'Total registro de personas' from #Cantidad_PuntoControl  cp inner join #filtrar_fecha ff on cp.id_persona = ff.id_persona