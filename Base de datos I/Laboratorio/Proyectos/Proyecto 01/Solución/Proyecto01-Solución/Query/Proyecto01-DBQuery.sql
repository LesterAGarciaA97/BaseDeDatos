--Creacion de la base de datos completa
--CREATE DATABASE OFFSHOREBANK_DB
--Eliminacion de la base de datos completa
--DROP DATABASE OFFSHOREBANK_DB

create TABLE CLIENTE 
(
	id_cliente int not null,	
	DPI nvarchar(13) not null,
	Nombre nvarchar(50) not null,
	Apellido nvarchar(50) not null,
	Lugar_De_Nacimiento nvarchar(50) not null,
	Fecha_De_Nacimiento date not null,
	nacionalidad nvarchar(20) ,
	Telefono_Casa nvarchar(20),
	Telefono_Celular nvarchar(20) not null,
	Email nvarchar(50) not null,
	constraint pk_cliente primary key(id_cliente),
	CONSTRAINT FECHA_NACIMIENTO CHECK(DATEDIFF(YEAR,Fecha_De_Nacimiento, GETDATE()) >= 18)  --VALIDAR QUE LA PERSONA SEA MAYOR DE EDAD
)

--Insercion de datos en la tabla CLIENTE
insert into CLIENTE(id_cliente,DPI,Nombre,Apellido,Lugar_De_Nacimiento,Fecha_De_Nacimiento,nacionalidad,Telefono_Casa,Telefono_Celular,Email)
values('1111','123456789','Iván','Arango','Guatemala','1989-03-13','Guatemalteco','41427517','22456718','ivanandres@gmail.com')
insert into CLIENTE(id_cliente,DPI,Nombre,Apellido,Lugar_De_Nacimiento,Fecha_De_Nacimiento,nacionalidad,Telefono_Casa,Telefono_Celular,Email)
values('1112','123456784','Luis','Solares','Guatemala','1989-03-13','Italiano','41427517','22456718','luisola@gmail.com')
insert into CLIENTE(id_cliente,DPI,Nombre,Apellido,Lugar_De_Nacimiento,Fecha_De_Nacimiento,nacionalidad,Telefono_Casa,Telefono_Celular,Email)
values('1113','123456785','Yazmine','Sierra','Guatemala','1978-03-13','Japones','41427517','22456718','yazsi96@gmail.com')
insert into CLIENTE(id_cliente,DPI,Nombre,Apellido,Lugar_De_Nacimiento,Fecha_De_Nacimiento,nacionalidad,Telefono_Casa,Telefono_Celular,Email)
values('1114','123456786','Lester','Garcia','Guatemala','1967-03-13','Guatemalteco','41427517','22456718','lgarcia34@gmail.com')
insert into CLIENTE(id_cliente,DPI,Nombre,Apellido,Lugar_De_Nacimiento,Fecha_De_Nacimiento,nacionalidad,Telefono_Casa,Telefono_Celular,Email)
values('1115','123456786','Hector','Zetino','Guatemala','1987-03-13','Sueco','41427517','22456718','hzetichi98@gmail.com')

--Vaciar datos de la tabla CLIENTE
--TRUNCATE TABLE CLIENTE

--BENEFICIARIO se relaciona con CLIENTE
CREATE TABLE BENEFICIARIO
(
	id_beneficiario int Not null,
	DPI nvarchar(50),
	Nombre nvarchar(50) not null,
	Apellido nvarchar(50) not null,
	Lugar_De_Nacimiento nvarchar(50) not null,
	Fecha_De_Nacimiento date not null,
	Telefono_Casa nvarchar(20),
	Telefono_Celular nvarchar(20) not null,
	Email nvarchar(50) not null,
	id_cliente int not null,	
	constraint pk_beneficiario primary key(id_beneficiario),
	constraint fk_beneficiario foreign key (id_cliente) references CLIENTE(id_cliente)
)

--Insercion de datos en la tabla BENEFICIARIO

