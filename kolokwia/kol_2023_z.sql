-- podaj listę dzieci, które oddały książkę
-- "Last of the Mohicans" w dniu 2001-10-07
use library
select m.member_no, m.firstname, m.lastname, t.title, l.in_date
from member m
inner join juvenile j on m.member_no = j.member_no
inner join loanhist l on j.member_no = l.member_no
inner join title t on l.title_no = t.title_no
where title = 'Last of the Mohicans' and
      year(in_date) = 2001 and month(in_date) = 10 and day(in_date) = 7
-- podaj listę dzieci, które oddały książkę "Walking" w dniu 2001-12-14
use library
select jm.firstname, jm.lastname, jm.member_no
from juvenile as j
join member as jm on j.member_no = jm.member_no
join loanhist as lh on lh.member_no = jm.member_no and
title_no = (select title_no from title where title = 'Walking')
and year(in_date) = 2001 and month(in_date) = 12 and day(in_date) = 14


-- podaj łączną liczbę i wartość obsłużonych przez wszystkich pracowników
-- w lutym 1997 roku (pamiętając o opłacie za przesyłkę), wyświetl także
-- pracowników, którzy nie obsłużyli żadnego zamówienia w tym miesiącu
use Northwind
select e.FirstName, e.LastName, e.EmployeeID,
        isnull(round(sum(o.Freight) + (
            select round(sum(od.UnitPrice * od.Quantity * (1 - od.Discount)),2)
            from Orders o
            inner join [Order Details] od on o.OrderID = od.OrderID
            where year(o.OrderDate) = 1997 and month(o.OrderDate) = 2
                and o.EmployeeID = e.EmployeeID
            ),2), 0) as price,
        count(o.OrderID) as count
from Employees e
left join Orders o on e.EmployeeID = o.EmployeeID and year(o.OrderDate) = 1997 and month(o.OrderDate) = 2
group by e.FirstName, e.LastName, e.EmployeeID


-- podaj kategorie, która zarobiła w 1997 roku najwięcej pieniędzy
-- podziel zarobki na miesiące
use Northwind;
with table1 as (
    select  categoryid,
            month(orderdate) as 'months',
            sum(od.unitprice * od.quantity * (1 - od.discount)) as 'price'
    from orders o
    inner join [order details] od on o.orderid = od.orderid
    inner join products p on od.productid = p.productid
    where year(o.orderdate) = 1997
    group by categoryid, month(orderdate)
)
select CategoryName, months, price
from table1 t1
inner join categories c on t1.categoryid = c.categoryid
where price = (
    select max(price)
    from table1 t2
    where t1.months = t2.months
    group by months
    )
order by months
-- podaj kategorie, która zarobiła w 1997 roku najwięcej pieniędzy
-- podziel zarobki tej kategorii na miesiące
use Northwind;
with table1 as (
    select  top 1 categoryid,
            sum(od.unitprice * od.quantity * (1 - od.discount)) as 'price'
    from orders o
    inner join [order details] od on o.orderid = od.orderid
    inner join products p on od.productid = p.productid
    where year(o.orderdate) = 1997
    group by categoryid
    order by price desc
)
select CategoryName, pricee, months
from table1 t1
inner join categories c on t1.categoryid = c.categoryid
inner join (
    select  categoryid,
            month(orderdate) as 'months',
            sum(od.unitprice * od.quantity * (1 - od.discount)) as 'pricee'
    from orders o
    inner join [order details] od on o.orderid = od.orderid
    inner join products p on od.productid = p.productid
    where year(o.orderdate) = 1997
    group by categoryid, month(orderdate)
) t2 on t1.categoryid = t2.categoryid
order by months
-- podaj kategorie, która zarobiła w 1997 roku najwięcej pieniędzy
-- podziel zarobki tej kategorii na miesiące
use Northwind;
select categoryname,
       year(orderdate) as rok,
       month(orderdate) as miesiac,
       round(sum(od.unitprice*quantity*(1-discount)), 2) as przychod
from Categories as c join products as p on c.CategoryID = p.CategoryID
and c.CategoryID = (
    select top 1 categoryid
    from Products as p
    join [Order Details] as od on p.ProductID = od.ProductID
    join orders as o on od.OrderID = o.OrderID and year(OrderDate) = 1997
    group by categoryid
    order by sum(od.unitprice*quantity*(1-discount)) desc)
