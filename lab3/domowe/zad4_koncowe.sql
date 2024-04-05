use Northwind

--4.1.1 ale to tylko pracownicy co mają podwładnych
select distinct e.firstname, e.lastname, round(sum(oo.quantity*oo.unitprice*(1-discount)),2) as sum
from employees e
inner join employees ee on ee.reportsto=e.EmployeeID
inner join orders o on o.EmployeeID=e.EmployeeID
inner join [Order Details] oo on oo.OrderID=o.OrderID
group by e.EmployeeID, e.firstname, e.lastname, ee.EmployeeID, ee.FirstName, ee.LastName

--4.1.2 ale to tylko pracownicy bez podwładnych
select e.firstname, e.lastname, round(sum(oo.quantity*oo.unitprice*(1-discount)),2) as sum
from employees e
left join employees ee on ee.reportsto=e.EmployeeID
inner join orders o on o.EmployeeID=e.EmployeeID
inner join [Order Details] oo on oo.OrderID=o.OrderID
group by e.EmployeeID, e.firstname, e.lastname
having count(ee.employeeid)=0

--sprawdzenie
select firstname, lastname, round(sum(oo.quantity*oo.unitprice*(1-discount)),2) as value
from employees e
inner join orders o on o.EmployeeID=e.EmployeeID
inner join [Order Details] oo on o.OrderID = oo.OrderID
group by e.EmployeeID, firstname, lastname
order by count(o.orderid) desc