INSERT INTO BENEFICIARIO(id_beneficiario,DPI,Nombre,Apellido,Lugar_De_Nacimiento,Fecha_De_Nacimiento,Telefono_Casa,Telefono_Celular,Email,id_cliente)
values('1001','4668898665643','Yazmine','Barillas','Guatemala','1998-02-23','24412431','30227200','yasmin@gmail.com','1111')
INSERT INTO BENEFICIARIO(id_beneficiario,DPI,Nombre,Apellido,Lugar_De_Nacimiento,Fecha_De_Nacimiento,Telefono_Casa,Telefono_Celular,Email,id_cliente)
values('1002','4668898665645','Jose','Mendez','Guatemala','1994-07-02','24412431','30227200','jose@gmail.com','1111')
INSERT INTO BENEFICIARIO(id_beneficiario,DPI,Nombre,Apellido,Lugar_De_Nacimiento,Fecha_De_Nacimiento,Telefono_Casa,Telefono_Celular,Email,id_cliente)
values('1003','4668898665648','Andrea','Arango','Guatemala','1995-10-12','24412431','30227200','andrea@gmail.com','1112')
INSERT INTO BENEFICIARIO(id_beneficiario,DPI,Nombre,Apellido,Lugar_De_Nacimiento,Fecha_De_Nacimiento,Telefono_Casa,Telefono_Celular,Email,id_cliente)
values('1004','4668898665649','Jose','Donis','Guatemala','1994-12-25','24412431','30227200','jose@gmail.com','1113')
INSERT INTO BENEFICIARIO(id_beneficiario,DPI,Nombre,Apellido,Lugar_De_Nacimiento,Fecha_De_Nacimiento,Telefono_Casa,Telefono_Celular,Email,id_cliente)
values('1005','4668898665649','Bryan','Mejia','Guatemala','1996-10-25','24412433','44227200','bryan@gmail.com','1115')

--Consulta que relaciones CLIENTE y BENEFICIARIO
SELECT *FROM CLIENTE
select *from BENEFICIARIO

--CUENTA se relaciona con CLIENTE
CREATE TABLE CUENTA
(
	id_cuenta int not null,
	Tipo_Cuenta nvarchar(50) not null,
	Fecha_Apertura date not null Default GETDATE(),
	Lugar_Apertura nvarchar (MAX) NOT NULL,	
	id_cliente int not null,
	constraint pk_Cuenta primary key(id_cuenta),
	constraint fk_cuenta foreign key (id_cliente) references CLIENTE(id_cliente),
	constraint validar_tipoCuenta check((Tipo_Cuenta = 'Comercial') or (Tipo_Cuenta = 'Premium')),	
	constraint validar_fechaApertura check(DATEDIFF(DAY,Fecha_Apertura,GETDATE()) >= 0),	
)

--VALIDA QUE EL CLIENTE NO ABRA UNA CUENTA EN EL MISMO LUGAR DE NACIMIENTO
CREATE TRIGGER VALIDAR_APERTURA
ON CUENTA
AFTER INSERT
AS
DECLARE @Lugar_Nacimeinto as nvarchar(20), @Lugar_Apertura as nvarchar (MAX)
DECLARE @ID_CUENTA_PK AS INT,@TipoCueta as nvarchar(50), @FechaApertura as date, @id as int

SET @ID_CUENTA_PK = (SELECT id_cuenta FROM inserted)
SET @TipoCueta = (SELECT Tipo_Cuenta FROM inserted)
SET @FechaApertura = (SELECT Fecha_Apertura FROM inserted)
SET @Lugar_Apertura = (SELECT LOWER(Lugar_Apertura) FROM inserted)
SET @id = (SELECT id_cliente FROM inserted)

SET @Lugar_Nacimeinto =  (SELECT LOWER(Lugar_De_Nacimiento) FROM CLIENTE WHERE (id_cliente = @id))

BEGIN
IF(@Lugar_Apertura = @Lugar_Nacimeinto)
INSERT INTO CUENTA(id_cuenta,Tipo_Cuenta,Fecha_Apertura,Lugar_Apertura,id_cliente) VALUES(@ID_CUENTA_PK,@TipoCueta,@FechaApertura,@Lugar_Apertura,@id)
END
GO 

--Insercion de datos en la tabla CUENTA
insert into CUENTA(id_cuenta,Tipo_Cuenta,Fecha_Apertura,Lugar_Apertura,id_cliente)
values('1129','Comercial','2012-03-13','Honduras','1111')
insert into CUENTA(id_cuenta,Tipo_Cuenta,Fecha_Apertura,Lugar_Apertura,id_cliente)
values('1124','Premium','2020-03-13','Italia','1112')
insert into CUENTA(id_cuenta,Tipo_Cuenta,Fecha_Apertura,Lugar_Apertura,id_cliente)
values('1125','Comercial','2020-03-13','Panama','1113')
insert into CUENTA(id_cuenta,Tipo_Cuenta,Fecha_Apertura,Lugar_Apertura,id_cliente)
values('1126','Comercial','2013-03-13','Italia','1114')
insert into CUENTA(id_cuenta,Tipo_Cuenta,Fecha_Apertura,Lugar_Apertura,id_cliente)
values('1127','Premium','2020-03-13','Honduras','1115')

