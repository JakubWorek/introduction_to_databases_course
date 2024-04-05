use Northwind

-- 2.1 podzapytania
select distinct productid, quantity
from [order details] as ord1
where quantity = ( select MAX(quantity)
                    from [order details] as ord2
                    where ord1.productid = ord2.productid )
order by 1

-- 2.1 normalnie
select productid, max(quantity)
from [order details]
group by productid
order by productid

-- 2.2 podzapytania
select productid, productname
from products p
where unitprice<(select avg(unitprice)
                 from products)

-- 2.2 normalnie
select p.productid, p.productname
from products p
cross join products pp
group by p.productid, p.productname, p.UnitPrice
having p.unitprice<avg(pp.unitprice)

-- 2.3 podzapytania
select productid, productname
from products p
where unitprice<(select avg(unitprice)
                 from products
                 where CategoryID=p.CategoryID)

-- 2.3 normalnie
select p.productid, p.productname
from products p
inner join products pp on pp.CategoryID=p.CategoryID
group by p.productid, p.productname, p.UnitPrice
having p.unitprice<avg(pp.unitprice)