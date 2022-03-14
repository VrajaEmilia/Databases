CREATE TABLE department (
    departmentID int NOT NULL,
    departmentName varchar(255),
	PRIMARY KEY (departmentID)
);

CREATE TABLE employee (
    employeeID int NOT NULL PRIMARY KEY,
    employeeNAME varchar(255),
	departmentID int FOREIGN KEY REFERENCES department(departmentID)
);

INSERT INTO department (departmentID, departmentName) VALUES
(1,'Storage'),
(2,'Shop'),
(3,'Delivery'),
(4,'Baking');

INSERT INTO employee (employeeID, employeeNAME,departmentID) VALUES
(1,'John',1),
(2,'Mary',2),
(3,'Steven',4),
(4,'Bob',3),
(5,'Anna',4),
(6,'Lucy',2),
(7,'Claire',3);

CREATE TABLE ingredient (
    ingredientID int NOT NULL PRIMARY KEY,
    ingredientNAME varchar(255),
	ingredientPRICE int NOT NULL
);



INSERT INTO ingredient(ingredientID, ingredientNAME, ingredientPRICE) VALUES
(1, 'flour', 1),
(2, 'eggs', 3),
(3, 'sugar', 1),
(4, 'milk', 3),
(5, 'salt', 1),
(6, 'chocolate', 5),
(7, 'vanilla', 5);

CREATE TABLE customer (
    customerID int NOT NULL PRIMARY KEY,
    customerNAME varchar(255),
	phoneNumber varchar(255),
	customerADDRESS varchar(255)
);

INSERT INTO customer(customerID, customerNAME, phoneNumber, customerADDRESS) VALUES
(1, 'Mihai', '07....','Unirii nr 3'),
(2, 'Ana-Maria', '07....','Lunii nr 4'),
(3, 'Evelin', '07....','Garoafelor nr 5'),
(4, 'Catalin', '07....','Banilor nr3'),
(5, 'Adrian', '07....','Eroilor nr 6'),
(6, 'Anca', '07....','Viilor nr 7'),
(7, 'Vanessa', '07....','Calea Manastur nr18');

CREATE TABLE menuItems (
    itemID int NOT NULL PRIMARY KEY,
    itemNAME varchar(255),
);

INSERT INTO menuItems(itemID, itemNAME) VALUES
(1, 'Cake'),
(2, 'Donut'),
(3, 'Cupcake');

CREATE TABLE cake (
    cakeID int NOT NULL PRIMARY KEY,
    type varchar(255)
);

CREATE TABLE donut (
    donutID int NOT NULL PRIMARY KEY,
    type varchar(255)
);

CREATE TABLE cupcake (
    cupcakeID int NOT NULL PRIMARY KEY,
    type varchar(255)
);

ALTER TABLE cake
DROP COLUMN type;

ALTER TABLE cake
ADD cakeType varchar(255);

ALTER TABLE donut
DROP COLUMN type;

ALTER TABLE donut
ADD donutType varchar(255);

ALTER TABLE cupcake
DROP COLUMN type;

ALTER TABLE cupcake
ADD cupcakeType varchar(255);


INSERT INTO cake(cakeID, cakeType) VALUES
(1, 'Chocolate'),
(2, 'Vanilla'),
(3, 'Red Velvet');

INSERT INTO donut(donutID, donutType) VALUES
(1, 'Chocolate'),
(2, 'Vanilla'),
(3, 'Strawberry');

INSERT INTO cupcake(cupcakeID, cupcakeType) VALUES
(1, 'ChocolateChip'),
(2, 'Vanilla'),
(3, 'M&Ms');

CREATE TABLE customerOrder (
    orderID int NOT NULL,
    customerID int FOREIGN KEY REFERENCES customer(customerID) NOT NULL,
	orderDescription varchar(255)
	); 

