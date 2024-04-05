-- Wybor kolumn

--1.1
select CompanyName, Address + ' ' + City + ' ' + PostalCode as Adres  from customers

--1.2
select Lastname, HomePhone from employees

--1.3
select ProductName, UnitPrice from Products

--1.4
select CategoryName, Description from Categories

--1.5
select CompanyName, HomePage from Suppliers