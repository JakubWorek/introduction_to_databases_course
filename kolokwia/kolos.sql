-- zadanie 1
-- klienci obsługiwani tylko przez jednego pracownika
use Northwind;
with table1 as (
    select c.CustomerID as 'klient'
    from customers c
    inner join orders o on c.CustomerID = o.CustomerID
    inner join Employees e on o.EmployeeID = e.EmployeeID
    group by c.CustomerID
    having count(distinct e.EmployeeID) = 1
)
select t.klient, cc.CompanyName,
       o.EmployeeID, e.FirstName, e.LastName,
       e.Address + ' ' + e.City as 'Address', e.HomePhone
from table1 t
inner join Customers cc on t.klient = cc.CustomerID
inner join Orders o on t.klient = o.CustomerID
inner join Employees e on o.EmployeeID = e.EmployeeID

-- zadanie 2
-- tytuły których liczba wypozyczen była większa od średniej dla tego samego autora
use library;
with autortytulliczbawypozyczenia as (
    select t.author, t.title, count(*) as 'qntty'
    from loanhist l
    inner join title t on l.title_no = t.title_no
    group by t.author, t.title
),
srednia as (
    select author, avg(qntty) as 'avg'
    from autortytulliczbawypozyczenia
    group by author
)
select title, author, qntty
from autortytulliczbawypozyczenia
where qntty > (
    select avg
    from srednia s
    where autortytulliczbawypozyczenia.author = s.author
    )

-- zadanie 3
-- dla kazdego pracownika podaj nazwe dostawcy którego produkty najczęściej sprzedawał,
-- interesują nas wyłącznie pracownicy bez podwładnych
use Northwind;
select e.EmployeeID, s.ShipperID, count(OrderID) as 'ileDostaw'
from Employees e
inner join orders o on e.EmployeeID = o.EmployeeID
inner join shippers s on o.ShipVia = s.ShipperID
group by e.EmployeeID, s.ShipperID
order by 1,2
