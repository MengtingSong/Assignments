-- 1. What is View? What are the benefits of using views?
-- A view is a virtual table whose contents are defined by a query. Like a real table, 
-- a view consists of a set of named columns and rows of data.
-- Benefits:
-- 1. To Simplify Data Manipulation: Views can simplify how users work with data. 
-- You can define frequently used joins, projections, UNION queries, and SELECT 
-- queries as views so that users do not have to specify all the conditions and 
-- qualifications every time an additional operation is performed on that data. 
-- 2. Views enable you to create a backward compatible interface for a table when its schema changes. 
-- 3. To Customize Data: Views let different users to see data in different ways, 
-- even when they are using the same data at the same time. This is especially 
-- useful when users who have many different interests and skill levels share 
-- the same database. For example, a view can be created that retrieves only 
-- the data for the customers with whom an account manager deals. The view can 
-- determine which data to retrieve based on the login ID of the account manager who uses the view.
-- 4. Distributed queries can also be used to define views that use data from multiple heterogeneous sources 
-- This is useful, for example, if you want to combine similarly structured data
-- from different servers, each of which stores data for a different region of your organization.

-- 2. Can data be modified through views?
-- Data in the base table can be modified through views with restrictions and limitations.

-- 3. What is stored procedure and what are the benefits of using it?
-- A stored procedure groups one or more Transact-SQL statements into a logical unit, 
-- stored as an object in a SQL Server database.
-- Benefits:
-- 1. Increase database security. Using stored procedures provides increased security for 
-- a database by limiting direct access. 
-- 2. Faster execution: Stored procedures generally result in improved performance because 
-- the database can optimize the data access plan used by the procedure and cache it for subsequent reuse.
-- 3. Stored procedures help centralize your Transact-SQL code in the data tier. 
-- Websites or applications that embed ad hoc SQL are notoriously difficult to modify 
-- in a production environment. When ad hoc SQL is embedded in an application, 
-- you may spend too much time trying to find and debug the embedded SQL. Once you’ve found the bug, 
-- chances are you’ll need to recompile the page or program executable, causing unnecessary 
-- application outages or application distribution nightmares. If you centralize your 
-- Transact-SQL code in stored procedures, you’ll have only one place to look for SQL code or SQL batches. 
-- If you document the code properly, you’ll also be able to capture the areas that need fixing.
-- 4. Stored procedures can help reduce network traffic for larger ad hoc queries. 
-- Programming your application call to execute a stored procedure, rather then push 
-- across a 5000 line SQL call, can have a positive impact on your network and application 
-- performance, particularly if the call is repeated thousands of times a minute 
-- 5. Stored procedures encourage code reusability. 

-- 4. What is the difference between view and stored procedure?
-- View is simple showcasing data stored in the database tables whereas 
-- a stored procedure is a group of statements that can be executed. 
-- A view is faster as it displays data from the tables referenced whereas a store procedure executes sql statements.

-- 5. What is the difference between stored procedure and functions?
-- The function must return a value but in Stored Procedure it is optional. 
-- Even a procedure can return zero or n values. 
-- Functions can have only input parameters for it whereas Procedures can have input or output parameters. 
-- Functions can be called from Procedure whereas Procedures cannot be called from a Function.
-- Functions can ONLY be used in expressions whereas Procedures cannot be used in expressions.

-- 6. Can stored procedure return multiple result sets?
-- Most stored procedures return multiple result sets. 
-- Such a stored procedure usually includes one or more select statements. 
-- The consumer needs to consider this inclusion to handle all the result sets.

-- 7. Can stored procedure be executed as part of SELECT Statement? Why?
-- NO. Stored procedures are typically executed with an EXEC statement. 

-- 8. What is Trigger? What types of Triggers are there?
-- A trigger defines a set of actions that are performed in response to an 
-- insert, update, or delete operation on a specified table. 
-- When such an SQL operation is executed, the trigger is said to have been activated. 
-- There are three types of triggers in SQL Server. DDL Trigger. DML Trigger. Logon Trigger.

-- 9. What are the scenarios to use Triggers?
-- A database trigger is procedural code that is automatically executed 
-- in response to certain events on a particular table or view in a database. 
-- The trigger is mostly used for maintaining the integrity of the information on the database.

