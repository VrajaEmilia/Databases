USE Bakery;

-- table with a single-column primary key and no foreign keys = department
--a table with a single-column primary key and at least one foreign key = employee
--a table with a multicolumn primary key customer order

ALTER TABLE customerOrder
DROP CONSTRAINT PK_ORDER;

ALTER TABLE customerOrder
ADD CONSTRAINT PK_ORDER PRIMARY KEY (orderID,customerID);

DROP VIEW SelectFromOneTable
DROP VIEW SelectFromTwoTables
DROP VIEW SelectWithGroupBy
--View with select from one table
GO
CREATE VIEW SelectFromOneTable AS 
	SELECT *
	FROM employee
	WHERE departmentID in (1,2,3)
GO 

Select * FROM SelectFromOneTable

--View with select from two tables
GO
CREATE VIEW SelectFromTwoTables AS 
	SELECT e.* , d.departmentName
	FROM employee e, department d
	WHERE e.departmentID = d.departmentID
GO

Select * FROM SelectFromTwoTables

--view with a SELECT statement that has a GROUP BY clause and operates on at least 2 tables.
GO
CREATE OR ALTER VIEW SelectWithGroupBy AS 
	SELECT COUNT(e.employeeID) AS employeeNO, d.departmentName
	FROM employee e, department d
	WHERE e.departmentID = d.departmentID
	GROUP BY d.departmentName
GO

Select * FROM SelectWithGroupBy

SELECT * FROM department
SELECT * FROM employee
SELECT * FROM customerOrder

GO
CREATE OR ALTER PROCEDURE DELETE_FROM_TABLE @table VARCHAR(40) AS
	PRINT ('DELETING FROM' + @table)
	DECLARE @query VARCHAR(50)
    SET @query = 'DELETE FROM ' + @table
    EXEC (@query);


GO
CREATE OR ALTER PROCEDURE INSERT_INTO_TABLE @table VARCHAR(40), @rows INT AS
	DECLARE @i INT
	IF @table = 'department'
	BEGIN
		SET @i=1
		DECLARE @name VARCHAR(40)
		WHILE @i<=@rows
		BEGIN
			SET @name = 'dep'+CAST(@i as varchar(10))
			INSERT INTO department(departmentID,departmentName) VALUES (@i,@name);
			SET @i = @i + 1
		END
	END
	IF @table = 'employee'
	BEGIN
		SET @i=1
		WHILE @i<=@rows
		BEGIN
			SET @name = 'name'+CAST(@i as varchar(10))
			INSERT INTO employee (employeeID, employeeNAME,departmentID) VALUES (@i,@name,@i);
			SET @i = @i + 1
		END
	END
	IF @table = 'customerOrder'
	BEGIN
		SET @i=1
		WHILE @i<=@rows
		BEGIN
			SET @name = 'order'+CAST(@i as varchar(10))
			INSERT INTO customerOrder( orderID, customerID,orderDescription) VALUES (@i,1,@name);
			SET @i = @i + 1
		END
	END


INSERT INTO Tables VALUES ('Employee'), ('Department'), ('customerOrder');
INSERT INTO Views VALUES ('SelectFromOneTable'), ('SelectFromTwoTables'), ('SelectWithGroupBy')
INSERT INTO Tests VALUES ('test1')


INSERT INTO TestTables (TestID,TableID,NoOfRows,Position) VALUES
	(1,1,10,1),
	(1,2,10,2),
	(1,3,10,3);

INSERT INTO TestViews(TestID,ViewID) VALUES
	(1,1),
	(1,2),
	(1,3)


EXEC INSERT_INTO_TABLE employee,10


