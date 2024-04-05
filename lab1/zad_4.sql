-- Zakres wartosci

--4.1
select *
from products
where unitprice not between 10 and 20

--4.2
select ProductName, UnitPrice
from Products
where UnitPrice between 20 and 30