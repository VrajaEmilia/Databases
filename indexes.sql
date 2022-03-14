--Work on 3 tables of the form Ta(aid, a2, …), Tb(bid, b2, …), Tc(cid, aid, bid, …), where:

--aid, bid, cid, a2, b2 are integers;
--the primary keys are underlined;
--a2 is UNIQUE in Ta;
--aid and bid are foreign keys in Tc, referencing the primary keys in Ta and Tb, respectively.

CREATE TABLE Ta(
	aid INT PRIMARY KEY IDENTITY(1,1),
	a2 INT UNIQUE
	)

CREATE TABLE Tb(
	bid INT PRIMARY KEY IDENTITY(1,1),
	b2 INT 
	)

CREATE TABLE Tc(
	cid INT PRIMARY KEY IDENTITY(1,1),
	aid INT FOREIGN KEY REFERENCES Ta(aid),
	bid INT FOREIGN KEY REFERENCES Tb(bid)
	)

ALTER TABLE Ta
ADD a3 VARCHAR(40) DEFAULT '+';

ALTER TABLE Tb
ADD b3 VARCHAR(40) DEFAULT '+';

UPDATE Ta
SET a3 = '+';

UPDATE Tb
SET b3 = '+';

UPDATE Ta
SET a3 = '-'
WHERE aid in(1,4);


UPDATE Tb
SET b3 = '-'
WHERE bid in(2,5);

INSERT INTO Ta VALUES (11),(21),(52),(34),(43);
INSERT INTO tb VALUES (25),(34),(25),(47),(78);

INSERT INTO Tc(aid,bid) VALUES (1,3),(1,5),(2,1),(3,1),(3,2),(3,3),(5,5)

SELECT * FROM Ta
SELECT * FROM Tb
SELECT * FROM Tc

--clustered index scan;
SELECT aid, a3 FROM Ta WHERE a3 = '-';


--clustered index seek;
SELECT * FROM Ta WHERE aid=2;


--nonclustered index scan;
SELECT a2 FROM Ta


--nonclustered index seek;
SELECT aid,a3 FROM Ta WHERE a2 = 52

--key lookup;
SELECT * FROM Ta WHERE a2 = 43

--Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze its execution plan.
IF EXISTS(SELECT * FROM sys.indexes WHERE name='index_b2')
DROP INDEX index_b2 ON Tb

SELECT bid FROM tb
WHERE b2 > 50       ---estimated rows to be read = 5 (all the rows in the table)
--Create a nonclustered index that can speed up the query. Examine the execution plan again.
CREATE NONCLUSTERED INDEX index_b2 ON Tb(b2 ASC)
SELECT bid FROM tb
WHERE b2 > 50       ---estimated rows to be read = 1


--Create a view that joins at least 2 tables. Check whether existing indexes are helpful,if not,
--reassess existing indexes / examine the cardinality of the tables.

GO
CREATE OR ALTER VIEW view1 AS
SELECT a.aid,b.bid
FROM Ta a
INNER JOIN Tb b ON a.a3 = b.b3
WHERE a.a3 = '-'

IF EXISTS(SELECT * FROM sys.indexes WHERE name='index_b3')
DROP INDEX index_b3 ON Tb

IF EXISTS(SELECT * FROM sys.indexes WHERE name='index_a3')
DROP INDEX index_a3 ON Ta

SELECT * FROM view1 -- cluestered index scan on Ta Tb

CREATE NONCLUSTERED INDEX index_b3 ON Tb(b3 ASC)
CREATE NONCLUSTERED INDEX index_a3 ON Ta(a3 ASC)
SELECT * FROM view1  -- NonClustered index seek on Ta Tb

