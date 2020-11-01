CREATE OR ALTER PROCEDURE UPS_loadData 
AS
BEGIN
	DECLARE @commitName AS VARCHAR(50)
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	BEGIN TRANSACTION
	CREATE TABLE #tempCSVData(
		fecha VARCHAR(20),
		hora VARCHAR(20),
		origen varchar(50),
		destino varchar(50),
		tipo INT,
		duracion INT,
		estado INT
	);
	BULK INSERT #tempCSVData
	FROM 'C:\datos.csv'
	WITH (FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n');
	SAVE TRANSACTION datosCargados;
	DECLARE @fechaTabla AS VARCHAR(20)
	DECLARE @fecha AS DATE
	DECLARE @horaTabla AS VARCHAR(20)
	DECLARE @hora AS TIME
	DECLARE @tipo AS INT
	DECLARE @duracion AS INT
	DECLARE @estadoConfirm AS INT
	DECLARE @origen AS VARCHAR(50)
	DECLARE @destino AS VARCHAR(50)
	DECLARE manejoDatos CURSOR FOR
	SELECT fecha, hora, origen, destino, tipo, duracion, estado FROM #tempCSVData
	OPEN manejoDatos;
	DECLARE @i AS INT
	SET @i = 0;
	FETCH NEXT FROM manejoDatos INTO @fechaTabla, @horaTabla, @origen, @destino, @TIPO, @duracion
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @commitName = 'Nombre' + @i;
			SELECT @fecha = CONVERT(DATE, @fechaTabla, 1)
			SELECT @hora = CONVERT(TIME, @horaTabla, 8)
			INSERT INTO Eventos(fecha, hora, origen) VALUES (@fecha, @hora, @origen);
			DECLARE @eventoId AS INT
			SELECT @eventoId = MAX(id) FROM Eventos
			IF @tipo = 1
			BEGIN
				IF @estadoConfirm = 2 BEGIN
					SELECT @eventoId = id FROM Llamadas INNER JOIN Eventos ON Eventos.id = Llamadas.idEvento 
					WHERE destino = @destino AND duracion = @duracion AND origen = @origen AND fecha = @fecha AND hora = @hora
				END
				ELSE
				BEGIN
					INSERT INTO Llamadas VALUES (@eventoId, @destino, @duracion)
				END
				SAVE TRANSACTION @commitName;
			END
			ELSE IF @tipo = 2
			BEGIN
				BEGIN
					SELECT @eventoId = id FROM Mensajes INNER JOIN Eventos ON Eventos.id = Mensajes.idEvento 
					WHERE destino = @destino AND cantidadMensajes = @duracion AND origen = @origen AND fecha = @fecha AND hora = @hora
				END
				BEGIN
					INSERT INTO Mensajes VALUES (@eventoId, @destino, @duracion)
				END
				SAVE TRANSACTION @commitName;
			END
			ELSE IF @tipo = 3
			BEGIN
				BEGIN
					SELECT @eventoId = id FROM Datos INNER JOIN Eventos ON Eventos.id = Datos.idEvento 
					WHERE ipDestino = @destino AND consumo = @duracion AND origen = @origen AND fecha = @fecha AND hora = @hora
				END
				BEGIN
					INSERT INTO Datos VALUES (@eventoId, @destino, @duracion)
				END
				SAVE TRANSACTION @commitName;
			END
			ELSE
			BEGIN
				ROLLBACK TRANSACTION @commitName;
			END
			SET @i = 0;
		END
	CLOSE manejoDatos;
	DEALLOCATE manejoDatos;
	COMMIT TRANSACTION;
END;