CREATE TABLE SERIE
(
Id_Serie int,
nombre varchar(50),
fecha date,
)

ALTER TABLE SERIE
	ADD clasificacion varchar(100)

DROP TABLE SERIE

CREATE TABLE SERIE
(
Id_Serie int NOT NULL,
nombre varchar(50) NOT NULL,
fecha date NOT NULL,
clasificacion varchar(50) NOT NULL
)

INSERT INTO SERIE (Id_Serie, nombre, fecha, clasificacion)
values (5, 'Patito1','01/01/1934','b') 

DROP TABLE SERIE

CREATE TABLE SERIE
(
Id_Serie int NOT NULL,
nombre varchar(50) NOT NULL,
fecha date NOT NULL,
clasificacion varchar(50) NOT NULL
constraint uc_serie unique (Id_Serie)
)

INSERT INTO SERIE (Id_Serie, nombre, fecha, clasificacion)
values (5, 'Patito1','01/01/1934','b') 

SELECT *
FROM sysobjects
WHERE name= 'uc_serie'

CREATE TABLE SERIE
(
Id_Serie int NOT NULL,
nombre varchar(50) NOT NULL,
fecha date NOT NULL,
clasificacion varchar(50) NOT NULL
constraint uc_serie unique (Id_Serie),
constraint pk_serie primary key(Id_Serie)
)

CREATE TABLE SERIE
(
Id_Serie int NOT NULL,
nombre varchar(50) NOT NULL,
fecha date NOT NULL,
clasificacion varchar(50) NOT NULL
CONSTRAINT uc_serie unique (Id_Serie),
CONSTRAINT pk_serie primary key(Id_Serie),
CONSTRAINT uc_fecha check(fecha >= '10/31/2020')
)

//Error por fecha invalida
INSERT INTO SERIE (Id_Serie, nombre, fecha, clasificacion)
values (5, 'Patito1','01/01/1934','b')

DROP TABLE SERIE

CREATE TABLE SERIE
(
Id_Serie int NOT NULL,
nombre varchar(50) NOT NULL,
fecha date NOT NULL,
clasificacion varchar(50) NOT NULL
CONSTRAINT uc_serie unique (Id_Serie),
CONSTRAINT pk_serie primary key(Id_Serie),
CONSTRAINT uc_fecha check(fecha >= '2010-02-13')
)

//Error por fecha invalida --> Arreglado
INSERT INTO SERIE (Id_Serie, nombre, fecha, clasificacion)
values (5, 'Patito1','2010-02-13','b')

DROP TABLE SERIE

//Validar que 
CREATE TABLE SERIE
(
Id_Serie int NOT NULL,
nombre varchar(50) NOT NULL,
fecha date NOT NULL,
clasificacion varchar(50) NOT NULL
CONSTRAINT uc_serie unique (Id_Serie),
CONSTRAINT pk_serie primary key(Id_Serie),
CONSTRAINT uc_fecha check(fecha >= '2010-02-13'),
CONSTRAINT uc_nombre_seg check(substring(nombre,2,1)='a')
)

CREATE TABLE SERIE
(
Id_Serie int NOT NULL,
nombre varchar(50) NOT NULL,
fecha date NOT NULL,
clasificacion varchar(50) NOT NULL
CONSTRAINT uc_serie unique (Id_Serie),
CONSTRAINT pk_serie primary key(Id_Serie),
CONSTRAINT uc_fecha check(fecha >= '2010-02-13'),
CONSTRAINT uc_nombre_seg check(substring(nombre,2,1)='a'),
CONSTRAINT fk_otra foreign key(Id_Serie) references serie (Id_Serie)
)

