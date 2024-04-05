use Northwind

--1.1
select COUNT(*) as "Liczba produktow"
from Products
where unitprice not between 10 and 20

--1.2
select MAX(UnitPrice) as "Max cena < 20"
from Products
where UnitPrice < 20

--1.3
select MIN(UnitPrice) as Min,
       AVG(UnitPrice) as Avg,
       MAX(UnitPrice) as Max
from Products
where QuantityPerUnit like '%bottle%'

--1.4
select *
from Products
where UnitPrice > (select AVG(UnitPrice) from Products)

--1.5
select SUM(CONVERT(money, Quantity*UnitPrice*(1-Discount))) as Total
from [Order Details]
where OrderID = 10250