use Northwind

--2.1
select ProductID, sum(Quantity) as Count
from [Order Details]
where ProductID < 3
group by ProductID

--2.2
select ProductID, sum(Quantity) as Count
from [Order Details]
group by ProductID

--2.3
select OrderID,
       sum(convert(money, Quantity * UnitPrice * (1 - Discount))) as Total,
       sum(Quantity) as Qntt
from [Order Details]
group by OrderID
having sum(Quantity) > 250
order by Total desc