-- Lester Andrés García Aquino - 1003115

USE AdventureWorks2017;

CREATE TRIGGER Purchasing.tiu_ValidarInventario ON Production.ProductReview INSTEAD OF INSERT AS 
BEGIN
DECLARE @ID INT, 
	    @Date DATETIME,
		@Email NVARCHAR(100),
		@Existencias INT
SELECT @ID = ProductID,
	   @Date = ReviewDate,
	   @Email = EmailAddress 
FROM inserted
SELECT @Existencias = Quantity 
FROM Production.ProductInventory 
WHERE ProductID = @ID
IF(@Existencias > 100)
BEGIN
DECLARE @IDProd INT,
	    @Productos INT,
		@Revisada NVARCHAR(50),
		@FechaRevisada DATETIME, 
		@Rango INT,
		@InitialEmail NVARCHAR(50),
		@FechaNueva DATETIME,
		@Nota NVARCHAR(50)
DECLARE Cursor_Validar CURSOR
FOR SELECT * 
	FROM Production.ProductReview
OPEN cTest
FETCH NEXT FROM cTest INTO @IDProd,
						   @Productos,
						   @Revisada,
						   @fecha_revision,
						   @InitialEmail, 
						   @Rango, 
						   @Nota,
						   @FechaNueva 
WHILE (@@FETCH_STATUS = 0)
BEGIN
IF(@Date <> @FechaRevisada AND 
	@InitialEmail <> @Email AND 
	@IDProd = @Productos)
BEGIN
INSERT INTO Production.ProductReview(ProductReviewID,
									 ProductID,
									 ReviewerName,
									 ReviewDate,
									 EmailAddress,
									 Rating,
									 Comments,
									 ModifiedDate)
VALUE(@IDProd,
	  @Productos,
	  @Revisada,
	  @FechaRevisada,
	  @InitialEmail,
	  @Rango,
	  @Nota,
	  @FechaNueva)
END
FETCH NEXT 
FROM cTest INTO @IDProd,
			    @Productos,
				@Revisada,
				@FechaRevisada,
				@InitialEmail, 
				@Rango,
				@Nota,
				@FechaNueva 
END
CLOSE cTest
DEALLOCATE cTest
END
ELSE
BEGIN
PRINT 'ERROR, NO CUMPLE CON LAS CONDICIONES NECESARIAS'
END
END