-- 10. What is the difference between Trigger and Stored Procedure?
-- Trigger executes automatically on occurrences of an event whereas, 
-- the Procedure is executed when it is explicitly invoked.

USE Northwind
GO

-- 1-3
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE 
BEGIN TRANSACTION modify_db
    DECLARE @max_id INT
    SELECT @max_id = MAX(RegionID) FROM dbo.Region

    INSERT INTO dbo.Region
    VALUES
    (@max_id+1, 'Middle Earth')   -- Should use '' not "" for string entry

    SELECT @max_id = MAX(TerritoryID) FROM dbo.Territories
    DECLARE @region_id INT
    SELECT @region_id = r.RegionID FROM dbo.Region r WHERE r.RegionDescription = 'Middle Earth'
    
    INSERT INTO dbo.Territories
    VALUES
    (@max_id+1, 'Gondor', @region_id)   
    -- If the primary key is not set with INDENTITY, it won't be inserted automatically by the system
    -- Can also use SET IDENTITY_INSERT ON to allow explicitly inserting indentity values for PK with IDENTITY constraint 

    INSERT INTO dbo.Employees
    (LastName, FirstName)   -- Specify the columns if not inserting values for all columns
    VALUES
    ('King', 'Aragorn')

    DECLARE @emp_id INT
    SELECT @emp_id = e.EmployeeID FROM dbo.Employees e WHERE e.FirstName = 'Aragorn' AND e.LastName = 'King'
    DECLARE @territory_id INT
    SELECT @territory_id = TerritoryID FROM dbo.Territories WHERE TerritoryDescription = 'Gondor'
    
    INSERT INTO dbo.EmployeeTerritories
    VALUES
    (@emp_id, @territory_id)

    UPDATE dbo.Territories 
    SET TerritoryDescription = 'Arnor'
    WHERE TerritoryDescription = 'Gondor'

    -- DELETE FROM dbo.Employees
    -- WHERE EmployeeID IN
    -- (SELECT EmployeeID FROM dbo.EmployeeTerritories
    -- WHERE TerritoryID = 
    -- (SELECT TerritoryID FROM dbo.Territories
    -- WHERE TerritoryDescription = 'Gondor'))
    -- Will cause multi-implementation of subqueriries -> Use JOIN instead

    -- Can use alias in DELETE query. 
    -- Just you have use that alias after DELETE keyword than it will work. 
    -- It specifies that from which table you have delete the records.
    -- e.g. DELETE b FROM table_b b WHERE NOT EXISTS (SELECT * FROM table_a a WHERE a.some_id = b.some_id)
    
    DELETE FROM dbo.EmployeeTerritories     -- Can't delete from two tables if not using JOIN afterwards
    WHERE TerritoryID = @territory_id
    
    -- Can't delete employees if the referenced data is not deleted
    DELETE FROM dbo.Employees
    WHERE EmployeeID = @emp_id

    DELETE FROM dbo.Territories
    WHERE TerritoryID = @territory_id

    DELETE FROM dbo.Region
    WHERE RegionDescription = 'Middle Earth'

ROLLBACK
GO

-- 4
CREATE VIEW view_product_order_song AS
SELECT p.ProductID, SUM(od.Quantity) OrderedQuantity
FROM dbo.Products p
INNER JOIN dbo.[Order Details] od
ON p.ProductID = od.ProductID
GROUP BY p.ProductID
GO

DROP VIEW view_product_order_song
GO

-- 5
CREATE PROCEDURE sp_product_order_quantity_song
    @product_id INT,
    @ordered_quantity INT OUTPUT
AS
    SELECT @ordered_quantity = SUM(od.Quantity) FROM dbo.[Order Details] od
    WHERE od.ProductID = @product_id
GO

DECLARE @product_id INT = 1
DECLARE @ordered_quantity INT
EXEC sp_product_order_quantity_song @product_id, @ordered_quantity = @ordered_quantity OUTPUT
SELECT @product_id ProductID, @ordered_quantity OrderedQuantity
GO

-- 6
CREATE PROCEDURE sp_product_order_city_song
    @product_name NVARCHAR(40)
