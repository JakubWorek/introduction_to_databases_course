--  Wypisz wszystkich członków biblioteki z adresami
--  i info czy jest dzieckiem czy nie
--  i ilość wypożyczeń w poszczególnych latach i miesiącach.
use library
select  m.member_no,
        m.firstname + ' ' + m.lastname as name,
        a.street + ' ' + a.city + ' ' + a.zip as address,
        'adult' as type,
        count(*) as loans
from member m
inner join adult a on m.member_no = a.member_no
inner join loan l on m.member_no = l.member_no
group by m.member_no,
        m.firstname + ' ' + m.lastname,
        a.street + ' ' + a.city + ' ' + a.zip
union
select  m.member_no,
        m.firstname + ' ' + m.lastname as name,
        a.street + ' ' + a.city + ' ' + a.zip as address,
        'child' as type,
        count(*) as loans
from member m
inner join juvenile j on m.member_no = j.member_no
inner join adult a on j.adult_member_no = a.member_no
inner join loan l on m.member_no = l.member_no
group by m.member_no,
        m.firstname + ' ' + m.lastname,
        a.street + ' ' + a.city + ' ' + a.zip

-- v2
use library
select  m.member_no,
        m.firstname + ' ' + m.lastname as name,
        a.street + ' ' + a.city + ' ' + a.zip as address,
        'adult' as type,
        year(out_date) as year,
        month(out_date) as month,
        count(*) as loans
from member m
inner join adult a on m.member_no = a.member_no
inner join loanhist l on m.member_no = l.member_no
group by m.member_no,
        m.firstname + ' ' + m.lastname,
        a.street + ' ' + a.city + ' ' + a.zip,
        year(out_date),
        month(out_date)
union
select  m.member_no,
        m.firstname + ' ' + m.lastname as name,
        a.street + ' ' + a.city + ' ' + a.zip as address,
        'child' as type,
        year(out_date) as year,
        month(out_date) as month,
        count(*) as loans
from member m
inner join juvenile j on m.member_no = j.member_no
inner join adult a on j.adult_member_no = a.member_no
inner join loanhist l on m.member_no = l.member_no
group by m.member_no,
        m.firstname + ' ' + m.lastname,
        a.street + ' ' + a.city + ' ' + a.zip,
        year(out_date),
        month(out_date)

-- v3
use library;
with t1 as (
select AM.member_no, AM.firstname,
       AM.lastname,
       city,
       street,
       'Adult' as age,
       year(out_date) as m,
       month(out_date) as y,
       count(*) as cnt
from adult as A
         join member as AM on A.member_no = AM.member_no
         join loanhist as LH on A.member_no = LH.member_no
group by AM.member_no, AM.firstname, AM.lastname, city, street, year(out_date), month(out_date)
union
select JM.member_no, JM.firstname,
       JM.lastname,
       city,
       street,
       'Child' as age,
       year(out_date) as m,
       month(out_date) as y,
       count(*) as cnt
from juvenile as J
         join adult as A on J.adult_member_no = A.member_no
         join member as JM on J.member_no = JM.member_no
         join loanhist as LH on J.member_no = LH.member_no
group by JM.member_no, JM.firstname, JM.lastname, city, street, year(out_date), month(out_date)
) ,
t2 as (select AM.member_no,
               AM.firstname,
               AM.lastname,
               city,
               street,
               'Adult'         as age,
               year(out_date)  as m,
               month(out_date) as y,
               count(*)        as cnt
        from adult as A
                 join member as AM on A.member_no = AM.member_no
                 join loan as LH on A.member_no = LH.member_no
        group by AM.member_no, AM.firstname, AM.lastname, city, street, year(out_date), month(out_date)
        union
        select JM.member_no,
               JM.firstname,
               JM.lastname,
               city,
               street,
               'Child'         as age,
               year(out_date)  as m,
               month(out_date) as y,
               count(*)        as cnt
        from juvenile as J
                 join adult as A on J.adult_member_no = A.member_no
                 join member as JM on J.member_no = JM.member_no
                 join loan as LH on J.member_no = LH.member_no
        group by JM.member_no, JM.firstname, JM.lastname, city, street, year(out_date), month(out_date)
)
select firstname, lastname, city,street,y, m,age, isnull(t1.cnt,0) + isnull((select t2.cnt from t2 where t2.member_no = t1.member_no and t1.m = t2.m and t1.y = t2.y), 0) as 'wypozyczenia' from t1

--  Zamówienia z Freight większym niż AVG danego roku
use Northwind
select  year(o.OrderDate) as year,
        o.Freight as freight,
        (select avg(o1.Freight)
                   from Orders o1
                   where year(o1.OrderDate) = year(o.OrderDate)) as avg
from Orders o
where o.Freight > (select avg(o1.Freight)
                   from Orders o1
                   where year(o1.OrderDate) = year(o.OrderDate))
group by year(o.OrderDate), o.Freight
order by Freight

-- Klienci, którzy nie zamówili nigdy nic z kategorii 'Seafood'
use Northwind
select distinct c.CustomerID
from Customers c
where c.CustomerID not in (select distinct o1.CustomerID
                           from Orders o1
                           inner join [Order Details] od on o1.OrderID = od.OrderID
                           inner join Products p on od.ProductID = p.ProductID
                           inner join Categories c on p.CategoryID = c.CategoryID
                           where c.CategoryName like 'Seafood')

