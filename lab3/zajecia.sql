--1 stara składnia
USE joindb
SELECT buyer_name, s.buyer_id, qty
FROM buyers AS b, sales AS s
WHERE b.buyer_id = s.buyer_id

--2 nowa składnia (lepsza)
USE joindb
SELECT buyer_name, s.buyer_id, qty
FROM buyers AS b INNER JOIN sales AS s
ON b.buyer_id = s.buyer_id

--3
use Northwind
SELECT productname, companyname
FROM products
INNER JOIN suppliers
ON products.supplierid = suppliers.supplierid

--4
SELECT DISTINCT companyname, orderdate
FROM orders
INNER JOIN customers
ON orders.customerid = customers.customerid
WHERE orderdate > ‘3/1/98’

--5
USE joindb
SELECT buyer_name, sales.buyer_id, qty
FROM buyers LEFT OUTER JOIN sales
ON buyers.buyer_id = sales.buyer_id

--6
USE Northwind
SELECT companyname, customers.customerid, orderdate
FROM customers
LEFT OUTER JOIN orders
ON customers.customerid = orders.customerid

-- cross join
use joindb
SELECT buyer_name, qty
FROM buyers
CROSS JOIN sales

--zabawa
use joindb
SELECT buy1.buyer_name AS buyer1, prod.prod_name
,buy2.buyer_name AS buyer2
FROM sales AS a
JOIN sales AS b
ON a.prod_id = b.prod_id
inner join Buyers as buy1 on a.buyer_id = buy1.buyer_id
inner join Buyers as buy2 on b.buyer_id = buy2.buyer_id
inner join Produce as prod on a.prod_id = prod.prod_id
WHERE a.buyer_id > b.buyer_id

-- pokazuje pary pracowników zajmujących to samo stanowisko
use Northwind
SELECT a.employeeid,
       LEFT(a.lastname,10) AS name,
       LEFT(a.title,10) AS title,
       b.employeeid,
       LEFT(b.lastname,10) AS name,
       LEFT(b.title,10) AS title
FROM employees AS a
INNER JOIN employees AS b
ON a.title = b.title
WHERE a.employeeid < b.employeeid