AS
    SELECT TOP 5 c.City, SUM(od.Quantity) OrderedQuantity
    FROM dbo.ORders o
    INNER JOIN dbo.Customers c
    ON o.CustomerID = c.CustomerID
    INNER JOIN dbo.[Order Details] od
    ON o.OrderID = od.OrderID
    INNER JOIN dbo.Products p
    ON p.ProductID = od.ProductID
    WHERE p.ProductName = @product_name
    GROUP BY c.City
    ORDER BY OrderedQuantity DESC
GO

EXEC sp_product_order_city_song Chai 
GO

-- 7
CREATE PROCEDURE sp_move_employees_song
    @territory NCHAR(50)
AS
    DECLARE @emp_num INT
    SELECT @emp_num = COUNT(1)
    FROM dbo.EmployeeTerritories et
    INNER JOIN dbo.Territories t
    ON et.TerritoryID = t.TerritoryID
    WHERE t.TerritoryDescription = '@territory'

    DECLARE @territory_id NVARCHAR(20)
    SELECT @territory_id = MAX(t.TerritoryID)+1
    FROM dbo.Territories t

    DECLARE @region_id INT
    SELECT @region_id = r.RegionID
    FROM dbo.Region r
    WHERE r.RegionDescription = 'Northern'

    IF @emp_num > 0
    BEGIN
        INSERT INTO dbo.Territories
        (TerritoryID, TerritoryDescription, RegionID)
        VALUES
        (@territory_id, 'Stevens Point', @region_id)

        DECLARE @old_territory_id NVARCHAR(20)
        SELECT @old_territory_id = t.TerritoryID
        FROM dbo.Territories t
        WHERE t.TerritoryDescription = @territory

        UPDATE dbo.EmployeeTerritories
        SET TerritoryID = @territory_id
        WHERE TerritoryID = @old_territory_id

    END    
GO

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRANSACTION move_emp
    -- Lock Employees table
    SELECT COUNT(1) EmployeeNumber FROM dbo.Employees

    EXEC sp_move_employees_song 'Troy'
    SELECT * FROM dbo.Territories t WHERE t.TerritoryDescription = 'Stevens Point'

ROLLBACK
GO

-- 8
CREATE TRIGGER move_back_employees
ON dbo.EmployeeTerritories
AFTER INSERT
AS
DECLARE @emp_num INT
DECLARE @new_terr_id NVARCHAR(20)
DECLARE @old_terr_id NVARCHAR(20)

SELECT @new_terr_id = t.TerritoryID
FROM dbo.Territories t
WHERE t.TerritoryDescription = 'Troy'

SELECT @new_terr_id = t.TerritoryID
FROM dbo.Territories t
WHERE t.TerritoryDescription = 'Stevens Point'

SELECT @emp_num = COUNT(1)
FROM dbo.EmployeeTerritories et
WHERE et.TerritoryID = @new_terr_id

IF @emp_num > 100
BEGIN
    UPDATE dbo.EmployeeTerritories
    SET TerritoryID = @old_terr_id
    WHERE TerritoryID = @new_terr_id
END

DROP TRIGGER move_back_employees

-- 9
BEGIN TRANSACTION new_table
CREATE TABLE city_song
(
    CityID INT PRIMARY KEY IDENTITY(1,1),
    City VARCHAR(20) NOT NULL
)

SET IDENTITY_INSERT city_song OFF
INSERT INTO city_song 
(City)
VALUES          -- Every record/row needs to be included in () and seperated by ,
('Seattle'),
('Green Bay')

CREATE TABLE people_song
(
    PeopleID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(45) NOT NULL,
    CityID INT FOREIGN KEY REFERENCES city_song(CityID) ON DELETE SET NULL
)

INSERT INTO people_song
(Name, CityID)
VALUES
('Aaron Rodgers', 2),
('Russell Wilson', 1),
('Jody Nelson', 2)

INSERT INTO dbo.city_song
(City)
VALUES
('Madison')

UPDATE dbo.people_song      -- Can't and no need to use table alias in UPDATE statement
SET CityID = 3
WHERE CityID = 1

DELETE FROM dbo.city_song
WHERE City = 'Seattle'

COMMIT
GO