GO
CREATE OR ALTER PROCEDURE run_test @test_name VARCHAR(40) AS 
		DECLARE @start DATETIME
		DECLARE @end DATETIME
		SET @start =getdate()
		-- variables we need
		DECLARE @name VARCHAR(50)
		DECLARE @table_id INT
		
		DECLARE @test_id INT
		SET @test_id = (SELECT TestID FROM Tests WHERE Name = @test_name) 

		INSERT INTO TestRuns(Description,StartAt) VALUES ('test run for '+@test_name,@start) 

		--creating a cursor for the order in which we need to delete from the tables
		DECLARE c1 CURSOR FOR 
		SELECT TableID
		FROM TestTables
		WHERE TestID =@test_id
		ORDER BY Position ASC

		OPEN c1
		FETCH NEXT 
		FROM c1
		INTO @table_id

		WHILE @@FETCH_STATUS = 0
		BEGIN
		   SET @name = (SELECT name FROM Tables WHERE TableID = @table_id)
		   EXEC DELETE_FROM_TABLE @name
		   FETCH NEXT 
		   FROM c1
		   INTO @table_id
		END

		CLOSE c1
		DEALLOCATE c1

		--creating a cursor for the order in which we need to insert into the tables
		DECLARE c2 CURSOR FOR 
		SELECT TableID
		FROM TestTables
		WHERE TestID =@test_id
		ORDER BY Position DESC

		---start,end of insert,test_run_id
		DECLARE @sInsert DATETIME
		DECLARE @eInsert DATETIME
		DECLARE @test_run_id INT
		SET  @test_run_id = (SELECT TestRunID from TestRuns WHERE StartAt = @start)
		OPEN c2
		FETCH NEXT 
		FROM c2
		INTO @table_id

		DECLARE @rows int

		WHILE @@FETCH_STATUS = 0
		BEGIN
		   SET @name = (SELECT name FROM Tables WHERE TableID = @table_id)
		   SET @rows = (SELECT NoOfRows FROM TestTables WHERE TestID=@test_id and TableID = @table_id)
		   SET @sInsert = GETDATE();
		   EXEC INSERT_INTO_TABLE @name, @rows
		   SET @eInsert = GETDATE();
		   INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@test_run_id,@table_id,@sInsert,@eInsert)
		   FETCH NEXT 
		   FROM c2
		   INTO @table_id
		END

		CLOSE c2
		DEALLOCATE c2

		--DECLARE c3 CURSOR FOR VIEWS 
		DECLARE @view_id INT

		DECLARE c3 CURSOR FOR 
		SELECT ViewID
		FROM TestViews
		WHERE TestID =@test_id

		OPEN c3
		FETCH NEXT 
		FROM c3
		INTO @view_id

		---start,end of view
		DECLARE @sView DATETIME
		DECLARE @eView DATETIME

		WHILE @@FETCH_STATUS = 0
		BEGIN
		   DECLARE @ViewName VARCHAR(40)
		   SET @ViewName = (SELECT Name From Views Where ViewID = @view_id)
		   SET @sView = GETDATE();
		   
		   IF @ViewName = 'SelectFromOneTable' SELECT * FROM SelectFromOneTable
		   IF @ViewName = 'SelectFromTwoTables' SELECT * FROM SelectFromTwoTables
		   IF @ViewName = 'SelectWithGroupBy' SELECT * FROM SelectWithGroupBy
		   
		   SET @eView = GETDATE();
		   INSERT INTO TestRunViews(TestRunID,ViewID, StartAt, EndAt) VALUES (@test_run_id,@view_id,@sView,@eView)
		   FETCH NEXT 
		   FROM c3
		   INTO @view_id
		END
		CLOSE c3
		DEALLOCATE c3
		SET @end = GETDATE()
		UPDATE TestRuns
		SET EndAt = @end
		WHERE @start = StartAt


EXEC run_test test1

SELECT * FROM employee
SELECT * FROM department
SELECT * FROM customerOrder

DECLARE @query VARCHAR(50)
SET @query = 'SELECT * FROM SelectFromOneTable'
EXEC @query

SELECT * FROM Tables
SELECT * FROM Views
SELECT * FROM Tests
SELECT * FROM TestTables
SELECT * FROM TestViews
SELECT * FROM TestRunTables
SELECT * FROM TestRunViews
SELECT * FROM Tests
SELECT * FROM TestRuns

DELETE FROM TestRuns
DELETE FROM TestTables
DELETE FROM TestViews
