--  Jaki był najpopularniejszy autor wśród dzieci w Arizonie w 2001 roku?
use library
select top 1 author, count(*) as 'qntty'
from title
inner join loanhist on title.title_no = loanhist.title_no
inner join juvenile on loanhist.member_no = juvenile.member_no
inner join adult on juvenile.adult_member_no = adult.member_no
where state = 'AZ' and year(out_date) = 2001
group by author
order by qntty desc

-- Dla każdego dziecka wybierz jego imię nazwisko, adres, imię i nazwisko rodzica i
-- ilość książek, które oboje przeczytali w 2001
use library;
with table1 as (
    select m.member_no,
           (select count(*)
            from loan l1
            where l1.member_no = m.member_no
            and year(l1.out_date) = 2001)
            +
           (select count(*)
            from loanhist lh
            where lh.member_no = m.member_no
            and year(due_date) = 2001) as loans
    from member m
    group by m.member_no
)
select  m.firstname + ' ' + m.lastname as 'child',
        a.street + ' ' + a.city + ' ' + a.zip as 'address',
        m1.firstname + ' ' + m1.lastname as 'parent',
        t1.loans + (select sum(loans) from table1 t1 where t1.member_no = a.member_no) as 'loans'
from member m
inner join table1 t1 on m.member_no = t1.member_no
inner join juvenile j on m.member_no = j.member_no
inner join adult a on j.adult_member_no = a.member_no
inner join member m1 on a.member_no = m1.member_no

-- Kategorie które w roku 1997 grudzień były obsłużone wyłącznie przez ‘United Package’
use Northwind;
select c.categoryname, s.companyname
from categories c
inner join products p on c.categoryid = p.categoryid
inner join [order details] od on p.productid = od.productid
inner join orders o on od.orderid = o.orderid
inner join shippers s on o.shipvia = s.shipperid
where year(o.orderdate) = 1997 and month(o.orderdate) = 12 and s.companyname = 'United Package'
    and c.categoryname not in (
        select c.categoryname
        from categories c
        inner join products p on c.categoryid = p.categoryid
        inner join [order details] od on p.productid = od.productid
        inner join orders o on od.orderid = o.orderid
        inner join shippers s on o.shipvia = s.shipperid
        where year(o.orderdate) = 1997 and month(o.orderdate) = 12 and s.companyname != 'United Package'
        )

-- v2
use Northwind
select distinct categoryname from categories as C
join products as P on C.CategoryID = P.CategoryID
join [Order Details] as OD on P.ProductID = OD.ProductID
join orders as O on OD.OrderID = O.OrderID
join Shippers as S on O.ShipVia = S.ShipperID
where year(ShippedDate) = 1997 and month(ShippedDate) = 12 and CompanyName = 'United Package'
except -- except zwraca różnicę zbiorów
select distinct categoryname from categories as C
join products as P on C.CategoryID = P.CategoryID
join [Order Details] as OD on P.ProductID = OD.ProductID
join orders as O on OD.OrderID = O.OrderID
join Shippers as S on O.ShipVia = S.ShipperID
where year(ShippedDate) = 1997 and month(ShippedDate) = 12 and CompanyName <> 'United Package'

-- Wybierz klientów, którzy kupili przedmioty wyłącznie z jednej kategorii w marcu 1997 i wypisz nazwę tej kategorii
use Northwind;
with table1 as (
    select c.customerid, categoryname, count(*) as 'qntty'
    from customers c
    inner join orders o on c.customerid = o.customerid
    inner join [order details] od on o.orderid = od.orderid
    inner join products p on od.productid = p.productid
    inner join categories cat on p.categoryid = cat.categoryid
    where year(o.orderdate) = 1997 and month(o.orderdate) = 3
    group by c.customerid, categoryname
)
select customerid, categoryname
from table1 t1
where customerid in (
    select customerid from table1 t2
    where t1.customerid = t2.customerid
    group by customerid
    having count(*) = 1
    )

-- Wybierz dzieci wraz z adresem, które nie wypożyczyły książek w lipcu 2001
-- autorstwa ‘Jane Austin’
use library
select distinct m.firstname + ' ' + m.lastname as 'name',
       a.street + ' ' + a.city + ' ' + a.zip as 'address'
from member m
inner join juvenile j on m.member_no = j.member_no
inner join adult a on j.adult_member_no = a.member_no
where m.member_no not in (
    select m.member_no
    from member m
    inner join loanhist lh on m.member_no = lh.member_no
    inner join title t on lh.title_no = t.title_no
    where author = 'Jane Austin' and month(due_date) = 7 and year(due_date) = 2001
    )

-- Wybierz kategorię, która w danym roku 1997 najwięcej zarobiła, podział na miesiące
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

-- Dane pracownika i najczęstszy dostawca pracowników bez podwładnych
use Northwind;
with table1 as (
    select o.employeeid, o.ShipVia, count(*) as 'qntty'
    from orders o
    group by o.employeeid, o.ShipVia
)
select e.firstname, e.lastname, s.CompanyName, qntty
from employees e
inner join table1 t1 on e.employeeid = t1.employeeid
inner join Shippers s on t1.ShipVia = s.ShipperID
left join employees ee on ee.reportsto = e.employeeid
where qntty = (
    select max(qntty)
    from table1 t2
    where t1.employeeid = t2.employeeid
    group by employeeid
    )
group by e.lastname, e.firstname, s.CompanyName, qntty
having count(ee.employeeid)=0

-- Wybierz tytuły książek, gdzie ilość wypożyczeń książki jest większa od średniej ilości
-- wypożyczeń książek tego samego autora. xD
use library;
with autortytulliczbawypozyczenia as (
    select t.author, t.title, count(*) as 'qntty'
    from loan l
    inner join title t on l.title_no = t.title_no
    group by t.author, t.title
),
srednia as (
    select author, avg(qntty) as 'avg'
    from autortytulliczbawypozyczenia
    group by author
)
select author, title, qntty
from autortytulliczbawypozyczenia
where qntty > (
    select avg
    from srednia s
    where autortytulliczbawypozyczenia.author = s.author
    )