--Vaciar datos de la tabla Cuenta
--TRUNCATE TABLE CUENTA

--SUCURSAL se relaciona con CUENTA
CREATE TABLE SUCURSAL
(
	id_sucursal int not null,
	direccion nvarchar(max),
	pais nvarchar(50),
	id_cuenta int not null,
	constraint pk_Surcursal primary key(id_sucursal),
	constraint fk_surcursal foreign key (id_cuenta) references CUENTA(id_cuenta)	
)

--Insercion de datos en la tabla SUCURSAL
INSERT INTO SUCURSAL(id_sucursal,direccion,pais,id_cuenta)
VALUES('1234','Mixco','Guatemala','1123')
INSERT INTO SUCURSAL(id_sucursal,direccion,pais,id_cuenta)
VALUES('1235','Antigua','Guatemala','1123')
INSERT INTO SUCURSAL(id_sucursal,direccion,pais,id_cuenta)
VALUES('1236','Tokio','Japon','1124')
INSERT INTO SUCURSAL(id_sucursal,direccion,pais,id_cuenta)
VALUES('1237','Xela','Guatemala','1126')
INSERT INTO SUCURSAL(id_sucursal,direccion,pais,id_cuenta)
VALUES('1238','Orlando','USA','1127')

--Vaciar datos de la tabla SUCURSAL
--TRUNCATE TABLE SUCURSAL

--CUENTA_COMERCIAL se relaciona con CUENTA
CREATE TABLE CUENTA_COMERCIAL
(
	id_cuenta_comercial int not null,
	cantidad_Apertura money not null,
	id_cuenta int not null,
	constraint pk_cuenta_comercial primary key(id_cuenta_comercial),
	constraint fk_cuenta_comercial foreign key (id_cuenta) references CUENTA(id_cuenta),
	constraint validar_cuentaComercial_1 check(cantidad_Apertura > 50000)
)

--Insercion de datos en la tabla CUENTA_COMERCIAL
insert into CUENTA_COMERCIAL(id_cuenta_comercial,cantidad_Apertura,id_cuenta)
values('4321','60000','1123')
insert into CUENTA_COMERCIAL(id_cuenta_comercial,cantidad_Apertura,id_cuenta)
values('4322','70000','1125')
insert into CUENTA_COMERCIAL(id_cuenta_comercial,cantidad_Apertura,id_cuenta)
values('4323','80000','1126')
insert into CUENTA_COMERCIAL(id_cuenta_comercial,cantidad_Apertura,id_cuenta)
values('4324','90000','1127')

--Consulta de verificación de cantidad de cuentas comerciales
select * from CUENTA where Tipo_Cuenta = 'Comercial'

--Vaciar datos de la tabla CUENTA_COMERCIAL
--TRUNCATE TABLE CUENTA_COMERCIAL

--COBRO_CUENTA_COMERCIAL se relaciona con CUENTA_COMERCIAL
CREATE TABLE COBRO_CUENTA_COMERCIAL
(
	id_cobro_CuentaComercial int not null,
	tipo_cobro nvarchar(50) not null,
	id_cuenta_comercial int not null,
	tipo_moneda_CuentaComercial varchar(15),   --Descripcion de tipo de moneda (Euros o dolares)
	constraint pk_id_cobro primary key(id_cobro_CuentaComercial),
	constraint fk_id_cobro foreign key (id_cuenta_comercial) references CUENTA_COMERCIAL(id_cuenta_comercial),
	constraint validar_moneda_comercial check((tipo_moneda_CuentaComercial = 'Dolares' or tipo_moneda_CuentaComercial = 'dolares') or (tipo_moneda_CuentaComercial = 'euros') or (tipo_moneda_CuentaComercial = 'Euros')),	
	constraint validar_COBRO_CUENTA_COMERCIAL1 check((tipo_cobro = 'Deposito' or tipo_cobro = 'deposito') or (tipo_cobro = 'Retiros' or tipo_cobro = 'retiros') or (tipo_cobro = 'Efectivo' or tipo_cobro = 'efectivo'))
)

