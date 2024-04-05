use Northwind

--2.1
select categoryname, sum(quantity) as sum
from categories c
inner join products p on p.CategoryID=c.CategoryID
inner join [Order Details] oo on oo.ProductID=p.ProductID
group by categoryname
order by 2 desc

--2.2
select categoryname, round(sum(quantity*oo.unitprice*(1-discount)),2) as value
from categories c
inner join products p on p.CategoryID=c.CategoryID
inner join [Order Details] oo on oo.ProductID=p.ProductID
group by categoryname
order by 2 desc

--2.3.1
select categoryname, round(sum(quantity*oo.unitprice*(1-discount)),2) as value, sum(quantity) as sum
from categories c
inner join products p on p.CategoryID=c.CategoryID
inner join [Order Details] oo on oo.ProductID=p.ProductID
group by categoryname
order by 2 desc

--2.3.2
select categoryname, round(sum(quantity*oo.unitprice*(1-discount)),2) as value, sum(quantity) as sum
from categories c
inner join products p on p.CategoryID=c.CategoryID
inner join [Order Details] oo on oo.ProductID=p.ProductID
group by categoryname
order by 3 desc

--2.4
select oo.OrderID, round(sum(quantity*oo.unitprice*(1-discount))+o.Freight,2) as value
from [Order Details] oo
inner join orders o on oo.OrderID = o.OrderID
group by oo.OrderID, o.Freight
order by 2 desc