-- 1.      How many products can you find in the Production.Product table?

SELECT count(ProductID) as No_Of_Products from Production.Product; 

-- 2.      Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.

SELECT * FROM Production.Product WHERE ProductSubcategoryID is not NULL;

-- 3.      How many Products reside in each SubCategory? Write a query to display the results with the following titles.

-- ProductSubcategoryID CountedProducts

-- -------------------- ---------------

SELECT ProductSubcategoryID, count(ProductID) as CountedProducts from Production.Product where ProductSubcategoryID is not NULL GROUP BY ProductSubcategoryID ;


-- 4.      How many products that do not have a product subcategory.

SELECT count(ProductID) FROM Production.Product WHERE ProductSubcategoryID is NULL;

-- 5.      Write a query to list the sum of products quantity in the Production.ProductInventory table.

SELECT sum(Quantity) as Sum_Quantity from Production.ProductInventory;

-- 6.    Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.

--               ProductID    TheSum

--               -----------        ----------

SELECT  ProductID, sum(Quantity) as The_Sum from Production.ProductInventory where LocationID=40 GROUP BY ProductID having SUM(Quantity)<100;

-- 7.    Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100

--     Shelf      ProductID    TheSum

--     ----------   -----------        -----------

SELECT  Shelf, ProductID, sum(Quantity) as The_Sum from Production.ProductInventory where LocationID=40 GROUP BY Shelf, ProductID having SUM(Quantity)<100;

-- 8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.

SELECT ProductID,AVG(Quantity) Average from Production.ProductInventory where LocationID=10 GROUP BY ProductID;

-- 9.    Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory

--     ProductID   Shelf      TheAvg

--     ----------- ---------- -----------


SELECT ProductID, Shelf, AVG(Quantity) TheAvg from Production.ProductInventory GROUP BY ProductID, Shelf;



-- 10.  Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory

--     ProductID   Shelf      TheAvg

--     ----------- ---------- -----------

SELECT ProductID, Shelf, AVG(Quantity) TheAvg from Production.ProductInventory where not Shelf='N/A'  GROUP BY ProductID, Shelf;


-- 11.  List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.

--     Color                        Class              TheCount          AvgPrice

--     -------------- - -----    -----------            ---------------------

SELECT  Color, Class, COUNT(*) as TheCount, AVG(ListPrice) as AvgPrice from Production.Product WHERE Color IS NOT NULL AND Class IS NOT NULL GROUP BY Color, Class;


-- Joins:

-- 12.   Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.

--     Country                        Province

--     ---------                          ----------------------

SELECT p.Name as Country, s.Name as Province from Person.CountryRegion p JOIN Person.StateProvince s ON p.CountryRegionCode=s.CountryRegionCode;

-- 13.  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.

 

--     Country                        Province

--     ---------                          ----------------------

SELECT p.Name as Country, s.Name as Province from Person.CountryRegion p JOIN Person.StateProvince s ON p.CountryRegionCode=s.CountryRegionCode where p.Name in ('Germany', 'Canada');


--  Using Northwnd Database: (Use aliases for all the Joins)

-- 14.  List all Products that has been sold at least once in last 27 years.


SELECT ProductName from Products p join [Order Details] as d on p.ProductID=d.ProductID JOIN Orders o ON d.OrderID = o.OrderID WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE());;


-- 15.  List top 5 locations (Zip Code) where the products sold most.

SELECT Top 5 c.PostalCode, count(od.ProductID) as Total_sold from Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID join Customers c on o.CustomerID=c.CustomerID GROUP BY c.PostalCode ORDER BY Total_sold DESC;;

-- 16.  List top 5 locations (Zip Code) where the products sold most in last 27 years.

SELECT Top 5 c.PostalCode, count(od.ProductID) as Total_sold from Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID join Customers c on o.CustomerID=c.CustomerID where o.OrderDate>=DATEADD(YEAR, -27, GETDATE()) GROUP BY c.PostalCode ORDER BY Total_sold DESC;;

-- 17.   List all city names and number of customers in that city.    

SELECT City, count(CustomerID) as [No Of Customers] from Customers GROUP BY City;

-- 18.  List city names which have more than 2 customers, and number of customers in that city

SELECT City, count(CustomerID) as [No Of Customers] from Customers GROUP BY City HAVING COUNT(CustomerID) > 2; 

-- Using Nested Queries

SELECT City, [No Of Customers] from (SELECT City, count(CustomerID) as [No Of Customers] from Customers GROUP BY City) AS CityCounts WHERE [No Of Customers]>2;

-- 19.  List the names of customers who placed orders after 1/1/98 with order date.
SELECT c.ContactName, o.OrderDate FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID WHERE o.OrderDate > '1998-01-01 00:00:00.000';

-- 20.  List the names of all customers with most recent order dates

SELECT c.ContactName, o.OrderDate FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID where o.OrderDate = ( SELECT MAX(OrderDate) FROM Orders WHERE CustomerID = c.CustomerID);

-- 21.  Display the names of all customers  along with the  count of products they bought

SELECT c.ContactName, COUNT(distinct(od.ProductID)) as Count_Of_Products from Customers c join Orders o on c.CustomerID=o.CustomerID join [Order Details] od on o.OrderID=od.OrderID GROUP BY c.ContactName;

-- 22.  Display the customer ids who bought more than 100 Products with count of products.

SELECT c.CustomerID, COUNT(od.ProductID) from Customers c JOIN Orders o on c.CustomerID=o.CustomerID JOIN [Order Details] od ON o.OrderID=od.OrderID GROUP BY c.CustomerID having count(od.ProductID)>100

-- 23.  List all of the possible ways that suppliers can ship their products. Display the results as below

--     Supplier Company Name                Shipping Company Name

--     ---------------------------------            ----------------------------------

SELECT s.CompanyName AS [Supplier Company Name], sh.CompanyName AS [Shipping Company Name] FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID JOIN Shippers sh ON o.ShipVia = sh.ShipperID
GROUP BY s.CompanyName, sh.CompanyName;

-- 24.  Display the products order each day. Show Order date and Product Name.

SELECT o.OrderDate, p.ProductName FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
ORDER BY o.OrderDate;

-- 25.  Displays pairs of employees who have the same job title.

SELECT a.employeeID as [first employee], b.employeeID as [second employee] from employees a join employees b on a.employeeID > b.employeeID and a.Title=b.Title ;

-- 26.  Display all the Managers who have more than 2 employees reporting to them.

SELECT e1.EmployeeID AS ManagerID, COUNT(e2.EmployeeID) AS NumOfReports FROM Employees e1
JOIN Employees e2 ON e1.EmployeeID = e2.ReportsTo
GROUP BY e1.EmployeeID HAVING COUNT(e2.EmployeeID) > 2

-- 27.  Display the customers and suppliers by city. The results should have the following columns

SELECT c.City, c.ContactName AS Name, c.ContactName, 'Customer' AS Type FROM Customers c
UNION
SELECT s.City, s.CompanyName AS Name, s.ContactName, 'Supplier' AS Type FROM Suppliers s ORDER BY City, Type;
