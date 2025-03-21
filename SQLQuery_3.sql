-- All scenarios are based on Database NORTHWIND.

-- 1.      List all cities that have both Employees and Customers.

SELECT DISTINCT e.City FROM Employees e JOIN Customers c ON e.City = c.City;

-- 2.      List all cities that have Customers but no Employee.

-- a.      Use sub-query

SELECT DISTINCT c.City FROM Customers c WHERE c.City NOT IN (SELECT DISTINCT City FROM Employees);

-- b.      Do not use sub-query

SELECT distinct c.City from Customers c left join Employees e on c.City=e.City where e.City is null; 

-- 3.      List all products and their total order quantities throughout all orders.

SELECT p.productName, sum(od.Quantity) as Total_quantity from Products p join [Order Details] od on p.ProductID=od.ProductID group by ProductName order by Total_quantity desc;

-- 4.      List all Customer Cities and total products ordered by that city.
-- SELECT * from [Order Details];

select c.City, sum(od.Quantity) as Total_ordered from customers c join orders o on c.CustomerID=o.CustomerID join [Order Details] od on o.OrderID=od.OrderID GROUP by c.City ORDER by Total_ordered desc;

-- 5.      List all Customer Cities that have at least two customers.

SELECT city, count(CustomerID) as No_of_customers from customers GROUP by city having count(CustomerID)>=2;

-- using inner query

SELECT c.City, c.ContactName FROM Customers c WHERE c.City IN (
    SELECT City FROM Customers GROUP BY City HAVING COUNT(CustomerID) >= 2
)
ORDER BY c.City;

-- 6.      List all Customer Cities that have ordered at least two different kinds of products.

SELECT c.City, count(distinct od.ProductID) as No_of_products_ordered from customers c join orders o on c.CustomerID=o.CustomerID join [Order Details] od
on o.OrderID=od.OrderID GROUP by c.City HAVING count(distinct od.ProductID)>=2 ORDER BY c.City;

-- 7.      List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.

select distinct c.ContactName, c.City AS CustomerCity, o.ShipCity AS OrderShipCity from customers c join orders o on c.CustomerID=o.CustomerID and c.City!=o.ShipCity;

-- 8.      List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

with popular_products_avg AS 
( select od.productID, sum(Quantity) as Num_of_products, AVG(p.UnitPrice) AS AvgPrice , c.City AS CustomerCity
from [Order Details] od join Products p on od.ProductID=p.ProductID JOIN Orders o ON od.OrderID = o.OrderID 
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY od.ProductID, c.City),
Most_product_city AS
(
  SELECT productID, CustomerCity, AvgPrice, Num_of_products,
   RANK() OVER (PARTITION BY productID ORDER BY Num_of_products DESC) AS Rank 
   from popular_products_avg
)
SELECT TOP 5 p.ProductName, mp.AvgPrice, mp.CustomerCity, mp.Num_of_products from 
Most_product_city mp join products p on mp.ProductID=p.ProductID 
where Rank=1 
ORDER BY mp.Num_of_products DESC;

-- 9.      List all cities that have never ordered something but we have employees there.

-- a.      Use sub-query

SELECT DISTINCT e.City FROM Employees e
WHERE e.City NOT IN (
    SELECT DISTINCT o.ShipCity FROM Orders o
)

-- b.      Do not use sub-query

SELECT DISTINCT e.City FROM Employees e LEFT JOIN Orders o ON e.City = o.ShipCity WHERE o.OrderID IS NULL;

-- 10.  List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)

WITH most_sold_order_employee AS (
    select e.City AS EmployeeCity, e.EmployeeID, COUNT(o.OrderID) AS no_of_Orders
    FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID 
    GROUP BY e.City, e.EmployeeID
),
most_quantiy_product_city  AS (
    select o.ShipCity AS City, SUM(od.Quantity) AS no_of_products
    FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY o.ShipCity
)
Select TOP 1 msoe.EmployeeCity, mqpc.City, msoe.no_of_Orders, mqpc.no_of_products
FROM most_sold_order_employee msoe
JOIN most_quantiy_product_city mqpc ON msoe.EmployeeCity = mqpc.City
ORDER BY msoe.no_of_Orders DESC, mqpc.no_of_products DESC;

-- SELECT TOP 1 eoc.EmployeeCity, ctp.City, eoc.TotalOrders, ctp.TotalQuantity
-- FROM EmployeeOrderCity eoc
-- JOIN CityTotalProductQuantity ctp ON eoc.EmployeeCity = ctp.City

-- 11. How do you remove the duplicates record of a table?

-- WITH CTE AS 
-- (SELECT *, ROW_NUMBER() OVER (PARTITION BY column1, column2, column3 ,... ORDER BY (SELECT NULL)) as rank FROM table_name
-- )
-- delete FROM CTE WHERE rank > 1;
