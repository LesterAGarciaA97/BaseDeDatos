--CREATE DATABASE LaboratorioFinal
--USE LaboratorioFinal

CREATE TABLE DOCENTE
(
	Id_Docente int PRIMARY KEY IDENTITY(1,1),
	Turno_Docente varchar(50) NOT NULL
)

CREATE TABLE FACULTAD
(
	Id_Facultad int PRIMARY KEY IDENTITY(1,1),
	Nombre varchar(50),
	Id_Docente int,
	CONSTRAINT fk_Id_Docente FOREIGN KEY (Id_Docente) REFERENCES DOCENTE (Id_Docente) 
)

CREATE TABLE MARCAJE_DOCENTE
(
	Id_Marcaje int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Hora_Entrada time,
	Hora_Salida time,
	Fecha date,
	Id_Docente int,
	CONSTRAINT fk_Id_Docente2 FOREIGN KEY (Id_Docente) REFERENCES DOCENTE (Id_Docente)
)

CREATE TABLE ADMINISTRACION
(
	Id_Administracion int PRIMARY KEY IDENTITY(1,1),
	Turno_Admonistracion varchar(50) NOT NULL,
	id_jefe int,
	CONSTRAINT fk_Id_jefe FOREIGN KEY (id_jefe) REFERENCES ADMINISTRACION (Id_Administracion)
)

CREATE TABLE MARCAJE_ADMINISTRACION
(
	Id_Marcaje int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Hora_Entrada time,
	Hora_Salida time,
	Fecha date,
	Id_Administracion int,
	CONSTRAINT fk_Id_Administracion FOREIGN KEY (Id_Administracion) REFERENCES ADMINISTRACION (Id_Administracion)
)

CREATE TABLE DEPARTAMENTO
(
	Id_Departamento int PRIMARY KEY IDENTITY(1,1),
	Nombre varchar(50),
	Id_Administracion int,
	CONSTRAINT fk_Id_Administracion2 FOREIGN KEY (Id_Administracion) REFERENCES ADMINISTRACION (Id_Administracion) 
)

CREATE TABLE EMPLEADO
(
	Id_Empleado int PRIMARY KEY IDENTITY(1,1),
	Nombre varchar(50) NOT NULL,
	Apellido varchar(50) NOT NULL,
	Telefono varchar(8) NOT NULL,
	Fecha_Nacimiento DATE NOT NULL,
	Correo varchar(50) NOT NULL,
	Genero varchar(50) NOT NULL,
	Id_Docente int,
	CONSTRAINT fk_Id_Docente3 FOREIGN KEY (Id_Docente) REFERENCES DOCENTE (Id_Docente),
	Id_Administracion int,
	CONSTRAINT fk_Id_Administracion3 FOREIGN KEY (Id_Administracion) REFERENCES ADMINISTRACION (Id_Administracion)
)