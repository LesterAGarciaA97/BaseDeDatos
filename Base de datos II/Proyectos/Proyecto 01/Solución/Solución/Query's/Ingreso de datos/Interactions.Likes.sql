USE BOOKFACE;
GO

--select *from Person.Amigo where ID_Usuario = 2
--select *from Interactions.Publicacion where ID_Publicacion = 11
--select COUNT(Tipo_Like),ID_Publicacion from Interactions.Likes where Tipo_Like = 'Like' group by ID_Publicacion 
--delete Interactions.Likes

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 2 )
GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 3 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 19 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 6 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 7 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 8 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 9 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 10 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 11 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 12 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 20 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 14 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 15 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 16 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (1, 'Like',  getdate(), 17 )
 GO

 

 
 insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 1 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 3 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 6 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 7 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 8 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 9 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 10 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 11 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 12 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 14 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 15 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 16 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 17 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (2, 'Like',  getdate(), 20 )
 GO
 
 
 begin tran
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (3, 'Like',  getdate(), 2 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (3, 'Like',  getdate(), 4 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (3, 'dislike',  getdate(), 6 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (3, 'Like',  getdate(), 7 )
 GO

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (3, 'Like',  getdate(), 9 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (3, 'dislike',  getdate(), 10 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (3, 'Like',  getdate(), 11 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (3, 'Like',  getdate(), 12 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (3, 'dislike',  getdate(), 13 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (3, 'Like',  getdate(), 14 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (3, 'Like',  getdate(), 16 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (3, 'dislike',  getdate(), 17 )
 GO

 

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'Like',  getdate(), 1 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'Like',  getdate(), 3 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'Like',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'Like',  getdate(), 6 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'Like',  getdate(), 7 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'dislike',  getdate(), 8 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'Like',  getdate(), 9 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'dislike',  getdate(), 10 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'Like',  getdate(), 11 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'Like',  getdate(), 12 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'Like',  getdate(), 14 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'Like',  getdate(), 15 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'dislike',  getdate(), 16 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'Like',  getdate(), 17 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (4, 'Like',  getdate(), 18 )
 GO

 

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'Like',  getdate(), 1 )
 GO

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'Like',  getdate(), 3 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'Like',  getdate(), 19)
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'dislike',  getdate(), 6 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'Like',  getdate(), 7 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'Like',  getdate(), 8 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'Like',  getdate(), 9 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'dislike',  getdate(), 10 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'Like',  getdate(), 11 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'Like',  getdate(), 15 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'Like',  getdate(), 16 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'dislike',  getdate(), 17 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'Like',  getdate(), 18 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (5, 'Like',  getdate(), 20 )
 GO

 


insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (6, 'Like',  getdate(), 1 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (6, 'Like',  getdate(), 3 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (6, 'Like',  getdate(), 4 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (6, 'dislike',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (6, 'Like',  getdate(), 7 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (6, 'dislike',  getdate(), 9 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (6, 'Like',  getdate(), 10 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (6, 'Like',  getdate(), 11 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (6, 'dislike',  getdate(), 12 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (6, 'Like',  getdate(), 16 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (6, 'Like',  getdate(), 17 )
 GO



insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (7, 'Like',  getdate(), 1 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (7, 'Like',  getdate(), 2 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (7, 'Like',  getdate(), 3 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (7, 'dislike',  getdate(), 4 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (7, 'Like',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (7, 'Like',  getdate(), 6 )
 GO


insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (8, 'Like',  getdate(), 2 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (8, 'Like',  getdate(), 3 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (8, 'dislike',  getdate(), 4 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (8, 'Like',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (8, 'Like',  getdate(), 6 )
 GO

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (9, 'Like',  getdate(), 1 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (9, 'Like',  getdate(), 2 )
 GO

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (9, 'Like',  getdate(), 4 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (9, 'Like',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (9, 'dislike',  getdate(), 6 )
 GO

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (10, 'Like',  getdate(), 1 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (10, 'Like',  getdate(), 2 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (10, 'dislike',  getdate(), 3 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (10, 'Like',  getdate(), 4 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (10, 'Like',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (10, 'Like',  getdate(), 6 )
 GO


insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (11, 'Like',  getdate(), 4 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (11, 'Like',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (11, 'dislikedislike',  getdate(), 6 )
 GO

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (12, 'Like',  getdate(), 4 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (12, 'Like',  getdate(), 6 ) 
 GO

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (13, 'Like',  getdate(), 4)
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (13, 'Like',  getdate(), 5)
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (13, 'dislike',  getdate(), 6)
 GO

 
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (14, 'Like',  getdate(), 4)
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (14, 'Like',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (14, 'dislike',  getdate(), 6)
 GO


insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (15, 'Like',  getdate(), 4)
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (15, 'Like',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (15, 'dislike',  getdate(), 6)
 GO


insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (16, 'Like',  getdate(), 4 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (16, 'Like',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (16, 'Like',  getdate(), 6 )
 GO

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (17, 'Like',  getdate(), 4 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (17, 'Like',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (17, 'dislike',  getdate(), 6 )
 GO

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (18, 'Like',  getdate(), 4 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (18, 'Like',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (18, 'Like',  getdate(), 6 )
 GO

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (19, 'Like',  getdate(), 4 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (19, 'Like',  getdate(), 6 )
 GO

insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (20, 'Like',  getdate(), 2 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (20, 'Like',  getdate(), 3 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (20, 'Like',  getdate(), 4 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (20, 'dislike',  getdate(), 5 )
 GO
insert into Interactions.Likes (ID_Publicacion, Tipo_Like, fecha, ID_Amigo) values (20, 'Like',  getdate(), 6 )
 GO

 


