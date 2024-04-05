use Northwind

--1.1
select OrderID, sum(convert(money, Quantity * UnitPrice * (1 - Discount))) as Total
from [Order Details]
group by OrderID
order by Total desc

--1.2
select top 10 OrderID, sum(convert(money, Quantity * UnitPrice * (1 - Discount))) as Total
from [Order Details]
group by OrderID
order by Total desc