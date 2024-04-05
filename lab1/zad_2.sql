-- Wybor wierszy

--2.1
select CompanyName, Address + ' ' + City + ' ' + PostalCode as Adres
from Customers
where City = 'London'

--2.2
select CompanyName, Address + ' ' + City + ' ' + PostalCode as Adres
from Customers
where Country = 'France' or Country = 'Spain'

--2.3
select ProductName, UnitPrice
from Products
where UnitPrice >= 20 and UnitPrice <= 30

--2.4
select ProductName, UnitPrice
from Products
inner join Categories on Products.CategoryID = Categories.CategoryID
where Categories.CategoryName like '%Meat%'

--2.5
select ProductName, UnitsInStock, Suppliers.CompanyName
from Products
inner join Suppliers on Products.SupplierID = Suppliers.SupplierID
where Suppliers.CompanyName = 'Tokyo Traders'

--2.6
select ProductName, UnitsInStock
from Products
where UnitsInStock = 0