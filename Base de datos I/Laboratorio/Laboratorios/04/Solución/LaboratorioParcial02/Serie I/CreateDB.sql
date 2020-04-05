CREATE DATABASE ElBuenGusto
USE ElBuenGusto

CREATE TABLE CLIENTE
(
	Id_Cliente INT NOT NULL,
	CONSTRAINT pk_Cliente PRIMARY KEY(Id_Cliente),
	Contacto INT,
	CONSTRAINT Contacto_Valido CHECK(LEN(CONVERT(VARCHAR(8), Contacto)) = 8), --Validaci�n de que el n�mero del contacto tenga 8 d�gitos
	DPI_Cliente VARCHAR(13),
	CONSTRAINT DPI_Valido CHECK(DATALENGTH([DPI_Cliente]) = 13), --Validación de que el DPI sea válido
	Fecha_Nacimiento DATE NOT NULL,
	CONSTRAINT uc_DPI UNIQUE (DPI_Cliente) --La forma de identificar un cliente �nic es por su DPI
)

CREATE TABLE AUTOMOVIL
(
	Id_Automovil INT NOT NULL,
	Precio_Automovil MONEY NOT NULL,
	Marca_Automovil VARCHAR(50) NOT NULL,
	Modelo_Automovil VARCHAR(50) NOT NULL,
	Fecha_Ingreso DATE,
	CONSTRAINT uc_Rango_Precio CHECK((35000 <= Precio_Automovil) AND (Precio_Automovil <= 90000)), --El precio de los veh�culos est� entre 35k y 90k
	CONSTRAINT uc_fecha CHECK(Fecha_Ingreso >= '2000-01-01'), --Solamente se tienen veh�culos de 20 a�os de antig�edad (tomando en cuenta la fecha de ingreso)
	Placa_Automovil VARCHAR(6),
	CONSTRAINT pk_Automovil PRIMARY KEY(Placa_Automovil),
	CONSTRAINT uc_Placa_Automovil CHECK (Placa_Automovil LIKE '[0-9][0-9][0-9][A-Z][A-Z][A-Z]'),--La placa del veh�culo debe estar formada por 3 letras y 3 n�meros
	Id_Cliente INT NOT NULL,
	CONSTRAINT fk_Id_Cliente FOREIGN KEY(Id_Cliente) REFERENCES Cliente (Id_Cliente)
)

CREATE TABLE REVISION
(
	Id_Revision INT NOT NULL,
	CONSTRAINT pk_Revision PRIMARY KEY(Id_Revision),
	Placa_Automovil VARCHAR(6),
	CONSTRAINT fk_Placa_Automovil FOREIGN KEY(Placa_Automovil) REFERENCES Automovil (Placa_Automovil),
	Fecha_Ingreso DATE NOT NULL,
    Fecha_Salida DATE NOT NULL
)

CREATE TABLE OPERACION
(
	Id_Operacion INT NOT NULL,
	CONSTRAINT pk_Operacion PRIMARY KEY(Id_Operacion),
	Duracion_Operacion TIME,
    CONSTRAINT uc_Duracion_Max CHECK (Duracion_Operacion <= '05:00:00.0000000'),
    Id_Revision INT,
    CONSTRAINT fk_Id_Revision FOREIGN KEY(Id_Revision) REFERENCES Revision (Id_Revision),
	Placa_Automovil VARCHAR(6),
	CONSTRAINT fk_Placa_Automovil2 FOREIGN KEY(Placa_Automovil) REFERENCES Automovil (Placa_Automovil)
)

CREATE TABLE MATERIAL
(
	Id_Material INT NOT NULL,
	CONSTRAINT pk_Material PRIMARY KEY(Id_Material),
	Detalle_Material varchar(50),
	Materiales_Utilizados INT,
	Id_Operacion INT, 
	CONSTRAINT fk_Id_Operacion FOREIGN KEY(Id_Operacion) REFERENCES Operacion (Id_Operacion)
)