CREATE VIEW Packers_song 
AS
    SELECT p.PeopleID, p.Name, p.CityID, c.City
    FROM dbo.people_song p
    INNER JOIN dbo.city_song c
    ON p.CityID = c.CityID
    WHERE c.City = 'Green Bay'

GO

DROP TABLE dbo.people_song
DROP TABLE dbo.city_song
DROP VIEW Packers_song
GO

-- 10
CREATE PROC sp_birthday_employees_song 
AS
    CREATE TABLE birthday_employees_song
    (
        EmployeeID INT PRIMARY KEY 
        FOREIGN KEY REFERENCES dbo.Employees(EmployeeID),
        BirthDate DATETIME
        -- Can NOT reference BirthDate in Employees table
        -- The column in parent table to be referenced as FK MUST be UNIQUE
    )

    INSERT INTO birthday_employees_song
    SELECT e.EmployeeID, e.BirthDate
    FROM dbo.Employees e
    WHERE MONTH(e.BirthDate) = 2

    SELECT * FROM birthday_employees_song

EXEC sp_birthday_employees_song

DROP TABLE birthday_employees_song
GO

-- 11
CREATE PROCEDURE sp_song_1
AS
    SELECT City
    FROM
    (SELECT City, COUNT(CustomerID) CustomerNum
    FROM 
    (SELECT c.CustomerID, c.City, COUNT(od.ProductID) ProductKindNum
    FROM dbo.Customers c
    LEFT JOIN dbo.Orders o
    ON c.CustomerID = o.CustomerID
    LEFT JOIN dbo.[Order Details] od    -- Both need to use LEFT JOIN not INNER JOIN
    ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.City) cp   -- Need to give result set of subquery an alias to be used in SELECT statement
    WHERE ProductKindNum <= 1
    GROUP BY City) cc
    WHERE CustomerNum >= 2

GO

CREATE PROCEDURE sp_song_2
AS
    WITH cte_product_num
    AS 
    (
        SELECT c.CustomerID, COUNT(od.ProductID) ProductKindNum
        FROM dbo.Customers c
        LEFT JOIN dbo.Orders o
        ON c.CustomerID = o.CustomerID
        LEFT JOIN dbo.[Order Details] od    -- Both need to use LEFT JOIN not INNER JOIN
        ON o.OrderID = od.OrderID
        GROUP BY c.CustomerID
        HAVING COUNT(od.ProductID) <= 1
    ),
    cte_customer_num
    AS
    (
        SELECT City, COUNT(c.CustomerID) CustomerNum
        FROM cte_product_num p
        INNER JOIN dbo.Customers c
        ON p.CustomerID = c.CustomerID
        GROUP BY City
        HAVING COUNT(c.CustomerID) >= 2
    )
    SELECT City FROM cte_customer_num

GO

-- 12
-- Create triggers on one table fired by every event of 
-- insert, update, delete happened to the other table 

-- 14
CREATE FUNCTION AddDot 
(@mid_name VARCHAR)
RETURNS VARCHAR
BEGIN   -- Can NOT be ommitted
    IF @mid_name IS NOT NULL
        RETURN @mid_name + '.'
    RETURN @mid_name
END
GO

SELECT CONCAT([First Name], [Last Name], dbo.AddDot([Middle Name])) 'Full Name'
FROM sample_table
-- Need to use dbo.FuncName if not a built-in function

-- 15
SELECT TOP 1 Marks
FROM sample_table
WHERE SEX = 'F'
ORDER BY Marks DESC

SELECT Student, Marks, ROW_NUMBER() OVER(PARTITION BY Sex ORDER BY Marks DESC) 'MarkRank'
FROM sample_table
WHERE SEX = 'F' AND MarkRank = 1

-- 16
SELECT *
FROM sample_table
ORDER BY Sex ASC, Marks DESC

SELECT Student, Marks, Sex
FROM 
(SELECT Student, Marks, Sex, 
dense_RANK() OVER(ORDER BY Sex) 'SexRank'
ROW_NUMBER() OVER(PARTITION BY Sex ORDER BY Marks DESC) 'MarkRank'
FROM sample_table) rank
ORDER BY SexRank, MarkRank DESC