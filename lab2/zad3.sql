use Northwind

--3.1
select OrderID, count(*)
from [Order Details]
group by OrderID
having COUNT(*) > 5

--sprawdzenie
select * from [Order Details] where OrderID=11077

--3.2
select CustomerID, count(*)
from Orders
where YEAR(ShippedDate) = 1998
group by CustomerID
having COUNT(*) > 8
order by SUM(Freight) DESC