
--PROCEDIMIENTO PARA NUMERO DE USUARIOS NUEVOS POR DIA Y PORCENTAJE DE CRECIMIENTO
create procedure Person.uspCrecimiento
as
begin
declare @usuariosAntiguos float,
		@usuariosNuevos float,
		@crecimiento float

select @usuariosAntiguos = count(distinct ID_Usuario)
from Person.Usuario
where convert(date,Fecha_Creacion_Usuario) < convert(date, GETDATE())

select @usuariosNuevos = count(distinct ID_Usuario)
from Person.Usuario
where convert(date, Fecha_Creacion_Usuario) = convert(date, getdate())

set @crecimiento = @usuariosNuevos/ @usuariosAntiguos

select count(distinct ID_Usuario) [Total Usuarios], @usuariosNuevos [Usuarios Nuevos], @crecimiento [Crecimiento] 
from Person.Usuario
end

--exec Person.uspCrecimiento