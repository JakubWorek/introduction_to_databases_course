--Sortowanie danych

--7.1
select CompanyName, Country
from Customers
order by 2,1

--7.2
select Categories.CategoryName, Products.ProductName, Products.UnitPrice
from Products
inner join Categories on Products.CategoryID = Categories.CategoryID
order by 1, 3 desc

--7.3
select CompanyName, Country
from Customers
where Country IN  ('Japan', 'Italy')
order by 2,1