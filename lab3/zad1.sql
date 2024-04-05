use Northwind

--1.1
select ProductName, UnitPrice
from Products
inner join Suppliers
on Products.SupplierID = Suppliers.SupplierID
where UnitPrice between 20 and 30
order by UnitPrice desc

--1.2
select ProductName, UnitsInStock
from Products
inner join Suppliers
on Products.SupplierID = Suppliers.SupplierID
where CompanyName = 'Tokyo Traders'

--1.3
select Customers.CustomerID, Address
from Customers
left outer join Orders
on Customers.CustomerID = Orders.CustomerID
and year(OrderDate)=1997
where OrderID is null

--1.4
select CompanyName, Phone from Suppliers
inner join Products
on Suppliers.SupplierID = Products.SupplierID
where isnull(UnitsInStock, 0)=0



use library
--1.5
select firstname, lastname, birth_date
from juvenile
inner join member
on juvenile.member_no = member.member_no

--1.6
select distinct title
from title
inner join loan
on title.title_no = loan.title_no

--1.7
select title, in_date, due_date, fine_paid, fine_assessed, datediff(day, in_date,due_date) as DateDiff
from loanhist
inner join title
on loanhist.title_no = title.title_no
where title like 'Tao Teh King' and in_date > due_date

--1.8
select isbn, firstname, middleinitial, lastname
from reservation
inner join member
on reservation.member_no = member.member_no
where firstname like 'Stephen' and lastname like 'Graff' and middleinitial like 'A'