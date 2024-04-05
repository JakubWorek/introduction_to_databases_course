use Northwind

-- top
select top 5 with ties orderid, productid, quantity
from [order details]
order by quantity desc

-- count
select COUNT (*)
from employees

-- avg
SELECT AVG(unitprice)
FROM products

-- sum
SELECT SUM(quantity)
FROM [order details]
WHERE productid = 1

--rollup
SELECT productid, orderid, SUM(quantity) AS total_quantity FROM orderhist
GROUP BY productid, orderid
WITH ROLLUP
ORDER BY productid, orderid

--rownowaznie rozbijamy
select NULL, NULL, sum(quantity)
from orderhist

select productid, NULL, sum(quantity)
from orderhist
group by productid

select productid, orderid, sum(quantity)
from orderhist
group by productid, orderid

--Ile zamowien bylo zrealizowanych z opuznieniem
select count(*)
from Orders
where ShippedDate > RequiredDate

--Dla każdego pracownika wyswietlic ile zamowien obsluzyl i podac date najszwiezszego zamowienia
select employeeid, count(*), max(OrderDate)
from orders
group by employeeid
order by 2

--Policz ile dzieci urodzilo sie w poszczegolnych latach w poszczegolnych miesiacach
use library
select month(birth_date) as Month, year(birth_date) as Year, count(*) as Quantity
from juvenile
group by month(birth_date), year(birth_date)

--Dla każdego czytelnika ile ma wypozyczonych ksiazek
select member_no, count(*) as ileWypozyczonych
from loan
group by member_no
order by 2 desc




