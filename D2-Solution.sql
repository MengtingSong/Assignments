-- An SQL result set is a set of rows from a database as the output of a query, 
-- as well as metadata about the query such as the column names, 
-- and the types and sizes of each column.

-- UNION ALL keeps all of the records from each of the original data sets, UNION removes any duplicate records. 
-- UNION will perform a sorting operation on the first column in the first SELECT statement 
-- before finally returning the combined data set.
-- UNION can NOT be used inside a recursive CTE but UNION ALL can be used.

-- INTERSECT - Returns only the common records obtained from two or more SELECT statements.
-- EXCEPT - Returns only those records which are in the first query but not in the second query.

-- JOIN combines data from many tables based on a matched condition between them. It combines data into new columns.
-- UNION combines the result-set of two or more SELECT statements. It combines data into new rows.

-- INNER JOIN returns only the matching rows between both the tables, non-matching rows are eliminated. 
-- FULL JOIN returns all rows from both the tables and fill in NULLs for missing matches on either side,
-- including non-matching rows from both the tables.

-- LEFT JOIN retrieves all the rows from both the tables that satisfy the join condition, 
-- along with the unmatched rows of the left table, and columns of the table on the right is null padded. 
-- OUTER JOIN is classified into 3 types: LEFT JOIN, RIGHT JOIN, and FULL JOIN. 

-- A CROSS JOIN is a type of join that returns the Cartesian product of rows from the tables in the join. 
-- In other words, it combines each row from the first table with each row from the second table.

-- WHERE is used to filter records before any groupings take place. 
-- HAVING is used to filter values after they have been groups. 
-- Only columns or expressions in the group can be included in the HAVING clause's conditions

-- YES. A GROUP BY clause can contain two or more columns.

USE AdventureWorks2019
GO

-- 1 
SELECT COUNT(DISTINCT Name)
FROM Production.Product
-- 504

-- 2
SELECT COUNT(1) AS CountedProducts
    , p.ProductSubcategoryID
FROM Production.Product AS p
WHERE p.ProductSubcategoryID IS NOT NULL
GROUP BY p.ProductSubcategoryID

-- 3
SELECT p.ProductSubcategoryID
    , COUNT(DISTINCT Name) AS CountedProducts
FROM Production.Product AS p
WHERE p.ProductSubcategoryID IS NOT NULL
GROUP BY p.ProductSubcategoryID

-- 4
SELECT COUNT(DISTINCT Name)
FROM Production.Product AS p
WHERE p.ProductSubcategoryID IS NULL
-- 209

-- 5
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
GROUP BY ProductID

-- 6
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100

-- 7
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100

-- 8
SELECT AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE LocationID = 10

-- 9
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf
ORDER BY ProductID

-- 10
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID, Shelf
ORDER BY ProductID

-- 11
SELECT Color, Class 
    , COUNT(1) AS TheCount
    , AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE NOT (Color IS NULL OR Class IS NULL)
GROUP BY Color, Class

-- 12
SELECT c.Name AS Country, s.Name AS Province
FROM person.CountryRegion AS c 
INNER JOIN person.StateProvince AS s 
ON c.CountryRegionCode = s.CountryRegionCode

-- 13
SELECT c.Name AS Country, s.Name AS Province
FROM person.CountryRegion AS c 
INNER JOIN person.StateProvince AS s 
ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany', 'Canada')
ORDER BY c.Name

USE Northwind
GO

-- 14
SELECT ProductName 
FROM dbo.[Order Details] AS od
INNER JOIN dbo.Orders AS o
ON od.OrderID = o.OrderID
INNER JOIN dbo.Products AS p 
ON p.ProductID = od.ProductID
WHERE DATEDIFF(year, o.OrderDate, GETDATE()) >= 25
GROUP BY ProductName

-- 15
SELECT TOP 5 ShipPostalCode, SUM(Quantity) AS SoldQuanty
FROM dbo.Orders AS o 
INNER JOIN dbo.[Order Details] AS od 
ON o.OrderID = od.OrderID
GROUP BY ShipPostalCode
ORDER BY SUM(Quantity) DESC

-- 16
SELECT TOP 5 ShipPostalCode, SUM(Quantity) AS SoldQuanty
FROM dbo.Orders AS o 
INNER JOIN dbo.[Order Details] AS od 
ON o.OrderID = od.OrderID
WHERE DATEDIFF(year, o.OrderDate, GETDATE()) <= 20
GROUP BY ShipPostalCode
ORDER BY SUM(Quantity) DESC

-- 17
SELECT City, COUNT(DISTINCT CustomerID) AS CustomerNumber
FROM dbo.Customers
GROUP BY City

-- 18
SELECT City, COUNT(CustomerID) AS CustomerNumber
FROM dbo.Customers
GROUP BY City
HAVING COUNT(CustomerID) > 10

-- 19
SELECT c.ContactName, o.OrderDate
FROM dbo.Customers AS c 
INNER JOIN dbo.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > CONVERT(datetime, '1998-01-01')

-- 20
SELECT c.ContactName, MAX(o.OrderDate) AS RecentOrderDate
FROM dbo.Customers AS c 
INNER JOIN dbo.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName

-- 21
SELECT c.CustomerID, c.ContactName, COUNT(od.Quantity) AS CountOfProducts
FROM dbo.Customers AS c 
INNER JOIN dbo.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN dbo.[Order Details] AS od 
ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.ContactName

-- 22
SELECT c.CustomerID, COUNT(od.Quantity) AS CountOfProducts
FROM dbo.Customers AS c 
INNER JOIN dbo.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN dbo.[Order Details] AS od 
ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING COUNT(od.Quantity) > 100

-- 23
SELECT su.CompanyName AS [Supplier Company Name]
    , sh.CompanyName AS [Shipping Company Name]
FROM dbo.Suppliers AS su
CROSS JOIN dbo.Shippers AS sh

-- 24
SELECT o.OrderDate, p.ProductName
FROM dbo.Products AS p
INNER JOIN dbo.[Order Details] AS od
ON p.ProductID = od.ProductID
INNER JOIN dbo.[Orders] AS o
ON od.OrderID = od.OrderID

-- 25
SELECT CONCAT(l.FirstName, ' ', l.LastName) AS EmployeeName
    , CONCAT(r.FirstName, ' ', r.LastName) AS EmployeeName
FROM dbo.Employees AS l
INNER JOIN dbo.Employees AS r
ON l.Title = r.Title AND l.EmployeeID < r.EmployeeID

-- 26
-- CONCAT(...) is also a column that should be included in GROUP BY clause
SELECT e.ReportsTo AS ManagerID
    , CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName
    , COUNT(e.EmployeeID) AS EmployeeNumber
FROM dbo.Employees AS e
INNER JOIN dbo.Employees AS m
ON e.ReportsTo = m.EmployeeID
GROUP BY e.ReportsTo, CONCAT(m.FirstName, ' ', m.LastName) 
HAVING COUNT(e.EmployeeID) > 2


-- 27
SELECT City
    , ContactName
    , 'Customer' AS Type
FROM dbo.Customers
UNION ALL
SELECT City
    , ContactName
    , 'Suppliers' AS Type
from dbo.Suppliers

-- 28
SELECT *
FROM T1
INNER JOIN T2
ON F1.T1 = F2.T2

-- Result:
F1.T1	F2.T2
2	    2
3	    3

-- 29
SELECT *
FROM T1
LEFT JOIN T2
ON F1.T1 = F2.T2

F1.T1	F2.T2
1       NULL
2	    2
3	    3

