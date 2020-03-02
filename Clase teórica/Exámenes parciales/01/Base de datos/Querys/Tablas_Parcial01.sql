CREATE TABLE "CLIENTE"
(
DPI int,
Nombre Varchar(50),
No_Tarjeta_De_Credito int,
Genero Varchar(50),
Fecha_De_Nacimiento date
)

CREATE TABLE "VISUALIZACION"
(
ID_Visualizacion int,
Hora_Inicio time,
Hora_Fin time,
Fecha_Inicio date,
Fecha_Fin date
)

CREATE TABLE "CAPITULO"
(
Id_Capitulo int,
Nombre varchar(50),
Descripcion varchar(50),
Fecha_De_Lanzamiento date,
Duracion int
)

CREATE TABLE "TEMPORADA"
(
Id_Temporada int,
Nombre varchar(50),
Numero_Temporada integer,
Fecha_De_Lanzamiento date,
Fecha_De_Finalizacion date
)

CREATE TABLE "SERIE"
(
Id_Capitulo int,
Nombre varchar(50),
Fecha_De_Nacimiento date,
Actor varchar(50)
)

CREATE TABLE "DIRECTOR"
(
Id_Director varchar(50),
Nombre varchar(50),
Nacionalidad varchar(50)
)

CREATE TABLE "ACTOR"
(
Id_Actor int,
Nombre varchar(50),
Genero varchar(50),
Nacionalidad varchar(50),
Tipo_Actor varchar(50)
)