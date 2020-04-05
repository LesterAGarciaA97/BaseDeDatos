USE ElBuenGusto;

INSERT INTO CLIENTE (Id_Cliente, Contacto, DPI_Cliente, Fecha_Nacimiento)
VALUES
(123, 54390435, '3001060090101', '2000-04-13'),
(543, 24859384, '3001495600101', '1990-10-11'),
(235, 57869403, '3001485960101', '1995-07-14'),
(154, 30495867, '3001574860101', '1957-04-19'),
(345, 54958829, '3001489390101', '2000-05-21');

INSERT INTO AUTOMOVIL (Id_Automovil, Precio_Automovil, Marca_Automovil, Modelo_Automovil, Fecha_Ingreso, Placa_Automovil, Id_Cliente)
VALUES
(987, 35000, 'Honda', '2010', '2011-04-13', '550GFL', 123),
(569, 35500, 'Volvo', '2000', '2000-01-01', '984CYP', 543),
(968, 90000, 'Toyota', '2009', '2015-03-19', '335GRL', 235),
(597, 57450, 'Kia', '2018', '2019-02-15', '290AYP', 154),
(879, 89275, 'Nissan', '2021', '2020-05-20', '436FRL', 345);

INSERT INTO REVISION (Id_Revision, Fecha_Ingreso, Fecha_Salida)
VALUES
(586, '2020-10-13', '2020-10-13'),
(103, '2020-02-19', '2020-02-21'),
(284, '2020-03-21', '2020-03-27'),
(483, '2020-01-20', '2020-01-30'),
(354, '2020-05-09', '2020-07-09');

INSERT INTO OPERACION (Id_Operacion, Duracion_Operacion, Id_Revision)
VALUES
(295, '03:10:30.0000000', 586),
(583, '05:00:00.0000000', 103),
(481, '01:50:49.0000000', 284),
(984, '02:50:59.0000000', 483),
(734, '04:23:45.0000000', 354);

INSERT INTO MATERIAL (Id_Material, Detalle_Material, Materiales_Utilizados)
VALUES
(384, 'Pastillas de frenos', 1),
(291, 'Radiador', 2),
(284, 'Polarizado 3M', 5),
(124, 'Llantas FireStone', 4),
(491, 'Carga aire acondicionado', 2);
