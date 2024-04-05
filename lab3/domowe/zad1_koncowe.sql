use Northwind

--1.1
select oo.orderid, companyname, sum(quantity) as sum
from [Order Details] oo
inner join orders o on o.OrderID=oo.OrderID
inner join customers c on c.CustomerID=o.CustomerID
group by oo.orderid, companyname

--1.2
select oo.orderid, companyname, sum(quantity) as sum
from [Order Details] oo
inner join orders o on o.OrderID=oo.OrderID
inner join customers c on c.CustomerID=o.CustomerID
group by oo.orderid, companyname
having sum(Quantity) > 250

--1.3
select oo.orderid, companyname, round(sum(quantity*unitprice*(1-discount)),2) as 'value'
from [Order Details] oo
inner join orders o on o.OrderID=oo.OrderID
inner join customers c on c.CustomerID=o.CustomerID
group by oo.orderid, companyname
order by 3 desc

--1.4
select oo.orderid, companyname, round(sum(quantity*unitprice*(1-discount)),2) as value
from [Order Details] oo
inner join orders o on o.OrderID=oo.OrderID
inner join customers c on c.CustomerID=o.CustomerID
group by oo.orderid, companyname
having sum(quantity) > 250
order by 3 desc

--1.5
select oo.orderid,
       companyname,
       e.FirstName+ ' ' + e.LastName as pracownik,
       round(sum(quantity*unitprice*(1-discount)),2) as value,
       sum(quantity) as qntty
from [Order Details] oo
inner join orders o on o.OrderID=oo.OrderID
inner join customers c on c.CustomerID=o.CustomerID
inner join employees e on o.EmployeeID = e.EmployeeID
group by oo.orderid, companyname, e.FirstName+ ' ' + e.LastName
having sum(quantity) > 250
order by 4 desc