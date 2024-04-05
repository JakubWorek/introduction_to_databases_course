-- Porownywanie stringow

--3.1
select *
from Products
where QuantityPerUnit like '%bottle%'

--3.2
select FirstName, LastName, Title
from Employees
where LastName like '[B-L]%'

--3.3
select FirstName, LastName, Title
from Employees
where LastName like '[BL]%'

--3.4
select CategoryName, Description
from Categories
where Description like '%,%'

--3.5
select CompanyName, ContactName, Address
from Customers
where Customers.CompanyName like '%Store%'