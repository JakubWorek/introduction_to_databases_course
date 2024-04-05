-- Wyświetl produkt, który przyniósł najmniejszy, ale niezerowy, przychód w 1996 roku.
use Northwind
select top 1 ProductName, sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) as Revenue
from Products p
inner join [Order Details] od on p.ProductID = od.ProductID
inner join Orders o on od.OrderID = o.OrderID
where year(o.OrderDate) = 1996
group by ProductName
having sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) > 0
order by sum(od.UnitPrice * od.Quantity * (1 - od.Discount))

-- Wyświetl wszystkich członków biblioteki (imię i nazwisko, adres)
-- rozróżniając dorosłych i dzieci (dla dorosłych podaj liczbę dzieci),
-- którzy nigdy nie wypożyczyli książki.
use library
select m1.firstname + ' ' + m1.lastname as name,
       a.street + ' ' + a.city + ' ' + a.zip as address,
       'adult' as type,
       count(j.adult_member_no) as children
from member m1
inner join adult a on m1.member_no = a.member_no
left join juvenile j on m1.member_no = j.adult_member_no
where m1.member_no not in (select lh.member_no from loanhist lh)
    and m1.member_no not in (select l.member_no from loan l)
group by m1.firstname + ' ' + m1.lastname,
            a.street + ' ' + a.city + ' ' + a.zip
union
select m2.firstname + ' ' + m2.lastname as name,
       a.street + ' ' + a.city + ' ' + a.zip as address,
       'juvenile' as type,
       0 as children
from member m2
inner join juvenile j on m2.member_no = j.member_no
inner join adult a on j.adult_member_no = a.member_no
where m2.member_no not in (select lh.member_no from loanhist lh)
    and m2.member_no not in (select l.member_no from loan l)
group by m2.firstname + ' ' + m2.lastname,
            a.street + ' ' + a.city + ' ' + a.zip
order by 1,2

-- Wyświetl podsumowanie zamówień (całkowita cena + fracht) obsłużonych
-- przez pracowników w lutym 1997 roku, uwzględnij wszystkich, nawet jeśli suma
-- wyniosła 0.
use Northwind;
with table1 as (
    select  e.EmployeeID, e.FirstName, e.LastName,
            count(o.OrderID) as orders,
            round(sum(od.UnitPrice * od.Quantity * (1 - od.Discount))+sum(o.Freight),2) as price
    from Employees e
    inner join Orders o on e.EmployeeID = o.EmployeeID
    inner join [Order Details] od on o.OrderID = od.OrderID
    where year(o.OrderDate) = 1997 and month(o.OrderDate) = 2
    group by e.EmployeeID, e.FirstName, e.LastName
)
select e.FirstName, e.LastName, isnull(t.orders,0) as orders, isnull(t.price,0) as pirce
from table1 t
right join Employees e on t.EmployeeID = e.EmployeeID
order by 4 desc

-- v2
use Northwind;
select e.FirstName, e.LastName, e.EmployeeID,
        isnull(round(sum(o.Freight) + (
            select round(sum(od.UnitPrice * od.Quantity * (1 - od.Discount)),2)
            from Orders o
            inner join [Order Details] od on o.OrderID = od.OrderID
            where year(o.OrderDate) = 1997 and month(o.OrderDate) = 2
                and o.EmployeeID = e.EmployeeID
            ),2), 0) as price
from Employees e
left join Orders o on e.EmployeeID = o.EmployeeID and year(o.OrderDate) = 1997 and month(o.OrderDate) = 2
--where year(o.OrderDate) = 1997 and month(o.OrderDate) = 2
group by e.FirstName, e.LastName, e.EmployeeID