INSERT INTO customerOrder( orderID, customerID,orderDescription) VALUES
(1,1,'Gluten free vanilla cake'),
(2,3,'4 ChocolateChip Cupcakes'),
(3,2,'Red Velvet cake'),
(4,5,'12 Strawberry donuts'),
(5,4,'3 M&Ms cupcakes'),
(6,6,'5 Chocolate donuts'),
(7,7,'Chocolate cake'),
(8,3,'4 Vanilla Cupcakes'),
(9,6,'3 ChocolateChip cupcakes');

CREATE TABLE ingredientItemR (
    ingredientID int FOREIGN KEY REFERENCES ingredient(ingredientID),
	itemID int FOREIGN KEY REFERENCES menuItems(itemID)
);  
INSERT INTO ingredientItemR(itemID,ingredientID) VALUES
(1,1),
(1,2),
(1,3),
(1,4),
(2,1),
(2,2),
(2,3),
(2,4),
(2,7),
(3,1),
(3,2),
(3,3),
(3,6),
(3,7);


ALTER TABLE cake
ADD itemID int FOREIGN KEY REFERENCES menuItems(itemID);

ALTER TABLE donut
ADD itemID int FOREIGN KEY REFERENCES menuItems(itemID);

ALTER TABLE cupcake
ADD itemID int FOREIGN KEY REFERENCES menuItems(itemID);

UPDATE cake
SET itemID = 1

UPDATE donut
SET itemID = 2

UPDATE cupcake
SET itemID = 3

DROP TABLE ingredientItemR

CREATE TABLE ingredientItemR (
    ingredientID int NOT NULL FOREIGN KEY REFERENCES ingredient(ingredientID),
	itemID int NOT NULL FOREIGN KEY REFERENCES menuItems(itemID)
	PRIMARY KEY (ingredientID,itemID)
); 

INSERT INTO ingredientItemR(itemID,ingredientID) VALUES
(1,1),
(1,2),
(1,3),
(1,4),
(2,1),
(2,2),
(2,3),
(2,4),
(2,7),
(3,1),
(3,2),
(3,3),
(3,6),
(3,7);

--statement that violates integrity constraints
INSERT INTO department(departmentID,departmentName) VALUES
(1,'Wrong department');



Select * from cake
Select * from donut
Select * from cupcake
Select * from menuItems
Select * from ingredient
Select * from ingredientItemR
Select * from employee
Select * from department
Select * from customer
Select * from customerOrder

INSERT INTO employee(employeeID,employeeNAME,departmentID) VALUES
(1,'John',3),
(8,'John',1);

--ASSIGNMENT 2

--inserts above 
--updates below
--delete data

DELETE FROM customerOrder WHERE orderID=1 or orderID=2;
DELETE FROM employee WHERE employeeNAME='John' and departmentID=1;

--2 queries with the union operation; use UNION [ALL] and OR;
--the cupcakes and cakes that contain chocolate or vanilla
SELECT cakeType AS 'TYPE',cakeID as 'ID'
FROM cake 
WHERE cakeType LIKE '%Chocolate%' OR cakeType LIKE '%Vanilla%'
UNION ALL
SELECT cupcakeType,cupcakeID
FROM cupcake
WHERE cupcakeType LIKE '%Chocolate%' OR cupcakeType LIKE '%Vanilla%'

--intersect and in
INSERT into customer(customerID, customerNAME, phoneNumber, customerADDRESS) VALUES
(8,'Catalina','07..','Teilor nr7');

ALTER TABLE customerOrder
ADD itemID int FOREIGN KEY REFERENCES menuItems(itemID);

UPDATE customerOrder
SET customerOrder.itemID = 1
WHERE orderID = 2;

UPDATE customerOrder
SET customerOrder.itemID = 2
WHERE orderID = 3;

UPDATE customerOrder
SET customerOrder.itemID = 2
WHERE orderID = 7;

--intersect
--getting the items that have been ordered that contain flour
SELECT itemID
FROM menuItems
WHERE itemID IN (SELECT itemID FROM customerOrder)
INTERSECT
SELECT itemID
FROM ingredientItemR
WHERE ingredientID IN (SELECT ingredientID FROM ingredient WHERE ingredientNAME='flour');

