use Northwind

-- 4.1 podzapytania
select OrderID,
       (select round(sum(quantity*unitprice*(1-discount)),2)
        from [Order Details] oo
        where o.OrderID = oo.OrderID
        )+ freight as sum
from orders o
where o.OrderID = 10250

-- 4.1 normalnie
select o.OrderID, round(sum(oo.quantity*oo.unitprice*(1-oo.discount)),2)
from orders o
inner join [Order Details] oo on o.OrderID = oo.OrderID
where o.OrderID = 10250
group by o.OrderID

-- 4.2 podzapytania
select oo.orderid, round(sum(unitprice*quantity*(1-discount)) +
    (select freight
     from orders o
     where o.OrderID=oo.OrderID),2)
from [Order Details] oo
group by orderid

-- 4.2 normalnie
select oo.orderid, round(sum(unitprice*quantity*(1-discount)) + freight , 2)
from [Order Details] oo
inner join Orders o on oo.OrderID = O.OrderID
group by oo.orderid, freight

-- 4.3 podzapytania
select address + ', ' + city as Adres, companyname
from customers c
where not exists(
    select *
    from orders o
    where o.CustomerID=c.CustomerID and year(o.orderdate)=1997
)

-- 4.3 normalnie
select address
from customers c
left join orders o on o.CustomerID=c.CustomerID and year(o.OrderDate)=1997
group by c.customerid, address
having count(o.customerID)=0

-- 4.4 podzapytania
select p.productid
from products p
where   (select count(distinct customerid)
        from orders o
	    inner join [Order Details] oo on oo.ProductID=p.ProductID and o.OrderID=oo.OrderID
		group by productid)>1

-- 4.4 normalnie
select oo.productid
from [Order Details] oo
inner join Orders o on o.OrderID=oo.OrderID
group by oo.productid
having count(distinct customerid)>1