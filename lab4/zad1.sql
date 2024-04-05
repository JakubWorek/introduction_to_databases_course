use Northwind

-- 1.1 podzapytania
select companyname, phone
from customers
where exists
    (select *
     from orders
     where orders.CustomerID=customers.CustomerID and year(orders.ShippedDate)=1997
and orders.ShipVia=
    (select shipperid
     from shippers
     where CompanyName='United Package'))

-- 1.1 normalnie
select distinct c.companyname, c.phone
from customers c
inner join orders o on o.CustomerID=c.CustomerID and year(o.shippeddate)=1997
inner join Shippers s on s.ShipperID=o.ShipVia and s.CompanyName='United Package'

-- 1.2 podzapytania
select companyname, phone
from customers c
where exists
(select *
 from orders o
 where o.CustomerID=c.CustomerID and exists
	(select *
	 from [Order Details] oo
	 where oo.OrderID=o.OrderID and exists
		(select *
		 from products p
		 where p.ProductID=oo.ProductID and exists
			(select *
			 from categories cc
			 where cc.CategoryID=p.CategoryID and categoryname='Confections'))))

-- 1.2 normalnie
select distinct c.companyname, c.phone
from customers c
inner join orders o on o.CustomerID=c.CustomerID
inner join [Order Details] oo on oo.OrderID=o.OrderID
inner join Products p on p.ProductID=oo.ProductID
inner join categories cc on cc.CategoryID=p.CategoryID
where categoryname='Confections'

-- 1.3 podzapytania
select companyname, phone
from customers c
where not exists
(select *
 from orders o
 where o.CustomerID=c.CustomerID and exists
	(select *
	 from [Order Details] oo
	 where oo.OrderID=o.OrderID and exists
		(select *
		 from products p
		 where p.ProductID=oo.ProductID and exists
			(select *
			 from categories cc
			 where cc.CategoryID=p.CategoryID and categoryname='Confections'))))

-- 1.3 normalnie
select distinct c.companyname, c.phone
from customers c
left join orders o on o.CustomerID=c.CustomerID
left join [Order Details] oo on oo.OrderID=o.OrderID
left join Products p on p.ProductID=oo.ProductID
left join categories cc on cc.CategoryID=p.CategoryID and categoryname='Confections'
group by c.CustomerID, c.CompanyName, c.Phone
having count(cc.categoryid)=0