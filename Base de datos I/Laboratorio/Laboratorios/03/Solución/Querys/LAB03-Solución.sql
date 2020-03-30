CREATE TABLE "LOCALIDAD"
(
Id_Localidad int IDENTITY(10,10) NOT NULL,
CONSTRAINT pk_Localidad primary key(Id_Localidad),
Nombre_O_Descripcion varchar(50) NOT NULL,
)

CREATE TABLE "ALMACEN"
(
Id_almacen int IDENTITY(10,10) NOT NULL,
CONSTRAINT pk_Almacen primary key (Id_Almacen),
Nombre_Almacen varchar(50) NOT NULL,
Direccion_Almacen varchar(15),
CONSTRAINT [tamanio_minimo] check(DATALENGTH([Direccion_Almacen]) >= 15),
Fecha_Apertura date NOT NULL,
Horario_Disponible varchar(50) NOT NULL,
CONSTRAINT Horario_Valido check(Horario_Disponible = 'MAT0' OR Horario_Disponible = 'MAT1' OR Horario_Disponible = 'MAT2' OR 
								Horario_Disponible = 'MAT3' OR Horario_Disponible = 'MAT4' OR Horario_Disponible = 'MAT5' OR
								Horario_Disponible = 'MAT6' OR Horario_Disponible = 'MAT7' OR Horario_Disponible = 'MAT8' OR
								Horario_Disponible = 'MAT9' OR Horario_Disponible = 'VESP0' OR Horario_Disponible = 'VESP1' OR
								Horario_Disponible = 'VESP2' OR Horario_Disponible = 'VESP3' OR Horario_Disponible = 'VESP4' OR
								Horario_Disponible = 'VESP5' OR Horario_Disponible = 'VESP6' OR Horario_Disponible = 'VESP7' OR
								Horario_Disponible = 'VESP8' OR Horario_Disponible = 'VESP9'),
Id_Localidad int NOT NULL,
CONSTRAINT fk_Id_Localidad foreign key(Id_Localidad) references localidad (Id_Localidad)
)

CREATE TABLE "INVENTARIO"
(
Id_Articulo int IDENTITY(10,10) NOT NULL,
CONSTRAINT pk_Inventario primary key (Id_Articulo),
Nombre varchar(50) NOT NULL,
Cantidad_En_Inventario int NOT NULL,
Precio_Por_Unidad money NOT NULL,
CONSTRAINT Precio_Unidad check(Precio_Por_Unidad > 0), 
Id_Almacen int NOT NULL,
CONSTRAINT fk_Id_Almacen foreign key(Id_Almacen) references almacen (Id_Almacen)
)

CREATE TABLE "Almacen_Empleado"
(
Id_Empleado int IDENTITY(10,10) NOT NULL,
CONSTRAINT pk_Empleado primary key (Id_Empleado),
Funcion_Empleado varchar(50) NOT NULL,
CONSTRAINT Cargo_Empleado check(Funcion_Empleado = 'SEGURIDAD' OR Funcion_Empleado = 'GERENTE' OR Funcion_Empleado = 'CAJERO'),
Nit_Empleado int NOT NULL,
CONSTRAINT uc_Nit unique (Nit_Empleado , Funcion_Empleado),
Id_Almacen int NOT NULL,
CONSTRAINT fk_Id_Almacen foreign key(Id_Almacen) references almacen (Id_Almacen)
)


//Yazmine Isabel Sierra Aragon 1174916 Lester Andrés García Aquino 1003115
