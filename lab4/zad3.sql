use Northwind

-- 3.1 podzapytania
select productid, productname, unitprice,
(select avg(unitprice)
 from products) as 'AVG',
unitprice -(select avg(unitprice)
            from products) as diff
from products p

-- 3.1 normalnie
select p.productid, p.productname, p.unitprice,
       avg(pp.unitprice) as 'AVG', p.unitprice-avg(pp.unitprice) as diff
from products p
cross join products pp
group by p.productid, p.productname, p.UnitPrice
having p.unitprice<avg(pp.unitprice)

-- 3.2 podzapytania
select  productid,
        productname,
        (select c.categoryname
        from Categories c
        where c.CategoryID=p.CategoryID) as 'Category name',
        unitprice,
        (select avg(unitprice)
         from products
         where categoryid=p.CategoryID) as 'AVG',
        unitprice -(select avg(unitprice)
                    from products
                    where categoryid=p.CategoryID) as diff
from products p

-- 3.2 normalnie
select  p.productid, p.productname, c.CategoryName,
        p.unitprice, avg(pp.unitprice) as 'AVG',
        p.unitprice-avg(pp.unitprice) as diff
from products p
inner join products pp on pp.CategoryID=p.CategoryID
inner join categories c on c.CategoryID=p.CategoryID
group by p.productid, p.productname, p.UnitPrice, c.CategoryName