--TRANSACCION_TIPO_A se relaciona con CUENTA_COMERCIAL
CREATE TABLE TRANSACCION_TIPO_A
(
	id_transaccionTipoA int not null,
	id_CuentaOrigen int not null,
	id_CuentaDestino int not null,
	pais nvarchar(50) not null,
	tipo_moneda nvarchar(50) not null,
	cantidad money not null,
	Fecha_Transaccion date default GETDATE(),
	id_cuenta_comercial int not null,
	hora_transaccion_a nvarchar(15),
	constraint pk_TransaccionTipoA primary key(id_transaccionTipoA),
	constraint fk_TransaccionTipoA foreign key (id_cuenta_comercial) references CUENTA_COMERCIAL(id_cuenta_comercial),
	constraint validar_TransaccionA_1 check((tipo_moneda = 'Dolares' or tipo_moneda = 'dolares') or (tipo_moneda = 'Euros') or (tipo_moneda = 'euros') ),		
	constraint valida_cuentaorigen check(id_CuentaOrigen =id_cuenta_comercial)
)

--VALIDA UNICAMENTE QUE SEAN Transferencias entre cuentas tipo comercial. 
CREATE TRIGGER VALTRANA
ON TRANSACCION_TIPO_A
AFTER INSERT
as
DECLARE @comercial as int
DECLARE @id_transaccionTipoA AS INT
DECLARE @id_CuentaOrigen AS int
DECLARE @id_CuentaDestino AS int 
DECLARE @pais nvarchar(50)
DECLARE @tipo_moneda_AS nvarchar(50) 
DECLARE @cantidad AS money
DECLARE @Fecha_Transaccion AS date
DECLARE @id_CuentaComercial AS int 
DECLARE @hora_transaccion AS nvarchar(15)

SET @id_transaccionTipoA = (SELECT @id_transaccionTipoA FROM inserted)
SET @id_CuentaOrigen = (SELECT id_CuentaOrigen FROM inserted)
SET @id_CuentaDestino = (SELECT id_CuentaDestino FROM inserted)
SET @pais = (SELECT @pais FROM inserted)
SET @tipo_moneda_AS = (SELECT @tipo_moneda_AS FROM inserted)
SET @cantidad = (SELECT @cantidad FROM inserted)
SET @Fecha_Transaccion = (SELECT @Fecha_Transaccion FROM inserted)
SET @id_CuentaComercial = (SELECT @id_transaccionTipoA FROM inserted)
SET @hora_transaccion = (SELECT @id_transaccionTipoA FROM inserted)
SET @comercial = (SELECT COUNT(id_cuenta_comercial) FROM CUENTA_COMERCIAL WHERE (id_cuenta_comercial = @id_CuentaDestino))
--validar que la cuenta destino sea comercial

BEGIN
IF(@comercial <=0)
insert into TRANSACCION_TIPO_A(id_transaccionTipoA,id_CuentaOrigen,id_CuentaDestino,pais,tipo_moneda,cantidad,Fecha_Transaccion,id_cuenta_comercial,hora_transaccion_a)
values(@id_transaccionTipoA,@id_CuentaOrigen,@id_CuentaDestino,@pais,@tipo_moneda_AS,@cantidad ,@Fecha_Transaccion,@id_CuentaComercial,@hora_transaccion)
END
GO

--Insercion de datos en la tabla TRASANCCION_TIPO_A
insert into TRANSACCION_TIPO_A(id_transaccionTipoA,id_CuentaOrigen,id_CuentaDestino,pais,tipo_moneda,cantidad,Fecha_Transaccion,id_cuenta_comercial,hora_transaccion_a)
values('4040','4321','4324','Guatemala','dolares','100001','2019-12-12','4321','14:12')
insert into TRANSACCION_TIPO_A(id_transaccionTipoA,id_CuentaOrigen,id_CuentaDestino,pais,tipo_moneda,cantidad,Fecha_Transaccion,id_cuenta_comercial,hora_transaccion_a)
values('4041','4322','4329','Guatemala','euros','100501','2019-12-13','4322','10:12')
insert into TRANSACCION_TIPO_A(id_transaccionTipoA,id_CuentaOrigen,id_CuentaDestino,pais,tipo_moneda,cantidad,Fecha_Transaccion,id_cuenta_comercial,hora_transaccion_a)
values('4042','4323','4324','Guatemala','dolares','100500','2019-12-13','4323','11:12')
insert into TRANSACCION_TIPO_A(id_transaccionTipoA,id_CuentaOrigen,id_CuentaDestino,pais,tipo_moneda,cantidad,Fecha_Transaccion,id_cuenta_comercial,hora_transaccion_a)
values('4043','4322','4323','Guatemala','euros','100599','2019-12-16','4322','03:12')

