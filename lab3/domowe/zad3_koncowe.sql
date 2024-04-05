use Northwind

--3.1
select s.CompanyName, count(o.orderid) as 'orders done in 1997'
from shippers as s
inner join Orders o on o.ShipVia=s.ShipperID
where year(o.shippeddate)=1997
group by s.ShipperID, s.CompanyName
order by 2 desc

--3.2
select top 1 s.CompanyName, count(o.orderid) as 'orders done in 1997'
from shippers as s
inner join Orders o on o.ShipVia=s.ShipperID
where year(o.shippeddate)=1997
group by s.ShipperID, s.CompanyName
order by 2 desc

--3.3
select firstname, lastname, round(sum(oo.quantity*oo.unitprice*(1-discount)),2) as value
from employees e
inner join orders o on o.EmployeeID=e.EmployeeID
inner join dbo.[Order Details] oo on o.OrderID = oo.OrderID
group by e.EmployeeID, firstname, lastname
order by count(o.orderid) desc

--3.4
select top 1 firstname, lastname, count(o.orderid) as count
from employees e
inner join orders o on o.EmployeeID=e.EmployeeID
where year(o.ShippedDate)=1997
group by e.EmployeeID, firstname, lastname
order by count(o.orderid) desc

--3.5
select top 1 firstname, lastname, round(sum(oo.quantity*oo.unitprice*(1-discount)),2) as value
from employees e
inner join orders o on o.EmployeeID=e.EmployeeID
inner join dbo.[Order Details] oo on o.OrderID = oo.OrderID
where year(o.ShippedDate)=1997
group by e.EmployeeID, firstname, lastname
order by round(sum(oo.quantity*oo.unitprice*(1-discount)),2) desc