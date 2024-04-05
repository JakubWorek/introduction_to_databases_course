use Northwind

-- 5.1 podzapytania
select e.firstname,
       e.lastname,
       round((select sum(o.freight)
              from orders o
              where o.employeeid = e.employeeid)
              +
             (select sum(od.unitprice * od.quantity * (1-od.discount))
              from [order details] as od
              where od.OrderID in (select o2.OrderID
                                   from orders as o2
                                   where o2.employeeid = e.employeeid)), 2) as total
from employees e
order by 2

-- 5.1 normalnie
select firstname, lastname,
       round(sum(oo.quantity*oo.unitprice*(1-oo.discount))+sum(o.Freight),2) as total
from Employees e
inner join Orders o on e.EmployeeID = o.EmployeeID
inner join [Order Details] oo on o.OrderID = oo.OrderID
group by firstname, lastname, e.EmployeeID
order by 2

-- 5.2 podzapytania
select top 1 e.firstname,
             e.lastname,
             round((select sum(o.freight)
                    from orders o
                    where o.employeeid = e.employeeid and year(o.OrderDate) = 1997) +
                   (select sum(od.unitprice * od.quantity * (1-od.discount))
                    from [order details] as od
                    where od.OrderID in (select o2.OrderID
                                         from orders as o2
                                         where o2.employeeid = e.employeeid and year(o2.orderdate) = 1997)), 2) as total
from employees e
order by total desc

-- 5.2 normalnie
select top 1 e.firstname,
             e.lastname,
             ROUND(SUM(o.freight) + SUM(od.unitprice * od.quantity * (1-od.discount)), 2) as total
from employees e
inner join orders o on e.employeeid = o.employeeid
inner join [order details] as od on od.OrderID = o.OrderID
where YEAR(o.OrderDate) = 1997
group by e.firstname, e.lastname
order by total desc

-- 5.3 podzapytania (osoby z podwładnymi)
select e.firstname,
       e.lastname,
       round((select sum(o.freight)
              from orders o
              where o.employeeid = e.employeeid)
              +
             (select sum(od.unitprice * od.quantity * (1-od.discount))
              from [order details] as od
              where od.OrderID in (select o2.OrderID
                                   from orders as o2
                                   where o2.employeeid = e.employeeid)), 2) as total
from employees e
where e.employeeid in (select e2.reportsTo
                       from employees as e2
                       where e2.reportsTo is not null)

-- 5.3 podzapytania (osoby bez podwładnych)
select e.firstname,
       e.lastname,
       round((select sum(o.freight)
              from orders o
              where o.employeeid = e.employeeid)
              +
             (select sum(od.unitprice * od.quantity * (1-od.discount))
              from [order details] as od
              where od.OrderID in (select o2.OrderID
                                   from orders as o2
                                   where o2.employeeid = e.employeeid)), 2) as total
from employees e
where e.employeeid not in (select e2.reportsTo
                       from employees as e2
                       where e2.reportsTo is not null)

-- 5.4 podzapytania (osoby z podwładnymi)
select e.firstname,
       e.lastname,
       round((select sum(o.freight)
              from orders o
              where o.employeeid = e.employeeid)
              +
             (select sum(od.unitprice * od.quantity * (1-od.discount))
              from [order details] as od
              where od.OrderID in (select o2.OrderID
                                   from orders as o2
                                   where o2.employeeid = e.employeeid)), 2) as total,
      (select max(o3.orderdate)
       from orders as o3
       where o3.employeeid = e.employeeid) as lastorderdate
from employees e
where e.employeeid in (select e2.reportsTo
                       from employees as e2
                       where e2.reportsTo is not null)

-- 5.4 podzapytania (osoby bez podwładnych)
select e.firstname,
       e.lastname,
       round((select sum(o.freight)
              from orders o
              where o.employeeid = e.employeeid)
              +
             (select sum(od.unitprice * od.quantity * (1-od.discount))
              from [order details] as od
              where od.OrderID in (select o2.OrderID
                                   from orders as o2
                                   where o2.employeeid = e.employeeid)), 2) as total,
      (select max(o3.orderdate)
       from orders as o3
       where o3.employeeid = e.employeeid) as lastorderdate
from employees e
where e.employeeid not in (select e2.reportsTo
                       from employees as e2
                       where e2.reportsTo is not null)