--Consulta para saber cantidad de transacciones tipoA realizadas por cuentas comerciales o cuantas cuentas comerciales han realizado transacciones tipo A
select *from CUENTA_COMERCIAL 
select *from TRANSACCION_TIPO_A

--CUENTA_PREMIUM se relaciona con CUENTA
CREATE TABLE CUENTA_PREMIUM
(
	id_cuenta_premium int not null,
	cantidad_Apertura money not null,
	id_cuenta int not null,
	tipo_moneda_CuentaPremium varchar(15),   --para describir si lo que tiene son dolares o euros 
	constraint pk_cuenta_premium primary key(id_cuenta_premium),
	constraint fk_cuenta_premium foreign key (id_cuenta) references CUENTA(id_cuenta),
	constraint validar_moneda_premium check((tipo_moneda_CuentaPremium = 'Dolares' or tipo_moneda_CuentaPremium = 'dolares') or (tipo_moneda_CuentaPremium = 'Euros') or (tipo_moneda_CuentaPremium = 'euros')),
	constraint validar_cuentaPremium_1 check(cantidad_Apertura > 500000)
)


--Insercion de datos en la tabla CUENTA_PREMIUM
insert into CUENTA_PREMIUM(id_cuenta_premium,cantidad_Apertura,id_cuenta,tipo_moneda_CuentaPremium) values('9876','600000','1123','euros')
insert into CUENTA_PREMIUM(id_cuenta_premium,cantidad_Apertura,id_cuenta,tipo_moneda_CuentaPremium) values('9875','600000','1124','dolares')
insert into CUENTA_PREMIUM(id_cuenta_premium,cantidad_Apertura,id_cuenta,tipo_moneda_CuentaPremium) values('9874','700000','1125','dolares')
insert into CUENTA_PREMIUM(id_cuenta_premium,cantidad_Apertura,id_cuenta,tipo_moneda_CuentaPremium) values('9872','800000','1124','euros')
insert into CUENTA_PREMIUM(id_cuenta_premium,cantidad_Apertura,id_cuenta,tipo_moneda_CuentaPremium) values('9871','900000','1124','euros')

--Consulta para saber cuantas cuentas son cuentas premium
select *from CUENTA
select *from CUENTA_PREMIUM

--TRANSACCION_TIPO_B se relaciona con CUENTA_PREMIUM
CREATE TABLE TRANSACCION_TIPOB
(
	id_transaccionTipoB int not null,
	id_CuentaOrigen int not null,
	id_CuentaDestino int not null,	
	pais nvarchar(50) not null,
	tipo_moneda nvarchar(50) not null,
	cantidad money not null,
	id_cuenta_premium int not null,
	fecha_Transaccion date default GETDATE(),
	hora_transaccion_b nvarchar(15),	
	constraint pk_id_transaccionTipoB primary key(id_transaccionTipoB),
	constraint fk_id_transaccionTipoB foreign key (id_cuenta_premium) references CUENTA_PREMIUM(id_cuenta_premium),
	constraint validar_moneda_tipob check((tipo_moneda = 'Dolares' or tipo_moneda = 'dolares') or (tipo_moneda = 'Euros') or (tipo_moneda = 'euros')),
	constraint valida_cuentaorigenb check(id_CuentaOrigen =id_cuenta_premium)
)

--Consulta que relaciona cuentas premium con su cantidad de transacciones tipo B realizadas
select *from CUENTA_PREMIUM
select *from TRANSACCION_TIPOB

