use Northwind

--2.1
select OrderID, MAX(UnitPrice) as MaxPrice
from [Order Details]
group by OrderID

--2.2
select OrderID, MAX(UnitPrice) as MaxPrice
from [Order Details]
group by OrderID
order by MaxPrice

--2.3
select OrderID,
       MIN(UnitPrice) as MinPrice,
       MAX(UnitPrice) as MaxPrice
from [Order Details]
group by OrderID

--2.4
select ShipVia, COUNT(*) as OrderCount
from Orders
group by ShipVia

--2.5
select top 1 ShipVia, COUNT(*) as OrdersCount
from Orders
where YEAR(ShippedDate) = 1997
group by ShipVia
order by COUNT(*) DESC