--getting the items that have been ordered that contain milk
SELECT itemID
FROM menuItems
WHERE itemID IN (SELECT itemID FROM customerOrder)
INTERSECT
SELECT itemID
FROM ingredientItemR
WHERE ingredientID IN (SELECT ingredientID FROM ingredient WHERE ingredientNAME='milk');

--2 queries with the difference operation; use EXCEPT and NOT IN;
ALTER TABLE ingredient
ADD inStock int DEFAULT 0;

ALTER TABLE ingredient
ADD CHECK (inStock=1 or inStock=0);

UPDATE ingredient
SET inStock=1
WHERE ingredientID IN (1,2,3,4,7);

--the ingredients that are out of stock with a price over 1
SELECT ingredientName
FROM ingredient
WHERE ingredientPRICE>1
EXCEPT
SELECT ingredientName
FROM ingredient
WHERE inStock=1;

--the ingredients that are not in stock and are necessary for orders
UPDATE customerOrder
SET customerOrder.itemID = 3
WHERE orderID = 8;

SELECT ingredientID
FROM ingredientItemR
WHERE itemID IN (SELECT itemID FROM customerOrder)
EXCEPT
SELECT ingredientid
FROM ingredient
WHERE inStock NOT IN(0);

--INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN

--show all the distinct locations where food needs to be delivered
SELECT DISTINCT customerADDRESS
FROM customer
INNER JOIN customerORDER ON customer.customerID = customerOrder.customerID
ORDER BY customerADDRESS ASC;

--FULL JOIN ON 3 tables 
SELECT C.cakeType,D.donutType, M.itemID 
FROM((cake C FULL JOIN menuItems M on C.itemID=M.itemID)
	FULL JOIN donut D on M.itemID=D.itemID );
--LEFT JOIN on 2 m:n relatioships
CREATE TABLE drinks (
    drinkID int NOT NULL PRIMARY KEY,
    drinkNAME varchar(255),
);
INSERT INTO drinks(drinkID,drinkNAME) VALUES
(1,'espresso'),
(2,'latte machiatto'),
(3,'capuccino'),
(4,'Chocolate milkshake'),
(5,'Vanilla milkshake');

CREATE TABLE drinksIngredientsR(
	ingredientID int FOREIGN KEY REFERENCES ingredient(ingredientID),
	drinkID int FOREIGN KEY REFERENCES drinks(drinkID)
	);
INSERT INTO ingredient(ingredientID,ingredientNAME,ingredientPRICE,inStock) VALUES
(8,'coffee',4,1);

INSERT INTO drinksIngredientsR(ingredientID,drinkID) VALUES
(8,1),
(8,2),
(4,2),
(8,3),
(4,3),
(3,3),
(4,4),
(3,4),
(5,4),
(5,4),
(6,4),
(4,5),
(3,5),
(7,5);
SELECT * FROM drinks;
SELECT * FROM ingredient;
SELECT * FROM drinksIngredientsR;

--the ids of those ingredients that are only used in drinks
SELECT drinksIngredientsR.ingredientID
FROM drinksIngredientsR
LEFT JOIN ingredientItemR r2 ON r2.ingredientID = drinksIngredientsR.ingredientID
WHERE r2.ingredientID is NULL
GROUP BY drinksIngredientsR.ingredientID

--RIGHT JOIN
--shows the customer and their orders
SELECT C.customerNAME, C.customerADDRESS, O.orderID, O.orderDescription
FROM customerOrder O
RIGHT JOIN customer C ON c.customerID=O.customerID;
-- queries with the IN operator and a subquery in the WHERE clause; in at least one case, 
--the subquery should include a subquery in its own WHERE clause;


--the orders that cannot be completed because ingredients are not in stock
SELECT *
FROM customerOrder
WHERE customerOrder.itemID IN ( SELECT itemID FROM ingredientItemR WHERE ingredientItemR.ingredientID IN(SELECT ingredientID from ingredient WHERE inStock IS NULL));

--employees that work either in the delivery department or shop department
SELECT *
FROM employee
WHERE employee.departmentID IN(SELECT departmentID from department where departmentName='Delivery' or departmentName='Shop')
ORDER BY departmentID;