--Insercion de datos en la tabla TRANSACCION_TIPO_B
insert into TRANSACCION_TIPOB(id_transaccionTipoB,id_CuentaOrigen,id_CuentaDestino,pais,tipo_moneda,cantidad,Fecha_Transaccion,id_cuenta_premium,hora_transaccion_b)
values('3040','9871','9872','Guatemala','dolares','100001','2019-12-12','9871','14:12')
insert into TRANSACCION_TIPOB(id_transaccionTipoB,id_CuentaOrigen,id_CuentaDestino,pais,tipo_moneda,cantidad,Fecha_Transaccion,id_cuenta_premium,hora_transaccion_b)
values('3041','9872','9871','Guatemala','dolares','90000','2019-12-13','9872','10:12')
insert into TRANSACCION_TIPOB(id_transaccionTipoB,id_CuentaOrigen,id_CuentaDestino,pais,tipo_moneda,cantidad,Fecha_Transaccion,id_cuenta_premium,hora_transaccion_b)
values('3042','9874','9872','Guatemala','dolares','12.50','2019-12-13','9874','11:12')
insert into TRANSACCION_TIPOB(id_transaccionTipoB,id_CuentaOrigen,id_CuentaDestino,pais,tipo_moneda,cantidad,Fecha_Transaccion,id_cuenta_premium,hora_transaccion_b)
values('3043','9876','9871','Guatemala','euros','150599','2019-12-16','9876','03:12')

--COBRO_CUENTA_PREMIUM se relaciona con CUENTA_PREMIUM
CREATE TABLE COBRO_CUENTA_PREMIUM
(
	id_cobro_CuentaPremium int not null,
	tipo_cobro_premium nvarchar(50) not null,
	id_cuenta_premium int not null,
	constraint pk_id_cobro_CuentaPremium primary key(id_cobro_CuentaPremium),
	constraint fk_id_cobro_CuentaPremium foreign key (id_cuenta_premium) references CUENTA_PREMIUM(id_cuenta_premium),
	constraint validar_COBRO_CUENTA_PREMIUM check((tipo_cobro_premium = 'Deposito' or tipo_cobro_premium = 'deposito') or (tipo_cobro_premium = 'Retiros' or tipo_cobro_premium = 'retiros') or (tipo_cobro_premium = 'Efectivo' or tipo_cobro_premium = 'efectivo'))
)

--Transaccion tipo bitcon se relaciona con cuenta premium
CREATE TABLE TRANSACCION_BITCOIN 
(
	id_transaccion_bitcoin int not null,
	cantidad money not null,
	fecha date default GETDATE() not null,
	tipo_moneda nvarchar(50) not null,
	id_cuenta_premium int not null,
	hora_transaccion_bitcoin nvarchar(15) not null,
    constraint pk_id_transaccion_bitcoin primary key(id_transaccion_bitcoin),
	constraint fk_id_transaccion_bitcoin foreign key (id_cuenta_premium) references CUENTA_PREMIUM(id_cuenta_premium),
	constraint validar_moneda_tipoBitcoin check((tipo_moneda = 'Dolares' or tipo_moneda = 'dolares')),
	constraint validar_hora_transaccion check((CAST(SUBSTRING(hora_transaccion_bitcoin,0,3) AS INT) BETWEEN 8 AND 13))	
)



--Insercion de datos en la tabla TRANSACCION_BITCOIN
INSERT INTO TRANSACCION_BITCOIN(id_transaccion_bitcoin,cantidad,fecha,tipo_moneda,id_cuenta_premium,hora_transaccion_bitcoin)
VALUES('1445','100000.53','2019-12-07','dolares','9871','12:14')
INSERT INTO TRANSACCION_BITCOIN(id_transaccion_bitcoin,cantidad,fecha,tipo_moneda,id_cuenta_premium,hora_transaccion_bitcoin)
VALUES('1446','200.12',GETDATE(),'dolares','9872','11:30')
INSERT INTO TRANSACCION_BITCOIN(id_transaccion_bitcoin,cantidad,fecha,tipo_moneda,id_cuenta_premium,hora_transaccion_bitcoin)
VALUES('1447','10.99',GETDATE(),'dolares','9871','08:20')
INSERT INTO TRANSACCION_BITCOIN(id_transaccion_bitcoin,cantidad,fecha,tipo_moneda,id_cuenta_premium,hora_transaccion_bitcoin)
VALUES('1448','1230',GETDATE(),'dolares','9876','12:30')

--Consulta de cantidad de transacciones tipo bitcoin realizadas
select *from TRANSACCION_BITCOIN