join [Order Details] as od on p.ProductID = od.ProductID
join orders as o on od.OrderID = o.OrderID and year(OrderDate) = 1997
group by categoryname, year(orderdate), month(orderdate)


-- podaj nazwy produktów, które odnotowały niezerowy przychód w 1996 roku
use Northwind;
select distinct p.ProductName
from Products p
inner join [Order Details] od on p.ProductID = od.ProductID
inner join Orders o on od.OrderID = o.OrderID
where year(o.OrderDate) = 1996
group by p.ProductName
having sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) > 0


-- podaj tytuły książek, które zostały wypożyczone przez więcej niż jednego czytelnika,
-- który posiada dzieci,
-- podaj imie i nazwisko tych czytelników
use library
select t.title, m.firstname, m.lastname
from title t
inner join loanhist l on t.title_no = l.title_no
inner join juvenile j on l.member_no = j.member_no
inner join member m on j.member_no = m.member_no
where t.title_no in (
        select title_no
        from loanhist
        group by title_no
        having count(member_no) > 1
    )
    and j.adult_member_no in (
        select adult_member_no
        from juvenile
    )


-- podaj wszystkie zamówienia dla których opłata za przesyłkę
-- jest większa od średniej opłaty za przesyłkę w danym roku
use Northwind
select OrderID, Freight, year(OrderDate) as 'year', 'avg' = (
    select avg(Freight)
    from Orders o2
    where year(o.OrderDate) = year(o2.OrderDate)
    )
from Orders o
where Freight > (
    select avg(Freight)
    from Orders o2
    where year(o.OrderDate) = year(o2.OrderDate)
    )
-- podaj wszystkie zamówienia dla których opłata za przesyłkę
-- jest większa od średniej opłaty za przesyłkę w danym roku
use Northwind
select o.OrderID, o.Freight
from Orders o
where o.Freight > (
    select avg(o2.Freight)
    from Orders o2
    where year(o.OrderDate) = year(o2.OrderDate)
    )


-- podaj liste dzieci które w dniu 2001-12-14 nie zwróciły do biblioteki
-- książki "Walking", podaj imie, nazwisko i adres dziecka
use library
select m.firstname, m.lastname, m.member_no,
       a.street, a.city, a.state, a.zip
from juvenile as j
join member as m on j.member_no = m.member_no
join adult a on j.adult_member_no = a.member_no
where m.member_no not in (
    select member_no
    from loanhist
    where title_no = (
        select title_no
        from title
        where title = 'Walking'
        )
        and year(in_date) = 2001 and month(in_date) = 12 and day(in_date) = 14
    )


-- dla każdego produktu podać wartość sprzedaży tego produktu w 1997 roku
-- oraz ilość zamówień, które ten produkt zawierały. Jeżeli produkt nie był zamawiany
-- to wartość powinna wynosić 0
use Northwind
select p.ProductName,
       isnull(sum(od.UnitPrice * od.Quantity * (1 - od.Discount)),0) as 'price',
       isnull(count(od.OrderID),0) as 'count'
from Products p
left join [Order Details] od on p.ProductID = od.ProductID
left join Orders o on od.OrderID = o.OrderID and year(o.OrderDate) = 1997
group by p.ProductName
order by count


-- podaj liczbę zamówień oraz wartość zamówień (uwzględniając opłatę za przesyłkę)
-- złożonych przez każdego klienta w lutym 1997 roku.
-- Jeśli klient nie złożył żadnego zamówienia to wartość powinna wynosić 0
use Northwind
select c.CompanyName,
       isnull(count(o.OrderID),0) as 'count',
       isnull(sum(o.Freight) + (
            select sum(od.UnitPrice * od.Quantity * (1 - od.Discount))
            from Orders o2
            inner join [Order Details] od on o2.OrderID = od.OrderID
            where   year(o2.OrderDate) = 1997
                    and month(o2.OrderDate) = 2
                    and o2.CustomerID = c.CustomerID
            ),0) as 'price'
from Customers c
left join Orders o on c.CustomerID = o.CustomerID and year(o.OrderDate) = 1997 and month(o.OrderDate) = 2
group by c.CompanyName, c.CustomerID
