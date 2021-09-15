USE AdventureWorks2019

SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product

SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product
WHERE ListPrice = 0

SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product
WHERE Color IS NULL

SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product
WHERE Color IS NOT NULL

SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product
WHERE Color IS NOT NULL
AND ListPrice > 0

SELECT CONCAT(Name, ' ', Color) AS 'Name Color'
FROM Production.Product
WHERE Color IS NOT NULL

SELECT CONCAT('NAME:', Name, ' -- COLOR: ', Color) AS 'Name And Color'
FROM Production.Product

SELECT ProductID, Name
FROM Production.Product
WHERE ProductID BETWEEN 400 AND 500

SELECT ProductID, Name, Color 
FROM Production.Product
WHERE Color IN ('black', 'blue')

SELECT *
FROM Production.Product
WHERE Name LIKE 's%'

SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE 'S%'
ORDER BY Name

SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE '[A, S]%'
ORDER BY Name

SELECT *
FROM Production.Product
WHERE Name LIKE 'SPO[^K]%'
ORDER BY Name

SELECT DISTINCT(Color)
FROM Production.Product
ORDER BY Color DESC

SELECT DISTINCT(CONCAT(ProductSubcategoryID, ' ', Color))
FROM Production.Product
WHERE NOT (ProductSubcategoryID IS NULL OR Color IS NULL)

SELECT ProductSubCategoryID
      , LEFT([Name],35) AS [Name]
      , Color, ListPrice 
FROM Production.Product
WHERE NOT (Color IN ('Red','Black') 
      AND ListPrice NOT BETWEEN 1000 AND 2000 
      AND ProductSubCategoryID = 1)
ORDER BY ProductID

SELECT p.ProductSubcategoryID, p.Name, p.Color, p.ListPrice
FROM Production.Product AS p
WHERE p.ProductSubcategoryID = 14 AND p.ListPrice > 1000 AND (p.Name LIKE '%Red%' OR p.Name LIKE '%58')
    OR p.ProductSubcategoryID = 12 AND p.Color = 'Silver' AND p.ListPrice > 1300
    OR p.ProductSubcategoryID = 2 AND p.Color = 'Yellow' AND p.ListPrice > 1500
    OR p.ProductSubcategoryID = 1 AND p.Color = 'Black' AND p.ListPrice < 1000
ORDER BY p.ProductSubcategoryID DESC