--CONSULTAS A VALIDAR
--CONSULTA1 (Cuentas cuentas (por tipo) se apertura por dia)
select COUNT(Tipo_Cuenta) 'Total cuentas',Tipo_Cuenta,Fecha_Apertura	from CUENTA where (Fecha_Apertura = '2020-03-13') group by Tipo_Cuenta,Fecha_Apertura
--CONSULTA2 (Cantidad de clientes por pais que tienen cuentas comerciales y premium)
select nacionalidad,id_cliente into #Clientes_Tempo from CLIENTE order by nacionalidad asc
select  id_cliente,Tipo_Cuenta into #TipoCuenta from CUENTA order by Tipo_Cuenta asc
select ct.nacionalidad,COUNT(ct.nacionalidad) as 'Total Nacionalidad',tp.Tipo_Cuenta from #Clientes_Tempo ct inner join #TipoCuenta tp on ct.id_cliente = tp.id_cliente group by ct.nacionalidad,tp.Tipo_Cuenta
--CONSULTA3 (Que pais realiza mas transacciones por Bitcoin)
SELECT S.pais,S.id_cuenta INTO #PAIS_SURCURSAL FROM CUENTA C inner join SUCURSAL s on C.id_cuenta = s.id_cuenta
SELECT ps.pais,cp.id_cuenta_premium into #Transaccion_de_bitcoin FROM #PAIS_SURCURSAL ps inner join CUENTA_PREMIUM cp on ps.id_cuenta = cp.id_cuenta
select top 1 COUNT(tb1.pais) as 'Total',tb1.pais as 'Pais' from #Transaccion_de_bitcoin tb1 inner join TRANSACCION_BITCOIN tb2 on tb1.id_cuenta_premium = tb2.id_cuenta_premium group by tb1.pais order by tb1.pais desc 
--CONSULTA4 (Informacion de clientes que tienen mas de 30 anios y que comparten cuentas)
select id_cliente into #Clientes_EDAD from CLIENTE where DATEDIFF(YEAR,Fecha_De_Nacimiento, GETDATE()) >= 30
select cd.id_cliente into #Beneficiarios_id from BENEFICIARIO b inner join #Clientes_EDAD cd  on b.id_cliente=cd.id_cliente group by cd.id_cliente,b.id_cliente having count (cd.id_cliente)>0
select c.id_cliente,c.DPI,c.Nombre,c.Apellido,c.Lugar_De_Nacimiento,c.Fecha_De_Nacimiento,c.nacionalidad,c.Telefono_Casa,c.Telefono_Celular,c.Email from CLIENTE c inner join #Beneficiarios_id bi on c.id_cliente = bi.id_cliente 
--CONSULTA5 (Cuantas cuentas tipo comercio tienen mAs de 5 anios de apertura)
select count(Tipo_Cuenta) Total_Cuentas from CUENTA where DATEDIFF(YEAR,Fecha_Apertura, GETDATE()) > 5
--CONSULTA6 (Listado de transacciones en el ultimo trimestre, que corresponden a montos arriba de $ 100,000 (dolares y euros) y que sean realizadas entre las 11 pm y 3 am.)
SELECT * into #TRANSFERENCIAS_A_REGISTRO FROM TRANSACCION_TIPO_A where ((cantidad > 100000) and (DATEDIFF(MONTH,Fecha_Transaccion, GETDATE()) = 3) AND ( (CAST(SUBSTRING(hora_transaccion_a,0,3) AS INT) BETWEEN 1 AND 2) OR (CAST(SUBSTRING(hora_transaccion_a,0,3) AS INT) BETWEEN 11 AND 24)))
SELECT * into #TRANSFERENCIAS_B_REGISTRO FROM TRANSACCION_TIPOB where ((cantidad > 100000) and (DATEDIFF(MONTH,Fecha_Transaccion, GETDATE()) = 3) AND ( (CAST(SUBSTRING(hora_transaccion_b,0,3) AS INT) BETWEEN 1 AND 2) OR (CAST(SUBSTRING(hora_transaccion_b,0,3) AS INT) BETWEEN 11 AND 24)))
SELECT * into #TRANSFERENCIAS_BITCOIN_REGISTRO FROM TRANSACCION_BITCOIN where ((cantidad > 100000) and (DATEDIFF(MONTH,fecha ,GETDATE()) = 3) AND ( (CAST(SUBSTRING(hora_transaccion_bitcoin,0,3) AS INT) BETWEEN 1 AND 2) OR (CAST(SUBSTRING(hora_transaccion_bitcoin,0,3) AS INT) BETWEEN 11 AND 24)))
--CONSULTA7 (Pagos realizados con Bitcoin, por comercio)
select *from TRANSACCION_BITCOIN