--2 queries with the EXISTS operator and a subquery in the WHERE clause

--will display the ingredients if one of the prices was made <0 by mistake
SELECT *
FROM ingredient
WHERE EXISTS (SELECT * FROM ingredient WHERE ingredientPRICE<0);

--will display the employees that work in the baking department if there are any orders made
SELECT *
FROM employee
WHERE employee.departmentID=4 and EXISTS (SELECT * FROM customerOrder);

-- 2 queries with a subquery in the FROM clause;       

--the ingredients that have the price more than the average
SELECT i.ingredientID, i.ingredientNAME, i.ingredientPRICE 
FROM (SELECT avg(ingredientPRICE) AS PriceAverage FROM ingredient) AS av, ingredient AS i
WHERE i.ingredientPRICE  > av.PriceAverage;

--the number of orders made by each customer
SELECT customer.customerID, COUNT(customerOrder.orderID) as 'NR.ORDERS'
FROM
    (customer LEFT JOIN
    customerOrder ON customerOrder.customerID =customer.customerID)
	GROUP BY customer.customerID;

SELECT * FROM customerOrder;
--4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 
--2 of the latter will also have a subquery in the HAVING clause; use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;

--how many employees work in each department
SELECT COUNT(E.employeeID) AS 'Nr of workers', E.departmentID
FROM employee E
GROUP BY E.departmentID;

--all the customers that ordered more than once
SELECT customerOrder.customerID, COUNT(customerID) AS Count
FROM customerOrder
GROUP BY customerID
HAVING COUNT(customerID) > 1;

--shows how many orders has the client with the name Vanessa
SELECT customerOrder.customerID, COUNT(customerID) AS Count
FROM customerOrder
GROUP BY customerID
HAVING customerID IN(SELECT customerID FROM customer WHERE customerNAME='Vanessa');

--shows the departments that have at least 2 workers
SELECT COUNT(E.employeeID) AS 'Nr of workers', E.departmentID
FROM employee E
GROUP BY E.departmentID
HAVING 2>=(SELECT COUNT(*) from employee E2 WHERE E2.departmentID=E.departmentID)

--4 queries using ANY and ALL to introduce a subquery 
--in the WHERE clause (2 queries per operator); rewrite 2 of them with aggregation operators, and the other 2 with IN / [NOT] IN

--all the costumers from the table that have placed at least an order
SELECT *
FROM customer
WHERE customerID = ANY(SELECT customerID FROM customerOrder);

--all the items that have been ordered at least once
SELECT *
FROM menuItems
WHERE itemID = ANY(SELECT itemID FROM customerOrder);
--rewritten with IN
SELECT *
FROM menuItems
WHERE itemID IN (SELECT itemID FROM customerOrder);
--ingredients that are not in any orders
SELECT *
FROM ingredient
WHERE ingredientID != ALL(SELECT e.ingredientID FROM ingredientItemR e LEFT JOIN customerOrder c on e.itemID=c.itemID)

--customers that haven't placed any orders yet
SELECT *
FROM customer C
WHERE C.customerID != ALL(SELECT C2.customerID FROM customerOrder C2)
--rewritten with  NOT IN
SELECT *
FROM customer C
WHERE C.customerID NOT IN(SELECT C2.customerID FROM customerOrder C2)


-- LAB 3
Select * from ingredient

SELECT * from customer;


CREATE TABLE person (
    id int NOT NULL,
    FirstName varchar(255),
	LastName varchar(255),
);

CREATE TABLE person2(
    FirstName varchar(255),
	LastName varchar(255),
);

ALTER TABLE person2
ADD ID int not null;

ALTER TABLE person2
ADD CONSTRAINT PID PRIMARY KEY (ID)


CREATE TABLE car(
	id int NOT NULL,
	Model varchar(50),
	PRIMARY KEY(id)
	);

CREATE TABLE DBVersion(
	v int DEFAULT 0
);

INSERT INTO DBVersion(v) VALUES
(0);

EXEC ChangeVersion 7
EXEC ChangeVersion 0




