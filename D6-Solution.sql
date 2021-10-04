-- 1.	What is an object in SQL?
-- A database object in a relational database is a data structure used to 
-- either store or reference data. 
-- The most common object that people interact with is the table. 
-- Other objects are schemas, journals, catalogs, aliases, views, 
-- indexes, constraints, triggers, sequences, stored procedures, user-defined functions, 
-- user-defined types, global variables, and SQL packages. 
-- SQL creates and maintains these objects as system objects.

-- 2.	What is Index? What are the advantages and disadvantages of using Indexes?
-- Indexes are database objects based on table column for faster retrieval of data
-- Query optimizer depends on indexed columns to function
-- Separate structure attached to a table
-- Contain pointers to the physical data
-- Used to 
-- To quickly find data that satisfy conditions in the WHERE clause.
-- To find matching rows in the JOIN clause.
-- To maintain uniqueness of key column during INSERT and UPDATE.
-- To Sort, Aggregate and Group data.

-- 3.	What are the types of Indexes?
-- Clustered and non-clustered

-- 4.	Does SQL Server automatically create indexes when a table is created? If yes, under which constraints?
-- Primary Key by default will create clustered index.

-- 5.	Can a table have multiple clustered index? Why?
-- Only 1 is allowed.

-- 6.	Can an index be created on multiple columns? Is yes, is the order of columns matter?
-- A multiple-column index can be considered a sorted array, the rows of which contain values 
-- that are created by concatenating the values of the indexed columns.
-- Column order is very important.
-- The second column in a multicolumn index can never be accessed without accessing the first column as well.

-- 7.	Can indexes be created on views?
-- Yes. Indexed views.

-- 8.	What is normalization? What are the steps (normal forms) to achieve normalization?
-- Normalization is a database design technique that reduces data redundancy and eliminates undesirable 
-- characteristics like Insertion, Update and Deletion Anomalies. Normalization rules divides larger 
-- tables into smaller tables and links them using relationships. The purpose of Normalisation in SQL
-- is to eliminate redundant (repetitive) data and ensure data is stored logically.
-- 1NF, 2NF, 3NF.

-- 9.	What is denormalization and under which scenarios can it be preferable?
-- Denormalization is the process of adding precomputed redundant data to an otherwise 
-- normalized relational database to improve read performance of the database.
-- Denormalization can improve performance by: Minimizing the need for joins. 
-- Precomputing aggregate values, that is, computing them at data modification time, 
-- rather than at select time. Reducing the number of tables, in some cases.

-- 10.	How do you achieve Data Integrity in SQL Server?
-- Data integrity is usually imposed during the database design phase through 
-- the use of standard procedures and rules. It is maintained through the use of 
-- various error-checking methods and validation procedures.

-- 11.	What are the different kinds of constraint do SQL Server have?
-- Not Null Constraint.
-- Check Constraint.
-- Default Constraint.
-- Unique Constraint.
-- Primary Constraint.
-- Foreign Constraint.

-- 12.	What is the difference between Primary Key and Unique Key?
	-- UNIQUE constraint allows 1 NULL value but PK doesn’t allow any NULL value.
	-- A table can have multiple UNIQUE constraints but only 1 PK is allowed per table.
	-- PK will sort the data in ascending order by default, UNIQUE will not sort.
	-- PK will create clustered index but UNIQUE key creates non clustered index automatically implicitly.

-- 13.	What is foreign key?
-- A foreign key is a column (or combination of columns) in a table whose values must match values 
-- of a column in some other table. FOREIGN KEY constraints enforce referential integrity, which 
-- essentially says that if column value A refers to column value B, then column value B must exist.

-- 14.	Can a table have multiple foreign keys?
-- Yes.

-- 15.	Does a foreign key have to be unique? Can it be null?
-- Does not to be unique. Can be null.

-- 16.	Can we create indexes on Table Variables or Temporary Tables?
-- Can't create indexes on Table Variables.
-- Can add either a clustered or non clustered index to Temporary Table.  The index is also temporary.

-- 17.	What is Transaction? What types of transaction levels are there in SQL Server?
-- A transaction is a sequence of operations performed (using one or more SQL statements) 
-- on a database as a single logical unit of work. The effects of all the SQL statements 
-- in a transaction can be either all committed (applied to the database) 
-- or all rolled back (undone from the database).
-- READ UNCOMMITTED , READ COMMITTED , REPEATABLE READ , and SERIALIZABLE .

-- Query Questions
-- 1
CREATE TABLE customer
(
    cust_id INT PRIMARY KEY IDENTITY(1,1),
    iname VARCHAR(50) NOT NULL
)

CREATE TABLE [order]    -- Need to use [] around order because it's a keywork of SQL
(
    order_id INT PRIMARY KEY IDENTITY(1,1),
    cust_id INT FOREIGN KEY REFERENCES customer(cust_id),
    amount MONEY NOT NULL,
    order_date SMALLDATETIME NOT NULL
)

SELECT iname, order_totals
FROM customer c
INNER JOIN
(SELECT c.cust_id, SUM(amount) 'order_totals'
FROM customer c
INNER JOIN [order] o
ON c.cust_id = o.cust_id
WHERE YEAR(o.order_date) = 2002
GROUP BY c.cust_id) co
ON c.cust_id = co.cust_id

-- 2
CREATE TABLE person
(
    id INT PRIMARY KEY IDENTITY(1,1),
    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL
)

SELECT *
FROM person
WHERE lastname LIKE 'A%'

-- 3
CREATE TABLE person
(
    person_id INT PRIMARY KEY, 
    manager_id INT NULL, 
    name VARCHAR(100) NOT NULL
) 

SELECT p.name, m.employee_num
FROM person p
INNER JOIN
(SELECT e.manager_id, COUNT(1) employee_num
FROM person e
GROUP BY e.manager_id) m
ON p.person_id = m.manager_id
WHERE p.manager_id IS NULL

-- 4
-- A triggering event or statement is the SQL statement, database event, 
-- or user event that causes a trigger to fire. 
-- A triggering event can be one or more of the following:

-- An INSERT, UPDATE, or DELETE statement on a specific table (or view, in some cases)
-- A CREATE, ALTER, or DROP statement on any schema object
-- A database startup or instance shutdown
-- A specific error message or any error message
-- A user logon or logoff

-- 5
CREATE TABLE Companies
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(45) NOT NULL
)

CREATE TABLE [Address]
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    Address VARCHAR(200) NOT NULL UNIQUE
)

CREATE TABLE Contacts
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(45) NOT NULL,
    Suite VARCHAR(20) NOT NULL,
    AddressID INT FOREIGN KEY REFERENCES [Address](ID)
    CONSTRAINT
    un UNIQUE (Suite, AddressID)    -- Must have a constraint name
)

CREATE TABLE Divisions
(
    Name VARCHAR(45) NOT NULL,
    CompanyID INT NOT NULL FOREIGN KEY REFERENCES Companies(ID),
    AddressID INT FOREIGN KEY REFERENCES [Address](ID),
    ContactID INT FOREIGN KEY REFERENCES Contacts(ID),
    CONSTRAINT
    comp_pk PRIMARY KEY (Name, CompanyID)
)