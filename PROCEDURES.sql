USE [Bakery]


--CHANGE TYPE OF A COLUMN
GO
CREATE PROCEDURE Version1
AS
BEGIN 
ALTER TABLE ingredient
ALTER COLUMN ingredientPRICE varchar(25)
PRINT('VERSION 1: type of column price is varchar')
END
GO

Select * from ingredient

GO
CREATE PROCEDURE BackToVersion0
AS
BEGIN 
ALTER TABLE ingredient
ALTER COLUMN ingredientPRICE int NOT NULL
PRINT('BACK TO VERSION 0: type of column price is now int.')
END
GO


--ADD/REMOVE COLUMN

GO
CREATE PROCEDURE Version2
AS
BEGIN 
ALTER TABLE employee
ADD age int
PRINT('VERSION 2: Added column age in employee table.')
END
GO

GO
CREATE PROCEDURE BackToVersion1
AS
BEGIN 
ALTER TABLE employee
DROP COLUMN age
PRINT('BACK TO VERSION 1: Removed column age from employee table.')
END
GO

--ADD REMOVE CONSTRAINT

GO
CREATE PROCEDURE Version3
AS
BEGIN 
ALTER TABLE ingredient
ADD CONSTRAINT PR CHECK(ingredientPRICE>0)
PRINT('VERSION 3: ADDED CONSTRAINT ingredientPRICE>0.')
END
GO

GO
CREATE PROCEDURE BackToVersion2
AS
BEGIN 
ALTER TABLE ingredient
DROP CONSTRAINT PR
PRINT('BACK TO VERSION 2: Removed constraint ingredientPRICE>0.')
END
GO

--add / remove a primary key

GO
CREATE PROCEDURE Version4
AS
BEGIN 
ALTER TABLE person
ADD CONSTRAINT PK_Person PRIMARY KEY (ID)
PRINT('VERSION 4: Added primary key to person.')
END
GO

GO
CREATE PROCEDURE BackToVersion3
AS
BEGIN 
ALTER TABLE person
DROP CONSTRAINT PK_Person;
PRINT('BACK TO VERSION 3:Removed primary key.')
END
GO

-- add / remove a candidate key;

CREATE PROCEDURE Version5 AS
BEGIN
	ALTER TABLE person2
	ADD CONSTRAINT Person2_CK UNIQUE (FirstName,LastName)
	PRINT('VERSION 5: Added candidate key to person.')
END
GO

CREATE PROCEDURE BackToVersion4 AS
BEGIN
	ALTER TABLE person2
	DROP CONSTRAINT Person2_CK
	PRINT('BACK TO VERSION 4: Removed candidate key from person.')
END
GO

--add / remove a foreign key;

CREATE PROCEDURE Version6 AS
BEGIN
	ALTER TABLE car
	ADD CONSTRAINT FK_Person
	FOREIGN KEY (PersonID) REFERENCES person2(ID)
	PRINT('VERSION 6:Added foreign key.')
END
GO

CREATE PROCEDURE BackToVersion5 AS
BEGIN
	ALTER TABLE car
	DROP Constraint FK_Person
	PRINT('BACK TO VERSION 5:Removed foreign key.')
END
GO

-- create / drop a table.

CREATE PROCEDURE Version7 AS
BEGIN
	CREATE TABLE car_piece(
	pieceID int PRIMARY KEY NOT NULL,
	name varchar(255),
	);
	PRINT('VERSION 7:Added new table.')
END
GO

CREATE PROCEDURE BackToVersion6 AS
BEGIN
DROP TABLE car_piece
PRINT('BACK TO VERSION 6:Removed new table.')
END
GO

--MAIN
DROP PROCEDURE ChangeVersion


GO
CREATE PROCEDURE ChangeVersion @new_v int AS
BEGIN
DECLARE @current_v INT 
DECLARE @proc VARCHAR(50)
SET @current_v = (SELECT v FROM DBVersion)
IF @new_v > @current_v
				BEGIN
					WHILE @new_v > @current_v
					BEGIN
						SET @current_v = @current_v+1
						SET @proc = 'Version' + CAST(@current_v as varchar(5))
						EXEC @proc
					END
				END
ELSE
				BEGIN
					WHILE @new_v<@current_v
					BEGIN
						set @current_v=@current_v-1
						SET @proc='BackToVersion' + CAST(@current_v as varchar(5))
						EXEC @proc
					END
				END
UPDATE DBVersion
SET v = @new_v
END
GO

