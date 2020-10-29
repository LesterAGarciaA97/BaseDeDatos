--Informes diarios

--PROCEDIMIENTO PARA NUMERO DE USUARIOS NUEVOS ENTRE HOY Y UNA FECHA ESTABLECIDA
create or alter procedure Person.uspCrecimientoRango
				@fechaAntes date
as
begin
	declare @usuariosAntiguos float,
			@usuariosNuevos float,
			@crecimiento float

	if(@fechaAntes is null)
	begin
		set @fechaAntes = DATEADD(day, -1, getdate())
	end

	select @usuariosAntiguos = count(distinct ID_Usuario)
	from Person.Usuario
	where convert(date,Fecha_Creacion_Usuario) <= convert(date, @fechaAntes) and Fecha_Fin_Usuario is NULL

	select @usuariosNuevos = count(distinct ID_Usuario)
	from Person.Usuario
	where convert(date,Fecha_Creacion_Usuario) > convert(date, @fechaAntes) and Fecha_Fin_Usuario is NULL

	set @crecimiento = @usuariosNuevos/ @usuariosAntiguos

	select count(distinct ID_Usuario) [Total Usuarios], @usuariosNuevos [Usuarios Nuevos], convert(decimal(5,2), @crecimiento) [Crecimiento] 
	from Person.Usuario
end
GO

--exec Person.uspCrecimientoRango '2020-10-20'
--exec Person.uspCrecimiento null

--Número de publicaciones al mes, con el 100% de su capacidad de comentarios llena.
create or alter procedure Interactions.uspPublicaciones_ComentariosLlenos
as
begin
select MONTH(GETDATE()) as [Mes del anio],P.ID_Publicacion as [Id_Publicacion], COUNT(C.ID_Comentario) as [Cantidad de Comentarios]
from Interactions.Publicacion P
	inner join Interactions.Comentario C on P.ID_Publicacion = C.ID_Publicacion
	group by P.ID_Publicacion
	having (COUNT(C.ID_Comentario) > 3)
end
GO

-- Detalle de publicaciones que en algún momento impactaron en el incremento de la cantidad máxima de amigos para un usuario.
create or alter procedure Interactions.uspPublicacionesImpacto
as
begin
select P.ID_Publicacion ,P.ID_Usuario, P.Contenido, COUNT(Tipo_Like) as 'Total Likes'
from Interactions.Publicacion P
	inner join Interactions.Likes L on (P.ID_Publicacion = L.ID_Publicacion and P.Estado = 1)
	group by P.ID_Publicacion ,P.ID_Usuario, P.Contenido
	having COUNT(Tipo_Like) >= 15
end
GO