-- Dla każdego klienta najczęściej zamawianą kategorię
use Northwind
select  c.CustomerID,
        c.CompanyName,
        (select top 1 c1.CategoryName
         from Orders o1
         inner join [Order Details] od on o1.OrderID = od.OrderID
         inner join Products p on od.ProductID = p.ProductID
         inner join Categories c1 on p.CategoryID = c1.CategoryID
         where o1.CustomerID = c.CustomerID
         group by c1.CategoryName
         order by count(*) desc) as category
from Customers c
order by c.CustomerID

-- Podział na company, year month i suma freight
use Northwind
select  c.CompanyName,
        year(o.OrderDate) as year,
        month(o.OrderDate) as month,
        sum(o.Freight) as freight
from Customers c
inner join Orders o on c.CustomerID = o.CustomerID
group by c.CompanyName,
        year(o.OrderDate),
        month(o.OrderDate)

-- Wypisać wszystkich czytelników, którzy nigdy nie wypożyczyli książki dane
-- adresowe i podział czy ta osoba jest dzieckiem
use library
select  m.member_no,
        m.firstname + ' ' + m.lastname as name,
        a.street + ' ' + a.city + ' ' + a.zip as address,
        'adult' as type
from member m
inner join adult a on m.member_no = a.member_no
where m.member_no not in (select l.member_no
                          from loan l)
    and m.member_no not in (select lh.member_no
                            from loanhist lh)
union
select  m.member_no,
        m.firstname + ' ' + m.lastname as name,
        a.street + ' ' + a.city + ' ' + a.zip as address,
        'child' as type
from member m
inner join juvenile j on m.member_no = j.member_no
inner join adult a on j.adult_member_no = a.member_no
where m.member_no not in (select l.member_no
                          from loan l)
    and m.member_no not in (select lh.member_no
                            from loanhist lh)
order by name

-- Najczęściej wybierana kategoria w 1997 dla każdego klienta
use Northwind
select  c.CustomerID,
        c.CompanyName,
        (select top 1 c1.CategoryName
         from Orders o1
         inner join [Order Details] od on o1.OrderID = od.OrderID
         inner join Products p on od.ProductID = p.ProductID
         inner join Categories c1 on p.CategoryID = c1.CategoryID
         where o1.CustomerID = c.CustomerID
            and year(o1.OrderDate) = 1997
         group by c1.CategoryName
         order by count(*) desc) as category
from Customers c

-- Dla każdego czytelnika imię nazwisko, suma książek wypożyczony przez
-- tą osobę i jej dzieci, który żyje w Arizona i ma mieć więcej niż 2 dzieci
-- lub kto żyje w Kalifornii i ma mieć więcej niż 3 dzieci
use library;
with table1 as (
    select m.member_no,
           (select count(*)
            from loan l1
            where l1.member_no = m.member_no)
            +
           (select count(*)
            from loanhist lh
            where lh.member_no = m.member_no) as loans
    from member m
    group by m.member_no
)
select m.member_no, m.firstname + ' ' + m.lastname as name,
        t1.loans + (
            select sum(loans)
            from table1 t2
            inner join juvenile j on j.adult_member_no=t2.member_no
            where j.adult_member_no=m.member_no
            )
from table1 t1
inner join member m on t1.member_no = m.member_no
inner join adult a on a.member_no=m.member_no and a.state='AZ'
left join juvenile j on j.adult_member_no=a.member_no
group by m.member_no, m.firstname+' '+m.lastname, a.state, t1.loans
having count(j.adult_member_no)>2
union
select m.member_no, m.firstname + ' ' + m.lastname as name,
        t1.loans + (
            select sum(loans)
            from table1 t3
            inner join juvenile j on j.adult_member_no=t3.member_no
            where j.adult_member_no=m.member_no
            )
from table1 t1
inner join member m on t1.member_no = m.member_no
inner join adult a on a.member_no=m.member_no and a.state='CA'
left join juvenile j on j.adult_member_no=a.member_no
group by m.member_no, m.firstname+' '+m.lastname, a.state, t1.loans
having count(j.adult_member_no)>3

-- v2
use library;
with loans as (
    select m.member_no,
           (select count(*)
            from loan l1
            where l1.member_no = m.member_no)
            +
           (select count(*)
            from loanhist lh
            where lh.member_no = m.member_no) as cnt
    from member m
    group by m.member_no
)
select firstname, lastname, A.member_no,
isnull(LS.cnt, 0) + isnull((select sum(cnt) from loans join juvenile as j2 on j2.member_no = loans.member_no where j2.adult_member_no = A.member_no), 0) from adult as A
join loans as LS on LS.member_no = A.member_no
join member on A.member_no = member.member_no
join juvenile as J on A.member_no = J.adult_member_no
where state = 'AZ' group by firstname, lastname, A.member_no, LS.cnt having count(*) > 2
union
select firstname, lastname, A.member_no,
isnull(LS.cnt, 0) + isnull((select sum(cnt) from loans join juvenile as j2 on j2.member_no = loans.member_no where j2.adult_member_no = A.member_no), 0) from adult as A
join loans as LS on LS.member_no = A.member_no
join member on A.member_no = member.member_no
join juvenile as J on A.member_no = J.adult_member_no
where state = 'CA' group by firstname, lastname, A.member_no, LS.cnt having count(*) > 3