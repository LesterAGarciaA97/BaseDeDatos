--Procedimiento Interacción

create or alter procedure usp_Interacciones
@id_amigo int ,@id_publicacion int,@Tipo varchar(10)
as
set transaction isolation level serializable
begin tran
if(@@ERROR = 0)
begin
insert into Interactions.Likes(ID_Publicacion,Tipo_Like,fecha,ID_Amigo) values(@id_publicacion,@Tipo,GETDATE(),@id_amigo)
commit
end

else
begin
rollback
print 'Transaccion fallida.'
end



