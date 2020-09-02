USE AdventureWorks2017;

-- Crear un Trigger que notifique cuando exista algún cambio (insert o update) en la tabla clientes 
CREATE TRIGGER tiu_aviso ON Sales.Customer
	AFTER INSERT, UPDATE AS
	PRINT 'Actualiza datos'

SELECT *
FROM Sales.Customer

UPDATE Sales.Customer
SET PersonID = 10
WHERE CustomerID = 8


ALTER TRIGGER tiu_aviso ON Sales.Customer
	AFTER UPDATE AS
  if UPDATE(PersonID)
  begin
	print 'Actualiza datos PersonID'
  end
  else
  begin
	print 'otra cosa'
  end;

SELECT *
FROM Sales.Customer

UPDATE Sales.Customer
SET PersonID = 10
WHERE CustomerID = 10


ALTER TRIGGER sales.tiu_aviso ON sales.customer
  AFTER UPDATE AS

  DECLARE @valorAnterior INT
  DECLARE @valorNuevo INT

  SELECT @valorAnterior = personID
  FROM deleted

  SELECT @valorNuevo = PersonID
  FROM inserted
  
    IF UPDATE(Personid)
    BEGIN 
    PRINT 'ACTUALIZA DATOS persona id'
    PRINT @valorAnterior
    PRINT @valorNuevo
    END
    ELSE
    BEGIN 
    PRINT 'otra cosa'
    END

	SELECT *
FROM Sales.Customer

UPDATE Sales.Customer
SET PersonID = 10
WHERE CustomerID = 10

-- MANDAR A LLAMAR O A EJECUTAR OTROS SP's
--EXEC sp_add_agent_parameter



CREATE TABLE Persona
(
	ID INT NOT NULL,
	Nombre VARCHAR(50),
	Nombre_Anterior VARCHAR(50),
	Nombre_Igual_Cuenta_ INT
	CONSTRAINT pk_persona PRIMARY KEY(ID)
)

INSERT Persona(ID, Nombre) VALUES(1,'Fernando')
INSERT Persona(ID, Nombre) VALUES(2,'Lisbeth')
INSERT Persona(ID, Nombre) VALUES(3,'Karen')

SELECT * FROM Persona

CREATE TRIGGER tiu_valida_persona on Persona
		AFTER INSERT, UPDATE AS
		
	DECLARE @NombreNuevo VARCHAR(50)

	SELECT @NombreNuevo = nombre
	FROM inserted;

		UPDATE Persona --Nombre de la tabla
		SET Nombre_Igual_Cuenta = (SELECT COUNT(1) FROM Persona WHERE Nombre = @NombreNuevo ) --Listado de columnas a actualizar
		WHERE Nombre = @NombreNuevo

		--Modificar la columna Nombre_igual_Cuenta unicamente del registro que se esta repitiendo
		UPDATE Persona
		SET Nombre_Igual_Cuenta = (SELECT COUNT(1) FROM Persona WHERE Nombre = @NombreNuevo )
		FROM Persona P
			inner join inserted i on P.ID = i.ID;

-- Trigger que notifique con correo cuando exista cambio (insert, update, delete) en la tabla clientes
